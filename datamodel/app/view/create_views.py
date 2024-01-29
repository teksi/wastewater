#!/usr/bin/env python3

import argparse

import psycopg2
from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from vw_tww_reach import vw_tww_reach
from vw_tww_wastewater_structure import vw_tww_wastewater_structure
from yaml import safe_load

# sys.path.append(os.path.join(os.path.dirname(__file__)))


def run_sql(file_path: str, pg_service: str, variables: dict = {}):
    sql = open(file_path).read()
    conn = psycopg2.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql, variables)
    conn.commit()
    conn.close()


def create_views(
    srid: int = 2056,
    pg_service: str = "pg_teksi_wastewater",
    tww_reach_extra: str = None,
    tww_wastewater_structure_extra: str = None,
):
    """
    Creates the views for TEKSI Wastewater & GEP
    :param srid: the EPSG code for geometry columns
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param tww_reach_extra: YAML file path of the definition of additional columns for vw_tww_reach view
    :param tww_wastewater_structure_extra: YAML file path of the definition of additional columns for vw_tww_wastewater_structure_extra view
    """  # noqa E501

    variables = {"SRID": srid}

    # open YAML files
    if tww_reach_extra:
        tww_reach_extra = safe_load(open(tww_reach_extra))
    if tww_wastewater_structure_extra:
        tww_wastewater_structure_extra = safe_load(open(tww_wastewater_structure_extra))

    run_sql("app/view/vw_dictionary_value_list.sql", pg_service, variables)

    defaults = {"view_schema": "tww_app", "pg_service": pg_service}

    SingleInheritances={
        # structure parts
        'access_aid':'structure_part',
        'benching':'structure_part',
        'backflow_prevention':'structure_part',
        'dryweather_downspout':'structure_part',
        'cover':'structure_part',
        'dryweather_flume':'structure_part',
        'tank_emptying':'structure_part',
        'tank_cleaning':'structure_part',
        'electrical_equipment':'structure_part',
        'electromechanical_eqipment':'structure_part',
        'solids_retention':'structure_part',
        'flushing_nozzle':'structure_part',

        # wastewater structures
        'channel':'wastewater_structure',
        'manhole':'wastewater_structure',
        'special_structure':'wastewater_structure',
        'infiltration_installation':'wastewater_structure',
        'discharge_point':'wastewater_structure',
        'wwtp_structure':'wastewater_structure',
        'drainless_toilet':'wastewater_structure',
        'small_treatment_plant':'wastewater_structure',

        # wastewater_networkelement
        'wastewater_node':'wastewater_networkelement',
        'reach':'wastewater_networkelement',

        #connection_object
        'building':'connection_object',
        'reservoir':'connection_object',
        'individual_surface':'connection_object',
        'fountain':'connection_object',

        # zone
        'infiltration_zone':'zone',
        'drainage_system':'zone',
        }

    for key in SingleInheritances:
        SingleInheritance(
            "tww_od."+key,
            "tww_od."+SingleInheritances[key],
            view_name="vw_"+key,
            pkey_default_value=True,
            inner_defaults={"identifier": "obj_id"},
            **defaults,
        ).create()


    MultipleInheritance(
        safe_load(open("app/view/vw_maintenance_event.yaml")),
        create_joins=True,
        drop=True,
        variables=variables,
        pg_service=pg_service,
    ).create()

    MultipleInheritance(
        safe_load(open("app/view/vw_damage.yaml")), drop=True, pg_service=pg_service
    ).create()

    vw_tww_wastewater_structure(
        srid, pg_service=pg_service, extra_definition=tww_wastewater_structure_extra
    )
    vw_tww_reach(pg_service=pg_service, extra_definition=tww_reach_extra)

    run_sql("app/view/vw_file.sql", pg_service, variables)

    MultipleInheritance(
        safe_load(open("app/view/vw_oo_overflow.yaml")),
        create_joins=True,
        variables=variables,
        pg_service=pg_service,
        drop=True,
    ).create()

    # These are not put in the for loop because there are other sql files in that folder. Reason unknown
    run_sql("app/view/vw_change_points.sql", pg_service, variables)
    run_sql("app/view/vw_tww_import.sql", pg_service, variables)

    directories = ['catchment_area','network','swmm_views']
    for folder in directories
        files = os.listdir(os.path.join(folder,os.path.dirname(__file__)))
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".sql"):
                run_sql(os.path.join(folder, filename), pg_service, variables))

    SimpleJoins(safe_load(open("app/view/export/vw_export_reach.yaml")), pg_service).create()
    SimpleJoins(
        safe_load(open("app/view/export/vw_export_wastewater_structure.yaml")), pg_service
    ).create()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
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
    args = parser.parse_args()

    create_views(
        args.srid,
        args.pg_service,
        tww_reach_extra=args.tww_reach_extra,
        tww_wastewater_structure_extra=args.tww_wastewater_structure_extra,
    )
