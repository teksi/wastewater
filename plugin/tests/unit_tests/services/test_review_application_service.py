from __future__ import annotations

from contextlib import contextmanager
from types import SimpleNamespace
from unittest.mock import Mock

import pytest
from teksi_hooks.exceptions import DiffJobEligibilityError, DiffJobStateError

from teksi_wastewater.hooks.services.tww_review_application_service import (
    TwwReviewApplicationService,
)


@contextmanager
def _scope(value):
    yield value


def _service(job):
    diff_schema_service = Mock()
    diff_schema_service.require_review_job.return_value = job
    context_factory = Mock()
    context_factory.source_contexts.return_value = ("base", "incremental")
    persistence_service = Mock()
    persistence_service.persist_job.return_value = "persisted"
    canonical_adapter = Mock()
    canonical_adapter.canonical_model.return_value = "canonical"
    session_manager = Mock()
    session_manager.persistence_scope.side_effect = lambda **_: _scope("sessions")
    service = TwwReviewApplicationService(
        diff_schema_service=diff_schema_service,
        persistence_context_factory=context_factory,
        persistence_service=persistence_service,
        canonical_model_adapter=canonical_adapter,
        validation_definition="validation",
        session_manager=session_manager,
    )
    return service, session_manager, persistence_service


def test_apply_rejects_non_accepted_job() -> None:
    service, _, _ = _service(
        SimpleNamespace(
            job_status="pending",
            validation_success=True,
            metadata={"live_schema": "tww_od"},
        )
    )
    with pytest.raises(DiffJobStateError):
        service.apply_job(job_id="job")


def test_apply_rejects_failed_validation() -> None:
    service, _, _ = _service(
        SimpleNamespace(
            job_status="accepted",
            validation_success=False,
            metadata={"live_schema": "tww_od"},
        )
    )
    with pytest.raises(DiffJobEligibilityError):
        service.apply_job(job_id="job")


def test_apply_uses_incremental_scope_and_persists() -> None:
    job = SimpleNamespace(
        job_status="accepted",
        validation_success=True,
        metadata={
            "live_schema": "tww_od",
            "incremental_import_schema": "tww_app_xtf2pg_incr",
        },
    )
    service, session_manager, persistence_service = _service(job)
    assert service.apply_job(job_id="job") == "persisted"
    session_manager.persistence_scope.assert_called_once_with(
        include_incremental=True,
    )
    persistence_service.persist_job.assert_called_once_with(
        job=job,
        live_schema="tww_od",
        source_contexts=("base", "incremental"),
        canonical_metadata="canonical",
        validation_definition="validation",
        session_context="sessions",
    )
