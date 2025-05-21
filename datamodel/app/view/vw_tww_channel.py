#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_structure

import argparse
import os

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
from pirogue.utils import select_columns


def vw_tww_channel(pg_service: str = None):
    """
    Creates tww_channel view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_channel;

    CREATE OR REPLACE VIEW tww_app.vw_tww_channel AS

    SELECT
          {ws_cols}
        , {ch_cols}
        , ST_CurveToLine(ST_LineMerge(ST_Collect(ST_CurveToLine(re.progression3d_geometry)))) as progression3d_geometry
      FROM tww_od.channel ch
         LEFT JOIN tww_od.wastewater_structure ws ON ch.obj_id = ws.obj_id
         LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.reach re ON ne.obj_id = re.obj_id
       GROUP BY
         {ch_cols_grp}
        , {ws_cols_grp}
         ;
    """.format(
        ch_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            prefix="ch_",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
        ),
        ws_cols=select_columns(
            pg_cur=cursor,
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
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
        ),
        ws_cols_grp=select_columns(
            pg_cur=cursor,
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

    cursor.execute(view_sql)

    extras = """
    COMMENT ON VIEW tww_app.vw_tww_channel IS 'Read only';
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    vw_tww_channel(pg_service=pg_service)
