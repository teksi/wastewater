from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass, field
from typing import Any
from uuid import UUID

from psycopg import sql
from teksi_hooks.capabilities.cleanup import (
    IntermediateDataCleanupCapability,
)

from ...interlis import config
from .tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)


@dataclass(slots=True)
class TwwIntermediateDataCleanupAdapter(
    IntermediateDataCleanupCapability,
):
    """
    Delete TEKSI Wastewater intermediate import data.

    Intermediate schemas are obtained from review-job metadata. Live,
    application and dictionary schemas are explicitly protected from deletion.

    Cleanup is idempotent. Missing schemas do not cause an error.
    """

    connection_factory: TwwDatabaseConnectionFactory

    protected_schemas: frozenset[str] = field(
        default_factory=lambda: frozenset(
            {
                config.TWW_OD_SCHEMA,
                config.TWW_VL_SCHEMA,
                config.TWW_SYS_SCHEMA,
                config.TWW_APP_SCHEMA,
                config.EXPORT_SCHEMA,
            }
        ),
    )

    def cleanup(
        self,
        *,
        snapshot_id: UUID,
        metadata: Mapping[
            str,
            Any,
        ],
    ) -> None:
        """
        Delete the intermediate schemas recorded for a diff snapshot.
        """

        schemas = self._intermediate_schemas(
            metadata,
        )

        for schema in schemas:
            self._assert_cleanup_allowed(
                schema=schema,
                snapshot_id=snapshot_id,
            )

            self._drop_schema(
                schema,
            )

    def _intermediate_schemas(
        self,
        metadata: Mapping[
            str,
            Any,
        ],
    ) -> tuple[str, ...]:
        """
        Return unique intermediate schema names from workflow metadata.
        """

        schemas: list[str] = []

        for metadata_key in (
            "import_schema",
            "incremental_import_schema",
        ):
            schema = metadata.get(
                metadata_key,
            )

            if not schema:
                continue

            schema_name = str(
                schema,
            )

            if schema_name not in schemas:
                schemas.append(
                    schema_name,
                )

        return tuple(
            schemas,
        )

    def _assert_cleanup_allowed(
        self,
        *,
        schema: str,
        snapshot_id: UUID,
    ) -> None:
        """
        Prevent deletion of protected application schemas.
        """

        if schema in self.protected_schemas:
            raise ValueError(
                f"Snapshot {snapshot_id} references protected "
                f"schema {schema!r}; cleanup is not allowed."
            )

    def _drop_schema(
        self,
        schema: str,
    ) -> None:
        """
        Drop one intermediate schema if it exists.
        """

        query = sql.SQL("""
            DROP SCHEMA IF EXISTS {} CASCADE;
            """).format(
            sql.Identifier(
                schema,
            )
        )

        with self.connection_factory.connection(
            autocommit=True,
        ) as connection:
            connection.execute(
                query,
            )
