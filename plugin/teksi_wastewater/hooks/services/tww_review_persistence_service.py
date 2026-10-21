# teksi_wastewater/hooks/services/tww_review_persistence_service.py

from __future__ import annotations

import json
import logging
from collections.abc import Sequence
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Protocol

from sqlalchemy.orm import Session

from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
)
from teksi_hooks.models.review import (
    DiffReviewJob,
)

from ..adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from ..capabilities.tww_interlis_persistence_capability import (
    TwwInterlisPersistenceResult,
)
from ..exceptions import (
    DiffJobEligibilityError,
    DiffJobPersistenceError,
    DiffJobStateError,
)
from .tww_diff_schema_service import (
    DiffJobCounts,
    TwwDiffSchemaService,
    TwwJobPersistenceResult,
)
from .tww_quarantine_persistence_preparer import (
    TwwQuarantinePersistencePreparer,
)
from .tww_database_backup_service import (
    TwwDatabaseBackupService,
)
from .tww_persistence_context_factory import(
    TwwPersistenceSourceContext,
)

logger = logging.getLogger(
    __name__,
)


@dataclass(
    frozen=True,
    slots=True,
)
class TwwQuarantineBackup:
    """
    Record of one retained quarantine-schema backup.

    The database backup service creates the archive. This record keeps the
    archive associated with the schema and source role required for restore,
    cleanup, and diagnostics.
    """

    source_role: str

    import_schema: str

    backup_path: Path


@dataclass(
    frozen=True,
    slots=True,
)
class TwwPersistencePhaseResult:
    """
    Result of persisting one retained source phase.
    """

    source_role: str
    import_schema: str
    source_model: str
    committed: bool
    interlis_persistence: TwwInterlisPersistenceResult


