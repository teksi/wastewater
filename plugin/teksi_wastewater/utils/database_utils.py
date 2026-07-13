import collections
import configparser
import logging
import os
import re
from typing import Any

from ..interlis import config
from .issues import Issue, IssueLevel
from .plugin_utils import logger

try:
    import psycopg
    from psycopg import sql

    PSYCOPG_VERSION = 3
    DEFAULTS_CONN_ARG = {"autocommit": True}
except ImportError:
    import psycopg2 as psycopg
    from psycopg2 import sql

    PSYCOPG_VERSION = 2
    DEFAULTS_CONN_ARG = {}


class DatabaseConfig:
    def __init__(self) -> None:
        self.PGSERVICE = None  # overriden by PG* settings below
        self.PGHOST = os.getenv("PGHOST", None)
        self.PGPORT = os.getenv("PGPORT", None)
        self.PGDATABASE = os.getenv("PGDATABASE", None)
        self.PGUSER = os.getenv("PGUSER", None)
        self.PGPASS = os.getenv("PGPASS", None)


class DatabaseUtils:

    databaseConfig = DatabaseConfig()

    class PsycopgConnection:
        def __init__(self) -> None:
            self.connection = None

        def __enter__(self):
            self.connection = psycopg.connect(
                DatabaseUtils.get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG
            )
            if PSYCOPG_VERSION == 2:
                self.connection.set_session(autocommit=True)

            return self.connection

        def __exit__(self, exc_type, exc_val, exc_tb):
            self.connection.commit()
            self.connection.close()

    @staticmethod
    def wrap_identifier(identifier: str) -> Any:
        """
        Safely wrap an identifier (e.g., table or column name) for use in SQL.
        Works with both psycopg2 and psycopg3.
        """
        return sql.Identifier(identifier)

    @staticmethod
    def wrap_literal(value: Any) -> Any:
        """
        Safely wrap a literal value for use in SQL.
        Works with both psycopg2 and psycopg3.
        """
        return sql.Literal(value)

    @staticmethod
    def compose_sql(query: str, *args: Any, **kwargs: Any) -> Any:
        """
        Safely compose an SQL query with identifiers and values.
        Works with both psycopg2 and psycopg3.
        """
        return sql.SQL(query).format(*args, **kwargs)

    @staticmethod
    def fetchone(query: str):
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(query)
            return cursor.fetchone()

    @staticmethod
    def fetchall(query: str):
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(query)
            return cursor.fetchall()

    @staticmethod
    def execute(query: str):
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            cursor.execute(query)

    @staticmethod
    def get_psycopg_connection():
        connection = psycopg.connect(
            DatabaseUtils.get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG
        )
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)

    @staticmethod
    def read_pgservice(service_name):
        """
        Returns a config object from a pg_service name (parsed from PGSERVICEFILE).
        """

        # Path for pg_service.conf
        if os.environ.get("PGSERVICEFILE"):
            PG_CONFIG_PATH = os.environ.get("PGSERVICEFILE")
            logger.debug(f"PGSERVICEFILE:  {PG_CONFIG_PATH}")
        elif os.environ.get("PGSYSCONFDIR"):
            PG_CONFIG_PATH = os.path.join(os.environ.get("PGSYSCONFDIR"), "pg_service.conf")
            logger.debug(f"PGSYSCONFDIR:  {PG_CONFIG_PATH}")
        else:
            if os.name == "nt":  # Windows
                config_file = "pg_service.conf"
            else:  # Unix-like (Linux, macOS)
                config_file = ".pg_service.conf"
            PG_CONFIG_PATH = os.path.expanduser(f"~/{config_file}")
            logger.debug(f"PG_CONFIG_PATH:  {PG_CONFIG_PATH}")

        config = configparser.ConfigParser()
        if os.path.exists(PG_CONFIG_PATH):
            config.read(PG_CONFIG_PATH)

        if service_name not in config:
            logger.warning(f"Service `{service_name}` not found in {PG_CONFIG_PATH}.")
            return {}

        return config[service_name]

    @staticmethod
    def get_pgconf():
        """
        Returns the postgres configuration (parsed from the config.PGSERVICE service and overriden by config.PG* settings)
        """

        if DatabaseUtils.databaseConfig.PGSERVICE:
            pgconf = DatabaseUtils.read_pgservice(DatabaseUtils.databaseConfig.PGSERVICE)
        else:
            pgconf = {}

        if DatabaseUtils.databaseConfig.PGHOST:
            pgconf["host"] = DatabaseUtils.databaseConfig.PGHOST
        if DatabaseUtils.databaseConfig.PGPORT:
            pgconf["port"] = DatabaseUtils.databaseConfig.PGPORT
        if DatabaseUtils.databaseConfig.PGDATABASE:
            pgconf["dbname"] = DatabaseUtils.databaseConfig.PGDATABASE
        if DatabaseUtils.databaseConfig.PGUSER:
            pgconf["user"] = DatabaseUtils.databaseConfig.PGUSER
        if DatabaseUtils.databaseConfig.PGPASS:
            pgconf["password"] = DatabaseUtils.databaseConfig.PGPASS

        return collections.defaultdict(str, pgconf)

    @staticmethod
    def get_pgconf_as_psycopg_dsn() -> list[str]:
        """Returns the pgconf as a psycopg connection string"""

        pgconf = DatabaseUtils.get_pgconf()
        parts = []
        for key in pgconf:
            parts.append(f"{key}={pgconf[key]}")
        dsn_masked_pwd = re.sub(r"(password=).+", r"\1[PASSWORD]", " ".join(parts))
        logger.debug(f"psycopg dsn: {dsn_masked_pwd}")
        return " ".join(parts)

    @staticmethod
    def disable_symbology_triggers():
        logger.info("Disable symbology triggers")
        DatabaseUtils.execute("SELECT tww_app.alter_symbology_triggers('disable');")

    @staticmethod
    def enable_symbology_triggers():
        logger.info("Enable symbology triggers")
        DatabaseUtils.execute("SELECT tww_app.alter_symbology_triggers('enable');")

    @staticmethod
    def check_symbology_triggers_enabled():
        logger.info("Check symbology triggers enabled")
        row = DatabaseUtils.fetchone("SELECT tww_app.check_symbology_triggers_enabled();")
        return row[0]

    @staticmethod
    def update_symbology():
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("update_wastewater_node symbology for all datasets - please be patient")
            cursor.execute("SELECT tww_app.update_wastewater_node_symbology(NULL, True);")
            logger.info("update_wastewater_structure label for all datasets - please be patient")
            cursor.execute("SELECT tww_app.update_wastewater_structure_label(NULL, True);")

    @staticmethod
    def disable_modification_triggers():
        logger.info("Disable modification triggers")
        DatabaseUtils.execute("SELECT tww_app.alter_modification_triggers('disable');")

    @staticmethod
    def enable_modification_triggers():
        logger.info("Enable modification triggers")
        DatabaseUtils.execute("SELECT tww_app.alter_modification_triggers('enable');")

    @staticmethod
    def check_modification_triggers_enabled():
        logger.info("Check if modification triggers are enabled")
        row = DatabaseUtils.fetchone("SELECT tww_app.check_modification_enabled();")
        return row[0]

    @staticmethod
    def check_oid_prefix() -> list[str]:
        """Check whether the oid_prefix is set up for production"""
        logger.info("Checking setup of oid prefix")
        prefixes = DatabaseUtils.fetchall("SELECT prefix FROM tww_sys.oid_prefixes WHERE active;")

        issues = []
        if len(prefixes) > 1:
            issues.append(
                Issue(
                    "More than one oid_prefix set to active. Generation of "
                    "Object-ID will not work. Set the OID prefix for your "
                    "production database to active.",
                    IssueLevel.ERROR,
                )
            )

        if len(prefixes) > 0:
            active_pref = prefixes[0][0]
            if active_pref == "ch000000":
                issues.append(
                    Issue(
                        "OID prefix set to 'ch000000'. Database not safe for production.",
                        IssueLevel.ERROR,
                    )
                )

        return issues

    @staticmethod
    def check_fk_defaults() -> list[str]:
        """Check whether the database is set up for production"""
        logger.info("Checking setup of default_values")

        defaults = []
        vals = []
        for item in DatabaseUtils.fetchall(
            "SELECT fieldname,value_obj_id from tww_od.default_values;"
        ):
            defaults.append(item[0])
            vals.append(item[1])

        msg_list = []
        if None in vals:
            msg_list.append(
                Issue(
                    "There is an undefined default value in tww_od.default_values",
                    IssueLevel.ERROR,
                )
            )
        elif not all(x in defaults for x in ["fk_provider", "fk_dataowner"]):
            msg_list.append(
                Issue(
                    "'fk_provider' or 'fk_dataowner' not set in tww_od.default_values",
                    IssueLevel.ERROR,
                )
            )

        return msg_list

    @staticmethod
    def get_validity_check_issues(include_ili: bool = False, logger=None) -> list[str]:
        messages = []
        messages = DatabaseUtils.check_oid_prefix()
        messages.extend(DatabaseUtils.check_fk_defaults())

        if not DatabaseUtils.check_symbology_triggers_enabled():
            messages.extend(
                Issue(
                    "Symbology triggers are disabled",
                    IssueLevel.ERROR,
                )
            )

        if include_ili:
            IntegrityChecker = TWWIntegrityChecker(
                models=[config.MODEL_NAME_DSS, config.MODEL_NAME_VSA_KEK], logger=logger
            )
            IntegrityChecker.run_integrity_checks()
            messages.extend(IntegrityChecker.issues)

        return messages

    @staticmethod
    def refresh_network_simple():
        logger.info("Refreshing network")
        DatabaseUtils.execute("SELECT tww_app.network_refresh_network_simple();")

    @staticmethod
    def refresh_matviews():
        logger.info("Refreshing materialized views")
        DatabaseUtils.execute("SELECT tww_app.refresh_materialized_views('tww_app', NULL, True);")


