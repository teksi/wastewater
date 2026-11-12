from __future__ import annotations

from decimal import Decimal
from pathlib import Path
from typing import Any

import pytest
from teksi_wastewater.interlis import model_config
from teksi_wastewater.utils.database_utils import DatabaseUtils

from ..helpers import (
    get_xtf_object,
    get_xtf_object_node_text,
    run_cli,
)

pytestmark = pytest.mark.no_qgis


DATA_DIR = Path("/usr/src/plugin/tests/dockerised/qgis/data")
CONTAINER_OUTPUT_DIR = Path("/usr/src/plugin/tests/dockerised/no_qgis/output")

OUTPUT_DIR = Path(__file__).resolve().parent / "output"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

DB_ARGS = (
    "--pghost db " "--pgdatabase tww " "--pguser postgres " "--pgpass postgres " "--pgport 5432"
)

# These tests operate on a disposable database and intentionally reuse the
# quarantine schemas across a sequence of imports and exports.
SCHEMA_RECREATION_ARG = "--allow-schema-recreation"

ORGANISATION_ID = "ch20p3q400001497"
REACH_ID = "ch000000RE000001"
WASTEWATER_NODE_ID = "ch000000WN000001"
PIPE_PROFILE_ID = "ch000000PP000003"
KEK_EXAMINATION_ID = "fk11abk6EX000002"
WASTEWATER_STRUCTURE_ID = "ch000000WS000001"


def _data_file(name: str) -> Path:
    """
    Return a required XTF test fixture.

    The assertion deliberately happens before invoking the CLI so a missing
    container mount or stale image produces a focused test failure.
    """
    path = DATA_DIR / name

    assert path.is_file(), (
        f"Missing INTERLIS test fixture: {path}. "
        "Ensure the current plugin checkout is mounted into the qgis container."
    )

    return path


def _container_output_file(name: str) -> Path:
    return CONTAINER_OUTPUT_DIR / f"{name}.xtf"


def _host_exported_file(
    base_name: str,
    model_name: str,
) -> Path:
    return OUTPUT_DIR / f"{base_name}_{model_name}.xtf"


def _model_name(
    group: str,
    *,
    lang: str = "de",
) -> str:
    """
    Return the configured language-specific model name for a model group.
    """
    return model_config.interlis_models[group].lang_name(lang)


def _topic_name(
    group: str,
    *,
    lang: str = "de",
) -> str:
    """
    Return the only configured topic for a model group and language.

    Every model used by these fixtures currently exposes one transfer topic.
    Fail clearly if a future model definition changes that assumption.
    """
    topics = model_config.interlis_models[group].topics_by_lang(lang)

    assert len(topics) == 1, (
        "Expected exactly one topic for INTERLIS group "
        f"{group!r} and language {lang!r}, got {sorted(topics)!r}."
    )

    return next(iter(topics))


def _run_interlis_import(
    fixture_name: str,
    *,
    incremental_only: bool = False,
) -> None:
    """
    Import one XTF fixture through the packaged TEKSI hooks CLI.

    ``run_cli`` is expected to invoke the packaged CLI and to fail when the
    command exits with a non-zero status.
    """
    xtf_file = _data_file(fixture_name)

    incremental_arg = "--incremental_only " if incremental_only else ""

    run_cli(
        "interlis_import "
        f'--xtf_file "{xtf_file}" '
        f"{incremental_arg}"
        f"{SCHEMA_RECREATION_ARG} "
        f"{DB_ARGS}"
    )


def _run_interlis_export(
    *,
    base_name: str,
    model_group: str,
    selected_ids: tuple[str, ...] = (),
) -> Path:
    """
    Export one model and return the host-visible output path.
    """
    export_model = _model_name(model_group)
    container_output = _container_output_file(base_name)
    host_output = _host_exported_file(base_name, export_model)

    # Prevent an output left by an earlier run from satisfying the test.
    host_output.unlink(missing_ok=True)

    selected_ids_arg = f'--selected_ids "{",".join(selected_ids)}" ' if selected_ids else ""

    run_cli(
        "interlis_export "
        f'--xtf_file "{container_output}" '
        f'--export_model "{export_model}" '
        f"{selected_ids_arg}"
        "--logs_next_to_file "
        f"{SCHEMA_RECREATION_ARG} "
        f"{DB_ARGS}"
    )

    assert host_output.is_file(), (
        "INTERLIS export command completed without creating the expected "
        f"host-visible output file: {host_output}"
    )

    return host_output


