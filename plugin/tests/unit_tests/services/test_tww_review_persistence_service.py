# tests/unit/hooks/services/test_tww_review_persistence_service.py

from __future__ import annotations

from pathlib import Path
from unittest.mock import Mock, call

import pytest

from teksi_hooks.models.review import (
    DiffReviewJob,
)

from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobPersistenceError,
)

from teksi_wastewater.hooks.adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceResult,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    DiffJobCounts,
    TwwJobPersistenceResult,
)
from teksi_wastewater.hooks.services.tww_review_persistence_service import (
    TwwReviewPersistenceService,
)


BACKUP_PATH = Path(
    "/tmp/tww-diff-job-1.dump",
)


def _job(
    *,
    job_status: str = "accepted",
    validation_success: bool = True,
    metadata: dict | None = None,
) -> DiffReviewJob:
    return DiffReviewJob(
        job_db_id=1,
        job_id="job-1",
        job_status=job_status,
        validation_success=validation_success,
        metadata=(
            metadata
            if metadata is not None
            else {
                "source_model": "DSS_2020_1_LV95",
                "import_schema": "xtf_import",
                "live_schema": "tww_od",
            }
        ),
        features_by_class={},
    )


def _counts(
    *,
    total_count: int = 1,
    rejected_count: int = 0,
    created_count: int = 0,
    altered_count: int = 1,
    deleted_count: int = 0,
) -> DiffJobCounts:
    return DiffJobCounts(
        total_count=total_count,
        rejected_count=rejected_count,
        created_count=created_count,
        altered_count=altered_count,
        deleted_count=deleted_count,
    )


def _service(
    *,
    job: DiffReviewJob | None = None,
    counts: DiffJobCounts | None = None,
    validation_finding_row_count: int = 0,
):
    diff_schema_service = Mock()
    quarantine_preparer = Mock()
    backup_service = Mock()
    persistence_adapter = Mock()

    diff_schema_service.require_review_job.return_value = (
        job
        if job is not None
        else _job()
    )

    diff_schema_service.job_counts.return_value = (
        counts
        if counts is not None
        else _counts()
    )

    diff_schema_service.validation_finding_row_count.return_value = (
        validation_finding_row_count
    )

    backup_service.create_backup.return_value = (
        BACKUP_PATH
    )

    persistence_adapter.persist_quarantine.return_value = (
        TwwInterlisPersistenceResult(
            import_schema="xtf_import",
            live_schema="tww_od",
            source_model="DSS_2020_1_LV95",
            committed=True,
        )
    )

    service = TwwReviewPersistenceService(
        diff_schema_service=diff_schema_service,
        quarantine_preparer=quarantine_preparer,
        backup_service=backup_service,
        persistence_adapter=persistence_adapter,
    )

    return (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    )


