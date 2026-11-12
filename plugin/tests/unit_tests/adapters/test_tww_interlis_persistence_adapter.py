from __future__ import annotations
from unittest.mock import Mock
import pytest
from teksi_wastewater.hooks.adapters.tww_interlis_persistence_adapter import TwwInterlisPersistenceAdapter


def _adapter():
    return TwwInterlisPersistenceAdapter(quarantine_runner=Mock(),source_runtime_contexts={})


def test_assert_incremental_ready_requires_context():
    with pytest.raises(RuntimeError):
        _adapter().assert_incremental_ready(source_role='incremental')


def test_base_role_does_not_require_incremental_context():
    _adapter().assert_incremental_ready(source_role='base')