def _fetchone(
    query: str,
) -> Any:
    """
    Execute a query that must return one row.
    """
    result = DatabaseUtils.fetchone(query)

    assert result is not None, (
        "Expected the database query to return one row:\n" f"{query.strip()}"
    )

    return result


def _assert_scalar(
    query: str,
    expected: Any,
) -> None:
    """
    Assert the first column of a required database row.
    """
    result = _fetchone(query)

    assert result[0] == expected, (
        f"Expected {expected!r}, got {result[0]!r} for query:\n" f"{query.strip()}"
    )


@pytest.fixture(scope="module")
def imported_orgs(
    clean_db_once,
) -> None:
    _run_interlis_import(
        "minimal-dataset-organisation-arbon-only.xtf",
    )


@pytest.fixture(scope="module")
def imported_sia405(
    imported_orgs,
) -> None:
    _run_interlis_import(
        "minimal-dataset-SIA405-ABWASSER.xtf",
    )


@pytest.fixture(scope="module")
def imported_dss(
    imported_sia405,
) -> None:
    _run_interlis_import(
        "minimal-dataset-DSS.xtf",
    )


@pytest.fixture(scope="module")
def imported_kek(
    imported_dss,
) -> None:
    _run_interlis_import(
        "minimal-dataset-VSA-KEK-manhole-damage.xtf",
    )


@pytest.fixture(scope="module")
def exported_sia405_base_abwasser(
    imported_kek,
) -> Path:
    DatabaseUtils.execute("""
        UPDATE tww_od.organisation
        SET tww_local_extension = true;
        """)

    return _run_interlis_export(
        base_name="export_minimal_dataset_sia405_base",
        model_group="sia405_base_abwasser",
    )


@pytest.fixture(scope="module")
def exported_sia405_abwasser(
    imported_kek,
) -> Path:
    return _run_interlis_export(
        base_name="export_minimal_dataset_sia405",
        model_group="sia405_abwasser",
    )


@pytest.fixture(scope="module")
def exported_dss(
    imported_kek,
) -> Path:
    return _run_interlis_export(
        base_name="export_minimal_dataset_dss",
        model_group="dss",
    )


@pytest.fixture(scope="module")
def exported_kek(
    imported_kek,
) -> Path:
    return _run_interlis_export(
        base_name="export_minimal_dataset_kek",
        model_group="vsa_kek",
    )


@pytest.fixture(scope="module")
def imported_sia405_modified(
    imported_kek,
) -> None:
    _run_interlis_import(
        "minimal-dataset-SIA405-ABWASSER-modified.xtf",
    )


@pytest.fixture(scope="module")
def exported_dss_selection(
    imported_sia405_modified,
) -> Path:
    return _run_interlis_export(
        base_name="export_minimal_dataset_dss_selection",
        model_group="dss",
        selected_ids=(
            "ch000000WN000002",
            "ch000000WN000003",
            "ch000000RE000002",
        ),
    )


def test_interlis_importer_exporter_importable_without_qgis() -> None:
    from teksi_wastewater.interlis.interlis_importer_exporter import (
        InterlisImporterExporter,
    )
    from teksi_wastewater.interlis.utils.ili2db import InterlisTools

    assert InterlisTools is not None
    assert InterlisImporterExporter is not None


def test_import_orgs(
    imported_orgs,
) -> None:
    _assert_scalar(
        f"""
        SELECT identifier
        FROM tww_od.organisation
        WHERE obj_id = '{ORGANISATION_ID}';
        """,
        "Arbon",
    )


def test_import_sia405(
    imported_sia405,
) -> None:
    _assert_scalar(
        f"""
        SELECT obj_id
        FROM tww_od.reach
        WHERE obj_id = '{REACH_ID}';
        """,
        REACH_ID,
    )

    _assert_scalar(
        f"""
        SELECT remark
        FROM tww_od.wastewater_networkelement
        WHERE obj_id = '{REACH_ID}';
        """,
        "rp_from_level added",
    )

    _assert_scalar(
        f"""
        SELECT bottom_level
        FROM tww_od.wastewater_node
        WHERE obj_id = '{WASTEWATER_NODE_ID}';
        """,
        448.0,
    )

    _assert_scalar(
        f"""
        SELECT height_width_ratio
        FROM tww_od.pipe_profile
        WHERE obj_id = '{PIPE_PROFILE_ID}';
        """,
        Decimal("1.12857"),
    )


