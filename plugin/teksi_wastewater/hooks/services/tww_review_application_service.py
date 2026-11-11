
from __future__ import annotations

from dataclasses import dataclass

from teksi_hooks.models.validation import (
    ValidationDefinition,
)

from teksi_wastewater.hooks.adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)
from teksi_wastewater.hooks.adapters.tww_session_manager import (
    TwwSessionManager,
)
from teksi_hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobStateError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
    TwwJobPersistenceResult,
)
from teksi_wastewater.hooks.services.tww_persistence_context_factory import (
    TwwPersistenceContextFactory,
)
from teksi_wastewater.hooks.services.tww_review_persistence_service import (
    TwwReviewPersistenceService,
)


@dataclass(
    slots=True,
)
class TwwReviewApplicationService:
    """
    Apply one accepted persisted review job.

    This is the shared application entry point for the creator hook's
    auto-apply path and the dedicated persistor hook.
    """

    diff_schema_service: TwwDiffSchemaService

    persistence_context_factory: TwwPersistenceContextFactory

    persistence_service: TwwReviewPersistenceService

    canonical_model_adapter: TwwCanonicalModelAdapter

    validation_definition: ValidationDefinition

    session_manager: TwwSessionManager

    def apply_job(
        self,
        *,
        job_id: str,
    ) -> TwwJobPersistenceResult:
        """
        Reconstruct and apply one accepted review job.

        This service owns the persistence session scope. All downstream services
        borrow the sessions contained in that scope and must not commit, roll back
        or close them.

        Jobs containing an incremental source receive a dedicated incremental
        quarantine session in addition to the base quarantine and live sessions.
        """
        job = self.diff_schema_service.require_review_job(
            job_id=job_id,
            include_features=False,
        )

        if job.job_status != "accepted":
            raise DiffJobStateError(
                job_id=job_id,
                expected_status="accepted",
                actual_status=job.job_status,
            )

        if not job.validation_success:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    "source validation was not successful."
                ),
            )

        live_schema = job.metadata.get(
            "live_schema",
        )

        if (
            not isinstance(
                live_schema,
                str,
            )
            or not live_schema.strip()
        ):
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    "required job metadata 'live_schema' is "
                    "missing or invalid."
                ),
            )

        canonical_metadata = (
            self.canonical_model_adapter
            .canonical_model()
        )

        has_incremental_source = (
            self._has_incremental_source(
                job,
            )
        )

        with self.session_manager.persistence_scope(
            include_incremental=(
                has_incremental_source
            ),
        ) as session_context:
            source_contexts = (
                self.persistence_context_factory
                .source_contexts(
                    job=job,
                    session_context=session_context,
                )
            )

            return self.persistence_service.persist_job(
                job=job,
                live_schema=live_schema.strip(),
                source_contexts=source_contexts,
                canonical_metadata=canonical_metadata,
                validation_definition=(
                    self.validation_definition
                ),
                session_context=session_context,
            )

    def _has_incremental_source(
        self,
        job,
    ) -> bool:
        """
        Return whether one review job contains an incremental source.
        """
        incremental_schema = job.metadata.get(
            "incremental_import_schema",
        )

        return (
            isinstance(
                incremental_schema,
                str,
            )
            and bool(
                incremental_schema.strip()
            )
        )