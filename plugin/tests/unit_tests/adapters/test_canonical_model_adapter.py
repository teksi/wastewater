from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any
from unittest.mock import Mock

from teksi_hooks.models.canonical_object import (
    CanonicalAttributeMetadata,
    CanonicalClassMetadata,
    CanonicalModelMetadata,
    CanonicalValueMetadata,
    LocalizedMetadata,
)

from teksi_wastewater.hooks.adapters import (
    tww_canonical_model_adapter as adapter_module,
)
from teksi_wastewater.hooks.adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
    TwwLanguage,
)

from ..helpers import (
    FakeColumn,
    FakeConnection,
    FakeConnectionFactory,
)


class CanonicalModelCursor:
    """
    Fake cursor routing dictionary queries to configured rows.
    """

    def __init__(
        self,
        *,
        class_rows: Sequence[
            Mapping[
                str,
                Any,
            ]
        ] = (),
        attribute_rows: Sequence[
            Mapping[
                str,
                Any,
            ]
        ] = (),
        value_rows: Sequence[
            Mapping[
                str,
                Any,
            ]
        ] = (),
    ) -> None:
        self.class_rows = tuple(
            dict(
                row,
            )
            for row in class_rows
        )

        self.attribute_rows = tuple(
            dict(
                row,
            )
            for row in attribute_rows
        )

        self.value_rows = tuple(
            dict(
                row,
            )
            for row in value_rows
        )

        self.executed_queries: list[
            tuple[
                Any,
                tuple[
                    Any,
                    ...,
                ],
            ]
        ] = []

        self.description: tuple[
            FakeColumn,
            ...,
        ] | None = None

        self._rows: tuple[
            tuple[
                Any,
                ...,
            ],
            ...,
        ] = ()

    def execute(
        self,
        query,
        parameters=(),
    ) -> None:
        parameter_values = tuple(
            parameters or (),
        )

        self.executed_queries.append(
            (
                query,
                parameter_values,
            )
        )

        query_text = str(
            query,
        )

        source_rows = self._source_rows(
            query_text,
        )

        selected_rows = self._filtered_rows(
            query_text=query_text,
            parameters=parameter_values,
            rows=source_rows,
        )

        self._set_rows(
            selected_rows,
        )

    def fetchall(
        self,
    ) -> list[
        tuple[
            Any,
            ...,
        ]
    ]:
        return list(
            self._rows,
        )

    def fetchone(
        self,
    ) -> tuple[
        Any,
        ...,
    ] | None:
        if not self._rows:
            return None

        return self._rows[
            0
        ]

    def _source_rows(
        self,
        query_text: str,
    ) -> tuple[
        dict[
            str,
            Any,
        ],
        ...,
    ]:
        if "dictionary_od_values" in query_text:
            return self.value_rows

        if "dictionary_od_field" in query_text:
            return self.attribute_rows

        if "dictionary_od_table" in query_text:
            return self.class_rows

        raise AssertionError(
            f"Unexpected query: {query_text}"
        )

    def _filtered_rows(
        self,
        *,
        query_text: str,
        parameters: tuple[
            Any,
            ...,
        ],
        rows: Sequence[
            dict[
                str,
                Any,
            ]
        ],
    ) -> tuple[
        dict[
            str,
            Any,
        ],
        ...,
    ]:
        if not parameters:
            return tuple(
                rows,
            )

        if "dictionary_od_values" in query_text:
            return self._filtered_value_rows(
                parameters=parameters,
                rows=rows,
            )

        if "dictionary_od_field" in query_text:
            return self._filtered_attribute_rows(
                parameters=parameters,
                rows=rows,
            )

        if "dictionary_od_table" in query_text:
            return tuple(
                row
                for row in rows
                if row.get(
                    "class_id",
                )
                == parameters[0]
            )

        return tuple(
            rows,
        )

    def _filtered_attribute_rows(
        self,
        *,
        parameters: tuple[
            Any,
            ...,
        ],
        rows: Sequence[
            dict[
                str,
                Any,
            ]
        ],
    ) -> tuple[
        dict[
            str,
            Any,
        ],
        ...,
    ]:
        class_id = parameters[
            0
        ]

        attribute_id = (
            parameters[
                1
            ]
            if len(
                parameters,
            ) > 1
            else None
        )

        return tuple(
            row
            for row in rows
            if row.get(
                "class_id",
            )
            == class_id
            and (
                attribute_id is None
                or row.get(
                    "attribute_id",
                )
                == attribute_id
            )
        )

    def _filtered_value_rows(
        self,
        *,
        parameters: tuple[
            Any,
            ...,
        ],
        rows: Sequence[
            dict[
                str,
                Any,
            ]
        ],
    ) -> tuple[
        dict[
            str,
            Any,
        ],
        ...,
    ]:
        class_id = parameters[
            0
        ]

        attribute_id = (
            parameters[
                1
            ]
            if len(
                parameters,
            ) > 1
            else None
        )

        value_id = (
            parameters[
                2
            ]
            if len(
                parameters,
            ) > 2
            else None
        )

        return tuple(
            row
            for row in rows
            if row.get(
                "class_id",
            )
            == class_id
            and (
                attribute_id is None
                or row.get(
                    "attribute_id",
                )
                == attribute_id
            )
            and (
                value_id is None
                or row.get(
                    "value_id",
                )
                == value_id
            )
        )

    def _set_rows(
        self,
        rows: Sequence[
            dict[
                str,
                Any,
            ]
        ],
    ) -> None:
        if not rows:
            self.description = ()
            self._rows = ()
            return

        column_names = tuple(
            rows[
                0
            ]
        )

        self.description = tuple(
            FakeColumn(
                name=column_name,
            )
            for column_name in column_names
        )

        self._rows = tuple(
            tuple(
                row.get(
                    column_name,
                )
                for column_name in column_names
            )
            for row in rows
        )


