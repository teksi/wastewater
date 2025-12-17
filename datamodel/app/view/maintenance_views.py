#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_structure

import argparse
import os

import psycopg
from pirogue.utils import select_columns, update_command

from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    update_extra,
)


def mvw_tww_channel(
    connection: psycopg.Connection,
    srid: psycopg.sql.Literal,
    extra_definition: dict = None,
    lang_code: str = "en",
):
    """
    Creates mvw_tww_channel view
    :param connection: Psycopg connection
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    matview_sql = """
    DROP MATERIALIZED VIEW IF EXISTS tww_app.mvw_tww_channel;

    CREATE MATERIALIZED VIEW tww_app.mvw_tww_channel AS
     WITH  reach_2d AS MATERIALIZED (SELECT obj_id,
        st_curvetoline(st_force2d(progression3d_geometry)) AS progression2d_geometry,
                fk_reach_point_from,
                fk_reach_point_to,
                clear_height,
                length_effective,
                material
        FROM tww_od.reach),
        channel_geometries AS (
            SELECT
                ch.obj_id,
                st_startpoint(st_linemerge(st_collect(re.progression2d_geometry))) AS channel_start_point,
                st_endpoint(st_linemerge(st_collect(re.progression2d_geometry))) AS channel_end_point
            FROM tww_od.channel ch
            JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
            JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
            JOIN reach_2d re ON re.obj_id = ne.obj_id
            GROUP BY ch.obj_id
        ),
        reach_start_end_points AS (
            SELECT
                re.obj_id,
                ne.fk_wastewater_structure,
                re.fk_reach_point_from,
                re.fk_reach_point_to,
                st_startpoint(re.progression2d_geometry) AS reach_start_point,
                st_endpoint(re.progression2d_geometry) AS reach_end_point
            FROM reach_2d re
            JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = re.obj_id
        ),
        rp_channel AS (
            SELECT
                cg.obj_id,
                rs.fk_reach_point_from,
                re.fk_reach_point_to
            FROM channel_geometries cg
            JOIN reach_start_end_points rs ON rs.fk_wastewater_structure = cg.obj_id AND st_equals(rs.reach_start_point, cg.channel_start_point)
            JOIN reach_start_end_points re ON re.fk_wastewater_structure = cg.obj_id AND st_equals(re.reach_end_point, cg.channel_end_point)
        ), re_agg as(
        select ne.fk_wastewater_structure,
            st_multi(st_forcecurve(st_linemerge(st_collect(re.progression2d_geometry))))::geometry(MultiCurve, {{srid}}) AS progression2d_geometry,
            min(re.clear_height) AS _re_min_height,
            max(re.clear_height) AS _re_max_height,
            sum(re.length_effective) AS _re_length_effective,
            array_agg(DISTINCT vl_mat.value_{lang_code}) AS _re_materials
        FROM reach_2d re
        INNER JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = re.obj_id
        LEFT JOIN tww_vl.reach_material vl_mat ON vl_mat.code = re.material
        GROUP BY ne.fk_wastewater_structure
        )
        SELECT
          {ch_cols}
        , {ws_cols}
        , re_agg.progression2d_geometry
        , re_agg._re_min_height
        , re_agg._re_max_height
        , re_agg._re_length_effective
        , re_agg._re_materials
        , rpc.fk_reach_point_from
        , rp_from.fk_wastewater_networkelement as _from_ne
        , rpc.fk_reach_point_to
        , rp_to.fk_wastewater_networkelement as _to_ne
        , vl_fh.tww_is_primary
      FROM tww_od.channel ch
         JOIN rp_channel rpc ON rpc.obj_id::text = ch.obj_id::text
         LEFT JOIN tww_od.reach_point rp_from on rp_from.obj_id=rpc.fk_reach_point_from
         LEFT JOIN tww_od.reach_point rp_to on rp_to.obj_id=rpc.fk_reach_point_to
         LEFT JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
         LEFT JOIN re_agg on re_agg.fk_wastewater_structure = ch.obj_id
         LEFT JOIN tww_vl.channel_function_hierarchic vl_fh ON vl_fh.code = ch.function_hierarchic;
    """.format(
        lang_code=lang_code,
        ch_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        ws_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            prefix="ws_",
            remove_pkey=True,
            indent=4,
            skip_columns=[
                "detail_geometry3d_geometry",
                "fk_dataowner",
                "fk_provider",
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
    )

    matview_sql = psycopg.sql.SQL(matview_sql).format(srid=psycopg.sql.Literal(srid))
    cursor.execute(matview_sql)
    extras = """CREATE UNIQUE INDEX in_app_mvw_tww_channel_unique "
    "ON tww_app.mvw_tww_channel USING btreee
    (obj_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;"""

    extras_sql = psycopg.sql.SQL(extras)
    cursor.execute(extras_sql)


def vw_tww_channel_maintenance(connection: psycopg.Connection, extra_definition: dict = None):
    """
    Creates vw_tww_channel_maintenance view
    :param connection: Psycopg connection
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_channel_maintenance;

    CREATE OR REPLACE VIEW tww_app.vw_tww_channel_maintenance AS

    SELECT
          mw.id
        , {me_cols}
        , {mn_cols}
        , {ch_cols}
        {extra_cols}
      FROM tww_od.re_maintenance_event_wastewater_structure mw
         INNER JOIN tww_app.mvw_tww_channel ch ON ch.obj_id = mw.fk_wastewater_structure
         LEFT JOIN tww_od.maintenance_event me ON me.obj_id = mw.fk_maintenance_event
         LEFT JOIN tww_od.maintenance mn ON me.obj_id = mn.obj_id
         {extra_joins}
         ;
    """.format(
        ch_cols=select_columns(
            connection=connection,
            table_schema="tww_app",
            table_name="mvw_tww_channel",
            table_alias="ch",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            remap_columns={
                "obj_id": "ch_obj_id",
                "bedding_encasement": "ch_bedding_encasement",
                "connection_type": "ch_connection_type",
                "function_amelioration": "ch_function_amelioration",
                "function_hierarchic": "ch_function_hierarchic",
                "function_hydraulic": "ch_function_hydraulic",
                "jetting_interval": "ch_jetting_interval",
                "pipe_length": "ch_pipe_length",
                "seepage": "ch_seepage",
                "usage_current": "ch_usage_current",
                "usage_planned": "ch_usage_planned",
            },
        ),
        me_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance_event",
            table_alias="me",
            prefix="me_",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        mn_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance",
            table_alias="mn",
            prefix="mn_",
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
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_channel_maintenance_update()
      RETURNS trigger AS
    $BODY$
    BEGIN

      {update_mn}
      {update_me}
      {update_extra}


      RETURN NEW;
    END; $BODY$
      LANGUAGE plpgsql VOLATILE;

      CREATE TRIGGER vw_tww_channel_maintenance_update
      INSTEAD OF UPDATE
      ON tww_app.vw_tww_channel_maintenance
      FOR EACH ROW
      EXECUTE PROCEDURE tww_app.ft_vw_tww_channel_maintenance_update();
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
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )
    cursor.execute(trigger_update_sql)


def vw_tww_ws_maintenance(connection: psycopg.Connection, extra_definition: dict = None):
    """
    Creates vw_tww_ws_maintenance view
    :param connection: Psycopg connection
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()
    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_ws_maintenance;

    CREATE OR REPLACE VIEW tww_app.vw_tww_ws_maintenance AS

    SELECT
          mw.id
        , wn.situation3d_geometry
        , {me_cols}
        , {mn_cols}
        , {ws_cols}
        {extra_cols}
      FROM tww_od.re_maintenance_event_wastewater_structure mw
         INNER JOIN tww_od.wastewater_structure ws ON ws.obj_id = mw.fk_wastewater_structure
         LEFT JOIN tww_od.maintenance_event me ON me.obj_id = mw.fk_maintenance_event
         LEFT JOIN tww_od.maintenance mn ON me.obj_id = mn.obj_id
         LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
         {extra_joins}
         WHERE wn.obj_id IS NOT NULL;
         ;
    """.format(
        ws_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            prefix="ws_",
            remove_pkey=False,
            indent=4,
            safe_skip_columns=[
                "accessibility",
                "contract_section",
                "detail_geometry3d_geometry",
                "elevation_determination",
                "location_name",
                "records",
                "remark",
                "replacement_value",
                "rv_base_year",
                "rv_construction_type",
                "subsidies",
                "year_of_construction",
                "year_of_replacement",
                "last_modification",
                "fk_dataowner",
                "fk_provider",
                "fk_main_cover",
                "fk_main_wastewater_node",
                "_depth",
            ],
        ),
        me_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance_event",
            table_alias="me",
            prefix="me_",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        mn_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="maintenance",
            table_alias="mn",
            prefix="mn_",
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
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_ws_maintenance_update()
      RETURNS trigger AS
    $BODY$
    BEGIN

      {update_mn}
      {update_me}
      {update_extra}


      RETURN NEW;
    END; $BODY$
      LANGUAGE plpgsql VOLATILE;

      CREATE TRIGGER vw_tww_ws_maintenance_update
      INSTEAD OF UPDATE
      ON tww_app.vw_tww_ws_maintenance
      FOR EACH ROW
      EXECUTE PROCEDURE tww_app.ft_vw_tww_ws_maintenance_update();
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
        mvw_tww_channel(connection=conn)
        vw_tww_channel_maintenance(connection=conn)
        vw_tww_ws_maintenance(connection=conn)
