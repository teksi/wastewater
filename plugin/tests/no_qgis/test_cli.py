import pytest

from .helpers import run_cli


@pytest.mark.no_qgis
def test_interlis_importer_exporter_importable_without_qgis():

    from teksi_wastewater.interlis.utils.ili2db import InterlisTools

    assert InterlisTools is not None

    from teksi_wastewater.interlis.interlis_importer_exporter import (
        InterlisImporterExporter,
    )

    assert InterlisImporterExporter is not None


@pytest.mark.no_qgis
def test_import_orgs(clean_db):
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-organisation-arbon-only.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )


@pytest.mark.no_qgis
def test_import_sia405(clean_db):
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-SIA405-ABWASSER.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )


@pytest.mark.no_qgis
def test_export(clean_db):
    run_cli(
        "interlis_export "
        '--xtf_file "output.xtf" '
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
