# teksi_wastewater/hooks/services/tww_review_persistence_service.py

from __future__ import annotations

from dataclasses import dataclass
import logging
from pathlib import Path
from typing import Protocol

from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobPersistenceError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    DiffJobCounts,
    TwwDiffSchemaService,
    TwwInterlisPersistenceAdapter,
    TwwJobPersistenceResult,
)


logger = logging.getLogger(
    __name__,
)


class TwwQuarantineBackupService(
    Protocol,
):
    def create_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> Path:
        ...

    def restore_backup(
        self,
        *,
        backup_path: Path,
        import_schema: str,
    ) -> None:
        ...
    
    def delete_backup(
        self,
        *,
        backup_path: Path,
    ) -> None:
        ...




@dataclass(
    slots=True,
)
class TwwReviewPersistenceService:
    """
    Apply one accepted tww_diff review job.

    Review acceptance remains separate from persistence execution:

    pending -> accepted
    accepted -> applying
    applying -> applied or failed
    """

    diff_schema_service: TwwDiffSchemaService
    persistence_adapter: TwwInterlisPersistenceAdapter

    def persist_job(
        self,
        *,
        job_id: str,
        live_schema: str | None = None,
    ) -> TwwJobPersistenceResult:
        """
        Apply one accepted review job to the live schema.
        """

        job = self.diff_schema_service.require_review_job(
            job_id=job_id,
            include_features=False,
        )

        self._assert_application_eligibility(
            job_id=job_id,
            job_status=job.job_status,
            validation_success=job.validation_success,
        )

        counts = self.diff_schema_service.job_counts(
            job_id=job_id,
        )

        self._assert_review_counts(
            job_id=job_id,
            counts=counts,
        )

        import_schema = self._required_metadata_value(
            job_id=job_id,
            metadata=job.metadata,
            key="import_schema",
        )

        source_model = self._required_metadata_value(
            job_id=job_id,
            metadata=job.metadata,
            key="source_model",
        )

        resolved_live_schema = (
            live_schema
            or self._required_metadata_value(
                job_id=job_id,
                metadata=job.metadata,
                key="live_schema",
            )
        )

        self.diff_schema_service.acquire_job_for_application(
            job_id=job_id,
        )

        try:
            preparation_result = self.quarantine_preparer.prepare(
                job_id=job_id,
                import_schema=import_schema,
            )

            persistence_result = (
                self.persistence_adapter.persist_quarantine(
                    import_schema=import_schema,
                    live_schema=resolved_live_schema,
                    source_model=source_model,
                )
            )

            if not persistence_result.committed:
                raise DiffJobPersistenceError(
                    job_id=job_id,
                    phase="applying",
                    message=(
                        "The quarantine-to-live importer returned "
                        "without confirming its live transaction commit."
                    ),
                )

        except Exception as exception:
            self._mark_failed(
                job_id=job_id,
                exception=exception,
            )

            raise

        self.diff_schema_service.mark_job_applied(
            job_id=job_id,
        )

        logger.info(
            "Applied diff review job %r with %s review features.",
            job_id,
            counts.total_count,
        )

        return TwwJobPersistenceResult(
            job_id=job_id,
            previous_status="accepted",
            job_status="applied",
            review_feature_count=counts.total_count,
            rejected_feature_count=counts.rejected_count,
            import_schema=import_schema,
            live_schema=resolved_live_schema,
            source_model=source_model,
            quarantine_preparation=preparation_result,
            interlis_persistence=persistence_result,
        )

    def _assert_application_eligibility(
        self,
        *,
        job_id: str,
        job_status: str,
        validation_success: bool,
    ) -> None:
        """
        Validate application-level job eligibility.
        """

        if job_status != "accepted":
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"the job has status {job_status!r}; "
                    "expected 'accepted'."
                ),
            )

        if not validation_success:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    "source validation was not successful."
                ),
            )

    def _assert_review_counts(
        self,
        *,
        job_id: str,
        counts: DiffJobCounts,
    ) -> None:
        """
        Validate the persisted review-row set.
        """

        if counts.rejected_count:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"{counts.rejected_count} of "
                    f"{counts.total_count} review rows contain "
                    "blocking permission or validation findings."
                ),
            )

        operation_count = (
            counts.created_count
            + counts.altered_count
            + counts.deleted_count
        )

        if operation_count != counts.total_count:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"{counts.total_count - operation_count} review "
                    "rows do not identify a persistence operation."
                ),
            )

    def _required_metadata_value(
        self,
        *,
        job_id: str,
        metadata,
        key: str,
    ) -> str:
        """
        Return one required non-empty string metadata value.
        """

        value = metadata.get(
            key,
        )

        if not isinstance(
            value,
            str,
        ) or not value.strip():
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"required job metadata {key!r} is missing."
                ),
            )

        return value

    def _mark_failed(
        self,
        *,
        job_id: str,
        exception: Exception,
    ) -> None:
        """
        Record an application failure without hiding the original error.
        """

        try:
            self.diff_schema_service.mark_job_failed(
                job_id=job_id,
                expected_status="applying",
                phase="applying",
                error_type=type(
                    exception,
                ).__name__,
                message=str(
                    exception,
                ),
            )
        except Exception:
            logger.exception(
                "Could not mark diff review job %r as failed.",
                job_id,
            )