# teksi_wastewater/hooks/adapters/tww_database_connection_factory.py

from __future__ import annotations

from contextlib import AbstractContextManager
from dataclasses import dataclass, field

import psycopg
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)

from ...utils.database_utils import DatabaseUtils


@dataclass(
    frozen=True,
    slots=True,
)
class TwwDatabaseConnectionFactory(
    DatabaseConnectionFactory,
):
    """
    Create managed psycopg connections for TEKSI Wastewater.
    """

    parameters: dict[
        str,
        object,
    ] = field(
        default_factory=dict,
    )

    def connection(
        self,
        *,
        autocommit: bool = False,
    ) -> AbstractContextManager:
        return psycopg.connect(
            **self.parameters,
            autocommit=autocommit,
        )

    def apply_to_database_config(
        self,
    ) -> None:
        """
        Apply this factory's parameters to the legacy database configuration.
        """

        database_config = DatabaseUtils.databaseConfig

        database_config.PGSERVICE = self.parameters.get(
            "service",
        )

        database_config.PGHOST = self.parameters.get(
            "host",
        )

        database_config.PGPORT = self.parameters.get(
            "port",
        )

        database_config.PGDATABASE = self.parameters.get(
            "dbname",
        )

        database_config.PGUSER = self.parameters.get(
            "user",
        )

        database_config.PGPASS = self.parameters.get(
            "password",
        )

    @classmethod
    def from_database_config(
        cls,
    ) -> TwwDatabaseConnectionFactory:
        database_config = DatabaseUtils.databaseConfig

        parameters = {
            key: value
            for key, value in {
                "service": database_config.PGSERVICE,
                "host": database_config.PGHOST,
                "port": database_config.PGPORT,
                "dbname": database_config.PGDATABASE,
                "user": database_config.PGUSER,
                "password": database_config.PGPASS,
            }.items()
            if value
            not in (
                None,
                "",
            )
        }

        if not parameters:
            raise RuntimeError("No PostgreSQL connection configuration is available.")

        return cls(
            parameters=parameters,
        )
