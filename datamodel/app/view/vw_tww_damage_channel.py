#!/usr/bin/env python3
#
# -- View: tww_damage_channel

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, update_command

from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)


def vw_tww_damage_channel(
    connection: psycopg.Connection,
    extra_definition: dict = None,
):
    """
    Creates tww_damage_channel view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}
    # copy for CTE
    extra_definition_base = extra_definition.copy()
    if extra_definition_base and "joins" in extra_definition_base:
        for join_def in extra_definition_base["joins"].values():
            join_def["table_alias"] = "base"
    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_damage_channel;

    CREATE OR REPLACE VIEW tww_app.vw_tww_damage_channel AS
    WITH base AS(
      SELECT
        {dg_cols},
        {dc_cols},
        ws.identifier AS ws_identifier,
        ch.progression2d_geometry AS ch_progression2d_geometry,
            CASE
                WHEN ch.fk_reach_point_to::text = ex.fk_reach_point::text THEN 'upstream'::text
                WHEN ch.fk_reach_point_from::text = ex.fk_reach_point::text THEN 'downstream'::text
                ELSE 'unknown'::text
            END AS direction,
        ch.tww_is_primary
        {extra_cols}
        FROM tww_od.damage_channel dc
             LEFT JOIN tww_od.damage dg ON dg.obj_id::text = dc.obj_id::text
             LEFT JOIN tww_od.examination ex ON ex.obj_id::text = dg.fk_examination::text
             LEFT JOIN tww_od.re_maintenance_event_wastewater_structure mews ON mews.fk_maintenance_event::text = ex.obj_id::text
             LEFT JOIN tww_od.wastewater_structure ws ON mews.fk_wastewater_structure::text = ws.obj_id::text
             LEFT JOIN tww_app.mvw_tww_channel ch ON ch.obj_id = ws.obj_id
             {extra_joins}
          WHERE ex.recording_type = 3686
        ),
        damage_pictures AS(
        SELECT dc.obj_id, array_agg(COALESCE(dm.path || fi.path_relative, fi.path_relative)) over w as pics
        FROM tww_od.file fi
        INNER JOIN tww_od.damage_channel dc ON fi.object = dc.obj_id
        INNER JOIN tww_od.damage dg ON dg.obj_id = dc.obj_id
        LEFT JOIN tww_od.examination ex ON dg.fk_examination = ex.obj_id
        LEFT JOIN tww_od.maintenance_event me on me.obj_id = ex.obj_id
        LEFT JOIN tww_od.data_media dm ON dm.obj_id = fi.fk_data_media
        WHERE fi.tww_outdated IS NOT True AND fi.kind=3772 --picture
        WINDOW W as (ORDER BY fi.obj_id DESC)
        ),
        examination_videos AS(
        SELECT dc.obj_id, FIRST_value(COALESCE(dm.path || fi.path_relative, fi.path_relative)) over w as video
        FROM tww_od.file fi
        INNER JOIN tww_od.examination ex ON fi.object = ex.obj_id
        INNER JOIN tww_od.maintenance_event me on me.obj_id = ex.obj_id
        RIGHT JOIN tww_od.damage dg on dg.fk_examination = ex.obj_id
        INNER JOIN tww_od.damage_channel dc ON dg.obj_id = dc.obj_id
        LEFT JOIN tww_od.data_media dm ON dm.obj_id = fi.fk_data_media
        WHERE fi.tww_outdated IS NOT True AND ex.tww_outdated IS NOT True AND fi.kind IN (3775, 9146)
        WINDOW W as (PARTITION BY ex.fk_reach_point ORDER BY me.time_point DESC)
        )
        SELECT
        {dg_cols_base}
        , {dc_cols_base}
        , base.ws_identifier
        , ST_LineInterpolatePoint(st_LineMerge(base.ch_progression2d_geometry),
        CASE
            WHEN base.direction = 'downstream'::text THEN LEAST(base.channel_distance / st_length(base.ch_progression2d_geometry), 1)
            WHEN base.direction = 'upstream'::text THEN 1 - LEAST(base.channel_distance / st_length(base.ch_progression2d_geometry), 1)
            ELSE NULL
        END) AS situation2d_geometry
        , base.direction
        , base.tww_is_primary
        , damage_pictures.pics[1] as picture_1
        , damage_pictures.pics[2] as picture_2
        , examination_videos.video
        {extra_cols_base}
        FROM base
        LEFT JOIN damage_pictures ON damage_pictures.obj_id=base.obj_id
        LEFT JOIN examination_videos ON examination_videos.obj_id=base.obj_id;
    """.format(
        dg_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="damage",
            table_alias="dg",
            remove_pkey=False,
            indent=4,
        ),
        dg_cols_base=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="damage",
            table_alias="base",
            remove_pkey=True,
            indent=4,
        ),
        dc_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="damage_channel",
            table_alias="dc",
            remove_pkey=True,
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
        extra_cols=(
            ""
            if not extra_definition
            else extra_cols(connection=connection, extra_definition=extra_definition)
        ),
        extra_cols_base=(
            ""
            if not extra_definition
            else "," + extra_cols(connection=connection, extra_definition=extra_definition_base)
        ),
        extra_joins=extra_joins(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_damage_channel_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

    {insert_dg}
    {insert_dc}
    {insert_extra}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_damage_channel_INSERT ON tww_app.vw_tww_damage_channel;

    CREATE TRIGGER vw_tww_damage_channel_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_damage_channel
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_damage_channel_INSERT();
    """.format(
        insert_dg=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="damage",
            table_alias="dg",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
        ),
        insert_dc=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="damage_channel",
            table_alias="dc",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_damage_channel_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_dg}
      {update_dc}
      {update_extra}
       RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_damage_channel_UPDATE ON tww_app.vw_tww_damage_channel;

    CREATE TRIGGER vw_tww_damage_channel_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_damage_channel
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_damage_channel_UPDATE();
    """.format(
        update_dg=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="damage",
            table_alias="dg",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_dc=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="damage_channel",
            table_alias="dc",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_damage_channel_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.damage WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_damage_channel_DELETE ON tww_app.vw_tww_damage_channel;

    CREATE TRIGGER vw_tww_damage_channel_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_damage_channel
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_damage_channel_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
        ALTER VIEW tww_app.vw_tww_damage_channel ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','damage_channel');
    """
    cursor.execute(extras)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_damage_channel(connection=conn)
