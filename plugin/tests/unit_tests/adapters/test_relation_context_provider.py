from __future__ import annotations
from unittest.mock import Mock, patch
from teksi_wastewater.hooks.adapters.tww_relation_context_provider import TwwRelationContextProvider,MappingProjectionMode


def _provider(classes=()):
    return TwwRelationContextProvider(quarantine_classes=classes,model_mapping=Mock(),canonical_model_adapter=Mock(),projection_mode=MappingProjectionMode.FULL)


def test_empty_classes_return_empty_tuple():
    assert _provider(()).relation_contexts() == ()


def test_relation_contexts_are_cached():
    provider=_provider(())
    with patch.object(provider,'_build_relation_contexts',return_value=(Mock(),)) as build:
        first=provider.relation_contexts(); second=provider.relation_contexts()
    assert first is second
    build.assert_called_once()


def test_clear_cache_forces_rebuild():
    provider=_provider(())
    provider._relation_contexts_cache=()
    provider.clear_cache()
    assert provider._relation_contexts_cache is None
