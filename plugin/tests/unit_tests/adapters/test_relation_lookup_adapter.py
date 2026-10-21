from __future__ import annotations

from teksi_hooks.models.canonical_object import (
    CanonicalObjectIdentity,
)
from teksi_wastewater.hooks.adapters.tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)

from ..helpers import (
    FakeConnectionFactory,
    FakeCursor,
    FakeQueryResult,
    fake_connection_factory,
)


def _adapter(
    *,
    results: tuple[
        FakeQueryResult,
        ...,
    ] = (),
    schema: str = "tww_od",
) -> tuple[
    TwwRelationLookupAdapter,
    FakeCursor,
    FakeConnectionFactory,
]:
    connection_factory, cursor = fake_connection_factory(
        results=results,
    )

    adapter = TwwRelationLookupAdapter(
        connection_factory=connection_factory,
        schema=schema,
    )

    return (
        adapter,
        cursor,
        connection_factory,
    )


def test_tww_relation_lookup_adapter_returns_canonical_identities() -> None:
    adapter, cursor, connection_factory = _adapter(
        schema="tww_app",
        results=(
            FakeQueryResult(
                column_names=("obj_id",),
                rows=(("ch000000ws000001",),),
            ),
        ),
    )

    objects = adapter.canonical_objects(
        local_class_id="wastewater_networkelement",
        related_class_id="wastewater_structure",
        local_attribute="fk_wastewater_structure",
        related_attribute="obj_id",
        value="ch000000ws000001",
    )

    assert (
        len(
            objects,
        )
        == 1
    )

    assert objects[0].class_id == ("wastewater_structure")

    assert objects[0].attributes == {
        "obj_id": "ch000000ws000001",
    }

    assert (
        len(
            cursor.executed_queries,
        )
        == 1
    )

    assert connection_factory.autocommit_values == [
        True,
    ]


def test_tww_relation_lookup_adapter_returns_empty_tuple_without_matches() -> None:
    adapter, cursor, connection_factory = _adapter(
        schema="tww_app",
        results=(
            FakeQueryResult(
                column_names=("obj_id",),
                rows=(),
            ),
        ),
    )

    objects = adapter.canonical_objects(
        local_class_id="wastewater_networkelement",
        related_class_id="wastewater_structure",
        local_attribute="fk_wastewater_structure",
        related_attribute="obj_id",
        value="missing",
    )

    assert objects == ()

    assert (
        len(
            cursor.executed_queries,
        )
        == 1
    )

    assert connection_factory.autocommit_values == [
        True,
    ]


def test_tww_relation_lookup_adapter_current_object_returns_none_without_match() -> None:
    adapter, cursor, connection_factory = _adapter(
        results=(
            FakeQueryResult(
                column_names=(
                    "obj_id",
                    "status",
                    "last_modification",
                ),
                rows=(),
            ),
        ),
    )

    current = adapter.current_object(
        CanonicalObjectIdentity(
            class_id="wastewater_structure",
            attributes={
                "obj_id": "ch000000ws000001",
            },
        )
    )

    assert current is None

    assert (
        len(
            cursor.executed_queries,
        )
        == 1
    )

    assert connection_factory.autocommit_values == [
        True,
    ]


def test_tww_relation_lookup_adapter_current_object_returns_canonical_object() -> None:
    adapter, cursor, _ = _adapter(
        results=(
            FakeQueryResult(
                column_names=(
                    "obj_id",
                    "status",
                    "fk_provider",
                    "last_modification",
                ),
                rows=(
                    (
                        "ch000000ws000001",
                        "operational",
                        "ch000000provider1",
                        "2026-01-01T12:00:00",
                    ),
                ),
            ),
        ),
    )

    identity = CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={
            "obj_id": "ch000000ws000001",
        },
    )

    current = adapter.current_object(
        identity,
    )

    assert current is not None
    assert current.identity == identity

    assert current.values == {
        "status": "operational",
        "fk_provider": "ch000000provider1",
    }

    assert current.last_modification == "2026-01-01T12:00:00"

    query, parameters = cursor.executed_queries[0]

    assert "wastewater_structure" in str(
        query,
    )

    assert parameters == ("ch000000ws000001",)


def test_tww_relation_lookup_adapter_current_object_excludes_identity_attributes() -> None:
    adapter, _, _ = _adapter(
        results=(
            FakeQueryResult(
                column_names=(
                    "obj_id",
                    "identifier",
                    "status",
                    "last_modification",
                ),
                rows=(
                    (
                        "ch000000ws000001",
                        "abc",
                        "operational",
                        "2026-01-01T12:00:00",
                    ),
                ),
            ),
        ),
    )

    identity = CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={
            "obj_id": "ch000000ws000001",
            "identifier": "abc",
        },
    )

    current = adapter.current_object(
        identity,
    )

    assert current is not None
    assert current.identity == identity

    assert current.values == {
        "status": "operational",
    }

    assert current.last_modification == "2026-01-01T12:00:00"


def test_tww_relation_lookup_adapter_current_object_uses_first_row() -> None:
    adapter, _, _ = _adapter(
        results=(
            FakeQueryResult(
                column_names=(
                    "obj_id",
                    "status",
                    "last_modification",
                ),
                rows=(
                    (
                        "ch000000ws000001",
                        "first",
                        "2026-01-01T12:00:00",
                    ),
                    (
                        "ch000000ws000001",
                        "second",
                        "2026-01-02T12:00:00",
                    ),
                ),
            ),
        ),
    )

    current = adapter.current_object(
        CanonicalObjectIdentity(
            class_id="wastewater_structure",
            attributes={
                "obj_id": "ch000000ws000001",
            },
        )
    )

    assert current is not None
    assert current.values["status"] == "first"

    assert current.last_modification == "2026-01-01T12:00:00"


def test_tww_relation_lookup_adapter_current_object_supports_non_obj_id_identity() -> None:
    adapter, cursor, _ = _adapter(
        results=(
            FakeQueryResult(
                column_names=(
                    "identifier",
                    "status",
                    "last_modification",
                ),
                rows=(
                    (
                        "external-1",
                        "operational",
                        "2026-01-01T12:00:00",
                    ),
                ),
            ),
        ),
    )

    identity = CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={
            "identifier": "external-1",
        },
    )

    current = adapter.current_object(
        identity,
    )

    assert current is not None
    assert current.identity == identity

    assert current.values == {
        "status": "operational",
    }

    assert current.last_modification == "2026-01-01T12:00:00"

    query, parameters = cursor.executed_queries[0]

    assert "identifier" in str(
        query,
    )

    assert parameters == ("external-1",)
