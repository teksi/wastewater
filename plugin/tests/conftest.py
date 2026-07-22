import subprocess
import sys
import time

import pytest

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


@pytest.fixture
def clean_db():
    run("docker compose exec db dropdb --if-exists tww")
    run("docker compose exec db createdb tww")
    run("docker compose run db pum -s pg_tww -d datamodel install -p SRID 2056")
    yield


@pytest.fixture
def no_qgis(monkeypatch):
    monkeypatch.setitem(sys.modules, "qgis", None)
