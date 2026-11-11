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
from teksi_wastewater.hooks.adapters.tww_implicit_model_mapping_adapter import (
    TwwImplicitModelMappingAdapter,
)
from teksi_hooks.exceptions import (
    DiffJobEligibilityError,
)
from teksi_wastewater.hooks.adapters.tww_session_manager import (
    TwwSessionContext,
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

    The enclosing persistence workflow owns the quarantine and live sessions.
    This factory borrows those sessions while reconstructing source contexts.

    Generated quarantine ORM classes contain schema-qualified table metadata.
    Therefore, one quarantine session may query retained base and incremental
    source schemas through their respective ORM class collections.

    Implicit model-mapping discovery uses the same quarantine and live
    sessions as the subsequent persistence workflow. The factory does not:

    - create database sessions;
    - commit or roll back transactions;
    - close database sessions;
    - recreate quarantine schemas;
    - reimport source data.
    """

    model_config_dir: Path

    quarantine_classes_factory: (
        QuarantineClassesFactory
    )

    logger: logging.Logger

    def source_contexts(
        self,
        *,
        job: DiffReviewJob,
        session_context: TwwSessionContext,
    ) -> tuple[
        TwwPersistenceSourceContext,
        ...,
    ]:
        """
        Build base and incremental source contexts in persistence order.

        Both sessions are borrowed from ``session_context``. The caller
        remains responsible for transaction completion and session closure.
        """

        self._assert_session_context(
            session_context,
        )

        contexts: list[
            TwwPersistenceSourceContext,
        ] = []

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
                    session_context=session_context,
                )
            )

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
        Return one complete persisted source descriptor.

        A completely absent source descriptor returns ``None``. A partially
        populated descriptor is rejected.
        """

        if source_role not in {
            "base",
            "incremental",
        }:
            raise ValueError(
                "source_role must be either 'base' or "
                f"'incremental', got {source_role!r}."
            )

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

        descriptor_values = tuple(
            value
            for (
                key,
                value,
            ) in values.items()
            if key != "source_role"
        )

        if all(
            value in (
                None,
                "",
            )
            for value in descriptor_values
        ):
            return None

        missing_keys = tuple(
            key
            for (
                key,
                value,
            ) in values.items()
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
            for (
                key,
                value,
            ) in values.items()
        }

    def _source_context(
        self,
        *,
        descriptor: Mapping[
            str,
            str,
        ],
        session_context: TwwSessionContext,
    ) -> TwwPersistenceSourceContext:
        """
        Build one runtime source context using borrowed workflow sessions.
        """

        import_schema = descriptor[
            "import_schema"
        ]

        quarantine_classes = (
            self.quarantine_classes_factory(
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
        )

        model_mapping = self._effective_model(
            mapping_model_id=descriptor[
                "mapping_model_id"
            ],
            import_schema=import_schema,
            language=descriptor[
                "model_language"
            ],
            quarantine_session=(
                session_context.quarantine
            ),
            live_session=session_context.live,
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
            quarantine_session=(
                session_context.quarantine
            ),
            model_mapping=model_mapping,
        )

    def _effective_model(
        self,
        *,
        mapping_model_id: str,
        import_schema: str,
        language: str,
        quarantine_session: Session,
        live_session: Session,
    ) -> EffectiveModelMappingCapability:
        """
        Rebuild the effective mapping for one retained source.

        Explicit mapping metadata is loaded from configuration. Implicit
        mapping discovery uses the sessions belonging to the active
        persistence workflow.
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
                import_schema=import_schema,
                language=language,
                quarantine_session=(
                    quarantine_session
                ),
                live_session=live_session,
            )
        )

        return EffectiveModelMappingCapability.load(
            explicit_mapping=explicit_capability,
            implicit_mapping=implicit_capability,
        )

    def _assert_session_context(
        self,
        session_context: TwwSessionContext,
    ) -> None:
        """
        Require an initialized pair of borrowed workflow sessions.
        """

        if session_context.quarantine is None:
            raise RuntimeError(
                "The persistence session context has no "
                "quarantine session."
            )

        if session_context.live is None:
            raise RuntimeError(
                "The persistence session context has no live "
                "session."
            )