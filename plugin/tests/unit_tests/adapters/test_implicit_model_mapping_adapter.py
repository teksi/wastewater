from __future__ import annotations

import pytest

from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ModelMapping,
    ValueMapping,
)

from teksi_wastewater.hooks.adapters.tww_implicit_model_mapping_adapter import (
    TwwImplicitModelMappingAdapter,
)

from ..helpers import (
    FakeQueryResult,
    fake_connection_factory,
)


ATTRIBUTE_QUERY_RESULT = FakeQueryResult(
    column_names=(
        "canonical_class_id",
        "canonical_attr_id",
        "ili_class_name",
        "ili_attribute_name",
    ),
    rows=(
        (
            "wastewater_structure",
            "status",
            "Abwasserbauwerk",
            "Status",
        ),
        (
            "reach",
            "progression_geometry",
            "Haltung",
            "Geometrie",
        ),
        (
            "reach",
            "obj_id",
            "Haltung",
            "ObjektID",
        ),
        (
            "ignored_table",
            "ignored_field",
            None,
            "IgnoredAttribute",
        ),
        (
            "ignored_table",
            "ignored_field",
            "IgnoredClass",
            None,
        ),
    ),
)


VALUE_QUERY_RESULT = FakeQueryResult(
    column_names=(
        "ili_class_name",
        "ili_attribute_name",
        "ili_value_name",
        "canonical_value_id",
        "canonical_value_name",
    ),
    rows=(
        (
            "Abwasserbauwerk",
            "Status",
            "in_Betrieb",
            1234,
            "operational",
        ),
        (
            "Abwasserbauwerk",
            "Status",
            None,
            9999,
            "ignored",
        ),
    ),
)


CLASS_QUERY_RESULT = FakeQueryResult(
    column_names=(
        "canonical_class_id",
        "ili_class_name",
    ),
    rows=(
        (
            "wastewater_structure",
            "Abwasserbauwerk",
        ),
        (
            "reach",
            "Haltung",
        ),
        (
            "ignored_table",
            None,
        ),
    ),
)


@pytest.fixture
def implicit_mapping_adapter():
    connection_factory, cursor = fake_connection_factory(
        results=(
            ATTRIBUTE_QUERY_RESULT,
            VALUE_QUERY_RESULT,
            CLASS_QUERY_RESULT,
        )
    )

    adapter = TwwImplicitModelMappingAdapter(
        connection_factory=connection_factory,
        language="de",
        import_schema="xtf_import",
    )

    return (
        adapter,
        cursor,
        connection_factory,
    )


def test_implicit_model_mapping_loads_model_mapping(
    implicit_mapping_adapter,
) -> None:
    (
        adapter,
        cursor,
        connection_factory,
    ) = implicit_mapping_adapter

    mapping = adapter.model_mapping()

    assert isinstance(
        mapping,
        ModelMapping,
    )

    assert mapping.is_ssot is False

    assert set(
        mapping.classes,
    ) == {
        "Abwasserbauwerk",
        "Haltung",
    }

    wastewater_structure = mapping.classes[
        "Abwasserbauwerk"
    ]

    assert isinstance(
        wastewater_structure,
        ClassMapping,
    )

    assert (
        wastewater_structure.canonical_class_id
        == "wastewater_structure"
    )

    assert set(
        wastewater_structure.attributes,
    ) == {
        "Status",
    }

    status = wastewater_structure.attributes[
        "Status"
    ]

    assert isinstance(
        status,
        AttributeMapping,
    )

    assert (
        status.canonical_class_id
        == "wastewater_structure"
    )

    assert status.canonical_attr_id == "status"

    assert status.values == {
        "in_Betrieb": ValueMapping(
            canonical_value_id=1234,
            value="operational",
        ),
    }

    reach = mapping.classes[
        "Haltung"
    ]

    assert reach.canonical_class_id == "reach"

    assert set(
        reach.attributes,
    ) == {
        "Geometrie",
        "ObjektID",
    }

    assert (
        reach.attributes[
            "Geometrie"
        ].canonical_attr_id
        == "progression_geometry"
    )

    assert (
        reach.attributes[
            "ObjektID"
        ].canonical_attr_id
        == "obj_id"
    )

    assert len(
        cursor.executed_queries,
    ) == 3

    assert connection_factory.autocommit_values == [
        True,
        True,
        True,
    ]


def test_implicit_model_mapping_rejects_unknown_language() -> None:
    connection_factory, _ = fake_connection_factory(
        results=(),
    )

    with pytest.raises(
        ValueError,
        match="Unsupported language",
    ):
        TwwImplicitModelMappingAdapter(
            connection_factory=connection_factory,
            language="es",
        )


def test_implicit_model_mapping_class_definition(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    class_mapping = adapter.class_definition(
        "Abwasserbauwerk",
    )

    assert (
        class_mapping.canonical_class_id
        == "wastewater_structure"
    )


def test_implicit_model_mapping_class_definition_raises_for_unknown_class(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    with pytest.raises(
        KeyError,
        match="Unknown class",
    ):
        adapter.class_definition(
            "DoesNotExist",
        )


def test_implicit_model_mapping_try_class_definition_returns_none(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    assert (
        adapter.try_class_definition(
            "DoesNotExist",
        )
        is None
    )


def test_implicit_model_mapping_attribute_definition(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    attribute_mapping = adapter.attribute_definition(
        "Abwasserbauwerk",
        "Status",
    )

    assert (
        attribute_mapping.canonical_class_id
        == "wastewater_structure"
    )

    assert (
        attribute_mapping.canonical_attr_id
        == "status"
    )


def test_implicit_model_mapping_attribute_definition_raises_for_unknown_attribute(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    with pytest.raises(
        KeyError,
        match="Unknown attribute",
    ):
        adapter.attribute_definition(
            "Abwasserbauwerk",
            "Missing",
        )


def test_implicit_model_mapping_try_attribute_definition_returns_none(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    assert (
        adapter.try_attribute_definition(
            "Abwasserbauwerk",
            "Missing",
        )
        is None
    )

    assert (
        adapter.try_attribute_definition(
            "DoesNotExist",
            "Status",
        )
        is None
    )


def test_implicit_model_mapping_value_mapping(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    value_mapping = adapter.value_mapping(
        "Abwasserbauwerk",
        "Status",
        "in_Betrieb",
    )

    assert value_mapping == ValueMapping(
        canonical_value_id=1234,
        value="operational",
    )


def test_implicit_model_mapping_value_mapping_raises_for_unknown_value(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    with pytest.raises(
        KeyError,
        match="Unknown value",
    ):
        adapter.value_mapping(
            "Abwasserbauwerk",
            "Status",
            "missing_value",
        )


def test_implicit_model_mapping_try_value_mapping_returns_none(
    implicit_mapping_adapter,
) -> None:
    adapter, _, _ = implicit_mapping_adapter

    assert (
        adapter.try_value_mapping(
            "Abwasserbauwerk",
            "Status",
            "missing_value",
        )
        is None
    )

    assert (
        adapter.try_value_mapping(
            "Abwasserbauwerk",
            "Missing",
            "in_Betrieb",
        )
        is None
    )


def test_implicit_model_mapping_returns_cached_mapping(
    implicit_mapping_adapter,
) -> None:
    adapter, cursor, _ = implicit_mapping_adapter

    first = adapter.model_mapping()
    second = adapter.model_mapping()

    assert second is first

    assert len(
        cursor.executed_queries,
    ) == 3