from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import dataclass, field, replace
from enum import StrEnum
from typing import Any
from zlib import crc32

from psycopg import sql
from sqlalchemy import inspect, select
from sqlalchemy.orm import Session
from sqlalchemy.exc import NoInspectionAvailable
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.models.canonical_object import (
    CanonicalAttributeMetadata,
    CanonicalClassMetadata,
    CanonicalGeometryFamily,
    CanonicalGeometryMetadata,
    CanonicalModelMetadata,
    CanonicalValueMetadata,
    LocalizedMetadata,
)
from teksi_hooks.models.mapping import (
    CanonicalViewMapping,
)

from ...interlis.interlis_model_mapping.model_tww_od import (
    ModelTwwOd,
)

from ...interlis.interlis_model_mapping.model_tww_ag6496 import (
    ModelTwwAG6496,
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

    canonical_schema: str = "tww_od"

    reflected_class_ids: frozenset[
        str,
    ] | None = None

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

    canonical_view_automap_classes: (
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

    _canonical_foreign_keys_cache: tuple[
        CanonicalForeignKeyMetadata,
        ...,
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _resolved_automap_classes_cache: dict[
        str,
        Any,
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _canonical_foreign_key_index_cache: dict[
        tuple[
            str,
            str,
        ],
        tuple[
            str,
            ...,
        ],
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _resolved_canonical_view_classes_cache: dict[
        tuple[
            str,
            str,
        ],
        Any,
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _canonical_geometry_cache: dict[
        tuple[
            str,
            str,
        ],
        CanonicalGeometryMetadata,
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    _geometry_attribute_aliases_cache: dict[
        tuple[
            str,
            str,
        ],
        str,
    ] | None = field(
        default=None,
        init=False,
        repr=False,
    )

    # ------------------------------------------------------------------
    # Public canonical-model API
    # ------------------------------------------------------------------

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
            if key[
                0
            ]
            == class_id
        }

    def canonical_class(
        self,
        class_id: str,
    ) -> Any:
        """
        Return the writable canonical ORM class for one physical class identifier.
        """

        canonical_class = (
            self._resolved_automap_classes().get(
                class_id,
            )
        )

        if canonical_class is None:
            raise KeyError(
                "No canonical ORM class exists for "
                f"{class_id!r}."
            )

        return canonical_class

    def canonical_model(
        self,
    ) -> CanonicalModelMetadata:
        """
        Return complete canonical metadata.

        Dictionary definitions remain authoritative for ordinary semantic and
        localized metadata. ORM reflection supplies physical classes and
        attributes missing from the dictionary.

        Physical PostGIS geometry metadata is authoritative for geometry column
        names, exact subtypes, coordinate dimensions, SRIDs, and broad geometry
        families.
        """

        if self._canonical_model_cache is not None:
            return self._canonical_model_cache

        dictionary_classes = (
            self._dictionary_classes()
        )

        dictionary_attributes = (
            self._dictionary_attributes()
        )

        dictionary_values = (
            self._dictionary_values()
        )

        automap_classes = (
            self._resolved_automap_classes()
        )

        reflected_classes = self._reflected_classes(
            automap_classes=automap_classes,
        )

        reflected_attributes = (
            self._reflected_attributes(
                automap_classes=automap_classes,
            )
        )

        merged_classes = self._merge_classes(
            dictionary=dictionary_classes,
            reflected=reflected_classes,
        )

        merged_classes = (
            self._with_geometry_classes(
                classes=merged_classes,
            )
        )

        merged_attributes = self._merge_attributes(
            dictionary=dictionary_attributes,
            reflected=reflected_attributes,
        )

        merged_attributes = (
            self._with_geometry_attributes(
                attributes=merged_attributes,
            )
        )

        self._canonical_foreign_keys_cache = (
            self._reflected_foreign_keys(
                automap_classes=automap_classes,
            )
        )

        self._canonical_model_cache = (
            CanonicalModelMetadata(
                classes=merged_classes,
                attributes=merged_attributes,
                values=dictionary_values,
            )
        )

        return self._canonical_model_cache

    def canonical_view_class(
        self,
        view: CanonicalViewMapping,
    ) -> Any:
        """
        Return the ORM class for one canonical comparison view.

        Canonical comparison views are read-only projection sources. They are
        resolved independently from writable canonical model classes and are not
        added to ``CanonicalModelMetadata``.
        """

        key = (
            view.schema,
            view.name,
        )

        resolved_views = (
            self._resolved_canonical_view_classes()
        )

        view_class = resolved_views.get(
            key,
        )

        if view_class is None:
            available_views = tuple(
                sorted(
                    resolved_views,
                )
            )

            raise KeyError(
                "No canonical comparison ORM class exists for "
                f"{view.schema!r}.{view.name!r}. Available views: "
                f"{available_views!r}."
            )

        identity_attribute = getattr(
            view_class,
            view.identity_attribute,
            None,
        )

        if identity_attribute is None:
            raise ValueError(
                "Canonical comparison view "
                f"{view.schema!r}.{view.name!r} does not expose "
                "configured identity attribute "
                f"{view.identity_attribute!r}."
            )

        return view_class
    
    def canonical_view_rows_by_identity(
        self,
        *,
        view: CanonicalViewMapping,
        identities: Sequence[
            Any,
        ],
        session: Session,
    ) -> dict[
        Any,
        Any,
    ]:
        """
        Return canonical comparison rows keyed by configured identity.

        The complete identity collection is loaded in one query. Projection
        implementations must use this method instead of querying the canonical
        view once per source row.

        Duplicate identities are rejected because a canonical comparison view
        must expose at most one semantic row per source object.
        """

        view_class = self.canonical_view_class(
            view,
        )

        identity_column = getattr(
            view_class,
            view.identity_attribute,
        )

        unique_identities = tuple(
            dict.fromkeys(
                identity
                for identity in identities
                if identity is not None
            )
        )

        if not unique_identities:
            return {}

        rows = tuple(
            session.scalars(
                select(
                    view_class,
                ).where(
                    identity_column.in_(
                        unique_identities,
                    )
                )
            )
        )

        rows_by_identity: dict[
            Any,
            Any,
        ] = {}

        for row in rows:
            identity = getattr(
                row,
                view.identity_attribute,
            )

            if identity in rows_by_identity:
                raise RuntimeError(
                    "Canonical comparison view "
                    f"{view.schema!r}.{view.name!r} returned "
                    "several rows for identity "
                    f"{identity!r}."
                )

            rows_by_identity[
                identity
            ] = row

        return rows_by_identity

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

    def clear_cache(
        self,
    ) -> None:
        self._canonical_model_cache = None
        self._canonical_foreign_keys_cache = None
        self._canonical_foreign_key_index_cache = None
        self._resolved_automap_classes_cache = None
        self._resolved_canonical_view_classes_cache = None
        self._canonical_geometry_cache = None
        self._geometry_attribute_aliases_cache = None
  
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

        foreign_keys = (
            self._canonical_foreign_keys_cache
            or ()
        )

        return tuple(
            foreign_key
            for foreign_key in foreign_keys
            if (
                class_id is None
                or foreign_key.class_id
                == class_id
            )
            and (
                referenced_class_id is None
                or foreign_key.referenced_class_id
                == referenced_class_id
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
            if foreign_key.attribute_id
            == attribute_id
        )

        if not matches:
            return None

        if len(
            matches,
        ) != 1:
            raise RuntimeError(
                "Several canonical foreign-key definitions exist for "
                f"{class_id!r}.{attribute_id!r}: {matches!r}."
            )

        return matches[
            0
        ]

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

    def geometry_metadata(
        self,
        *,
        class_id: str,
        attribute_id: str,
    ) -> CanonicalGeometryMetadata | None:
        """
        Return physical metadata for one canonical geometry attribute.
        """

        return self._canonical_geometries().get(
            (
                class_id,
                attribute_id,
            )
        )

    def geometry_attribute_names(
        self,
        class_id: str,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return physical geometry attribute identifiers for one canonical class.
        """

        return tuple(
            sorted(
                attribute_id
                for (
                    geometry_class_id,
                    attribute_id,
                ) in self._canonical_geometries()
                if geometry_class_id == class_id
            )
        )

    def geometry_family(
        self,
        *,
        class_id: str,
        attribute_id: str,
    ) -> CanonicalGeometryFamily:
        """
        Return the broad family of one canonical geometry attribute.
        """

        metadata = self.geometry_metadata(
            class_id=class_id,
            attribute_id=attribute_id,
        )

        if metadata is None:
            raise KeyError(
                "No physical canonical geometry exists "
                f"for {class_id!r}.{attribute_id!r}."
            )

        return metadata.family

    def geometry_families(
        self,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalGeometryFamily,
    ]:
        """
        Return geometry families keyed by physical canonical attributes.
        """

        return {
            key: metadata.family
            for (
                key,
                metadata,
            ) in self._canonical_geometries().items()
        }

    def is_geometry_attribute(
        self,
        class_id: str,
        attribute_id: str,
    ) -> bool:
        """
        Return whether one physical canonical attribute is a geometry.
        """

        return (
            class_id,
            attribute_id,
        ) in self._canonical_geometries()   

    def physical_attribute_id(
        self,
        *,
        class_id: str,
        attribute_id: str,
    ) -> str:
        """
        Return the executable physical canonical attribute identifier.
        """

        normalized_class_id = class_id.strip()
        normalized_attribute_id = (
            attribute_id.strip()
        )

        if (
            not normalized_class_id
            or not normalized_attribute_id
        ):
            raise ValueError(
                "Canonical class and attribute identifiers "
                "must not be empty."
            )

        key = (
            normalized_class_id,
            normalized_attribute_id,
        )

        if key in self._canonical_geometries():
            return normalized_attribute_id

        return self._geometry_attribute_aliases().get(
            key,
            normalized_attribute_id,
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
            if (
                class_id is None
                or key[
                    0
                ]
                == class_id
            )
            and (
                attribute_id is None
                or key[
                    1
                ]
                == attribute_id
            )
        }

    # ------------------------------------------------------------------
    # Canonical ORM discovery
    # ------------------------------------------------------------------

    def _resolved_canonical_view_classes(
        self,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        Any,
    ]:
        """
        Return canonical comparison ORM classes keyed by schema and relation.

        Canonical comparison views are read-only projection sources. They remain
        separate from writable canonical ORM classes and are not included in
        ``CanonicalModelMetadata``.

        Both mapping-style collections and SQLAlchemy automap-style class
        namespaces are supported.

        For mapping-style collections, the preferred key is:

            (schema_name, relation_name)

        Schema-qualified string keys are also accepted:

            "schema_name.relation_name"

        Otherwise, schema and relation names are derived from the mapped class's
        ``__table__`` metadata.
        """

        if (
            self._resolved_canonical_view_classes_cache
            is not None
        ):
            return (
                self
                ._resolved_canonical_view_classes_cache
            )

        raw_classes = (
            self._canonical_view_automap_classes()
        )

        resolved: dict[
            tuple[
                str,
                str,
            ],
            Any,
        ] = {}

        if isinstance(
            raw_classes,
            Mapping,
        ):
            candidates = tuple(
                (
                    configured_key,
                    mapped_class,
                )
                for (
                    configured_key,
                    mapped_class,
                ) in raw_classes.items()
            )

        else:
            candidates = tuple(
                (
                    None,
                    candidate,
                )
                for attribute_name in dir(
                    raw_classes,
                )
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

        for (
            configured_key,
            mapped_class,
        ) in candidates:
            if mapped_class is None:
                continue

            table = getattr(
                mapped_class,
                "__table__",
                None,
            )

            if table is None:
                continue

            key = self._canonical_view_key(
                configured_key=configured_key,
                mapped_class=mapped_class,
            )

            existing = resolved.get(
                key,
            )

            if (
                existing is not None
                and existing is not mapped_class
            ):
                raise RuntimeError(
                    "Several canonical comparison ORM classes "
                    "resolve to view "
                    f"{key[0]!r}.{key[1]!r}."
                )

            self._validate_canonical_view_class(
                mapped_class=mapped_class,
                key=key,
            )

            resolved[
                key
            ] = mapped_class

        self._resolved_canonical_view_classes_cache = (
            resolved
        )

        return resolved

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
            candidates = tuple(
                raw_classes.values()
            )

        else:
            candidates = tuple(
                candidate
                for attribute_name in dir(
                    raw_classes
                )
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

            if (
                existing is not None
                and existing is not mapped_class
            ):
                raise RuntimeError(
                    "Several canonical ORM classes resolve to "
                    f"physical class identifier {class_id!r}."
                )

            resolved[
                class_id
            ] = mapped_class

        if self.reflected_class_ids is not None:
            missing_class_ids = (
                set(
                    self.reflected_class_ids,
                )
                - set(
                    resolved,
                )
            )

            if missing_class_ids:
                raise RuntimeError(
                    "Configured canonical ORM classes are unavailable "
                    f"from ModelTwwOd: "
                    f"{tuple(sorted(missing_class_ids))!r}."
                )

            resolved = {
                class_id: resolved[
                    class_id
                ]
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
        return dict(
            ModelTwwOd().classes(),
        )


    def _canonical_geometries(
        self,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        CanonicalGeometryMetadata,
    ]:
        """
        Return cached geometry metadata for the physical canonical schema.

        PostGIS ``geometry_columns`` is authoritative for physical geometry
        attributes. Dictionary definitions are deliberately not used because they
        may:

        - contain 2D/3D representation variants;
        - use semantic names differing from physical columns;
        - omit geometries declared by extension classes.
        """

        if self._canonical_geometry_cache is not None:
            return self._canonical_geometry_cache

        query = sql.SQL(
            """
            SELECT
                f_table_name AS class_id,
                f_geometry_column AS attribute_id,
                coord_dimension,
                srid,
                type AS geometry_type
            FROM
                geometry_columns
            WHERE
                f_table_schema = %s
            ORDER BY
                f_table_name,
                f_geometry_column;
            """
        )

        rows = self._fetchall_dict(
            query=query,
            parameters=(
                self.canonical_schema,
            ),
        )

        geometries: dict[
            tuple[
                str,
                str,
            ],
            CanonicalGeometryMetadata,
        ] = {}

        for row in rows:
            class_id = self._required_metadata_identifier(
                row.get(
                    "class_id",
                ),
                field_name="class_id",
            )

            attribute_id = (
                self._required_metadata_identifier(
                    row.get(
                        "attribute_id",
                    ),
                    field_name="attribute_id",
                )
            )

            geometry_type = (
                self._required_metadata_identifier(
                    row.get(
                        "geometry_type",
                    ),
                    field_name="geometry_type",
                )
                .upper()
            )

            coordinate_dimension = int(
                row[
                    "coord_dimension"
                ]
            )

            srid = int(
                row[
                    "srid"
                ]
            )

            key = (
                class_id,
                attribute_id,
            )

            if key in geometries:
                raise RuntimeError(
                    "PostGIS returned several geometry "
                    "definitions for canonical attribute "
                    f"{class_id!r}.{attribute_id!r}."
                )

            geometries[
                key
            ] = CanonicalGeometryMetadata(
                source_id=self._reflected_source_id(
                    "geometry:"
                    f"{class_id}."
                    f"{attribute_id}"
                ),
                identifier=attribute_id,
                localized=LocalizedMetadata(),
                field_datatype=(
                    "geometry("
                    f"{geometry_type.lower()}"
                    ")"
                ),
                geometry_type=geometry_type,
                family=self._geometry_family_from_type(
                    geometry_type,
                ),
                coordinate_dimension=(
                    coordinate_dimension
                ),
                srid=srid,
            )

        self._canonical_geometry_cache = (
            geometries
        )

        return geometries

    def _canonical_view_automap_classes(
        self,
    ) -> Mapping[
        Any,
        Any,
    ]:
        """
        Return configured canonical comparison ORM classes.

        Canonical views are intentionally not inferred from ``ModelTwwOd``.
        They belong to schemas such as ``tww_app`` and are read-only semantic
        projection sources.

        The composition root must supply their mapped SQLAlchemy classes.
        """

        if (
            self.canonical_view_automap_classes
            is not None
        ):
            return self.canonical_view_automap_classes
        
        return ModelTwwAG6496().classes()
        

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
        ) in sorted(
            automap_classes.items()
        ):
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
        ) in sorted(
            automap_classes.items()
        ):
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
                            "attribute:"
                            f"{class_id}."
                            f"{attribute_id}",
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
        ) in sorted(
            automap_classes.items()
        ):
            try:
                mapper = inspect(
                    mapped_class,
                )
            except NoInspectionAvailable:
                continue

            inheritance_columns = (
                self._inheritance_local_columns(
                    mapper,
                )
            )

            for relationship in mapper.relationships:
                if self._is_inheritance_relationship(
                    mapper=mapper,
                    relationship=relationship,
                    inheritance_columns=(
                        inheritance_columns
                    ),
                ):
                    continue

                referenced_class = (
                    relationship.mapper.class_
                )

                referenced_class_id = (
                    class_id_by_mapped_class.get(
                        referenced_class,
                    )
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
                        referenced_column = (
                            foreign_key.column
                        )

                        referenced_table = getattr(
                            referenced_column,
                            "table",
                            None,
                        )

                        if referenced_table is None:
                            continue

                        target_class_id = (
                            self._class_id_for_table(
                                automap_classes=(
                                    automap_classes
                                ),
                                table=referenced_table,
                            )
                            or referenced_class_id
                        )

                        referenced_attribute_id = (
                            self._column_attribute_name(
                                referenced_column,
                            )
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
                                referenced_class_id=(
                                    target_class_id
                                ),
                                referenced_attribute_id=(
                                    referenced_attribute_id
                                ),
                            ),
                        )

        return tuple(
            foreign_keys[
                key
            ]
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

                if not isinstance(
                    attribute_id,
                    str,
                ) or not attribute_id:
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
                    columns[
                        0
                    ],
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
                key=lambda item: item[
                    0
                ],
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
                and candidate_table.name
                == table.name
                and candidate_table.schema
                == table.schema
            ):
                return class_id

        return None

    def _inheritance_local_columns(
        self,
        mapper: Any,
    ) -> frozenset[
        Any,
    ]:
        """
        Return child-side columns participating in joined inheritance.
        """

        if (
            mapper.inherits is None
            or mapper.inherit_condition is None
        ):
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
        inheritance_columns: frozenset[
            Any,
        ],
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

    def _validate_canonical_view_class(
        self,
        *,
        mapped_class: Any,
        key: tuple[
            str,
            str,
        ],
    ) -> None:
        """
        Validate one read-only canonical comparison ORM class.

        SQLAlchemy ORM classes require at least one mapper primary-key attribute,
        even when the underlying database relation is a view without a declared
        database primary key.
        """

        try:
            mapper = inspect(
                mapped_class,
            )

        except NoInspectionAvailable as exception:
            raise TypeError(
                "Canonical comparison class for "
                f"{key[0]!r}.{key[1]!r} is not a mapped "
                "SQLAlchemy class."
            ) from exception

        primary_key = tuple(
            mapper.primary_key,
        )

        if not primary_key:
            raise ValueError(
                "Canonical comparison ORM class for "
                f"{key[0]!r}.{key[1]!r} does not define an ORM "
                "primary key. Configure the canonical view's "
                "semantic identity as the SQLAlchemy mapper "
                "primary key."
            )

    def _with_geometry_attributes(
        self,
        *,
        attributes: Mapping[
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
        Overlay authoritative physical geometry metadata.

        Exact dictionary metadata is retained only when it already uses the same
        physical class and attribute identifier. In that case its source ID and
        localized names supplement the PostGIS definition.

        PostGIS geometry properties remain authoritative.
        """

        result = dict(
            attributes,
        )

        for (
            key,
            geometry_metadata,
        ) in self._canonical_geometries().items():
            existing_metadata = result.get(
                key,
            )

            if existing_metadata is None:
                result[
                    key
                ] = geometry_metadata

                continue

            result[
                key
            ] = replace(
                geometry_metadata,
                source_id=(
                    existing_metadata.source_id
                ),
                localized=(
                    existing_metadata.localized
                ),
            )

        return result

    def _with_geometry_classes(
        self,
        *,
        classes: Mapping[
            str,
            CanonicalClassMetadata,
        ],
    ) -> dict[
        str,
        CanonicalClassMetadata,
    ]:
        """
        Add canonical classes represented by physical geometry columns.

        Existing dictionary or ORM class metadata remains authoritative.
        """

        result = dict(
            classes,
        )

        geometry_class_ids = {
            class_id
            for (
                class_id,
                _attribute_id,
            ) in self._canonical_geometries()
        }

        for class_id in sorted(
            geometry_class_ids,
        ):
            result.setdefault(
                class_id,
                CanonicalClassMetadata(
                    source_id=self._reflected_source_id(
                        f"class:{class_id}",
                    ),
                    identifier=class_id,
                    localized=LocalizedMetadata(),
                ),
            )

        return result

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

        return -(
            checksum
            or 1
        )

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

        if (
            type_name == "geometry"
            or type_name.startswith(
                "geometry",
            )
        ):
            geometry_type = getattr(
                column.type,
                "geometry_type",
                None,
            )

            if geometry_type is None:
                return "geometry"

            normalized_geometry_type = (
                str(
                    geometry_type,
                )
                .strip()
                .lower()
            )

            if not normalized_geometry_type:
                return "geometry"

            return (
                "geometry("
                f"{normalized_geometry_type}"
                ")"
            )

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
                row[
                    "class_id"
                ],
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
        Load ordinary canonical attributes from ``dictionary_od_field``.

        Geometry attributes are excluded. Physical geometry metadata is loaded
        independently from PostGIS ``geometry_columns`` because dictionary
        geometry definitions may contain representation variants, use semantic
        rather than physical names, or omit extension-class geometries.
        """

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
            FROM {schema}.dictionary_od_field AS f
            JOIN {schema}.dictionary_od_table AS t
            ON t.id = f.class_id
            WHERE
                COALESCE(
                    lower(
                        trim(
                            f.field_datatype
                        )
                    ),
                    ''
                ) NOT LIKE %s
            ORDER BY
                t.tablename,
                f.field_name;
            """
        ).format(
            schema=sql.Identifier(
                self.schema,
            ),
        )

        rows = self._fetchall_dict(
            query=query,
            parameters=(
                "geometry%",
            ),
        )

        attributes: dict[
            tuple[
                str,
                str,
            ],
            CanonicalAttributeMetadata,
        ] = {}

        for row in rows:
            class_id = str(
                row[
                    "class_id"
                ]
            )

            attribute_id = str(
                row[
                    "attribute_id"
                ]
            )

            key = (
                class_id,
                attribute_id,
            )

            if key in attributes:
                raise RuntimeError(
                    "Several dictionary attributes resolve to "
                    f"{class_id!r}.{attribute_id!r}."
                )

            attributes[
                key
            ] = self._attribute_metadata_from_row(
                row,
            )

        return attributes

    def _dictionary_geometry_identifiers(
        self,
    ) -> tuple[
        tuple[
            str,
            str,
        ],
        ...,
    ]:
        """
        Return semantic geometry identifiers from the TWW dictionary.

        These identifiers are used only to resolve source-to-canonical mappings
        to physical PostGIS attributes. They are not treated as executable
        canonical attributes themselves.
        """

        query = sql.SQL(
            """
            SELECT
                t.tablename AS class_id,
                f.field_name AS attribute_id
            FROM {schema}.dictionary_od_field AS f
            JOIN {schema}.dictionary_od_table AS t
            ON t.id = f.class_id
            WHERE
                COALESCE(
                    lower(
                        trim(
                            f.field_datatype
                        )
                    ),
                    ''
                ) LIKE %s
            ORDER BY
                t.tablename,
                f.field_name;
            """
        ).format(
            schema=sql.Identifier(
                self.schema,
            ),
        )

        rows = self._fetchall_dict(
            query=query,
            parameters=(
                "geometry%",
            ),
        )

        result: list[
            tuple[
                str,
                str,
            ],
        ] = []

        seen: set[
            tuple[
                str,
                str,
            ],
        ] = set()

        for row in rows:
            class_id = str(
                row[
                    "class_id"
                ]
            ).strip()

            attribute_id = str(
                row[
                    "attribute_id"
                ]
            ).strip()

            if (
                not class_id
                or not attribute_id
            ):
                continue

            key = (
                class_id,
                attribute_id,
            )

            if key in seen:
                continue

            seen.add(
                key,
            )

            result.append(
                key,
            )

        return tuple(
            result,
        )

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
                    row[
                        "class_id"
                    ],
                ),
                str(
                    row[
                        "attribute_id"
                    ],
                ),
                str(
                    row[
                        "value_id"
                    ],
                ),
            ): self._value_metadata_from_row(
                row,
            )
            for row in rows
        }

    def _geometry_attribute_aliases(
        self,
    ) -> dict[
            tuple[
                str,
                str,
            ],
            str,
        ]:
        """
        Return semantic-to-physical canonical geometry attribute aliases.

        Dictionary geometry names describe semantic canonical attributes, while
        PostGIS geometry metadata describes executable physical columns.

        Matching is performed within one canonical class using a normalized
        geometry stem. Exact physical matches take precedence. Ambiguous matches
        are rejected.
        """

        if (
            self._geometry_attribute_aliases_cache
            is not None
        ):
            return dict(
                self._geometry_attribute_aliases_cache,
            )

        dictionary_geometries = (
            self._dictionary_geometry_identifiers()
        )

        physical_geometries_by_class: dict[
            str,
            list[
                str,
            ],
        ] = {}

        for (
            class_id,
            attribute_id,
        ) in self._canonical_geometries():
            physical_geometries_by_class.setdefault(
                class_id,
                [],
            ).append(
                attribute_id,
            )

        aliases: dict[
            tuple[
                str,
                str,
            ],
            str,
        ] = {}

        for (
            class_id,
            dictionary_attribute_id,
        ) in dictionary_geometries:
            physical_attribute_ids = (
                physical_geometries_by_class.get(
                    class_id,
                    [],
                )
            )

            if not physical_attribute_ids:
                continue

            if (
                dictionary_attribute_id
                in physical_attribute_ids
            ):
                aliases[
                    (
                        class_id,
                        dictionary_attribute_id,
                    )
                ] = dictionary_attribute_id

                continue

            dictionary_stem = (
                self._geometry_attribute_stem(
                    dictionary_attribute_id,
                )
            )

            matching_physical_attributes = tuple(
                sorted(
                    physical_attribute_id
                    for physical_attribute_id
                    in physical_attribute_ids
                    if (
                        self._geometry_attribute_stem(
                            physical_attribute_id,
                        )
                        == dictionary_stem
                    )
                )
            )

            if not matching_physical_attributes:
                continue

            if (
                len(
                    matching_physical_attributes,
                )
                != 1
            ):
                raise RuntimeError(
                    "Dictionary geometry attribute "
                    f"{class_id!r}."
                    f"{dictionary_attribute_id!r} matches "
                    "several physical canonical geometry "
                    "columns: "
                    f"{matching_physical_attributes!r}."
                )

            aliases[
                (
                    class_id,
                    dictionary_attribute_id,
                )
            ] = matching_physical_attributes[
                0
            ]

        self._geometry_attribute_aliases_cache = (
            aliases
        )

        return dict(
            aliases,
        )

    # ------------------------------------------------------------------
    # Dictionary-row conversion
    # ------------------------------------------------------------------

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
            source_id=row[
                "source_id"
            ],
            identifier=str(
                row[
                    "attribute_id"
                ],
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
            source_id=row[
                "source_id"
            ],
            identifier=str(
                row[
                    "class_id"
                ],
            ),
            localized=self._localized_metadata(
                row=row,
                name_prefix="name",
            ),
        )

    def _geometry_attribute_stem(
        self,
        attribute_id: str,
    ) -> str:
        """
        Return a normalized geometry attribute stem.

        Physical representation suffixes are removed repeatedly so dictionary and
        database names can be compared.

        Examples:

        - ``area`` -> ``area``
        - ``area_geometry`` -> ``area``
        - ``detail_geometry`` -> ``detail``
        - ``detail_geometry3d`` -> ``detail``
        - ``detail_geometry3d_geometry`` -> ``detail``
        """

        normalized = (
            attribute_id
            .strip()
            .casefold()
        )

        if not normalized:
            raise ValueError(
                "Geometry attribute identifiers must not "
                "be empty."
            )

        previous = None

        while previous != normalized:
            previous = normalized

            if normalized.endswith(
                "_geometry",
            ):
                normalized = normalized[
                    :-len(
                        "_geometry"
                    )
                ]

            if normalized.endswith(
                "3d",
            ):
                normalized = normalized[
                    :-len(
                        "3d"
                    )
                ]

            if normalized.endswith(
                "2d",
            ):
                normalized = normalized[
                    :-len(
                        "2d"
                    )
                ]

            normalized = normalized.rstrip(
                "_",
            )

        if not normalized:
            raise ValueError(
                "Could not derive a geometry attribute "
                f"stem from {attribute_id!r}."
            )

        return normalized

    def _is_geometry_datatype(
        self,
        field_datatype: str | None,
    ) -> bool:
        """
        Return whether one canonical datatype represents geometry.
        """

        if field_datatype is None:
            return False

        normalized = (
            field_datatype
            .strip()
            .lower()
        )

        return (
            normalized
            == "geometry"
            or normalized.startswith(
                "geometry(",
            )
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
                names[
                    language.value
                ] = normalized_value

        return LocalizedMetadata(
            names=names,
        )

    def _required_metadata_identifier(
        self,
        value: Any,
        *,
        field_name: str,
    ) -> str:
        """
        Return one required non-*mpty PostGIS metadata identifier.
        """

        if (
            not isinstance(
                value,
               str,
            )
            or not value.strip()
        ):
            raise RuntimeError(
                "PostGIS geometry metadata contains an "
               f"invalid {field_name!r}: {value!r}."
            )

        return value.strip()

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
            source_id=row[
                "source_id"
            ],
            identifier=str(
                row[
                    "value_id"
                ],
            ),
            localized=self._localized_metadata(
                row=row,
                name_prefix="value_name",
            ),
        )

    # ------------------------------------------------------------------
    # Database helpers
    # ------------------------------------------------------------------

    def _fetchall_dict(
        self,
        *,
        query: sql.Composable,
        parameters: Sequence[
            Any,
        ] = (),
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
            column[
                0
            ],
        )

    def _geometry_family_from_type(
        self,
        geometry_type: str,
    ) -> CanonicalGeometryFamily:
        """
        Return the broad canonical family for one PostGIS geometry subtype.

        Coordinate dimensions do not change the geometry family. For example,
        ``LINESTRING``, ``LINESTRINGZ``, and ``LINESTRINGZM`` all belong to the
        line family.
        """

        normalized_type = (
            geometry_type
            .strip()
            .upper()
            .replace(
                " ",
                "",
            )
            .replace(
                "_",
                "",
            )
        )

        for dimensional_suffix in (
            "ZM",
            "Z",
            "M",
        ):
            if normalized_type.endswith(
                dimensional_suffix,
            ):
                normalized_type = normalized_type[
                    :-len(
                        dimensional_suffix
                    )
                ]

                break

        if normalized_type in {
            "POINT",
            "MULTIPOINT",
        }:
            return CanonicalGeometryFamily.POINT

        if normalized_type in {
            "LINESTRING",
            "MULTILINESTRING",
            "CIRCULARSTRING",
            "COMPOUNDCURVE",
            "MULTICURVE",
            "CURVE",
        }:
            return CanonicalGeometryFamily.LINE

        if normalized_type in {
            "POLYGON",
            "MULTIPOLYGON",
            "CURVEPOLYGON",
            "MULTISURFACE",
            "SURFACE",
        }:
            return CanonicalGeometryFamily.POLYGON

        raise RuntimeError(
            "Unsupported canonical PostGIS geometry "
            f"type {geometry_type!r}."
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
            set[
                str,
            ],
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

    def _canonical_view_key(
        self,
        *,
        configured_key: Any,
        mapped_class: Any,
    ) -> tuple[
        str,
        str,
    ]:
        """
        Return the schema-qualified identity of one canonical view class.

        Explicit mapping keys take precedence over SQLAlchemy table metadata.
        This is useful for view mappings whose generated ORM metadata does not
        retain the database schema.
        """

        if (
            isinstance(
                configured_key,
                tuple,
            )
            and len(
                configured_key,
            )
            == 2
        ):
            schema_name = str(
                configured_key[
                    0
                ],
            ).strip()

            relation_name = str(
                configured_key[
                    1
                ],
            ).strip()

            if (
                not schema_name
                or not relation_name
            ):
                raise ValueError(
                    "Canonical comparison view mapping keys "
                    "must contain non-empty schema and relation "
                    "names."
                )

            return (
                schema_name,
                relation_name,
            )

        if isinstance(
            configured_key,
            str,
        ):
            configured_parts = configured_key.split(
                ".",
                maxsplit=1,
            )

            if len(
                configured_parts,
            ) == 2:
                schema_name = (
                    configured_parts[
                        0
                    ].strip()
                )

                relation_name = (
                    configured_parts[
                        1
                    ].strip()
                )

                if (
                    schema_name
                    and relation_name
                ):
                    return (
                        schema_name,
                        relation_name,
                    )

        table = mapped_class.__table__

        schema_name = getattr(
            table,
            "schema",
            None,
        )

        relation_name = getattr(
            table,
            "name",
            None,
        )

        if (
            not isinstance(
                schema_name,
                str,
            )
            or not schema_name.strip()
        ):
            raise ValueError(
                "Canonical comparison ORM class "
                f"{mapped_class!r} does not expose a schema. "
                "Configure it using a `(schema, relation)` "
                "mapping key."
            )

        if (
            not isinstance(
                relation_name,
                str,
            )
            or not relation_name.strip()
        ):
            raise ValueError(
                "Canonical comparison ORM class "
                f"{mapped_class!r} does not expose a relation "
                "name."
            )

        return (
            schema_name.strip(),
            relation_name.strip(),
        )