class FakeIntegerType:
    python_type = int


class FakeOrmColumn:
    name = "fk_reach"
    key = "fk_reach"
    type = FakeIntegerType()


class FakeTable:
    name = "agxx_reach"
    columns = (
        FakeOrmColumn(),
    )


class FakeMappedClass:
    __table__ = FakeTable()


def _adapter(
    *,
    class_rows: Sequence[
        Mapping[
            str,
            Any,
        ]
    ] = (),
    attribute_rows: Sequence[
        Mapping[
            str,
            Any,
        ]
    ] = (),
    value_rows: Sequence[
        Mapping[
            str,
            Any,
        ]
    ] = (),
    schema: str = "tww_sys",
    languages: tuple[
        TwwLanguage,
        ...,
    ] = (
        TwwLanguage.DE,
        TwwLanguage.FR,
        TwwLanguage.IT,
        TwwLanguage.EN,
    ),
    automap_classes: Mapping[
        str,
        Any,
    ] | None = None,
    reflected_class_ids: frozenset[
        str
    ] = frozenset(),
) -> tuple[
    TwwCanonicalModelAdapter,
    CanonicalModelCursor,
    FakeConnectionFactory,
]:
    cursor = CanonicalModelCursor(
        class_rows=class_rows,
        attribute_rows=attribute_rows,
        value_rows=value_rows,
    )

    connection_factory = FakeConnectionFactory(
        FakeConnection(
            cursor,
        )
    )

    adapter = TwwCanonicalModelAdapter(
        connection_factory=connection_factory,
        schema=schema,
        languages=languages,
        reflected_class_ids=reflected_class_ids,
        automap_classes=(
            {}
            if automap_classes is None
            else automap_classes
        ),
    )

    return (
        adapter,
        cursor,
        connection_factory,
    )


def _assert_complete_dictionary_load(
    *,
    cursor: CanonicalModelCursor,
    connection_factory: FakeConnectionFactory,
) -> None:
    """
    Assert that the aggregate canonical dictionary was loaded once.
    """

    assert len(
        cursor.executed_queries,
    ) == 3

    assert all(
        parameters == ()
        for _, parameters
        in cursor.executed_queries
    )

    assert connection_factory.autocommit_values == [
        True,
        True,
        True,
    ]


