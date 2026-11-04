from __future__ import annotations

import logging
from collections.abc import Sequence
from dataclasses import dataclass, field
from typing import Any

from psycopg import sql
from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObject,
    CanonicalObjectIdentity,
)
from teksi_wastewater.hooks.adapters.tww_session_manager import (
    TwwSessionManager,
)


@dataclass(
    slots=True,
)
class TwwRelationLookupAdapter(
    RelationLookupCapability,
):
    """
    Database-backed TEKSI Wastewater relation lookup implementation.

    The adapter resolves canonical relationships and current canonical objects
    from a configured PostgreSQL schema.

    Each public lookup operation opens a managed projection scope and borrows
    the scope's live SQLAlchemy session. Existing psycopg query construction
    is retained by borrowing a DBAPI cursor from that session.

    The adapter does not commit, roll back, or close sessions or underlying
    connections. Session lifecycle is owned by ``TwwSessionManager``.

    Dynamic schema, table, and attribute names are represented as SQL
    identifiers. Runtime values are passed separately as query parameters.
    """

    schema: str

    session_manager: TwwSessionManager = field(
        repr=False,
    )

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    _canonical_objects_cache: dict[
        tuple[
            str,
            str,
            str,
            str,
            Any,
        ],
        tuple[
            CanonicalObjectIdentity,
            ...,
        ],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    def clear_cache(
        self,
    ) -> None:
        """
        Clear lookup results derived from the current live schema.
        """

        self._canonical_objects_cache.clear()

    def canonical_objects(
        self,
        local_class_id: str,
        related_class_id: str,
        local_attribute: str,
        related_attribute: str,
        value: Any,
    ) -> Sequence[CanonicalObjectIdentity,]:
        """
        Return related canonical object identities.

        Results are cached for the lifetime of this relation-lookup adapter.
        Missing results are cached as empty tuples.

        ``local_class_id`` and ``local_attribute`` remain part of the cache key
        because they describe the semantic relation being evaluated, even
        though the direct SQL lookup only uses the related side.
        """

        cache_key = (
            local_class_id,
            related_class_id,
            local_attribute,
            related_attribute,
            value,
        )

        cached = self._canonical_objects_cache.get(
            cache_key,
        )

        if cached is not None:
            return cached

        query = sql.SQL("""
            SELECT {identity_attribute}
            FROM {schema}.{table_name}
            WHERE {related_attribute} = %s
            """).format(
            identity_attribute=sql.Identifier(
                "obj_id",
            ),
            schema=sql.Identifier(
                self.schema,
            ),
            table_name=sql.Identifier(
                related_class_id,
            ),
            related_attribute=sql.Identifier(
                related_attribute,
            ),
        )

        rows = self._fetchall(
            query=query,
            parameters=(value,),
        )

        result = tuple(
            CanonicalObjectIdentity(
                class_id=related_class_id,
                attributes={
                    "obj_id": row[0],
                },
            )
            for row in rows
        )

        self._canonical_objects_cache[cache_key] = result

        return result

    def current_object(
        self,
        identity: CanonicalObjectIdentity,
    ) -> CanonicalObject | None:
        """
        Return the current canonical object matching an identity.

        Identity attributes are excluded from the returned object values
        because they are already represented by
        ``CanonicalObject.identity``.
        """

        self.logger.debug(
            "Fetching current canonical object: " "class_id=%r, identity_attributes=%r.",
            identity.class_id,
            dict(
                identity.attributes,
            ),
        )

        row = self._fetch_current_row(
            identity,
        )

        if row is None:
            return None

        values = {
            key: value
            for (
                key,
                value,
            ) in row.items()
            if (key not in identity.attributes and key != "last_modification")
        }

        return CanonicalObject(
            identity=identity,
            values=values,
            last_modification=row.get(
                "last_modification",
            ),
        )

    def current_objects(
        self,
        identities: Sequence[CanonicalObjectIdentity,],
        *,
        batch_size: int = 2000,
    ) -> dict[
        tuple,
        CanonicalObject | None,
    ]:
        """
        Return current canonical objects for several identities.

        Results are keyed by ``CanonicalObjectIdentity.key()`` because an
        identity may contain a mutable and unhashable attribute mapping.

        Identities are grouped by canonical class and identity-attribute shape.
        Each group is loaded in batches through one ``VALUES`` join rather than
        one query per canonical object.

        Missing canonical objects are represented by ``None``.
        """

        if batch_size <= 0:
            raise ValueError("batch_size must be greater than zero.")

        identities_by_key: dict[
            tuple,
            CanonicalObjectIdentity,
        ] = {}

        for identity in identities:
            if not identity.attributes:
                raise ValueError(
                    "Canonical object identity must contain at "
                    "least one attribute for class "
                    f"{identity.class_id!r}."
                )

            identity_key = identity.key()

            existing_identity = identities_by_key.get(
                identity_key,
            )

            if existing_identity is not None and existing_identity != identity:
                raise ValueError(
                    "Several canonical identities produced the "
                    f"same identity key {identity_key!r}."
                )

            identities_by_key[identity_key] = identity

        results: dict[
            tuple,
            CanonicalObject | None,
        ] = {identity_key: None for identity_key in identities_by_key}

        if not identities_by_key:
            return results

        identities_by_lookup_shape: dict[
            tuple[
                str,
                tuple[
                    str,
                    ...,
                ],
            ],
            list[CanonicalObjectIdentity,],
        ] = {}

        for identity in identities_by_key.values():
            identity_attribute_names = tuple(
                sorted(
                    identity.attributes,
                )
            )

            lookup_shape = (
                identity.class_id,
                identity_attribute_names,
            )

            identities_by_lookup_shape.setdefault(
                lookup_shape,
                [],
            ).append(
                identity,
            )

        with self.session_manager.projection_scope() as session_context:
            cursor = self._borrowed_cursor(
                session_context.live,
            )

            try:
                for (
                    class_id,
                    identity_attribute_names,
                ), grouped_identities in identities_by_lookup_shape.items():
                    for batch_start in range(
                        0,
                        len(
                            grouped_identities,
                        ),
                        batch_size,
                    ):
                        identity_batch = grouped_identities[batch_start : batch_start + batch_size]

                        batch_results = self._current_objects_batch(
                            cursor=cursor,
                            class_id=class_id,
                            identity_attribute_names=(identity_attribute_names),
                            identities=identity_batch,
                        )

                        results.update(
                            batch_results,
                        )

            finally:
                cursor.close()

        self.logger.debug(
            "Loaded %s canonical objects for %s requested " "identities using %s lookup groups.",
            sum(result is not None for result in results.values()),
            len(
                results,
            ),
            len(
                identities_by_lookup_shape,
            ),
        )

        return results

    def _current_objects_batch(
        self,
        *,
        cursor,
        class_id: str,
        identity_attribute_names: tuple[
            str,
            ...,
        ],
        identities: Sequence[CanonicalObjectIdentity,],
    ) -> dict[
        tuple,
        CanonicalObject | None,
    ]:
        """
        Load one batch sharing a canonical class and identity shape.
        """

        if not identities:
            return {}

        if not identity_attribute_names:
            raise ValueError(
                "Bulk canonical lookup requires at least one "
                f"identity attribute for class {class_id!r}."
            )

        requested_index_column = "__teksi_request_index"

        requested_column_names = (
            requested_index_column,
            *identity_attribute_names,
        )

        values_rows = sql.SQL(", ").join(
            sql.SQL("({})").format(
                sql.SQL(", ").join(sql.Placeholder() for _ in requested_column_names)
            )
            for _ in identities
        )

        join_conditions = sql.SQL(" AND ").join(
            sql.SQL("target.{attribute} " "IS NOT DISTINCT FROM " "requested.{attribute}").format(
                attribute=sql.Identifier(
                    attribute_name,
                )
            )
            for attribute_name in identity_attribute_names
        )

        query = sql.SQL("""
            WITH requested ({requested_columns}) AS (
                VALUES {values_rows}
            )
            SELECT
                requested.{requested_index},
                target.*
            FROM requested
            JOIN {schema}.{table_name} AS target
              ON {join_conditions}
            ORDER BY
                requested.{requested_index}
            """).format(
            requested_columns=sql.SQL(", ").join(
                sql.Identifier(
                    column_name,
                )
                for column_name in requested_column_names
            ),
            values_rows=values_rows,
            requested_index=sql.Identifier(
                requested_index_column,
            ),
            schema=sql.Identifier(
                self.schema,
            ),
            table_name=sql.Identifier(
                class_id,
            ),
            join_conditions=join_conditions,
        )

        parameters: list[Any,] = []

        identities_by_request_index: dict[
            int,
            CanonicalObjectIdentity,
        ] = {}

        for (
            request_index,
            identity,
        ) in enumerate(
            identities,
        ):
            if identity.class_id != class_id:
                raise ValueError(
                    "Bulk canonical lookup received an identity "
                    f"for class {identity.class_id!r} in a "
                    f"{class_id!r} batch."
                )

            actual_attribute_names = tuple(
                sorted(
                    identity.attributes,
                )
            )

            if actual_attribute_names != identity_attribute_names:
                raise ValueError(
                    "Bulk canonical lookup received incompatible "
                    "identity attributes for class "
                    f"{class_id!r}. Expected "
                    f"{identity_attribute_names!r}, got "
                    f"{actual_attribute_names!r}."
                )

            identities_by_request_index[request_index] = identity

            parameters.append(
                request_index,
            )

            parameters.extend(
                identity.attributes[attribute_name] for attribute_name in identity_attribute_names
            )

        self.logger.debug(
            "Bulk-loading %s canonical objects from %r.%r " "using identity attributes %r.",
            len(
                identities,
            ),
            self.schema,
            class_id,
            identity_attribute_names,
        )

        cursor.execute(
            query,
            tuple(
                parameters,
            ),
        )

        if cursor.description is None:
            raise RuntimeError("Bulk canonical object query returned no column " "metadata.")

        column_names = tuple(
            self._cursor_column_name(
                column_description,
            )
            for column_description in cursor.description
        )

        if not column_names or column_names[0] != requested_index_column:
            raise RuntimeError(
                "Bulk canonical object query did not return the " "expected request-index column."
            )

        table_column_names = column_names[1:]

        results: dict[
            tuple,
            CanonicalObject | None,
        ] = {identity.key(): None for identity in identities}

        matched_request_indexes: set[int,] = set()

        for result_row in cursor:
            request_index = int(result_row[0])

            try:
                identity = identities_by_request_index[request_index]

            except KeyError as exception:
                raise RuntimeError(
                    "Bulk canonical object query returned an "
                    f"unknown request index {request_index!r}."
                ) from exception

            if request_index in matched_request_indexes:
                raise ValueError(
                    "Canonical identity matched several live "
                    f"rows for class {class_id!r}: "
                    f"{dict(identity.attributes)!r}."
                )

            matched_request_indexes.add(
                request_index,
            )

            row = dict(
                zip(
                    table_column_names,
                    result_row[1:],
                    strict=True,
                )
            )

            values = {
                key: value
                for (
                    key,
                    value,
                ) in row.items()
                if (key not in identity.attributes and key != "last_modification")
            }

            results[identity.key()] = CanonicalObject(
                identity=identity,
                values=values,
                last_modification=row.get(
                    "last_modification",
                ),
            )

        return results

    def _fetch_current_row(
        self,
        identity: CanonicalObjectIdentity,
    ) -> (
        dict[
            str,
            Any,
        ]
        | None
    ):
        """
        Return the current database row matching a canonical identity.
        """

        if not identity.attributes:
            raise ValueError("Canonical object identity must contain at " "least one attribute.")

        where_parts = [
            sql.SQL("{} IS NOT DISTINCT FROM %s").format(
                sql.Identifier(
                    attribute_name,
                )
            )
            for attribute_name in identity.attributes
        ]

        query = sql.SQL("""
            SELECT *
            FROM {schema}.{table_name}
            WHERE {where_clause}
            LIMIT 2
            """).format(
            schema=sql.Identifier(
                self.schema,
            ),
            table_name=sql.Identifier(
                identity.class_id,
            ),
            where_clause=sql.SQL(" AND ").join(
                where_parts,
            ),
        )

        parameters = tuple(
            identity.attributes.values(),
        )

        rows = self._fetchall_dicts(
            query=query,
            parameters=parameters,
        )

        if not rows:
            return None

        if (
            len(
                rows,
            )
            > 1
        ):
            raise ValueError(
                "Canonical identity matched several live rows "
                f"for class {identity.class_id!r}: "
                f"{dict(identity.attributes)!r}."
            )

        return rows[0]

    def _fetchall(
        self,
        *,
        query,
        parameters: Sequence[Any,] = (),
    ) -> list[tuple,]:
        """
        Execute a read-only query and return all result rows.
        """

        with self.session_manager.projection_scope() as session_context:
            cursor = self._borrowed_cursor(
                session_context.live,
            )

            try:
                cursor.execute(
                    query,
                    tuple(
                        parameters,
                    ),
                )

                return list(
                    cursor.fetchall(),
                )

            except Exception:
                self.logger.info(
                    "Relation lookup query failed: %r; " "parameters=%r.",
                    str(
                        query,
                    ),
                    tuple(
                        parameters,
                    ),
                )

                raise

            finally:
                cursor.close()

    def _fetchall_dicts(
        self,
        *,
        query,
        parameters: Sequence[Any,] = (),
    ) -> list[
        dict[
            str,
            Any,
        ],
    ]:
        """
        Execute a read-only query and return all rows as dictionaries.
        """

        with self.session_manager.projection_scope() as session_context:
            cursor = self._borrowed_cursor(
                session_context.live,
            )

            try:
                cursor.execute(
                    query,
                    tuple(
                        parameters,
                    ),
                )

                rows = cursor.fetchall()

                if cursor.description is None:
                    if rows:
                        raise RuntimeError(
                            "Canonical object query returned rows " "without column metadata."
                        )

                    return []

                column_names = tuple(
                    self._cursor_column_name(
                        column_description,
                    )
                    for column_description in cursor.description
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

            except Exception:
                self.logger.info(
                    "Relation lookup query failed: %r; " "parameters=%r.",
                    str(
                        query,
                    ),
                    tuple(
                        parameters,
                    ),
                )

                raise

            finally:
                cursor.close()

    def _fetchone_dict(
        self,
        *,
        query,
        parameters: Sequence[Any,] = (),
    ) -> (
        dict[
            str,
            Any,
        ]
        | None
    ):
        """
        Execute a read-only query and return its first row as a dictionary.
        """

        rows = self._fetchall_dicts(
            query=query,
            parameters=parameters,
        )

        if not rows:
            return None

        return rows[0]

    def _borrowed_cursor(
        self,
        session,
    ):
        """
        Create a DBAPI cursor from a session owned by the active scope.

        The caller owns closing the cursor. The adapter must not close the
        SQLAlchemy connection, DBAPI connection, or session.
        """

        sqlalchemy_connection = session.connection()

        connection_fairy = sqlalchemy_connection.connection

        driver_connection = getattr(
            connection_fairy,
            "driver_connection",
            None,
        )

        if driver_connection is None:
            driver_connection = getattr(
                connection_fairy,
                "connection",
                None,
            )

        if driver_connection is None:
            raise RuntimeError(
                "Could not access the DBAPI connection owned by " "the live SQLAlchemy session."
            )

        return driver_connection.cursor()

    def _cursor_column_name(
        self,
        column_description,
    ) -> str:
        """
        Return one result-column name for psycopg cursor metadata.
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
