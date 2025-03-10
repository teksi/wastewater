#!/usr/bin/env python3

from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path
from typing import Optional

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from extensions.extension_manager import load_extension
from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from triggers.set_defaults_and_triggers import set_defaults_and_triggers
from view.vw_tww_additional_ws import vw_tww_additional_ws
from view.vw_tww_infiltration_installation import vw_tww_infiltration_installation
from view.vw_tww_measurement_series import vw_tww_measurement_series
from view.vw_tww_reach import vw_tww_reach
from view.vw_tww_wastewater_structure import vw_tww_wastewater_structure
from view.vw_wastewater_structure import vw_wastewater_structure
from yaml import safe_load


def run_sql_file(file_path: str, pg_service: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    with open(abs_file_path) as f:
        sql = f.read()
    run_sql(sql, pg_service, variables)


def run_sql(sql: str, pg_service: str, variables: dict = None):
    if variables:
        sql = psycopg.sql.SQL(sql).format(**variables)
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    conn.close()


def create_app(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    drop_schema: Optional[bool] = False,
    tww_reach_extra_path: Optional[Path] = None,
    tww_wastewater_structure_extra_path: Optional[Path] = None,
    tww_ii_extra_path: Optional[Path] = None,
    wastewater_structure_extra_path: Optional[Path] = None,
    extension_names: Optional[list] = [],
):
    """
    Creates the schema tww_app for TEKSI Wastewater & GEP
    :param srid: the EPSG code for geometry columns
    :param drop_schema: will drop schema tww_app if it exists
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param tww_reach_extra: YAML file path of the definition of additional columns for vw_tww_reach view
    :param tww_wastewater_structure_extra: YAML file path of the definition of additional columns for vw_tww_wastewater_structure_extra view
    :param tww_ii_extra: YAML file path of the definition of additional columns for vw_tww_infiltration_installation_extra view
    :param wastewater_structure_extra: YAML file path of the definition of additional columns for vw_wastewater_structure_extra view
    """
    cwd = Path(__file__).parent.resolve()
    variables = {
        "SRID": psycopg.sql.SQL(f"{srid}")
    }  # when dropping psycopg2 support, we can use the srid var directly

    if drop_schema:
        run_sql("DROP SCHEMA IF EXISTS tww_app CASCADE;", pg_service)

    run_sql("CREATE SCHEMA tww_app;", pg_service)
    run_sql_file("functions/oid_functions.sql", pg_service)
    run_sql_file("functions/modification_functions.sql", pg_service)
    run_sql_file("functions/symbology_functions.sql", pg_service)
    run_sql_file("functions/reach_direction_change.sql", pg_service, variables)
    run_sql_file("functions/geometry_functions.sql", pg_service, variables)
    run_sql_file("functions/update_catchment_area_totals.sql", pg_service, variables)
    run_sql_file("functions/organisation_functions.sql", pg_service, variables)
    run_sql_file("functions/meta_functions.sql", pg_service, variables)
    run_sql_file("functions/network_functions.sql", pg_service)

    yaml_paths_for_funcs={
        "vw_tww_reach":tww_reach_extra_path,
        "vw_tww_wastewater_structure":tww_wastewater_structure_extra_path,
        "vw_wastewater_structure":wastewater_structure_extra_path,
        "vw_tww_infiltration_installation":tww_ii_extra_path,
    }

    yaml_data_dicts=yaml_paths_for_funcs
    for key in yaml_data_dicts:
        yaml_data_dicts[key]={}
    
    for key in yaml_paths_for_funcs:
        if yaml_paths_for_funcs[key]:
            yaml_data_dicts[key].update(load_yaml(yaml_paths_for_funcs[key]))       

    MultipleInheritances = {
        "maintenance": cwd / "view/vw_maintenance_event.yaml",
        "damage": cwd / "view/vw_damage.yaml",
        "overflow": cwd / "view/vw_oo_overflow.yaml",
    }

    SingleInheritances = {
        # structure parts
        "access_aid": "structure_part",
        "benching": "structure_part",
        "backflow_prevention": "structure_part",
        "dryweather_downspout": "structure_part",
        "cover": "structure_part",
        "dryweather_flume": "structure_part",
        "tank_emptying": "structure_part",
        "tank_cleaning": "structure_part",
        "electric_equipment": "structure_part",
        "electromechanical_equipment": "structure_part",
        "solids_retention": "structure_part",
        "flushing_nozzle": "structure_part",
        # wastewater structures
        "channel": "wastewater_structure",
        "manhole": "wastewater_structure",
        "special_structure": "wastewater_structure",
        "infiltration_installation": "wastewater_structure",
        "discharge_point": "wastewater_structure",
        "wwtp_structure": "wastewater_structure",
        "drainless_toilet": "wastewater_structure",
        "small_treatment_plant": "wastewater_structure",
        # wastewater_networkelement
        "wastewater_node": "wastewater_networkelement",
        "reach": "wastewater_networkelement",
        # connection_object
        "building": "connection_object",
        "reservoir": "connection_object",
        "individual_surface": "connection_object",
        "fountain": "connection_object",
        # surface_runoff_parameters
        "param_ca_general": "surface_runoff_parameters",
        "param_ca_mouse1": "surface_runoff_parameters",
        # overflow
        "leapingweir": "overflow",
        "prank_weir": "overflow",
        "pump": "overflow",
        # maintenance_event
        "bio_ecol_assessment": "maintenance_event",
        "examination": "maintenance_event",
        "maintenance": "maintenance_event",
        # zone
        "infiltration_zone": "zone",
        "drainage_system": "zone",
    }

    if extension_names:
        for extension in extension_names:
            yaml_files=load_extension(srid, pg_service, "tww", extension)
            for yaml_file, file_path in yaml_files:
                if yaml_file in yaml_paths_for_funcs:
                    # load data
                    yaml_data_dicts[yaml_file].update(load_yaml(file_path))
                elif yaml_file in MultipleInheritances:
                    # overwrite the path
                    print(f"{MultipleInheritances[yaml_file]} overriden by extension {extension}: New path used is {file_path}")
                    MultipleInheritances[yaml_file].update(file_path)


    run_sql_file("view/vw_dictionary_value_list.sql", pg_service, variables)

    defaults = {"view_schema": "tww_app", "pg_service": pg_service}

    
    # Defaults and Triggers
    # Has to be fired before view creation otherwise it won't work and will only fail in CI
    set_defaults_and_triggers(pg_service, SingleInheritances)

    for key in SingleInheritances:
        SingleInheritance(
            "tww_od." + SingleInheritances[key],
            "tww_od." + key,
            view_name="vw_" + key,
            pkey_default_value=True,
            inner_defaults={"identifier": "obj_id"},
            **defaults,
        ).create()

    for key in MultipleInheritances:
        MultipleInheritance(
            load_yaml(MultipleInheritances[key])safe_load(open()),
            create_joins=True,
            drop=True,
            variables=variables,
            pg_service=pg_service,
        ).create()

    vw_wastewater_structure(pg_service=pg_service, extra_definition=yaml_data_dicts["vw_wastewater_structure"])
    vw_tww_wastewater_structure(
        srid, pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_wastewater_structure"]
    )
    vw_tww_infiltration_installation(srid, pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_infiltration_installation"])
    vw_tww_reach(pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_reach"])
    vw_tww_additional_ws(srid, pg_service=pg_service)
    vw_tww_measurement_series(pg_service=pg_service)


    run_sql_file("view/vw_file.sql", pg_service, variables)
    run_sql_file("view/vw_change_points.sql", pg_service, variables)
    run_sql_file("view/vw_tww_import.sql", pg_service, variables)

    run_sql_file("view/catchment_area/vw_catchment_area_connections.sql", pg_service, variables)
    run_sql_file("view/catchment_area/vw_catchment_area_additional.sql", pg_service, variables)
    run_sql_file(
        "view/catchment_area/vw_catchment_area_rwc_connections.sql", pg_service, variables
    )
    run_sql_file(
        "view/catchment_area/vw_catchment_area_wwc_connections.sql", pg_service, variables
    )
    run_sql_file(
        "view/catchment_area/vw_catchment_area_rwp_connections.sql", pg_service, variables
    )
    run_sql_file(
        "view/catchment_area/vw_catchment_area_wwp_connections.sql", pg_service, variables
    )
    run_sql_file(
        "view/catchment_area/vw_catchment_area_totals_aggregated.sql", pg_service, variables
    )

    # default values
    run_sql_file("view/set_default_value_for_views.sql", pg_service, variables)

    # Recreate GEP views
    run_sql_file("gep_views/vw_tww_catchment_area_totals.sql", pg_service, variables)

    # Recreate network views
    run_sql_file("view/network/vw_network_node.sql", pg_service, variables)
    run_sql_file("view/network/vw_network_segment.sql", pg_service, variables)

    # Recreate swmm views
    # to do finish testing swmm views
    run_sql_file("swmm_views/02_vw_swmm_junctions.sql", pg_service, variables)
    run_sql_file("swmm_views/03_vw_swmm_aquifers.sql", pg_service, variables)
    run_sql_file("swmm_views/04_vw_swmm_conduits.sql", pg_service, variables)
    run_sql_file("swmm_views/05_vw_swmm_dividers.sql", pg_service, variables)
    run_sql_file("swmm_views/06_vw_swmm_landuses.sql", pg_service, variables)
    run_sql_file("swmm_views/07_vw_swmm_losses.sql", pg_service, variables)
    run_sql_file("swmm_views/08_vw_swmm_outfalls.sql", pg_service, variables)
    run_sql_file("swmm_views/09_vw_swmm_subcatchments.sql", pg_service, variables)
    run_sql_file("swmm_views/10_vw_swmm_subareas.sql", pg_service, variables)
    run_sql_file("swmm_views/11_vw_swmm_dwf.sql", pg_service, variables)
    run_sql_file("swmm_views/12_vw_swmm_raingages.sql", pg_service, variables)
    run_sql_file("swmm_views/13_vw_swmm_infiltrations.sql", pg_service, variables)
    run_sql_file("swmm_views/14_vw_swmm_coverages.sql", pg_service, variables)
    run_sql_file("swmm_views/15_vw_swmm_vertices.sql", pg_service, variables)
    run_sql_file("swmm_views/16_vw_swmm_pumps.sql", pg_service, variables)
    run_sql_file("swmm_views/17_vw_swmm_polygons.sql", pg_service, variables)
    run_sql_file("swmm_views/18_vw_swmm_storages.sql", pg_service, variables)
    run_sql_file("swmm_views/19_vw_swmm_outlets.sql", pg_service, variables)
    run_sql_file("swmm_views/20_vw_swmm_orifices.sql", pg_service, variables)
    run_sql_file("swmm_views/21_vw_swmm_weirs.sql", pg_service, variables)
    run_sql_file("swmm_views/22_vw_swmm_curves.sql", pg_service, variables)
    run_sql_file("swmm_views/23_vw_swmm_xsections.sql", pg_service, variables)
    run_sql_file("swmm_views/24_vw_swmm_coordinates.sql", pg_service, variables)
    run_sql_file("swmm_views/25_vw_swmm_tags.sql", pg_service, variables)
    run_sql_file("swmm_views/26_vw_swmm_symbols.sql", pg_service, variables)
    run_sql_file("swmm_views/27_vw_swmm_results.sql", pg_service, variables)

    SimpleJoins(safe_load(open(cwd / "view/export/vw_export_reach.yaml")), pg_service).create()
    SimpleJoins(
        safe_load(open(cwd / "view/export/vw_export_wastewater_structure.yaml")),
        pg_service,
    ).create()

    # Roles
    run_sql_file("tww_app_roles.sql", pg_service, variables)


def load_yaml(file: Path) -> Dict[str]:
    """Safely loads a YAML file and ensures it returns a dictionary."""
    file = Path(file)  
    if not file.exists():
        return {}  # Return empty dict if file does not exist

    with open(file, "r") as f:
        data = safe_load(f)
        return data if isinstance(data, dict) else {}  # Ensure it returns a dict


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "--tww_wastewater_structure_extra",
        help="YAML definition file path for additions to vw_tww_wastewater_structure view",
    )
    parser.add_argument(
        "--tww_reach_extra",
        help="YAML definition file path for additions to vw_tww_reach view",
    )
    parser.add_argument(
        "-d",
        "--drop-schema",
        help="Drops cascaded any existing tww_app schema",
        default=False,
        action=BooleanOptionalAction,
    )
    parser.add_argument(
        "-x",
        "--extension_names",
        nargs="*",
        required=False,
        help="extensions that should be loaded into application schema",
    )
    args = parser.parse_args()

    create_app(
        args.srid,
        args.pg_service,
        drop_schema=args.drop_schema,
        tww_reach_extra=args.tww_reach_extra,
        tww_wastewater_structure_extra=args.tww_wastewater_structure_extra,
        extension_names=args.extension_names,
    )
