#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_structure

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


def vw_tww_wastewater_structure(
    connection: psycopg.Connection, srid: psycopg.sql.Literal, extra_definition: dict = None
):
    """
    Creates tww_wastewater_structure view
    :param connection: a psycopg connection object
    :param srid: EPSG code for geometries
    :param extra_definition: a dictionary for additional columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_wastewater_structure;

    CREATE OR REPLACE VIEW tww_app.vw_tww_wastewater_structure AS
     SELECT
        ws.identifier as identifier,

        CASE
          WHEN ma.obj_id IS NOT NULL THEN 'manhole'
          WHEN ss.obj_id IS NOT NULL THEN 'special_structure'
          WHEN dp.obj_id IS NOT NULL THEN 'discharge_point'
          WHEN ii.obj_id IS NOT NULL THEN 'infiltration_installation'
          ELSE 'unknown'
        END AS ws_type

        , ma.function AS ma_function
        , ss.function as ss_function
        , ws.fk_owner
        , ws.status

        {extra_cols}

        , {ws_cols}

        , main_co_sp.identifier AS co_identifier
        , main_co_sp.remark AS co_remark
        , main_co_sp.renovation_demand AS co_renovation_demand

        , {main_co_cols}
        , ST_Force2D(COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry))::geometry(Point, {{srid}}) AS situation3d_geometry

        , {ma_columns}

        , {ss_columns}

        , {ii_columns}

        , {dp_columns}

        , {wn_cols}
        , {ne_cols}

        , ws._label
        , ws._cover_label
        , ws._bottom_label
        , ws._input_label
        , ws._output_label
        , wn._usage_current AS _channel_usage_current
        , wn._function_hierarchic AS _channel_function_hierarchic
        , vl_fh.tww_is_primary

        FROM tww_od.wastewater_structure ws
        LEFT JOIN tww_od.cover main_co ON main_co.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.structure_part main_co_sp ON main_co_sp.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.manhole ma ON ma.obj_id = ws.obj_id
        LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
        LEFT JOIN tww_od.discharge_point dp ON dp.obj_id = ws.obj_id
        LEFT JOIN tww_od.infiltration_installation ii ON ii.obj_id = ws.obj_id
        LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
        {extra_joins}
        LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
        LEFT JOIN tww_od.wwtp_structure wt ON wt.obj_id = ws.obj_id
        LEFT JOIN tww_od.small_treatment_plant sm ON sm.obj_id = ws.obj_id
        LEFT JOIN tww_od.drainless_toilet dt ON dt.obj_id = ws.obj_id
        LEFT JOIN tww_vl.channel_function_hierarchic vl_fh ON vl_fh.code = wn._function_hierarchic
        WHERE '-1'=ALL(ARRAY[ch.obj_id,dt.obj_id,sm.obj_id,wt.obj_id]) IS NULL
        AND '-2'=ALL(ARRAY[ch.obj_id,dt.obj_id,sm.obj_id,wt.obj_id]) IS NULL;

    """.format(
        extra_cols=(
            ""
            if not extra_definition
            else extra_cols(connection=connection, extra_definition=extra_definition)
        ),
        ws_cols=select_columns(
            connection=connection,
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
            connection=connection,
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
        ma_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="manhole",
            table_alias="ma",
            remove_pkey=True,
            indent=4,
            skip_columns=["function"],
            prefix="ma_",
            remap_columns={"_orientation": "ma_orientation"},
        ),
        ss_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="special_structure",
            table_alias="ss",
            remove_pkey=True,
            indent=4,
            skip_columns=["function"],
            prefix="ss_",
            remap_columns={},
        ),
        ii_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="infiltration_installation",
            table_alias="ii",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
            prefix="ii_",
            remap_columns={},
        ),
        dp_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="discharge_point",
            table_alias="dp",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
            prefix="dp_",
            remap_columns={},
        ),
        wn_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "situation3d_geometry",
                "_usage_current",
                "_status",
                "_function_hierarchic",
            ],
            prefix="wn_",
            remap_columns={},
            columns_at_end=["obj_id"],
        ),
        ne_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
            remove_pkey=True,
            indent=4,
            skip_columns=[],
            prefix="wn_",
            remap_columns={},
        ),
        extra_joins=extra_joins(connection=connection, extra_definition=extra_definition),
    )
    view_sql = psycopg.sql.SQL(view_sql).format(srid=psycopg.sql.Literal(srid))

    try:
        cursor.execute(view_sql)
    except psycopg.errors.SyntaxError as e:
        raise PumHookError(f"Error creating view with code: {view_sql}: {e}")

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_structure_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN


      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ws}

      CASE
        WHEN NEW.ws_type = 'manhole' THEN
        -- Manhole
    {insert_ma}

        -- Special Structure
        WHEN NEW.ws_type = 'special_structure' THEN
    {insert_ss}

        -- Discharge Point
        WHEN NEW.ws_type = 'discharge_point' THEN
    {insert_dp}

        -- Infiltration Installation
        WHEN NEW.ws_type = 'infiltration_installation' THEN
    {insert_ii}

        ELSE
         RAISE NOTICE 'Wastewater structure type not handled by this view (%)', NEW.ws_type; -- ERROR
      END CASE;

    {insert_wn}


      CASE WHEN NOT tww_app.check_all_nulls(to_jsonb(NEW),'co') THEN -- no cover entries
        {insert_vw_cover}

     ELSE
       NEW.co_obj_id=NULL;
       PERFORM pg_notify('vw_tww_ws_no_cover', format('Wastewater Structure %s: no cover created. If you want to add a cover please fill in at least one cover attribute value.',NEW.identifier));
       RAISE WARNING 'Wastewater Structure %: no cover created as all cover-related columns are NULL. If you want to add a cover please fill in at least one cover attribute value.', NEW.identifier; -- Warning
    END CASE;

    UPDATE tww_od.wastewater_structure
      SET fk_main_cover = NEW.co_obj_id,
      fk_main_wastewater_node = NEW.wn_obj_id
      WHERE obj_id = NEW.obj_id;


      {insert_extra}
      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_wastewater_structure_INSERT ON tww_app.vw_tww_wastewater_structure;

    CREATE TRIGGER vw_tww_wastewater_structure_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_structure_INSERT();
    """.format(
        insert_ws=insert_command(
            connection=connection,
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
        insert_ma=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="manhole",
            table_alias="ma",
            prefix="ma_",
            remove_pkey=False,
            indent=6,
            skip_columns=["_orientation"],
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_ss=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="special_structure",
            table_alias="ss",
            prefix="ss_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_dp=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="discharge_point",
            table_alias="dp",
            prefix="dp_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_ii=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="infiltration_installation",
            table_alias="ii",
            prefix="ii_",
            remove_pkey=False,
            indent=6,
            remap_columns={"obj_id": "obj_id"},
        ),
        insert_wn=insert_command(
            connection=connection,
            table_schema="tww_app",
            table_name="vw_wastewater_node",
            table_type="view",
            table_alias="wn",
            prefix="wn_",
            remove_pkey=False,
            pkey="obj_id",
            indent=6,
            skip_columns=[
                "_usage_current",
                "_status",
                "_function_hierarchic",
            ],
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.wn_identifier,''), NEW.identifier)",
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )",
                "last_modification": "NOW()",
                "fk_provider": "COALESCE(NULLIF(NEW.wn_fk_provider,''), NEW.fk_provider)",
                "fk_dataowner": "COALESCE(NULLIF(NEW.wn_fk_dataowner,''), NEW.fk_dataowner)",
                "fk_wastewater_structure": "NEW.obj_id",
            },
            returning="obj_id INTO NEW.wn_obj_id",
        ),
        insert_vw_cover=insert_command(
            connection=connection,
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
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )",
                "last_modification": "NOW()",
                "fk_provider": "NEW.fk_provider",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_wastewater_structure": "NEW.obj_id",
            },
            returning="obj_id INTO NEW.co_obj_id",
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    trigger_insert_sql = psycopg.sql.SQL(trigger_insert_sql).format(srid=psycopg.sql.Literal(srid))

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_structure_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      dx float;
      dy float;
    BEGIN

      {update_co}
      IF NOT FOUND THEN
        CASE WHEN NOT tww_app.check_all_nulls(to_jsonb(NEW),'co') THEN -- no cover entries
          {insert_vw_cover}
        ELSE
          PERFORM pg_notify('vw_tww_ws_no_cover', format('Wastewater Structure %s: no cover created. If you want to add a cover please fill in at least one cover attribute value.',NEW.identifier));
        END CASE;
      END IF;
      {update_sp}
      {update_ws}
      {update_wn}
      {update_ne}
      {update_extra}

      IF OLD.ws_type <> NEW.ws_type THEN
        CASE WHEN OLD.ws_type <> 'unknown' THEN
          BEGIN
            EXECUTE FORMAT({literal_delete_on_ws_change});
          END;
        ELSE -- do nothing
          NULL;
        END CASE;

        CASE WHEN NEW.ws_type = ANY(ARRAY['manhole','special_structure','discharge_point','infiltration_installation','drainless_toilet','wwtp_structure','small_treatment_plant']) THEN
          BEGIN
            EXECUTE FORMAT({literal_insert_on_ws_change});
          END;
        ELSE -- do nothing
          NULL;
        END CASE;
      END IF;

      CASE
        WHEN NEW.ws_type = 'manhole' THEN
          {update_ma}

        WHEN NEW.ws_type = 'special_structure' THEN
          {update_ss}

        WHEN NEW.ws_type = 'discharge_point' THEN
          {update_dp}

        WHEN NEW.ws_type = 'infiltration_installation' THEN
          {update_ii}

        ELSE -- do nothing
          NULL;
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
        ST_Z(WN.situation3d_geometry)), {{srid}} )
        WHERE obj_id IN
        (
          SELECT obj_id FROM tww_od.wastewater_networkelement
          WHERE fk_wastewater_structure = NEW.obj_id
        );

        -- Move reach point node as well
        UPDATE tww_od.reach_point RP
        SET situation3d_geometry = ST_SetSRID( ST_MakePoint(
        ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(RP.situation3d_geometry), ST_Y(RP.situation3d_geometry)), dx, dy )),
        ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(RP.situation3d_geometry), ST_Y(RP.situation3d_geometry)), dx, dy )),
        ST_Z(RP.situation3d_geometry)), {{srid}} )
        WHERE obj_id IN
        (
          SELECT RP.obj_id FROM tww_od.reach_point RP
          LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
          WHERE NE.fk_wastewater_structure = NEW.obj_id
        );

        -- Move covers
        UPDATE tww_od.cover CO
        SET situation3d_geometry = ST_SetSRID( ST_MakePoint(
        ST_X(ST_TRANSLATE(ST_MakePoint(ST_X(CO.situation3d_geometry), ST_Y(CO.situation3d_geometry)), dx, dy )),
        ST_Y(ST_TRANSLATE(ST_MakePoint(ST_X(CO.situation3d_geometry), ST_Y(CO.situation3d_geometry)), dx, dy )),
        ST_Z(CO.situation3d_geometry)), {{srid}} )
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
                ST_Z(ST_PointN(RE.progression3d_geometry, 1))), {{srid}} )
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
                ST_Z(ST_PointN(RE.progression3d_geometry, 1))), {{srid}} )
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



    DROP TRIGGER IF EXISTS vw_tww_wastewater_structure_UPDATE ON tww_app.vw_tww_wastewater_structure;

    CREATE TRIGGER vw_tww_wastewater_structure_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_structure_UPDATE();
    """.format(
        literal_delete_on_ws_change="'DELETE FROM tww_od.%I WHERE obj_id = %L',OLD.ws_type,OLD.obj_id",
        literal_insert_on_ws_change="'INSERT INTO tww_od.%I(obj_id) VALUES (%L)',NEW.ws_type,OLD.obj_id",
        update_co=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="cover",
            table_alias="co",
            prefix="co_",
            indent=6,
            skip_columns=["situation3d_geometry"],
            remap_columns={"cover_shape": "co_shape"},
        ),
        update_sp=update_command(
            connection=connection,
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
            connection=connection,
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
                "fk_main_wastewater_node",
                "_depth",
            ],
            update_values={"fk_main_cover": "OLD.co_obj_id"},
        ),
        update_ma=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="manhole",
            table_alias="ws",
            prefix="ma_",
            remove_pkey=True,
            indent=6,
            skip_columns=["_orientation"],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_ss=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="special_structure",
            table_alias="ss",
            prefix="ss_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_dp=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="discharge_point",
            table_alias="dp",
            prefix="dp_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_ii=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="infiltration_installation",
            table_alias="ii",
            prefix="ii_",
            remove_pkey=True,
            indent=6,
            skip_columns=[],
            remap_columns={"obj_id": "obj_id"},
        ),
        update_wn=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_node",
            table_alias="wn",
            prefix="wn_",
            indent=6,
            skip_columns=[
                "situation3d_geometry",
                "_usage_current",
                "_status",
                "_function_hierarchic",
            ],
        ),
        update_ne=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
            prefix="wn_",
            indent=6,
            skip_columns=[],
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
        insert_vw_cover=insert_command(
            connection=connection,
            table_schema="tww_app",
            table_name="vw_cover",
            table_type="view",
            table_alias="co",
            prefix="co_",
            remove_pkey=False,
            pkey="obj_id",
            indent=10,
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
            returning="obj_id INTO OLD.co_obj_id",
        ),
    )

    update_trigger_sql = psycopg.sql.SQL(update_trigger_sql).format(srid=psycopg.sql.Literal(srid))

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_wastewater_structure_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_structure WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_wastewater_structure_DELETE ON tww_app.vw_tww_wastewater_structure;

    CREATE TRIGGER vw_tww_wastewater_structure_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_wastewater_structure
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_wastewater_structure_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_wastewater_structure ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_structure');
    ALTER VIEW tww_app.vw_tww_wastewater_structure ALTER co_obj_id SET DEFAULT tww_app.generate_oid('tww_od','cover');
    ALTER VIEW tww_app.vw_tww_wastewater_structure ALTER wn_obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_node');
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
        vw_tww_wastewater_structure(
            connection=conn,
            srid=srid,
            extra_definition=extra_definition,
        )