def test_import_dss(
    imported_dss,
) -> None:
    dss_pipe_profile_id = "ch000000PP000001"

    _assert_scalar(
        f"""
        SELECT obj_id
        FROM tww_od.pipe_profile
        WHERE obj_id = '{dss_pipe_profile_id}';
        """,
        dss_pipe_profile_id,
    )

    _assert_scalar(
        f"""
        SELECT bottom_level
        FROM tww_od.wastewater_node
        WHERE obj_id = '{WASTEWATER_NODE_ID}';
        """,
        448.0,
    )


def test_import_kek(
    imported_kek,
) -> None:
    _assert_scalar(
        f"""
        SELECT fk_maintenance_event
        FROM tww_od.re_maintenance_event_wastewater_structure
        WHERE fk_wastewater_structure = '{WASTEWATER_STRUCTURE_ID}';
        """,
        KEK_EXAMINATION_ID,
    )

    _assert_scalar(
        f"""
        SELECT bottom_level
        FROM tww_od.wastewater_node
        WHERE obj_id = '{WASTEWATER_NODE_ID}';
        """,
        448.0,
    )


def test_export_sia405_base_abwasser(
    exported_sia405_base_abwasser,
) -> None:
    interlis_object = get_xtf_object(
        exported_sia405_base_abwasser,
        _topic_name("sia405_base_abwasser"),
        "Organisation",
        ORGANISATION_ID,
    )

    assert interlis_object is not None


def test_export_sia405_abwasser(
    exported_sia405_abwasser,
) -> None:
    topic_name = _topic_name("sia405_abwasser")

    reach = get_xtf_object(
        exported_sia405_abwasser,
        topic_name,
        "Haltung",
        REACH_ID,
    )
    assert reach is not None

    pipe_profile = get_xtf_object(
        exported_sia405_abwasser,
        topic_name,
        "Rohrprofil",
        PIPE_PROFILE_ID,
    )
    assert pipe_profile is not None

    height_width_ratio_text = get_xtf_object_node_text(
        exported_sia405_abwasser,
        topic_name,
        "Rohrprofil",
        PIPE_PROFILE_ID,
        "HoehenBreitenverhaeltnis",
    )

    assert height_width_ratio_text == "1.12857"


def test_export_dss(
    exported_dss,
) -> None:
    pipe_profile = get_xtf_object(
        exported_dss,
        _topic_name("dss"),
        "Rohrprofil",
        "ch000000PP000001",
    )

    assert pipe_profile is not None


def test_export_kek(
    exported_kek,
) -> None:
    examination = get_xtf_object(
        exported_kek,
        _topic_name("vsa_kek"),
        "Untersuchung",
        KEK_EXAMINATION_ID,
    )

    assert examination is not None


def test_import_sia405_modified(
    imported_sia405_modified,
) -> None:
    _assert_scalar(
        f"""
        SELECT obj_id
        FROM tww_od.reach
        WHERE obj_id = '{REACH_ID}';
        """,
        REACH_ID,
    )

    _assert_scalar(
        f"""
        SELECT remark
        FROM tww_od.wastewater_networkelement
        WHERE obj_id = '{REACH_ID}';
        """,
        "rp_from_level modified",
    )

    _assert_scalar(
        f"""
        SELECT bottom_level
        FROM tww_od.wastewater_node
        WHERE obj_id = '{WASTEWATER_NODE_ID}';
        """,
        448.0,
    )


def test_export_dss_selection(
    exported_dss_selection,
) -> None:
    topic_name = _topic_name("dss")

    excluded_pipe_profile = get_xtf_object(
        exported_dss_selection,
        topic_name,
        "Rohrprofil",
        "ch000000PP000001",
    )
    assert excluded_pipe_profile is None

    included_pipe_profile = get_xtf_object(
        exported_dss_selection,
        topic_name,
        "Rohrprofil",
        "ch000000PP000002",
    )
    assert included_pipe_profile is not None
