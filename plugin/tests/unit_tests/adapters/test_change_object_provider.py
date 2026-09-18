from __future__ import annotations

from datetime import UTC, datetime

from teksi_hooks.capabilities.relation_lookup import (
    InMemoryRelationLookupCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObject,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.validation import (
    Change,
    ChangeOperation,
)
from teksi_wastewater.hooks.adapters.tww_change_object_provider import (
    TwwChangeObjectProvider,
)


def _identity(
    *,
    class_id: str = "reach",
    obj_id: str = "ch000000re000001",
) -> CanonicalObjectIdentity:
    return CanonicalObjectIdentity(
        class_id=class_id,
        attributes={
            "obj_id": obj_id,
        },
    )


def _change(
    *,
    class_id: str = "reach",
    obj_id: str = "ch000000re000001",
    old_values=None,
    new_values=None,
    operation: ChangeOperation = ChangeOperation.UPDATE,
) -> Change:
    return Change(
        table_name=class_id,
        object_id=obj_id,
        operation=operation,
        old_values=dict(
            old_values or {},
        ),
        new_values=dict(
            new_values or {},
        ),
    )


def _object(
    *,
    class_id: str = "reach",
    obj_id: str = "ch000000re000001",
    values=None,
) -> CanonicalObject:
    return CanonicalObject(
        identity=_identity(
            class_id=class_id,
            obj_id=obj_id,
        ),
        values=dict(
            values or {},
        ),
        last_modification=datetime(
            2026,
            1,
            1,
            tzinfo=UTC,
        ),
    )


def test_tww_change_object_provider_returns_old_object_from_live_lookup() -> None:
    canonical_object = _object(
        values={
            "obj_id": "ch000000re000001",
            "identifier": "old reach",
            "status": "old",
        },
    )

    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(canonical_object,),
        ),
    )

    change = _change(
        old_values={
            "identifier": "old reach",
        },
        new_values={
            "identifier": "new reach",
        },
    )

    result = provider.old_object(
        change,
    )

    assert result == canonical_object


def test_tww_change_object_provider_returns_none_when_old_object_is_missing() -> None:
    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
    )

    change = _change(
        old_values={
            "identifier": "old reach",
        },
        new_values={
            "identifier": "new reach",
        },
    )

    assert (
        provider.old_object(
            change,
        )
        is None
    )


def test_tww_change_object_provider_builds_new_object_from_change_values() -> None:
    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
    )

    change = _change(
        new_values={
            "obj_id": "ch000000re000001",
            "identifier": "new reach",
            "status": "new",
        },
    )

    result = provider.new_object(
        change,
    )

    assert result == CanonicalObject(
        identity=change.identity,
        values={
            "obj_id": "ch000000re000001",
            "identifier": "new reach",
            "status": "new",
        },
    )


def test_tww_change_object_provider_prefers_new_lookup_when_available() -> None:
    projected_object = _object(
        values={
            "obj_id": "ch000000re000001",
            "identifier": "projected reach",
            "status": "projected",
        },
    )

    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
        new_lookup=InMemoryRelationLookupCapability(
            objects=(projected_object,),
        ),
    )

    change = _change(
        new_values={
            "identifier": "new reach from change",
        },
    )

    result = provider.new_object(
        change,
    )

    assert result == projected_object


def test_tww_change_object_provider_falls_back_to_change_values_when_new_lookup_misses() -> None:
    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
        new_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
    )

    change = _change(
        new_values={
            "identifier": "new reach",
            "status": "new",
        },
    )

    result = provider.new_object(
        change,
    )

    assert result == CanonicalObject(
        identity=change.identity,
        values={
            "identifier": "new reach",
            "status": "new",
        },
    )


def test_tww_change_object_provider_uses_change_identity_for_new_object() -> None:
    provider = TwwChangeObjectProvider(
        live_lookup=InMemoryRelationLookupCapability(
            objects=(),
        ),
    )

    change = _change(
        class_id="wastewater_structure",
        obj_id="ch000000ws000001",
        operation=ChangeOperation.INSERT,
        new_values={
            "identifier": "new structure",
        },
    )

    result = provider.new_object(
        change,
    )

    assert result is not None
    assert result.identity == CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={
            "obj_id": "ch000000ws000001",
        },
    )
    assert result.values == {
        "identifier": "new structure",
    }
