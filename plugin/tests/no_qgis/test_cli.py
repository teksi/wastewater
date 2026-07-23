from decimal import Decimal
from pathlib import Path

import pytest
from teksi_wastewater.interlis import config
from teksi_wastewater.utils.database_utils import DatabaseUtils

from .helpers import (
    get_output_filename,
    get_xtf_object,
    get_xtf_object_node_text,
    run_cli,
)

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)


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

    result = DatabaseUtils.fetchone(
        "SELECT identifier FROM tww_od.organisation WHERE obj_id='ch20p3q400001497';"
    )
    assert result[0] == "Arbon"


@pytest.mark.no_qgis
def test_import_sia405():
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-SIA405-ABWASSER.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )

    result = DatabaseUtils.fetchone(
        "SELECT obj_id FROM tww_od.reach WHERE obj_id='ch000000RE000001';"
    )
    assert result

    result = DatabaseUtils.fetchone(
        "SELECT remark FROM tww_od.wastewater_networkelement WHERE obj_id='ch000000RE000001';"
    )
    assert result[0] == "rp_from_level added"

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
    )
    assert result[0] == 448.0

    # check on height_width_ratio decimal(8,5) instead of decimal(5,2)
    result = DatabaseUtils.fetchone(
        "SELECT height_width_ratio FROM tww_od.pipe_profile WHERE obj_id='ch000000PP000003';"
    )

    # adapted after November 2025 patch is online
    assert result[0] == Decimal("1.12857")


@pytest.mark.no_qgis
def test_import_dss():
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-DSS.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )

    result = DatabaseUtils.fetchone(
        "SELECT obj_id FROM tww_od.pipe_profile WHERE obj_id='ch000000PP000001';"
    )
    assert result

    # Check that we don't loose Z information on second import
    result = DatabaseUtils.fetchone(
        "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
    )
    assert result[0] == 448.0


@pytest.mark.no_qgis
def test_import_kek():
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-VSA-KEK-manhole-damage.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )

    result = DatabaseUtils.fetchone(
        "SELECT fk_maintenance_event FROM tww_od.re_maintenance_event_wastewater_structure WHERE fk_wastewater_structure='ch000000WS000001';"
    )
    assert result[0] == "fk11abk6EX000002"
    # Check that we don't loose Z information on third import
    result = DatabaseUtils.fetchone(
        "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
    )
    assert result[0] == 448.0


@pytest.mark.no_qgis
def test_export_sia405_base_abwasser():
    DatabaseUtils.execute("UPDATE tww_od.organisation SET tww_local_extension=true;")
    output_file = OUTPUT_DIR / "export_minimal_dataset_sia405_base.xtf"
    run_cli(
        "interlis_export "
        f'--xtf_file "{output_file}" '
        f"--models {config.MODEL_NAME_SIA405_BASE_ABWASSER} "
        "--logs_next_to_file"
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
    exported_xtf_filename = get_output_filename(
        f"{output_file}_{config.MODEL_NAME_SIA405_BASE_ABWASSER}.xtf"
    )
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_SIA405_ADMINISTRATION,
        "Organisation",
        "ch20p3q400001497",
    )
    assert interlis_object


@pytest.mark.no_qgis
def test_export_sia405_abwasser():
    output_file = OUTPUT_DIR / "export_minimal_dataset_sia405.xtf"
    run_cli(
        "interlis_export "
        f'--xtf_file "{output_file}" '
        f"--models {config.MODEL_NAME_SIA405_ABWASSER} "
        "--logs_next_to_file"
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
    exported_xtf_filename = get_output_filename(
        f"{output_file}_{config.MODEL_NAME_SIA405_ABWASSER}.xtf"
    )
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_SIA405_ABWASSER,
        "Haltung",
        "ch000000RE000001",
    )
    assert interlis_object

    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_SIA405_ABWASSER,
        "Rohrprofil",
        "ch000000PP000003",
    )
    assert interlis_object

    HoehenBreitenverhaeltnis_Text = get_xtf_object_node_text(
        exported_xtf_filename,
        config.TOPIC_NAME_SIA405_ABWASSER,
        "Rohrprofil",  # classname
        "ch000000PP000003",  # tid
        "HoehenBreitenverhaeltnis",  # attributename
    )

    assert HoehenBreitenverhaeltnis_Text == "1.12857"


@pytest.mark.no_qgis
def test_export_dss():
    output_file = OUTPUT_DIR / "export_minimal_dataset_dss.xtf"
    run_cli(
        "interlis_export "
        f'--xtf_file "{output_file}" '
        f"--models {config.MODEL_NAME_DSS}"
        "--logs_next_to_file"
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
    exported_xtf_filename = get_output_filename(f"{output_file}_{config.MODEL_NAME_DSS}.xtf")
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_DSS,
        "Rohrprofil",
        "ch000000PP000001",
    )
    assert interlis_object

    run_cli(
        "interlis_export "
        f'--xtf_file "{output_file}" '
        f"--models {config.MODEL_NAME_DSS}"
        '--selection "ch000000WN000002","ch000000WN000003","ch000000RE000002"'
        "--logs_next_to_file"
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_DSS,
        "Rohrprofil",
        "ch000000PP000001",
    )
    assert interlis_object
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_DSS,
        "Rohrprofil",
        "ch000000PP000002",
    )
    assert interlis_object


@pytest.mark.no_qgis
def test_export_kek():
    output_file = OUTPUT_DIR / "export_minimal_dataset_kek.xtf"
    run_cli(
        "interlis_export "
        f'--xtf_file "{output_file}" '
        f"--models {config.MODEL_NAME_VSA_KEK}"
        "--logs_next_to_file"
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )
    exported_xtf_filename = get_output_filename(f"{output_file}_{config.MODEL_NAME_VSA_KEK}.xtf")
    interlis_object = get_xtf_object(
        exported_xtf_filename,
        config.TOPIC_NAME_KEK,
        "Untersuchung",
        "fk11abk6EX000002",
    )
    assert interlis_object


@pytest.mark.no_qgis
def test_import_sia405():
    run_cli(
        "interlis_import "
        "--xtf_file /usr/src/plugin/tests/qgis/data/minimal-dataset-SIA405-ABWASSER.xtf "
        "--pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432"
    )

    result = DatabaseUtils.fetchone(
        "SELECT obj_id FROM tww_od.reach WHERE obj_id='ch000000RE000001';"
    )
    assert result

    result = DatabaseUtils.fetchone(
        "SELECT remark FROM tww_od.wastewater_networkelement WHERE obj_id='ch000000RE000001';"
    )
    assert result[0] == "rp_from_level modified"

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
    )
    assert result[0] == 448.0
