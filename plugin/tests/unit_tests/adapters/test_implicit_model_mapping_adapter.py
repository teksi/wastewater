from __future__ import annotations

from unittest.mock import Mock, patch

import pytest
from teksi_wastewater.hooks.adapters.tww_implicit_model_mapping_adapter import (
    TwwImplicitModelMappingAdapter,
    TwwLanguage,
)


def test_rejects_unknown_language():
    with pytest.raises(ValueError):
        TwwImplicitModelMappingAdapter(
            import_schema="q", quarantine_session=Mock(), live_session=Mock(), language="it"
        )


def test_rejects_empty_import_schema():
    with pytest.raises(ValueError, match="must not be empty"):
        TwwImplicitModelMappingAdapter(
            import_schema=" ", quarantine_session=Mock(), live_session=Mock()
        )


def test_requires_borrowed_sessions():
    with pytest.raises(RuntimeError, match="quarantine session"):
        TwwImplicitModelMappingAdapter(
            import_schema="q", quarantine_session=None, live_session=Mock()
        )
    with pytest.raises(RuntimeError, match="live session"):
        TwwImplicitModelMappingAdapter(
            import_schema="q", quarantine_session=Mock(), live_session=None
        )


def test_materialized_mapping_is_cached():
    sentinel = Mock()
    with patch.object(
        TwwImplicitModelMappingAdapter, "_load_model_mapping", return_value=sentinel
    ) as load:
        adapter = TwwImplicitModelMappingAdapter(
            import_schema="q",
            quarantine_session=Mock(),
            live_session=Mock(),
            language=TwwLanguage.DE,
        )
    assert adapter.materialize() is sentinel
    assert adapter.model_mapping() is sentinel
    load.assert_called_once()
