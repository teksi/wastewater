import subprocess
import time
from pathlib import Path

import pytest
from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
)
from teksi_wastewater.hooks.adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from teksi_wastewater.interlis import config
from teksi_wastewater.utils.database_utils import DatabaseUtils

DB_HOST = "db"
DB_NAME = "tww"
DB_USER = "postgres"
DB_PASSWORD = "postgres"

TWW_TEST_LOG_DIR = Path(
    "/tmp/tww2ili",
)


DATA_DIR = Path(__file__).parents[1] / "qgis" / "data"


@pytest.fixture(scope="session", autouse=True)
def ensure_interlis_log_dir() -> None:
    TWW_TEST_LOG_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )


def run(
    cmd: str,
):
    result = subprocess.run(
        cmd,
        shell=True,
        capture_output=True,
        text=True,
    )

    print(
        result.stdout,
    )
    print(
        result.stderr,
    )

    assert result.returncode == 0, f"Command failed: {cmd}"

    return result


@pytest.fixture(scope="session", autouse=True)
def wait_for_db() -> None:
    """
    Adapter tests are executed inside the qgis container.

    Therefore they connect to the db service directly and must not call
    docker compose from inside the container.
    """

    for _ in range(
        30,
    ):
        result = subprocess.run(
            f"pg_isready -h {DB_HOST} -U {DB_USER}",
            shell=True,
            capture_output=True,
            text=True,
        )

        print(
            result.stdout,
        )
        print(
            result.stderr,
        )

        if result.returncode == 0:
            return

        time.sleep(
            2,
        )

    raise RuntimeError("Database not ready")


@pytest.fixture(scope="session", autouse=True)
def configure_database() -> None:
    """
    Configure DatabaseUtils for direct container-to-container access.
    """

    DatabaseUtils.databaseConfig.PGSERVICE = None
    DatabaseUtils.databaseConfig.PGHOST = DB_HOST
    DatabaseUtils.databaseConfig.PGPORT = "5432"
    DatabaseUtils.databaseConfig.PGDATABASE = DB_NAME
    DatabaseUtils.databaseConfig.PGUSER = DB_USER
    DatabaseUtils.databaseConfig.PGPASS = DB_PASSWORD


@pytest.fixture(scope="module")
def clean_db_once(
    configure_database,
):
    """
    Clean only the adapter-relevant quarantine schemas.

    The full database is created and initialized by the GitHub workflow before
    pytest starts:

        dropdb
        createdb
        pum datamodel install

    These tests run inside the qgis container, so they must not call
    docker compose.
    """

    _drop_and_recreate_schema(
        config.IMPORT_SCHEMA,
    )

    _drop_and_recreate_schema(
        config.EXPORT_SCHEMA,
    )

    yield


def _drop_and_recreate_schema(
    schema_name: str,
) -> None:
    quoted_schema = schema_name.replace(
        '"',
        '""',
    )

    DatabaseUtils.execute(f'DROP SCHEMA IF EXISTS "{quoted_schema}" CASCADE;')

    DatabaseUtils.execute(f'CREATE SCHEMA "{quoted_schema}";')


@pytest.fixture(scope="module")
def quarantine_runner() -> TwwQuarantineRunner:
    return TwwQuarantineRunner()


@pytest.fixture(scope="module")
def interlis_context() -> TwwInterlisContext:
    return TwwInterlisContext(
        schema=config.IMPORT_SCHEMA,
        srid=2056,
        logs_next_to_file=False,
        filter_nulls=True,
        import_orgs=True,
        orgs_path=DATA_DIR / "minimal-dataset-organisation-arbon-only.xtf",
    )
