#!/usr/bin/env python3

import os
import re
import zipfile
from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path

import psycopg
import yaml
from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from pum import HookBase
from triggers.set_defaults_and_triggers import set_defaults_and_triggers
from view.vw_tww_additional_ws import vw_tww_additional_ws
from view.vw_tww_channel import vw_tww_channel
from view.vw_tww_damage_channel import vw_tww_damage_channel
from view.vw_tww_infiltration_installation import vw_tww_infiltration_installation
from view.vw_tww_measurement_series import vw_tww_measurement_series
from view.vw_tww_overflow import vw_tww_overflow
from view.vw_tww_reach import vw_tww_reach
from view.vw_tww_wastewater_structure import vw_tww_wastewater_structure
from view.vw_wastewater_structure import vw_wastewater_structure


class Hook(HookBase):
    def run_hook(
        self,
        connection: psycopg.Connection,
        SRID: int = 2056,
        extension_agxx: bool = False,
        extension_ci: bool = False,
        extension_zip: Path = None,
        lang_code: str = "en",
    ):
        """
        Creates the schema tww_app for TEKSI Wastewater & GEP
        :param SRID: the EPSG code for geometry columns
        :param extension_agxx: bool of whether to load agxx extension
        :param extension_agxx: bool of whether to load ci extension
        :param extension_zip: Path of zip containing self-defined extensions
        :paran lang_code: language code for use in extension views
        """
        self.cwd = Path(__file__).parent.resolve()

        variables_pirogue = {
            "SRID": psycopg.sql.SQL(f"{SRID}")
        }  # when dropping psycopg2 support, we can use the SRID var directly
        self.variables_sql = {
            "SRID": {
                "value": f"{SRID}",
                "type": "raw",
            },
            "value_lang": {
                "value": f"value_{lang_code}",
                "type": "identifier",
            },
            "abbr_lang": {
                "value": f"abbr_{lang_code}",
                "type": "identifier",
            },
            "description_lang": {
                "value": f"description_{lang_code}",
                "type": "identifier",
            },
            "display_lang": {
                "value": f"display_{lang_code}",
                "type": "identifier",
            },
        }
        self.execute("CREATE SCHEMA tww_app;")
        self.run_sql_files_in_folder(self.cwd / "sql_functions", self.variables_sql)
        self.extensions = {}
        if extension_agxx:
            self.extensions.update("agxx")

        if extension_ci:
            self.extensions.update("ci")

        self.yaml_data_dicts = {
            "vw_tww_reach": {},
            "vw_tww_wastewater_structure": {},
            "vw_tww_overflow": {},
            "vw_wastewater_structure": {},
            "vw_tww_infiltration_installation": {},
            "vw_tww_channel": {},
            "vw_tww_damage_channel": {},
            "vw_tww_additional_ws": {},
            "vw_tww_measurement_series": {},
        }

        self.MultipleInheritances = {
            "vw_maintenance": self.cwd / "view/multipleinheritance/vw_maintenance_event.yaml",
            "vw_damage": self.cwd / "view/multipleinheritance/vw_damage.yaml",
        }

        self.SingleInheritances = {
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

        self.SimpleJoins_yaml = {
            "vw_export_reach": self.cwd / "view/simplejoins/export/vw_export_reach.yaml",
            "vw_export_wastewater_structure": self.cwd
            / "view/simplejoins/export/vw_export_wastewater_structure.yaml",
        }

        if extension_zip:
            self.add_custom_extension(extension_zip)

        if self.extensions:
            for extension in self.extensions:
                print(
                    f"""*****
Running extension {extension}
****
                """
                )
                self.load_extension(
                    extension_name=extension,
                )

        # Defaults and Triggers
        # Has to be fired before view creation otherwise it won't work and will only fail in CI
        set_defaults_and_triggers(connection, self.SingleInheritances)

        for key in self.SingleInheritances:
            print(f"creating view vw_{key}")
            SingleInheritance(
                connection=connection,
                parent_table="tww_od." + self.SingleInheritances[key],
                child_table="tww_od." + key,
                view_name="vw_" + key,
                view_schema="tww_app",
                pkey_default_value=True,
                inner_defaults={"identifier": "obj_id"},
            ).create()

        for key in self.MultipleInheritances:
            MultipleInheritance(
                connection=connection,
                definition=self.load_yaml(self.MultipleInheritances[key]),
                drop=True,
                variables=variables_pirogue,
            ).create()

        vw_wastewater_structure(
            connection=connection, extra_definition=self.yaml_data_dicts["vw_wastewater_structure"]
        )
        vw_tww_wastewater_structure(
            connection=connection,
            srid=SRID,
            extra_definition=self.yaml_data_dicts["vw_tww_wastewater_structure"],
        )
        vw_tww_infiltration_installation(
            connection=connection,
            srid=SRID,
            extra_definition=self.yaml_data_dicts["vw_tww_infiltration_installation"],
        )
        vw_tww_reach(connection=connection, extra_definition=self.yaml_data_dicts["vw_tww_reach"])
        vw_tww_channel(
            connection=connection,
            extra_definition=self.yaml_data_dicts["vw_tww_channel"],
        )
        vw_tww_damage_channel(
            connection=connection,
            extra_definition=self.yaml_data_dicts["vw_tww_damage_channel"],
        )
        vw_tww_additional_ws(
            srid=SRID,
            connection=connection,
            extra_definition=self.yaml_data_dicts["vw_tww_additional_ws"],
        )
        vw_tww_measurement_series(
            connection=connection,
            extra_definition=self.yaml_data_dicts["vw_tww_measurement_series"],
        )
        vw_tww_overflow(
            connection=connection,
            extra_definition=self.yaml_data_dicts["vw_tww_overflow"],
        )

        # TODO: Are these export views necessary? cymed 13.03.25
        for _, yaml_path in self.SimpleJoins_yaml.items():
            SimpleJoins(definition=self.load_yaml(yaml_path), connection=connection).create()

        sql_directories = [
            "view/varia",
            "view/catchment_area",
            "view/gep_views",
            "view/swmm_views",
            "view/network",
        ]

        for directory in sql_directories:
            abs_dir = self.cwd / directory
            self.run_sql_files_in_folder(abs_dir, connection, self.variables_sql)

        # run post_all
        self.run_sql_files_in_folder(self.cwd / "post_all", connection, self.variables_sql)

        # Roles
        self.execute(self.cwd / "tww_app_roles.sql")

    def load_yaml(self, file: Path) -> dict[str]:
        """Safely loads a YAML file and ensures it returns a dictionary."""
        file = Path(file)
        if not file.exists():
            raise FileNotFoundError(f"The file {file} does not exist.")

        print(f"loading yaml {file}")
        with open(file) as f:
            data = yaml.safe_load(f)
            return data if isinstance(data, dict) else {}

    def add_custom_extension(self, zip_file_path: str):
        """
        Extracts a custom extension from a zip file into the specified extensions folder.

        Args:
            zip_file_path: Path to the zip file containing the extension.
        """
        # Define the extensions directory
        ext_folder = self.cwd / "extensions"

        # Extract the contents of the zip file into the extensions directory
        with zipfile.ZipFile(zip_file_path, "r") as zip_ref:
            zip_ref.extractall(ext_folder)

            original_config_path = ext_folder / "config.yaml"
            custom_config_path = ext_folder / "custom_config.yaml"

            # Load the original and custom configurations
            with open(original_config_path) as file:
                original_config = yaml.safe_load(file)

            with open(custom_config_path) as file:
                custom_config = yaml.safe_load(file)

            self.get_extension_names(custom_config)

            # Update the original configuration with the custom configuration
            # Here, you can define how to merge the configurations
            if custom_config and "extensions" in custom_config:
                original_config["extensions"].extend(custom_config["extensions"])

            with open(original_config_path, "w") as file:
                yaml.dump(original_config, file)

    def load_extension(
        self,
        extension_name: str = None,
    ):
        """
        initializes the TWW database for usage of an extension
        Args:
            connection: psycopg connection object
            extension_name: Name of the extension to load

        """
        # load definitions from config
        ext_folder = self.cwd / "extensions"
        config = self.read_config(ext_folder / "config.yaml", extension_name)

        # do not overwrite variables_sql, so different extensions can use the same variable differently
        variables = self.variables_sql
        ext_variables = config.get("variables", {})
        variables.update(ext_variables)

        directory = config.get("directory", None)
        yaml_files = {}
        if directory:
            abs_dir = ext_folder / directory
            self.run_sql_files_in_folder(abs_dir, variables)

            # extract yaml for extra_definition
            files = os.listdir(abs_dir)
            files.sort()
            for file in files:
                filename = os.fsdecode(file)
                if filename.endswith(".yaml"):
                    key = filename.removesuffix(".yaml")
                    yaml_files[key] = abs_dir / filename

        for target_view, file_path in yaml_files.items():
            if target_view in self.MultipleInheritances:
                # overwrite the path
                print(
                    f"MultipleInheritance view {self.MultipleInheritances[target_view]} overriden by extension {extension_name}: New path used is {file_path}"
                )
                self.MultipleInheritances[target_view] = file_path
            elif target_view in self.SimpleJoins_yaml:
                # overwrite the path
                print(
                    f"SimpleJoin view {self.SimpleJoins_yaml[target_view]} overriden by extension {extension_name}: New path used is {file_path}"
                )
                self.SimpleJoins_yaml[target_view] = file_path
            else:
                # load data
                if target_view in self.yaml_data_dicts:
                    self.yaml_data_dicts[target_view].update(self.load_yaml(file_path))
                else:
                    self.yaml_data_dicts[target_view] = self.load_yaml(file_path)

    def get_extension_names(self, config_file: str):
        abs_file_path = self.cwd / "extensions" / config_file
        with open(abs_file_path) as file:
            config = yaml.safe_load(file)
        for entry in config.get("extensions", []):
            self.extensions.update(entry.get("id"))

    def read_config(self, config_file: str, extension_name: str):
        abs_file_path = self.cwd / "extensions" / config_file
        with open(abs_file_path) as file:
            config = yaml.safe_load(file)
        for entry in config.get("extensions", []):
            if entry.get("id") == extension_name:
                return entry
        raise ValueError(f"No entry found with id: {extension_name}")

    def run_sql_file(self, file_path: str, variables: dict = None):
        with open(file_path) as f:
            sql = f.read()
        sql_vars = self.parse_variables(variables)
        self.run_sql(sql, sql_vars)

    def run_sql(self, sql: str, variables: dict = None):
        if variables is None:
            variables = {}
        if re.search(r"\{[A-Za-z-_]+\}", sql):  # avoid formatting if no variables are present
            try:
                sql = sql.format(**variables)
            except IndexError:
                print(sql)
                raise
        self.execute(sql)

    def run_sql_files_in_folder(self, directory: str, variables: dict = None):
        files = os.listdir(directory)
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.lower().endswith(".sql"):
                print(f"Running {filename}")
                self.run_sql_file(os.path.join(directory, filename), variables)

    def parse_variables(self, variables: dict) -> dict:
        """Parse variables based on their defined types in the YAML."""
        formatted_vars = {}

        for key, meta in variables.items():
            if isinstance(meta, dict) and "value" in meta and "type" in meta:
                value, var_type = meta["value"], meta["type"].lower()

                if var_type == "raw":  # Directly insert SQL without escaping
                    formatted_vars[key] = psycopg.sql.SQL(value)
                elif var_type == "identifier":  # Table/Column names
                    formatted_vars[key] = psycopg.sql.Identifier(value)
                elif var_type == "literal":  # String/Number literals
                    formatted_vars[key] = psycopg.sql.Literal(value)
                else:
                    raise ValueError(f"Unknown type '{var_type}' for variable '{key}'")
            else:
                formatted_vars[key] = psycopg.sql.Literal(str(meta))
        return formatted_vars


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
        "-a",
        "--extension_agxx",
        type=bool,
        action="store_true",
        default=False,
        help="load AG-64/96 extension",
    )
    parser.add_argument(
        "-c",
        "--extension_ci",
        type=bool,
        action="store_true",
        default=False,
        help="load ci extension",
    )
    parser.add_argument(
        "-l",
        "--lang_code",
        help="language code",
        type=str,
        default="en",
        choices=["en", "fr", "de", "it", "ro"],
    )
    parser.add_argument(
        "-z", "--extension_zip", help="path to zip file containing custom extensions", type=Path
    )
    args = parser.parse_args()

    with psycopg.connect(service=args.pg_service) as connection:
        if args.drop_schema:
            connection.execute("DROP SCHEMA IF EXISTS tww_app CASCADE;")
        hook = Hook()
        hook.run_hook(
            connection=connection,
            SRID=args.srid,
            extension_agxx=args.extension_agxx,
            extension_ci=args.extension_ci,
            extension_zip=args.extension_zip,
            lang_code=args.lang_code,
        )
