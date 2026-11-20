from __future__ import annotations

from unittest.mock import Mock

from teksi_wastewater.hooks.adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)


def test_constructor_uses_runner_and_runtime_contexts():
    runner = Mock()
    contexts = {"base": Mock(), "incremental": Mock()}
    adapter = TwwInterlisPersistenceAdapter(
        quarantine_runner=runner,
        source_runtime_contexts=contexts,
    )
    assert adapter.quarantine_runner is runner
    assert adapter.source_runtime_contexts is contexts