def test_tww_canonical_model_adapter_loads_classes() -> None:
    adapter, cursor, connection_factory = _adapter(
        class_rows=[
            {
                "source_id": 1,
                "class_id": "wastewater_structure",
                "name_de": "Abwasserbauwerk",
                "name_fr": "Ouvrage des eaux usées",
                "name_it": "Manufatto delle acque di scarico",
                "name_en": "Wastewater structure",
            },
            {
                "source_id": 2,
                "class_id": "reach",
                "name_de": "Haltung",
                "name_fr": "Tronçon",
                "name_it": "Tratta",
                "name_en": "Reach",
            },
        ],
    )

    classes = adapter.classes()

    assert classes == {
        "wastewater_structure": CanonicalClassMetadata(
            source_id=1,
            identifier="wastewater_structure",
            localized=LocalizedMetadata(
                names={
                    "de": "Abwasserbauwerk",
                    "fr": "Ouvrage des eaux usées",
                    "it": "Manufatto delle acque di scarico",
                    "en": "Wastewater structure",
                },
            ),
        ),
        "reach": CanonicalClassMetadata(
            source_id=2,
            identifier="reach",
            localized=LocalizedMetadata(
                names={
                    "de": "Haltung",
                    "fr": "Tronçon",
                    "it": "Tratta",
                    "en": "Reach",
                },
            ),
        ),
    }

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_loads_attributes() -> None:
    adapter, cursor, connection_factory = _adapter(
        attribute_rows=[
            {
                "source_id": 10,
                "class_id": "wastewater_structure",
                "attribute_id": "status",
                "field_datatype": "integer",
                "field_name_de": "Status",
                "field_name_fr": "État",
                "field_name_it": "Stato",
                "field_name_en": "Status",
            },
            {
                "source_id": 11,
                "class_id": "wastewater_structure",
                "attribute_id": "detail_geometry3d_geometry",
                "field_datatype": "geometry",
                "field_name_de": "Detailgeometrie",
                "field_name_fr": "Géométrie détaillée",
                "field_name_it": "Geometria dettagliata",
                "field_name_en": "Detail geometry",
            },
        ],
    )

    attributes = adapter.attributes(
        class_id="wastewater_structure",
    )

    assert attributes[
        (
            "wastewater_structure",
            "status",
        )
    ] == CanonicalAttributeMetadata(
        source_id=10,
        identifier="status",
        field_datatype="integer",
        localized=LocalizedMetadata(
            names={
                "de": "Status",
                "fr": "État",
                "it": "Stato",
                "en": "Status",
            },
        ),
    )

    assert attributes[
        (
            "wastewater_structure",
            "detail_geometry3d_geometry",
        )
    ] == CanonicalAttributeMetadata(
        source_id=11,
        identifier="detail_geometry3d_geometry",
        field_datatype="geometry",
        localized=LocalizedMetadata(
            names={
                "de": "Detailgeometrie",
                "fr": "Géométrie détaillée",
                "it": "Geometria dettagliata",
                "en": "Detail geometry",
            },
        ),
    )

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_loads_values() -> None:
    adapter, cursor, connection_factory = _adapter(
        value_rows=[
            {
                "source_id": 100,
                "class_id": "wastewater_structure",
                "attribute_id": "status",
                "value_id": "other.planned",
                "value_name_de": "geplant",
                "value_name_fr": "planifié",
                "value_name_it": "pianificato",
                "value_name_en": "planned",
            },
            {
                "source_id": 101,
                "class_id": "wastewater_structure",
                "attribute_id": "status",
                "value_id": "other.in_operation",
                "value_name_de": "in Betrieb",
                "value_name_fr": "en service",
                "value_name_it": "in esercizio",
                "value_name_en": "in operation",
            },
        ],
    )

    values = adapter.values(
        class_id="wastewater_structure",
        attribute_id="status",
    )

    assert values[
        (
            "wastewater_structure",
            "status",
            "other.planned",
        )
    ] == CanonicalValueMetadata(
        source_id=100,
        identifier="other.planned",
        localized=LocalizedMetadata(
            names={
                "de": "geplant",
                "fr": "planifié",
                "it": "pianificato",
                "en": "planned",
            },
        ),
    )

    assert values[
        (
            "wastewater_structure",
            "status",
            "other.in_operation",
        )
    ] == CanonicalValueMetadata(
        source_id=101,
        identifier="other.in_operation",
        localized=LocalizedMetadata(
            names={
                "de": "in Betrieb",
                "fr": "en service",
                "it": "in esercizio",
                "en": "in operation",
            },
        ),
    )

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_builds_canonical_model() -> None:
    adapter, cursor, connection_factory = _adapter(
        class_rows=[
            {
                "source_id": 1,
                "class_id": "reach",
                "name_de": "Haltung",
                "name_fr": "Tronçon",
                "name_it": "Tratta",
                "name_en": "Reach",
            },
        ],
        attribute_rows=[
            {
                "source_id": 10,
                "class_id": "reach",
                "attribute_id": "progression_geometry",
                "field_datatype": "geometry",
                "field_name_de": "Verlauf",
                "field_name_fr": "Tracé",
                "field_name_it": "Tracciato",
                "field_name_en": "Progression geometry",
            },
        ],
        value_rows=[
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
        ],
    )

    metadata = adapter.canonical_model()

    assert isinstance(
        metadata,
        CanonicalModelMetadata,
    )

    assert set(
        metadata.classes,
    ) == {
        "reach",
    }

    assert set(
        metadata.attributes,
    ) == {
        (
            "reach",
            "progression_geometry",
        ),
    }

    assert set(
        metadata.values,
    ) == {
        (
            "reach",
            "status",
            "active",
        ),
    }

    assert metadata.classes[
        "reach"
    ].localized.names == {
        "de": "Haltung",
        "fr": "Tronçon",
        "it": "Tratta",
        "en": "Reach",
    }

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_returns_single_class_metadata() -> None:
    adapter, cursor, connection_factory = _adapter(
        class_rows=[
            {
                "source_id": 1,
                "class_id": "reach",
                "name_de": "Haltung",
                "name_fr": "Tronçon",
                "name_it": "Tratta",
                "name_en": "Reach",
            },
        ],
    )

    metadata = adapter.class_metadata(
        "reach",
    )

    assert metadata is not None
    assert metadata.identifier == "reach"

    assert metadata.localized.names == {
        "de": "Haltung",
        "fr": "Tronçon",
        "it": "Tratta",
        "en": "Reach",
    }

    assert adapter.class_metadata(
        "unknown",
    ) is None

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_returns_single_attribute_metadata() -> None:
    adapter, _, _ = _adapter(
        attribute_rows=[
            {
                "source_id": 10,
                "class_id": "reach",
                "attribute_id": "progression_geometry",
                "field_datatype": "geometry",
                "field_name_de": "Verlauf",
                "field_name_fr": "Tracé",
                "field_name_it": "Tracciato",
                "field_name_en": "Progression geometry",
            },
        ],
    )

    metadata = adapter.attribute_metadata(
        "reach",
        "progression_geometry",
    )

    assert metadata is not None
    assert metadata.identifier == "progression_geometry"
    assert metadata.field_datatype == "geometry"

    assert metadata.localized.names == {
        "de": "Verlauf",
        "fr": "Tracé",
        "it": "Tracciato",
        "en": "Progression geometry",
    }

    assert adapter.attribute_metadata(
        "reach",
        "unknown",
    ) is None


