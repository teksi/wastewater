import subprocess
import sys
import time

import pytest

from teksi_wastewater.utils.database_utils import DatabaseUtils


DB_CONTAINER = "db"


def run(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)
    assert result.returncode == 0, f"Command failed: {cmd}"
    return result


@pytest.fixture(scope="session", autouse=True)
def wait_for_db():
    for _ in range(30):
        res = subprocess.run(
            f"docker compose exec {DB_CONTAINER} pg_isready -U postgres",
            shell=True,
        )
        if res.returncode == 0:
            return
        time.sleep(2)
    raise RuntimeError("Database not ready")


@pytest.fixture(autouse=True)
def forbid_qgis_import(request, monkeypatch):
    if request.node.get_closest_marker("no_qgis"):
        monkeypatch.setitem(sys.modules, "qgis", None)


@pytest.fixture(scope="module")
def clean_db_once():
    run('docker compose exec db sh -c "dropdb -U postgres --if-exists tww"')
    run('docker compose exec db sh -c "createdb -U postgres tww"')
    run("docker compose run pum -p pg_tww -d datamodel install -p SRID 2056")
    yield

@pytest.fixture(scope="module", autouse=True)
def configure_database():
    DatabaseUtils.databaseConfig.PGSERVICE = None

    DatabaseUtils.databaseConfig.PGHOST = "db"
    DatabaseUtils.databaseConfig.PGPORT = "5432"
    DatabaseUtils.databaseConfig.PGDATABASE = "tww"
    DatabaseUtils.databaseConfig.PGUSER = "postgres"
    DatabaseUtils.databaseConfig.PGPASS = "postgres"