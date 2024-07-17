import collections
import configparser
import os
from typing import List

from ..interlis import config
from .plugin_utils import logger

try:
    import psycopg

    PSYCOPG_VERSION = 3
    DEFAULTS_CONN_ARG = {"autocommit": True}
except ImportError:
    import psycopg2 as psycopg

    PSYCOPG_VERSION = 2
    DEFAULTS_CONN_ARG = {}


class DatabaseUtils:

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
    def read_pgservice(service_name):
        """
        Returns a config object from a pg_service name (parsed from PGSERVICEFILE).
        """

        # Path for pg_service.conf
        if os.environ.get("PGSERVICEFILE"):
            PG_CONFIG_PATH = os.environ.get("PGSERVICEFILE")
        elif os.environ.get("PGSYSCONFDIR"):
            PG_CONFIG_PATH = os.path.join(os.environ.get("PGSYSCONFDIR"), "pg_service.conf")
        else:
            PG_CONFIG_PATH = os.path.expanduser("~/.pg_service.conf")

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

        if config.PGSERVICE:
            pgconf = DatabaseUtils.read_pgservice(config.PGSERVICE)
        else:
            pgconf = {}

        if config.PGHOST:
            pgconf["host"] = config.PGHOST
        if config.PGPORT:
            pgconf["port"] = config.PGPORT
        if config.PGDATABASE:
            pgconf["dbname"] = config.PGDATABASE
        if config.PGUSER:
            pgconf["user"] = config.PGUSER
        if config.PGPASS:
            pgconf["password"] = config.PGPASS

        return collections.defaultdict(str, pgconf)

    @staticmethod
    def get_pgconf_as_psycopg_dsn() -> List[str]:
        """Returns the pgconf as a psycopg connection string"""

        pgconf = DatabaseUtils.get_pgconf()
        parts = []
        if pgconf["host"]:
            parts.append(f"host={pgconf['host']}")
        if pgconf["port"]:
            parts.append(f"port={pgconf['port']}")
        if pgconf["user"]:
            parts.append(f"dbname={pgconf['dbname']}")
        if pgconf["password"]:
            parts.append(f"user={pgconf['user']}")
        if pgconf["dbname"]:
            parts.append(f"password={pgconf['password']}")
        return " ".join(parts)

    @staticmethod
    def disable_symbology_triggers():
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("Disable symbology triggers")
            cursor.execute("SELECT tww_sys.disable_symbology_triggers();")

    @staticmethod
    def enable_symbology_triggers():
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("Enable symbology triggers")
            cursor.execute("SELECT tww_sys.enable_symbology_triggers();")

    @staticmethod
    def check_symbology_triggers_enabled():
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("Enable symbology triggers")
            cursor.execute("SELECT tww_sys.check_symbology_triggers_enabled();")

            row = cursor.fetchone()
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
    def get_psycopg_connection():
        connection = psycopg.connect(
            DatabaseUtils.get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG
        )
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)
