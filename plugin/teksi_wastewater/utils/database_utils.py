import collections
import configparser
import os
import re

from .plugin_utils import logger

try:
    import psycopg

    PSYCOPG_VERSION = 3
    DEFAULTS_CONN_ARG = {"autocommit": True}
except ImportError:
    import psycopg2 as psycopg

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
            PG_CONFIG_PATH = os.path.expanduser("~/.pg_service.conf")
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

            logger.info("update_wastewater_node_symbology for all datasets - please be patient")
            cursor.execute("SELECT tww_app.update_wastewater_node_symbology(NULL, True);")
            logger.info("update_wastewater_structure_label for all datasets - please be patient")
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

        msg_list = []
        if len(prefixes) > 1:
            msg_list.append(
                "more than one oid_prefix set to active. Generation of Object-ID will not work. Set the OID prefix for your production database to active."
            )

        if len(prefixes) > 0:
            active_pref = prefixes[0][0]
            if active_pref == "ch000000":
                msg_list.append("OID prefix set to 'ch000000'. Database not safe for production")

        return msg_list

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
            msg_list.append("There is an undefined default value in tww_od.default_values")
        elif not all(x in defaults for x in ["fk_provider", "fk_dataowner"]):
            msg_list.append("'fk_provider' or 'fk_dataowner' not set in tww_od.default_values")

        return msg_list

    @staticmethod
    def get_validity_check_issues() -> list[str]:
        messages = []
        messages = DatabaseUtils.check_oid_prefix()
        messages.extend(DatabaseUtils.check_fk_defaults())

        if not DatabaseUtils.check_symbology_triggers_enabled():
            messages.append("Symbology triggers are disabled")

        return messages
