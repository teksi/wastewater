from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any
from zlib import crc32

from psycopg import sql

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.models.canonical_object import (
    CanonicalAttributeMetadata,
    CanonicalClassMetadata,
    CanonicalModelMetadata,
    CanonicalValueMetadata,
    LocalizedMetadata,
)

from ...interlis.interlis_model_mapping.model_tww_od import (
    ModelTwwOd,
)


AGXX_EXTENSION_CLASSES = frozenset(
    {
        "agxx_wastewater_node",
        "agxx_last_modification",
        "agxx_wastewater_networkelement",
        "agxx_wastewater_structure",
        "agxx_reach",
        "agxx_overflow",
        "agxx_building_group",
        "agxx_catchment_area_totals",
        "agxx_infiltration_zone",
    }
)


class TwwLanguage(StrEnum):
    DE = "de"
    FR = "fr"
    IT = "it"
    EN = "en"


@dataclass(slots=True)
class TwwCanonicalModelAdapter:
    """
    Load composite canonical TEKSI Wastewater metadata.

    Dictionary metadata from ``tww_sys`` remains authoritative. Selected
    physical AG-XX extension classes reflected through ``ModelTwwOd``
    supplement dictionary entries that are missing from the dictionary.
    """

    connection_factory: DatabaseConnectionFactory
    schema: str = "tww_sys"
    reflected_class_ids: frozenset[str] = AGXX_EXTENSION_CLASSES
    languages: tuple[TwwLanguage, ...] = (
        TwwLanguage.DE,
        TwwLanguage.FR,
        TwwLanguage.IT,
        TwwLanguage.EN,
    )
    _canonical_model_cache: CanonicalModelMetadata | None = field(
        default=None,
        init=False,
        repr=False,
    )
    automap_classes: Mapping[
        str,
        Any,
    ] | None = None

    def canonical_model(
        self,
    ) -> CanonicalModelMetadata:
        if self._canonical_model_cache is not None:
            return self._canonical_model_cache

        dictionary_classes = self._dictionary_classes()
        dictionary_attributes = self._dictionary_attributes()
        dictionary_values = self._dictionary_values()

        reflected_classes: dict[
            str,
            CanonicalClassMetadata,
        ] = {}

        reflected_attributes: dict[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ] = {}

        if self.reflected_class_ids:
            automap_classes = self._automap_classes()

            reflected_classes = self._reflected_classes(
                automap_classes=automap_classes,
            )

            reflected_attributes = self._reflected_attributes(
                automap_classes=automap_classes,
            )

        self._canonical_model_cache = CanonicalModelMetadata(
            classes=self._merge_classes(
                dictionary=dictionary_classes,
                reflected=reflected_classes,
            ),
            attributes=self._merge_attributes(
                dictionary=dictionary_attributes,
                reflected=reflected_attributes,
            ),
            values=dictionary_values,
        )

        return self._canonical_model_cache

    def clear_cache(
        self,
    ) -> None:
        self._canonical_model_cache = None

    def classes(
        self,
    ) -> dict[str, CanonicalClassMetadata]:
        return dict(
            self.canonical_model().classes,
        )

    def attributes(
        self,
        class_id: str | None = None,
    ) -> dict[
        tuple[str, str],
        CanonicalAttributeMetadata,
    ]:
        attributes = self.canonical_model().attributes

        if class_id is None:
            return dict(
                attributes,
            )

        return {
            key: metadata
            for key, metadata in attributes.items()
            if key[0] == class_id
        }

    def values(
        self,
        class_id: str | None = None,
        attribute_id: str | None = None,
    ) -> dict[
        tuple[str, str, str],
        CanonicalValueMetadata,
    ]:
        values = self.canonical_model().values

        return {
            key: metadata
            for key, metadata in values.items()
            if (
                class_id is None
                or key[0] == class_id
            )
            and (
                attribute_id is None
                or key[1] == attribute_id
            )
        }

    def class_metadata(
        self,
        class_id: str,
    ) -> CanonicalClassMetadata | None:
        return self.canonical_model().classes.get(
            class_id,
        )

    def attribute_metadata(
        self,
        class_id: str,
        attribute_id: str,
    ) -> CanonicalAttributeMetadata | None:
        return self.canonical_model().attributes.get(
            (
                class_id,
                attribute_id,
            )
        )

    def value_metadata(
        self,
        class_id: str,
        attribute_id: str,
        value_id: str,
    ) -> CanonicalValueMetadata | None:
        return self.canonical_model().values.get(
            (
                class_id,
                attribute_id,
                value_id,
            )
        )

    def is_geometry_attribute(
        self,
        class_id: str,
        attribute_id: str,
    ) -> bool:
        metadata = self.attribute_metadata(
            class_id,
            attribute_id,
        )

        if metadata is None:
            return False

        return self._is_geometry_datatype(
            metadata.field_datatype,
        )

    def geometry_attribute_names(
        self,
        class_id: str,
    ) -> tuple[str, ...]:
        return tuple(
            attribute_id
            for (
                attribute_class_id,
                attribute_id,
            ), metadata in self.attributes(
                class_id=class_id,
            ).items()
            if (
                attribute_class_id == class_id
                and self._is_geometry_datatype(
                    metadata.field_datatype,
                )
            )
        )

    def _automap_classes(
        self,
    ) -> Mapping[
        str,
        Any,
    ]:
        if self.automap_classes is not None:
            return self.automap_classes

        return ModelTwwOd().classes()

    def _reflected_source_id(
        self,
        semantic_id: str,
    ) -> int:
        """
        Return a deterministic fallback source identifier for reflected metadata.

        Reflected elements without a corresponding tww_sys dictionary row do not
        have a numeric dictionary identifier. A deterministic negative integer is
        used to keep those elements distinguishable from ordinary positive
        dictionary identifiers.

        This value is metadata provenance only. Stable semantic identity is
        derived separately from the canonical identifier and
        TeksiModelNamespaces.
        """

        checksum = crc32(
            semantic_id.encode(
                "utf-8",
            )
        )

        return -(
            checksum
            or 1
        )


    def _reflected_classes(
        self,
        *,
        automap_classes: Any,
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        classes: dict[
            str,
            CanonicalClassMetadata,
        ] = {}

        for class_id in sorted(
            self.reflected_class_ids,
        ):
            mapped_class = self._automap_class(
                automap_classes=automap_classes,
                class_id=class_id,
            )

            table = mapped_class.__table__

            identifier = str(
                table.name,
            )

            classes[
                class_id
            ] = CanonicalClassMetadata(
                source_id=self._reflected_source_id(
                    f"class:{class_id}",
                ),
                identifier=identifier,
                localized=LocalizedMetadata(),
            )

        return classes

    def _reflected_attributes(
        self,
        *,
        automap_classes: Any,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalAttributeMetadata,
    ]:
        attributes: dict[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ] = {}

        for class_id in sorted(
            self.reflected_class_ids,
        ):
            mapped_class = self._automap_class(
                automap_classes=automap_classes,
                class_id=class_id,
            )

            for column in mapped_class.__table__.columns:
                attribute_id = str(
                    column.name,
                )

                attributes[
                    (
                        class_id,
                        attribute_id,
                    )
                ] = CanonicalAttributeMetadata(
                    source_id=self._reflected_source_id(
                        "attribute:"
                        f"{class_id}."
                        f"{attribute_id}",
                    ),
                    identifier=attribute_id,
                    field_datatype=self._sqlalchemy_datatype(
                        column,
                    ),
                    localized=LocalizedMetadata(),
                )

        return attributes

    def _automap_class(
        self,
        *,
        automap_classes: Any,
        class_id: str,
    ) -> Any:
        if isinstance(
            automap_classes,
            Mapping,
        ):
            mapped_class = automap_classes.get(
                class_id,
            )
        else:
            mapped_class = getattr(
                automap_classes,
                class_id,
                None,
            )

        if mapped_class is None:
            raise RuntimeError(
                "Configured canonical extension class is unavailable "
                f"from ModelTwwOd: {class_id!r}."
            )

        if getattr(
            mapped_class,
            "__table__",
            None,
        ) is None:
            raise RuntimeError(
                "Automapped canonical extension class has no table "
                f"metadata: {class_id!r}."
            )

        return mapped_class

    def _sqlalchemy_datatype(
        self,
        column: Any,
    ) -> str:
        type_name = type(
            column.type,
        ).__name__.strip().lower()

        if (
            type_name == "geometry"
            or type_name.startswith(
                "geometry",
            )
        ):
            return "geometry"

        try:
            python_type = column.type.python_type
        except (
            AttributeError,
            NotImplementedError,
        ):
            python_type = None

        if python_type is str:
            return "text"

        if python_type is bool:
            return "boolean"

        if python_type is int:
            return "integer"

        if python_type is float:
            return "numeric"

        return str(
            column.type,
        ).strip().lower()

    def _merge_classes(
        self,
        *,
        dictionary: Mapping[
            str,
            CanonicalClassMetadata,
        ],
        reflected: Mapping[
            str,
            CanonicalClassMetadata,
        ],
    ) -> dict[str, CanonicalClassMetadata]:
        result = dict(
            dictionary,
        )

        for key, metadata in reflected.items():
            result.setdefault(
                key,
                metadata,
            )

        return result

    def _merge_attributes(
        self,
        *,
        dictionary: Mapping[
            tuple[str, str],
            CanonicalAttributeMetadata,
        ],
        reflected: Mapping[
            tuple[str, str],
            CanonicalAttributeMetadata,
        ],
    ) -> dict[
        tuple[str, str],
        CanonicalAttributeMetadata,
    ]:
        result = dict(
            dictionary,
        )

        for key, metadata in reflected.items():
            result.setdefault(
                key,
                metadata,
            )

        return result

    def _dictionary_classes(
        self,
    ) -> dict[str, CanonicalClassMetadata]:
        query = sql.SQL(
            """
            SELECT
                t.id AS source_id,
                t.tablename AS class_id,
                t.name_de,
                t.name_fr,
                t.name_it,
                t.name_en
            FROM {}.dictionary_od_table AS t
            ORDER BY
                t.tablename;
            """
        ).format(
            sql.Identifier(
                self.schema,
            )
        )

        rows = self._fetchall_dict(
            query=query,
        )

        return {
            str(
                row["class_id"],
            ): self._class_metadata_from_row(
                row,
            )
            for row in rows
        }

    def _dictionary_attributes(
        self,
    ) -> dict[
        tuple[str, str],
        CanonicalAttributeMetadata,
    ]:
        query = sql.SQL(
            """
            SELECT
                f.attribute_id AS source_id,
                t.tablename AS class_id,
                f.field_name AS attribute_id,
                f.field_datatype AS field_datatype,
                f.field_name_de,
                f.field_name_fr,
                f.field_name_it,
                f.field_name_en
            FROM {}.dictionary_od_field AS f
            JOIN {}.dictionary_od_table AS t
                ON t.id = f.class_id
            ORDER BY
                t.tablename,
                f.field_name;
            """
        ).format(
            sql.Identifier(
                self.schema,
            ),
            sql.Identifier(
                self.schema,
            ),
        )

        rows = self._fetchall_dict(
            query=query,
        )

        return {
            (
                str(
                    row["class_id"],
                ),
                str(
                    row["attribute_id"],
                ),
            ): self._attribute_metadata_from_row(
                row,
            )
            for row in rows
        }

    def _dictionary_values(
        self,
    ) -> dict[
        tuple[str, str, str],
        CanonicalValueMetadata,
    ]:
        query = sql.SQL(
            """
            SELECT
                v.value_id AS source_id,
                t.tablename AS class_id,
                f.field_name AS attribute_id,
                v.value_name AS value_id,
                v.value_name_de,
                v.value_name_fr,
                v.value_name_it,
                v.value_name_en
            FROM {}.dictionary_od_values AS v
            JOIN {}.dictionary_od_table AS t
                ON t.id = v.class_id
            JOIN {}.dictionary_od_field AS f
                ON f.class_id = v.class_id
               AND f.attribute_id = v.attribute_id
            ORDER BY
                t.tablename,
                f.field_name,
                v.value_name;
            """
        ).format(
            sql.Identifier(
                self.schema,
            ),
            sql.Identifier(
                self.schema,
            ),
            sql.Identifier(
                self.schema,
            ),
        )

        rows = self._fetchall_dict(
            query=query,
        )

        return {
            (
                str(
                    row["class_id"],
                ),
                str(
                    row["attribute_id"],
                ),
                str(
                    row["value_id"],
                ),
            ): self._value_metadata_from_row(
                row,
            )
            for row in rows
        }

    def _class_metadata_from_row(
        self,
        row: Mapping[str, Any],
    ) -> CanonicalClassMetadata:
        return CanonicalClassMetadata(
            source_id=row["source_id"],
            identifier=str(
                row["class_id"],
            ),
            localized=self._localized_metadata(
                row=row,
                name_prefix="name",
            ),
        )

    def _attribute_metadata_from_row(
        self,
        row: Mapping[str, Any],
    ) -> CanonicalAttributeMetadata:
        field_datatype = row.get(
            "field_datatype",
        )

        return CanonicalAttributeMetadata(
            source_id=row["source_id"],
            identifier=str(
                row["attribute_id"],
            ),
            field_datatype=(
                str(
                    field_datatype,
                )
                if field_datatype is not None
                else None
            ),
            localized=self._localized_metadata(
                row=row,
                name_prefix="field_name",
            ),
        )

    def _value_metadata_from_row(
        self,
        row: Mapping[str, Any],
    ) -> CanonicalValueMetadata:
        return CanonicalValueMetadata(
            source_id=row["source_id"],
            identifier=str(
                row["value_id"],
            ),
            localized=self._localized_metadata(
                row=row,
                name_prefix="value_name",
            ),
        )

    def _localized_metadata(
        self,
        *,
        row: Mapping[str, Any],
        name_prefix: str,
    ) -> LocalizedMetadata:
        names: dict[
            str,
            str,
        ] = {}

        for language in self.languages:
            value = row.get(
                f"{name_prefix}_{language.value}",
            )

            if value is None:
                continue

            normalized_value = str(
                value,
            ).strip()

            if normalized_value:
                names[
                    language.value
                ] = normalized_value

        return LocalizedMetadata(
            names=names,
        )

    def _is_geometry_datatype(
        self,
        field_datatype: str | None,
    ) -> bool:
        if field_datatype is None:
            return False

        normalized = field_datatype.strip().lower()

        return (
            normalized == "geometry"
            or normalized.startswith(
                "geometry(",
            )
        )

    def _fetchall_dict(
        self,
        *,
        query: sql.Composable,
        parameters: Sequence[Any] = (),
    ) -> list[dict[str, Any]]:
        with self.connection_factory.connection(
            autocommit=True,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    query,
                    tuple(
                        parameters,
                    ),
                )
                rows = cursor.fetchall()

                if cursor.description is None:
                    return []

                column_names = tuple(
                    self._column_name(
                        column,
                    )
                    for column in cursor.description
                )

        return [
            dict(
                zip(
                    column_names,
                    row,
                    strict=True,
                )
            )
            for row in rows
        ]

    def _column_name(
        self,
        column: Any,
    ) -> str:
        name = getattr(
            column,
            "name",
            None,
        )

        if name is not None:
            return str(
                name,
            )

        return str(
            column[0],
        )