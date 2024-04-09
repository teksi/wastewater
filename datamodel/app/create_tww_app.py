#!/usr/bin/env python3

import argparse
from pathlib import Path
from typing import Optional

import psycopg
from view.create_views import create_views


def run_sql_file(file_path: str, pg_service: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    with open(abs_file_path) as f:
        sql = f.read()
    run_sql(sql, pg_service, variables)


def run_sql(sql: str, pg_service: str, variables: dict = None):
    if variables:
        sql = psycopg.sql.SQL(sql).format(**variables)
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    conn.close()


def create_tww_app(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    tww_reach_extra: Optional[Path] = None,
    tww_wastewater_structure_extra: Optional[Path] = None,
    db_identifier: str = None,
):
    """
    Creates the schema tww_app for TEKSI Wastewater & GEP
    :param srid: the EPSG code for geometry columns
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param tww_reach_extra: YAML file path of the definition of additional columns for vw_tww_reach view
    :param tww_wastewater_structure_extra: YAML file path of the definition of additional columns for vw_tww_wastewater_structure_extra view
    :param db_identifier: database identifier
    """
    variables = {"SRID": srid, "db_identifier": db_identifier}

    run_sql("DROP SCHEMA IF EXISTS tww_app CASCADE;", pg_service)

    run_sql("CREATE SCHEMA tww_app;", pg_service)
    run_sql_file("symbology_functions.sql", pg_service)
    run_sql_file("reach_direction_change.sql", pg_service, variables)
    run_sql_file("14_geometry_functions.sql", pg_service, variables)

    create_views(
        srid,
        pg_service,
        tww_reach_extra,
        tww_wastewater_structure_extra,
    )

    run_sql_file("triggers/network.sql", pg_service)
    run_sql_file("tww_app_roles.sql", pg_service, variables)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "--tww_wastewater_structure_extra",
        help="YAML definition file path for additions to vw_tww_wastewater_structure view",
    )
    parser.add_argument(
        "--tww_reach_extra",
        help="YAML definition file path for additions to vw_tww_reach view",
    )
    parser.add_argument(
        "--db_identifier",
        help="identifier for database specific grant roles",
    )
    args = parser.parse_args()

    create_tww_app(
        args.srid,
        args.pg_service,
        tww_reach_extra=args.tww_reach_extra,
        tww_wastewater_structure_extra=args.tww_wastewater_structure_extra,
        db_identifier=args.db_identifier,
    )
