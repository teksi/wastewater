# teksi_wastewater/hooks/services/tww_review_persistence_service.py

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
import logging
from pathlib import Path
from typing import Any, Protocol

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
from teksi_wastewater.hooks.services.tww_quarantine_persistence_preparer import (
    TwwQuarantinePersistencePreparer,
)


logger = logging.getLogger(
    __name__,
)


class TwwQuarantineBackupService(
    Protocol,
):
    """
    Create, restore and delete quarantine backups.
    """

    def create_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> Path:
        """
        Create a backup before destructive quarantine preparation.
        """

        ...

    def restore_backup(
        self,
        *,
        backup_path: Path,
        import_schema: str,
    ) -> None:
        """
        Restore quarantine from a previously created backup.
        """

        ...

    def delete_backup(
        self,
        *,
        backup_path: Path,
    ) -> None:
        """
        Delete a quarantine backup.
        """

        ...


@dataclass(
    slots=True,
)
class TwwReviewPersistenceService:
    """
    Apply one accepted tww_diff review job.

    Lifecycle:

    pending -> accepted
    accepted -> applying
    applying -> applied or failed

    Quarantine is backed up before destructive permission filtering.
    The backup is restored when preparation or persistence fails and is
    deleted after successful application.
    """

    diff_schema_service: TwwDiffSchemaService

    quarantine_preparer: TwwQuarantinePersistencePreparer

    backup_service: TwwQuarantineBackupService

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

        backup_path: Path | None = None

        try:
            backup_path = self.backup_service.create_backup(
                job_id=job_id,
                import_schema=import_schema,
            )

            self.diff_schema_service.set_backup_path(
                job_id=job_id,
                expected_status="applying",
                backup_path=str(
                    backup_path,
                ),
            )

            self.quarantine_preparer.prepare(
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

            self.diff_schema_service.mark_job_applied(
                job_id=job_id,
            )

        except Exception as exception:
            if backup_path is not None:
                self._restore_backup(
                    job_id=job_id,
                    import_schema=import_schema,
                    backup_path=backup_path,
                )

            self._mark_failed(
                job_id=job_id,
                exception=exception,
            )

            raise

        self._delete_applied_backup(
            job_id=job_id,
            backup_path=backup_path,
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
        Validate job-level persistence eligibility.
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

        Rejected rows represent changes that cannot be prepared safely for
        persistence. Permission-restricted attributes that can be neutralized
        in quarantine must not be included in rejected_count.
        """

        if counts.rejected_count:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"{counts.rejected_count} of "
                    f"{counts.total_count} review rows contain "
                    "blocking findings."
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
                    "rows do not identify exactly one persistence "
                    "operation."
                ),
            )

    def _required_metadata_value(
        self,
        *,
        job_id: str,
        metadata: Mapping[
            str,
            Any,
        ],
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

    def _restore_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
        backup_path: Path,
    ) -> None:
        """
        Restore quarantine after preparation or persistence failure.

        Restoration and cleanup failures are logged without hiding the
        original persistence exception.
        """

        try:
            self.backup_service.restore_backup(
                backup_path=backup_path,
                import_schema=import_schema,
            )
        except Exception:
            logger.exception(
                "Could not restore quarantine backup %s for "
                "diff review job %r.",
                backup_path,
                job_id,
            )

            return

        try:
            self.backup_service.delete_backup(
                backup_path=backup_path,
            )
        except Exception:
            logger.exception(
                "Could not delete restored quarantine backup %s "
                "for diff review job %r.",
                backup_path,
                job_id,
            )

            return

        try:
            self.diff_schema_service.clear_backup_path(
                job_id=job_id,
                expected_status="applying",
            )
        except Exception:
            logger.exception(
                "Could not clear the quarantine backup path for "
                "diff review job %r.",
                job_id,
            )

    def _delete_applied_backup(
        self,
        *,
        job_id: str,
        backup_path: Path,
    ) -> None:
        """
        Delete the quarantine backup after successful application.

        A cleanup failure does not change an already applied job back to
        failed. The retained backup_path allows later cleanup.
        """

        try:
            self.backup_service.delete_backup(
                backup_path=backup_path,
            )
        except Exception:
            logger.exception(
                "Could not delete quarantine backup %s for "
                "applied diff review job %r.",
                backup_path,
                job_id,
            )

            return

        try:
            self.diff_schema_service.clear_backup_path(
                job_id=job_id,
                expected_status="applied",
            )
        except Exception:
            logger.exception(
                "Deleted quarantine backup %s but could not clear "
                "the backup path for applied diff review job %r.",
                backup_path,
                job_id,
            )

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