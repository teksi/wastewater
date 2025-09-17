#!/usr/bin/env python3
#
# -- View: vw_tww_log_card

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, update_command
from pum.exceptions import PumHookError
from yaml import safe_load

from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)


def vw_tww_log_card(
    connection: psycopg.Connection, srid: psycopg.sql.Literal, extra_definition: dict = None
):
    """
    Creates tww_log_card view
    :param connection: a psycopg connection object
    :param srid: EPSG code for geometries
    :param extra_definition: a dictionary for additional columns
    """

    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_log_card;

    CREATE OR REPLACE VIEW tww_app.vw_tww_log_card AS

    SELECT
          {lc_cols}
        , ne.identifier
        , ST_Force2D(COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry))::geometry(Point, {{srid}}) AS situation3d_geometry
        , ws.status as ws_status
        , ma.function as ma_function
        , ss.function as ss_function
        , dp.relevance as dp_relevance
        , ii.kind as ii_kind
        {extra_cols}

      FROM tww_od.log_card lc
         LEFT JOIN tww_od.wastewater_networkelement ne ON lc.fk_pwwf_wastewater_node = ne.obj_id
         LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ne.obj_id
         LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.manhole ma ON ma.obj_id = ws.obj_id
         LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
         LEFT JOIN tww_od.discharge_point dp ON dp.obj_id = ws.obj_id
         LEFT JOIN tww_od.infiltration_installation ii ON ii.obj_id = ws.obj_id
         LEFT JOIN tww_od.cover main_co ON ws.fk_main_cover = main_co.obj_id
         {extra_joins}
         ;
    """.format(
        lc_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="log_card",
            table_alias="lc",
            indent=4,
            skip_columns=[],
        ),
        extra_cols=(
            ""
            if not extra_definition
            else ", " + extra_cols(connection=connection, extra_definition=extra_definition)
        ),
        extra_joins=extra_joins(connection=connection, extra_definition=extra_definition),
    )

    view_sql = psycopg.sql.SQL(view_sql).format(srid=psycopg.sql.Literal(srid))

    try:
        cursor.execute(view_sql)
    except psycopg.errors.SyntaxError as e:
        raise PumHookError(f"Error creating view with code: {view_sql}: {e}")

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_log_card_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {insert_lc}
      {insert_extra}
      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_log_card_INSERT ON tww_app.vw_tww_log_card;

    CREATE TRIGGER vw_tww_log_card_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_log_card
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_log_card_INSERT();
    """.format(
        insert_lc=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="log_card",
            table_alias="lc",
            remove_pkey=False,
            indent=2,
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    trigger_insert_sql = psycopg.sql.SQL(trigger_insert_sql)

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_log_card_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      dx float;
      dy float;
    BEGIN

      {update_lc}
      {update_extra}
      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_log_card_UPDATE ON tww_app.vw_tww_log_card;

    CREATE TRIGGER vw_tww_log_card_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_log_card
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_log_card_UPDATE();
    """.format(
        update_lc=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="log_card",
            table_alias="lc",
            remove_pkey=False,
            indent=6,
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )

    update_trigger_sql = psycopg.sql.SQL(update_trigger_sql)

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_log_card_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.log_card WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_log_card_DELETE ON tww_app.vw_tww_log_card;

    CREATE TRIGGER vw_tww_log_card_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_log_card
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_log_card_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_log_card ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','log_card');
    """
    cursor.execute(extras)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--srid", help="EPSG code for SRID")
    parser.add_argument(
        "-e",
        "--extra-definition",
        help="YAML file path for extra additions to the view",
    )
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    srid = psycopg.sql.Literal(args.srid or os.getenv("SRID"))
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    extra_definition = {}
    if args.extra_definition:
        with open(args.extra_definition) as f:
            extra_definition = safe_load(f)
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_log_card(
            connection=conn,
            srid=srid,
            extra_definition=extra_definition,
        )
