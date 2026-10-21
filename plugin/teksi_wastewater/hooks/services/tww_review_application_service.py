from __future__ import annotations

from dataclasses import dataclass

from teksi_hooks.models.validation import (
    ValidationDefinition,
)
from teksi_wastewater.hooks.adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)
from teksi_wastewater.hooks.exceptions import (
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

    def apply_job(
        self,
        *,
        job_id: str,
    ) -> TwwJobPersistenceResult:
        """
        Reconstruct and apply one accepted review job.
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
                reason=("source validation was not successful."),
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
                reason=("required job metadata 'live_schema' is " "missing or invalid."),
            )

        canonical_metadata = self.canonical_model_adapter.canonical_model()

        source_contexts = ()

        try:
            source_contexts = self.persistence_context_factory.source_contexts(
                job=job,
            )

            return self.persistence_service.persist_job(
                job=job,
                live_schema=live_schema.strip(),
                source_contexts=source_contexts,
                canonical_metadata=canonical_metadata,
                validation_definition=(self.validation_definition),
            )

        finally:
            self.persistence_context_factory.close_source_contexts(
                source_contexts=source_contexts,
            )