class TWWIntegrityChecker:
    def __init__(self, models=[], limit_to_selection=False, logger=None):
        self.limit_to_selection = limit_to_selection
        self.models = models
        self.issues = []
        self.logger = logger or logging.getLogger(__name__)

    def add_issue(
        self,
        message: str,
        level: IssueLevel = IssueLevel.WARNING,
    ):
        self.issues.append(Issue(message, level))

        if level == IssueLevel.ERROR:
            self.logger.error(message)
        elif level == IssueLevel.INFO:
            self.logger.info(message)
        else:
            self.logger.warning(message)

    def run_integrity_checks(self) -> list[Issue]:
        checks = [
            ("subclass_counts", self._check_subclass_counts),
            ("identifier_null", self._check_identifier_null),
            ("fk_owner_null", self._check_fk_owner_null),
            ("fk_operator_null", self._check_fk_operator_null),
            ("fk_dataowner_null", self._check_fk_dataowner_null),
            ("fk_provider_null", self._check_fk_provider_null),
            ("fk_wastewater_structure_null", self._check_fk_wastewater_structure_null),
            ("fk_wastewater_node_null", self._check_fk_wastewater_node_null),
            ("fk_responsible_entity_null", self._check_fk_responsible_entity_null),
            ("fk_responsible_start_null", self._check_fk_responsible_start_null),
            ("fk_discharge_point_null", self._check_fk_discharge_point_null),
            ("fk_hydraulic_char_data_null", self._check_fk_hydraulic_char_data_null),
            ("building_group_null", self._check_fk_building_group_null),
            ("fk_reach_null", self._check_fk_reach_null),
            ("fk_reach_point_from_null", self._check_fk_reach_point_from_null),
            ("fk_reach_point_to_null", self._check_fk_reach_point_to_null),
            ("fk_pwwf_wastewater_node_null", self._check_fk_pwwf_wastewater_node_null),
            ("fk_catchment_area_null", self._check_fk_catchment_area_null),
            # Add other checks here
        ]

        for check_name, check_func in checks:
            failed, error_message, _ = check_func()
            if failed:
                self.add_issue(
                    f"{check_name}: {error_message}",
                    IssueLevel.ERROR,
                )

        return self.issues

    @property
    def failed(self) -> bool:
        return any(i.level == IssueLevel.ERROR for i in self.issues)

    @property
    def failed_checks(self) -> list:
        return [i for i in self.issues if i.level == IssueLevel.ERROR]

    @property
    def stats(self):
        return {
            "failed": len(self.failed_checks),
            "total": len(self.issues),
        }

    def _check_subclass_counts(self, raise_err=False):
        failed = False
        error_messages = []
        total_issue_count = 0

        # List of all checks to perform
        checks = [
            ("wastewater_networkelement", ["reach", "wastewater_node"]),
            (
                "wastewater_structure",
                [
                    "channel",
                    "manhole",
                    "special_structure",
                    "infiltration_installation",
                    "discharge_point",
                    "wwtp_structure",
                    "small_treatment_plant",
                    "drainless_toilet",
                ],
            ),
            (
                "structure_part",
                [
                    "benching",
                    "tank_emptying",
                    "tank_cleaning",
                    "cover",
                    "access_aid",
                    "electric_equipment",
                    "electromechanical_equipment",
                    "solids_retention",
                    "backflow_prevention",
                    "flushing_nozzle",
                    "dryweather_flume",
                    "dryweather_downspout",
                ],
            ),
        ]
        if config.MODEL_NAME_VSA_KEK in self.models:
            checks.extend(
                [
                    (
                        "maintenance_event",
                        ["maintenance", "examination", "bio_ecol_assessment"],
                    ),
                    (
                        "damage",
                        ["damage_channel", "damage_manhole"],
                    ),
                ]
            )
        if config.MODEL_NAME_DSS in self.models:
            checks.extend(
                [
                    ("overflow", ["pump", "leapingweir", "prank_weir"]),
                    (
                        "connection_object",
                        ["fountain", "individual_surface", "building", "reservoir"],
                    ),
                    (
                        "zone",
                        ["infiltration_zone", "drainage_system"],
                    ),
                ]
            )

        for parent, children in checks:
            check_failed, msg, count = self._check_subclass_count(
                config.TWW_OD_SCHEMA, parent, children
            )
            failed = failed or check_failed
            if msg:
                error_messages.append(msg)
            total_issue_count += count
        error_message = "; ".join(error_messages) if error_messages else ""
        # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} last")
        if raise_err and failed:
            from ..interlis.utils.various import InterlisImporterExporterError

            raise InterlisImporterExporterError("Subclass Count error", error_message, None)
        return (failed, error_message, total_issue_count)

    def _check_subclass_count(self, schema_name, parent_name, child_list) -> tuple[bool, str, int]:
        """
        Returns: (failed, error message, parent_count)
        """
        errormsg = ""
        self.add_issue(f"INTEGRITY CHECK {parent_name} subclass data...", level="info")
        self.add_issue("CONNECTING TO DATABASE...", level="info")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            cursor.execute(f"SELECT obj_id FROM {schema_name}.{parent_name};")
            parent_rows = cursor.fetchall()
            parent_ids = {row[0] for row in parent_rows}
            self.add_issue(f"Number of {parent_name} datasets: {len(parent_ids)}", level="info")

            missing_in_subclass = set(parent_ids)
            missing_in_superclass = {}  # Maps subclass name to orphaned IDs

            for child_name in child_list:
                cursor.execute(f"SELECT obj_id FROM {schema_name}.{child_name};")
                child_rows = cursor.fetchall()
                child_ids = {row[0] for row in child_rows}
                self.add_issue(f"Number of {child_name} datasets: {len(child_rows)}", level="info")

                missing_in_subclass -= child_ids

                orphaned = child_ids - parent_ids
                if orphaned:
                    missing_in_superclass[child_name] = orphaned

            if missing_in_subclass:
                errormsg += (
                    f"Missing subclass entries for {len(missing_in_subclass)} "
                    f"{schema_name}.{parent_name} objects (IDs: {sorted(missing_in_subclass)})\n"
                )
            if missing_in_superclass:
                for child_name, orphaned_ids in missing_in_superclass.items():
                    errormsg += (
                        f"Missing superclass entries for {len(orphaned_ids)} objects in {schema_name}.{child_name} "
                        f"(IDs: {sorted(orphaned_ids)})\n"
                    )

            if missing_in_subclass or missing_in_superclass:
                if self.limit_to_selection:
                    self.add_issue(
                        f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                    )
                else:
                    self.add_issue(f"Subclass Count error: {errormsg}", level="error")
                # Return statement added
                return (True, errormsg, len(missing_in_subclass) + len(missing_in_superclass))
            else:
                self.add_issue(
                    f"OK: number of subclass elements of class {parent_name} OK in schema {schema_name}!",
                    level="info",
                )
                # Return statement added
                return (False, errormsg, len(missing_in_subclass) + len(missing_in_superclass))

    def _check_conditions(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
        check_null: bool = True,
        check_true: bool = False,
    ) -> dict[str, tuple[int, list[Any]]]:
        """
        Returns a dict of {class_name: (count, [obj_ids])} for missing values.
        """
        check_str = check_val is not None
        if not any((check_str, check_null, check_true)):
            raise ValueError("No conditions specified for check_conditions")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            column_identifier = DatabaseUtils.wrap_identifier(value_name)
            condition_parts = []
            params = []
            if check_str:

                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} = %s",
                        column_name=column_identifier,
                    )
                )
                params.append(check_val)
            if check_null:
                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} IS NULL",
                        column_name=column_identifier,
                    )
                )
            if check_true:
                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} IS True",
                        column_name=column_identifier,
                    )
                )
            condition = DatabaseUtils.compose_sql(
                "(" + " OR ".join(["{}"] * len(condition_parts)) + ")", *condition_parts
            )
            results = {}
            for _class in check_classes:
                query = DatabaseUtils.compose_sql(
                    """
                    SELECT COUNT(obj_id) as _count, array_agg(obj_id) as _obj_ids
                    FROM tww_od.{table_name}
                    WHERE {condition}
                    """,
                    table_name=DatabaseUtils.wrap_identifier(_class),
                    condition=condition,
                )
                cursor.execute(query, params or None)
                result = cursor.fetchone()
                class_count = int(result[0]) if result else 0
                obj_ids_without_val = result[1] if result else []
                results[_class] = (class_count, obj_ids_without_val)
            return results

    def _check_available_export_values(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
        check_null: bool = True,
        check_true: bool = False,
    ) -> tuple[bool, str, int]:
        """
        Check if attribute value_name fulfils condition.
        check_classes: List of class names that are to be checked
        value_name: name of the value to be checked
        check_null: bool whether to check for IS NULL
        check_val: value to be checked. Defaults to ''
        Returns: (failed, error_message, issue_count)
        """
        results = self._check_conditions(
            check_classes, value_name, check_val, check_null, check_true
        )
        error_message = ""
        empty_class_count = 0
        for _class, (class_count, _) in results.items():
            self.add_issue(
                f"table name: {_class}, value name: {value_name}, class count: {class_count}",
                level="info",
            )
            if class_count == 0:
                error_message += (
                    f"No exportable entries found in table tww_od.{_class} on {value_name} check"
                )
                empty_class_count += 1
        if empty_class_count > 0:
            return (True, error_message, empty_class_count)
        else:
            self.add_issue(f"OK: all {value_name} set!", level="info")
            return (False, "", 0)

    def _check_value_condition(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
    ) -> tuple[bool, str, int]:
        """
        Check if attribute value_name fulfils condition.
        check_classes: List of class names that are to be checked
        value_name: name of the value to be checked
        check_null: bool whether to check for IS NULL
        check_val: value to be checked. Defaults to ''
        limit_to_selection: bool whether a selection limit is active
        Returns: (failed, error_message, issue_count)
        """
        results = self._check_conditions(
            check_classes=check_classes,
            value_name=value_name,
            check_val=check_val,
        )
        missing_count = 0
        error_message = ""
        for _class, (class_count, obj_ids_without_val) in results.items():
            self.add_issue(
                f"table name: {_class}, value name: {value_name}, class count: {class_count}",
                level="info",
            )
            if class_count > 0:
                error_message += (
                    f"{class_count} rows in class '{_class}' "
                    f"without {value_name}: {','.join(obj_ids_without_val)}\n"
                )
                missing_count += class_count
        if missing_count > 0:
            errormsg = f"Missing {value_name} in schema tww_od: {missing_count}"
            if self.limit_to_selection:
                self.add_issue(
                    f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                )
            else:
                self.add_issue(f"INTEGRITY CHECK missing {value_name}: {errormsg}", level="error")
            return (True, error_message, missing_count)
        else:
            self.add_issue(f"OK: all {value_name} set!", level="info")
            return (False, "", 0)

    def _check_identifier_null(self):
        """
        Check if attribute identifier is Null or ''
        """
        check_classes = [
            ("organisation"),
        ]
        if config.MODEL_NAME_VSA_KEK in self.models:
            check_classes.extend(
                [
                    # VSA-KEK
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        if config.MODEL_NAME_SIA405_ABWASSER in self.models:
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    # VSA-DSS
                    # new 2020
                    ("building_group"),
                    ("catchment_area"),
                    ("catchment_area_totals"),
                    ("connection_object"),
                    ("control_center"),
                    # only VSA-DSS 2015
                    # ("hazard_source"),
                    ("hydr_geometry"),
                    ("hydraulic_char_data"),
                    # new 2020
                    ("measure"),
                    ("measurement_result"),
                    ("measurement_series"),
                    ("measuring_device"),
                    ("measuring_point"),
                    ("mechanical_pretreatment"),
                    ("overflow"),
                    ("overflow_char"),
                    ("retention_body"),
                    # only VSA-DSS 2015
                    # ("river_bank"),
                    # ("river_bed"),
                    # ("sector_water_body"),
                    ("sludge_treatment"),
                    # ("substance"),
                    ("surface_runoff_parameters"),
                    # ("surface_water_bodies"),
                    ("throttle_shut_off_unit"),
                    ("waste_water_treatment"),
                    ("waste_water_treatment_plant"),
                    # only VSA-DSS 2015
                    # ("water_catchment"),
                    # ("water_control_structure"),
                    # ("water_course_segment"),
                    ("wwtp_energy_use"),
                    ("zone"),
                ]
            )
        if config.MODEL_NAME_AG64 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "identifier", "")

    def _check_fk_owner_null(self):
        """
        Check if MANDATORY fk_owner is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.models):
            check_classes = [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]
        return self._check_value_condition(check_classes, "fk_owner")

    def _check_fk_operator_null(self):
        """
        Check if MANDATORY fk_operator is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.models):
            check_classes = [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]
        return self._check_value_condition(check_classes, "fk_operator")

    def _check_fk_dataowner_null(self):
        """
        Check if MANDATORY fk_dataowner is Null
        """
        check_classes = []
        if config.MODEL_NAME_VSA_KEK in self.models:
            check_classes.extend(
                [
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_DSS,
        }
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("building_group"),
                    ("building_group_baugwr"),
                    ("catchment_area"),
                    ("connection_object"),
                    ("control_center"),
                    # new 2020
                    ("disposal"),
                    ("farm"),
                    # only VSA-DSS 2015
                    # ("hazard_source"),
                    ("hq_relation"),
                    ("hydraulic_char_data"),
                    ("hydr_geometry"),
                    ("hydr_geom_relation"),
                    # new 2020
                    ("log_card"),
                    # maintenance_event see VSA-KEK
                    # new 2020
                    ("measure"),
                    ("measurement_result"),
                    ("measurement_series"),
                    ("measuring_device"),
                    ("measuring_point"),
                    ("mechanical_pretreatment"),
                    ("mutation"),
                    ("overflow"),
                    ("overflow_char"),
                    ("profile_geometry"),
                    ("retention_body"),
                    # only VSA-DSS 2015
                    # ("river_bank"),
                    # ("river_bed"),
                    # ("sector_water_body"),
                    ("sludge_treatment"),
                    # ("substance"),
                    ("surface_runoff_parameters"),
                    # only VSA-DSS 2015
                    # ("surface_water_bodies"),
                    ("throttle_shut_off_unit"),
                    ("waste_water_treatment"),
                    ("waste_water_treatment_plant"),
                    # only VSA-DSS 2015
                    # ("water_catchment"),
                    # ("water_control_structure"),
                    # ("water_course_segment"),
                    ("wwtp_energy_use"),
                    ("zone"),
                    # sia405cc
                    ("sia405cc_cable"),
                    ("sia405cc_cable_point"),
                    ("sia405pt_protection_tube"),
                ]
            )
        if config.MODEL_NAME_AG64 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_dataowner")

    def _check_fk_provider_null(self):
        """
        Check if MANDATORY fk_provider is Null
        """
        check_classes = []
        if config.MODEL_NAME_VSA_KEK in self.models:
            check_classes.extend(
                [
                    # VSA-KEK
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_DSS,
        }
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    # take out for DSS 2020
                    # ("organisation"),
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    # new 2020
                    ("building_group"),
                    ("building_group_baugwr"),
                    ("catchment_area"),
                    ("connection_object"),
                    ("control_center"),
                    # new 2020
                    ("disposal"),
                    ("farm"),
                    # only VSA-DSS 2015
                    # ("hazard_source"),
                    ("hq_relation"),
                    ("hydraulic_char_data"),
                    ("hydr_geometry"),
                    ("hydr_geom_relation"),
                    # new 2020
                    ("log_card"),
                    # maintenance_event see VSA-KEK
                    # new 2020
                    ("measure"),
                    ("measurement_result"),
                    ("measurement_series"),
                    ("measuring_device"),
                    ("measuring_point"),
                    ("mechanical_pretreatment"),
                    ("mutation"),
                    ("overflow"),
                    ("overflow_char"),
                    ("profile_geometry"),
                    ("retention_body"),
                    # only VSA-DSS 2015
                    # ("river_bank"),
                    # ("river_bed"),
                    # ("sector_water_body"),
                    ("sludge_treatment"),
                    # ("substance"),
                    ("surface_runoff_parameters"),
                    # ("surface_water_bodies"),
                    ("throttle_shut_off_unit"),
                    ("waste_water_treatment"),
                    ("waste_water_treatment_plant"),
                    # only VSA-DSS 2015
                    # ("water_catchment"),
                    # ("water_control_structure"),
                    # ("water_course_segment"),
                    ("wwtp_energy_use"),
                    ("zone"),
                ]
            )
        if config.MODEL_NAME_CABLE in self.models:
            check_classes.extend(
                [
                    # sia405cc
                    ("sia405cc_cable"),
                    ("sia405cc_cable_point"),
                ]
            )
        if config.MODEL_NAME_PROTECTION_TUBE in self.models:
            check_classes.extend(
                [
                    ("sia405pt_protection_tube"),
                ]
            )
        if config.MODEL_NAME_AG64 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_provider")

    def _check_fk_wastewater_structure_null(self):
        """
        Check if MANDATORY fk_wastewater_structure is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_DSS,
        }
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("structure_part"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_wastewater_structure")

    def _check_fk_wastewater_node_null(self):
        """
        Check if MANDATORY fk_wastewater_node is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("hydraulic_char_data"),
                    ("overflow"),
                    ("throttle_shut_off_unit"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_wastewater_node")

    def _check_fk_responsible_entity_null(self):
        """
        Check if MANDATORY fk_responsible_entity is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("measure"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_responsible_entity")

    def _check_fk_responsible_start_null(self):
        """
        Check if MANDATORY fk_responsible_start is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("measure"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_responsible_start")

    def _check_fk_discharge_point_null(self):
        """
        Check if MANDATORY fk_discharge_point is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("catchment_area_totals"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_discharge_point")

    def _check_fk_hydraulic_char_data_null(self):
        """
        Check if MANDATORY fk_hydraulic_char_data is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("catchment_area_totals"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_hydraulic_char_data")

    def _check_fk_building_group_null(self):
        """
        Check if MANDATORY fk_building_group is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("building_group_baugwr"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_building_group")

    def _check_fk_reach_null(self):
        """
        Check if MANDATORY fk_reach is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_DSS,
        }
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("reach_progression_alternative"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_reach")

    def _check_fk_reach_point_from_null(self):
        """
        Check if MANDATORY fk_reach_point_from is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_from")

    def _check_fk_reach_point_to_null(self):
        """
        Check if MANDATORY fk_reach_point_to is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_to")

    def _check_fk_pwwf_wastewater_node_null(self):
        """
        Check if MANDATORY fk_pwwf_wastewater_node is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("log_card"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_pwwf_wastewater_node")

    def _check_fk_catchment_area_null(self):
        """
        Check if MANDATORY fk_catchment_area is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.models:
            check_classes.extend(
                [
                    ("surface_runoff_parameters"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_catchment_area")

    def _check_organisation_tww_local_extension_count(self):
        """
        Check if there are organisations with tww_local_extension set
        """
        check_classes = [
            # VSA-KEK
            # SIA405 Abwasser
            # VSA-DSS
            ("organisation"),
        ]
        return self._check_available_export_values(
            check_classes,
            "tww_local_extension",
            check_val=None,
            check_null=False,
            check_true=True,
        )
