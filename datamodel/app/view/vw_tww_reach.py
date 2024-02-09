#!/usr/bin/env python3
#
# -- View: vw_tww_wastewater_structure

import argparse
import os

import psycopg2
from pirogue.utils import insert_command, select_columns, table_parts, update_command
from yaml import safe_load


def vw_tww_reach(pg_service: str = None, extra_definition: dict = None):
    """
    Creates tww_reach view
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service
    extra_definition = extra_definition or {}

    conn = psycopg2.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_reach;

    CREATE OR REPLACE VIEW tww_app.vw_tww_reach AS

    SELECT
        re.obj_id,
        re.clear_height,
        re.material,
        ch.usage_current AS ch_usage_current,
        ch.function_hierarchic AS ch_function_hierarchic,
        ws.status AS ws_status,
        ws.fk_owner AS ws_fk_owner,
        ch.function_hydraulic AS ch_function_hydraulic,
        CASE
          WHEN pp.height_width_ratio IS NOT NULL THEN round(re.clear_height::numeric / pp.height_width_ratio)::smallint
          ELSE clear_height
        END AS width,
        CASE
          WHEN rp_from.level > 0 AND rp_to.level > 0 THEN round((rp_from.level - rp_to.level)/ST_LENGTH(re.progression3d_geometry)::numeric*1000,1)
          ELSE NULL
        END AS _slope_per_mill
        , {extra_cols}
        {re_cols}
        , {ne_cols}
        , {ch_cols}
        , {ws_cols}
        , {rp_from_cols}
        , {rp_to_cols}
      FROM tww_od.reach re
         LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = re.obj_id
         LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id = re.fk_reach_point_from
         LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id = re.fk_reach_point_to
         LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id
         LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
         LEFT JOIN tww_od.pipe_profile pp ON re.fk_pipe_profile = pp.obj_id
         {extra_joins};
    """.format(
        extra_cols="\n    , ".join(
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
                for table_def in extra_definition.get("joins", {}).values()
            ]
        ),
        re_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach",
            table_alias="re",
            remove_pkey=True,
            indent=4,
            skip_columns=[
                "clear_height",
                "material",
                "fk_reach_point_from",
                "fk_reach_point_to",
            ],
        ),
        ne_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            table_alias="ne",
            remove_pkey=True,
            indent=4,
            skip_columns=["fk_wastewater_structure"],
        ),
        ch_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="channel",
            table_alias="ch",
            prefix="ch_",
            remove_pkey=True,
            indent=4,
            skip_columns=["usage_current", "function_hierarchic", "function_hydraulic"],
        ),
        ws_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            table_alias="ws",
            prefix="ws_",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "detail_geometry3d_geometry",
                "status",
                "fk_owner",
                "fk_dataowner",
                "fk_provider",
                "_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
        rp_from_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            table_alias="rp_from",
            prefix="rp_from_",
            remove_pkey=False,
            indent=4,
            skip_columns=["situation3d_geometry"],
        ),
        rp_to_cols=select_columns(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            table_alias="rp_to",
            prefix="rp_to_",
            remove_pkey=False,
            indent=4,
            skip_columns=["situation3d_geometry"],
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
    -- REACH INSERT
    -- Function: vw_tww_reach_insert()

    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_reach_insert()
      RETURNS trigger AS
    $BODY$
    BEGIN
      -- Synchronize geometry with level
      NEW.progression3d_geometry = ST_ForceCurve(ST_SetPoint(ST_CurveToLine(NEW.progression3d_geometry),0,
      ST_MakePoint(ST_X(ST_StartPoint(NEW.progression3d_geometry)),ST_Y(ST_StartPoint(NEW.progression3d_geometry)),COALESCE(NEW.rp_from_level,'NaN'))));

      NEW.progression3d_geometry = ST_ForceCurve(ST_SetPoint(ST_CurveToLine(NEW.progression3d_geometry),ST_NumPoints(NEW.progression3d_geometry)-1,
      ST_MakePoint(ST_X(ST_EndPoint(NEW.progression3d_geometry)),ST_Y(ST_EndPoint(NEW.progression3d_geometry)),COALESCE(NEW.rp_to_level,'NaN'))));

      {rp_from}
      {rp_to}
      {ws}
      {ch}
      {ne}
      {re}

      RETURN NEW;
    END; $BODY$
      LANGUAGE plpgsql VOLATILE
      COST 100;

    CREATE TRIGGER vw_tww_reach_insert INSTEAD OF INSERT ON tww_app.vw_tww_reach
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_reach_insert();
    """.format(
        rp_from=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            prefix="rp_from_",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
            coalesce_pkey_default=True,
            insert_values={"situation3d_geometry": "ST_StartPoint(NEW.progression3d_geometry)"},
            returning="obj_id INTO NEW.rp_from_obj_id",
        ),
        rp_to=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            prefix="rp_to_",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
            coalesce_pkey_default=True,
            insert_values={"situation3d_geometry": "ST_EndPoint(NEW.progression3d_geometry)"},
            returning="obj_id INTO NEW.rp_to_obj_id",
        ),
        ws=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            prefix="ws_",
            remove_pkey=False,
            indent=2,
            skip_columns=[
                "detail_geometry3d_geometry",
                "fk_dataowner",
                "fk_provider",
                "_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
        ch=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="channel",
            prefix="ch_",
            remove_pkey=False,
            indent=2,
            remap_columns={"obj_id": "ws_obj_id"},
            skip_columns=[],
        ),
        ne=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            remove_pkey=False,
            indent=2,
            remap_columns={"fk_wastewater_structure": "ws_obj_id"},
        ),
        re=insert_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach",
            remove_pkey=False,
            indent=2,
            insert_values={
                "fk_reach_point_from": "NEW.rp_from_obj_id",
                "fk_reach_point_to": "NEW.rp_to_obj_id",
            },
        ),
    )
    cursor.execute(trigger_insert_sql)

    trigger_update_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_reach_update()
      RETURNS trigger AS
    $BODY$
    BEGIN

      -- Synchronize geometry with level
      IF NEW.rp_from_level <> OLD.rp_from_level OR (NEW.rp_from_level IS NULL AND OLD.rp_from_level IS NOT NULL) OR (NEW.rp_from_level IS NOT NULL AND OLD.rp_from_level IS NULL) THEN
        NEW.progression3d_geometry = ST_ForceCurve(ST_SetPoint(ST_CurveToLine(NEW.progression3d_geometry),0,
        ST_MakePoint(ST_X(ST_StartPoint(NEW.progression3d_geometry)),ST_Y(ST_StartPoint(NEW.progression3d_geometry)),COALESCE(NEW.rp_from_level,'NaN'))));
      ELSE
        IF ST_Z(ST_StartPoint(NEW.progression3d_geometry)) <> ST_Z(ST_StartPoint(OLD.progression3d_geometry)) THEN
          NEW.rp_from_level = NULLIF(ST_Z(ST_StartPoint(NEW.progression3d_geometry)),'NaN');
        END IF;
      END IF;

      -- Synchronize geometry with level
      IF NEW.rp_to_level <> OLD.rp_to_level OR (NEW.rp_to_level IS NULL AND OLD.rp_to_level IS NOT NULL) OR (NEW.rp_to_level IS NOT NULL AND OLD.rp_to_level IS NULL) THEN
        NEW.progression3d_geometry = ST_ForceCurve(ST_SetPoint(ST_CurveToLine(NEW.progression3d_geometry),ST_NumPoints(NEW.progression3d_geometry)-1,
        ST_MakePoint(ST_X(ST_EndPoint(NEW.progression3d_geometry)),ST_Y(ST_EndPoint(NEW.progression3d_geometry)),COALESCE(NEW.rp_to_level,'NaN'))));
      ELSE
        IF ST_Z(ST_EndPoint(NEW.progression3d_geometry)) <> ST_Z(ST_EndPoint(OLD.progression3d_geometry)) THEN
          NEW.rp_to_level = NULLIF(ST_Z(ST_EndPoint(NEW.progression3d_geometry)),'NaN');
        END IF;
      END IF;

      {rp_from}

      {rp_to}

      {ch}

      {ws}

      {ne}

      {re}


      RETURN NEW;
    END; $BODY$
      LANGUAGE plpgsql VOLATILE;
    """.format(
        rp_from=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            prefix="rp_from_",
            remove_pkey=True,
            indent=6,
            update_values={"situation3d_geometry": "ST_StartPoint(NEW.progression3d_geometry)"},
        ),
        rp_to=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach_point",
            prefix="rp_to_",
            remove_pkey=True,
            indent=6,
            update_values={"situation3d_geometry": "ST_EndPoint(NEW.progression3d_geometry)"},
        ),
        ch=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="channel",
            prefix="ch_",
            remove_pkey=True,
            indent=6,
            remap_columns={"obj_id": "ws_obj_id"},
        ),
        ws=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_structure",
            prefix="ws_",
            remove_pkey=True,
            indent=6,
            remap_columns={
                "fk_dataowner": "fk_dataowner",
                "fk_provider": "fk_provider",
                "last_modification": "last_modification",
            },
            skip_columns=[
                "detail_geometry3d_geometry",
                "_label",
                "_depth",
                "fk_main_cover",
            ],
        ),
        ne=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="wastewater_networkelement",
            remove_pkey=True,
            indent=6,
            remap_columns={"fk_wastewater_structure": "ws_obj_id"},
        ),
        re=update_command(
            pg_cur=cursor,
            table_schema="tww_od",
            table_name="reach",
            remove_pkey=True,
            indent=6,
            skip_columns=["fk_reach_point_to", "fk_reach_point_from"],
        ),
    )
    cursor.execute(trigger_update_sql)

    trigger_delete_sql = """
    CREATE TRIGGER vw_tww_reach_update
      INSTEAD OF UPDATE
      ON tww_app.vw_tww_reach
      FOR EACH ROW
      EXECUTE PROCEDURE tww_app.ft_vw_tww_reach_update();


    -- REACH DELETE
    -- Rule: vw_tww_reach_delete()

    CREATE OR REPLACE RULE vw_tww_reach_delete AS ON DELETE TO tww_app.vw_tww_reach DO INSTEAD (
      DELETE FROM tww_od.reach WHERE obj_id = OLD.obj_id;
    );
    """
    cursor.execute(trigger_delete_sql)

    extras = """
    ALTER VIEW tww_app.vw_tww_reach ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach');

    ALTER VIEW tww_app.vw_tww_reach ALTER rp_from_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach_point');
    ALTER VIEW tww_app.vw_tww_reach ALTER rp_to_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach_point');
    ALTER VIEW tww_app.vw_tww_reach ALTER ws_obj_id SET DEFAULT tww_sys.generate_oid('tww_od','channel');
    """
    cursor.execute(extras)

    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-e",
        "--extra-definition",
        help="YAML file path for extra additions to the view",
    )
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    extra_definition = safe_load(open(args.extra_definition)) if args.extra_definition else {}
    vw_tww_reach(pg_service=pg_service, extra_definition=extra_definition)
