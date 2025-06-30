#!/usr/bin/env python3
#
# -- View: vw_tww_infiltration_installation

import argparse
import os

import psycopg
import psycopg.sql
from pirogue.utils import insert_command, select_columns, table_parts, update_command
from yaml import safe_load


def vw_tww_infiltration_installation(
    connection: psycopg.Connection, srid: psycopg.sql.Literal, extra_definition: dict = None
):
    """
    Creates tww_infiltration_installation view
    :param connection: a psycopg connection object
    :param srid: EPSG code for geometries
    :param extra_definition: a dictionary for additional read-only columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_infiltration_installation;

    CREATE OR REPLACE VIEW tww_app.vw_tww_infiltration_installation AS
     SELECT
        ws.identifier as identifier

        , ws.fk_owner
        , ws.status

        {extra_cols}

        , {ws_cols}

        , main_co_sp.identifier AS co_identifier
        , main_co_sp.remark AS co_remark
        , main_co_sp.renovation_demand AS co_renovation_demand

        , {main_co_cols}
        , ST_Force2D(COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry))::geometry(Point, {{srid}}) AS situation3d_geometry
        , {ii_columns}

        , {mp_columns}
        , {rb_columns}

        , {wn_cols}
        , {ne_cols}

        , wns._usage_current AS _channel_usage_current
        , wns._function_hierarchic AS _channel_function_hierarchic


      FROM tww_od.infiltration_installation ii
        LEFT JOIN tww_od.wastewater_structure ws ON ii.obj_id = ws.obj_id
        LEFT JOIN tww_od.cover main_co ON main_co.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.structure_part main_co_sp ON main_co_sp.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.mechanical_pretreatment mp ON mp.obj_id = ws.obj_id
        LEFT JOIN tww_od.retention_body rb ON rb.fk_infiltration_installation = ws.obj_id
        LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
        LEFT JOIN tww_od.tww_wastewater_node_symbology wns ON wns.fk_wastewater_node = ws.fk_main_wastewater_node
        {extra_joins};
    """.format(
        extra_cols="\n    ".join(
            [
                select_columns(
                    connection=connection,
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
        mp_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="mechanical_pretreatment",
            table_alias="mp",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            prefix="mp_",
            remap_columns={},
        ),
        rb_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="retention_body",
            table_alias="rb",
            remove_pkey=False,
            indent=4,
            skip_columns=["fk_infiltration_installation"],
            prefix="rb_",
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

    view_sql = psycopg.sql.SQL(view_sql).format(srid=psycopg.sql.Literal(srid))

    cursor.execute(view_sql)

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_infiltration_installation_INSERT()
      RETURNS trigger AS
    $BODY$

    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ws}

    {insert_ii}


    CASE WHEN NOT tww_app.check_all_nulls(NEW,'mp') THEN
    {insert_mp}
    ELSE NULL;
    END CASE;

    CASE WHEN NOT tww_app.check_all_nulls(NEW,'rb') THEN
    {insert_rb}
    ELSE NULL;
    END CASE;

    {insert_wn}

      UPDATE tww_od.wastewater_structure
        SET fk_main_wastewater_node = NEW.wn_obj_id
        WHERE obj_id = NEW.obj_id;

    CASE WHEN NOT tww_app.check_all_nulls(NEW,'co') THEN
    {insert_vw_cover}

      UPDATE tww_od.wastewater_structure
        SET fk_main_cover = NEW.co_obj_id
        WHERE obj_id = NEW.obj_id;
    ELSE NULL;
    END CASE;

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_infiltration_installation_INSERT ON tww_app.vw_tww_infiltration_installation;

    CREATE TRIGGER vw_tww_infiltration_installation_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_infiltration_installation
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_infiltration_installation_INSERT();
    """.format(
        insert_ws=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            remove_pkey=False,
            indent=2,
            skip_columns=[
                "fk_main_cover",
                "fk_main_wastewater_node",
                "detail_geometry3d_geometry",
            ],
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
        insert_mp=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="mechanical_pretreatment",
            table_alias="mp",
            prefix="mp_",
            remove_pkey=False,
            indent=6,
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.mp_identifier,''), NEW.identifier)",
                "last_modification": "NOW()",
                "fk_provider": "COALESCE(NULLIF(NEW.mp_fk_provider,''), NEW.fk_provider)",
                "fk_dataowner": "COALESCE(NULLIF(NEW.mp_fk_dataowner,''), NEW.fk_dataowner)",
                "fk_wastewater_structure": "NEW.obj_id",
            },
        ),
        insert_rb=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="retention_body",
            table_alias="rb",
            prefix="rb_",
            remove_pkey=False,
            indent=6,
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.rb_identifier,''), NEW.identifier)",
                "last_modification": "NOW()",
                "fk_provider": "COALESCE(NULLIF(NEW.rb_fk_provider,''), NEW.fk_provider)",
                "fk_dataowner": "COALESCE(NULLIF(NEW.rb_fk_dataowner,''), NEW.fk_dataowner)",
                "fk_infiltration_installation": "NEW.obj_id",
            },
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
            insert_values={
                "identifier": "COALESCE(NULLIF(NEW.wn_identifier,''), NEW.identifier)",
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )",
                "last_modification": "NOW()",
                "fk_provider": "COALESCE(NULLIF(NEW.wn_fk_provider,''), NEW.fk_provider)",
                "fk_dataowner": "COALESCE(NULLIF(NEW.wn_fk_dataowner,''), NEW.fk_dataowner)",
                "fk_wastewater_structure": "NEW.obj_id",
            },
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
        ),
    )

    trigger_insert_sql = psycopg.sql.SQL(trigger_insert_sql).format(srid=psycopg.sql.Literal(srid))
    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_infiltration_installation_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      dx float;
      dy float;
    BEGIN
      {update_ii}
      {update_co}
      IF NOT FOUND THEN
        CASE WHEN NOT tww_app.check_all_nulls(NEW,'co') THEN -- no cover entries
          {insert_vw_cover}
        ELSE
          PERFORM pg_notify('vw_tww_ws_no_cover', format('Wastewater Structure %s: no cover created. If you want to add a cover please fill in at least one cover attribute value.',NEW.identifier));
        END CASE;
      END IF;
      {update_sp}
      {update_ws}
      {update_wn}
      {update_ne}


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



    DROP TRIGGER IF EXISTS vw_tww_infiltration_installation_UPDATE ON tww_app.vw_tww_infiltration_installation;

    CREATE TRIGGER vw_tww_infiltration_installation_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_infiltration_installation
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_infiltration_installation_UPDATE();
    """.format(
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
                "fk_main_cover",
                "fk_main_wastewater_node",
                "_depth",
            ],
            update_values={},
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
                "situation3d_geometry": "ST_SetSRID(ST_MakePoint(ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), 'nan'), {srid} )",
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
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_infiltration_installation_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.wastewater_structure WHERE obj_id = OLD.obj_id;
      DELETE FROM tww_od.mechanical_pretreatment WHERE fk_wastewater_structure = OLD.obj_id;
      DELETE FROM tww_od.retention_body WHERE fk_infiltration_installation = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_infiltration_installation_DELETE ON tww_app.vw_tww_infiltration_installation;

    CREATE TRIGGER vw_tww_infiltration_installation_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_infiltration_installation
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_infiltration_installation_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_infiltration_installation ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_structure');
    ALTER VIEW tww_app.vw_tww_infiltration_installation ALTER co_obj_id SET DEFAULT tww_app.generate_oid('tww_od','cover');
    ALTER VIEW tww_app.vw_tww_infiltration_installation ALTER wn_obj_id SET DEFAULT tww_app.generate_oid('tww_od','wastewater_node');
    ALTER VIEW tww_app.vw_tww_infiltration_installation ALTER mp_obj_id SET DEFAULT tww_app.generate_oid('tww_od','mechanical_pretreatment');
    ALTER VIEW tww_app.vw_tww_infiltration_installation ALTER rb_obj_id SET DEFAULT tww_app.generate_oid('tww_od','retention_body');
    """
    cursor.execute(extras)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--srid", help="EPSG code for SRID", default=2056)
    parser.add_argument(
        "-e",
        "--extra-definition",
        help="YAML file path for extra additions to the view",
    )
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    srid = psycopg.sql.Literal(args.srid)
    extra_definition = safe_load(open(args.extra_definition)) if args.extra_definition else {}
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_infiltration_installation(
            connection=conn, srid=srid, extra_definition=extra_definition
        )
