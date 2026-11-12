from __future__ import annotations

from unittest.mock import Mock

from teksi_wastewater.hooks.services.tww_review_persistence_service import (
    TwwPersistenceRecoveryState,
    TwwReviewPersistenceService,
)


def test_constructor_uses_factory_based_current_contract():
    service = TwwReviewPersistenceService(
        diff_schema_service=Mock(), backup_service=Mock(), persistence_adapter=Mock()
    )
    assert service.diff_schema_service is not None
    assert service.backup_service is not None
    assert service.persistence_adapter is not None


def test_recovery_state_accepts_complete_persisted_state():
    state = TwwPersistenceRecoveryState(
        job_id="job",
        phase="not_started",
        active_source_role=None,
        active_import_schema=None,
        completed_source_roles=(),
        prepared_import_schemas=(),
        backups=(),
    )
    assert state.job_id == "job"
    assert state.completed_source_roles == ()
