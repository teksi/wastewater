#!/usr/bin/env python3
#
# -- View: tww_damage_channel

import argparse
import os

import psycopg
from pirogue.utils import select_columns


def vw_tww_damage_channel(
    connection: psycopg.Connection,
):
    """
    Creates tww_damage_channel view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_damage_channel;

    CREATE OR REPLACE VIEW tww_app.vw_tww_damage_channel AS
    WITH base AS(
      SELECT
        {dc_cols},
        ws.identifier AS ws_identifier,
        ST_LineMerge(ST_Collect(ST_Force2D(re.progression3d_geometry))) AS ch_progression2d_geometry,
        CASE
          WHEN re_2.obj_id IS NULL THEN 'upstream'::text
          ELSE 'downstream'::text
        END AS direction
        FROM tww_od.damage_channel dc
             LEFT JOIN tww_od.damage da ON da.obj_id::text = dc.obj_id::text
             LEFT JOIN tww_od.examination ex ON ex.obj_id::text = da.fk_examination::text
             LEFT JOIN tww_od.re_maintenance_event_wastewater_structure mews ON mews.fk_maintenance_event::text = ex.obj_id::text
             LEFT JOIN tww_od.wastewater_structure ws ON mews.fk_wastewater_structure::text = ws.obj_id::text
             LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id::text = ne.fk_wastewater_structure::text
             LEFT JOIN tww_od.reach re ON re.obj_id::text = ne.obj_id::text
             LEFT JOIN tww_od.reach_point rp ON rp.obj_id::text = ex.fk_reach_point::text
             LEFT JOIN tww_od.reach re_2 ON re_2.fk_reach_point_from::text = rp.obj_id::text
          WHERE ex.recording_type = 3686
          GROUP BY {dc_cols},ws.identifier, re_2.obj_id
        )
        SELECT
        {dc_cols_base},
        base.ws_identifier,
        ST_LineInterpolatePoint(base.ch_progression2d_geometry,
        CASE
            WHEN base.direction = 'downstream'
            THEN LEAST(base.channel_distance / ST_Length(base.ch_progression2d_geometry), 1)
            ELSE 1::double precision - LEAST(base.channel_distance / ST_Length(base.ch_progression2d_geometry), 1)
        END) AS situation2d_geometry,
        base.direction
        FROM base;
    """.format(
        dc_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="damage_channel",
            table_alias="dc",
            remove_pkey=False,
            indent=4,
        ),
        dc_cols_base=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="damage_channel",
            table_alias="base",
            remove_pkey=False,
            indent=4,
        ),
    )

    cursor.execute(view_sql)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_damage_channel(connection=conn)
