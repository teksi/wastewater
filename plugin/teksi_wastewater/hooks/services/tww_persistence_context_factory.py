from __future__ import annotations

import logging
from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Protocol

from sqlalchemy.orm import Session

from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.models.review import (
    DiffReviewJob,
)
from teksi_hooks.parser.model_mapping_parser import (
    ModelMappingParser,
)

from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from teksi_wastewater.hooks.adapters.tww_implicit_model_mapping_adapter import (
    TwwImplicitModelMappingAdapter,
)
from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
)


class QuarantineClassesFactory(
    Protocol,
):
    """
    Reconstruct ORM classes for an existing quarantine schema.
    """

    def __call__(
        self,
        *,
        source_model: str,
        model_group: str,
        model_language: str,
        import_schema: str,
    ) -> Any:
        """
        Return ORM classes without recreating the quarantine schema.
        """

        ...


class QuarantineSessionFactory(
    Protocol,
):
    """
    Open a SQLAlchemy session for an existing quarantine schema.
    """

    def __call__(
        self,
        *,
        import_schema: str,
    ) -> Session:
        """
        Return a new caller-owned quarantine session.
        """

        ...


@dataclass(
    slots=True,
)
class TwwPersistenceSourceContext:
    """
    Runtime dependencies for persisting one retained quarantine source.

    Contexts are returned in persistence order: base first and incremental
    second.
    """

    source_role: str
    import_schema: str
    source_model: str
    mapping_model_id: str
    model_language: str
    model_group: str
    quarantine_classes: Any
    quarantine_session: Session
    model_mapping: EffectiveModelMappingCapability