def test_tww_canonical_model_adapter_returns_single_value_metadata() -> None:
    adapter, _, _ = _adapter(
        value_rows=[
            {
                "source_id": 100,
                "class_id": "wastewater_structure",
                "attribute_id": "status",
                "value_id": "other.planned",
                "value_name_de": "geplant",
                "value_name_fr": "planifié",
                "value_name_it": "pianificato",
                "value_name_en": "planned",
            },
        ],
    )

    metadata = adapter.value_metadata(
        "wastewater_structure",
        "status",
        "other.planned",
    )

    assert metadata is not None
    assert metadata.identifier == "other.planned"

    assert metadata.localized.names == {
        "de": "geplant",
        "fr": "planifié",
        "it": "pianificato",
        "en": "planned",
    }

    assert adapter.value_metadata(
        "wastewater_structure",
        "status",
        "unknown",
    ) is None


def test_tww_canonical_model_adapter_detects_geometry_attributes() -> None:
    adapter, _, _ = _adapter(
        attribute_rows=[
            {
                "source_id": 10,
                "class_id": "reach",
                "attribute_id": "progression_geometry",
                "field_datatype": "geometry",
                "field_name_de": "Verlauf",
                "field_name_fr": "Tracé",
                "field_name_it": "Tracciato",
                "field_name_en": "Progression geometry",
            },
            {
                "source_id": 11,
                "class_id": "reach",
                "attribute_id": "identifier",
                "field_datatype": "text",
                "field_name_de": "Bezeichnung",
                "field_name_fr": "Désignation",
                "field_name_it": "Identificatore",
                "field_name_en": "Identifier",
            },
        ],
    )

    assert adapter.is_geometry_attribute(
        "reach",
        "progression_geometry",
    )

    assert not adapter.is_geometry_attribute(
        "reach",
        "identifier",
    )

    assert not adapter.is_geometry_attribute(
        "reach",
        "missing_attribute",
    )


