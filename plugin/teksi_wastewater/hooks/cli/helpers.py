from __future__ import annotations

import argparse

import pgserviceparser
from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)


def database_connection_factory(
    args: argparse.Namespace,
) -> TwwDatabaseConnectionFactory:
    """
    Create a TEKSI Wastewater connection factory from CLI arguments.
    """

    return TwwDatabaseConnectionFactory(
        parameters=_database_connection_config(
            args,
        ),
    )


def _database_connection_config(
    args: argparse.Namespace,
) -> dict[str, object]:
    """
    Build PostgreSQL connection parameters from CLI arguments.

    A configured PostgreSQL service supplies the base parameters. Explicit
    command-line arguments override corresponding service values.
    """

    parameters: dict[str, object] = {}

    if args.pgservice:
        parameters.update(
            pgserviceparser.service_config(
                args.pgservice,
            )
        )

    explicit_parameters = {
        "host": args.pghost,
        "port": args.pgport,
        "dbname": args.pgdatabase,
        "user": args.pguser,
        "password": args.pgpass,
    }

    parameters.update(
        {
            key: value
            for key, value in explicit_parameters.items()
            if value
            not in (
                None,
                "",
            )
        }
    )

    return parameters


def add_postgres_connection_args(
    parser: argparse.ArgumentParser,
) -> None:
    """
    Add shared PostgreSQL connection arguments to a CLI parser.
    """

    parser.add_argument(
        "--pgservice",
        help=(
            "PostgreSQL service name. Values from the service are "
            "overridden by explicitly supplied connection arguments."
        ),
    )

    parser.add_argument(
        "--pghost",
        help="PostgreSQL host",
    )

    parser.add_argument(
        "--pgport",
        type=int,
        help="PostgreSQL port",
    )

    parser.add_argument(
        "--pgdatabase",
        help="PostgreSQL database",
    )

    parser.add_argument(
        "--pguser",
        help="PostgreSQL user",
    )

    parser.add_argument(
        "--pgpass",
        help="PostgreSQL password",
    )
