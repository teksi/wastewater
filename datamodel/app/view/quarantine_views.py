#!/usr/bin/env python3
#
# -- View: quarantine views

import argparse
import os

import psycopg
from pirogue.information_schema import columns
from pirogue.utils import insert_command, select_columns, update_command
from pum.exceptions import PumHookError


def vw_tww_import_manhole(connection: psycopg.Connection):
    """
    Creates vw_tww_import_manhole view
    :param connection: a psycopg connection object
    """

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_import_manhole;

    CREATE OR REPLACE VIEW tww_app.vw_tww_import_manhole AS
  SELECT
        ws.uuidoid
        , CASE
          WHEN ma.obj_id IS NOT NULL THEN 'manhole'
          WHEN ss.obj_id IS NOT NULL THEN 'special_structure'
          ELSE 'unknown'
        END AS ws_type
        , ws.obj_id as ws_obj_id
        , ws._depth as ws__depth
        , ws.accessibility as ws_accessibility
        , ws.identifier as ws_identifier
        , ws.remark as ws_remark
        , ws.status as ws_status
        , wn.obj_id as wn_obj_id
        , wn.bottom_level as wn_bottom_level
        , wn._function_hierarchic
        , wn._usage_current

        , {ma_columns}
        , {ss_columns}
        , main_co.level - ss.upper_elevation as ss__upper_elevation_depth,
        , {main_co_cols}
        , main_co_sp.renovation_demand as co_renovation_demand
        , main_co_sp.remark as co_remark


        , {aa_cols}
        , aa.renovation_demand as aa_renovation_demand
        , aa.remark as aa_remark

        , {be_cols}
        , be.renovation_demand as be_renovation_demand
        , be.remark as be_remark

        , {df_cols}
        , df.renovation_demand as df_renovation_demand
        , df.remark as df_remark

        , {dd_cols}
        , dd.renovation_demand as dd_renovation_demand
        , dd.remark as dd_remark
        , (q.uuidoid IS NOT NULL) AS in_quarantine


        FROM tww_od.wastewater_structure ws
        LEFT JOIN tww_od.cover main_co ON main_co.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.structure_part main_co_sp ON main_co_sp.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.manhole ma ON ma.obj_id = ws.obj_id
        LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
        INNER JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = ws.fk_main_wastewater_node
        INNER JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node

        LEFT JOIN (
          SELECT cls.*
          , sp.fk_wastewater_structure
          , sp.renovation_demand
          , sp.remark
          FROM tww_od.access_aid cls
          INNER JOIN tww_od.structure_part sp on sp.obj_id=cls.obj_id
        ) aa ON aa.fk_wastewater_structure = ws.obj_id
        LEFT JOIN(
          SELECT cls.*
          , sp.fk_wastewater_structure
          , sp.renovation_demand
          , sp.remark
          FROM tww_od.benching cls
          INNER JOIN tww_od.structure_part sp on sp.obj_id=cls.obj_id
        ) be ON be.fk_wastewater_structure = ws.obj_id
        LEFT JOIN (
          SELECT cls.*
          , sp.fk_wastewater_structure
          , sp.renovation_demand
          , sp.remark
          FROM tww_od.dryweather_flume cls
          INNER JOIN tww_od.structure_part sp on sp.obj_id=cls.obj_id
        ) df ON df.fk_wastewater_structure = ws.obj_id
        LEFT JOIN (
          SELECT cls.*
          , sp.fk_wastewater_structure
          , sp.renovation_demand
          , sp.remark
          FROM tww_od.dryweather_downspout cls
          INNER JOIN tww_od.structure_part sp on sp.obj_id=cls.obj_id
        ) dd ON dd.fk_wastewater_structure = ws.obj_id
        LEFT JOIN (
            SELECT obj_id
            , id
            , tww_deleted
            FROM tww_od.import_ws_quarantine
            ) q ON q.obj_id = ws.obj_id
        WHERE ma.obj_id IS NOT NULL or ss.obj_id IS NOT NULL AND q.tww_deleted IS NOT TRUE;
    """.format(
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
            skip_columns=[],
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
            skip_columns=[],
            prefix="ss_",
            remap_columns={},
        ),
        aa_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="access_aid",
            table_alias="aa",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            prefix="aa_",
            remap_columns={},
        ),
        be_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="benching",
            table_alias="be",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            prefix="be_",
            remap_columns={},
        ),
        dd_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="dryweather_downspout",
            table_alias="dd",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            prefix="dd_",
            remap_columns={},
        ),
        df_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="dryweather_flume",
            table_alias="df",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
            prefix="df_",
            remap_columns={},
        ),
    )

    view_sql = psycopg.sql.SQL(view_sql)

    try:
        cursor.execute(view_sql)
    except psycopg.errors.SyntaxError as e:
        raise PumHookError(f"Error creating view with code: {view_sql}: {e}")

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_import_manhole_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {insert_wsq}
      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_import_manhole_INSERT ON tww_app.vw_tww_import_manhole;

    CREATE TRIGGER vw_tww_import_manhole_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_import_manhole
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vvw_tww_import_manhole_INSERT();
    """.format(
        insert_wsq=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_ws_quarantine",
            remove_pkey=False,
            indent=2,
            skip_columns=["tww_is_okay", "tww_deleted"],
        ),
    )

    trigger_insert_sql = psycopg.sql.SQL(trigger_insert_sql)

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_import_manhole_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      CASE WHEN NEW.in_quarantine THEN
        {update_wsq}
      ELSE
        {insert_wsq}
      END CASE;
      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;


    DROP TRIGGER IF EXISTS vw_tww_import_manhole_UPDATE ON tww_app.vw_tww_import_manhole;

    CREATE TRIGGER vw_tww_import_manhole_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_import_manhole
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_import_manhole_UPDATE();
    """.format(
        insert_wsq=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_ws_quarantine",
            remove_pkey=False,
            indent=6,
            skip_columns=["tww_is_okay", "tww_deleted"],
        ),
        update_wsq=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_ws_quarantine",
            remove_pkey=False,
            indent=6,
            skip_columns=["tww_is_okay", "tww_deleted"],
        ),
    )

    update_trigger_sql = psycopg.sql.SQL(update_trigger_sql)

    cursor.execute(update_trigger_sql)

    defaults = """
    ALTER VIEW tww_app.vw_tww_import_manhole ALTER id SET DEFAULT uuid_generate_v4();
    """
    cursor.execute(defaults)


def vw_tww_import_reach_point(connection: psycopg.Connection):
    """
    Creates vw_tww_import_reach_point view
    :param connection: a psycopg connection object
    """

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_import_reach_point;

    CREATE OR REPLACE VIEW tww_app.vw_tww_import_reach_point AS
    WITH outlets AS (
    SELECT
        ne.fk_wastewater_structure ws,
        rp.obj_id,
        False AS tww_is_inflow,
        ROW_NUMBER() OVER(
            PARTITION BY ne.fk_wastewater_structure
            ORDER BY
                fh.tww_symbology_order,
                uc.tww_symbology_order,
                ST_Azimuth(rp.situation3d_geometry, ST_PointN(re_from.progression3d_geometry, 2)) ASC
        ) AS idx,
        degrees(ST_Azimuth(rp.situation3d_geometry, ST_PointN(re_from.progression3d_geometry, 2))) AS azimuth
    FROM tww_od.reach_point rp
    LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
    INNER JOIN tww_od.reach re_from ON rp.obj_id = re_from.fk_reach_point_from
    LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id::text = re_from.obj_id::text
    LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure::text = ws.obj_id::text
    LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
    LEFT JOIN tww_vl.channel_function_hierarchic fh ON ch.function_hierarchic = fh.code
    LEFT JOIN tww_vl.channel_usage_current uc ON ch.usage_current = uc.code
    WHERE NOT EXISTS (SELECT 1 FROM tww_od.channel ch_1 WHERE ch_1.obj_id = ne.fk_wastewater_structure)
    AND ne.fk_wastewater_structure IS NOT NULL
), rp_azi AS(
SELECT
    rp.obj_id,
    MOD(FLOOR((degrees(ST_Azimuth(rp.situation3d_geometry,
    ST_PointN(re_to.progression3d_geometry, -2)))
    - outs.azimuth + 375) / 30)::integer, 12) + 1 AS tww_position_in_structure
FROM tww_od.reach_point rp
LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
INNER JOIN tww_od.reach re_to ON rp.obj_id = re_to.fk_reach_point_to
INNER JOIN outlets outs ON outs.ws = ne.fk_wastewater_structure AND outs.idx = 1

UNION ALL

SELECT
    obj_id,
    12 AS tww_position_in_structure
FROM outlets
WHERE idx = 1

UNION ALL

SELECT
    secondary.obj_id,
    MOD(FLOOR((secondary.azimuth - main.azimuth + 375) / 30)::integer, 12) + 1 AS tww_position_in_structure
FROM outlets secondary
INNER JOIN outlets main ON main.ws = secondary.ws AND main.idx = 1
WHERE secondary.idx > 1)
  SELECT
          {rp_columns}
        , NULL::smallint as tww_level_measurement_kind
        , co.level - rp.level as co_depth
        , ss.upper_elevation - rp.level as co_depth
        , ws.status as ws_status
        , CASE
          WHEN re_from.obj_id IS NOT NULL THEN False
          WHEN re_to.obj_id IS NOT NULL THEN True
          ELSE NULL
          END AS tww_is_inflow
        , coalesce(q.tww_position_in_structure,rp_azi.tww_position_in_structure) as tww_position_in_structure
        , coalesce(re_from.material,re_to.material) as re_material
        , coalesce(re_from.clear_height,re_to.clear_height) as re_clear_height
        , q_ws.uuidoid as fk_import_ws_quarantine
        , NULL::boolean as tww_is_okay
        , (q.uuidoid IS NOT NULL) AS in_quarantine

        FROM tww_od.reach_point rp
        INNER JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
        INNER JOIN tww_od.wastewater_node wn ON wn.obj_id = ne.obj_id
        INNER JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
        LEFT JOIN tww_od.reach re_from on re.fk_reach_point_from =rp.obj_id
        LEFT JOIN tww_od.reach re_to on re.fk_reach_point_to =rp.obj_id
        LEFT JOIN tww_od.cover co ON co.obj_id = ws.fk_main_cover
        LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
        LEFT JOIN (
            SELECT obj_id
            , id
            FROM tww_od.import_reach_point_quarantine
            ) q ON q.obj_id = rp.obj_id
        LEFT JOIN (
            SELECT obj_id
            , id
            , tww_deleted
            FROM tww_od.import_ws_quarantine
            ) q_ws ON q_ws.obj_id = ws.obj_id
        WHERE q_ws.tww_deleted IS NOT TRUE;
    """.format(
        rp_columns=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="reach_point",
            table_alias="rp",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "situation3d_geometry",
                "last_modification",
                "fk_dataowner",
                "fk_provider",
                "fk_wastewater_networkelement",
            ],
            remap_columns={"cover_shape": "co_shape"},
            columns_on_top=["uuidoid"],
            columns_at_end=["obj_id"],
        )
    )

    view_sql = psycopg.sql.SQL(view_sql)

    try:
        cursor.execute(view_sql)
    except psycopg.errors.SyntaxError as e:
        raise PumHookError(f"Error creating view with code: {view_sql}: {e}")

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_import_reach_point_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {insert_rpq}
      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_import_reach_point_INSERT ON tww_app.vw_tww_import_reach_point;

    CREATE TRIGGER vw_tww_import_reach_point_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_import_reach_point
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vvw_tww_import_reach_point_INSERT();
    """.format(
        insert_rpq=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=False,
            indent=2,
            skip_columns=["tww_is_okay"],
        ),
    )

    trigger_insert_sql = psycopg.sql.SQL(trigger_insert_sql)

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_import_reach_point_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      CASE WHEN NEW.in_quarantine THEN
        {update_rpq}
      ELSE
        {insert_rpq}
      END CASE;
      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;


    DROP TRIGGER IF EXISTS vw_tww_import_reach_point_UPDATE ON tww_app.vw_tww_import_reach_point;

    CREATE TRIGGER vw_tww_import_reach_point_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_import_reach_point
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_import_reach_point_UPDATE();
    """.format(
        insert_rpq=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=False,
            indent=6,
            skip_columns=["tww_is_okay"],
        ),
        update_rpq=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=False,
            indent=6,
            skip_columns=["tww_is_okay"],
        ),
    )

    update_trigger_sql = psycopg.sql.SQL(update_trigger_sql)

    cursor.execute(update_trigger_sql)

    defaults = """
    ALTER VIEW tww_app.vw_tww_import_reach_point ALTER id SET DEFAULT uuid_generate_v4();
    """
    cursor.execute(defaults)


def tww_import_logic(connection: psycopg.Connection):

    cursor = connection.cursor()

    wsq_skip_cols = [
        "tww_is_okay",
        "tww_deleted",
        "aa_renovation_demand",
        "aa_remark",
        "be_renovation_demand",
        "be_remark",
        "df_renovation_demand",
        "df_remark",
        "dd_renovation_demand",
        "dd_remark",
        "in_quarantine",
    ]

    # List of tables to fetch columns from
    sp_tables = [
        "access_aid",
        "benching",
        "dryweather_flume",
        "dryweather_downspout",
    ]

    for table in sp_tables:
        wsq_skip_cols.extend(
            columns(
                connection=connection,
                table_schema="tww_od",
                table_name=table,
            )
        )

    rp_skip_cols = [
        "tww_level_measurement_kind",
        "co_depth",
        "ss_upper_elevation_depth",
        "ws_status",
        "tww_is_inflow",
        "tww_position_in_structure",
        "fk_import_ws_quarantine",
        "re_material",
        "re_clear_height",
        "tww_is_okay",
    ]

    re_skip_cols = [
        "tww_delta_measurement",
        "fk_import_rp_quarantine_from",
        "fk_import_rp_quarantine_to",
        "tww_is_okay",
        "tww_deleted",
    ]

    rp_lvl_sql = """
    CREATE OR REPLACE FUNCTION tww_app.calculate_quarantine_rp_level(tww_level_measurement_kind smallint,
    rp_co_depth numeric(7,3),
    rp_level numeric(7,3),
    co_level numeric(7,3),
    ss_upper_elevation numeric(7,3),
    rp_ss_upper_elevation_depth numeric(7,3))
    RETURNS numeric(7,3)
    LANGUAGE plpgsql
    AS $$
    DECLARE calc_lvl numeric(7,3);
    BEGIN
        -- calculate levels
        CASE WHEN tww_level_measurement_kind  = 1 THEN
            calc_lvl :=  NULLIF(co_level,0) - NULLIF(rp_co_depth,0);
        WHEN tww_level_measurement_kind  = 2 THEN
            calc_lvl :=  NULLIF(ss_upper_elevation,0) - NULLIF(rp_ss_upper_elevation_depth,0);
        ELSE
            calc_lvl = rp_level;
        END CASE;
        RETURN calc_lvl;
    END;
    $$;
    """
    rp_lvl_sql = psycopg.sql.SQL(rp_lvl_sql)
    cursor.execute(rp_lvl_sql)

    autoupdate_sql = """
        CREATE OR REPLACE FUNCTION tww_app.try_quarantine_rp_insert()
        RETURNS trigger
        LANGUAGE plpgsql
        AS $$
        DECLARE
            ws_record RECORD;
            _rp_level  numeric(7,3);
            new_in_outlets integer;
            old_in_outlets integer;
        BEGIN
            BEGIN
                SELECT * FROM tww_od.import_ws_quarantine ws
                INTO ws_record WHERE ws.uuidoid = NEW.fk_import_ws_quarantine;

                CASE WHEN NEW.tww_is_inflow THEN
                    SELECT COUNT(rp.obj_id) INTO old_in_outlets
                    FROM tww_od.wastewater_networkelement ne
                    INNER JOIN tww_od.reach_point rp on rp.fk_wastewater_networkelement =ne.obj_id
                    INNER JOIN tww_od.reach re on re.fk_reach_point_to = rp.obj_id
                    WHERE ne.fk_wastewater_structure = ws_record.ws_obj_id;
                WHEN NOT NEW.tww_is_inflow THEN
                    SELECT COUNT(rp.obj_id) INTO old_in_outlets
                    FROM tww_od.wastewater_networkelement ne
                    INNER JOIN tww_od.reach_point rp on rp.fk_wastewater_networkelement =ne.obj_id
                    INNER JOIN tww_od.reach re on re.fk_reach_point_from = rp.obj_id
                    WHERE ne.fk_wastewater_structure = ws_record.ws_obj_id;
                ELSE NULL;
                END CASE;

                SELECT COUNT(rp.obj_id) INTO new_in_outlets
                FROM tww_od.import_ws_quarantine ws
                INNER JOIN tww_od.import_reach_point_quarantine rp on rp.fk_import_ws_quarantine =ws.uuidoid
                WHERE ws.uuidoid = NEW.fk_import_ws_quarantine and rp.tww_is_inflow = NEW.tww_is_inflow;

                IF old_in_outlets = 1 AND new_in_outlets = 1 AND ws_record.obj_id IS NOT NULL THEN--auto-assignment possible
                    UPDATE tww_od.reach
                    SET material = NEW.re_material,
                    clear_height = NEW.re_clear_height
                    WHERE obj_id = ( SELECT re.obj_id
                    FROM tww_od.reach re
                    LEFT JOIN tww_od.reach_point rp ON (rp.obj_id = re.fk_reach_point_to AND NEW.tww_is_inflow)
                      OR (rp.obj_id = re.fk_reach_point_from AND NOT NEW.tww_is_inflow)
                    LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
                    LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
                    WHERE ws.obj_id = ws_record.obj_id);

                    {update_rp}
                    RETURN NULL;
                ELSE
                    RAISE NOTICE 'no automatic mapping for tww_od.import_reach_point_quarantine for id %, manual editing needed', NEW.uuidoid;
                    RETURN NEW;
                END IF;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE NOTICE 'No record found in tww_od.import_ws_quarantine for id %, manual editing needed', NEW.fk_import_ws_quarantine;
                        RETURN NEW;
            END;
        END;
        $$;
            """.format(
        update_rp=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=rp_skip_cols,
            comment_skipped=False,
            update_values={
                "level": """tww_app.calculate_quarantine_rp_level(
                            rp_record.tww_level_measurement_kind,
                            rp_record.rp_co_depth,
                            rp_record.rp_level,
                            ws_record.co_level,
                            ws_record.ss_upper_elevation,
                            rp_record.ss_upper_elevation_depth)""",
            },
            where_clause=""" obj_id = ( SELECT rp.obj_id
                    FROM tww_od.reach re
                    LEFT JOIN tww_od.reach_point rp ON (rp.obj_id = re.fk_reach_point_to AND NEW.tww_is_inflow)
                      OR (rp.obj_id = re.fk_reach_point_from AND NOT NEW.tww_is_inflow)
                    LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
                    LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
                    WHERE ws.obj_id = NEW.obj_id )""",
        ).replace("tww_od.import_reach_point_quarantine", "tww_od.reach_point"),
    )
    autoupdate_sql = psycopg.sql.SQL(autoupdate_sql)
    cursor.execute(autoupdate_sql)

    structure_part_sql = """
    CREATE OR REPLACE FUNCTION tww_app.set_structure_parts_from_quarantine(
    ws_row tww_od.import_ws_quarantine
    )
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
    DECLARE
        has_data BOOLEAN;
    BEGIN
        -- Access Aid
        IF ws_row.aa_obj_id IS NOT NULL THEN
            IF EXISTS (
                SELECT 1 FROM tww_app.access_aid
                WHERE fk_wastewater_structure = ws_row.ws_obj_id
            ) THEN
                -- Update existing record
                UPDATE tww_app.access_aid
                SET
                    renovation_demand = ws_row.aa_renovation_demand,
                    remark = ws_row.aa_remark,
                    kind = ws_row.aa_kind
                WHERE fk_wastewater_structure = ws_row.ws_obj_id;
            ELSE
                -- Check if any attribute is not NULL
                has_data := (ws_row.aa_renovation_demand IS NOT NULL)
                        OR (ws_row.aa_remark IS NOT NULL)
                        OR (ws_row.aa_kind IS NOT NULL);
                IF has_data THEN
                    -- Insert new record
                    INSERT INTO tww_app.access_aid (
                        obj_id,
                        fk_wastewater_structure,
                        renovation_demand,
                        remark,
                        kind
                    ) VALUES (
                        ws_row.aa_obj_id,
                        ws_row.ws_obj_id,
                        ws_row.aa_renovation_demand,
                        ws_row.aa_remark,
                        ws_row.aa_kind
                    );
                END IF;
            END IF;
        END IF;

        -- Benching
        IF ws_row.be_obj_id IS NOT NULL THEN
            IF EXISTS (
                SELECT 1 FROM tww_app.vw_benching
                WHERE fk_wastewater_structure = ws_row.ws_obj_id
            ) THEN
                -- Update existing record
                UPDATE tww_app.vw_benching
                SET
                    kind = ws_row.be_kind,
                    renovation_demand = ws_row.be_renovation_demand,
                    remark = ws_row.be_remark
                WHERE fk_wastewater_structure = ws_row.ws_obj_id;
            ELSE
                -- Check if any attribute is not NULL
                has_data := (ws_row.be_kind IS NOT NULL)
                        OR (ws_row.be_renovation_demand IS NOT NULL)
                        OR (ws_row.be_remark IS NOT NULL);
                IF has_data THEN
                    -- Insert new record
                    INSERT INTO tww_app.vw_benching (
                        obj_id,
                        fk_wastewater_structure,
                        kind,
                        renovation_demand,
                        remark
                    ) VALUES (
                        ws_row.be_obj_id,
                        ws_row.ws_obj_id,
                        ws_row.be_kind,
                        ws_row.be_renovation_demand,
                        ws_row.be_remark
                    );
                END IF;
            END IF;
        END IF;

        -- Dryweather Flume
        IF ws_row.df_obj_id IS NOT NULL THEN
            IF EXISTS (
                SELECT 1 FROM tww_app.vw_dryweather_flume
                WHERE fk_wastewater_structure = ws_row.ws_obj_id
            ) THEN
                -- Update existing record
                UPDATE tww_app.vw_dryweather_flume
                SET
                    material = ws_row.df_material,
                    renovation_demand = ws_row.df_renovation_demand,
                    remark = ws_row.df_remark
                WHERE fk_wastewater_structure = ws_row.ws_obj_id;
            ELSE
                -- Check if any attribute is not NULL
                has_data := (ws_row.df_material IS NOT NULL)
                        OR (ws_row.df_renovation_demand IS NOT NULL)
                        OR (ws_row.df_remark IS NOT NULL);
                IF has_data THEN
                    -- Insert new record
                    INSERT INTO tww_app.vw_dryweather_flume (
                        obj_id,
                        fk_wastewater_structure,
                        material,
                        renovation_demand,
                        remark
                    ) VALUES (
                        ws_row.df_obj_id,
                        ws_row.ws_obj_id,
                        ws_row.df_material,
                        ws_row.df_renovation_demand,
                        ws_row.df_remark
                    );
                END IF;
            END IF;
        END IF;

        -- Dryweather Downspout
        IF ws_row.dd_obj_id IS NOT NULL THEN
            IF EXISTS (
                SELECT 1 FROM tww_app.dryweather_downspout
                WHERE fk_wastewater_structure = ws_row.ws_obj_id
            ) THEN
                -- Update existing record
                UPDATE tww_app.dryweather_downspout
                SET
                    diameter = ws_row.dd_diameter,
                    renovation_demand = ws_row.dd_renovation_demand,
                    remark = ws_row.dd_remark
                WHERE fk_wastewater_structure = ws_row.ws_obj_id;
            ELSE
                -- Check if any attribute is not NULL
                has_data := (ws_row.dd_diameter IS NOT NULL)
                        OR (ws_row.dd_renovation_demand IS NOT NULL)
                        OR (ws_row.dd_remark IS NOT NULL);
                IF has_data THEN
                    -- Insert new record
                    INSERT INTO tww_app.dryweather_downspout (
                        obj_id,
                        fk_wastewater_structure,
                        diameter,
                        renovation_demand,
                        remark
                    ) VALUES (
                        ws_row.dd_obj_id,
                        ws_row.ws_obj_id,
                        ws_row.dd_diameter,
                        ws_row.dd_renovation_demand,
                        ws_row.dd_remark
                    );
                END IF;
            END IF;
        END IF;
    END;
    $$;

    """

    structure_part_sql = psycopg.sql.SQL(structure_part_sql)
    cursor.execute(structure_part_sql)

    update_fnc_sql = """
    CREATE OR REPLACE FUNCTION tww_app.transfer_quarantine_to_live()
LANGUAGE plpgsql
AS $$
DECLARE
    check_count integer;
    ws_record RECORD;
    rp_record RECORD;
    ex_record RECORD;
    dm_record RECORD;
    fi_record RECORD;
    re_record RECORD;
    _bottom_level  numeric(7,3);
    _upper_elevation  numeric(7,3);
    _rp_level  numeric(7,3);
    rp_oid character varying(16);
    ws_oid character varying(16);
    vo_oid character varying(16);
    ex_oid character varying(16);
    _url text;

BEGIN
    -- Start a transaction to ensure atomicity
    BEGIN

        FOR ws_record IN
            SELECT * FROM tww_od.import_ws_quarantine
            WHERE tww_is_okay = true AND tww_deleted = false
        LOOP
        -- Step 0: Check for non-ok foreign key entries in related tables
        SELECT COUNT(*) INTO check_count
        FROM (
            SELECT 1 FROM tww_od.import_reach_point_quarantine rp
            WHERE rp.fk_import_ws_quarantine = ws_record.uuidoid AND rp.tww_is_okay = false

            UNION ALL

            SELECT 1 FROM tww_od.import_reach_quarantine re
            JOIN tww_od.import_reach_point_quarantine rp
              ON re.fk_import_rp_quarantine_from = rp.uuidoid OR re.fk_import_rp_quarantine_to = rp.uuidoid
            WHERE rp.fk_import_ws_quarantine = ws_record.uuidoid AND re.tww_is_okay = false

            UNION ALL

            SELECT 1 FROM tww_od.import_examination_quarantine ex
            WHERE ex.fk_import_ws_quarantine = ws_record.uuidoid AND ex.tww_is_okay = false

            UNION ALL

            SELECT 1 FROM tww_od.import_damage_ws_quarantine dm
            JOIN tww_od.import_examination_quarantine ex ON dm.fk_import_examination_quarantine = ex.uuidoid
            WHERE ex.fk_import_ws_quarantine = ws_record.uuidoid AND dm.tww_is_okay = false
        ) AS subquery;

        -- Skip the loop if any related entries are not okay
        IF check_count > 0 THEN
            RAISE NOTICE 'Skipping entry %: Not all children are set to ok', ws_record.obj_id;
            CONTINUE;
        END IF;

            -- Step 1: Process import_ws_quarantine
            CASE WHEN ws_record.tww_level_measurement_kind  = 1 THEN
            _bottom_level :=  coalesce(NULLIF(ws_record.co_level,0) - NULLIF(ws_record.ws__depth,0),wn_bottom_level);
            _upper_elevation := coalesce(NULLIF(ws_record.co_level,0) - NULLIF(ws_record.ss__upper_elevation_depth,0),ss_upper_elevation);
            ELSE
            _bottom_level :=  ws_record.wn_bottom_level;
            _upper_elevation := ws_record.ss_upper_elevation;
            END CASE;

            -- Check if the record already exists in the live table
            IF EXISTS (
                SELECT 1 FROM tww_od.manhole
                WHERE obj_id = ws_record.ws_obj_id
                UNION ALL
                SELECT 1 from tww_od.special_structure
                WHERE obj_id = ws_record.ws_obj_id
            ) THEN
                {update_wsq}
                PERFORM tww_app.set_structure_parts_from_quarantine(ws_record.*);
                ws_oid := ws_record.ws_obj_id;
            ELSE
                {insert_wsq}
                PERFORM tww_app.set_structure_parts_from_quarantine(ws_record.*);
            END IF;

            -- Step 2: Process import_reach_point_quarantine
            FOR rp_record IN
                SELECT * FROM tww_od.import_reach_point_quarantine
                WHERE fk_import_ws_quarantine = ws_record.uuidoid
            LOOP
                -- Check if the record already exists in the live table
                IF EXISTS (
                    SELECT 1 FROM tww_od.reach_point
                    WHERE obj_id = rp_record.obj_id
                ) THEN
                    {update_rp}

                    UPDATE tww_od.import_reach_quarantine
                    SET fk_reach_point_from = rp_record.obj_id
                    WHERE fk_import_rp_quarantine_from = rp_record.uuidoid;

                    UPDATE tww_od.import_reach_quarantine
                    SET fk_reach_point_to = rp_record.obj_id
                    WHERE fk_import_rp_quarantine_to = rp_record.uuidoid;
                ELSE
                    {insert_rp}

                    UPDATE tww_od.import_reach_quarantine
                    SET fk_reach_point_from = rp_record.obj_id
                    WHERE fk_import_rp_quarantine_from = rp_oid;

                    UPDATE tww_od.import_reach_quarantine
                    SET fk_reach_point_to = rp_record.obj_id
                    WHERE fk_import_rp_quarantine_to = rp_oid;
                END IF;
            END LOOP;

            -- Step 3: Process import_examination_quarantine
             UPDATE tww_od.import_damage_ws_quarantine
                    SET fk_wastewater_structure = ws_oid
                    WHERE fk_import_ws_quarantine = ws_record.uuidoid;

            FOR ex_record IN
                SELECT * FROM tww_od.import_examination_quarantine
                WHERE fk_import_ws_quarantine = ws_record.uuidoid
            LOOP
                -- Check if the record already exists in the live table
                IF EXISTS (
                    SELECT 1 FROM tww_od.examination
                    WHERE obj_id = ex_record.obj_id
                ) THEN
                    {update_ex}
                ELSE
                    {insert_ex}
                END IF;


                -- Step 4: Process import_damage_ws_quarantine
                UPDATE tww_od.import_damage_ws_quarantine
                    SET fk_examination = ex_oid
                    WHERE fk_import_examination_quarantine = ex_record.uuidoid;

                FOR dm_record IN
                    SELECT * FROM tww_od.import_examination_quarantine
                    WHERE fk_import_examination_quarantine = ex_record.uuidoid
                LOOP
                    IF EXISTS (
                        SELECT 1 FROM tww_od.damage_manhole
                        WHERE obj_id = dm_record.obj_id
                    ) THEN
                        {update_dm}
                    ELSE
                        {insert_dm}
                    END IF;

                END LOOP;

                -- Step 5: Process import_picture_quarantine
                UPDATE tww_od.import_picture_quarantine
                    SET fk_examination = ex_oid
                    WHERE fk_import_ex_quarantine = ex_record.uuidoid;

                FOR fi_record IN
                    SELECT * FROM tww_od.import_picture_quarantine
                    WHERE fk_import_ex_quarantine = ex_record.uuidoid
                LOOP
                    IF fi_record.fk_data_media is NULL THEN
                        IF vo_oid IS NULL THEN
                        INSERT INTO tww_od.data_media(remark) VALUES ('generated on quarantine import')
                        RETURNING obj_id into vo_oid;
                            RAISE NOTICE  'Created new data_media (obj_id=%) for file import as data_media was not specified for file %, please edit manually',
                            , vo_oid, fi_record.path_relative;
                        ELSE
                            RAISE NOTICE  'Using data_media (obj_id=%) for file import as data_media was not specified for file %, please edit manually',
                            , vo_oid, fi_record.path_relative;;
                        END IF;
                        ELSE NULL;
                    END IF;

                    SELECT COALESCE(vo.path || fi_record.path_relative, fi_record.path_relative)
                    INTO _url
                    FROM tww_od.data_media vo
                    WHERE vo.obj_id=fi_record.fk_data_media OR vo.obj_id=vo_oid;

                    IF EXISTS (
                        SELECT 1 FROM tww_od.file
                        WHERE obj_id = fi_record.obj_id
                    ) THEN
                        {update_fi}
                    ELSE
                        {insert_fi}
                    END IF;

                END LOOP;

            END LOOP;

        END LOOP;

        -- Step 6: Process import_reach_quarantine
        FOR re_record IN
            SELECT * FROM tww_od.import_reach_quarantine
            WHERE tww_is_okay = true AND tww_deleted = false
        LOOP

            IF EXISTS (
                SELECT 1 FROM tww_od.reach
                WHERE obj_id = re_record.obj_id
            ) THEN
                {update_re}
            ELSE
                {insert_re}

            END IF;
        END LOOP;

        -- Commit the transaction if everything succeeds
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback in case of any error
            ROLLBACK;
            RAISE;
    END;
END;
$$;
    """.format(
        insert_wsq=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_ws_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=wsq_skip_cols,
            comment_skipped=False,
            insert_values={
                "ss_upper_elevation": "_upper_elevation",
                "wn_bottom_level": "_bottom_level",
            },
            returning="obj_id into ws_oid",
        )
        .replace("NEW.", "ws_record.")
        .replace("tww_od.import_ws_quarantine", "tww_app.vw_tww_wastewater_structure"),
        update_wsq=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_ws_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=rp_skip_cols,
            comment_skipped=False,
            update_values={
                "ss_upper_elevation": "_upper_elevation",
                "wn_bottom_level": "_bottom_level",
            },
        )
        .replace("NEW.", "ws_record.")
        .replace("tww_od.import_ws_quarantine", "tww_app.vw_tww_wastewater_structure"),
        insert_rp=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=rp_skip_cols,
            comment_skipped=False,
            insert_values={
                "level": """tww_app.calculate_quarantine_rp_level(
                            rp_record.tww_level_measurement_kind,
                            rp_record.rp_co_depth,
                            rp_record.rp_level,
                            ws_record.co_level,
                            ws_record.ss_upper_elevation,
                            rp_record.ss_upper_elevation_depth)""",
            },
            returning="obj_id INTO rp_oid",
        )
        .replace("NEW.", "rp_record.")
        .replace("tww_od.import_reach_point_quarantine", "tww_od.reach_point"),
        update_rp=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_point_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=rp_skip_cols,
            comment_skipped=False,
            update_values={
                "level": """tww_app.calculate_quarantine_rp_level(
                            rp_record.tww_level_measurement_kind,
                            rp_record.rp_co_depth,
                            rp_record.rp_level,
                            ws_record.co_level,
                            ws_record.ss_upper_elevation,
                            rp_record.ss_upper_elevation_depth)""",
            },
        )
        .replace("NEW.", "rp_record.")
        .replace("tww_od.import_reach_point_quarantine", "tww_od.reach_point"),
        insert_re=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=re_skip_cols,
            comment_skipped=False,
            insert_values={
                "progression3d_geometry": "ST_Translate(re_record.progression3d_geometry,0,0,re_record.tww_delta_measurement)",
            },
        )
        .replace("NEW.", "re_record.")
        .replace("tww_od.import_reach_quarantine", "tww_app.vw_tww_reach"),
        update_re=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_reach_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=re_skip_cols,
            comment_skipped=False,
            update_values={
                "progression3d_geometry": "ST_Translate(re_record.progression3d_geometry,0,0,re_record.tww_delta_measurement)",
            },
        )
        .replace("NEW.", "re_record.")
        .replace("tww_od.import_reach_quarantine", "tww_app.vw_tww_reach"),
        insert_ex=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_examination_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=["fk_import_ws_quarantine", "tww_is_okay"],
            comment_skipped=False,
            returning="obj_id INTO ex_oid",
        )
        .replace("NEW.", "ex_record.")
        .replace("tww_od.import_examination_quarantine", "tww_app.vw_examination"),
        update_ex=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_examination_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=["fk_import_ws_quarantine", "tww_is_okay"],
            comment_skipped=False,
            returning="obj_id INTO ex_oid",
        )
        .replace("NEW.", "ex_record.")
        .replace("tww_od.import_examination_quarantine", "tww_app.vw_examination"),
        insert_dm=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_damage_ws_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=["fk_import_examination_quarantine"],
            comment_skipped=False,
            insert_values={
                "obj_id": "dm_record.dm_obj_id",
                "fk_examination": "dm_record.da_fk_examination",
                "comments": "dm_record.da_comments",
                "single_damage_class": "dm_record.da_single_damage_class",
                "shaft_area": "dm_record.dm_shaft_area",
                "damage_code": "dm_record.dm_damage_code",
            },
            returning="obj_id INTO rp_oid",
        )
        .replace("NEW.", "dm_record.")
        .replace("tww_od.import_damage_ws_quarantine", "tww_app.vw_damage_manhole"),
        update_dm=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="import_damage_ws_quarantine",
            remove_pkey=True,
            indent=6,
            skip_columns=["fk_import_examination_quarantine"],
            comment_skipped=False,
            update_values={
                "obj_id": "dm_record.dm_obj_id",
                "fk_examination": "dm_record.da_fk_examination",
                "comments": "dm_record.da_comments",
                "single_damage_class": "dm_record.da_single_damage_class",
                "shaft_area": "dm_record.dm_shaft_area",
                "damage_code": "dm_record.dm_damage_code",
            },
        )
        .replace("NEW.", "dm_record.")
        .replace("tww_od.import_damage_ws_quarantine", "tww_app.vw_damage_manhole"),
        insert_fi=insert_command(
            connection=connection,
            table_schema="tww_app",
            table_name="vw_file",
            remove_pkey=False,
            indent=6,
            skip_columns=rp_skip_cols,
            comment_skipped=False,
            insert_values={
                "_url": "_url",
            },
        ).replace("NEW.", "fi_record."),
        update_fi=update_command(
            connection=connection,
            table_schema="tww_app",
            table_name="vw_file",
            remove_pkey=False,
            indent=6,
            skip_columns=["fk_dataowner", "fk_provider"],
            comment_skipped=False,
            update_values={
                "_url": "_url",
                "object": "ex_record.obj_id",
            },
        ).replace("NEW.", "fi_record."),
    )
    update_fnc_sql = psycopg.sql.SQL(update_fnc_sql)
    cursor.execute(update_fnc_sql)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_import_manhole(
            connection=conn,
        )
