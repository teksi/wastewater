from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from teksi_hooks.models.canonical_object import CanonicalModelMetadata
from teksi_wastewater.hooks.adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)

from ..helpers import FakeColumn, FakeConnection, FakeConnectionFactory


class CanonicalModelCursor:
    """Return realistic rows for the adapter's four aggregate metadata queries."""

    def __init__(
        self,
        *,
        class_rows: Sequence[Mapping[str, Any]] = (),
        attribute_rows: Sequence[Mapping[str, Any]] = (),
        value_rows: Sequence[Mapping[str, Any]] = (),
        geometry_rows: Sequence[Mapping[str, Any]] = (),
    ) -> None:
        self.class_rows = tuple(dict(row) for row in class_rows)
        self.attribute_rows = tuple(dict(row) for row in attribute_rows)
        self.value_rows = tuple(dict(row) for row in value_rows)
        self.geometry_rows = tuple(dict(row) for row in geometry_rows)
        self.executed_queries: list[tuple[Any, tuple[Any, ...]]] = []
        self.description = None
        self._rows: tuple[tuple[Any, ...], ...] = ()

    def execute(self, query, parameters=()) -> None:
        parameter_values = tuple(parameters or ())
        self.executed_queries.append((query, parameter_values))
        query_text = str(query)

        if "geometry_columns" in query_text:
            rows = self.geometry_rows
        elif "dictionary_od_values" in query_text:
            rows = self.value_rows
        elif "dictionary_od_field" in query_text:
            # The current aggregate query passes the SQL LIKE pattern
            # "%geometry%". It is not a class-id filter.
            rows = tuple(
                row
                for row in self.attribute_rows
                if "geometry"
                not in str(row.get("field_datatype", "")).strip().lower()
            )
        elif "dictionary_od_table" in query_text:
            rows = self.class_rows
        else:
            raise AssertionError(f"Unexpected query: {query_text}")

        self._set_rows(rows)

    def _set_rows(self, rows: Sequence[Mapping[str, Any]]) -> None:
        if not rows:
            self.description = ()
            self._rows = ()
            return
        column_names = tuple(rows[0])
        self.description = tuple(FakeColumn(name=name) for name in column_names)
        self._rows = tuple(
            tuple(row.get(name) for name in column_names)
            for row in rows
        )

    def fetchall(self):
        return list(self._rows)

    def fetchone(self):
        return self._rows[0] if self._rows else None

    def __iter__(self):
        return iter(self._rows)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        return False


def _adapter(
    *,
    class_rows=(),
    attribute_rows=(),
    value_rows=(),
    geometry_rows=(),
    schema: str = "tww_sys",
    reflected_class_ids=frozenset(),
    automap_classes=None,
):
    cursor = CanonicalModelCursor(
        class_rows=class_rows,
        attribute_rows=attribute_rows,
        value_rows=value_rows,
        geometry_rows=geometry_rows,
    )
    factory = FakeConnectionFactory(FakeConnection(cursor))
    adapter = TwwCanonicalModelAdapter(
        connection_factory=factory,
        schema=schema,
        reflected_class_ids=reflected_class_ids,
        automap_classes={} if automap_classes is None else automap_classes,
    )
    return adapter, cursor, factory


def _class_row(class_id="reach", source_id=1):
    return {
        "source_id": source_id,
        "class_id": class_id,
        "name_de": "Haltung",
        "name_fr": "Tronçon",
        "name_it": "Tratta",
        "name_en": "Reach",
    }


def _attribute_row(
    attribute_id="status",
    *,
    class_id="reach",
    source_id=10,
    datatype="integer",
):
    return {
        "source_id": source_id,
        "class_id": class_id,
        "attribute_id": attribute_id,
        "field_datatype": datatype,
        "field_name_de": attribute_id,
        "field_name_fr": attribute_id,
        "field_name_it": attribute_id,
        "field_name_en": attribute_id,
    }