@dataclass(
    slots=True,
)
class TwwPersistenceContextFactory:
    """
    Reconstruct persistence contexts from persisted diff-job metadata.

    ORM class and session construction are supplied by the plugin composition
    layer. This service does not recreate or reimport quarantine schemas.
    """

    connection_factory: TwwDatabaseConnectionFactory

    model_config_dir: Path

    quarantine_classes_factory: QuarantineClassesFactory

    quarantine_session_factory: QuarantineSessionFactory

    logger: logging.Logger

    def source_contexts(
        self,
        *,
        job: DiffReviewJob,
    ) -> tuple[
        TwwPersistenceSourceContext,
        ...,
    ]:
        """
        Build base and incremental contexts in persistence order.
        """

        contexts: list[
            TwwPersistenceSourceContext,
        ] = []

        try:
            for source_role in (
                "base",
                "incremental",
            ):
                descriptor = self._source_descriptor(
                    job=job,
                    source_role=source_role,
                )

                if descriptor is None:
                    continue

                contexts.append(
                    self._source_context(
                        descriptor=descriptor,
                    )
                )

        except Exception:
            self.close_source_contexts(
                source_contexts=tuple(
                    contexts,
                ),
            )

            raise

        if not contexts:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(
                    "the job contains no retained source "
                    "contexts."
                ),
            )

        return tuple(
            contexts,
        )

    def close_source_contexts(
        self,
        *,
        source_contexts: tuple[
            TwwPersistenceSourceContext,
            ...,
        ],
    ) -> None:
        """
        Roll back unfinished transactions and close all source sessions.
        """

        for source_context in reversed(
            source_contexts,
        ):
            session = source_context.quarantine_session

            try:
                if session.in_transaction():
                    session.rollback()

            except Exception:
                self.logger.exception(
                    "Could not roll back quarantine session for "
                    "source role %r and schema %r.",
                    source_context.source_role,
                    source_context.import_schema,
                )

            try:
                session.close()

            except Exception:
                self.logger.exception(
                    "Could not close quarantine session for "
                    "source role %r and schema %r.",
                    source_context.source_role,
                    source_context.import_schema,
                )

    def _source_descriptor(
        self,
        *,
        job: DiffReviewJob,
        source_role: str,
    ) -> dict[
        str,
        str,
    ] | None:
        """
        Return one persisted source descriptor.
        """

        metadata = job.metadata

        values: dict[
            str,
            Any,
        ] = {
            "source_role": source_role,
            "import_schema": metadata.get(
                f"{source_role}_import_schema",
            ),
            "source_model": metadata.get(
                f"{source_role}_source_model",
            ),
            "mapping_model_id": metadata.get(
                f"{source_role}_mapping_model_id",
            ),
            "model_language": metadata.get(
                f"{source_role}_model_language",
            ),
            "model_group": metadata.get(
                f"{source_role}_model_group",
            ),
        }

        source_values = tuple(
            value
            for key, value in values.items()
            if key != "source_role"
        )

        if all(
            value in (
                None,
                "",
            )
            for value in source_values
        ):
            return None

        missing_keys = tuple(
            key
            for key, value in values.items()
            if (
                not isinstance(
                    value,
                    str,
                )
                or not value.strip()
            )
        )

        if missing_keys:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(
                    "incomplete persisted metadata for "
                    f"{source_role!r} source. Missing or invalid "
                    f"fields: {missing_keys!r}."
                ),
            )

        return {
            key: value.strip()
            for key, value in values.items()
        }

    def _source_context(
        self,
        *,
        descriptor: Mapping[
            str,
            str,
        ],
    ) -> TwwPersistenceSourceContext:
        """
        Build one runtime source context.
        """

        import_schema = descriptor[
            "import_schema"
        ]

        model_mapping = self._effective_model(
            mapping_model_id=descriptor[
                "mapping_model_id"
            ],
            import_schema=import_schema,
            language=descriptor[
                "model_language"
            ],
        )

        quarantine_classes = self.quarantine_classes_factory(
            source_model=descriptor[
                "source_model"
            ],
            model_group=descriptor[
                "model_group"
            ],
            model_language=descriptor[
                "model_language"
            ],
            import_schema=import_schema,
        )

        quarantine_session = self.quarantine_session_factory(
            import_schema=import_schema,
        )

        return TwwPersistenceSourceContext(
            source_role=descriptor[
                "source_role"
            ],
            import_schema=import_schema,
            source_model=descriptor[
                "source_model"
            ],
            mapping_model_id=descriptor[
                "mapping_model_id"
            ],
            model_language=descriptor[
                "model_language"
            ],
            model_group=descriptor[
                "model_group"
            ],
            quarantine_classes=quarantine_classes,
            quarantine_session=quarantine_session,
            model_mapping=model_mapping,
        )

    def _effective_model(
        self,
        *,
        mapping_model_id: str,
        import_schema: str,
        language: str,
    ) -> EffectiveModelMappingCapability:
        """
        Rebuild the effective mapping for one retained source.
        """

        explicit_mapping = (
            ModelMappingParser().parse_file(
                self.model_config_dir
                / "explicit_mapping.yaml",
                model_id=mapping_model_id,
            )
        )

        explicit_capability = (
            ModelMappingCapability(
                mapping=explicit_mapping,
            )
        )

        implicit_capability = (
            TwwImplicitModelMappingAdapter(
                connection_factory=(
                    self.connection_factory
                ),
                import_schema=import_schema,
                language=language,
            )
        )
        for candidate_class_id in (
            "GepMassnahme",
            "gepmassnahme",
        ):
            class_mapping = explicit_mapping.classes.get(
                candidate_class_id,
            )

            if class_mapping is None:
                continue

            self.logger.info(
                "Explicit identity mapping for class %r: %r."
                "self.model_config_dir: %r",
                candidate_class_id,
                {
                    target_class_id: {
                        "source_attribute": (
                            identity.source_attribute
                        ),
                        "canonical_attribute": (
                            identity.canonical_attribute
                        ),
                    }
                    for (
                        target_class_id,
                        identity,
                    ) in class_mapping.identities.items()
                },
                self.model_config_dir,
            )

        return (
            EffectiveModelMappingCapability(
                explicit_mapping=(
                    explicit_capability
                ),
                implicit_mapping=(
                    implicit_capability
                ),
            )
        )