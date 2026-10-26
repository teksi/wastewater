from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any
from collections.abc import Mapping

from sqlalchemy import inspect
from sqlalchemy.exc import NoInspectionAvailable
from sqlalchemy.orm import Session
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.effects import (
    CanonicalViewEffectProjector,
)
from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EffectSource,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ForeignKeyMapping,
    RelationContext,
)
from teksi_hooks.services.relation_context_provider import (
    RelationContextProvider,
)

try:
    from psycopg import sql
except ImportError:
    from psycopg2 import sql


@dataclass(
    frozen=True,
    slots=True,
)
class SourceForeignKeyTarget:
    relation: Any
    referenced_column: Any


@dataclass(
    slots=True,
)
class TwwQuarantineEffectProjector:
    """
    Project quarantine rows into canonical effects.

    Declaratively mapped source classes are projected through model mapping
    metadata.

    Projection-backed source classes are delegated to a
    ``CanonicalViewEffectProjector``, which compares the complete source
    class against a read-only canonical comparison view.

    This service does not:

    - evaluate rights;
    - classify changes;
    - validate business rules;
    - write review artifacts;
    - write tww_diff rows;
    - commit, roll back, or close caller-owned sessions.
    """

    model_mapping: EffectiveModelMappingCapability

    connection_factory: DatabaseConnectionFactory

    relation_context_provider: RelationContextProvider

    canonical_view_effect_projector: CanonicalViewEffectProjector

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    _source_identity_cache: dict[
        tuple[
            str,
            str,
            str,
        ],
        dict[
            int,
            str,
        ],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_foreign_key_target_cache: dict[
        tuple[
            Any,
            str,
        ],
        SourceForeignKeyTarget | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_identity_owner_cache: dict[
        Any,
        tuple[
            Any,
            str,
        ]
        | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    def clear_cache(
        self,
    ) -> None:
        """
        Clear identities derived from populated quarantine schemas.

        This must be called if a quarantine schema is recreated and repopulated
        while the same projector instance remains in use.
        """

        self._source_identity_cache.clear()
        self._source_foreign_key_target_cache.clear()
        self._source_identity_owner_cache.clear()

    def effect_document_from_quarantine(
        self,
        *,
        schema: str,
        source_model: str,
        canonical_metadata: CanonicalModelMetadata,
        quarantine_session: Session,
        live_session: Session,
    ) -> EffectDocument:
        """
        Project the current quarantine schema into one canonical effect document.

        Both sessions are caller-owned. This service must not commit, roll back,
        or close either session.
        """

        effects: list[Effect,] = []

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            with connection.cursor() as cursor:
                for relation_context in self.relation_context_provider.relation_contexts():
                    effects.extend(
                        self._effects_for_relation_context(
                            cursor=cursor,
                            relation_context=(relation_context),
                            schema=schema,
                            source_model=source_model,
                            canonical_metadata=(canonical_metadata),
                            quarantine_session=(quarantine_session),
                            live_session=live_session,
                        )
                    )

        return EffectDocument(
            source=EffectSource(
                model=source_model,
                class_id="quarantine",
                object_id=schema,
            ),
            effects=tuple(
                effects,
            ),
        )

    def _effects_for_relation_context(
        self,
        *,
        cursor,
        relation_context: RelationContext,
        schema: str,
        source_model: str,
        canonical_metadata: CanonicalModelMetadata,
        quarantine_session: Session,
        live_session: Session,
    ) -> tuple[
        Effect,
        ...,
    ]:
        """
        Project one source relation through its configured mapping strategy.
        """

        class_mapping = relation_context.class_mapping

        if class_mapping.is_projection_backed:
            return self._projection_effects_for_relation_context(
                relation_context=relation_context,
                source_model=source_model,
                quarantine_session=quarantine_session,
                live_session=live_session,
            )

        if not class_mapping.is_attribute_backed:
            return ()

        effects: list[Effect,] = []

        for row in self._rows(
            cursor=cursor,
            schema=schema,
            relation=relation_context.relation,
        ):
            effects.extend(
                self._attribute_effects(
                    relation=relation_context.relation,
                    row=row,
                    source_class_id=(relation_context.source_class_id),
                    class_mapping=class_mapping,
                    canonical_metadata=(canonical_metadata),
                    cursor=cursor,
                    schema=schema,
                )
            )

        return tuple(
            effects,
        )

    def _projection_effects_for_relation_context(
        self,
        *,
        relation_context: RelationContext,
        source_model: str,
        quarantine_session: Session,
        live_session: Session,
    ) -> tuple[
        Effect,
        ...,
    ]:
        """
        Project one complete source relation against its canonical view.

        The specialized projector returns one effect document per source row.
        This method flattens those documents into the quarantine-level effect
        document used by diff creation.
        """

        class_mapping = relation_context.class_mapping

        projection = class_mapping.projection

        if projection is None:
            raise RuntimeError(
                "Projection-backed class mapping does not " "contain a projection definition."
            )

        source_class_id = relation_context.source_class_id

        source_rows = tuple(
            quarantine_session.query(
                relation_context.relation,
            )
        )

        if not source_rows:
            return ()

        documents = self.canonical_view_effect_projector.project_effects(
            source_model=source_model,
            source_class_id=source_class_id,
            source_rows=source_rows,
            quarantine_session=quarantine_session,
            live_session=live_session,
            projection=projection,
        )

        self._assert_complete_projection(
            source_class_id=source_class_id,
            source_rows=source_rows,
            documents=documents,
        )

        effects = tuple(effect for document in documents for effect in document.effects)

        self.logger.info(
            "Projected %s source rows from projection-backed "
            "relation %r into %s canonical effects.",
            len(
                source_rows,
            ),
            self._table_name(
                relation_context.relation,
            ),
            len(
                effects,
            ),
        )

        return effects

    def _assert_complete_projection(
        self,
        *,
        source_class_id: str,
        source_rows: tuple[
            Any,
            ...,
        ],
        documents: tuple[
            EffectDocument,
            ...,
        ],
    ) -> None:
        """
        Require one correctly aligned effect document per source row.
        """

        if len(
            documents,
        ) != len(
            source_rows,
        ):
            raise ValueError(
                "Canonical-view projection returned "
                f"{len(documents)} effect documents for "
                f"{len(source_rows)} source rows in class "
                f"{source_class_id!r}."
            )

        for (
            source_row,
            document,
        ) in zip(
            source_rows,
            documents,
            strict=True,
        ):
            expected_object_id = self._source_object_id(
                source_row,
            )

            if document.source.class_id != source_class_id:
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"class {document.source.class_id!r}; "
                    f"expected {source_class_id!r}."
                )

            if document.source.object_id != expected_object_id:
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"object {document.source.object_id!r}; "
                    f"expected {expected_object_id!r} for class "
                    f"{source_class_id!r}."
                )

    def _source_object_id(
        self,
        source_row: Any,
    ) -> str:
        """
        Return one source object's stable transfer identity.
        """

        object_id = getattr(
            source_row,
            "t_ili_tid",
            None,
        ) or getattr(
            source_row,
            "obj_id",
            None,
        )

        if (
            not isinstance(
                object_id,
                str,
            )
            or not object_id.strip()
        ):
            raise ValueError(
                "Projection-backed source row does not expose " "a non-empty t_ili_tid or obj_id."
            )

        return object_id

    def _rows(
        self,
        *,
        cursor,
        schema: str,
        relation,
    ):
        """
        Yield quarantine rows for one imported ORM relation.
        """

        query = self._relation_rows_query(
            schema=schema,
            relation=relation,
        )

        cursor.execute(
            query,
        )

        if cursor.description is None:
            return

        column_names = tuple(
            self._cursor_column_name(
                column_description,
            )
            for column_description in cursor.description
        )

        for row in cursor:
            yield dict(
                zip(
                    column_names,
                    row,
                    strict=True,
                )
            )

    def _table_name(
        self,
        relation,
    ) -> str:
        table = getattr(
            relation,
            "__table__",
            None,
        )

        if table is not None:
            return table.name

        return relation.__name__

    def _identity(
        self,
        *,
        row: dict[
            str,
            Any,
        ],
        class_mapping: ClassMapping,
        canonical_class_id: str | None = None,
    ) -> CanonicalObjectIdentity:
        """
        Build the identity for one canonical target class.
        """

        target_class_id = canonical_class_id or class_mapping.canonical_class_id

        if target_class_id is None:
            raise ValueError("Cannot build an identity without a canonical " "target class.")

        identity_mapping = class_mapping.identities.get(
            target_class_id,
        )

        if identity_mapping is None and target_class_id == class_mapping.canonical_class_id:
            identity_mapping = class_mapping.identity

        if identity_mapping is None:
            raise ValueError(
                "No resolved identity mapping exists for "
                "canonical target class "
                f"{target_class_id!r}."
            )

        try:
            source_value = row[identity_mapping.source_attribute]

        except KeyError as exception:
            raise ValueError(
                "Source identity attribute "
                f"{identity_mapping.source_attribute!r} is missing "
                f"for canonical target class "
                f"{target_class_id!r}. Available source attributes: "
                f"{tuple(sorted(row))!r}."
            ) from exception

        if source_value is None:
            raise ValueError(
                "Source identity attribute "
                f"{identity_mapping.source_attribute!r} is null "
                f"for canonical target class "
                f"{target_class_id!r}."
            )

        return CanonicalObjectIdentity(
            class_id=target_class_id,
            attributes={
                identity_mapping.canonical_attribute: (source_value),
            },
        )

    def _attribute_effects(
        self,
        *,
        relation,
        row: dict[
            str,
            Any,
        ],
        source_class_id: str,
        class_mapping: ClassMapping,
        canonical_metadata: CanonicalModelMetadata,
        cursor,
        schema: str,
    ) -> tuple[
        UpdateAttributeEffect,
        ...,
    ]:
        effects: list[UpdateAttributeEffect,] = []

        identities_by_target_class: dict[
            str,
            CanonicalObjectIdentity,
        ] = {}

        for (
            source_attribute,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            canonical_attribute_id = attribute_mapping.canonical_attr_id

            if canonical_attribute_id is None:
                continue

            target_class_id = (
                attribute_mapping.canonical_class_id or class_mapping.canonical_class_id
            )

            if target_class_id is None:
                raise ValueError(
                    "No canonical target class is defined for "
                    f"{source_class_id}.{source_attribute}."
                )

            identity = identities_by_target_class.get(
                target_class_id,
            )

            if identity is None:
                identity = self._identity(
                    row=row,
                    class_mapping=class_mapping,
                    canonical_class_id=target_class_id,
                )

                identities_by_target_class[target_class_id] = identity

            self._assert_known_attribute(
                canonical_metadata=canonical_metadata,
                class_id=target_class_id,
                attribute_id=canonical_attribute_id,
            )

            try:
                value = row[source_attribute]

            except KeyError as exception:
                raise ValueError(
                    "Mapped source attribute "
                    f"{source_class_id!r}.{source_attribute!r} is "
                    "missing from the projected quarantine row. "
                    "Available source attributes: "
                    f"{tuple(sorted(row))!r}."
                ) from exception

            if attribute_mapping.foreign_key is None:
                value = self._mapped_value(
                    source_class_id=source_class_id,
                    source_attribute=source_attribute,
                    attribute_mapping=attribute_mapping,
                    value=value,
                )

            else:
                value = self._canonical_foreign_key_value(
                    cursor=cursor,
                    schema=schema,
                    relation=relation,
                    source_class_id=source_class_id,
                    source_attribute=source_attribute,
                    source_value=value,
                    foreign_key_mapping=(attribute_mapping.foreign_key),
                )

            effects.append(
                UpdateAttributeEffect(
                    identity=identity,
                    attribute_id=canonical_attribute_id,
                    value=value,
                )
            )

        return tuple(
            effects,
        )

    def _mapped_value(
        self,
        *,
        source_class_id: str,
        source_attribute: str,
        attribute_mapping: AttributeMapping,
        value: Any,
    ) -> Any:
        if value is None:
            return None

        value_mapping = self.model_mapping.try_value_mapping(
            source_class_id,
            source_attribute,
            str(
                value,
            ),
        )

        if value_mapping is None:
            value_mapping = attribute_mapping.values.get(
                str(
                    value,
                )
            )

        if value_mapping is None:
            return value

        return value_mapping.canonical_value_id

    def _assert_known_class(
        self,
        *,
        canonical_metadata: CanonicalModelMetadata,
        class_id: str,
    ) -> None:
        if class_id not in canonical_metadata.classes:
            raise KeyError(f"Unknown canonical class: {class_id!r}")

    def _assert_known_attribute(
        self,
        *,
        canonical_metadata: CanonicalModelMetadata,
        class_id: str,
        attribute_id: str,
    ) -> None:
        if (
            class_id,
            attribute_id,
        ) not in canonical_metadata.attributes:
            raise KeyError("Unknown canonical attribute: " f"{class_id!r}.{attribute_id!r}")

    def _relation_rows_query(
        self,
        *,
        schema: str,
        relation,
    ):
        """
        Build a query for one complete joined-inheritance relation.

        Tables are ordered from the most-derived relation to the root parent.
        Child tables are joined to their immediate parent through the inheritance
        condition represented by the SQLAlchemy mapper.

        Selected columns use mapper attribute names so the result is compatible
        with ``ClassMapping`` and ``CanonicalIdentityMapping``.
        """

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable as exception:
            raise TypeError(
                "Cannot build a quarantine query for an unmapped " f"relation: {relation!r}."
            ) from exception

        hierarchy = self._mapper_hierarchy(
            mapper,
        )

        aliases = {
            hierarchy_mapper: (f"t{index}")
            for (
                index,
                hierarchy_mapper,
            ) in enumerate(
                hierarchy,
            )
        }

        selected_columns = self._selected_inheritance_columns(
            mapper=mapper,
            aliases=aliases,
        )

        if not selected_columns:
            raise RuntimeError(
                "The quarantine relation "
                f"{self._table_name(relation)!r} exposes no "
                "selectable mapped columns."
            )

        leaf_mapper = hierarchy[0]

        leaf_alias = aliases[leaf_mapper]

        query = sql.SQL("SELECT {columns} " "FROM {schema}.{table} AS {alias}").format(
            columns=sql.SQL(", ").join(
                sql.SQL("{alias}.{column} AS {attribute}").format(
                    alias=sql.Identifier(
                        table_alias,
                    ),
                    column=sql.Identifier(
                        column_name,
                    ),
                    attribute=sql.Identifier(
                        attribute_name,
                    ),
                )
                for (
                    table_alias,
                    column_name,
                    attribute_name,
                ) in selected_columns
            ),
            schema=sql.Identifier(
                schema,
            ),
            table=sql.Identifier(
                leaf_mapper.local_table.name,
            ),
            alias=sql.Identifier(
                leaf_alias,
            ),
        )

        for child_mapper in hierarchy:
            parent_mapper = child_mapper.inherits

            if parent_mapper is None:
                continue

            query += self._inheritance_join_sql(
                schema=schema,
                child_mapper=child_mapper,
                parent_mapper=parent_mapper,
                child_alias=aliases[child_mapper],
                parent_alias=aliases[parent_mapper],
            )

        return query

    def _source_foreign_key_target(
        self,
        *,
        relation,
        source_attribute: str,
    ) -> SourceForeignKeyTarget | None:
        """
        Return the cached referenced ORM relation and target column.
        """

        cache_key = (
            relation,
            source_attribute,
        )

        if cache_key in self._source_foreign_key_target_cache:
            return self._source_foreign_key_target_cache[cache_key]

        try:
            mapper = inspect(
                relation,
            )

        except NoInspectionAvailable:
            self._source_foreign_key_target_cache[cache_key] = None

            return None

        target: SourceForeignKeyTarget | None = None

        for relationship in mapper.relationships:
            for local_column in relationship.local_columns:
                local_attribute = str(
                    getattr(
                        local_column,
                        "key",
                        None,
                    )
                    or local_column.name
                )

                if local_attribute != source_attribute:
                    continue

                for foreign_key in local_column.foreign_keys:
                    referenced_column = foreign_key.column

                    if referenced_column.table is relationship.mapper.local_table:
                        target = SourceForeignKeyTarget(
                            relation=(relationship.mapper.class_),
                            referenced_column=(referenced_column),
                        )

                        break

                if target is not None:
                    break

            if target is not None:
                break

        self._source_foreign_key_target_cache[cache_key] = target

        return target

    def _source_identity_owner(
        self,
        relation,
    ) -> (
        tuple[
            Any,
            str,
        ]
        | None
    ):
        """
        Return the cached mapper and attribute owning source identity.

        ``t_ili_tid`` is preferred. ``obj_id`` is the fallback.
        """

        if relation in self._source_identity_owner_cache:
            return self._source_identity_owner_cache[relation]

        try:
            mapper = inspect(
                relation,
            )

        except NoInspectionAvailable:
            self._source_identity_owner_cache[relation] = None

            return None

        current_mapper = mapper

        while current_mapper is not None:
            local_table = current_mapper.local_table

            if "t_ili_tid" in local_table.c:
                result = (
                    current_mapper,
                    "t_ili_tid",
                )

                self._source_identity_owner_cache[relation] = result

                return result

            current_mapper = current_mapper.inherits

        current_mapper = mapper

        while current_mapper is not None:
            local_table = current_mapper.local_table

            if "obj_id" in local_table.c:
                result = (
                    current_mapper,
                    "obj_id",
                )

                self._source_identity_owner_cache[relation] = result

                return result

            current_mapper = current_mapper.inherits

        self._source_identity_owner_cache[relation] = None

        return None

    def _canonical_foreign_key_value(
        self,
        *,
        cursor,
        schema: str,
        relation,
        source_class_id: str,
        source_attribute: str,
        source_value: Any,
        foreign_key_mapping: ForeignKeyMapping,
    ) -> Any:
        """
        Convert one quarantine FK value to its canonical identity.

        Non-integer values are already external or canonical identifiers and pass
        through unchanged.

        Integer values are ili2pg ``t_id`` references. Their referenced ORM
        relation determines which inheritance root owns ``t_ili_tid`` or the
        fallback ``obj_id``.
        """

        if source_value is None:
            return None

        if not isinstance(
            source_value,
            int,
        ):
            return source_value

        foreign_key_target = self._source_foreign_key_target(
            relation=relation,
            source_attribute=source_attribute,
        )

        if foreign_key_target is None:
            raise ValueError(
                "Could not resolve the source ORM foreign-key target "
                f"for {source_class_id!r}.{source_attribute!r}."
            )

        identity_owner = self._source_identity_owner(
            foreign_key_target.relation,
        )

        if identity_owner is None:
            raise ValueError(
                "Could not find a source identity attribute "
                "('t_ili_tid' or 'obj_id') in the ORM inheritance "
                "hierarchy referenced by "
                f"{source_class_id!r}.{source_attribute!r}."
            )

        (
            identity_mapper,
            identity_attribute,
        ) = identity_owner

        identity_table = str(
            identity_mapper.local_table.name,
        )

        identity_by_t_id = self._source_identity_by_t_id(
            cursor=cursor,
            schema=schema,
            identity_table=identity_table,
            identity_attribute=identity_attribute,
        )

        try:
            canonical_value = identity_by_t_id[source_value]

        except KeyError as exception:
            raise ValueError(
                "Could not resolve internal quarantine foreign key "
                f"{source_class_id!r}.{source_attribute!r} with "
                f"t_id {source_value!r} through "
                f"{schema!r}.{identity_table!r}."
                f"{identity_attribute!r}. Expected canonical target "
                f"{foreign_key_mapping.referenced_class_id!r}."
                f"{foreign_key_mapping.referenced_attribute_id!r}."
            ) from exception

        self.logger.debug(
            "Resolved internal quarantine foreign key "
            "%r.%r=%r through %r.%r to canonical %r.%r=%r.",
            source_class_id,
            source_attribute,
            source_value,
            identity_table,
            identity_attribute,
            foreign_key_mapping.referenced_class_id,
            foreign_key_mapping.referenced_attribute_id,
            canonical_value,
        )

        return canonical_value

    def _source_identity_by_t_id(
        self,
        *,
        cursor,
        schema: str,
        identity_table: str = "baseclass",
        identity_attribute: str = "t_ili_tid",
    ) -> dict[
        int,
        str,
    ]:
        """
        Return a cached identity index for one source inheritance root.
        """

        cache_key = (
            schema,
            identity_table,
            identity_attribute,
        )

        cached = self._source_identity_cache.get(
            cache_key,
        )

        if cached is not None:
            return cached

        cursor.execute(
            sql.SQL("""
                SELECT
                    t_id,
                    {identity_attribute}
                FROM {schema}.{identity_table}
                WHERE {identity_attribute} IS NOT NULL
                """).format(
                identity_attribute=sql.Identifier(
                    identity_attribute,
                ),
                schema=sql.Identifier(
                    schema,
                ),
                identity_table=sql.Identifier(
                    identity_table,
                ),
            )
        )

        identity_by_t_id = {
            int(
                t_id,
            ): str(
                identity,
            )
            for (
                t_id,
                identity,
            ) in cursor.fetchall()
        }

        self._source_identity_cache[cache_key] = identity_by_t_id

        self.logger.debug(
            "Cached %s source identities from %r.%r using %r.",
            len(
                identity_by_t_id,
            ),
            schema,
            identity_table,
            identity_attribute,
        )

        return identity_by_t_id

    def _mapper_hierarchy(
        self,
        mapper,
    ) -> tuple:
        """
        Return one mapper hierarchy from leaf class to root class.
        """

        hierarchy = []
        current_mapper = mapper

        while current_mapper is not None:
            hierarchy.append(
                current_mapper,
            )

            current_mapper = current_mapper.inherits

        return tuple(
            hierarchy,
        )

    def _selected_inheritance_columns(
        self,
        *,
        mapper,
        aliases: Mapping[
            Any,
            str,
        ],
    ) -> tuple[
        tuple[
            str,
            str,
            str,
        ],
        ...,
    ]:
        """
        Return selected source columns for an inherited ORM relation.

        Each result contains:

        - table alias;
        - physical column name;
        - output source-attribute name.

        Mapper column properties are authoritative because their keys correspond
        to the source attributes used by mappings. The first usable occurrence
        of an attribute is retained.
        """

        selected_columns: list[
            tuple[
                str,
                str,
                str,
            ],
        ] = []

        selected_attributes: set[str,] = set()

        for column_property in mapper.column_attrs:
            attribute_name = getattr(
                column_property,
                "key",
                None,
            )

            if (
                not isinstance(
                    attribute_name,
                    str,
                )
                or not attribute_name
            ):
                continue

            if attribute_name in selected_attributes:
                continue

            selected_column = None
            selected_mapper = None

            for column in getattr(
                column_property,
                "columns",
                (),
            ):
                column_table = getattr(
                    column,
                    "table",
                    None,
                )

                if column_table is None:
                    continue

                for hierarchy_mapper in aliases:
                    if hierarchy_mapper.local_table is column_table:
                        selected_column = column
                        selected_mapper = hierarchy_mapper

                        break

                if selected_column is not None:
                    break

            if selected_column is None or selected_mapper is None:
                continue

            selected_columns.append(
                (
                    aliases[selected_mapper],
                    selected_column.name,
                    attribute_name,
                )
            )

            selected_attributes.add(
                attribute_name,
            )

        return tuple(
            selected_columns,
        )

    def _inheritance_join_sql(
        self,
        *,
        schema: str,
        child_mapper,
        parent_mapper,
        child_alias: str,
        parent_alias: str,
    ):
        """
        Return the SQL join from one child table to its direct ORM parent.

        The normal ili2pg inheritance key is ``t_id``. The implementation first
        derives the join columns from the mapper inheritance condition and falls
        back to ``t_id`` only when both tables expose that column.
        """

        join_columns = self._inheritance_join_columns(
            child_mapper=child_mapper,
            parent_mapper=parent_mapper,
        )

        if join_columns is None:
            raise RuntimeError(
                "Could not determine the joined-inheritance "
                f"condition from {child_mapper.local_table.fullname!r} "
                f"to {parent_mapper.local_table.fullname!r}."
            )

        (
            child_column_name,
            parent_column_name,
        ) = join_columns

        return sql.SQL(
            " JOIN {schema}.{parent_table} AS {parent_alias}"
            " ON {child_alias}.{child_column}"
            " = {parent_alias}.{parent_column}"
        ).format(
            schema=sql.Identifier(
                schema,
            ),
            parent_table=sql.Identifier(
                parent_mapper.local_table.name,
            ),
            parent_alias=sql.Identifier(
                parent_alias,
            ),
            child_alias=sql.Identifier(
                child_alias,
            ),
            child_column=sql.Identifier(
                child_column_name,
            ),
            parent_column=sql.Identifier(
                parent_column_name,
            ),
        )

    def _inheritance_join_columns(
        self,
        *,
        child_mapper,
        parent_mapper,
    ) -> (
        tuple[
            str,
            str,
        ]
        | None
    ):
        """
        Return child and parent columns used for joined inheritance.
        """

        child_table = child_mapper.local_table
        parent_table = parent_mapper.local_table

        inherit_condition = child_mapper.inherit_condition

        left = getattr(
            inherit_condition,
            "left",
            None,
        )

        right = getattr(
            inherit_condition,
            "right",
            None,
        )

        if (
            getattr(
                left,
                "table",
                None,
            )
            is child_table
            and getattr(
                right,
                "table",
                None,
            )
            is parent_table
        ):
            return (
                left.name,
                right.name,
            )

        if (
            getattr(
                right,
                "table",
                None,
            )
            is child_table
            and getattr(
                left,
                "table",
                None,
            )
            is parent_table
        ):
            return (
                right.name,
                left.name,
            )

        if "t_id" in child_table.c and "t_id" in parent_table.c:
            return (
                "t_id",
                "t_id",
            )

        return None

    def _cursor_column_name(
        self,
        column_description,
    ) -> str:
        """
        Return one result-column name for psycopg 2 or psycopg 3.
        """

        name = getattr(
            column_description,
            "name",
            None,
        )

        if name is not None:
            return str(
                name,
            )

        return str(column_description[0])