def test_tww_canonical_model_adapter_returns_geometry_attribute_names() -> None:
    adapter, _, _ = _adapter(
        attribute_rows=[
            {
                "source_id": 10,
                "class_id": "reach",
                "attribute_id": "progression_geometry",
                "field_datatype": "geometry",
                "field_name_de": "Verlauf",
                "field_name_fr": "Tracé",
                "field_name_it": "Tracciato",
                "field_name_en": "Progression geometry",
            },
            {
                "source_id": 11,
                "class_id": "reach",
                "attribute_id": "identifier",
                "field_datatype": "text",
                "field_name_de": "Bezeichnung",
                "field_name_fr": "Désignation",
                "field_name_it": "Identificatore",
                "field_name_en": "Identifier",
            },
            {
                "source_id": 12,
                "class_id": "wastewater_structure",
                "attribute_id": "detail_geometry3d_geometry",
                "field_datatype": " geometry ",
                "field_name_de": "Detailgeometrie",
                "field_name_fr": "Géométrie détaillée",
                "field_name_it": "Geometria dettagliata",
                "field_name_en": "Detail geometry",
            },
        ],
    )

    assert adapter.geometry_attribute_names(
        "reach",
    ) == (
        "progression_geometry",
    )

    assert adapter.geometry_attribute_names(
        "wastewater_structure",
    ) == (
        "detail_geometry3d_geometry",
    )


def test_tww_canonical_model_adapter_uses_custom_schema_and_caches_model(
) -> None:
    adapter, cursor, connection_factory = _adapter(
        schema="custom_sys",
    )

    adapter.classes()

    adapter.attributes(
        class_id="reach",
    )

    adapter.values(
        class_id="reach",
        attribute_id="status",
    )

    combined = "\n".join(
        str(
            query,
        )
        for query, _
        in cursor.executed_queries
    )

    assert "custom_sys" in combined

    for column_name in (
        "name_de",
        "name_fr",
        "name_it",
        "name_en",
        "field_name_de",
        "field_name_fr",
        "field_name_it",
        "field_name_en",
        "value_name_de",
        "value_name_fr",
        "value_name_it",
        "value_name_en",
    ):
        assert column_name in combined

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_omits_empty_localizations() -> None:
    adapter, _, _ = _adapter()

    localized = adapter._localized_metadata(
        row={
            "name_de": "Haltung",
            "name_fr": None,
            "name_it": "",
            "name_en": "Reach",
        },
        name_prefix="name",
    )

    assert localized == LocalizedMetadata(
        names={
            "de": "Haltung",
            "en": "Reach",
        },
    )


