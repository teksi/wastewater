from __future__ import annotations

from pathlib import Path
from unittest.mock import Mock

from teksi_wastewater.hooks.adapters.tww_quarantine_runner import TwwQuarantineRunner


def _runner():
    return TwwQuarantineRunner(
        canonical_model_adapter=Mock(),
        importer_exporter=Mock(),
        interlis_tools=Mock(),
        canonical_projection_lookup=Mock(),
        incremental_effect_evaluator=Mock(),
        incremental_effect_persister=Mock(),
    )


def test_log_path_sanitizes_model_name():
    path = _runner()._validation_log_path(log_path=Path("/tmp/import.log"), model_name="A/B:C")
    assert path.name == "import_A_B_C.log"


def test_validate_success_is_empty():
    runner = _runner()
    runner.interlis_tools.run_ilivalidator = Mock(return_value=None)
    assert (
        runner.validate_quarantine(model_names=(), log_path=Path("/tmp/x.log"), schema="q") == ()
    )
