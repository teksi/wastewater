import collections
import configparser
import datetime
import logging
import os
import subprocess
import tempfile
import time
from typing import List

from .. import config


class DeduplicatedLogger(logging.Logger):
    """Logger that deduplicates messages

    Multiple subsequent logging with the same message/level will result in [repeated N times]
    message instead of many lines.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._last_message = None
        self._repeated = 0

    def _log(self, level, msg, args, exc_info=None, extra=None):
        this_message = (level, msg)
        if self._last_message is None or self._last_message != this_message:
            if self._repeated > 0:
                super()._log(
                    self._last_message[0],
                    f"[repeted {self._repeated} times]",
                    args,
                    exc_info,
                    extra,
                )

            super()._log(level, msg, args, exc_info, extra)
            self._repeated = 0
        else:
            self._repeated += 1
        self._last_message = this_message


logging.setLoggerClass(DeduplicatedLogger)
logger = logging.getLogger(__package__)


class CmdException(BaseException):
    pass


def exec_(command, check=True, output_content=False):
    logger.info(f"EXECUTING: {command}")
    try:
        proc = subprocess.run(
            command,
            check=True,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
    except subprocess.CalledProcessError as e:
        if check:
            logger.exception(e.output.decode("windows-1252" if os.name == "nt" else "utf-8"))
            raise CmdException("Command errored ! See logs for more info.")
        return e.output if output_content else e.returncode
    return proc.stdout.decode().strip() if output_content else proc.returncode


def setup_test_db(template="full"):
    """
    As initializing demo data can be a bit slow,
    we do these steps in a Docker container then commit it to an image, so we can
    start a clean database relatively quickly.

    We prepare two template databases : full, empty
    And then copy those to config.PGDATABASE when needed to initialize an fresh db
    for testing.
    """

    pgconf = get_pgconf()

    def dexec_(cmd, check=True):
        return exec_(f"docker exec twwqwat {cmd}", check)

    docker_image = os.getenv("TWWQWAT2ILI_TESTDB_IMAGE", "postgis/postgis:13-3.2")

    logger.info(f"SETTING UP TWW/QWAT DATABASE [{docker_image}]...")

    r = exec_("docker inspect -f '{{.State.Running}}' twwqwat", check=False)
    running = r == 0
    if running:
        r = exec_("docker inspect -f {{.Config.Image}} twwqwat", output_content=True)
        if r != docker_image:
            logger.info(f"Test container running `{r}`, we expect `{docker_image}`, we kill it")
            exec_("docker rm twwqwat --force")
            running = False

    if not running:
        logger.info("Test container not running, we create it")
        exec_(
            f"docker run -d --rm -p 5432:5432 --name twwqwat -e POSTGRES_PASSWORD={pgconf['password'] or 'postgres'} -e POSTGRES_DB={pgconf['dbname'] or 'tww_prod'} {docker_image}"
        )

    # Wait for PG
    while exec_("docker exec twwqwat pg_isready", check=False) != 0:
        logger.info("Postgres not ready... we wait...")
        time.sleep(1)

    db_didnt_exist = (
        dexec_("createdb -U postgres tpl_empty", check=False) == 0
        or dexec_("createdb -U postgres tpl_full", check=False) == 0
    )
    if db_didnt_exist:
        logger.info("Test templates don't exist, we create them")

        dexec_("dropdb -U postgres tpl_empty --if-exists")
        dexec_("dropdb -U postgres tpl_full --if-exists")

        dexec_("apt-get update")
        dexec_("apt-get install -y wget")

        # Getting data
        dexec_(
            "wget https://github.com/TWW/datamodel/releases/download/1.5.6-1/tww_1.5.6-1_structure_and_demo_data.backup"
        )
        dexec_(
            "wget https://github.com/TWW/datamodel/releases/download/1.5.6-1/tww_1.5.6-1_structure_with_value_lists.sql"
        )
        dexec_(
            "wget https://github.com/qwat/qwat-data-model/releases/download/1.3.6/qwat_v1.3.6_data_and_structure_sample.backup"
        )
        dexec_(
            "wget https://github.com/qwat/qwat-data-model/releases/download/1.3.6/qwat_v1.3.6_structure_only.sql"
        )
        dexec_(
            "wget https://github.com/qwat/qwat-data-model/releases/download/1.3.6/qwat_v1.3.6_value_list_data_only.sql"
        )

        # Creating the template DB with empty structure
        dexec_("psql -f tww_1.5.6-1_structure_with_value_lists.sql tww_prod postgres")
        dexec_("psql -f qwat_v1.3.6_structure_only.sql tww_prod postgres")
        dexec_("psql -f qwat_v1.3.6_value_list_data_only.sql tww_prod postgres")
        dexec_("createdb -U postgres --template=tww_prod tpl_empty")

        # Creating the template DB with full data
        dexec_(
            'psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid<>pg_backend_pid();"'
        )
        dexec_("dropdb -U postgres tww_prod --if-exists")
        dexec_("createdb -U postgres tww_prod")
        dexec_(
            "pg_restore -U postgres --dbname tww_prod --verbose --no-privileges --exit-on-error tww_1.5.6-1_structure_and_demo_data.backup"
        )
        dexec_(
            "pg_restore -U postgres --dbname tww_prod --verbose --no-privileges --exit-on-error qwat_v1.3.6_data_and_structure_sample.backup"
        )
        dexec_("createdb -U postgres --template=tww_prod tpl_full")

        # Hotfix tww invalid demo data
        delta_path = os.path.join(
            os.path.dirname(__file__), "..", "data", "test_data", "tww_demodata_hotfix.sql"
        )
        exec_(f"docker cp {delta_path} twwqwat:/tww_demodata_hotfix.sql")
        dexec_("psql -U postgres -d tpl_full -v ON_ERROR_STOP=1 -f /tww_demodata_hotfix.sql")

        # Hotfix qwat invalid demo data
        delta_path = os.path.join(
            os.path.dirname(__file__), "..", "data", "test_data", "qwat_demodata_hotfix.sql"
        )
        exec_(f"docker cp {delta_path} twwqwat:/qwat_demodata_hotfix.sql")
        dexec_("psql -U postgres -d tpl_full -v ON_ERROR_STOP=1 -f /qwat_demodata_hotfix.sql")

    dexec_(
        'psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid<>pg_backend_pid();"'
    )
    dexec_("dropdb -U postgres tww_prod --if-exists")
    dexec_(f"createdb -U postgres --template=tpl_{template} tww_prod")


def capfirst(s):
    return s[0].upper() + s[1:]


def invert_dict(d):
    return {v: k for k, v in d.items()}


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


def get_pgconf():
    """
    Returns the postgres configuration (parsed from the config.PGSERVICE service and overriden by config.PG* settings)
    """

    if config.PGSERVICE:
        pgconf = read_pgservice(config.PGSERVICE)
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


def get_pgconf_as_psycopg2_dsn() -> List[str]:
    """Returns the pgconf as a psycopg2 connection string"""

    pgconf = get_pgconf()
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


def get_pgconf_as_ili_args() -> List[str]:
    """Returns the pgconf as a list of ili2db arguments"""
    pgconf = get_pgconf()
    args = []
    if pgconf["host"]:
        args.extend(["--dbhost", '"' + pgconf["host"] + '"'])
    if pgconf["port"]:
        args.extend(["--dbport", '"' + pgconf["port"] + '"'])
    if pgconf["user"]:
        args.extend(["--dbusr", '"' + pgconf["user"] + '"'])
    if pgconf["password"]:
        args.extend(["--dbpwd", '"' + pgconf["password"] + '"'])
    if pgconf["dbname"]:
        args.extend(["--dbdatabase", '"' + pgconf["dbname"] + '"'])
    return args


def make_log_path(next_to_path, step_name):
    """Returns a path for logging purposes. If next_to_path is None, it will be saved in the temp directory"""
    now = f"{datetime.datetime.now():%y%m%d%H%M%S}"
    if next_to_path:
        return f"{next_to_path}.{now}.{step_name}.log"
    else:
        temp_path = os.path.join(tempfile.gettempdir(), "tww2ili")
        os.makedirs(temp_path, exist_ok=True)
        return os.path.join(temp_path, f"{now}.{step_name}.log")


class LoggingHandlerContext:
    """Temporarily sets a log handler, then removes it"""

    def __init__(self, handler):
        self.handler = handler

    def __enter__(self):
        logger.addHandler(self.handler)

    def __exit__(self, et, ev, tb):
        logger.removeHandler(self.handler)
        self.handler.close()
        # implicit return of None => don't swallow exceptions
