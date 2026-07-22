import subprocess

import pytest


def run_qgis_tests(args=""):
    cmd = f"""
    docker compose exec qgis
    /usr/src/plugin/.docker/run-docker-tests.sh {args}
    """
    result = subprocess.run(cmd, shell=True)
    assert result.returncode == 0


@pytest.mark.qgis
def test_all_except_dss(clean_db):
    run_qgis_tests(
        "--deselect teksi_wastewater/tests/test_interlis.py::TestInterlis::test_dss_dataset_import_export"
    )


@pytest.mark.qgis
def test_dss(clean_db):
    run_qgis_tests(
        "teksi_wastewater/tests/test_interlis.py::TestInterlis::test_dss_dataset_import_export"
    )
