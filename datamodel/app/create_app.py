#!/usr/bin/env python3
import logging
import os
import re
from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path

import psycopg
import yaml
from pirogue import MultipleInheritance, SimpleJoins, SingleInheritance
from pum import HookBase
from triggers.set_defaults_and_triggers import set_defaults_and_triggers
from view.catchment_area_views import (
    vw_tww_catchment_area,
    vw_tww_catchment_area_totals,
)
from view.maintenance_views import (
    vw_tww_channel,
    vw_tww_channel_maintenance,
    vw_tww_ws_maintenance,
)
from view.vw_tww_additional_ws import vw_tww_additional_ws
from view.vw_tww_damage_channel import vw_tww_damage_channel
from view.vw_tww_infiltration_installation import vw_tww_infiltration_installation
from view.vw_tww_log_card import vw_tww_log_card
from view.vw_tww_measurement_series import vw_tww_measurement_series
from view.vw_tww_overflow import vw_tww_overflow
from view.vw_tww_reach import vw_tww_reach
from view.vw_tww_wastewater_structure import vw_tww_wastewater_structure
from view.vw_wastewater_structure import vw_wastewater_structure

logger = logging.getLogger(__name__)


class Hook(HookBase):
    def run_hook(
        self,
        connection: psycopg.Connection,
        SRID: int = 2056,
        modification_agxx: bool = False,
        modification_ci: bool = False,
        lang_code: str = "en",
        modification_yaml: Path = None,
    ):
        """
        Creates the schema tww_app for TEKSI Wastewater & GEP
        :param SRID: the EPSG code for geometry columns. Overridden by modification_yaml
        :param modification_agxx: bool of whether to load agxx modification. Overridden by modification_yaml
        :param modification_ci: bool of whether to load ci modification. Overridden by modification_yaml
        :param lang_code: language code for use in modification views. Overridden by modification_yaml
        :param modification_yaml: Path of yaml containing app parametrisation
        """
        self.cwd = Path(__file__).parent.resolve()
        self._connection = connection

        if modification_yaml:
            self.parameters = self.load_yaml(modification_yaml)
            SRID = self.parameters["base_configurations"][0].get("SRID", 2056)
            lang_code = self.parameters["base_configurations"][0].get("lang_code", "en")
        else:
            self.parameters = self.load_yaml(self.cwd / "app_modification.template.yaml")
            if "modification_repositories" in self.parameters:
                for entry in self.parameters["modification_repositories"]:
                    if modification_ci and entry["id"] == "ci":
                        entry["active"] = True
                    if modification_agxx and entry["id"] == "agxx":
                        entry["active"] = True

        self.abspath = self.cwd if not modification_yaml else ""

        variables_pirogue = {
            "SRID": psycopg.sql.SQL(f"{SRID}")
        }  # when dropping psycopg2 support, we can use the SRID var directly
        self.variables_sql = {
            "SRID": {
                "value": SRID,
                "type": "number",
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
        self.run_sql_files_in_folder(self.cwd / "sql_functions")
        self.app_modifications = [
            entry
            for entry in self.parameters.get("modification_repositories")
            if entry.get("active")
        ]

        self.extra_definitions = self.parameters.get("extra_definitions")
        self.simple_joins_yaml = self.parameters.get("simple_joins_yaml")
        self.multiple_inherintances = self.parameters.get("multiple_inherintances")

        self.single_inherintances = self.load_yaml(self.cwd / "single_inherintances.yaml")

        if self.app_modifications:
            for modification in self.app_modifications:
                logger.info(
                    f"""*****
Running modification {modification.get('id')}
****
                """
                )
                self.load_modification(
                    modification_config=modification,
                )
        for entry in self.parameters.get("modification_repositories"):
            if entry.get("reset_vl", False):
                self.manage_vl(entry)

        # Defaults and Triggers
        # Has to be fired before view creation otherwise it won't work and will only fail in CI
        set_defaults_and_triggers(self._connection, self.single_inherintances)

        for key in self.single_inherintances:
            logger.info(f"creating view vw_{key}")
            SingleInheritance(
                connection=self._connection,
                parent_table="tww_od." + self.single_inherintances[key],
                child_table="tww_od." + key,
                view_name="vw_" + key,
                view_schema="tww_app",
                pkey_default_value=True,
                inner_defaults={"identifier": "obj_id"},
            ).create()

        for key in self.multiple_inherintances:
            MultipleInheritance(
                connection=self._connection,
                definition=self.load_yaml(self.abspath / self.multiple_inherintances[key]),
                drop=True,
                variables=variables_pirogue,
            ).create()

        for key, value in self.extra_definitions.items():
            if value:
                self.extra_definitions[key] = self.abspath / value

        vw_wastewater_structure(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_wastewater_structure"])
                if self.extra_definitions.get("vw_wastewater_structure")
                else {}
            ),
        )
        vw_tww_wastewater_structure(
            connection=self._connection,
            srid=SRID,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_wastewater_structure"])
                if self.extra_definitions.get("vw_tww_wastewater_structure")
                else {}
            ),
        )
        vw_tww_infiltration_installation(
            connection=self._connection,
            srid=SRID,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_infiltration_installation"])
                if self.extra_definitions.get("vw_tww_infiltration_installation")
                else {}
            ),
        )
        vw_tww_reach(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_reach"])
                if self.extra_definitions.get("vw_tww_reach")
                else {}
            ),
        )
        vw_tww_channel(
            connection=self._connection,
            srid=SRID,
            lang_code=lang_code,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_channel"])
                if self.extra_definitions.get("vw_tww_channel")
                else {}
            ),
        )
        vw_tww_channel_maintenance(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_channel_maintenance"])
                if self.extra_definitions.get("vw_tww_channel_maintenance")
                else {}
            ),
        )
        vw_tww_ws_maintenance(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_ws_maintenance"])
                if self.extra_definitions.get("vw_tww_ws_maintenance")
                else {}
            ),
        )
        vw_tww_channel_maintenance(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_channel_maintenance"])
                if self.extra_definitions["vw_tww_channel_maintenance"]
                else {}
            ),
        )
        vw_tww_ws_maintenance(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_ws_maintenance"])
                if self.extra_definitions["vw_tww_ws_maintenance"]
                else {}
            ),
        )
        vw_tww_damage_channel(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_damage_channel"])
                if self.extra_definitions.get("vw_tww_damage_channel")
                else {}
            ),
        )
        vw_tww_additional_ws(
            srid=SRID,
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_additional_ws"])
                if self.extra_definitions.get("vw_tww_additional_ws")
                else {}
            ),
        )
        vw_tww_measurement_series(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_measurement_series"])
                if self.extra_definitions.get("vw_tww_measurement_series")
                else {}
            ),
        )
        vw_tww_overflow(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_overflow"])
                if self.extra_definitions.get("vw_tww_overflow")
                else {}
            ),
        )
        vw_tww_log_card(
            srid=SRID,
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_log_card"])
                if self.extra_definitions.get("vw_tww_log_card")
                else None
            ),
        )
        vw_tww_catchment_area(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_catchment_area"])
                if self.extra_definitions.get("vw_tww_catchment_area")
                else None
            ),
        )
        vw_tww_catchment_area_totals(
            connection=self._connection,
            extra_definition=(
                self.load_yaml(self.extra_definitions["vw_tww_catchment_area_totals"])
                if self.extra_definitions.get("vw_tww_catchment_area_totals")
                else None
            ),
        )
        # TODO: Are these export views necessary? cymed 13.03.25
        for _, yaml_path in self.simple_joins_yaml.items():
            SimpleJoins(
                definition=self.load_yaml(self.abspath / yaml_path), connection=self._connection
            ).create()

        sql_directories = [
            "view/varia",
            "view/catchment_area",
            "view/gep_views",
            "view/swmm_views",
            "view/network",
        ]

        for directory in sql_directories:
            abs_dir = self.cwd / directory
            self.run_sql_files_in_folder(abs_dir)

        # run post_all
        self.run_sql_files_in_folder(self.cwd / "post_all")

    @staticmethod
    def load_yaml(file: Path) -> dict[str]:
        """Safely loads a YAML file and ensures it returns a dictionary."""
        file = Path(file)
        if not file.exists():
            raise FileNotFoundError(f"The file {file} does not exist.")

        logger.info(f"loading yaml {file}")
        with open(file) as f:
            data = yaml.safe_load(f)
            return data if isinstance(data, dict) else {}

    def load_modification(
        self,
        modification_config: set = None,
    ):
        """
        initializes the TWW app schema for usage of a modification
        Args:
            modification_config: modification configuration set
        """

        # load definitions from config
        template_path = modification_config.get("template", None)
        if template_path:
            curr_dir = self.abspath / os.path.dirname(template_path)
            modification_config = self.load_yaml(self.abspath / template_path)
        else:
            curr_dir = ""

        ext_variables = modification_config.get("variables", {})
        sql_vars = self.parse_variables(ext_variables)

        for sql_file in modification_config.get("sql_files", None):
            file_name = curr_dir / sql_file.get("file")
            self.run_sql_file(file_name, sql_vars)

        if template_path:
            for key, value in modification_config.get("extra_definitions", {}).items():
                if not self.extra_definitions[key]:
                    self.extra_definitions[key] = curr_dir / value

            for key, value in modification_config.get("simple_joins_yaml", {}).items():
                if not self.simple_joins_yaml[key]:
                    self.simple_joins_yaml[key] = curr_dir / value

            for key, value in modification_config.get("multiple_inherintances", {}).items():
                if self.multiple_inherintances[key]:
                    self.multiple_inherintances[key] = curr_dir / value

    def manage_vl(
        self,
        config: set = None,
    ):
        """
        manages activation/deactivation of tww value list of a modification
        Args:
            config:  configuration set
        """

        # load definitions from config
        template_path = config.get("template", None)
        is_active = config.get("active", False)
        sql_vars = {"activate": {"value": is_active, "type": "literal"}}
        sql_vars = self.parse_variables(sql_vars)
        if template_path:
            curr_dir = os.path.dirname(template_path)
            config = self.load_yaml(template_path)
        else:
            curr_dir = ""

        for sql_file in config.get("reset_vl_files", None):
            file_name = curr_dir / sql_file.get("file")
            self.run_sql_file(file_name, sql_vars)

    def run_sql_file(self, file_path: str, variables: dict = None):
        with open(file_path) as f:
            sql = f.read()
        self.run_sql(sql, variables)

    def run_sql(self, sql: str, variables: dict = None):
        if variables is None:
            variables = {}
        if (
            re.search(r"\{[A-Za-z-_]+\}", sql) and variables
        ):  # avoid formatting if no variables are present
            try:
                sql = psycopg.sql.SQL(sql).format(**variables).as_string(self._connection)

            except IndexError:
                logger.critical(sql)
                raise
        self.execute(sql)

    def run_sql_files_in_folder(self, directory: str):
        files = os.listdir(directory)
        files.sort()
        sql_vars = self.parse_variables(self.variables_sql)
        for file in files:
            filename = os.fsdecode(file)
            if filename.lower().endswith(".sql"):
                logger.info(f"Running {filename}")
                self.run_sql_file(os.path.join(directory, filename), sql_vars)

    def parse_variables(self, variables: dict) -> dict:
        """Parse variables based on their defined types in the YAML."""
        formatted_vars = {}

        for key, meta in variables.items():
            if isinstance(meta, dict) and "value" in meta and "type" in meta:
                value, var_type = meta["value"], meta["type"].lower()

                if var_type == "number":  # Directly insert SQL without escaping
                    if isinstance(value, float) or isinstance(value, int):
                        formatted_vars[key] = psycopg.sql.SQL(f"{value}")
                    else:  # avoid injection
                        raise ValueError(f"Value '{value}' is not float or int.")
                elif var_type == "identifier":  # Table/Column names
                    if not re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*$", value):  # avoid injection
                        raise ValueError(f"Identifier '{value}' contains invalid characters.")
                    formatted_vars[key] = psycopg.sql.Identifier(value)
                elif var_type == "literal":  # String/Number literals
                    formatted_vars[key] = psycopg.sql.Literal(value)
                else:
                    raise ValueError(f"Unknown type '{var_type}' for variable '{key}'")
            else:
                raise ValueError(f"Unknown type '{var_type}' for variable '{key}'.")
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
        "--modification_agxx",
        action="store_true",
        default=False,
        help="load AG-64/96 modification on app schema",
    )
    parser.add_argument(
        "-c",
        "--modification_ci",
        action="store_true",
        default=False,
        help="load ci modification",
    )
    parser.add_argument(
        "-l",
        "--lang_code",
        help="language code",
        type=str,
        default="en",
        choices=["en", "fr", "de", "it", "ro"],
    )
    parser.add_argument("-m", "--modification_yaml", help="path to modification yaml", type=Path)
    args = parser.parse_args()

    with psycopg.connect(service=args.pg_service) as connection:
        if args.drop_schema:
            connection.execute("DROP SCHEMA IF EXISTS tww_app CASCADE;")
        hook = Hook()
        hook.run_hook(
            connection=connection,
            SRID=args.srid,
            modification_agxx=args.modification_agxx,
            modification_ci=args.modification_ci,
            modification_yaml=args.modification_yaml,
            lang_code=args.lang_code,
        )
