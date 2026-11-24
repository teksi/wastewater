from __future__ import annotations

import shlex
from pathlib import Path

import pytest
from teksi_wastewater.utils.database_utils import (
    DatabaseUtils,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)

from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)

from ..helpers import run_cli, run_interlis_import

pytestmark = pytest.mark.no_qgis


DATA_DIR = Path(__file__).parent / "data"
CONFIG_DIR = Path(__file__).parent / "config"

ORGS_XTF = DATA_DIR / "test-dataset-organisations.xtf"
BASELINE_DSS_XTF = DATA_DIR / "test_baseline_import_DSS_2020_1_LV95.xtf"
BASELINE_AGXX_XTF = DATA_DIR / "test_baseline_Genereller_Entwaesserungsplan_AG.xtf"

DIFF_CLI_PATH = Path("/usr/src/plugin/teksi_wastewater/hooks/cli/diff_cli.py")

DBW_WI = "ch080qwzPR000017"
DBW_GEP = "ch080qwzPR000020"
FI_BU = "ch080qwzGE000001"
DATAOWNER_OID = "ch080qwzPR000018"

BASELINE_JOB_ID = "pytest-trusted-baseline"

DB_ARGS = (
    "--pghost",
    "db",
    "--pgdatabase",
    "tww",
    "--pguser",
    "postgres",
    "--pgpass",
    "postgres",
    "--pgport",
    "5432",
)

@pytest.fixture(
    scope="module",
)
def diff_schema_service(
    tww_connection_factory: TwwDatabaseConnectionFactory,
) -> TwwDiffSchemaService:
    return TwwDiffSchemaService(
        connection_factory=tww_connection_factory,
    )


def run_diff_cli(
    *arguments: str,
) -> None:
    """
    Run one command through the TWW diff-review CLI.
    """
    run_cli(
        shlex.join(
            [
                *arguments,
                *DB_ARGS,
            ]
        ),
        DIFF_CLI_PATH,
    )


def create_review_job(
    *,
    job_id: str,
    provider_oid: str,
    xtf_file: Path | None = None,
    incremental_xtf: Path | None = None,
    auto_apply: bool = False,
    skip_rights_evaluation: bool = False,
) -> None:
    """
    Create or replace one review job.

    A job may contain a base source, an incremental source, or both.
    """
    arguments = [
        "create",
        "--job-id",
        job_id,
        "--job-mode",
        "replace",
        "--provider-oid",
        provider_oid,
        "--dataowner-oid",
        DATAOWNER_OID,
        "--rights-profile",
        "CI",
        "--hook-config-dir",
        str(CONFIG_DIR),
        "--supersede-existing-diff-jobs",
    ]

    if xtf_file is not None:
        arguments += [
            "--xtf-input",
            str(xtf_file),
        ]

    if incremental_xtf is not None:
        arguments += [
            "--incremental-xtf",
            str(incremental_xtf),
        ]

    arguments += [
        "--orgs-path",
        str(ORGS_XTF),
    ]

    if skip_rights_evaluation:
        arguments.append(
            "--skip_rights_evaluation",
        )

    if auto_apply:
        arguments.append(
            "--auto-apply",
        )

    run_diff_cli(
        *arguments,
    )


def accept_job(
    job_id: str,
) -> None:
    """
    Accept one pending review job through the CLI.
    """
    run_diff_cli(
        "accept",
        "--job-id",
        job_id,
    )


def persist_job(
    job_id: str,
) -> None:
    """
    Persist one accepted review job through the CLI.
    """
    run_diff_cli(
        "persist",
        "--job-id",
        job_id,
        "--rights-profile",
        "CI",
        "--hook-config-dir",
        str(CONFIG_DIR),
    )


def assert_baseline_imported() -> None:
    """
    Assert that the trusted baseline populated canonical data.
    """
    rows = DatabaseUtils.fetchall("""
        SELECT count(*)
        FROM tww_od.wastewater_structure
        """)

    assert rows[0][0] > 0, "The DSS baseline did not create wastewater structures."

    rows = DatabaseUtils.fetchall("""
        SELECT count(*)
        FROM tww_od.reach
        """)

    assert rows[0][0] > 0, "The DSS baseline did not create reaches."


def job_row(
    job_id: str,
) -> tuple:
    """
    Return the authoritative metadata row for one review job.

    Column positions:

    0: id
    1: job_id
    2: job_status
    3: validation_success
    4: metadata
    """
    rows = DatabaseUtils.fetchall(
        """
        SELECT
            id,
            job_id,
            job_status,
            validation_success,
            metadata
        FROM
            tww_diff.tww_metadata
        WHERE
            job_id = %s
        """,
        (job_id,),
    )

    assert len(rows) == 1, f"Expected one metadata row for {job_id!r}, " f"found {len(rows)}."

    return rows[0]


def assert_job_status(
    job_id: str,
    expected_status: str,
) -> None:
    """
    Assert one review job's authoritative lifecycle status.
    """
    row = job_row(
        job_id,
    )
    actual_status = row[2]

    assert actual_status == expected_status, (
        f"Expected job {job_id!r} to have status " f"{expected_status!r}, got {actual_status!r}."
    )


