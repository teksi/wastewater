#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_structure

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, table_parts, update_command
from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)




def vw_tww_channel(
        connection: psycopg.Connection, srid: psycopg.sql.Literal, extra_definition: dict = None
    ):
    """
    Creates tww_channel view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    matview_sql = """
    DROP MATERIALIZED VIEW IF EXISTS tww_app.vw_tww_channel;

    CREATE MATERIALIZED VIEW tww_app.vw_tww_channel AS
          {ws_cols}
        , {ch_cols}
        , ST_LineMerge(ST_Collect(ST_CurveToLine(re.progression3d_geometry))) as progression3d_geometry::geometry(MultiCurve, {{srid}}) 
        , min(re.clear_height) AS _min_height
        , max(re.clear_height) AS _max_height
        , sum(length_effective) as _length_effective
        , array_agg(DISTINCT re.material) as _materials
      FROM tww_od.channel ch
         LEFT JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
         LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.reach re ON ne.obj_id = re.obj_id
       GROUP BY
         {ch_cols_grp}
        , {ws_cols_grp}
    """.format(
        ch_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            prefix="ch_",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
        ),
        ws_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "detail_geometry3d_geometry",
                "fk_owner",
                "fk_dataowner",
                "fk_provider",
                "_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
        ch_cols_grp=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
        ),
        ws_cols_grp=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "detail_geometry3d_geometry",
                "fk_owner",
                "fk_dataowner",
                "fk_provider",
                "_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
    )
    

    matview_sql = psycopg.sql.SQL(matview_sql).format(srid=psycopg.sql.Literal(srid))  
    cursor.execute(matview_sql)
    try:
        cursor.execute(matview_sql)
    except psycopg.errors.SyntaxError as e:
        raise PumHookError(f"Error creating view with code: {matview_sql}: {e}")

        
    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_channel_maintenance;

    CREATE OR REPLACE VIEW tww_app.vw_tww_channel_maintenance AS

    SELECT
          mw.id
        , {me_cols}
        , {mn_cols}  
        , {ch_cols}
        {extra_cols}
      FROM re_maintenance_event_wastewater_structure mw
         INNER JOIN tww_app.vw_tww_channel ch ON me.obj_id = mw.fk_wastewater_structure
         LEFT JOIN tww_od.maintenance_event me ON me.obj_id = mw.fk_maintenance_event
         LEFT JOIN tww_od.maintenance mn ON me.obj_id = mn.obj_id
         {extra_joins}
         ;
    """.format(
        ch_cols=select_columns(
            connection=connection,
            table_schema="tww_app",
            table_name="vw_tww_channel",
            table_alias="ch",
            prefix="ch_",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        me_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance_event",
            table_alias="me",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        mn_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance",
            table_alias="mn",
            remove_pkey=True,
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

    trigger_update_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_channel_update()
      RETURNS trigger AS
    $BODY$
    BEGIN

      {update_mn}
      {update_me}
      {update_extra}


      RETURN NEW;
    END; $BODY$
      LANGUAGE plpgsql VOLATILE;
    """.format(
        update_mn=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance",
            prefix="mn_",
            remove_pkey=True,
            indent=6,
            remap_columns={"obj_id": "me_obj_id"},
        ),
        update_me=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance_event",
            prefix="me_",
            remove_pkey=True,
            indent=6,
            update_values={"situation3d_geometry": "ST_EndPoint(NEW.progression3d_geometry)"},
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )
    cursor.execute(trigger_update_sql)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_channel(connection=conn)
