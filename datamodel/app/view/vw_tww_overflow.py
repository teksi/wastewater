#!/usr/bin/env python3
#
# -- View: vw_tww_overflow

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


def vw_tww_overflow(pg_service: str = None, extra_definition: dict = None):
    """
    Creates tww_overflow view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional columns
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service
    extra_definition = extra_definition or {}

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_overflow;

    CREATE OR REPLACE VIEW tww_app.vw_tww_overflow AS
     SELECT
        ov.obj_id,
        CASE
          WHEN lw.obj_id IS NOT NULL THEN 'leapingweir'
          WHEN pw.obj_id IS NOT NULL THEN 'prank_weir'
          WHEN pu.obj_id IS NOT NULL THEN 'pump'
          ELSE 'unknown'
        END AS overflow_type
        , {ov_cols}
        , {lw_cols}
        , {pw_cols}
        , {pu_cols}
        , wn.situation3d_geometry as geometry
        {extra_cols}

        , wn._usage_current AS _channel_usage_current
        , wn._function_hierarchic AS _channel_function_hierarchic

        FROM tww_od.overflow ov
        LEFT JOIN tww_od.leapingweir lw on lw.obj_id= ov.obj_id
        LEFT JOIN tww_od.prank_weir pw on pw.obj_id= ov.obj_id
        LEFT JOIN tww_od.pump pu on pu.obj_id= ov.obj_id
        LEFT JOIN tww_od.wastewater_node wn on ov.fk_wastewater_node= wn.obj_id
        {extra_joins};

    """.format(
        extra_cols=(
            ""
            if not extra_definition
            else extra_cols(pg_service=pg_service, extra_definition=extra_definition)
        ),
        ov_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="overflow",
            table_alias="ov",
            remove_pkey=True,
            indent=4,
        ),
        lw_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="leapingweir",
            table_alias="lw",
            remove_pkey=False,
            indent=4,
            prefix="lw_",
        ),
        pw_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="prank_weir",
            table_alias="pw",
            remove_pkey=True,
            indent=4,
            prefix="pw_",
        ),
        pu_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="pump",
            table_alias="pu",
            remove_pkey=True,
            indent=4,
            prefix="pu_",
        ),
        extra_joins=extra_joins(pg_service=pg_service, extra_definition=extra_definition),
    )
    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_overflow_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ov}

      CASE
        WHEN NEW.overflow_type = 'leapingweir' THEN
        -- Leaping weir
    {insert_lw}

        -- Special Structure
        WHEN NEW.overflow_type = 'prank_weir' THEN
    {insert_pw}

        -- Discharge Point
        WHEN NEW.overflow_type = 'pump' THEN
    {insert_pu}

        ELSE
         RAISE NOTICE 'Overflow type not handled by this view (%)', NEW.overflow_type; -- ERROR
      END CASE;

      {insert_extra}
      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_overflow_INSERT ON tww_app.vw_tww_overflow;

    CREATE TRIGGER vw_tww_overflow_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_overflow
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_overflow_INSERT();
    """.format(
        insert_ov=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="overflow",
            table_alias="ov",
            remove_pkey=False,
            indent=2,
        ),
        insert_lw=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="leapingweir",
            table_alias="lw",
            prefix="lw_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_pw=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="prank_weir",
            table_alias="pw",
            prefix="pw_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_pu=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="pump",
            table_alias="pu",
            prefix="pu_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_extra=insert_extra(pg_service=pg_service, extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_overflow_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_ov}
      {update_extra}

      IF OLD.overflow_type <> NEW.overflow_type THEN
        CASE WHEN OLD.overflow_type <> 'unknown' THEN
          BEGIN
            EXECUTE FORMAT({literal_delete_on_ov_change});
          END;
        END CASE;

        CASE WHEN NEW.overflow_type = ANY(ARRAY['leapingweir','prank_weir','pump']) THEN
          BEGIN
            EXECUTE FORMAT({literal_insert_on_ov_change});
          END;
        END CASE;
      END IF;

      CASE
        WHEN NEW.overflow_type = 'leapingweir' THEN
          {update_lw}

        WHEN NEW.overflow_type = 'prank_weir' THEN
          {update_pw}

        WHEN NEW.overflow_type = 'pump' THEN
          {update_pu}

        ELSE NULL;
      END CASE;

      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_overflow_UPDATE ON tww_app.vw_tww_overflow;

    CREATE TRIGGER vw_tww_overflow_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_overflow
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_overflow_UPDATE();
    """.format(
        literal_delete_on_ov_change="'DELETE FROM tww_od.%I WHERE obj_id = %L',OLD.overflow_type,OLD.obj_id",
        literal_insert_on_ov_change="'INSERT INTO tww_od.%I(obj_id) VALUES (%L)',NEW.overflow_type,OLD.obj_id",
        update_ov=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="overflow",
            table_alias="ov",
            remove_pkey=False,
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_lw=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="leapingweir",
            table_alias="lw",
            prefix="lw_",
            remove_pkey=True,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        update_pw=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="prank_weir",
            table_alias="pw",
            prefix="pw_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_pu=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="pump",
            table_alias="pu",
            prefix="pu_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_extra=update_extra(pg_service=pg_service, extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_overflow_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_structure WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_overflow_DELETE ON tww_app.vw_tww_overflow;

    CREATE TRIGGER vw_tww_overflow_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_overflow
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_overflow_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_overflow ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_structure');
    ALTER VIEW tww_app.vw_tww_overflow ALTER co_obj_id SET DEFAULT tww_app.generate_oid('tww_od','cover');
    ALTER VIEW tww_app.vw_tww_overflow ALTER wn_obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_node');
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
    extra_definition = {}
    if args.extra_definition:
        with open(args.extra_definition) as f:
            extra_definition = safe_load(f)
    vw_tww_overflow(pg_service=pg_service, extra_definition=extra_definition)
