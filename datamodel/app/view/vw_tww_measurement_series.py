#!/usr/bin/env python3
#
# -- View: vw_tww_measurement_series

import argparse
import os

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pirogue.utils import insert_command, select_columns, update_command
from yaml import safe_load

from ..utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)


def vw_tww_measurement_series(pg_service: str = None, extra_definition: dict = None):
    """
    Creates tww_measurement_series view
    :param pg_service: the PostgreSQL service name
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_measurement_series;

    CREATE OR REPLACE VIEW tww_app.vw_tww_measurement_series AS
     SELECT
        {ms_cols}
        , array_agg(mr.value) AS mr_values

        {extra_cols}
        FROM tww_od.measurement_series ms
        LEFT JOIN tww_od.measurement_result mr ON ms.obj_id = mr.fk_measurement_series
        {extra_joins}
        GROUP BY {ms_cols}
        {extra_cols};

    """.format(
        ms_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="measurement_series",
            table_alias="ms",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        extra_cols=(
            ""
            if not extra_definition
            else extra_cols(pg_service=pg_service,extra_definition=extra_definition)
        ),
        extra_joins=extra_joins(pg_service=pg_service,extra_definition=extra_definition),
    )

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_measurement_series_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ms}
    {insert_extra}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_measurement_series_INSERT ON tww_app.vw_tww_measurement_series;

    CREATE TRIGGER vw_tww_measurement_series_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_measurement_series
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_measurement_series_INSERT();
    """.format(
        insert_ms=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="measurement_series",
            table_alias="ms",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
        ),
        insert_extra=insert_extra(pg_service=pg_service,extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_measurement_series_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_ms}
      {update_extra}
       RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_measurement_series_UPDATE ON tww_app.vw_tww_measurement_series;

    CREATE TRIGGER vw_tww_measurement_series_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_measurement_series
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_measurement_series_UPDATE();
    """.format(
        update_ms=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="measurement_series",
            table_alias="ms",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_extra=update_extra(pg_service=pg_service,extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_measurement_series_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.measurement_series WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_measurement_series_DELETE ON tww_app.vw_tww_measurement_series;

    CREATE TRIGGER vw_tww_measurement_series_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_measurement_series
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_measurement_series_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
        ALTER VIEW tww_app.vw_tww_measurement_series ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','measurement_series');
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


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
    vw_tww_measurement_series(pg_service=pg_service, extra_definition=extra_definition)
