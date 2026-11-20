from __future__ import annotations

from unittest.mock import Mock

from teksi_wastewater.hooks.adapters.tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)


def test_constructor_uses_session_manager():
    manager = Mock()
    adapter = TwwRelationLookupAdapter(schema="tww_od", session_manager=manager)
    assert adapter.schema == "tww_od"
    assert adapter.session_manager is manager


def test_clear_cache():
    adapter = TwwRelationLookupAdapter(schema="tww_od", session_manager=Mock())
    adapter._canonical_objects_cache[("reach", "obj_id")] = ()
    adapter.clear_cache()
    assert adapter._canonical_objects_cache == {}