def test_tww_canonical_model_adapter_respects_configured_languages() -> None:
    adapter, _, _ = _adapter(
        languages=(
            TwwLanguage.DE,
            TwwLanguage.FR,
        ),
    )

    localized = adapter._localized_metadata(
        row={
            "name_de": "Haltung",
            "name_fr": "Tronçon",
            "name_it": "Tratta",
            "name_en": "Reach",
        },
        name_prefix="name",
    )

    assert localized == LocalizedMetadata(
        names={
            "de": "Haltung",
            "fr": "Tronçon",
        },
    )


def test_tww_canonical_model_adapter_returns_empty_localized_metadata() -> None:
    adapter, _, _ = _adapter()

    localized = adapter._localized_metadata(
        row={
            "name_de": None,
            "name_fr": "",
            "name_it": None,
            "name_en": "",
        },
        name_prefix="name",
    )

    assert localized == LocalizedMetadata()


def test_tww_canonical_model_adapter_skips_automap_without_reflected_classes(
    monkeypatch,
) -> None:
    adapter, cursor, connection_factory = _adapter(
        class_rows=[
            {
                "source_id": 1,
                "class_id": "reach",
                "name_de": "Haltung",
                "name_fr": "Tronçon",
                "name_it": "Tratta",
                "name_en": "Reach",
            },
        ],
        reflected_class_ids=frozenset(),
        automap_classes=None,
    )

    model_tww_od = Mock()

    monkeypatch.setattr(
        adapter_module,
        "ModelTwwOd",
        model_tww_od,
    )

    assert set(
        adapter.classes(),
    ) == {
        "reach",
    }

    model_tww_od.assert_not_called()

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_adds_reflected_class_and_attribute(
) -> None:
    adapter, cursor, connection_factory = _adapter(
        reflected_class_ids=frozenset(
            {
                "agxx_reach",
            }
        ),
        automap_classes={
            "agxx_reach": FakeMappedClass,
        },
    )

    metadata = adapter.canonical_model()

    reflected_class = metadata.classes[
        "agxx_reach"
    ]

    assert reflected_class == CanonicalClassMetadata(
        source_id=adapter._reflected_source_id(
            "class:agxx_reach",
        ),
        identifier="agxx_reach",
        localized=LocalizedMetadata(),
    )

    reflected_attribute = metadata.attributes[
        (
            "agxx_reach",
            "fk_reach",
        )
    ]

    assert reflected_attribute == CanonicalAttributeMetadata(
        source_id=adapter._reflected_source_id(
            "attribute:agxx_reach.fk_reach",
        ),
        identifier="fk_reach",
        field_datatype="integer",
        localized=LocalizedMetadata(),
    )

    assert reflected_class.source_id < 0
    assert reflected_attribute.source_id < 0

    _assert_complete_dictionary_load(
        cursor=cursor,
        connection_factory=connection_factory,
    )


def test_tww_canonical_model_adapter_prefers_dictionary_source_ids(
) -> None:
    adapter, _, _ = _adapter(
        class_rows=[
            {
                "source_id": 42,
                "class_id": "agxx_reach",
                "name_de": "AG Haltung",
                "name_fr": None,
                "name_it": None,
                "name_en": None,
            },
        ],
        attribute_rows=[
            {
                "source_id": 87,
                "class_id": "agxx_reach",
                "attribute_id": "fk_reach",
                "field_datatype": "uuid",
                "field_name_de": "Haltung",
                "field_name_fr": None,
                "field_name_it": None,
                "field_name_en": None,
            },
        ],
        reflected_class_ids=frozenset(
            {
                "agxx_reach",
            }
        ),
        automap_classes={
            "agxx_reach": FakeMappedClass,
        },
    )

    metadata = adapter.canonical_model()

    assert metadata.classes[
        "agxx_reach"
    ].source_id == 42

    assert metadata.attributes[
        (
            "agxx_reach",
            "fk_reach",
        )
    ].source_id == 87