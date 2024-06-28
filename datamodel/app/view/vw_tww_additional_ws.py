#!/usr/bin/env python3
#
# -- View: vw_tww_additional_ws

import argparse
import os

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
from pirogue.utils import insert_command, select_columns, update_command


def vw_tww_additional_ws(srid: int, pg_service: str = None):
    """
    Creates additional_wastewater_structure view
    :param srid: EPSG code for geometries
    :param pg_service: the PostgreSQL service name
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_additional_ws;

    CREATE OR REPLACE VIEW tww_app.vw_tww_additional_ws AS
     SELECT
        ws.identifier as identifier,

        CASE
          WHEN wt.obj_id IS NOT NULL THEN 'wwtp_structure'
          WHEN sm.obj_id IS NOT NULL THEN 'small_treatment_plant'
          WHEN dt.obj_id IS NOT NULL THEN 'drainless_toilet'
          ELSE 'unknown'
        END AS ws_type
        , wt.kind AS wt_kind

        , sm.function as sm_function
        , ws.fk_owner
        , ws.status

        , {ws_cols}

        , main_co_sp.identifier AS co_identifier
        , main_co_sp.remark AS co_remark
        , main_co_sp.renovation_demand AS co_renovation_demand

        , {main_co_cols}
        , ST_Force2D(COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry))::geometry(Point, {srid}) AS situation3d_geometry

        , {wt_columns}

        , {sm_columns}

        , {dt_columns}

        , {wn_cols}
        , {ne_cols}

        , ws._label
        , ws._cover_label
        , ws._bottom_label
        , ws._input_label
        , ws._output_label
        , wn._usage_current AS _channel_usage_current
        , wn._function_hierarchic AS _channel_function_hierarchic

        FROM tww_od.wastewater_structure ws
        LEFT JOIN tww_od.cover main_co ON main_co.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.structure_part main_co_sp ON main_co_sp.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.wwtp_structure wt ON wt.obj_id = ws.obj_id
        LEFT JOIN tww_od.small_treatment_plant sm ON sm.obj_id = ws.obj_id
        LEFT JOIN tww_od.drainless_toilet dt ON dt.obj_id = ws.obj_id
        LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
        LEFT JOIN tww_od.manhole ma ON ma.obj_id = ws.obj_id
        LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
        LEFT JOIN tww_od.discharge_point dp ON dp.obj_id = ws.obj_id
        LEFT JOIN tww_od.infiltration_installation ii ON ii.obj_id = ws.obj_id
        WHERE '-1'= ALL(ARRAY[ch.obj_id,ma.obj_id,ss.obj_id,dp.obj_id,ii.obj_id]) IS NULL
        AND '-2'= ALL(ARRAY[ch.obj_id,ma.obj_id,ss.obj_id,dp.obj_id,ii.obj_id]) IS NULL;

        ALTER VIEW tww_app.vw_tww_additional_ws ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure');
        ALTER VIEW tww_app.vw_tww_additional_ws ALTER co_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','cover');
        ALTER VIEW tww_app.vw_tww_additional_ws ALTER wn_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_node');
    """.format(
        srid=srid,
        ws_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "identifier",
                "fk_owner",
                "status",
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
                "fk_main_cover",
                "fk_main_wastewater_node",
                "detail_geometry3d_geometry",
            ],
        ),
        main_co_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="cover",
            table_alias="main_co",
            remove_pkey=False,
            indent=4,
            skip_columns=["situation3d_geometry"],
            prefix="co_",
            remap_columns={"cover_shape": "co_shape"},
            columns_at_end=["obj_id"],
        ),
        wt_columns=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wwtp_structure",
            table_alias="wt",
            remove_pkey=True,
            indent=4,
            skip_columns=["kind"],
            prefix="wt_",
            remap_columns={},
        ),
        sm_columns=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="small_treatment_plant",
            table_alias="sm",
            remove_pkey=True,
            indent=4,
            skip_columns=["function"],
            prefix="sm_",
            remap_columns={},
        ),
        dt_columns=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="drainless_toilet",
            table_alias="dt",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
            prefix="to_",
            remap_columns={},
        ),
        wn_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
            remove_pkey=False,
            indent=4,
            skip_columns=["situation3d_geometry"],
            prefix="wn_",
            remap_columns={},
            columns_at_end=["obj_id"],
        ),
        ne_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
            prefix="wn_",
            remap_columns={},
        ),
    )

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_additional_ws_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ws}

      CASE
        WHEN NEW.ws_type = 'wwtp_structure' THEN
        -- wwtp_structure
    {insert_wt}

        -- small_treatment_plant
        WHEN NEW.ws_type = 'small_treatment_plant' THEN
    {insert_sm}

        -- drainless_toilet
        WHEN NEW.ws_type = 'drainless_toilet' THEN
    {insert_dt}


        ELSE
         RAISE NOTICE 'Wastewater structure type not known (%)', NEW.ws_type; -- ERROR
      END CASE;

    {insert_wn}

      UPDATE tww_od.wastewater_structure
        SET fk_main_wastewater_node = NEW.wn_obj_id
        WHERE obj_id = NEW.obj_id;

    {insert_vw_cover}

      UPDATE tww_od.wastewater_structure
        SET fk_main_cover = NEW.co_obj_id
        WHERE obj_id = NEW.obj_id;

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_additional_ws_INSERT ON tww_app.vw_tww_additional_ws;

    CREATE TRIGGER vw_tww_additional_ws_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_additional_ws
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_additional_ws_INSERT();
    """.format(
        insert_ws=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=2,
            skip_columns=[
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
                "fk_main_cover",
                "fk_main_wastewater_node",
                "detail_geometry3d_geometry",
            ],
        ),
        insert_wt=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wwtp_structure",
            table_alias="wt",
            prefix="wt_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_sm=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="small_treatment_plant",
            table_alias="sm",
            prefix="sm_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_dt=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="drainless_toilet",
            table_alias="dt",
            prefix="to_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_wn=insert_command(
            pg_cur=cursor,
            table_schema="tww_app",
            table_name="vw_wastewater_node",
            table_type="view",
            table_alias="wn",
            prefix="wn_",
            remove_pkey=False,
            pkey="obj_id",
            indent=6,
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.wn_identifier,''), NEW.identifier)",
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )".format(
                    srid=srid
                ),
                "last_modification": "NOW()",
                "fk_provider": "COALESCE(NULLIF(NEW.wn_fk_provider,''), NEW.fk_provider)",
                "fk_dataowner": "COALESCE(NULLIF(NEW.wn_fk_dataowner,''), NEW.fk_dataowner)",
                "fk_wastewater_structure": "NEW.obj_id",
            },
        ),
        insert_vw_cover=insert_command(
            pg_cur=cursor,
            table_schema="tww_app",
            table_name="vw_cover",
            table_type="view",
            table_alias="co",
            prefix="co_",
            remove_pkey=False,
            pkey="obj_id",
            indent=6,
            remap_columns={"cover_shape": "co_shape"},
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.co_identifier,''), NEW.identifier)",
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )".format(
                    srid=srid
                ),
                "last_modification": "NOW()",
                "fk_provider": "NEW.fk_provider",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_wastewater_structure": "NEW.obj_id",
            },
        ),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_additional_ws_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      dx float;
      dy float;
    BEGIN
      {update_co}
      {update_sp}
      {update_ws}
      {update_wn}

      IF OLD.ws_type <> NEW.ws_type THEN
        CASE WHEN OLD.ws_type <> 'unknown' THEN
          BEGIN
            EXECUTE FORMAT({literal_delete_on_ws_change});
          END;
        END CASE;

        CASE WHEN NEW.ws_type = ANY(ARRAY['manhole','special_structure','discharge_point','infiltration_installation','drainless_toilet','wwtp_structure','small_treatment_plant']) THEN
          BEGIN
            EXECUTE FORMAT({literal_insert_on_ws_change});
          END;
        END CASE;
      END IF;

      CASE
        WHEN NEW.ws_type = 'wwtp_structure' THEN
          {update_wt}

        WHEN NEW.ws_type = 'small_treatment_plant' THEN
          {update_sm}

        WHEN NEW.ws_type = 'drainless_toilet' THEN
          {update_dt}

        ELSE -- do nothing
      END CASE;

      -- Cover geometry has been moved
      IF NOT ST_Equals( OLD.situation3d_geometry, NEW.situation3d_geometry) THEN
        dx = ST_X(NEW.situation3d_geometry) - ST_X(OLD.situation3d_geometry);
        dy = ST_Y(NEW.situation3d_geometry) - ST_Y(OLD.situation3d_geometry);

        -- Move wastewater node as well
        -- comment: TRANSLATE((ST_MakePoint(500, 900, 'NaN')), 10, 20, 0) would return NaN NaN NaN - so we have this workaround
        UPDATE tww_od.wastewater_node WN
        SET situation3d_geometry = ST_SetSRID( ST_MakePoint(
        ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(WN.situation3d_geometry), ST_Y(WN.situation3d_geometry)), dx, dy )),
        ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(WN.situation3d_geometry), ST_Y(WN.situation3d_geometry)), dx, dy )),
        ST_Z(WN.situation3d_geometry)), {srid} )
        WHERE obj_id IN
        (
          SELECT obj_id FROM tww_od.wastewater_networkelement
          WHERE fk_wastewater_structure = NEW.obj_id
        );

        -- Move covers
        UPDATE tww_od.cover CO
        SET situation3d_geometry = ST_SetSRID( ST_MakePoint(
        ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(CO.situation3d_geometry), ST_Y(CO.situation3d_geometry)), dx, dy )),
        ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(CO.situation3d_geometry), ST_Y(CO.situation3d_geometry)), dx, dy )),
        ST_Z(CO.situation3d_geometry)), {srid} )
        WHERE obj_id IN
        (
          SELECT obj_id FROM tww_od.structure_part
          WHERE fk_wastewater_structure = NEW.obj_id
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
          LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
          WHERE NE.fk_wastewater_structure = NEW.obj_id
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
          LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
          WHERE NE.fk_wastewater_structure = NEW.obj_id
        );
      END IF;

      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_additional_ws_UPDATE ON tww_app.vw_tww_additional_ws;

    CREATE TRIGGER vw_tww_additional_ws_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_additional_ws
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_additional_ws_UPDATE();
    """.format(
        srid=srid,
        literal_delete_on_ws_change="'DELETE FROM tww_od.%I WHERE obj_id = %L',OLD.ws_type,OLD.obj_id",
        literal_insert_on_ws_change="'INSERT INTO tww_od.%I(obj_id) VALUES (%L)',NEW.ws_type,OLD.obj_id",
        update_co=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="cover",
            table_alias="co",
            prefix="co_",
            indent=6,
            skip_columns=["situation3d_geometry"],
            remap_columns={"cover_shape": "co_shape"},
        ),
        update_sp=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="structure_part",
            table_alias="sp",
            prefix="co_",
            indent=6,
            skip_columns=["fk_wastewater_structure"],
            update_values={
                "last_modification": "NEW.last_modification",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_provider": "NEW.fk_provider",
            },
        ),
        update_ws=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=6,
            skip_columns=[
                "detail_geometry3d_geometry",
                "last_modification",
                "_label",
                "_cover_label",
                "_bottom_label",
                "_input_label",
                "_output_label",
                "fk_main_cover",
                "fk_main_wastewater_node",
                "_depth",
            ],
            update_values={},
        ),
        update_wt=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wwtp_structure",
            table_alias="wt",
            prefix="wt_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_sm=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="small_treatment_plant",
            table_alias="sm",
            prefix="sm_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_dt=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="drainless_toilet",
            table_alias="dt",
            prefix="to_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_wn=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
            prefix="wn_",
            indent=6,
            skip_columns=["situation3d_geometry"],
        ),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_additional_ws_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_structure WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_additional_ws_DELETE ON tww_app.vw_tww_additional_ws;

    CREATE TRIGGER vw_tww_additional_ws_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_additional_ws
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_additional_ws_DELETE();
    """
    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_additional_ws ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure');
    ALTER VIEW tww_app.vw_tww_additional_ws ALTER co_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','cover');
    ALTER VIEW tww_app.vw_tww_additional_ws ALTER wn_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_node');
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--srid", help="EPSG code for SRID")
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    srid = args.srid or os.getenv("SRID")
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    vw_tww_additional_ws(srid=srid, pg_service=pg_service)