def _geometry_row(attribute_id="progression_geometry", *, class_id="reach"):
    return {
        "class_id": class_id,
        "attribute_id": attribute_id,
        "coord_dimension": 2,
        "srid": 2056,
        "geometry_type": "LINESTRING",
    }


def test_loads_dictionary_classes_and_localizations() -> None:
    adapter, cursor, _ = _adapter(class_rows=(_class_row(),))
    classes = adapter.classes()
    assert classes["reach"].source_id == 1
    assert classes["reach"].localized.names["de"] == "Haltung"
    assert len(cursor.executed_queries) == 4


def test_loads_non_geometry_dictionary_attributes() -> None:
    adapter, _, _ = _adapter(
        class_rows=(_class_row(),),
        attribute_rows=(_attribute_row(),),
    )
    metadata = adapter.attribute_metadata("reach", "status")
    assert metadata is not None
    assert metadata.source_id == 10
    assert metadata.field_datatype == "integer"


def test_loads_geometry_attributes_from_postgis_catalog() -> None:
    adapter, _, _ = _adapter(
        class_rows=(_class_row(),),
        geometry_rows=(_geometry_row(),),
    )
    assert adapter.is_geometry_attribute("reach", "progression_geometry")
    assert adapter.geometry_attribute_names("reach") == (
        "progression_geometry",
    )
    geometry = adapter.geometry_metadata("reach", "progression_geometry")
    assert geometry is not None
    assert geometry.srid == 2056


def test_loads_dictionary_values() -> None:
    adapter, _, _ = _adapter(
        class_rows=(_class_row(),),
        value_rows=(
            {
                "source_id": 100,
                "class_id": "reach",
                "attribute_id": "status",
                "value_id": "active",
                "value_name_de": "aktiv",
                "value_name_fr": "actif",
                "value_name_it": "attivo",
                "value_name_en": "active",
            },
        ),
    )
    value = adapter.value_metadata("reach", "status", "active")
    assert value is not None
    assert value.source_id == 100
    assert value.localized.names["de"] == "aktiv"


def test_builds_and_caches_complete_model() -> None:
    adapter, cursor, factory = _adapter(
        class_rows=(_class_row(),),
        attribute_rows=(_attribute_row(),),
        geometry_rows=(_geometry_row(),),
    )
    first = adapter.canonical_model()
    second = adapter.canonical_model()
    assert isinstance(first, CanonicalModelMetadata)
    assert second is first
    assert ("reach", "status") in first.attributes
    assert ("reach", "progression_geometry") in first.attributes
    assert len(cursor.executed_queries) == 4
    assert factory.autocommit_values == [True, True, True, True]


def test_custom_dictionary_schema_does_not_change_live_geometry_schema() -> None:
    adapter, cursor, _ = _adapter(schema="custom_sys")
    adapter.canonical_model()
    combined = "\n".join(str(query) for query, _ in cursor.executed_queries)
    assert "custom_sys" in combined
    geometry_parameters = cursor.executed_queries[-1][1]
    assert geometry_parameters == ("tww_od",)


class FakeIntegerType:
    python_type = int


class FakeOrmColumn:
    name = "fk_reach"
    key = "fk_reach"
    type = FakeIntegerType()


class FakeTable:
    name = "agxx_reach"
    columns = (FakeOrmColumn(),)


class FakeMappedClass:
    __table__ = FakeTable()


def test_dictionary_source_ids_override_reflected_source_ids() -> None:
    adapter, _, _ = _adapter(
        class_rows=(_class_row("agxx_reach", 42),),
        attribute_rows=(
            _attribute_row(
                "fk_reach",
                class_id="agxx_reach",
                source_id=87,
                datatype="uuid",
            ),
        ),
        reflected_class_ids=frozenset({"agxx_reach"}),
        automap_classes={"agxx_reach": FakeMappedClass},
    )
    metadata = adapter.canonical_model()
    assert metadata.classes["agxx_reach"].source_id == 42
    assert metadata.attributes[("agxx_reach", "fk_reach")].source_id == 87