def test_persist_job_applies_accepted_job(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    result = service.persist_job(
        job_id="job-1",
    )

    assert result == TwwJobPersistenceResult(
        job_id="job-1",
        previous_status="accepted",
        job_status="applied",
        review_feature_count=1,
        restricted_feature_count=0,
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
        interlis_persistence=(
            persistence_adapter
            .persist_quarantine
            .return_value
        ),
    )

    diff_schema_service.require_review_job.assert_called_once_with(
        job_id="job-1",
        include_features=False,
    )

    diff_schema_service.job_counts.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.acquire_job_for_application.assert_called_once_with(
        job_id="job-1",
    )

    backup_service.create_backup.assert_called_once_with(
        job_id="job-1",
        import_schema="xtf_import",
    )

    diff_schema_service.set_backup_path.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        backup_path=str(
            BACKUP_PATH,
        ),
    )

    quarantine_preparer.prepare.assert_called_once_with(
        job_id="job-1",
        import_schema="xtf_import",
    )

    persistence_adapter.persist_quarantine.assert_called_once_with(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    diff_schema_service.mark_job_applied.assert_called_once_with(
        job_id="job-1",
    )

    backup_service.restore_backup.assert_not_called()

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.clear_backup_path.assert_called_once_with(
        job_id="job-1",
        expected_status="applied",
    )

    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_prepares_quarantine_before_import(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    call_order: list[
        str,
    ] = []

    backup_service.create_backup.side_effect = (
        lambda **_: (
            call_order.append(
                "create_backup",
            )
            or BACKUP_PATH
        )
    )

    diff_schema_service.set_backup_path.side_effect = (
        lambda **_: call_order.append(
            "set_backup_path",
        )
    )

    quarantine_preparer.prepare.side_effect = (
        lambda **_: call_order.append(
            "prepare",
        )
    )

    persistence_adapter.persist_quarantine.side_effect = (
        lambda **_: (
            call_order.append(
                "persist",
            )
            or TwwInterlisPersistenceResult(
                import_schema="xtf_import",
                live_schema="tww_od",
                source_model="DSS_2020_1_LV95",
                committed=True,
            )
        )
    )

    diff_schema_service.mark_job_applied.side_effect = (
        lambda **_: call_order.append(
            "mark_applied",
        )
    )

    service.persist_job(
        job_id="job-1",
    )

    assert call_order == [
        "create_backup",
        "set_backup_path",
        "prepare",
        "persist",
        "mark_applied",
    ]


def test_persist_job_rejects_non_accepted_job(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        job=_job(
            job_status="pending",
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="expected 'accepted'",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.job_counts.assert_not_called()
    diff_schema_service.acquire_job_for_application.assert_not_called()

    backup_service.create_backup.assert_not_called()
    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_rejects_unsuccessful_validation(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        job=_job(
            validation_success=False,
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="validation was not successful",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.job_counts.assert_not_called()
    diff_schema_service.acquire_job_for_application.assert_not_called()

    backup_service.create_backup.assert_not_called()
    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()

def test_persist_job_rejects_blocking_validation_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        counts=_counts(
            total_count=1,
            rejected_count=1,
            created_count=0,
            altered_count=1,
            deleted_count=0,
        ),
        validation_finding_row_count=1,
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="blocking validation findings",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.validation_finding_row_count.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.acquire_job_for_application.assert_not_called()

    backup_service.create_backup.assert_not_called()
    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()


@pytest.mark.parametrize(
    (
        "counts",
        "missing_operation_count",
    ),
    [
        (
            _counts(
                total_count=1,
                created_count=0,
                altered_count=0,
                deleted_count=0,
            ),
            1,
        ),
        (
            _counts(
                total_count=3,
                created_count=1,
                altered_count=1,
                deleted_count=0,
            ),
            1,
        ),
    ],
)
def test_persist_job_rejects_rows_without_operation(
    counts: DiffJobCounts,
    missing_operation_count: int,
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        counts=counts,
        validation_finding_row_count=0,
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match=(
            f"{missing_operation_count} review rows "
            "do not identify exactly one persistence operation"
        ),
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.validation_finding_row_count.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.acquire_job_for_application.assert_not_called()

    backup_service.create_backup.assert_not_called()
    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_allows_permission_restricted_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        counts=_counts(
            total_count=1,
            rejected_count=1,
            created_count=0,
            altered_count=1,
            deleted_count=0,
        ),
        validation_finding_row_count=0,
    )

    result = service.persist_job(
        job_id="job-1",
    )

    assert result.job_status == "applied"
    assert result.restricted_feature_count == 1

    diff_schema_service.validation_finding_row_count.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.acquire_job_for_application.assert_called_once_with(
        job_id="job-1",
    )

    quarantine_preparer.prepare.assert_called_once_with(
        job_id="job-1",
        import_schema="xtf_import",
    )

    persistence_adapter.persist_quarantine.assert_called_once_with(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    diff_schema_service.mark_job_applied.assert_called_once_with(
        job_id="job-1",
    )
@pytest.mark.parametrize(
    (
        "counts",
        "missing_operation_count",
    ),
    [
        (
            _counts(
                total_count=1,
                created_count=0,
                altered_count=0,
                deleted_count=0,
            ),
            1,
        ),
        (
            _counts(
                total_count=3,
                created_count=1,
                altered_count=1,
                deleted_count=0,
            ),
            1,
        ),
    ],
)

def test_persist_job_rejects_blocking_validation_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        counts=_counts(
            rejected_count=1,
        ),
        validation_finding_row_count=1,
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="blocking validation findings",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_not_called()

    backup_service.create_backup.assert_not_called()
    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_allows_permission_restricted_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        counts=_counts(
            total_count=1,
            rejected_count=1,
            created_count=0,
            altered_count=1,
            deleted_count=0,
        ),
        validation_finding_row_count=0,
    )

    result = service.persist_job(
        job_id="job-1",
    )

    assert result.job_status == "applied"
    assert result.restricted_feature_count == 1

    quarantine_preparer.prepare.assert_called_once_with(
        job_id="job-1",
        import_schema="xtf_import",
    )

    persistence_adapter.persist_quarantine.assert_called_once_with(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    diff_schema_service.mark_job_applied.assert_called_once_with(
        job_id="job-1",
    )

@pytest.mark.parametrize(
    "metadata",
    [
        {
            "import_schema": "xtf_import",
            "live_schema": "tww_od",
        },
        {
            "source_model": "",
            "import_schema": "xtf_import",
            "live_schema": "tww_od",
        },
    ],
)
def test_persist_job_rejects_missing_source_model(
    metadata: dict,
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        job=_job(
            metadata=metadata,
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="source_model",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_not_called()
    backup_service.create_backup.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()


@pytest.mark.parametrize(
    "metadata",
    [
        {
            "source_model": "DSS_2020_1_LV95",
            "live_schema": "tww_od",
        },
        {
            "source_model": "DSS_2020_1_LV95",
            "import_schema": " ",
            "live_schema": "tww_od",
        },
    ],
)
def test_persist_job_rejects_missing_import_schema(
    metadata: dict,
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        job=_job(
            metadata=metadata,
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="import_schema",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_not_called()
    backup_service.create_backup.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()


def test_persist_job_rejects_missing_live_schema(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service(
        job=_job(
            metadata={
                "source_model": "DSS_2020_1_LV95",
                "import_schema": "xtf_import",
            },
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="live_schema",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_not_called()
    backup_service.create_backup.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()


def test_persist_job_marks_job_failed_when_backup_creation_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    backup_service.create_backup.side_effect = RuntimeError(
        "Backup failed.",
    )

    with pytest.raises(
        RuntimeError,
        match="Backup failed",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.set_backup_path.assert_not_called()

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    backup_service.restore_backup.assert_not_called()
    backup_service.delete_backup.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()

    diff_schema_service.mark_job_failed.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        phase="applying",
        error_type="RuntimeError",
        message="Backup failed.",
    )


def test_persist_job_deletes_unused_backup_when_recording_path_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    diff_schema_service.set_backup_path.side_effect = RuntimeError(
        "Could not record backup path.",
    )

    with pytest.raises(
        RuntimeError,
        match="Could not record backup path",
    ):
        service.persist_job(
            job_id="job-1",
        )

    backup_service.restore_backup.assert_not_called()

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()
    diff_schema_service.mark_job_failed.assert_called_once()


def test_persist_job_restores_backup_when_preparation_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    quarantine_preparer.prepare.side_effect = RuntimeError(
        "Preparation failed.",
    )

    with pytest.raises(
        RuntimeError,
        match="Preparation failed",
    ):
        service.persist_job(
            job_id="job-1",
        )

    backup_service.restore_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
        import_schema="xtf_import",
    )

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.clear_backup_path.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
    )

    persistence_adapter.persist_quarantine.assert_not_called()

    diff_schema_service.mark_job_applied.assert_not_called()

    diff_schema_service.mark_job_failed.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        phase="applying",
        error_type="RuntimeError",
        message="Preparation failed.",
    )


def test_persist_job_restores_backup_when_import_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    persistence_adapter.persist_quarantine.side_effect = (
        RuntimeError(
            "Importer failed.",
        )
    )

    with pytest.raises(
        RuntimeError,
        match="Importer failed",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_called_once_with(
        job_id="job-1",
    )

    quarantine_preparer.prepare.assert_called_once_with(
        job_id="job-1",
        import_schema="xtf_import",
    )

    backup_service.restore_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
        import_schema="xtf_import",
    )

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.clear_backup_path.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
    )

    diff_schema_service.mark_job_failed.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        phase="applying",
        error_type="RuntimeError",
        message="Importer failed.",
    )

    diff_schema_service.mark_job_applied.assert_not_called()


def test_persist_job_treats_uncommitted_import_as_failure(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    persistence_adapter.persist_quarantine.return_value = (
        TwwInterlisPersistenceResult(
            import_schema="xtf_import",
            live_schema="tww_od",
            source_model="DSS_2020_1_LV95",
            committed=False,
        )
    )

    with pytest.raises(
        DiffJobPersistenceError,
        match="without confirming its live transaction commit",
    ):
        service.persist_job(
            job_id="job-1",
        )

    backup_service.restore_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
        import_schema="xtf_import",
    )

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.mark_job_applied.assert_not_called()

    diff_schema_service.mark_job_failed.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        phase="applying",
        error_type="DiffJobPersistenceError",
        message=(
            "Persistence of diff review job 'job-1' failed "
            "during phase 'applying': The quarantine-to-live "
            "importer returned without confirming its live "
            "transaction commit."
        ),
    )


def test_persist_job_does_not_hide_original_error_if_restore_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    persistence_adapter.persist_quarantine.side_effect = (
        RuntimeError(
            "Importer failed.",
        )
    )

    backup_service.restore_backup.side_effect = (
        RuntimeError(
            "Restore failed.",
        )
    )

    with pytest.raises(
        RuntimeError,
        match="Importer failed",
    ):
        service.persist_job(
            job_id="job-1",
        )

    backup_service.restore_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
        import_schema="xtf_import",
    )

    backup_service.delete_backup.assert_not_called()
    diff_schema_service.clear_backup_path.assert_not_called()

    diff_schema_service.mark_job_failed.assert_called_once()


def test_persist_job_does_not_hide_original_error_if_failure_status_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    persistence_adapter.persist_quarantine.side_effect = (
        RuntimeError(
            "Importer failed.",
        )
    )

    diff_schema_service.mark_job_failed.side_effect = (
        RuntimeError(
            "Status update failed.",
        )
    )

    with pytest.raises(
        RuntimeError,
        match="Importer failed",
    ):
        service.persist_job(
            job_id="job-1",
        )

    backup_service.restore_backup.assert_called_once()
    diff_schema_service.mark_job_applied.assert_not_called()


def test_persist_job_deletes_backup_after_success(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    service.persist_job(
        job_id="job-1",
    )

    backup_service.restore_backup.assert_not_called()

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.clear_backup_path.assert_called_once_with(
        job_id="job-1",
        expected_status="applied",
    )


def test_persist_job_keeps_applied_state_when_backup_deletion_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    backup_service.delete_backup.side_effect = RuntimeError(
        "Backup deletion failed.",
    )

    result = service.persist_job(
        job_id="job-1",
    )

    assert result.job_status == "applied"

    diff_schema_service.mark_job_applied.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.clear_backup_path.assert_not_called()
    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_keeps_applied_state_when_clearing_backup_path_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    diff_schema_service.clear_backup_path.side_effect = (
        RuntimeError(
            "Backup path cleanup failed.",
        )
    )

    result = service.persist_job(
        job_id="job-1",
    )

    assert result.job_status == "applied"

    backup_service.delete_backup.assert_called_once_with(
        backup_path=BACKUP_PATH,
    )

    diff_schema_service.mark_job_applied.assert_called_once_with(
        job_id="job-1",
    )

    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_uses_explicit_live_schema_override(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    result = service.persist_job(
        job_id="job-1",
        live_schema="custom_live",
    )

    assert result.live_schema == "custom_live"

    persistence_adapter.persist_quarantine.assert_called_once_with(
        import_schema="xtf_import",
        live_schema="custom_live",
        source_model="DSS_2020_1_LV95",
    )


def test_persist_job_uses_metadata_live_schema_without_override(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        backup_service,
        persistence_adapter,
    ) = _service()

    result = service.persist_job(
        job_id="job-1",
    )

    assert result.live_schema == "tww_od"

    persistence_adapter.persist_quarantine.assert_called_once_with(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )