#!/usr/bin/env python3
#
# -- View: vw_tww_catchment_area

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, update_command
from yaml import safe_load

from .utils.extra_definition_utils import (
    extra_cols,
    extra_joins,
    insert_extra,
    update_extra,
)


def vw_tww_catchment_area(connection: psycopg.Connection, extra_definition: dict = None):
    """
    Creates tww_catchment_area view
    :param connection: psycopg Connection
    :param extra_definition: a dictionary for additional columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_catchment_area;

    CREATE OR REPLACE VIEW tww_app.vw_tww_catchment_area AS
     SELECT
        {ca_cols}
        , ca.population_density_current * ca.surface_area AS _population_current
        , ca.population_density_planned * ca.surface_area AS _population_planned
        , ca.discharge_coefficient_ww_current * ca.surface_area /100 AS _fred_ww_current
        , ca.discharge_coefficient_rw_current * ca.surface_area /100 AS _fred_rw_current
        , ca.discharge_coefficient_ww_planned * ca.surface_area /100 AS _fred_ww_planned
        , ca.discharge_coefficient_rw_planned * ca.surface_area /100 AS _fred_rw_planned
        , ca.seal_factor_ww_current * ca.surface_area /100 AS _f_sealed_ww_current
        , ca.seal_factor_rw_current * ca.surface_area /100 AS _f_sealed_rw_current
        , ca.seal_factor_ww_planned * ca.surface_area /100 AS _f_sealed_ww_planned
        , ca.seal_factor_rw_planned * ca.surface_area /100 AS _f_sealed_rw_planned

        {extra_cols}
        FROM tww_od.catchment_area ca
        {extra_joins};

    """.format(
        ca_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ca",
            remove_pkey=False,
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

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);

    {insert_ca}
    {insert_extra}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_INSERT ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_INSERT();
    """.format(
        insert_ca=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ca",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_UPDATE()
      RETURNS trigger AS
    $BODY$
    BEGIN
      {update_ca}
      {update_extra}
       RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_catchment_area_UPDATE ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_UPDATE();
    """.format(
        update_ca=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area",
            table_alias="ms",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.catchment_area WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_DELETE ON tww_app.vw_tww_catchment_area;

    CREATE TRIGGER vw_tww_catchment_area_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_catchment_area
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
        ALTER VIEW tww_app.vw_tww_catchment_area ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','catchment_area');
    """
    cursor.execute(extras)


def vw_tww_catchment_area_totals(connection: psycopg.Connection, extra_definition: dict = None):
    """
    Creates tww_catchment_area view
    :param connection: psycopg Connection
    :param extra_definition: a dictionary for additional columns
    """
    extra_definition = extra_definition or {}

    cursor = connection.cursor()

    mview_sql = """
CREATE MATERIALIZED VIEW tww_app.mvw_catchment_area_totals
 AS
 SELECT cat.obj_id as _obj_id, -- underscore necessary for pirogue
    lc.obj_id as fk_log_card,
    ca_agg.perimeter_geometry
   FROM tww_od.catchment_area_totals cat
     LEFT JOIN tww_od.hydraulic_char_data hc_c ON hc_c.obj_id::text = cat.fk_hydraulic_char_data::text AND hc_c.status = 6372
     LEFT JOIN tww_od.wastewater_node wn ON hc_c.fk_wastewater_node::text = wn.obj_id::text
     LEFT JOIN tww_od.log_card lc ON lc.fk_pwwf_wastewater_node::text = wn.obj_id::text
     LEFT JOIN ( WITH ca AS (
                 SELECT catchment_area.fk_special_building_ww_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_ww_current IS NOT NULL
                UNION
                 SELECT catchment_area.fk_special_building_rw_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_rw_current IS NOT NULL
                ), collector AS (
                 SELECT coalesce(main_lc.obj_id, lc.obj_id) AS obj_id,
                    ca.geom
                   FROM ca
                     LEFT JOIN tww_od.log_card lc ON ca.fk_log_card::text = lc.obj_id::text
                     LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id::text = lc.fk_main_structure::text
                )
         SELECT collector.obj_id,
            st_unaryunion(st_collect(collector.geom)) AS perimeter_geometry
           FROM collector
          GROUP BY collector.obj_id) ca_agg ON ca_agg.obj_id::text = lc.obj_id::text
WITH DATA;
"""

    cursor.execute(mview_sql)

    view_sql = """
    DROP VIEW IF EXISTS tww_app.vw_tww_catchment_area_totals;

    CREATE OR REPLACE VIEW tww_app.vw_tww_catchment_area_totals AS
     SELECT
        {cat_cols}
        , {mv_cat_cols}
    , wn.situation3d_geometry
    , wn.obj_id AS wn_obj_id
    , {hc_c_cols}
    , {hc_o_cols}
    , {hc_p_cols}
    , {hg_c_cols}
    , ws.status AS ws_status
    , ma.function AS ma_function
    , ss.function AS ss_function
        {extra_cols}
        FROM tww_od.catchment_area_totals cat
        LEFT JOIN tww_app.mvw_catchment_area_totals mv_cat on mv_cat._obj_id=cat.obj_id
        LEFT JOIN tww_od.hydraulic_char_data hc_c ON hc_c.obj_id::text = cat.fk_hydraulic_char_data::text AND hc_c.status = 6372
        LEFT JOIN tww_od.wastewater_node wn ON hc_c.fk_wastewater_node::text = wn.obj_id::text
        LEFT JOIN tww_od.wastewater_networkelement ne ON wn.obj_id::text = ne.obj_id::text
        LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
        LEFT JOIN tww_od.manhole ma ON ma.obj_id::text = ws.obj_id::text
        LEFT JOIN tww_od.special_structure ss ON ss.obj_id::text = ws.obj_id::text
        LEFT JOIN tww_od.hydr_geometry hg_c ON hg_c.obj_id::text = wn.fk_hydr_geometry::text
        LEFT JOIN tww_od.hydraulic_char_data hc_o ON hc_o.fk_wastewater_node::text = wn.obj_id::text AND hc_o.status = 6373
        LEFT JOIN tww_od.hydraulic_char_data hc_p ON hc_p.fk_wastewater_node::text = wn.obj_id::text AND hc_p.status = 6371
        {extra_joins};

    """.format(
        cat_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area_totals",
            table_alias="cat",
            remove_pkey=False,
            indent=4,
            skip_columns=[],
        ),
        mv_cat_cols=select_columns(
            connection=connection,
            table_schema="tww_app",
            table_name="mvw_catchment_area_totals",
            table_alias="mv_cat",
            remove_pkey=False,
            indent=4,
            skip_columns=["_obj_id"],
        ),
        hc_c_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_c",
            prefix="hc_c_",
            remove_pkey=False,
            indent=4,
            skip_columns=["fk_wastewater_node", "status"],
        ),
        hc_o_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_o",
            prefix="hc_o_",
            remove_pkey=False,
            indent=4,
            skip_columns=["fk_wastewater_node", "status"],
        ),
        hc_p_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_p",
            prefix="hc_p_",
            remove_pkey=False,
            indent=4,
            skip_columns=["fk_wastewater_node", "status"],
        ),
        hg_c_cols=select_columns(
            connection=connection,
            table_schema="tww_od",
            table_name="hydr_geometry",
            table_alias="hg_c",
            prefix="hg_c_",
            remove_pkey=False,
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

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_totals_INSERT()
      RETURNS trigger AS
    $BODY$
    DECLARE
      hc_oid VARCHAR(16);
      lc_rec RECORD;
    BEGIN

      NEW.identifier = COALESCE(NEW.identifier, NEW.obj_id);


    SELECT lc.obj_id, lc.fk_pwwf_wastewater_node
    FROM tww_od.log_card lc
    WHERE lc.obj_id=NEW.fk_log_card
    INTO lc_rec;

    CASE WHEN lc_rec.fk_pwwf_wastewater_node IS NULL THEN
      CASE WHEN lc_rec.obj_id IS NULL THEN
      INSERT INTO tww_od.log_card (obj_id, fk_pwwf_wastewater_node)
      VALUES (NEW.fk_log_card, NEW.wn_obj_id);
      ELSE NULL;
      END CASE;
    WHEN lc_rec.fk_pwwf_wastewater_node != NEW.wn_obj_id THEN
      UPDATE tww_od.log_card lc SET lc.fk_pwwf_wastewater_node = NEW.wn_obj_id
      WHERE lc.obj_id=NEW.wn_obj_id;

    ELSE NULL;
    END CASE;
    {insert_hc_c}
    UPDATE tww_od.hydraulic_char_data SET status=6372 WHERE obj_id=hc_oid;
    {insert_hc_o}
    UPDATE tww_od.hydraulic_char_data SET status=6373 WHERE obj_id=hc_oid;
    {insert_hc_p}
    UPDATE tww_od.hydraulic_char_data SET status=6371 WHERE obj_id=hc_oid;
    {insert_hg_c}
    {insert_cat}

    {insert_extra}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_totals_INSERT ON tww_app.vw_tww_catchment_area_totals;

    CREATE TRIGGER vw_tww_catchment_area_totals_INSERT INSTEAD OF INSERT ON tww_app.vw_tww_catchment_area_totals
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_totals_insert();
    """.format(
        insert_cat=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area_totals",
            table_alias="ca",
            remove_pkey=False,
            indent=2,
            skip_columns=[],
            remap_columns={"fk_hydraulic_char_data": "hc_c_obj_id"},
        ),
        insert_hc_c=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_c",
            prefix="hc_c_",
            remove_pkey=False,
            indent=6,
            remap_columns={
                "fk_wastewater_node": "wn_obj_id",
            },
            returning="obj_id INTO hc_oid",
        ),
        insert_hc_o=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_o",
            prefix="hc_o_",
            remove_pkey=False,
            indent=6,
            remap_columns={
                "fk_wastewater_node": "wn_obj_id",
            },
            returning="obj_id INTO hc_oid",
        ),
        insert_hc_p=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_p",
            prefix="hc_p_",
            remove_pkey=False,
            indent=6,
            remap_columns={
                "fk_wastewater_node": "wn_obj_id",
            },
            returning="obj_id INTO hc_oid",
        ),
        insert_hg_c=insert_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydr_geometry",
            table_alias="hg_c",
            prefix="hg_c_",
            remove_pkey=False,
            indent=6,
        ),
        insert_extra=insert_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(trigger_insert_sql)

    update_trigger_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_totals_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      lc_rec RECORD;
    BEGIN

    SELECT lc.obj_id, lc.fk_pwwf_wastewater_node
    FROM tww_od.log_card
    WHERE lc.obj_id=NEW.fk_log_card
    INTO lc_rec;

    CASE WHEN lc_rec.fk_pwwf_wastewater_node IS NULL THEN
      CASE WHEN lc_rec.obj_id IS NULL THEN
      INSERT INTO tww_od.log_card (obj_id, fk_pwwf_wastewater_node)
      VALUES (NEW.fk_log_card, NEW.wn_obj_id);
      ELSE NULL;
      END CASE;
    WHEN lc_rec.fk_pwwf_wastewater_node != wn_obj_id THEN
      UPDATE tww_od.log_card lc SET lc.fk_pwwf_wastewater_node = NEW.wn_obj_id
      WHERE lc.obj_id=NEW.wn_obj_id;

    ELSE NULL;
    END CASE;

      {update_cat}

      {update_hc_c}
      {update_hc_o}
      {update_hc_p}
      {update_hg_c}

      {update_extra}
       RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;



    DROP TRIGGER IF EXISTS vw_tww_catchment_area_totals_UPDATE ON tww_app.vw_tww_catchment_area_totals;

    CREATE TRIGGER vw_tww_catchment_area_UPDATE INSTEAD OF UPDATE ON tww_app.vw_tww_catchment_area_totals
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_totals_UPDATE();
    """.format(
        update_cat=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="catchment_area_totals",
            table_alias="cat",
            indent=6,
            skip_columns=[],
            update_values={},
        ),
        update_hc_c=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_c",
            prefix="hc_c_",
            indent=6,
            skip_columns=["status"],
            update_values={
                "last_modification": "NEW.last_modification",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_provider": "NEW.fk_provider",
                "fk_wastewater_node": "NEW.wn_obj_id",
            },
        ),
        update_hc_o=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_o",
            prefix="hc_o_",
            indent=6,
            skip_columns=["status"],
            update_values={
                "last_modification": "NEW.last_modification",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_provider": "NEW.fk_provider",
                "fk_wastewater_node": "NEW.wn_obj_id",
            },
        ),
        update_hc_p=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydraulic_char_data",
            table_alias="hc_p",
            prefix="hc_p_",
            indent=6,
            skip_columns=["status"],
            update_values={
                "last_modification": "NEW.last_modification",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_provider": "NEW.fk_provider",
                "fk_wastewater_node": "NEW.wn_obj_id",
            },
        ),
        update_hg_c=update_command(
            connection=connection,
            table_schema="tww_od",
            table_name="hydr_geometry",
            table_alias="hg_c",
            prefix="hg_c_",
            indent=6,
            skip_columns=[],
            update_values={
                "last_modification": "NEW.last_modification",
                "fk_dataowner": "NEW.fk_dataowner",
                "fk_provider": "NEW.fk_provider",
            },
        ),
        update_extra=update_extra(connection=connection, extra_definition=extra_definition),
    )

    cursor.execute(update_trigger_sql)

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION tww_app.ft_vw_tww_catchment_area_totals_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      DELETE FROM tww_od.catchment_area_totals WHERE obj_id = OLD.obj_id;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_tww_catchment_area_totals_DELETE ON tww_app.vw_tww_catchment_area_totals;

    CREATE TRIGGER vw_tww_catchment_area_totals_DELETE INSTEAD OF DELETE ON tww_app.vw_tww_catchment_area_totals
      FOR EACH ROW EXECUTE PROCEDURE tww_app.ft_vw_tww_catchment_area_totals_DELETE();
    """

    cursor.execute(trigger_delete_sql)

    extras = """
        ALTER VIEW tww_app.vw_tww_catchment_area_totals ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','catchment_area_totals');
        ALTER VIEW tww_app.vw_tww_catchment_area_totals ALTER hc_c_obj_id SET DEFAULT tww_app.generate_oid('tww_od','hydraulic_char_data');
        ALTER VIEW tww_app.vw_tww_catchment_area_totals ALTER hc_o_obj_id SET DEFAULT tww_app.generate_oid('tww_od','hydraulic_char_data');
        ALTER VIEW tww_app.vw_tww_catchment_area_totals ALTER hc_p_obj_id SET DEFAULT tww_app.generate_oid('tww_od','hydraulic_char_data');
        ALTER VIEW tww_app.vw_tww_catchment_area_totals ALTER hg_c_obj_id SET DEFAULT tww_app.generate_oid('tww_od','hydr_geometry');
    """
    cursor.execute(extras)


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()

    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    parser.add_argument(
        "-e",
        "--extra-definition_ca",
        help="YAML file path for extra additions to the catchment_area view",
    )
    parser.add_argument(
        "-x",
        "--extra-definition_cat",
        help="YAML file path for extra additions to the catchment_area_totals view",
    )
    args = parser.parse_args()
    extra_definition_ca = {}
    if args.extra_definition_ca:
        with open(args.extra_definition_ca) as f:
            extra_definition_ca = safe_load(f)
    extra_definition_cat = {}
    if args.extra_definition_cat:
        with open(args.extra_definition_cat) as f:
            extra_definition_cat = safe_load(f)
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    with psycopg.connect(f"service={pg_service}") as conn:
        vw_tww_catchment_area(connection=conn, extra_definition=extra_definition_ca)
        vw_tww_catchment_area_totals(connection=conn, extra_definition=extra_definition_cat)
