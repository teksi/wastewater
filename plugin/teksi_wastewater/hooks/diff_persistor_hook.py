from __future__ import annotations

from pathlib import Path
from typing import Any
from collections.abc import Mapping

from sqlalchemy.orm import Session
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.hook import (
    HookBase,
    HookContext,
    HookMetadata,
)
from teksi_hooks.models.review import (
    DiffReviewJob,
)
from teksi_hooks.parser.validation_parser import (
    ValidationParser,
)
from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobStateError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)
from teksi_wastewater.hooks.services.tww_review_application_factory import (
    create_review_application_service,
)


class Hook(
    HookBase,
):
    """
    Persist one accepted TWW diff review job.

    A combined baseline and incremental review remains one review job. Its
    retained source schemas are persisted as separate ordered phases:

    1. baseline;
    2. incremental.

    The incremental phase therefore wins on overlapping source values.
    """

    required_capabilities = frozenset(
        {
            DatabaseConnectionFactory,
        }
    )

    @property
    def metadata(
        self,
    ) -> HookMetadata:
        return HookMetadata(
            name="Persist TWW Diff Review Job",
            description=(
                "Applies one accepted TWW diff review job from "
                "its retained quarantine schemas to the live "
                "TWW database."
            ),
        )

    def run_hook(
        self,
        context: HookContext,
    ) -> None:
        """
        Persist one accepted review job.
        """

        context.logger.info("Starting TWW diff persistor hook.")

        connection_factory = context.capability(
            DatabaseConnectionFactory,
        )

        if not isinstance(
            connection_factory,
            TwwDatabaseConnectionFactory,
        ):
            raise TypeError(
                "The TWW diff persistor hook requires a " "TwwDatabaseConnectionFactory."
            )

        job_id = self._required_string(
            parameters=context.parameters,
            key="job_id",
        )

        model_config_dir = self._model_config_dir()

        validation_definition = ValidationParser().parse_file(
            model_config_dir / "validations.yaml",
        )

        diff_schema_service = TwwDiffSchemaService(
            connection_factory=connection_factory,
        )

        job = diff_schema_service.require_review_job(
            job_id=job_id,
            include_features=False,
        )

        self._assert_job_can_be_persisted(
            job=job,
        )

        application_service = create_review_application_service(
            connection_factory=connection_factory,
            diff_schema_service=diff_schema_service,
            model_config_dir=model_config_dir,
            validation_definition=validation_definition,
            logger=context.logger,
        )

        persistence_result = application_service.apply_job(
            job_id=job_id,
        )

        if persistence_result.job_status != "applied":
            raise RuntimeError(
                "The reviewed import completed without reaching "
                f"the 'applied' state. Job {job_id!r} has status "
                f"{persistence_result.job_status!r}."
            )

        context.logger.info(
            "Applied reviewed tww_diff job %r with %s review "
            "features, of which %s were permission-restricted.",
            persistence_result.job_id,
            persistence_result.review_feature_count,
            persistence_result.restricted_feature_count,
        )

    def _assert_job_can_be_persisted(
        self,
        *,
        job: DiffReviewJob,
    ) -> None:
        """
        Require an accepted, validated review job.
        """

        if job.job_status != "accepted":
            raise DiffJobStateError(
                job_id=job.job_id,
                expected_status="accepted",
                actual_status=job.job_status,
            )

        job_type = job.metadata.get(
            "job_type",
            "review",
        )

        if job_type != "review":
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=("only review jobs can be persisted by this " "hook."),
            )

        if not job.validation_success:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=("source validation was not successful."),
            )

    def _quarantine_classes(
        self,
        *,
        source_model: str,
        model_group: str,
        model_language: str,
        import_schema: str,
    ) -> Any:
        """
        Return reflected ORM classes for one retained quarantine schema.

        Connect this method to the same quarantine-model factory used by the
        diff creator. It must reflect the existing schema and must not recreate
        or reimport it.
        """

        raise NotImplementedError(
            "Connect _quarantine_classes() to the existing " "quarantine-model factory."
        )

    def _quarantine_session(
        self,
        *,
        connection_factory: TwwDatabaseConnectionFactory,
        import_schema: str,
    ) -> Session:
        """
        Open a SQLAlchemy session for one retained quarantine schema.

        Connect this method to the existing SQLAlchemy session factory. The
        returned session must target the existing import schema. It must not
        recreate the schema.
        """

        raise NotImplementedError(
            "Connect _quarantine_session() to the existing "
            "quarantine SQLAlchemy session factory."
        )

    def _job_metadata_string(
        self,
        *,
        job: DiffReviewJob,
        key: str,
    ) -> str:
        """
        Return one required non-empty string from job metadata.
        """

        value = job.metadata.get(
            key,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(f"the review job has no valid {key!r} " "metadata value."),
            )

        return value.strip()

    def _required_string(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> str:
        """
        Return one required non-empty hook parameter.
        """

        value = parameters.get(
            key,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(f"Parameter {key!r} must be a non-empty string.")

        return value.strip()

    def _model_config_dir(
        self,
    ) -> Path:
        """
        Return immutable model configuration shipped with the hook.
        """

        path = (
            Path(
                __file__,
            )
            .resolve()
            .parent
            / "config"
            / "model"
        )

        if not path.is_dir():
            raise RuntimeError("Model configuration directory does not exist: " f"{path}")

        return path
