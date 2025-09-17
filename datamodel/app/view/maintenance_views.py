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


def vw_tww_channel(
    connection: psycopg.Connection,
    srid: psycopg.sql.Literal,
    extra_definition: dict = None,
    lang_code: str = "en",
):
    """
    Creates tww_channel view
    :param connection: Psycopg connection
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    matview_sql = """
    DROP MATERIALIZED VIEW IF EXISTS tww_app.vw_tww_channel;

    CREATE MATERIALIZED VIEW tww_app.vw_tww_channel AS
    WITH _topology AS
        (
        SELECT
          ch.obj_id
        , array_agg(wn_from.obj_id) AS _from_nodes
        , array_agg(wn_to.obj_id) as _to_nodes
      FROM tww_od.channel ch
         LEFT JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
         LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.reach re ON ne.obj_id = re.obj_id
         LEFT JOIN tww_od.reach_point rp_to ON re.fk_reach_point_to=rp_to.obj_id
         LEFT JOIN tww_od.wastewater_node wn_to on wn_to.obj_id=rp_to.fk_wastewater_networkelement
         LEFT JOIN tww_od.reach_point rp_from ON re.fk_reach_point_from=rp_from.obj_id
         LEFT JOIN tww_od.wastewater_node wn_from on wn_from.obj_id=rp_from.fk_wastewater_networkelement
       GROUP BY
         ch.obj_id
        )
        SELECT
          {ch_cols}
        , {ws_cols}
        , ST_Multi(ST_Force2D(ST_ForceCurve(ST_LineMerge(ST_Collect(ST_CurveToLine(re.progression3d_geometry))))))::geometry(MultiCurve, {{srid}})  as progression2d_geometry
        , min(re.clear_height) AS _re_min_height
        , max(re.clear_height) AS _re_max_height
        , sum(length_effective) as _re_length_effective
        , array_agg(DISTINCT vl_mat.value_{lang_code}) as _re_materials
        , (
            SELECT unnest(_topology._from_nodes)
            EXCEPT ALL
            SELECT unnest(_topology._to_nodes)
            LIMIT 1
          ) AS _from_node
        , (
            SELECT unnest(_topology._to_nodes)
            EXCEPT ALL
            SELECT unnest(_topology._from_nodes)
            LIMIT 1
          ) AS _to_node
        , vl_fh.tww_is_primary
      FROM tww_od.channel ch
         INNER JOIN _topology on _topology.obj_id=ch.obj_id
         LEFT JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
         LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.reach re ON ne.obj_id = re.obj_id
         LEFT JOIN tww_vl.channel_function_hierarchic vl_fh ON vl_fh.code = ch.function_hierarchic
         LEFT JOIN tww_vl.reach_material vl_mat on vl_mat.code = re.material
       GROUP BY
         {ch_cols_grp}
        , {ws_cols_grp}
        , _topology._from_nodes
        , _topology._to_nodes
        , vl_fh.tww_is_primary
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
        ch_cols_grp=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        ws_cols_grp=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
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
         INNER JOIN tww_app.vw_tww_channel ch ON ch.obj_id = mw.fk_wastewater_structure
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
        vw_tww_channel(connection=conn)
        vw_tww_channel_maintenance(connection=conn)
        vw_tww_ws_maintenance(connection=conn)
