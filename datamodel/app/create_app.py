#!/usr/bin/env python3

from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path
from typing import Optional

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from yaml import safe_load

from .extensions.extension_manager import load_extension
from .triggers.set_defaults_and_triggers import set_defaults_and_triggers
from .utils.sql_utils import run_sql, run_sql_files_in_folder
from .view.vw_tww_additional_ws import vw_tww_additional_ws
from .view.vw_tww_channel import vw_tww_channel
from .view.vw_tww_damage_channel import vw_tww_damage_channel
from .view.vw_tww_infiltration_installation import vw_tww_infiltration_installation
from .view.vw_tww_measurement_series import vw_tww_measurement_series
from .view.vw_tww_overflow import vw_tww_overflow
from .view.vw_tww_reach import vw_tww_reach
from .view.vw_tww_wastewater_structure import vw_tww_wastewater_structure
from .view.vw_wastewater_structure import vw_wastewater_structure


def load_yaml(file: Path) -> dict[str]:
    """Safely loads a YAML file and ensures it returns a dictionary."""

    file = Path(file)
    if not file.exists():
        return {}  # Return empty dict if file does not exist

    print(f"loading yaml {file}")
    with open(file) as f:
        data = safe_load(f)
        return data if isinstance(data, dict) else {}  # Ensure it returns a dict


def create_app(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    drop_schema: Optional[bool] = False,
    extension_names: Optional[list] = [],
):
    """
    Creates the schema tww_app for TEKSI Wastewater & GEP
    :param srid: the EPSG code for geometry columns
    :param drop_schema: will drop schema tww_app if it exists
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param extension_names: list of extensions YAML file path of the definition of additional columns for vw_tww_xxx views
    """

    cwd = Path(__file__).parent.resolve()
    variables = {
        "SRID": psycopg.sql.SQL(f"{srid}")
    }  # when dropping psycopg2 support, we can use the srid var directly

    variables_sql = {
        "SRID": {
            "value": f"{srid}",
            "type": "raw",
        }
    }

    if drop_schema:
        run_sql("DROP SCHEMA IF EXISTS tww_app CASCADE;", pg_service)

    run_sql("CREATE SCHEMA tww_app;", pg_service)

    run_sql_files_in_folder(
        Path(__file__).parent.resolve() / "sql_functions", pg_service, variables_sql
    )

    yaml_data_dicts = {
        "vw_tww_reach": {},
        "vw_tww_wastewater_structure": {},
        "vw_tww_overflow": {},
        "vw_wastewater_structure": {},
        "vw_tww_infiltration_installation": {},
        "vw_tww_additional_ws": {},
        "vw_tww_measurement_series": {},
    }

    MultipleInheritances = {
        "vw_maintenance": cwd / "view/multipleinheritance/vw_maintenance_event.yaml",
        "vw_damage": cwd / "view/multipleinheritance/vw_damage.yaml",
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

    SimpleJoins_yaml = {
        "vw_export_reach": cwd / "view/simplejoins/export/vw_export_reach.yaml",
        "vw_export_wastewater_structure": cwd
        / "view/simplejoins/export/vw_export_wastewater_structure.yaml",
    }

    if extension_names:
        for extension in extension_names:
            print(
                f"""*****
Running extension {extension}
****
            """
            )
            yaml_files = load_extension(srid, pg_service, "tww", extension)
            for target_view, file_path in yaml_files.items():
                if target_view in MultipleInheritances:
                    # overwrite the path
                    print(
                        f"MultipleInheritance view {MultipleInheritances[target_view]} overriden by extension {extension}: New path used is {file_path}"
                    )
                    MultipleInheritances[target_view] = file_path
                elif target_view in SimpleJoins_yaml:
                    # overwrite the path
                    print(
                        f"SimpleJoin view {SimpleJoins_yaml[target_view]} overriden by extension {extension}: New path used is {file_path}"
                    )
                    SimpleJoins_yaml[target_view] = file_path
                else:
                    # load data
                    if target_view in yaml_data_dicts:
                        yaml_data_dicts[target_view].update(load_yaml(file_path))
                    else:
                        yaml_data_dicts[target_view] = load_yaml(file_path)

    defaults = {"view_schema": "tww_app", "pg_service": pg_service}

    for key in SingleInheritances:
        print(f"creating view vw_{key}")
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
            load_yaml(MultipleInheritances[key]),
            drop=True,
            variables=variables,
            pg_service=pg_service,
        ).create()

    vw_wastewater_structure(
        pg_service=pg_service, extra_definition=yaml_data_dicts["vw_wastewater_structure"]
    )
    vw_tww_wastewater_structure(
        srid,
        pg_service=pg_service,
        extra_definition=yaml_data_dicts["vw_tww_wastewater_structure"],
    )
    vw_tww_channel(pg_service=pg_service) # no possibility for extra_definition in this view
    vw_tww_damage_channel(pg_service=pg_service) # no possibility for extra_definition in this view
    vw_tww_infiltration_installation(
        srid,
        pg_service=pg_service,
        extra_definition=yaml_data_dicts["vw_tww_infiltration_installation"],
    )
    vw_tww_reach(pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_reach"])
    vw_tww_additional_ws(
        srid, pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_additional_ws"]
    )
    vw_tww_measurement_series(
        pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_measurement_series"]
    )
    vw_tww_overflow(
        pg_service=pg_service, extra_definition=yaml_data_dicts["vw_tww_measurement_series"]
    )

    # TODO: Are these export views necessary? cymed 13.03.25
    for _, yaml_path in SimpleJoins_yaml.items():
        SimpleJoins(load_yaml(yaml_path), pg_service).create()

    sql_directories = [
        "view/varia",
        "view/catchment_area",
        "view/gep_views",
        "view/swmm_views",
        "view/network",
    ]

    for directory in sql_directories:
        abs_dir = Path(__file__).parent.resolve() / directory
        run_sql_files_in_folder(abs_dir, pg_service, variables_sql)

    # Defaults and Triggers
    set_defaults_and_triggers(pg_service, SingleInheritances)

    # run post_all
    run_sql_files_in_folder(
        Path(__file__).parent.resolve() / "post_all", pg_service, variables_sql
    )


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
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
        extension_names=args.extension_names,
    )
