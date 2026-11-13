from __future__ import annotations

from pathlib import Path
from unittest.mock import Mock

from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)


def _adapter():
    adapter = TwwInterlisServiceAdapter.__new__(TwwInterlisServiceAdapter)
    adapter._connection_factory = Mock()
    adapter._importer_exporter = Mock()
    return adapter


def test_identify_model_delegates() -> None:
    adapter = _adapter()
    expected = Mock()
    adapter._importer_exporter.identify_import_model.return_value = expected
    assert adapter.identify_model(Path("a.xtf")) is expected


def test_find_models_delegates_current_method() -> None:
    adapter = _adapter()
    adapter._importer_exporter.find_import_selection_models.return_value = (
        "M",
        ("M",),
    )
    assert adapter.find_models(Path("a.xtf")) == ("M", ("M",))


def test_tww_context_applies_supported_importer_options() -> None:
    context = TwwInterlisContext(
        schema="q",
        import_orgs=False,
        allow_schema_recreation=True,
    )
    importer = Mock()
    context.apply(importer)
    assert importer.schema == "q"
    # Schema recreation is consumed by the surrounding quarantine workflow;
    # TwwInterlisContext does not expose it as an importer attribute.
    assert context.allow_schema_recreation is True
