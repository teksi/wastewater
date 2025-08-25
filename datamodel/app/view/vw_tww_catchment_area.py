#!/usr/bin/env python3
#
# -- View: vw_tww_catchment_area

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, update_command
from yaml import safe_load

from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)


def vw_tww_catchment_area(connection: psycopg.Connection, extra_definition: dict = None):
    """
    Creates tww_catchment_area view
    :param connection: psycopg Connection
    :param extra_definition: a dictionary for additional columns
    """
    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_catchment_area;

    CREATE OR REPLACE VIEW tww_app.vw_tww_catchment_area AS
     SELECT
        {ca_cols}
        , ca.population_density_current * ca.area AS _population_current
        , ca.population_density_planned * ca.area AS _population_planned
        , ca.discharge_coefficient_ww_current * ca.area AS _fred_ww_current
        , ca.discharge_coefficient_rw_current * ca.area AS _fred_rw_current
        , ca.discharge_coefficient_ww_planned * ca.area AS _fred_ww_current
        , ca.discharge_coefficient_rw_planned * ca.area AS _fred_rw_planned
        , ca.seal_factor_ww_current * ca.area AS _f_sealed_ww_current
        , ca.seal_factor_rw_current * ca.area AS _f_sealed_rw_current
        , ca.seal_factor_ww_planned * ca.area AS _f_sealed_ww_current
        , ca.seal_factor_rw_planned * ca.area AS _f_sealed_rw_planned

        {extra_cols}
        FROM tww_od.catchment_area ca
        {extra_joins};

    """.format(
        ca_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ca",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        extra_cols=(
            ""
            if not extra_definition
            else extra_cols(connection=connection, extra_definition=extra_definition)
        ),
        extra_joins=extra_joins(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ca}
    {insert_extra}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_INSERT ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_INSERT();
    """.format(
        insert_ca=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ca",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_ca}
      {update_extra}
       RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_catchment_area_UPDATE ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_UPDATE();
    """.format(
        update_ca=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ms",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.catchment_area WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_DELETE ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
        ALTER VIEW tww_app.vw_tww_catchment_area ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','catchment_area');
    """
    cursor.execute(extras)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()

    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    parser.add_argument(
        "-e",
        "--extra-definition",
        help="YAML file path for extra additions to the view",
    )
    args = parser.parse_args()
    extra_definition = {}
    if args.extra_definition:
        with open(args.extra_definition) as f:
            extra_definition = safe_load(f)
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as connection:
        vw_tww_catchment_area(connection=connection, extra_definition=extra_definition)
