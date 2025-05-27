#!/usr/bin/env python3

from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path

import psycopg
from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from pum import HookBase
from triggers.set_defaults_and_triggers import set_defaults_and_triggers
from view.vw_tww_additional_ws import vw_tww_additional_ws
from view.vw_tww_channel import vw_tww_channel
from view.vw_tww_damage_channel import vw_tww_damage_channel
from view.vw_tww_infiltration_installation import vw_tww_infiltration_installation
from view.vw_tww_measurement_series import vw_tww_measurement_series
from view.vw_tww_reach import vw_tww_reach
from view.vw_tww_wastewater_structure import vw_tww_wastewater_structure
from view.vw_wastewater_structure import vw_wastewater_structure
from yaml import safe_load


class Hook(HookBase):
    def run_hook(
        self,
        connection: psycopg.Connection,
        SRID: int = 2056,
        tww_reach_extra: Path | None = None,
        tww_wastewater_structure_extra: Path | None = None,
        tww_ii_extra: Path | None = None,
        wastewater_structure_extra: Path | None = None,
        tww_channel_extra: Path | None = None,
    ):
        """
        Creates the schema tww_app for TEKSI Wastewater & GEP
        :param SRID: the EPSG code for geometry columns
        :param tww_reach_extra: YAML file path of the definition of additional columns for vw_tww_reach view
        :param tww_wastewater_structure_extra: YAML file path of the definition of additional columns for vw_tww_wastewater_structure_extra view
        :param tww_ii_extra: YAML file path of the definition of additional columns for vw_tww_infiltration_installation_extra view
        :param wastewater_structure_extra: YAML file path of the definition of additional columns for vw_wastewater_structure_extra view
        :param tww_channel_extra: YAML file path of the definition of additional columns for vw_tww_channel_extra view
        """
        cwd = Path(__file__).parent.resolve()

        variables = {
            "SRID": psycopg.sql.SQL(f"{SRID}")
        }  # when dropping psycopg2 support, we can use the SRID var directly

        self.execute("CREATE SCHEMA tww_app;")
        self.execute(cwd / "functions/oid_functions.sql")
        self.execute(cwd / "functions/modification_functions.sql")
        self.execute(cwd / "functions/symbology_functions.sql")
        self.execute(cwd / "functions/reach_direction_change.sql")
        self.execute(cwd / "functions/geometry_functions.sql")
        self.execute(cwd / "functions/update_catchment_area_totals.sql")
        self.execute(cwd / "functions/organisation_functions.sql")
        self.execute(cwd / "functions/meta_functions.sql")
        self.execute(cwd / "functions/network_functions.sql")

        # open YAML files
        if tww_reach_extra:
            tww_reach_extra = safe_load(open(tww_reach_extra))
        if tww_wastewater_structure_extra:
            tww_wastewater_structure_extra = safe_load(open(tww_wastewater_structure_extra))
        if wastewater_structure_extra:
            wastewater_structure_extra = safe_load(open(wastewater_structure_extra))

        self.execute(cwd / "view/vw_dictionary_value_list.sql")

        defaults = {"view_schema": "tww_app"}

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

        # Defaults and Triggers
        # Has to be fired before view creation otherwise it won't work and will only fail in CI
        set_defaults_and_triggers(connection, SingleInheritances)

        for key in SingleInheritances:
            SingleInheritance(
                connection=connection,
                parent_table="tww_od." + SingleInheritances[key],
                child_table="tww_od." + key,
                view_name="vw_" + key,
                pkey_default_value=True,
                inner_defaults={"identifier": "obj_id"},
                **defaults,
            ).create()

        MultipleInheritance(
            connection=connection,
            definition=safe_load(open(cwd / "view/vw_maintenance_event.yaml")),
            drop=True,
        ).create()

        MultipleInheritance(
            connection=connection,
            definition=safe_load(open(cwd / "view/vw_damage.yaml")),
            drop=True,
        ).create()

        vw_wastewater_structure(connection=connection, extra_definition=wastewater_structure_extra)
        vw_tww_wastewater_structure(
            connection=connection, srid=SRID, extra_definition=tww_wastewater_structure_extra
        )
        vw_tww_infiltration_installation(
            connection=connection, srid=SRID, extra_definition=tww_ii_extra
        )
        vw_tww_reach(connection=connection, extra_definition=tww_reach_extra)
        vw_tww_channel(connection=connection, extra_definition=tww_channel_extra)
        vw_tww_damage_channel(connection=connection)
        vw_tww_additional_ws(srid=SRID, connection=connection)
        vw_tww_measurement_series(connection=connection)

        self.execute(cwd / "view/vw_file.sql")

        MultipleInheritance(
            definition=safe_load(open(cwd / "view/vw_oo_overflow.yaml")),
            variables=variables,
            connection=connection,
            drop=True,
        ).create()

        self.execute(cwd / "view/vw_change_points.sql")
        self.execute(cwd / "view/vw_tww_import.sql")

        self.execute(cwd / "view/catchment_area/vw_catchment_area_connections.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_additional.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_rwc_connections.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_wwc_connections.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_rwp_connections.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_wwp_connections.sql")
        self.execute(cwd / "view/catchment_area/vw_catchment_area_totals_aggregated.sql")

        # default values
        self.execute(cwd / "view/set_default_value_for_views.sql")

        # Recreate GEP views
        self.execute(cwd / "gep_views/vw_tww_catchment_area_totals.sql")

        # Recreate network views
        self.execute(cwd / "view/network/vw_network_node.sql")
        self.execute(cwd / "view/network/vw_network_segment.sql")

        # Recreate swmm views
        # to do finish testing swmm views
        self.execute(cwd / "swmm_views/02_vw_swmm_junctions.sql")
        self.execute(cwd / "swmm_views/03_vw_swmm_aquifers.sql")
        self.execute(cwd / "swmm_views/04_vw_swmm_conduits.sql")
        self.execute(cwd / "swmm_views/05_vw_swmm_dividers.sql")
        self.execute(cwd / "swmm_views/06_vw_swmm_landuses.sql")
        self.execute(cwd / "swmm_views/07_vw_swmm_losses.sql")
        self.execute(cwd / "swmm_views/08_vw_swmm_outfalls.sql")
        self.execute(cwd / "swmm_views/09_vw_swmm_subcatchments.sql")
        self.execute(cwd / "swmm_views/10_vw_swmm_subareas.sql")
        self.execute(cwd / "swmm_views/11_vw_swmm_dwf.sql")
        self.execute(cwd / "swmm_views/12_vw_swmm_raingages.sql")
        self.execute(cwd / "swmm_views/13_vw_swmm_infiltrations.sql")
        self.execute(cwd / "swmm_views/14_vw_swmm_coverages.sql")
        self.execute(cwd / "swmm_views/15_vw_swmm_vertices.sql")
        self.execute(cwd / "swmm_views/16_vw_swmm_pumps.sql")
        self.execute(cwd / "swmm_views/17_vw_swmm_polygons.sql")
        self.execute(cwd / "swmm_views/18_vw_swmm_storages.sql")
        self.execute(cwd / "swmm_views/19_vw_swmm_outlets.sql")
        self.execute(cwd / "swmm_views/20_vw_swmm_orifices.sql")
        self.execute(cwd / "swmm_views/21_vw_swmm_weirs.sql")
        self.execute(cwd / "swmm_views/22_vw_swmm_curves.sql")
        self.execute(cwd / "swmm_views/23_vw_swmm_xsections.sql")
        self.execute(cwd / "swmm_views/24_vw_swmm_coordinates.sql")
        self.execute(cwd / "swmm_views/25_vw_swmm_tags.sql")
        self.execute(cwd / "swmm_views/26_vw_swmm_symbols.sql")
        self.execute(cwd / "swmm_views/27_vw_swmm_results.sql")

        SimpleJoins(
            connection=connection,
            definition=safe_load(open(cwd / "view/export/vw_export_reach.yaml")),
        ).create()
        SimpleJoins(
            connection=connection,
            definition=safe_load(open(cwd / "view/export/vw_export_wastewater_structure.yaml")),
        ).create()

        # Roles
        self.execute(cwd / "tww_app_roles.sql")


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
    args = parser.parse_args()

    with psycopg.connect(service=args.pg_service) as connection:
        if args.drop_schema:
            connection.execute("DROP SCHEMA IF EXISTS tww_app CASCADE;")
        hook = Hook()
        hook.run_hook(
            connection=connection,
            SRID=args.srid,
            tww_reach_extra=args.tww_reach_extra,
            tww_wastewater_structure_extra=args.tww_wastewater_structure_extra,
        )
