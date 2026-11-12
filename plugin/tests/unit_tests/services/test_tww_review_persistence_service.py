from __future__ import annotations
from unittest.mock import Mock
from teksi_wastewater.hooks.services.tww_review_persistence_service import TwwReviewPersistenceService,TwwQuarantineBackup,TwwPersistenceRecoveryState


def test_constructor_uses_factory_based_current_contract():
    service=TwwReviewPersistenceService(diff_schema_service=Mock(),backup_service=Mock(),persistence_adapter=Mock())
    assert service.diff_schema_service is not None
    assert service.backup_service is not None
    assert service.persistence_adapter is not None


def test_recovery_state_starts_empty():
    state=TwwPersistenceRecoveryState(job_id='job')
    assert state.job_id == 'job'
    assert state.completed_source_roles == [] or state.completed_source_roles == ()
