# teksi_wastewater/hooks/services/tww_review_persistence_service.py

from __future__ import annotations

import json
import logging
from collections.abc import Sequence
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from teksi_hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobPersistenceError,
    DiffJobStateError,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
)
from teksi_hooks.models.review import (
    DiffReviewJob,
)
from teksi_hooks.services.postgres_backup_service import (
    PostgresBackupService,
)

from ..adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from ..adapters.tww_session_manager import (
    TwwSessionContext,
)
from ..capabilities.tww_interlis_persistence_capability import (
    TwwInterlisPersistenceResult,
)
from ..exceptions import (
    TwwReviewApplicationError,
)
from .tww_diff_schema_service import (
    DiffJobCounts,
    TwwDiffSchemaService,
    TwwJobPersistenceResult,
)
from .tww_persistence_context_factory import (
    TwwPersistenceSourceContext,
)
from .tww_quarantine_persistence_preparer import (
    TwwQuarantinePersistencePreparer,
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
class TwwPersistenceRecoveryState:
    """
    Describe compensation required after review persistence fails.

    This state contains database identifiers and backup paths only. It must
    not retain SQLAlchemy sessions because recovery runs after the persistence
    scope has exited.
    """

    job_id: str

    phase: str

    active_source_role: str | None

    active_import_schema: str | None

    completed_source_roles: tuple[
        str,
        ...,
    ]

    prepared_import_schemas: tuple[
        str,
        ...,
    ]

    backups: tuple[
        TwwQuarantineBackup,
        ...,
    ]


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

    backup_service: PostgresBackupService

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
        source_contexts: Sequence[TwwPersistenceSourceContext,],
        canonical_metadata: CanonicalModelMetadata,
        validation_definition: Any,
        session_context: TwwSessionContext,
    ) -> TwwJobPersistenceResult:
        """
        Apply one accepted review job to the live schema.

        The supplied sessions are borrowed from the application-level persistence
        scope. This method does not close them.

        If persistence fails after backup creation, the raised
        ``TwwReviewApplicationError`` contains all state required for compensation.
        The application service must allow its persistence scope to exit before
        calling ``recover_job()``.
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

        validation_finding_row_count = self.diff_schema_service.validation_finding_row_count(
            job_id=job_id,
        )

        self._assert_review_counts(
            job_id=job_id,
            counts=counts,
            validation_finding_row_count=(validation_finding_row_count),
        )

        ordered_source_contexts = self._ordered_source_contexts(
            job_id=job_id,
            source_contexts=source_contexts,
        )

        if any(
            source_context.source_role == "incremental"
            for source_context in ordered_source_contexts
        ):
            self.persistence_adapter.assert_incremental_ready()

        self.diff_schema_service.acquire_job_for_application(
            job_id=job_id,
        )

        backups: list[TwwQuarantineBackup,] = []

        prepared_import_schemas: list[str,] = []

        phase_results: list[TwwPersistencePhaseResult,] = []

        active_phase = "backup"

        active_source_context: TwwPersistenceSourceContext | None = None

        try:
            backups = self._create_backups(
                job_id=job_id,
                source_contexts=(ordered_source_contexts),
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

                active_phase = "prepare_" f"{source_context.source_role}"

                self._prepare_source_context(
                    job_id=job_id,
                    source_context=source_context,
                    canonical_metadata=(canonical_metadata),
                    validation_definition=(validation_definition),
                )

                if source_context.import_schema not in prepared_import_schemas:
                    prepared_import_schemas.append(
                        source_context.import_schema,
                    )

                active_phase = "persist_" f"{source_context.source_role}"

                interlis_persistence = self.persistence_adapter.persist_quarantine(
                    job_id=job_id,
                    source_role=(source_context.source_role),
                    session_context=session_context,
                    import_schema=(source_context.import_schema),
                    live_schema=live_schema,
                    source_model=(source_context.source_model),
                    model_mapping=(source_context.model_mapping),
                    quarantine_classes=(source_context.quarantine_classes),
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
                        source_role=(source_context.source_role),
                        import_schema=(source_context.import_schema),
                        source_model=(source_context.source_model),
                        committed=True,
                        interlis_persistence=(interlis_persistence),
                    )
                )

                self.logger.info(
                    "Persisted source phase %r for diff job %r " "from quarantine schema %r.",
                    source_context.source_role,
                    job_id,
                    source_context.import_schema,
                )

            active_phase = "finalize"

            self.diff_schema_service.mark_job_applied(
                job_id=job_id,
            )

        except Exception as exception:
            recovery_state = TwwPersistenceRecoveryState(
                job_id=job_id,
                phase=active_phase,
                active_source_role=(
                    active_source_context.source_role
                    if active_source_context is not None
                    else None
                ),
                active_import_schema=(
                    active_source_context.import_schema
                    if active_source_context is not None
                    else None
                ),
                completed_source_roles=tuple(
                    phase_result.source_role for phase_result in phase_results
                ),
                prepared_import_schemas=tuple(prepared_import_schemas),
                backups=tuple(backups),
            )

            raise TwwReviewApplicationError(
                recovery_state=recovery_state,
                cause=exception,
            ) from exception

        self._delete_applied_backups(
            job_id=job_id,
            backups=backups,
        )

        self.logger.info(
            "Applied diff review job %r through source phases %r " "with %s review features.",
            job_id,
            tuple(phase_result.source_role for phase_result in phase_results),
            counts.total_count,
        )

        final_phase_result = phase_results[-1]

        return TwwJobPersistenceResult(
            job_id=job_id,
            previous_status="accepted",
            job_status="applied",
            review_feature_count=(counts.total_count),
            restricted_feature_count=(counts.restricted_count),
            import_schema=(final_phase_result.import_schema),
            live_schema=live_schema,
            source_model=(final_phase_result.source_model),
            interlis_persistence=(final_phase_result.interlis_persistence),
        )

    def recover_job(
        self,
        *,
        job: DiffReviewJob,
        live_schema: str,
        source_contexts: Sequence[TwwPersistenceSourceContext,],
        canonical_metadata: CanonicalModelMetadata,
        validation_definition: Any,
        persistence_exception: Exception,
    ) -> None:
        """
        Compensate a failed review persistence attempt.

        This method must be called only after the application-level persistence
        scope has exited. It does not use or close any SQLAlchemy session.

        Backup restoration failures are attached to the persistence exception and
        do not replace its original traceback.
        """
        del canonical_metadata
        del validation_definition

        normalized_live_schema = live_schema.strip()

        if not normalized_live_schema:
            raise ValueError("live_schema must be a non-empty string.")

        if not isinstance(
            persistence_exception,
            TwwReviewApplicationError,
        ):
            self.logger.warning(
                "Review application for job %r failed before "
                "recoverable persistence state was created.",
                job.job_id,
            )

            self._mark_failed(
                job_id=job.job_id,
                phase="application",
                source_role=None,
                import_schema=None,
                completed_phases=(),
                exception=persistence_exception,
            )

            return

        recovery_state = persistence_exception.recovery_state

        if recovery_state.job_id != job.job_id:
            raise ValueError(
                "Recovery state belongs to diff job "
                f"{recovery_state.job_id!r}, but recovery was "
                f"requested for {job.job_id!r}."
            )

        known_import_schemas = {source_context.import_schema for source_context in source_contexts}

        unexpected_backup_schemas = {
            backup.import_schema
            for backup in recovery_state.backups
            if backup.import_schema not in known_import_schemas
        }

        if unexpected_backup_schemas:
            raise ValueError(
                "Recovery state contains backup schemas that "
                "do not belong to the supplied source contexts: "
                f"{tuple(sorted(unexpected_backup_schemas))!r}."
            )

        original_exception = persistence_exception.cause

        restoration_errors = self._restore_backups(
            job_id=job.job_id,
            backups=(recovery_state.backups),
            prepared_import_schemas=(recovery_state.prepared_import_schemas),
        )

        for restoration_error in restoration_errors:
            if hasattr(
                original_exception,
                "add_note",
            ):
                original_exception.add_note(
                    "Quarantine backup restoration or "
                    "cleanup also failed: "
                    f"{restoration_error}"
                )

        self._mark_failed(
            job_id=job.job_id,
            phase=recovery_state.phase,
            source_role=(recovery_state.active_source_role),
            import_schema=(recovery_state.active_import_schema),
            completed_phases=(recovery_state.completed_source_roles),
            exception=original_exception,
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
            source_role=source_context.source_role,
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
        source_contexts: Sequence[TwwPersistenceSourceContext,],
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
                    reason=("unsupported persistence source role " f"{source_role!r}."),
                )

            if source_role in source_context_by_role:
                raise DiffJobEligibilityError(
                    job_id=job_id,
                    reason=(
                        "several persistence contexts exist for " f"source role {source_role!r}."
                    ),
                )

            source_context_by_role[source_role] = source_context

        if "base" not in source_context_by_role:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=("the review job has no retained base source."),
            )

        ordered = [
            source_context_by_role["base"],
        ]

        incremental_context = source_context_by_role.get(
            "incremental",
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
        source_contexts: Sequence[TwwPersistenceSourceContext,],
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
                reason=("source validation was not successful."),
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
                reason=("the live schema is missing or invalid."),
            )

        if not source_contexts:
            raise DiffJobEligibilityError(
                job_id=job.job_id,
                reason=("the review job has no retained source " "contexts."),
            )

        for source_context in source_contexts:
            if (
                not source_context.import_schema
                or not source_context.source_model
                or not source_context.mapping_model_id
            ):
                raise DiffJobEligibilityError(
                    job_id=job.job_id,
                    reason=("a retained source context contains " "incomplete source metadata."),
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

        operation_count = counts.created_count + counts.altered_count + counts.deleted_count

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
        source_contexts: Sequence[TwwPersistenceSourceContext,],
    ) -> list[TwwQuarantineBackup,]:
        """
        Back up every retained quarantine schema before preparation.

        Duplicate schema names are backed up only once.
        """

        backups: list[TwwQuarantineBackup,] = []

        backed_up_schemas: set[str,] = set()

        try:
            for source_context in source_contexts:
                if source_context.import_schema in backed_up_schemas:
                    continue

                backup_path = self.backup_service.create_backup(
                    job_id=job_id,
                    import_schema=(source_context.import_schema),
                )

                backups.append(
                    TwwQuarantineBackup(
                        source_role=(source_context.source_role),
                        import_schema=(source_context.import_schema),
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
        backups: Sequence[TwwQuarantineBackup,],
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
        backups: Sequence[TwwQuarantineBackup,],
        prepared_import_schemas: tuple[
            str,
            ...,
        ],
    ) -> tuple[
        Exception,
        ...,
    ]:
        """
        Restore prepared quarantine schemas in reverse order.

        Restoration failures are returned to the caller so they can be attached
        to the original persistence exception. Backup metadata is cleared only
        when every required restoration and archive deletion succeeds.
        """
        prepared_schema_set = set(
            prepared_import_schemas,
        )

        restoration_errors: list[Exception,] = []

        cleanup_succeeded = True

        for backup in reversed(
            backups,
        ):
            if backup.import_schema not in prepared_schema_set:
                try:
                    self.backup_service.delete_backup(
                        backup_path=(backup.backup_path),
                    )

                except Exception as exception:
                    cleanup_succeeded = False

                    restoration_errors.append(
                        exception,
                    )

                    self.logger.exception(
                        "Could not delete unused quarantine "
                        "backup %s for source role %r and "
                        "diff job %r.",
                        backup.backup_path,
                        backup.source_role,
                        job_id,
                    )

                continue

            try:
                self.backup_service.restore_backup(
                    backup_path=(backup.backup_path),
                    import_schema=(backup.import_schema),
                )

            except Exception as exception:
                cleanup_succeeded = False

                restoration_errors.append(
                    exception,
                )

                self.logger.exception(
                    "Could not restore quarantine backup %s "
                    "for source role %r, schema %r, and "
                    "diff job %r.",
                    backup.backup_path,
                    backup.source_role,
                    backup.import_schema,
                    job_id,
                )

                # Retain the archive for manual recovery.
                continue

            try:
                self.backup_service.delete_backup(
                    backup_path=(backup.backup_path),
                )

            except Exception as exception:
                cleanup_succeeded = False

                restoration_errors.append(
                    exception,
                )

                self.logger.exception(
                    "Restored schema %r but could not delete "
                    "quarantine backup %s for diff job %r.",
                    backup.import_schema,
                    backup.backup_path,
                    job_id,
                )

        if not cleanup_succeeded:
            return tuple(
                restoration_errors,
            )

        try:
            self.diff_schema_service.clear_backup_path(
                job_id=job_id,
                expected_status="applying",
            )

        except Exception as exception:
            restoration_errors.append(
                exception,
            )

            self.logger.exception(
                "Could not clear quarantine backup metadata " "for failed diff review job %r.",
                job_id,
            )

        return tuple(
            restoration_errors,
        )

    def _release_sessions_before_restore(
        self,
        *,
        session_context: TwwSessionContext,
        source_contexts: Sequence[TwwPersistenceSourceContext,],
        exception: Exception,
    ) -> None:
        """
        Roll back and close every application session before archive restoration.

        PostgreSQL ``pg_restore --clean`` requires schema-level locks. Retained
        SQLAlchemy sessions must therefore release their transactions and checked-
        out connections before the external PostgreSQL process starts.

        Session cleanup failures are recorded on the original persistence
        exception and do not prevent attempts to release the remaining sessions.
        """
        for (
            session_label,
            session,
        ) in self._distinct_recovery_sessions(
            session_context=session_context,
            source_contexts=source_contexts,
        ):
            try:
                if session.in_transaction():
                    session.rollback()

            except Exception as rollback_exception:
                self.logger.exception(
                    "Could not roll back database session %r " "before quarantine restoration.",
                    session_label,
                )

                if hasattr(
                    exception,
                    "add_note",
                ):
                    exception.add_note(
                        "Could not roll back database session "
                        f"{session_label!r}: "
                        f"{rollback_exception}"
                    )

            try:
                session.close()

            except Exception as close_exception:
                self.logger.exception(
                    "Could not close database session %r " "before quarantine restoration.",
                    session_label,
                )

                if hasattr(
                    exception,
                    "add_note",
                ):
                    exception.add_note(
                        "Could not close database session "
                        f"{session_label!r}: "
                        f"{close_exception}"
                    )

    def _distinct_recovery_sessions(
        self,
        *,
        session_context: TwwSessionContext,
        source_contexts: Sequence[TwwPersistenceSourceContext,],
    ) -> tuple[
        tuple[
            str,
            Any,
        ],
        ...,
    ]:
        """
        Return every distinct session that can retain quarantine or live locks.
        """
        candidates: list[
            tuple[
                str,
                Any,
            ],
        ] = [
            (
                "persistence.live",
                session_context.live,
            ),
            (
                "persistence.quarantine",
                session_context.quarantine,
            ),
        ]

        candidates.extend(
            (
                (
                    "source." f"{source_context.source_role}." "quarantine",
                    source_context.quarantine_session,
                )
            )
            for source_context in source_contexts
        )

        sessions: list[
            tuple[
                str,
                Any,
            ],
        ] = []

        processed_session_ids: set[int,] = set()

        for (
            label,
            session,
        ) in candidates:
            if session is None:
                continue

            session_id = id(
                session,
            )

            if session_id in processed_session_ids:
                continue

            processed_session_ids.add(
                session_id,
            )

            sessions.append(
                (
                    label,
                    session,
                )
            )

        return tuple(
            sessions,
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
        backups: Sequence[TwwQuarantineBackup,],
    ) -> None:
        """
        Delete backups created before the complete backup set failed.
        """

        for backup in reversed(
            backups,
        ):
            try:
                self.backup_service.delete_backup(
                    backup_path=(backup.backup_path),
                )

            except Exception:
                self.logger.exception(
                    "Could not delete unused quarantine backup " "%s for diff review job %r.",
                    backup.backup_path,
                    job_id,
                )

    def _delete_applied_backups(
        self,
        *,
        job_id: str,
        backups: Sequence[TwwQuarantineBackup,],
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
                    backup_path=(backup.backup_path),
                )

            except Exception:
                cleanup_succeeded = False

                self.logger.exception(
                    "Could not delete quarantine backup %s for " "applied diff review job %r.",
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

    def _mark_failed(
        self,
        *,
        job_id: str,
        phase: str,
        source_context: TwwPersistenceSourceContext | None,
        completed_phases: tuple[
            str,
            ...,
        ],
        exception: Exception,
    ) -> None:
        """
        Record an application failure without hiding the original exception.
        """

        source_role = source_context.source_role if source_context is not None else None

        import_schema = source_context.import_schema if source_context is not None else None

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
