#!/usr/bin/env python3
#
# -- View: vw_wastewater_structure

import argparse
import os

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
from pirogue.utils import insert_command, select_columns, table_parts, update_command
from yaml import safe_load


def vw_wastewater_structure(pg_service: str = None, extra_definition: dict = None):
    """
    Creates tww_wastewater_structure view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service
    extra_definition = extra_definition or {}

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_wastewater_structure;

    CREATE OR REPLACE VIEW tww_app.vw_wastewater_structure AS
     SELECT
        {ws_cols}
        {extra_cols}
        , wn._usage_current AS _channel_usage_current
        , wn._function_hierarchic AS _channel_function_hierarchic

        FROM tww_od.wastewater_structure ws
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
        {extra_joins}
        WHERE ch.obj_id IS NULL;

        ALTER VIEW tww_app.vw_wastewater_structure ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure');
    """.format(
        extra_cols="\n    ".join(
            [
                select_columns(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    skip_columns=table_def.get("skip_columns", []),
                    remap_columns=table_def.get("remap_columns", {}),
                    prefix=table_def.get("prefix", None),
                    table_alias=table_def.get("alias", None),
                )
                + ","
                for table_def in extra_definition.get("joins", {}).values()
            ]
        ),
        ws_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
            ],
        ),
        extra_joins="\n    ".join(
            [
                "LEFT JOIN {tbl} {alias} ON {jon}".format(
                    tbl=table_def["table"],
                    alias=table_def.get("alias", ""),
                    jon=table_def["join_on"],
                )
                for table_def in extra_definition.get("joins", {}).values()
            ]
        ),
    )

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_wastewater_structure_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ws}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_wastewater_structure_INSERT ON tww_app.vw_wastewater_structure;

    CREATE TRIGGER vw_wastewater_structure_INSERT INSTEAD OF INSERT ON tww_app.vw_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_wastewater_structure_INSERT();
    """.format(
        insert_ws=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="",
            remove_pkey=False,
            indent=2,
            skip_columns=[
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
            ],
        ),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_wastewater_structure_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_ws}
      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_wastewater_structure_UPDATE ON tww_app.vw_wastewater_structure;

    CREATE TRIGGER vw_wastewater_structure_UPDATE INSTEAD OF UPDATE ON tww_app.vw_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_wastewater_structure_UPDATE();
    """.format(
        update_ws=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="",
            remove_pkey=False,
            indent=6,
            skip_columns=[
                "last_modification",
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
                "_depth",
            ],
            update_values={},
        ),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_wastewater_structure_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_structure WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_wastewater_structure_DELETE ON tww_app.vw_wastewater_structure;

    CREATE TRIGGER vw_wastewater_structure_DELETE INSTEAD OF DELETE ON tww_app.vw_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_wastewater_structure_DELETE();
    """
    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_wastewater_structure ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure');
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-e",
        "--extra-definition",
        help="YAML file path for extra additions to the view",
    )
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    extra_definition = safe_load(open(args.extra_definition)) if args.extra_definition else {}
    vw_wastewater_structure(pg_service=pg_service, extra_definition=extra_definition)
