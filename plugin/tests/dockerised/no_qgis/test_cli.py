from __future__ import annotations

from decimal import Decimal
from pathlib import Path

import pytest
from teksi_wastewater.interlis import model_config
from teksi_wastewater.utils.database_utils import DatabaseUtils

from ..helpers import (
    get_xtf_object,
    get_xtf_object_node_text,
    run_cli,
)

pytestmark = pytest.mark.no_qgis


DATA_DIR = Path(
    "/usr/src/plugin/tests/dockerised/qgis/data",
)
CONTAINER_OUTPUT_DIR = Path(
    "/usr/src/plugin/tests/dockerised/no_qgis/output",
)

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True,
)

DB_ARGS = (
    "--pghost db "
    "--pgdatabase tww "
    "--pguser postgres "
    "--pgpass postgres "
    "--pgport 5432"
)


def _container_output_file(
    name: str,
) -> str:
    return str(
        CONTAINER_OUTPUT_DIR
        / f"{name}.xtf"
    )


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
    Return the configured language-specific model name for one model group.
    """
    return model_config.interlis_models[
        group
    ].lang_name(
        lang,
    )


def _topic_name(
    group: str,
    *,
    lang: str = "de",
) -> str:
    """
    Return the only configured topic for one model group and language.

    Every model used by these fixtures currently exposes one transfer topic.
    Fail clearly if a future model definition changes that assumption.
    """
    topics = model_config.interlis_models[
        group
    ].topics_by_lang(
        lang,
    )

    assert len(topics) == 1, (
        "Expected exactly one topic for INTERLIS group "
        f"{group!r} and language {lang!r}, got "
        f"{sorted(topics)!r}."
    )

    return next(
        iter(
            topics,
        )
    )


@pytest.fixture(
    scope="module",
)
def imported_orgs(
    clean_db_once,
) -> None:
    run_cli(
        "interlis_import "
        f'--xtf_file "{DATA_DIR / "minimal-dataset-organisation-arbon-only.xtf"}" '
        f"{DB_ARGS}"
    )


@pytest.fixture(
    scope="module",
)
def imported_sia405(
    imported_orgs,
) -> None:
    run_cli(
        "interlis_import "
        f'--xtf_file "{DATA_DIR / "minimal-dataset-SIA405-ABWASSER.xtf"}" '
        f"{DB_ARGS}"
    )


@pytest.fixture(
    scope="module",
)
def imported_dss(
    imported_sia405,
) -> None:
    run_cli(
        "interlis_import "
        f'--xtf_file "{DATA_DIR / "minimal-dataset-DSS.xtf"}" '
        f"{DB_ARGS}"
    )


@pytest.fixture(
    scope="module",
)
def imported_kek(
    imported_dss,
) -> None:
    run_cli(
        "interlis_import "
        f'--xtf_file "{DATA_DIR / "minimal-dataset-VSA-KEK-manhole-damage.xtf"}" '
        f"{DB_ARGS}"
    )


@pytest.fixture(
    scope="module",
)
def exported_sia405_base_abwasser(
    imported_kek,
) -> Path:
    DatabaseUtils.execute(
        """
        UPDATE tww_od.organisation
        SET tww_local_extension = true;
        """
    )

    base_name = "export_minimal_dataset_sia405_base"
    export_model = _model_name(
        "sia405_base_abwasser",
    )

    run_cli(
        "interlis_export "
        f'--xtf_file "{_container_output_file(base_name)}" '
        f'--export_model "{export_model}" '
        "--logs_next_to_file "
        f"{DB_ARGS}"
    )

    return _host_exported_file(
        base_name,
        export_model,
    )


@pytest.fixture(
    scope="module",
)
def exported_sia405_abwasser(
    imported_kek,
) -> Path:
    base_name = "export_minimal_dataset_sia405"
    export_model = _model_name(
        "sia405_abwasser",
    )

    run_cli(
        "interlis_export "
        f'--xtf_file "{_container_output_file(base_name)}" '
        f'--export_model "{export_model}" '
        "--logs_next_to_file "
        f"{DB_ARGS}"
    )

    return _host_exported_file(
        base_name,
        export_model,
    )


@pytest.fixture(
    scope="module",
)
def exported_dss(
    imported_kek,
) -> Path:
    base_name = "export_minimal_dataset_dss"
    export_model = _model_name(
        "dss",
    )

    run_cli(
        "interlis_export "
        f'--xtf_file "{_container_output_file(base_name)}" '
        f'--export_model "{export_model}" '
        "--logs_next_to_file "
        f"{DB_ARGS}"
    )

    return _host_exported_file(
        base_name,
        export_model,
    )


@pytest.fixture(
    scope="module",
)
def exported_kek(
    imported_kek,
) -> Path:
    base_name = "export_minimal_dataset_kek"
    export_model = _model_name(
        "vsa_kek",
    )

    run_cli(
        "interlis_export "
        f'--xtf_file "{_container_output_file(base_name)}" '
        f'--export_model "{export_model}" '
        "--logs_next_to_file "
        f"{DB_ARGS}"
    )

    return _host_exported_file(
        base_name,
        export_model,
    )


@pytest.fixture(
    scope="module",
)
def imported_sia405_modified(
    imported_kek,
) -> None:
    modified_xtf = (
        DATA_DIR
        / "minimal-dataset-SIA405-ABWASSER-modified.xtf"
    )

    assert modified_xtf.is_file(), (
        f"Missing modified SIA405 fixture: {modified_xtf}"
    )

    run_cli(
        "interlis_import "
        f'--xtf_file "{modified_xtf}" '
        f"{DB_ARGS}"
    )


@pytest.fixture(
    scope="module",
)
def exported_dss_selection(
    imported_sia405_modified,
) -> Path:
    base_name = "export_minimal_dataset_dss_selection"
    export_model = _model_name(
        "dss",
    )

    run_cli(
        "interlis_export "
        f'--xtf_file "{_container_output_file(base_name)}" '
        f'--export_model "{export_model}" '
        '--selected_ids "ch000000WN000002,ch000000WN000003,ch000000RE000002" '
        "--logs_next_to_file "
        f"{DB_ARGS}"
    )

    return _host_exported_file(
        base_name,
        export_model,
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
    result = DatabaseUtils.fetchone(
        "SELECT identifier "
        "FROM tww_od.organisation "
        "WHERE obj_id='ch20p3q400001497';"
    )

    assert result is not None
    assert result[0] == "Arbon"


def test_import_sia405(
    imported_sia405,
) -> None:
    result = DatabaseUtils.fetchone(
        "SELECT obj_id "
        "FROM tww_od.reach "
        "WHERE obj_id='ch000000RE000001';"
    )
    assert result is not None

    result = DatabaseUtils.fetchone(
        "SELECT remark "
        "FROM tww_od.wastewater_networkelement "
        "WHERE obj_id='ch000000RE000001';"
    )
    assert result is not None
    assert result[0] == "rp_from_level added"

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level "
        "FROM tww_od.wastewater_node "
        "WHERE obj_id='ch000000WN000001';"
    )
    assert result is not None
    assert result[0] == 448.0

    result = DatabaseUtils.fetchone(
        "SELECT height_width_ratio "
        "FROM tww_od.pipe_profile "
        "WHERE obj_id='ch000000PP000003';"
    )
    assert result is not None
    assert result[0] == Decimal(
        "1.12857",
    )


def test_import_dss(
    imported_dss,
) -> None:
    result = DatabaseUtils.fetchone(
        "SELECT obj_id "
        "FROM tww_od.pipe_profile "
        "WHERE obj_id='ch000000PP000001';"
    )
    assert result is not None

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level "
        "FROM tww_od.wastewater_node "
        "WHERE obj_id='ch000000WN000001';"
    )
    assert result is not None
    assert result[0] == 448.0


def test_import_kek(
    imported_kek,
) -> None:
    result = DatabaseUtils.fetchone(
        "SELECT fk_maintenance_event "
        "FROM tww_od.re_maintenance_event_wastewater_structure "
        "WHERE fk_wastewater_structure='ch000000WS000001';"
    )
    assert result is not None
    assert result[0] == "fk11abk6EX000002"

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level "
        "FROM tww_od.wastewater_node "
        "WHERE obj_id='ch000000WN000001';"
    )
    assert result is not None
    assert result[0] == 448.0


def test_export_sia405_base_abwasser(
    exported_sia405_base_abwasser,
) -> None:
    interlis_object = get_xtf_object(
        exported_sia405_base_abwasser,
        _topic_name(
            "sia405_base_abwasser",
        ),
        "Organisation",
        "ch20p3q400001497",
    )

    assert interlis_object is not None


def test_export_sia405_abwasser(
    exported_sia405_abwasser,
) -> None:
    topic_name = _topic_name(
        "sia405_abwasser",
    )

    interlis_object = get_xtf_object(
        exported_sia405_abwasser,
        topic_name,
        "Haltung",
        "ch000000RE000001",
    )
    assert interlis_object is not None

    interlis_object = get_xtf_object(
        exported_sia405_abwasser,
        topic_name,
        "Rohrprofil",
        "ch000000PP000003",
    )
    assert interlis_object is not None

    height_width_ratio_text = get_xtf_object_node_text(
        exported_sia405_abwasser,
        topic_name,
        "Rohrprofil",
        "ch000000PP000003",
        "HoehenBreitenverhaeltnis",
    )

    assert height_width_ratio_text == "1.12857"


def test_export_dss(
    exported_dss,
) -> None:
    interlis_object = get_xtf_object(
        exported_dss,
        _topic_name(
            "dss",
        ),
        "Rohrprofil",
        "ch000000PP000001",
    )

    assert interlis_object is not None


def test_export_kek(
    exported_kek,
) -> None:
    interlis_object = get_xtf_object(
        exported_kek,
        _topic_name(
            "vsa_kek",
        ),
        "Untersuchung",
        "fk11abk6EX000002",
    )

    assert interlis_object is not None


def test_import_sia405_modified(
    imported_sia405_modified,
) -> None:
    result = DatabaseUtils.fetchone(
        "SELECT obj_id "
        "FROM tww_od.reach "
        "WHERE obj_id='ch000000RE000001';"
    )
    assert result is not None, (
        "The modified SIA405 import did not retain the canonical "
        "reach row 'ch000000RE000001'."
    )

    result = DatabaseUtils.fetchone(
        "SELECT remark "
        "FROM tww_od.wastewater_networkelement "
        "WHERE obj_id='ch000000RE000001';"
    )
    assert result is not None
    assert result[0] == "rp_from_level modified"

    result = DatabaseUtils.fetchone(
        "SELECT bottom_level "
        "FROM tww_od.wastewater_node "
        "WHERE obj_id='ch000000WN000001';"
    )
    assert result is not None
    assert result[0] == 448.0


def test_export_dss_selection(
    exported_dss_selection,
) -> None:
    assert exported_dss_selection.exists()

    interlis_object = get_xtf_object(
        exported_dss_selection,
        _topic_name(
            "dss",
        ),
        "Rohrprofil",
        "ch000000PP000001",
    )
    assert interlis_object is None

    interlis_object = get_xtf_object(
        exported_dss_selection,
        _topic_name(
            "sia405_abwasser",
        ),
        "Rohrprofil",
        "ch000000PP000002",
    )
    assert interlis_object is not None
