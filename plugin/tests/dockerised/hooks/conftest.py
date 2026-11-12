from __future__ import annotations

import os
import shlex
import subprocess
import sys
import time
from collections.abc import Sequence
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

DB_HOST = os.getenv("PGHOST", "db")
DB_NAME = os.getenv("PGDATABASE", "tww")
DB_USER = os.getenv("PGUSER", "postgres")
DB_PASSWORD = os.getenv("PGPASSWORD", "postgres")
DB_PORT = os.getenv("PGPORT", "5432")

PLUGIN_ROOT = Path("/usr/src/plugin")

TWW_TEST_LOG_DIR = Path("/tmp/tww2ili")

DOCKERISED_TEST_DIR = Path(__file__).resolve().parents[1]

# Existing QGIS-oriented test data. The hooks tests already run inside the
# container, so these are local filesystem paths, not Docker-host paths.
DATA_DIR = DOCKERISED_TEST_DIR / "qgis" / "data"

# Fixtures specific to tests/dockerised/hooks.
HOOK_DATA_DIR = Path(__file__).resolve().parent / "data"

ORGANISATIONS_XTF = HOOK_DATA_DIR / "test-dataset-organisations.xtf"

# Run the packaged hooks CLI with the same Python interpreter that runs pytest.
# In CI, this is expected to be /tmp/teksi-hooks-venv/bin/python.
IMPORTER_CLI_PATH = PLUGIN_ROOT / "teksi_wastewater" / "hooks" / "cli" / "importer_exporter.py"

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
    command: Sequence[str],
    *,
    expected_returncode: int = 0,
) -> subprocess.CompletedProcess[str]:
    """
    Run a command directly in the current hooks test container.

    These tests already execute inside the plugin container. They must not
    invoke ``docker compose exec`` recursively.
    """
    result = subprocess.run(
        list(command),
        cwd=PLUGIN_ROOT,
        env=os.environ.copy(),
        capture_output=True,
        text=True,
        check=False,
    )

    print("COMMAND")
    print(
        shlex.join(
            command,
        )
    )
    print("STDOUT")
    print(
        result.stdout,
    )
    print("STDERR")
    print(
        result.stderr,
    )

    assert result.returncode == expected_returncode, (
        f"Command returned {result.returncode}; "
        f"expected {expected_returncode}.\n"
        f"Command: {shlex.join(command)}\n"
        f"STDOUT:\n{result.stdout}\n"
        f"STDERR:\n{result.stderr}"
    )

    return result


def run_interlis_cli(
    arguments: Sequence[str],
    *,
    expected_returncode: int = 0,
) -> subprocess.CompletedProcess[str]:
    """
    Run the packaged hooks CLI directly with the active Python interpreter.
    """
    assert IMPORTER_CLI_PATH.is_file(), f"Missing packaged hooks CLI: {IMPORTER_CLI_PATH}"

    return run(
        (
            sys.executable,
            str(
                IMPORTER_CLI_PATH,
            ),
            *arguments,
        ),
        expected_returncode=expected_returncode,
    )


@pytest.fixture(
    scope="session",
    autouse=True,
)
def wait_for_db() -> None:
    """
    Wait until PostgreSQL accepts direct container-to-container connections.
    """
    command = (
        "pg_isready",
        "-h",
        DB_HOST,
        "-p",
        DB_PORT,
        "-U",
        DB_USER,
        "-d",
        DB_NAME,
    )

    for attempt in range(
        1,
        31,
    ):
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=False,
        )

        if result.stdout:
            print(
                result.stdout,
            )

        if result.stderr:
            print(
                result.stderr,
            )

        if result.returncode == 0:
            return

        if attempt < 30:
            time.sleep(
                2,
            )

    raise RuntimeError(
        "Database did not become ready after 60 seconds. " f"Command: {shlex.join(command)}"
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

    the complete database before pytest starts. This
    fixture deliberately preserves the live ``tww_od`` state because every
    applied diff phase becomes the starting state for the next phase.
    """
    schemas = [
        config.IMPORT_SCHEMA,
        config.EXPORT_SCHEMA,
    ]

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
        and incremental_schema not in schemas
    ):
        schemas.append(
            incremental_schema,
        )

    for schema_name in schemas:
        _drop_and_recreate_schema(
            schema_name,
        )

    # No teardown. The sequential workflow intentionally retains applied data.
    yield


@pytest.fixture(
    scope="module",
)
def imported_organisations(
    clean_db_once,
) -> None:
    """
    Bootstrap organisations required by the sequential diff workflow.

    The fixture is idempotent for local reruns against an initialized
    database. CI normally imports the fixture after a fresh PUM installation.
    """
    assert ORGANISATIONS_XTF.is_file(), f"Missing organisation fixture: {ORGANISATIONS_XTF}"

    missing_before = _missing_required_organisation_oids()

    if missing_before:
        run_interlis_cli(
            (
                "interlis_import",
                "--xtf_file",
                str(
                    ORGANISATIONS_XTF,
                ),
                "--allow-schema-recreation",
                *DB_ARGS,
            )
        )

    missing_after = _missing_required_organisation_oids()

    assert not missing_after, (
        "Organisation bootstrap did not create all organisations "
        "required by the diff workflow. Missing canonical OIDs: "
        f"{sorted(missing_after)!r}."
    )


def _missing_required_organisation_oids() -> set:
    """
    Return required canonical organisation OIDs absent from ``tww_od``.
    """
    required_oids = tuple(
        sorted(
            REQUIRED_ORGANISATION_OIDS,
        )
    )

    if not required_oids:
        return set()

    placeholders = ", ".join("%s" for _ in required_oids)

    rows = DatabaseUtils.fetchall(
        f"""
        SELECT obj_id
        FROM tww_od.organisation
        WHERE obj_id IN (
            {placeholders}
        );
        """,
        required_oids,
    )

    # DatabaseUtils.fetchall() returns ordinary tuple rows, not dictionaries.
    existing_oids = {
        str(
            row[0],
        )
        for row in rows
    }

    return (
        set(
            required_oids,
        )
        - existing_oids
    )


def _drop_and_recreate_schema(
    schema_name: str,
) -> None:
    """
    Recreate one known quarantine schema using quoted SQL identifiers.
    """
    assert schema_name, "Schema name must not be empty."

    drop_schema = DatabaseUtils.compose_sql(
        "DROP SCHEMA IF EXISTS {} CASCADE;",
        DatabaseUtils.wrap_identifier(
            schema_name,
        ),
    )

    create_schema = DatabaseUtils.compose_sql(
        "CREATE SCHEMA {};",
        DatabaseUtils.wrap_identifier(
            schema_name,
        ),
    )

    DatabaseUtils.execute(
        drop_schema,
    )

    DatabaseUtils.execute(
        create_schema,
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
    organisations_file = DATA_DIR / "minimal-dataset-organisation-arbon-only.xtf"

    assert organisations_file.is_file(), f"Missing organisation fixture: {organisations_file}"

    return TwwInterlisContext(
        schema=config.IMPORT_SCHEMA,
        srid=2056,
        logs_next_to_file=False,
        filter_nulls=True,
        import_orgs=True,
        orgs_path=organisations_file,
        allow_schema_recreation=True,
    )