@dataclass(
    slots=True,
)
class TwwReviewPersistenceService:
    """
    Apply one accepted tww_diff review job.

    One review job may contain an ordered baseline source and an incremental
    source. Both remain part of one review decision and one job lifecycle.

    Persistence order:

    1. baseline;
    2. incremental.

    Quarantine preparation runs in one transaction per source context. The
    service commits each prepared quarantine phase before invoking the existing
    quarantine-to-live importer.

    All retained quarantine schemas are backed up before the first destructive
    preparation starts. On failure, every prepared quarantine schema is
    restored in reverse order.

    The live importer owns its own database transaction. Therefore the complete
    multi-source workflow is recoverable through backups but is not one
    distributed atomic transaction.
    """

    diff_schema_service: TwwDiffSchemaService

    backup_service: TwwDatabaseBackupService

    persistence_adapter: TwwInterlisPersistenceAdapter

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    def persist_job(
        self,
        *,
        job: DiffReviewJob,
        live_schema: str,
        source_contexts: Sequence[
            TwwPersistenceSourceContext,
        ],
        canonical_metadata: CanonicalModelMetadata,
        validation_definition: Any,
    ) -> TwwJobPersistenceResult:
        """
        Apply one accepted review job to the live schema.

        The job is acquired once, backed up once per retained source schema,
        applied through all source phases, and marked applied only after every
        phase confirms its live transaction commit.
        """

        job_id = job.job_id

        self._assert_application_eligibility(
            job=job,
            live_schema=live_schema,
            source_contexts=source_contexts,
        )

        counts = self.diff_schema_service.job_counts(
            job_id=job_id,
        )

        validation_finding_row_count = (
            self.diff_schema_service
            .validation_finding_row_count(
                job_id=job_id,
            )
        )

        self._assert_review_counts(
            job_id=job_id,
            counts=counts,
            validation_finding_row_count=(
                validation_finding_row_count
            ),
        )

        ordered_source_contexts = self._ordered_source_contexts(
            job_id=job_id,
            source_contexts=source_contexts,
        )
        
        if any(
            source_context.source_role
            == "incremental"
            for source_context in ordered_source_contexts
        ):
            self.persistence_adapter.assert_incremental_ready()

        self.diff_schema_service.acquire_job_for_application(
            job_id=job_id,
        )

        backups: list[
            TwwQuarantineBackup,
        ] = []

        prepared_source_roles: list[
            str,
        ] = []

        phase_results: list[
            TwwPersistencePhaseResult,
        ] = []

        active_phase = "backup"
        active_source_context: (
            TwwPersistenceSourceContext
            | None
        ) = None

        try:
            backups = self._create_backups(
                job_id=job_id,
                source_contexts=ordered_source_contexts,
            )

            self.diff_schema_service.set_backup_path(
                job_id=job_id,
                expected_status="applying",
                backup_path=self._backup_manifest(
                    backups,
                ),
            )

            for source_context in ordered_source_contexts:
                active_source_context = source_context

                active_phase = (
                    f"prepare_{source_context.source_role}"
                )

                self._prepare_source_context(
                    job_id=job_id,
                    source_context=source_context,
                    canonical_metadata=canonical_metadata,
                    validation_definition=validation_definition,
                )

                prepared_source_roles.append(
                    source_context.source_role,
                )

                active_phase = (
                    f"persist_{source_context.source_role}"
                )

                interlis_persistence = (
                    self.persistence_adapter
                    .persist_quarantine(
                        job_id=job_id,
                        source_role=source_context.source_role,
                        import_schema=(
                            source_context.import_schema
                        ),
                        live_schema=live_schema,
                        source_model=(
                            source_context.source_model
                        ),
                        model_mapping=source_context.model_mapping,
                        quarantine_classes=(
                            source_context.quarantine_classes
                        ),
                    )
                )

                if not interlis_persistence.committed:
                    raise DiffJobPersistenceError(
                        job_id=job_id,
                        phase=active_phase,
                        message=(
                            "The quarantine-to-live importer "
                            "returned without confirming its live "
                            "transaction commit for source role "
                            f"{source_context.source_role!r} and "
                            "schema "
                            f"{source_context.import_schema!r}."
                        ),
                    )

                phase_results.append(
                    TwwPersistencePhaseResult(
                        source_role=(
                            source_context.source_role
                        ),
                        import_schema=(
                            source_context.import_schema
                        ),
                        source_model=(
                            source_context.source_model
                        ),
                        committed=True,
                        interlis_persistence=(
                            interlis_persistence
                        ),
                    )
                )

                self.logger.info(
                    "Persisted source phase %r for diff job %r "
                    "from quarantine schema %r.",
                    source_context.source_role,
                    job_id,
                    source_context.import_schema,
                )

            active_phase = "finalize"

            self.diff_schema_service.mark_job_applied(
                job_id=job_id,
            )

        except Exception as exception:
            self._rollback_active_sessions(
                source_contexts=ordered_source_contexts,
            )

            self._restore_backups(
                job_id=job_id,
                backups=backups,
                prepared_source_roles=tuple(
                    prepared_source_roles,
                ),
            )

            self._mark_failed(
                job_id=job_id,
                phase=active_phase,
                source_context=active_source_context,
                completed_phases=tuple(
                    phase_result.source_role
                    for phase_result in phase_results
                ),
                exception=exception,
            )

            raise

        self._delete_applied_backups(
            job_id=job_id,
            backups=backups,
        )

        self.logger.info(
            "Applied diff review job %r through source phases %r "
            "with %s review features.",
            job_id,
            tuple(
                phase_result.source_role
                for phase_result in phase_results
            ),
            counts.total_count,
        )

        final_phase_result = phase_results[
            -1
        ]

        return TwwJobPersistenceResult(
            job_id=job_id,
            previous_status="accepted",
            job_status="applied",
            review_feature_count=counts.total_count,
            restricted_feature_count=(
                counts.restricted_count
            ),
            import_schema=(
                final_phase_result.import_schema
            ),
            live_schema=live_schema,
            source_model=(
                final_phase_result.source_model
            ),
            interlis_persistence=(
                final_phase_result
                .interlis_persistence
            ),
        )

    def _prepare_source_context(
        self,
        *,
        job_id: str,
        source_context: TwwPersistenceSourceContext,
        canonical_metadata: CanonicalModelMetadata,
        validation_definition: Any,
    ) -> None:
        """
        Apply review permission decisions to one quarantine source.

        The persistence service owns the source session transaction. The
        preparer modifies ORM objects and flushes, but must not commit, roll
        back, or close the session.
        """

        preparer = TwwQuarantinePersistencePreparer(
            diff_schema_service=self.diff_schema_service,
            quarantine_session=source_context.quarantine_session,
            quarantine_classes=source_context.quarantine_classes,
            model_mapping=source_context.model_mapping,
            canonical_metadata=canonical_metadata,
            validation_definition=validation_definition,
        )

        try:
            preparer.prepare(
                job_id=job_id,
                import_schema=source_context.import_schema,
            )

            source_context.quarantine_session.commit()

        except Exception:
            source_context.quarantine_session.rollback()
            raise

    def _ordered_source_contexts(
        self,
        *,
        job_id: str,
        source_contexts: Sequence[
            TwwPersistenceSourceContext,
        ],
    ) -> tuple[
        TwwPersistenceSourceContext,
        ...,
    ]:
        """
        Validate and order source contexts.

        Exactly one context per source role is allowed. Base is always first,
        followed by incremental.
        """

        source_context_by_role: dict[
            str,
            TwwPersistenceSourceContext,
        ] = {}

        for source_context in source_contexts:
            source_role = source_context.source_role

            if source_role not in {
                "base",
                "incremental",
            }:
                raise DiffJobEligibilityError(
                    job_id=job_id,
                    reason=(
                        "unsupported persistence source role "
                        f"{source_role!r}."
                    ),
                )

            if source_role in source_context_by_role:
                raise DiffJobEligibilityError(
                    job_id=job_id,
                    reason=(
                        "several persistence contexts exist for "
                        f"source role {source_role!r}."
                    ),
                )

            source_context_by_role[
                source_role
            ] = source_context

        if "base" not in source_context_by_role:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    "the review job has no retained base source."
                ),
            )

        ordered = [
            source_context_by_role[
                "base"
            ],
        ]

        incremental_context = (
            source_context_by_role.get(
                "incremental",
            )
        )

        if incremental_context is not None:
            ordered.append(
                incremental_context,
            )

        return tuple(
            ordered,
        )

    def _assert_application_eligibility(
        self,
        *,
        job: DiffReviewJob,
        live_schema: str,
        source_contexts: Sequence[
            TwwPersistenceSourceContext,
        ],
    ) -> None:
        """
        Validate lifecycle and source-level persistence eligibility.
        """

        if job.job_status != "accepted":
            raise DiffJobStateError(
                job_id=job.job_id,
                expected_status="accepted",
                actual_status=job.job_status,
            )

        if not job.validation_success:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(
                    "source validation was not successful."
                ),
            )

        if (
            not isinstance(
                live_schema,
                str,
            )
            or not live_schema.strip()
        ):
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(
                    "the live schema is missing or invalid."
                ),
            )

        if not source_contexts:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=(
                    "the review job has no retained source "
                    "contexts."
                ),
            )

        for source_context in source_contexts:
            if (
                not source_context.import_schema
                or not source_context.source_model
                or not source_context.mapping_model_id
            ):
                raise DiffJobEligibilityError(
                    job_id=job.job_id,
                    reason=(
                        "a retained source context contains "
                        "incomplete source metadata."
                    ),
                )

    def _assert_review_counts(
        self,
        *,
        job_id: str,
        counts: DiffJobCounts,
        validation_finding_row_count: int,
    ) -> None:
        """
        Validate persisted review rows before application.

        Validation findings block persistence. Permission findings are handled
        by destructive quarantine preparation and therefore do not block the
        entire job.
        """

        if validation_finding_row_count:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"{validation_finding_row_count} of "
                    f"{counts.total_count} review rows contain "
                    "blocking validation findings."
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
                    f"{counts.total_count - operation_count} "
                    "review rows do not identify exactly one "
                    "persistence operation."
                ),
            )

    def _create_backups(
        self,
        *,
        job_id: str,
        source_contexts: Sequence[
            TwwPersistenceSourceContext,
        ],
    ) -> list[
        TwwQuarantineBackup,
    ]:
        """
        Back up every retained quarantine schema before preparation.

        Duplicate schema names are backed up only once.
        """

        backups: list[
            TwwQuarantineBackup,
        ] = []

        backed_up_schemas: set[
            str,
        ] = set()

        try:
            for source_context in source_contexts:
                if (
                    source_context.import_schema
                    in backed_up_schemas
                ):
                    continue

                backup_path = (
                    self.backup_service.create_backup(
                        job_id=job_id,
                        import_schema=(
                            source_context.import_schema
                        ),
                    )
                )

                backups.append(
                    TwwQuarantineBackup(
                        source_role=(
                            source_context.source_role
                        ),
                        import_schema=(
                            source_context.import_schema
                        ),
                        backup_path=backup_path,
                    )
                )

                backed_up_schemas.add(
                    source_context.import_schema,
                )

        except Exception:
            self._delete_unused_backups(
                job_id=job_id,
                backups=backups,
            )

            raise

        return backups

    def _backup_manifest(
        self,
        backups: Sequence[
            TwwQuarantineBackup,
        ],
    ) -> str:
        """
        Serialize all retained quarantine backups into the existing text field.

        The metadata column remains a text field, so the multi-source backup
        set is represented as a JSON array.
        """

        return json.dumps(
            [
                {
                    "source_role": backup.source_role,
                    "import_schema": backup.import_schema,
                    "backup_path": str(
                        backup.backup_path,
                    ),
                }
                for backup in backups
            ],
            ensure_ascii=False,
            sort_keys=True,
        )

    def _restore_backups(
        self,
        *,
        job_id: str,
        backups: Sequence[
            TwwQuarantineBackup,
        ],
        prepared_source_roles: tuple[
            str,
            ...,
        ],
    ) -> None:
        """
        Restore retained quarantine schemas after application failure.

        Restores run in reverse persistence order. Restoration failures are
        logged without hiding the original application exception.
        """

        prepared_role_set = set(
            prepared_source_roles,
        )

        for backup in reversed(
            backups,
        ):
            if (
                backup.source_role
                not in prepared_role_set
            ):
                self._delete_backup_after_failure(
                    job_id=job_id,
                    backup=backup,
                )

                continue

            try:
                self.backup_service.restore_backup(
                    backup_path=(
                        backup.backup_path
                    ),
                    import_schema=(
                        backup.import_schema
                    ),
                )

            except Exception:
                self.logger.exception(
                    "Could not restore quarantine backup %s "
                    "for source role %r and diff job %r.",
                    backup.backup_path,
                    backup.source_role,
                    job_id,
                )

                continue

            try:
                self.backup_service.delete_backup(
                    backup_path=(
                        backup.backup_path
                    ),
                )

            except Exception:
                self.logger.exception(
                    "Could not delete restored quarantine "
                    "backup %s for diff job %r.",
                    backup.backup_path,
                    job_id,
                )

        try:
            self.diff_schema_service.clear_backup_path(
                job_id=job_id,
                expected_status="applying",
            )

        except Exception:
            self.logger.exception(
                "Could not clear quarantine backup metadata "
                "for failed diff review job %r.",
                job_id,
            )

    def _delete_backup_after_failure(
        self,
        *,
        job_id: str,
        backup: TwwQuarantineBackup,
    ) -> None:
        """
        Delete an unused backup for a source phase never prepared.
        """

        try:
            self.backup_service.delete_backup(
                backup_path=backup.backup_path,
            )

        except Exception:
            self.logger.exception(
                "Could not delete unused quarantine backup %s "
                "for source role %r and diff job %r.",
                backup.backup_path,
                backup.source_role,
                job_id,
            )

    def _delete_unused_backups(
        self,
        *,
        job_id: str,
        backups: Sequence[
            TwwQuarantineBackup,
        ],
    ) -> None:
        """
        Delete backups created before the complete backup set failed.
        """

        for backup in reversed(
            backups,
        ):
            try:
                self.backup_service.delete_backup(
                    backup_path=(
                        backup.backup_path
                    ),
                )

            except Exception:
                self.logger.exception(
                    "Could not delete unused quarantine backup "
                    "%s for diff review job %r.",
                    backup.backup_path,
                    job_id,
                )

    def _delete_applied_backups(
        self,
        *,
        job_id: str,
        backups: Sequence[
            TwwQuarantineBackup,
        ],
    ) -> None:
        """
        Delete all quarantine backups after successful application.

        Cleanup failure does not change an already applied job back to failed.
        Backup metadata remains available if not every backup was deleted.
        """

        cleanup_succeeded = True

        for backup in reversed(
            backups,
        ):
            try:
                self.backup_service.delete_backup(
                    backup_path=(
                        backup.backup_path
                    ),
                )

            except Exception:
                cleanup_succeeded = False

                self.logger.exception(
                    "Could not delete quarantine backup %s for "
                    "applied diff review job %r.",
                    backup.backup_path,
                    job_id,
                )

        if not cleanup_succeeded:
            return

        try:
            self.diff_schema_service.clear_backup_path(
                job_id=job_id,
                expected_status="applied",
            )

        except Exception:
            self.logger.exception(
                "Deleted quarantine backups but could not clear "
                "backup metadata for applied diff review job %r.",
                job_id,
            )

    def _rollback_active_sessions(
        self,
        *,
        source_contexts: Sequence[
            TwwPersistenceSourceContext,
        ],
    ) -> None:
        """
        Roll back active quarantine transactions without closing sessions.
        """

        for source_context in reversed(
            source_contexts,
        ):
            session = (
                source_context.quarantine_session
            )

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

    def _mark_failed(
        self,
        *,
        job_id: str,
        phase: str,
        source_context: (
            TwwPersistenceSourceContext
            | None
        ),
        completed_phases: tuple[
            str,
            ...,
        ],
        exception: Exception,
    ) -> None:
        """
        Record an application failure without hiding the original exception.
        """

        source_role = (
            source_context.source_role
            if source_context is not None
            else None
        )

        import_schema = (
            source_context.import_schema
            if source_context is not None
            else None
        )

        message = str(
            exception,
        )

        diagnostic_message = (
            f"{message} "
            f"[phase={phase!r}, "
            f"source_role={source_role!r}, "
            f"import_schema={import_schema!r}, "
            f"completed_phases={completed_phases!r}]"
        )

        try:
            self.diff_schema_service.mark_job_failed(
                job_id=job_id,
                expected_status="applying",
                phase=phase,
                error_type=type(
                    exception,
                ).__name__,
                message=diagnostic_message,
            )

        except Exception as transition_exception:
            self.logger.exception(
                "Could not mark diff review job %r as failed.",
                job_id,
            )

            if hasattr(
                exception,
                "add_note",
            ):
                exception.add_note(
                    "Additionally, the diff job could not be "
                    "marked failed: "
                    f"{transition_exception}"
                )