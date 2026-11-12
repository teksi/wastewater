from __future__ import annotations

import shlex
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

from ..helpers import run_cli


DB_HOST = "db"
DB_NAME = "tww"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_PORT = "5432"

TWW_TEST_LOG_DIR = Path(
    "/tmp/tww2ili",
)

# Existing QGIS-oriented test data.
DATA_DIR = (
    Path(
        __file__,
    ).parents[1]
    / "qgis"
    / "data"
)

# Fixtures specific to tests/dockerised/hooks.
HOOK_DATA_DIR = (
    Path(
        __file__,
    ).parent
    / "data"
)

ORGANISATIONS_XTF = (
    HOOK_DATA_DIR
    / "test-dataset-organisations.xtf"
)

IMPORTER_CLI_PATH = Path(
    "/usr/src/plugin/"
    "teksi_wastewater/"
    "hooks/"
    "cli/"
    "importer_exporter.py"
)

DB_ARGS = (
    "--pghost",
    DB_HOST,
    "--pgdatabase",
    DB_NAME,
    "--pguser",
    DB_USER,
    "--pgpass",
    DB_PASSWORD,
    "--pgport",
    DB_PORT,
)

REQUIRED_ORGANISATION_OIDS = frozenset(
    {
        "ch080qwzPR000017",
        "ch080qwzPR000018",
        "ch080qwzPR000020",
        "ch080qwzGE000001",
    }
)


@pytest.fixture(
    scope="session",
    autouse=True,
)
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

    assert result.returncode == 0, (
        f"Command failed: {cmd}"
    )

    return result


@pytest.fixture(
    scope="session",
    autouse=True,
)
def wait_for_db() -> None:
    """
    Wait until PostgreSQL accepts direct container-to-container connections.

    Adapter tests run inside the QGIS container and therefore must not execute
    Docker Compose recursively.
    """
    for _ in range(
        30,
    ):
        result = subprocess.run(
            (
                f"pg_isready "
                f"-h {DB_HOST} "
                f"-U {DB_USER} "
                f"-d {DB_NAME}"
            ),
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

    raise RuntimeError(
        "Database not ready."
    )


@pytest.fixture(
    scope="session",
    autouse=True,
)
def configure_database(
    wait_for_db,
) -> None:
    """
    Configure DatabaseUtils for direct container-to-container access.
    """
    DatabaseUtils.databaseConfig.PGSERVICE = None
    DatabaseUtils.databaseConfig.PGHOST = DB_HOST
    DatabaseUtils.databaseConfig.PGPORT = DB_PORT
    DatabaseUtils.databaseConfig.PGDATABASE = DB_NAME
    DatabaseUtils.databaseConfig.PGUSER = DB_USER
    DatabaseUtils.databaseConfig.PGPASS = DB_PASSWORD


@pytest.fixture(
    scope="module",
)
def clean_db_once(
    configure_database,
):
    """
    Reset adapter quarantine schemas once for the requesting test module.

    The GitHub workflow creates and installs the complete database before
    pytest starts:

        dropdb
        createdb
        pum datamodel install

    This fixture deliberately does not reset the live ``tww_od`` state. The
    diff workflow is sequential, and every applied phase becomes the starting
    state for the next phase.
    """
    _drop_and_recreate_schema(
        config.IMPORT_SCHEMA,
    )

    _drop_and_recreate_schema(
        config.EXPORT_SCHEMA,
    )

    incremental_schema = getattr(
        config,
        "IMPORT_SCHEMA_INCR",
        None,
    )

    if (
        isinstance(
            incremental_schema,
            str,
        )
        and incremental_schema.strip()
        and incremental_schema
        not in {
            config.IMPORT_SCHEMA,
            config.EXPORT_SCHEMA,
        }
    ):
        _drop_and_recreate_schema(
            incremental_schema,
        )

    # No teardown follows the yield. The module keeps the database state
    # created by the organisation bootstrap, baseline, and applied phases.
    yield


@pytest.fixture(
    scope="module",
)
def imported_organisations(
    clean_db_once,
) -> None:
    """
    Bootstrap required organisations once for the sequential diff workflow.

    The CLI runs in a separate process and commits the imported organisations
    to the live database. This fixture has no teardown: the trusted baseline
    and all subsequent phases intentionally build on that committed state.

    The fixture is idempotent for local reruns against an already initialized
    database. CI normally reaches the import path because the database starts
    from a fresh PUM installation.
    """
    assert ORGANISATIONS_XTF.is_file(), (
        "Missing organisation fixture: "
        f"{ORGANISATIONS_XTF}"
    )

    missing_before = _missing_required_organisation_oids()

    if missing_before:
        run_cli(
            shlex.join(
                [
                    "interlis_import",
                    "--xtf_file",
                    str(
                        ORGANISATIONS_XTF,
                    ),
                    "--allow-schema-recreation",
                    *DB_ARGS,
                ]
            ),
            IMPORTER_CLI_PATH,
        )

    missing_after = _missing_required_organisation_oids()

    assert not missing_after, (
        "Organisation bootstrap did not create all organisations "
        "required by the diff workflow. Missing canonical OIDs: "
        f"{sorted(missing_after)!r}."
    )


def _missing_required_organisation_oids() -> set[str]:
    """
    Return required canonical organisation OIDs absent from ``tww_od``.

    The query uses one placeholder per value so it works with the project's
    existing DatabaseUtils/psycopg parameter handling without relying on
    PostgreSQL-array adaptation.
    """
    placeholders = ", ".join(
        "%s"
        for _ in REQUIRED_ORGANISATION_OIDS
    )

    required_oids = tuple(
        sorted(
            REQUIRED_ORGANISATION_OIDS,
        )
    )

    rows = DatabaseUtils.execute_fetchall(
        f"""
        SELECT obj_id
        FROM tww_od.organisation
        WHERE obj_id IN (
            {placeholders}
        )
        """,
        required_oids,
    )

    existing_oids = {
        str(
            row["obj_id"],
        )
        for row in rows
    }

    return set(
        REQUIRED_ORGANISATION_OIDS
        - existing_oids
    )


def _drop_and_recreate_schema(
    schema_name: str,
) -> None:
    quoted_schema = schema_name.replace(
        '"',
        '""',
    )

    DatabaseUtils.execute(
        f'DROP SCHEMA IF EXISTS "{quoted_schema}" CASCADE;'
    )

    DatabaseUtils.execute(
        f'CREATE SCHEMA "{quoted_schema}";'
    )


@pytest.fixture(
    scope="module",
)
def quarantine_runner() -> TwwQuarantineRunner:
    return TwwQuarantineRunner()


@pytest.fixture(
    scope="module",
)
def interlis_context() -> TwwInterlisContext:
    return TwwInterlisContext(
        schema=config.IMPORT_SCHEMA,
        srid=2056,
        logs_next_to_file=False,
        filter_nulls=True,
        import_orgs=True,
        orgs_path=(
            DATA_DIR
            / "minimal-dataset-organisation-arbon-only.xtf"
        ),
    )