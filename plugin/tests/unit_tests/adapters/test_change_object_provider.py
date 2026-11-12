from __future__ import annotations

from datetime import UTC, datetime

from teksi_hooks.models.canonical_object import CanonicalObject
from teksi_hooks.models.validation import Change, ChangeOperation
from teksi_wastewater.hooks.adapters.tww_change_object_provider import (
    TwwChangeObjectProvider,
    TwwChangeObjectProviderFactory,
)


def _change(operation: ChangeOperation, *, old_values=None, new_values=None) -> Change:
    return Change(
        table_name="reach",
        object_id="ch000000re000001",
        operation=operation,
        old_values=dict(old_values or {}),
        new_values=dict(new_values or {}),
    )


def test_insert_has_no_old_object() -> None:
    assert (
        TwwChangeObjectProvider().old_object(
            _change(ChangeOperation.INSERT, new_values={"identifier": "new"})
        )
        is None
    )


def test_update_builds_old_and_new_objects_from_change_state() -> None:
    timestamp = datetime(2026, 1, 1, tzinfo=UTC)
    change = _change(
        ChangeOperation.UPDATE,
        old_values={"identifier": "old", "last_modification": timestamp},
        new_values={"identifier": "new", "last_modification": timestamp},
    )
    provider = TwwChangeObjectProvider()
    assert provider.old_object(change) == CanonicalObject(
        identity=change.identity,
        values=dict(change.old_values),
        last_modification=timestamp,
    )
    assert provider.new_object(change) == CanonicalObject(
        identity=change.identity,
        values=dict(change.new_values),
        last_modification=timestamp,
    )


def test_delete_has_no_new_object() -> None:
    assert (
        TwwChangeObjectProvider().new_object(
            _change(ChangeOperation.DELETE, old_values={"identifier": "old"})
        )
        is None
    )


def test_factory_is_stateless_and_ignores_schema_arguments() -> None:
    provider = TwwChangeObjectProviderFactory().change_object_provider(
        live_schema="tww_od",
        import_schema="tww_app_xtf2pg",
        canonical_metadata=None,
    )
    assert isinstance(provider, TwwChangeObjectProvider)
