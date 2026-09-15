# tests/unit/hooks/services/test_tww_review_persistence_service.py

from __future__ import annotations

from unittest.mock import Mock

import pytest

from teksi_hooks.models.review import (
    DiffReviewJob,
)

from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    DiffJobCounts,
)
from teksi_wastewater.hooks.services.tww_review_persistence_service import (
    TwwInterlisPersistenceResult,
    TwwJobPersistenceResult,
    TwwQuarantinePreparationResult,
    TwwReviewPersistenceService,
)


def _job(
    *,
    job_status: str = "accepted",
    validation_success: bool = True,
) -> DiffReviewJob:
    return DiffReviewJob(
        job_db_id=1,
        job_id="job-1",
        job_status=job_status,
        validation_success=validation_success,
        metadata={
            "source_model": "DSS_2020_1_LV95",
            "import_schema": "xtf_import",
            "live_schema": "tww_od",
        },
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
):
    diff_schema_service = Mock()
    quarantine_preparer = Mock()
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

    quarantine_preparer.prepare.return_value = (
        TwwQuarantinePreparationResult(
            job_id="job-1",
            import_schema="xtf_import",
            checked_feature_count=1,
        )
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
        persistence_adapter=persistence_adapter,
    )

    return (
        service,
        diff_schema_service,
        quarantine_preparer,
        persistence_adapter,
    )


def test_persist_job_applies_accepted_job(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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
        rejected_feature_count=0,
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
        quarantine_preparation=(
            quarantine_preparer
            .prepare
            .return_value
        ),
        interlis_persistence=(
            persistence_adapter
            .persist_quarantine
            .return_value
        ),
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

    diff_schema_service.mark_job_failed.assert_not_called()


def test_persist_job_rejects_non_accepted_job(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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

    diff_schema_service.acquire_job_for_application.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()
    diff_schema_service.mark_job_applied.assert_not_called()


def test_persist_job_rejects_unsuccessful_validation(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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

    diff_schema_service.acquire_job_for_application.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()


def test_persist_job_rejects_blocking_review_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
        persistence_adapter,
    ) = _service(
        counts=_counts(
            rejected_count=1,
        ),
    )

    with pytest.raises(
        DiffJobEligibilityError,
        match="blocking permission or validation findings",
    ):
        service.persist_job(
            job_id="job-1",
        )

    diff_schema_service.acquire_job_for_application.assert_not_called()
    quarantine_preparer.prepare.assert_not_called()
    persistence_adapter.persist_quarantine.assert_not_called()


def test_persist_job_marks_applying_job_failed_when_import_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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

    diff_schema_service.mark_job_failed.assert_called_once_with(
        job_id="job-1",
        expected_status="applying",
        phase="applying",
        error_type="RuntimeError",
        message="Importer failed.",
    )

    diff_schema_service.mark_job_applied.assert_not_called()


def test_persist_job_does_not_hide_original_error_if_failure_status_fails(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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

    diff_schema_service.mark_job_applied.assert_not_called()


def test_persist_job_uses_explicit_live_schema_override(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_preparer,
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