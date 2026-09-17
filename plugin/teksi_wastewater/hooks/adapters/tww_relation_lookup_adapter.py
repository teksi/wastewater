from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from typing import Any

from psycopg import sql
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObject,
    CanonicalObjectIdentity,
)


@dataclass(slots=True)
class TwwRelationLookupAdapter(
    RelationLookupCapability,
):
    """
    Database-backed TEKSI Wastewater relation lookup implementation.

    The adapter resolves canonical relationships and current canonical objects
    from a configured PostgreSQL schema.

    Dynamic schema, table and attribute names are represented as SQL
    identifiers. Runtime values are passed separately as query parameters.
    """

    connection_factory: DatabaseConnectionFactory

    schema: str

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

        The relation is resolved by comparing the supplied value with the
        related attribute on the related canonical class.

        ``local_class_id`` and ``local_attribute`` describe the originating
        side of the relation. They are part of the generic capability contract
        but are not needed by this direct database lookup.
        """

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

        return tuple(
            CanonicalObjectIdentity(
                class_id=related_class_id,
                attributes={
                    "obj_id": row[0],
                },
            )
            for row in rows
        )

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

        row = self._fetch_current_row(
            identity,
        )

        if row is None:
            return None

        values = {
            key: value
            for key, value in row.items()
            if key not in identity.attributes and key != "last_modification"
        }

        return CanonicalObject(
            identity=identity,
            values=values,
            last_modification=row.get(
                "last_modification",
            ),
        )

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
            raise ValueError("Canonical object identity must contain at least " "one attribute.")

        where_parts = [
            sql.SQL("{} = %s").format(
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
            LIMIT 1
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

        return self._fetchone_dict(
            query=query,
            parameters=parameters,
        )

    def _fetchall(
        self,
        *,
        query,
        parameters: Sequence[Any,] = (),
    ) -> list[tuple,]:
        """
        Execute a read-only query and return all result rows.
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

                return cursor.fetchall()

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

                row = cursor.fetchone()

                if row is None:
                    return None

                if cursor.description is None:
                    raise RuntimeError(
                        "Canonical object query returned a row " "without column metadata."
                    )

                column_names = tuple(column.name for column in cursor.description)

        return dict(
            zip(
                column_names,
                row,
                strict=True,
            )
        )
