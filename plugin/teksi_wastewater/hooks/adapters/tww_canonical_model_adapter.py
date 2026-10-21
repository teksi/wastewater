from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any
from zlib import crc32

from psycopg import sql
from sqlalchemy import inspect
from sqlalchemy.exc import NoInspectionAvailable
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


class TwwLanguage(
    StrEnum,
):
    DE = "de"
    FR = "fr"
    IT = "it"
    EN = "en"


@dataclass(
    frozen=True,
    slots=True,
)
class CanonicalForeignKeyMetadata:
    """
    Describe one physical foreign key in the canonical ORM.

    ``class_id`` and ``attribute_id`` identify the local canonical
    attribute.

    ``referenced_class_id`` and ``referenced_attribute_id`` identify the
    referenced canonical class and attribute.
    """

    class_id: str
    attribute_id: str
    referenced_class_id: str
    referenced_attribute_id: str


@dataclass(
    slots=True,
)
class TwwCanonicalModelAdapter:
    """
    Load composite canonical TEKSI Wastewater metadata.

    Dictionary metadata from ``tww_sys`` remains authoritative for semantic
    class, attribute, value-list, and localization metadata.

    The canonical ``tww_od`` ORM supplements the dictionary with:

    - physical canonical classes absent from the dictionary;
    - physical and inherited attributes absent from the dictionary;
    - canonical foreign-key relationships;
    - the referenced canonical class and attribute for each foreign key.

    Reflected metadata never overwrites an existing dictionary definition.

    Canonical ORM discovery is intentionally independent of the imported
    quarantine model. Source-language names, ili2pg inheritance, transfer
    identities, and source-to-canonical mappings remain responsibilities of
    the relation-context provider.
    """

    connection_factory: DatabaseConnectionFactory

    schema: str = "tww_sys"

    reflected_class_ids: frozenset[str,] | None = None

    languages: tuple[
        TwwLanguage,
        ...,
    ] = (
        TwwLanguage.DE,
        TwwLanguage.FR,
        TwwLanguage.IT,
        TwwLanguage.EN,
    )

    automap_classes: (
        Mapping[
            str,
            Any,
        ]
        | None
    ) = None

    _canonical_model_cache: CanonicalModelMetadata | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _canonical_foreign_keys_cache: (
        tuple[
            CanonicalForeignKeyMetadata,
            ...,
        ]
        | None
    ) = field(
        default=None,
        init=False,
        repr=False,
    )

    _resolved_automap_classes_cache: (
        dict[
            str,
            Any,
        ]
        | None
    ) = field(
        default=None,
        init=False,
        repr=False,
    )

    _canonical_foreign_key_index_cache: (
        dict[
            tuple[
                str,
                str,
            ],
            tuple[
                str,
                ...,
            ],
        ]
        | None
    ) = field(
        default=None,
        init=False,
        repr=False,
    )

    # ------------------------------------------------------------------
    # Public canonical-model API
    # ------------------------------------------------------------------

    def canonical_model(
        self,
    ) -> CanonicalModelMetadata:
        """
        Return complete canonical metadata.

        Dictionary definitions remain authoritative. ORM reflection supplies
        physical classes and attributes missing from the dictionary.
        """

        if self._canonical_model_cache is not None:
            return self._canonical_model_cache

        dictionary_classes = self._dictionary_classes()
        dictionary_attributes = self._dictionary_attributes()
        dictionary_values = self._dictionary_values()

        automap_classes = self._resolved_automap_classes()

        reflected_classes = self._reflected_classes(
            automap_classes=automap_classes,
        )

        reflected_attributes = self._reflected_attributes(
            automap_classes=automap_classes,
        )

        self._canonical_foreign_keys_cache = self._reflected_foreign_keys(
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
        self._canonical_foreign_keys_cache = None
        self._canonical_foreign_key_index_cache = None
        self._resolved_automap_classes_cache = None

    def classes(
        self,
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        """
        Return canonical classes keyed by canonical class identifier.
        """

        return dict(
            self.canonical_model().classes,
        )

    def attributes(
        self,
        class_id: str | None = None,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalAttributeMetadata,
    ]:
        """
        Return canonical attributes, optionally restricted to one class.
        """

        attributes = self.canonical_model().attributes

        if class_id is None:
            return dict(
                attributes,
            )

        return {
            key: metadata
            for (
                key,
                metadata,
            ) in attributes.items()
            if key[0] == class_id
        }

    def values(
        self,
        class_id: str | None = None,
        attribute_id: str | None = None,
    ) -> dict[
        tuple[
            str,
            str,
            str,
        ],
        CanonicalValueMetadata,
    ]:
        """
        Return canonical values, optionally filtered by class and attribute.
        """

        values = self.canonical_model().values

        return {
            key: metadata
            for (
                key,
                metadata,
            ) in values.items()
            if (class_id is None or key[0] == class_id)
            and (attribute_id is None or key[1] == attribute_id)
        }

    def foreign_keys(
        self,
        class_id: str | None = None,
        referenced_class_id: str | None = None,
    ) -> tuple[
        CanonicalForeignKeyMetadata,
        ...,
    ]:
        """
        Return reflected canonical foreign keys.

        Results may be filtered by the local canonical class and referenced
        canonical class.
        """

        self.canonical_model()

        foreign_keys = self._canonical_foreign_keys_cache or ()

        return tuple(
            foreign_key
            for foreign_key in foreign_keys
            if (class_id is None or foreign_key.class_id == class_id)
            and (
                referenced_class_id is None
                or foreign_key.referenced_class_id == referenced_class_id
            )
        )

    def foreign_key_metadata(
        self,
        class_id: str,
        attribute_id: str,
    ) -> CanonicalForeignKeyMetadata | None:
        """
        Return metadata for one canonical foreign-key attribute.
        """

        matches = tuple(
            foreign_key
            for foreign_key in self.foreign_keys(
                class_id=class_id,
            )
            if foreign_key.attribute_id == attribute_id
        )

        if not matches:
            return None

        if (
            len(
                matches,
            )
            != 1
        ):
            raise RuntimeError(
                "Several canonical foreign-key definitions exist for "
                f"{class_id!r}.{attribute_id!r}: {matches!r}."
            )

        return matches[0]

    def foreign_key_attributes_to_class(
        self,
        *,
        class_id: str,
        referenced_class_id: str,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return local canonical FK attributes referencing one canonical class.
        """

        return self._canonical_foreign_key_index().get(
            (
                class_id,
                referenced_class_id,
            ),
            (),
        )

    def class_metadata(
        self,
        class_id: str,
    ) -> CanonicalClassMetadata | None:
        """
        Return metadata for one canonical class.
        """

        return self.canonical_model().classes.get(
            class_id,
        )

    def attribute_metadata(
        self,
        class_id: str,
        attribute_id: str,
    ) -> CanonicalAttributeMetadata | None:
        """
        Return metadata for one canonical attribute.
        """

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
        """
        Return metadata for one canonical value.
        """

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
        """
        Return whether one canonical attribute is a geometry.
        """

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
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return geometry attribute identifiers for one canonical class.
        """

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

    # ------------------------------------------------------------------
    # Canonical ORM discovery
    # ------------------------------------------------------------------

    def _resolved_automap_classes(
        self,
    ) -> dict[
        str,
        Any,
    ]:
        """
        Return canonical ORM classes keyed by physical canonical class ID.

        Both mapping-style class collections and SQLAlchemy automap-style class
        namespaces are supported.
        """

        if self._resolved_automap_classes_cache is not None:
            return self._resolved_automap_classes_cache

        raw_classes = self._automap_classes()

        resolved: dict[
            str,
            Any,
        ] = {}

        if isinstance(
            raw_classes,
            Mapping,
        ):
            candidates = tuple(raw_classes.values())

        else:
            candidates = tuple(
                candidate
                for attribute_name in dir(raw_classes)
                if not attribute_name.startswith(
                    "_",
                )
                for candidate in (
                    getattr(
                        raw_classes,
                        attribute_name,
                    ),
                )
                if getattr(
                    candidate,
                    "__table__",
                    None,
                )
                is not None
            )

        for mapped_class in candidates:
            table = getattr(
                mapped_class,
                "__table__",
                None,
            )

            if table is None:
                continue

            class_id = str(
                table.name,
            )

            existing = resolved.get(
                class_id,
            )

            if existing is not None and existing is not mapped_class:
                raise RuntimeError(
                    "Several canonical ORM classes resolve to "
                    f"physical class identifier {class_id!r}."
                )

            resolved[class_id] = mapped_class

        if self.reflected_class_ids is not None:
            missing_class_ids = set(
                self.reflected_class_ids,
            ) - set(
                resolved,
            )

            if missing_class_ids:
                raise RuntimeError(
                    "Configured canonical ORM classes are unavailable "
                    f"from ModelTwwOd: "
                    f"{tuple(sorted(missing_class_ids))!r}."
                )

            resolved = {
                class_id: resolved[class_id]
                for class_id in sorted(
                    self.reflected_class_ids,
                )
            }

        self._resolved_automap_classes_cache = resolved

        return resolved

    def _automap_classes(
        self,
    ) -> Mapping[
        str,
        Any,
    ]:
        """
        Return the configured or default canonical ORM class collection.
        """

        if self.automap_classes is not None:
            return self.automap_classes

        return ModelTwwOd().classes()

    def _reflected_classes(
        self,
        *,
        automap_classes: Mapping[
            str,
            Any,
        ],
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        """
        Return canonical class metadata discovered from the ORM.
        """

        classes: dict[
            str,
            CanonicalClassMetadata,
        ] = {}

        for (
            class_id,
            mapped_class,
        ) in sorted(automap_classes.items()):
            table = getattr(
                mapped_class,
                "__table__",
                None,
            )

            if table is None:
                continue

            identifier = str(
                table.name,
            )

            classes[class_id] = CanonicalClassMetadata(
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
        automap_classes: Mapping[
            str,
            Any,
        ],
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalAttributeMetadata,
    ]:
        """
        Return canonical attributes discovered from mapped ORM classes.

        Mapper column attributes are used rather than only local table columns.
        This includes inherited ORM attributes where the canonical model uses
        joined-table inheritance.

        If several physical columns contribute to one ORM attribute, the
        attribute's first column determines the reflected datatype.
        """

        attributes: dict[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ] = {}

        for (
            class_id,
            mapped_class,
        ) in sorted(automap_classes.items()):
            for (
                attribute_id,
                column,
            ) in self._mapped_columns(
                mapped_class,
            ):
                key = (
                    class_id,
                    attribute_id,
                )

                attributes.setdefault(
                    key,
                    CanonicalAttributeMetadata(
                        source_id=self._reflected_source_id(
                            "attribute:" f"{class_id}." f"{attribute_id}",
                        ),
                        identifier=attribute_id,
                        field_datatype=(
                            self._sqlalchemy_datatype(
                                column,
                            )
                        ),
                        localized=LocalizedMetadata(),
                    ),
                )

        return attributes

    def _reflected_foreign_keys(
        self,
        *,
        automap_classes: Mapping[
            str,
            Any,
        ],
    ) -> tuple[
        CanonicalForeignKeyMetadata,
        ...,
    ]:
        """
        Return canonical foreign keys discovered from ORM relationships.

        Relationship-local columns determine the local canonical attribute.
        The referenced mapped class determines the referenced canonical class.

        Joined-table inheritance relationships are excluded. Their key columns
        describe ORM storage inheritance, not canonical business relationships.

        Duplicate relationship metadata emitted by SQLAlchemy backrefs is
        deduplicated by the complete local and referenced attribute tuple.
        """

        class_id_by_mapped_class = {
            mapped_class: class_id
            for (
                class_id,
                mapped_class,
            ) in automap_classes.items()
        }

        foreign_keys: dict[
            tuple[
                str,
                str,
                str,
                str,
            ],
            CanonicalForeignKeyMetadata,
        ] = {}

        for (
            class_id,
            mapped_class,
        ) in sorted(automap_classes.items()):
            try:
                mapper = inspect(
                    mapped_class,
                )
            except NoInspectionAvailable:
                continue

            inheritance_columns = self._inheritance_local_columns(
                mapper,
            )

            for relationship in mapper.relationships:
                if self._is_inheritance_relationship(
                    mapper=mapper,
                    relationship=relationship,
                    inheritance_columns=(inheritance_columns),
                ):
                    continue

                referenced_class = relationship.mapper.class_

                referenced_class_id = class_id_by_mapped_class.get(
                    referenced_class,
                )

                if referenced_class_id is None:
                    referenced_table = getattr(
                        referenced_class,
                        "__table__",
                        None,
                    )

                    if referenced_table is None:
                        continue

                    referenced_class_id = str(
                        referenced_table.name,
                    )

                for local_column in relationship.local_columns:
                    if local_column in inheritance_columns:
                        continue

                    if not local_column.foreign_keys:
                        continue

                    attribute_id = self._column_attribute_name(
                        local_column,
                    )

                    for foreign_key in local_column.foreign_keys:
                        referenced_column = foreign_key.column

                        referenced_table = getattr(
                            referenced_column,
                            "table",
                            None,
                        )

                        if referenced_table is None:
                            continue

                        target_class_id = (
                            self._class_id_for_table(
                                automap_classes=(automap_classes),
                                table=referenced_table,
                            )
                            or referenced_class_id
                        )

                        referenced_attribute_id = self._column_attribute_name(
                            referenced_column,
                        )

                        key = (
                            class_id,
                            attribute_id,
                            target_class_id,
                            referenced_attribute_id,
                        )

                        foreign_keys.setdefault(
                            key,
                            CanonicalForeignKeyMetadata(
                                class_id=class_id,
                                attribute_id=attribute_id,
                                referenced_class_id=(target_class_id),
                                referenced_attribute_id=(referenced_attribute_id),
                            ),
                        )

        return tuple(
            foreign_keys[key]
            for key in sorted(
                foreign_keys,
            )
        )

    def _mapped_columns(
        self,
        mapped_class: Any,
    ) -> tuple[
        tuple[
            str,
            Any,
        ],
        ...,
    ]:
        """
        Return effective ORM attribute names and representative columns.

        Inherited mapper attributes are included. Local table columns are
        added as a fallback when they are not exposed through mapper
        ``column_attrs``.
        """

        attributes: dict[
            str,
            Any,
        ] = {}

        try:
            mapper = inspect(
                mapped_class,
            )
        except NoInspectionAvailable:
            mapper = None

        if mapper is not None:
            for column_property in mapper.column_attrs:
                attribute_id = getattr(
                    column_property,
                    "key",
                    None,
                )

                if (
                    not isinstance(
                        attribute_id,
                        str,
                    )
                    or not attribute_id
                ):
                    continue

                columns = tuple(
                    getattr(
                        column_property,
                        "columns",
                        (),
                    )
                )

                if not columns:
                    continue

                attributes.setdefault(
                    attribute_id,
                    columns[0],
                )

        table = getattr(
            mapped_class,
            "__table__",
            None,
        )

        if table is not None:
            for column in table.columns:
                attribute_id = self._column_attribute_name(
                    column,
                )

                attributes.setdefault(
                    attribute_id,
                    column,
                )

        return tuple(
            sorted(
                attributes.items(),
                key=lambda item: item[0],
            )
        )

    def _class_id_for_table(
        self,
        *,
        automap_classes: Mapping[
            str,
            Any,
        ],
        table: Any,
    ) -> str | None:
        """
        Return the canonical class identifier owning one ORM table.
        """

        for (
            class_id,
            mapped_class,
        ) in automap_classes.items():
            candidate_table = getattr(
                mapped_class,
                "__table__",
                None,
            )

            if candidate_table is table:
                return class_id

            if (
                candidate_table is not None
                and candidate_table.name == table.name
                and candidate_table.schema == table.schema
            ):
                return class_id

        return None

    def _inheritance_local_columns(
        self,
        mapper: Any,
    ) -> frozenset[Any,]:
        """
        Return child-side columns participating in joined inheritance.
        """

        if mapper.inherits is None or mapper.inherit_condition is None:
            return frozenset()

        local_table = mapper.local_table

        return frozenset(
            element
            for element in self._iterate_sql_expression(
                mapper.inherit_condition,
            )
            if getattr(
                element,
                "table",
                None,
            )
            is local_table
        )

    def _is_inheritance_relationship(
        self,
        *,
        mapper: Any,
        relationship: Any,
        inheritance_columns: frozenset[Any,],
    ) -> bool:
        """
        Return whether one ORM relationship represents joined inheritance.
        """

        parent_mapper = mapper.inherits

        if parent_mapper is None:
            return False

        if relationship.mapper is not parent_mapper:
            return False

        return bool(
            set(
                relationship.local_columns,
            )
            & set(
                inheritance_columns,
            )
        )

    def _iterate_sql_expression(
        self,
        expression: Any,
    ) -> tuple[
        Any,
        ...,
    ]:
        """
        Return elements contained in one SQLAlchemy expression.

        The import is kept local to prevent the adapter's public API from
        exposing SQLAlchemy expression utilities.
        """

        from sqlalchemy.sql import visitors

        return tuple(
            visitors.iterate(
                expression,
            )
        )

    def _column_attribute_name(
        self,
        column: Any,
    ) -> str:
        """
        Return the ORM/source identifier represented by a column.
        """

        return str(
            getattr(
                column,
                "key",
                None,
            )
            or column.name
        )

    # ------------------------------------------------------------------
    # Reflected metadata construction
    # ------------------------------------------------------------------

    def _reflected_source_id(
        self,
        semantic_id: str,
    ) -> int:
        """
        Return a deterministic fallback source ID for reflected metadata.

        Reflected elements without a corresponding ``tww_sys`` dictionary row
        do not have a numeric dictionary identifier. A deterministic negative
        integer keeps them separate from ordinary positive dictionary IDs.

        This ID is metadata provenance only. Stable semantic identity remains
        the canonical class or attribute identifier.
        """

        checksum = crc32(
            semantic_id.encode(
                "utf-8",
            )
        )

        return -(checksum or 1)

    def _sqlalchemy_datatype(
        self,
        column: Any,
    ) -> str:
        """
        Return a canonical datatype description for an ORM column.
        """

        type_name = (
            type(
                column.type,
            )
            .__name__.strip()
            .lower()
        )

        if type_name == "geometry" or type_name.startswith(
            "geometry",
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

        return (
            str(
                column.type,
            )
            .strip()
            .lower()
        )

    # ------------------------------------------------------------------
    # Dictionary and reflected metadata merging
    # ------------------------------------------------------------------

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
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        """
        Merge reflected classes into authoritative dictionary metadata.
        """

        result = dict(
            dictionary,
        )

        for (
            key,
            metadata,
        ) in reflected.items():
            result.setdefault(
                key,
                metadata,
            )

        return result

    def _merge_attributes(
        self,
        *,
        dictionary: Mapping[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ],
        reflected: Mapping[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ],
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalAttributeMetadata,
    ]:
        """
        Merge reflected attributes into authoritative dictionary metadata.
        """

        result = dict(
            dictionary,
        )

        for (
            key,
            metadata,
        ) in reflected.items():
            result.setdefault(
                key,
                metadata,
            )

        return result

    # ------------------------------------------------------------------
    # tww_sys dictionary loading
    # ------------------------------------------------------------------

    def _dictionary_classes(
        self,
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        """
        Load canonical classes from ``dictionary_od_table``.
        """

        query = sql.SQL("""
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
            """).format(
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
        tuple[
            str,
            str,
        ],
        CanonicalAttributeMetadata,
    ]:
        """
        Load canonical attributes from ``dictionary_od_field``.
        """

        query = sql.SQL("""
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
            """).format(
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
        tuple[
            str,
            str,
            str,
        ],
        CanonicalValueMetadata,
    ]:
        """
        Load canonical values from ``dictionary_od_values``.
        """

        query = sql.SQL("""
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
            """).format(
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

    # ------------------------------------------------------------------
    # Dictionary-row conversion
    # ------------------------------------------------------------------

    def _class_metadata_from_row(
        self,
        row: Mapping[
            str,
            Any,
        ],
    ) -> CanonicalClassMetadata:
        """
        Convert one dictionary class row to canonical metadata.
        """

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
        row: Mapping[
            str,
            Any,
        ],
    ) -> CanonicalAttributeMetadata:
        """
        Convert one dictionary attribute row to canonical metadata.
        """

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
        row: Mapping[
            str,
            Any,
        ],
    ) -> CanonicalValueMetadata:
        """
        Convert one dictionary value row to canonical metadata.
        """

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
        row: Mapping[
            str,
            Any,
        ],
        name_prefix: str,
    ) -> LocalizedMetadata:
        """
        Convert localized dictionary columns into localized metadata.
        """

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
                names[language.value] = normalized_value

        return LocalizedMetadata(
            names=names,
        )

    def _is_geometry_datatype(
        self,
        field_datatype: str | None,
    ) -> bool:
        """
        Return whether one canonical datatype represents geometry.
        """

        if field_datatype is None:
            return False

        normalized = field_datatype.strip().lower()

        return normalized == "geometry" or normalized.startswith(
            "geometry(",
        )

    # ------------------------------------------------------------------
    # Database helpers
    # ------------------------------------------------------------------

    def _fetchall_dict(
        self,
        *,
        query: sql.Composable,
        parameters: Sequence[Any,] = (),
    ) -> list[
        dict[
            str,
            Any,
        ]
    ]:
        """
        Execute one query and return mapping-compatible result rows.
        """

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
        """
        Return a result-column name for psycopg 2 or psycopg 3.
        """

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

    def _canonical_foreign_key_index(
        self,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        tuple[
            str,
            ...,
        ],
    ]:
        """
        Return canonical FK attributes indexed by local and referenced class.
        """

        if self._canonical_foreign_key_index_cache is not None:
            return self._canonical_foreign_key_index_cache

        attributes_by_relation: dict[
            tuple[
                str,
                str,
            ],
            set[str,],
        ] = {}

        for foreign_key in self.foreign_keys():
            key = (
                foreign_key.class_id,
                foreign_key.referenced_class_id,
            )

            attributes_by_relation.setdefault(
                key,
                set(),
            ).add(
                foreign_key.attribute_id,
            )

        self._canonical_foreign_key_index_cache = {
            key: tuple(
                sorted(
                    attribute_ids,
                )
            )
            for (
                key,
                attribute_ids,
            ) in attributes_by_relation.items()
        }

        return self._canonical_foreign_key_index_cache
