#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_node

import argparse
import os

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pirogue.utils import insert_command, select_columns, table_parts, update_command
from yaml import safe_load


def vw_tww_wastewater_node(srid: int, pg_service: str = None, extra_definition: dict = None):
    """
    Creates tww_wastewater_node view
    :param srid: EPSG code for geometries
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
    DROP VIEW IF EXISTS tww_app.vw_tww_wastewater_node;

    CREATE OR REPLACE VIEW tww_app.vw_tww_wastewater_node AS
     SELECT

          {wn_cols}
        , {ne_cols}
        , wns._status
        , wns._usage_current
        , wns._function_hierarchic
        {extra_cols}
        FROM tww_od.wastewater_node wn

        LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = wn.obj_id
        LEFT JOIN tww_od.tww_wastewater_node_symbology wns ON wns.fk_wastewater_node = wn.obj_id
        {extra_joins};

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
        wn_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
            remove_pkey=False,
            indent=4,
        ),
        ne_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
            remove_pkey=True,
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
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_node_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);


    {insert_wn}


      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_wastewater_node_INSERT ON tww_app.vw_tww_wastewater_node;

    CREATE TRIGGER vw_tww_wastewater_node_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_wastewater_node
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_node_INSERT();
    """.format(
        insert_wn=insert_command(
            pg_cur=cursor,
            table_schema="tww_app",
            table_name="vw_wastewater_node",
            table_type="view",
            table_alias="wn",
            pkey="obj_id",
        ),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_node_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      dx float;
      dy float;
    BEGIN
      {update_wn}
      {update_ne}

      IF NOT ST_Equals( OLD.situation3d_geometry, NEW.situation3d_geometry) THEN
        dx = ST_X(NEW.situation3d_geometry) - ST_X(OLD.situation3d_geometry);
        dy = ST_Y(NEW.situation3d_geometry) - ST_Y(OLD.situation3d_geometry);
        -- Move reach point node as well
        UPDATE tww_od.reach_point RP
        SET situation3d_geometry = ST_SetSRID( ST_MakePoint(
        ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(RP.situation3d_geometry), ST_Y(RP.situation3d_geometry)), dx, dy )),
        ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(RP.situation3d_geometry), ST_Y(RP.situation3d_geometry)), dx, dy )),
        ST_Z(RP.situation3d_geometry)), {srid} )
        WHERE obj_id IN
        (
          SELECT RP.obj_id FROM tww_od.reach_point RP
          WHERE RP.fk_wastewater_networkelement = NEW.obj_id
        );

        -- Move reach(es) as well
        UPDATE tww_od.reach RE
        SET progression3d_geometry =
          ST_ForceCurve (ST_SetPoint(
            ST_CurveToLine (RE.progression3d_geometry ),
            0, -- SetPoint index is 0 based, PointN index is 1 based.
            ST_SetSRID( ST_MakePoint(
                ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(ST_PointN(RE.progression3d_geometry, 1)), ST_Y(ST_PointN(RE.progression3d_geometry, 1))), dx, dy )),
                ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(ST_PointN(RE.progression3d_geometry, 1)), ST_Y(ST_PointN(RE.progression3d_geometry, 1))), dx, dy )),
                ST_Z(ST_PointN(RE.progression3d_geometry, 1))), {srid} )
          ) )
        WHERE fk_reach_point_from IN
        (
          SELECT RP.obj_id FROM tww_od.reach_point RP
          WHERE RP.fk_wastewater_networkelement = NEW.obj_id
        );

        UPDATE tww_od.reach RE
        SET progression3d_geometry =
          ST_ForceCurve( ST_SetPoint(
            ST_CurveToLine( RE.progression3d_geometry ),
            ST_NumPoints(RE.progression3d_geometry) - 1,
            ST_SetSRID( ST_MakePoint(
                ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(ST_EndPoint(RE.progression3d_geometry)), ST_Y(ST_EndPoint(RE.progression3d_geometry))), dx, dy )),
                ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(ST_EndPoint(RE.progression3d_geometry)), ST_Y(ST_EndPoint(RE.progression3d_geometry))), dx, dy )),
                ST_Z(ST_PointN(RE.progression3d_geometry, 1))), {srid} )
          ) )
        WHERE fk_reach_point_to IN
        (
          SELECT RP.obj_id FROM tww_od.reach_point RP
          WHERE RP.fk_wastewater_networkelement = NEW.obj_id
        );
      END IF;

      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_wastewater_node_UPDATE ON tww_app.vw_tww_wastewater_node;

    CREATE TRIGGER vw_tww_wastewater_node_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_wastewater_node
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_node_UPDATE();
    """.format(
        srid=srid,
        update_wn=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
        ),
        update_ne=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
        ),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_node_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_networkelement WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_wastewater_node_DELETE ON tww_app.vw_tww_wastewater_node;

    CREATE TRIGGER vw_tww_wastewater_node_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_wastewater_node
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_node_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_wastewater_node ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_node');
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


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
    srid = args.srid or os.getenv("SRID")
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    extra_definition = safe_load(open(args.extra_definition)) if args.extra_definition else {}
    vw_tww_wastewater_node(srid=srid, pg_service=pg_service, extra_definition=extra_definition)