def assert_source_metadata(
    job_id: str,
    *,
    base_xtf: Path,
    incremental_xtf: Path,
) -> None:
    """
    Assert that base and incremental source metadata remain distinct.
    """
    row = job_row(
        job_id,
    )
    metadata = row[4]

    assert metadata["base_import_schema"] == ("tww_app_xtf2pg")
    assert metadata["incremental_import_schema"] == ("tww_app_xtf2pg_incr")
    assert Path(metadata["base_source_xtf"]).name == base_xtf.name
    assert Path(metadata["incremental_source_xtf"]).name == incremental_xtf.name


def diff_counts(
    diff_schema_service: TwwDiffSchemaService,
    job_id: str,
) -> tuple[
    int,
    int,
]:
    """
    Return total and rejected review-row counts for one job.

    Counting is delegated to ``TwwDiffSchemaService`` so PostgreSQL table
    inheritance and concrete review-table discovery are handled consistently
    with production code.
    """
    job_db_id = job_row(
        job_id,
    )[0]

    (
        row_counts_by_class,
        rejected_counts_by_class,
    ) = diff_schema_service.review_counts_by_class(
        job_db_id=job_db_id,
    )

    return (
        sum(
            row_counts_by_class.values(),
        ),
        sum(
            rejected_counts_by_class.values(),
        ),
    )

def assert_pending_permitted_job(
    diff_schema_service: TwwDiffSchemaService,
    job_id: str,
) -> None:
    """
    Assert that one pending review job contains permitted changes.
    """
    row = job_row(
        job_id,
    )

    job_status = row[2]
    validation_success = row[3]

    assert job_status == "pending", (
        f"Expected job {job_id!r} to be pending, "
        f"got {job_status!r}."
    )

    assert validation_success is True, (
        f"Expected validation to succeed for job "
        f"{job_id!r}, got {validation_success!r}."
    )

    (
        total_count,
        rejected_count,
    ) = diff_counts(
        diff_schema_service,
        job_id,
    )

    assert total_count > 0, (
        f"Job {job_id!r} did not produce review rows."
    )

    assert rejected_count == 0, (
        f"Expected job {job_id!r} to be fully "
        f"permitted, but {rejected_count} of "
        f"{total_count} rows were rejected."
    )


def create_and_apply_phase(
    *,
    diff_schema_service: TwwDiffSchemaService,
    allowed_provider: str,
    phase_identifier: str,
) -> None:
    """
    Create, accept and persist one permitted phase job.

    Each expensive XTF pair is imported and projected only once.
    Provider-right permutations belong in focused rights-evaluator tests
    rather than repeated end-to-end CLI imports.
    """
    base_xtf = (
        DATA_DIR
        / f"test_{phase_identifier}_DSS_2020_1_LV95.xtf"
    )
    incremental_xtf = DATA_DIR / (
        f"test_{phase_identifier}_"
        "Genereller_Entwaesserungsplan_AG.xtf"
    )
    job_id = (
        f"pytest-{phase_identifier}-job-"
        f"{allowed_provider}"
    )

    create_review_job(
        job_id=job_id,
        xtf_file=base_xtf,
        provider_oid=allowed_provider,
        incremental_xtf=incremental_xtf,
    )

    assert_pending_permitted_job(
        diff_schema_service,
        job_id,
    )

    assert_source_metadata(
        job_id,
        base_xtf=base_xtf,
        incremental_xtf=incremental_xtf,
    )

    accept_job(
        job_id,
    )

    assert_job_status(
        job_id,
        "accepted",
    )

    persist_job(
        job_id,
    )

    assert_job_status(
        job_id,
        "applied",
    )

@pytest.fixture(
    scope="module",
)
def imported_dss_baseline(
    imported_organisations,
) -> None:
    """
    Import the trusted DSS baseline before incremental review application.
    """
    del imported_organisations

    run_interlis_import(
        BASELINE_DSS_XTF,
        host_data_dir=DATA_DIR,
        container_data_dir=DATA_DIR,
    )

    assert_baseline_imported()


@pytest.fixture(
    scope="module",
)
def agxx_diff_applied(
    imported_dss_baseline,
) -> None:
    """
    Apply an incremental-only AGXX review job against the live DSS baseline.
    """
    del imported_dss_baseline

    create_review_job(
        job_id=BASELINE_JOB_ID,
        provider_oid=DBW_WI,
        incremental_xtf=BASELINE_AGXX_XTF,
        skip_rights_evaluation=True,
        auto_apply=True,
    )

    assert_job_status(
        BASELINE_JOB_ID,
        "applied",
    )

    rows = DatabaseUtils.fetchall("""
        SELECT count(*)
        FROM tww_od.agxx_building_group
        """)

    assert rows[0][0] > 0, "The AGXX baseline did not populate " "agxx_building_group."


def test_diff_import_workflow(
    agxx_diff_applied,
    diff_schema_service: TwwDiffSchemaService,
) -> None:
    """
    Exercise trusted baseline and three permitted review lifecycles.
    """
    del agxx_diff_applied

    create_and_apply_phase(
        diff_schema_service=diff_schema_service,
        allowed_provider=DBW_WI,
        phase_identifier="phase1_dbw_wi",
    )
    create_and_apply_phase(
        diff_schema_service=diff_schema_service,
        allowed_provider=DBW_GEP,
        phase_identifier="phase2_dbw_gep",
    )
    create_and_apply_phase(
        diff_schema_service=diff_schema_service,
        allowed_provider=FI_BU,
        phase_identifier="phase3_fi_bu",
    )
