from __future__ import annotations
from teksi_hooks.models.canonical_object import CanonicalObjectIdentity
from teksi_hooks.models.validation import Change, ChangeOperation
from teksi_wastewater.hooks.adapters.tww_change_object_provider import TwwChangeObjectProvider, TwwChangeObjectProviderFactory


def _change(operation, old_values=None, new_values=None):
    change=Change.__new__(Change)
    object.__setattr__(change,'operation',operation)
    object.__setattr__(change,'identity',CanonicalObjectIdentity(class_id='reach',attributes={'obj_id':'oid'}))
    object.__setattr__(change,'old_values',dict(old_values or {}))
    object.__setattr__(change,'new_values',dict(new_values or {}))
    return change


def test_insert_has_no_old_object():
    assert TwwChangeObjectProvider().old_object(_change(ChangeOperation.INSERT)) is None


def test_update_uses_change_values():
    change=_change(ChangeOperation.UPDATE,{'identifier':'old'},{'identifier':'new'})
    provider=TwwChangeObjectProvider()
    assert provider.old_object(change).values == {'identifier':'old'}
    assert provider.new_object(change).values == {'identifier':'new'}


def test_delete_has_no_new_object():
    assert TwwChangeObjectProvider().new_object(_change(ChangeOperation.DELETE)) is None


def test_factory_is_stateless():
    assert isinstance(TwwChangeObjectProviderFactory().change_object_provider(live_schema='tww_od',import_schema='q',canonical_metadata=None),TwwChangeObjectProvider)
