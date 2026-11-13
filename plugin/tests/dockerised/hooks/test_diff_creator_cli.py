from __future__ import annotations

import shlex
from pathlib import Path

import pytest
from teksi_wastewater.utils.database_utils import (
    DatabaseUtils,
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
    xtf_file: Path,
    provider_oid: str,
    incremental_xtf: Path,
    auto_apply: bool = False,
    skip_rights_evaluation: bool = False,
) -> None:
    """
    Create or replace one base-and-incremental review job.
    """
    assert xtf_file.is_file(), f"Missing base INTERLIS fixture: {xtf_file}"
    assert incremental_xtf.is_file(), "Missing incremental INTERLIS fixture: " f"{incremental_xtf}"
    assert ORGS_XTF.is_file(), f"Missing organisation fixture: {ORGS_XTF}"

    arguments = [
        "create",
        "--job-id",
        job_id,
        "--job-mode",
        "replace",
        "--xtf-input",
        str(xtf_file),
        "--incremental-xtf",
        str(incremental_xtf),
        "--provider-oid",
        provider_oid,
        "--dataowner-oid",
        DATAOWNER_OID,
        "--orgs-path",
        str(ORGS_XTF),
        "--rights-profile",
        "CI",
        "--hook-config-dir",
        str(CONFIG_DIR),
        "--supersede-existing-diff-jobs",
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
    Assert that the trusted baseline populated canonical and AGXX data.
    """
    rows = DatabaseUtils.execute_fetchall("""
        SELECT count(*) AS count
        FROM tww_od.wastewater_structure
        """)
    assert rows[0]["count"] > 0, "The DSS baseline did not create wastewater structures."

    rows = DatabaseUtils.execute_fetchall("""
        SELECT count(*) AS count
        FROM tww_od.reach
        """)
    assert rows[0]["count"] > 0, "The DSS baseline did not create reaches."


def job_row(
    job_id: str,
) -> dict:
    """
    Return the authoritative metadata row for one review job.
    """
    rows = DatabaseUtils.execute_fetchall(
        """
        SELECT
            id,
            job_id,
            job_status,
            validation_success,
            metadata
        FROM tww_diff.metadata
        WHERE job_id = %s
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
    actual_status = job_row(
        job_id,
    )["job_status"]

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
    metadata = job_row(
        job_id,
    )["metadata"]

    assert metadata["base_import_schema"] == "tww_app_xtf2pg"
    assert metadata["incremental_import_schema"] == ("tww_app_xtf2pg_incr")
    assert Path(metadata["base_source_xtf"]).name == base_xtf.name
    assert Path(metadata["incremental_source_xtf"]).name == (incremental_xtf.name)


def diff_counts(
    job_id: str,
) -> tuple[int, int]:
    """
    Return total and rejected review-row counts for one job.
    """
    job_db_id = job_row(
        job_id,
    )["id"]

    table_rows = DatabaseUtils.execute_fetchall("""
        SELECT table_name
        FROM information_schema.columns
        WHERE table_schema = 'tww_diff'
        GROUP BY table_name
        HAVING bool_or(column_name = 'job_id')
           AND bool_or(column_name = 'is_rejected')
        ORDER BY table_name
        """)

    total_count = 0
    rejected_count = 0

    for table_row in table_rows:
        table_name = table_row["table_name"]
        quoted_table_name = (
            '"'
            + table_name.replace(
                '"',
                '""',
            )
            + '"'
        )
        counts = DatabaseUtils.execute_fetchall(
            f"""
            SELECT
                count(*) AS total_count,
                count(*) FILTER (
                    WHERE is_rejected
                ) AS rejected_count
            FROM tww_diff.{quoted_table_name}
            WHERE job_id = %s
            """,
            (job_db_id,),
        )[0]

        total_count += counts["total_count"]
        rejected_count += counts["rejected_count"]

    return (
        total_count,
        rejected_count,
    )


def assert_pending_permitted_job(
    job_id: str,
) -> None:
    """
    Assert that one pending review job contains permitted changes.
    """
    job = job_row(
        job_id,
    )
    assert job["job_status"] == "pending"
    assert job["validation_success"] is True

    total_count, rejected_count = diff_counts(
        job_id,
    )
    assert total_count > 0, f"Job {job_id!r} did not produce review rows."
    assert rejected_count == 0, (
        f"Expected job {job_id!r} to be fully permitted, but "
        f"{rejected_count} of {total_count} rows were rejected."
    )


def create_and_apply_phase(
    *,
    allowed_provider: str,
    phase_identifier: str,
) -> None:
    """
    Create, accept and persist one permitted phase job.

    Each expensive XTF pair is imported and projected only once. Provider-right
    permutations belong in focused rights-evaluator tests rather than repeated
    end-to-end CLI imports.
    """
    base_xtf = DATA_DIR / (f"test_{phase_identifier}_DSS_2020_1_LV95.xtf")
    incremental_xtf = DATA_DIR / (
        f"test_{phase_identifier}_" "Genereller_Entwaesserungsplan_AG.xtf"
    )
    job_id = f"pytest-{phase_identifier}-job-{allowed_provider}"

    create_review_job(
        job_id=job_id,
        xtf_file=base_xtf,
        provider_oid=allowed_provider,
        incremental_xtf=incremental_xtf,
    )

    assert_pending_permitted_job(
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


@pytest.fixture(scope="module")
def imported_dss_baseline(imported_organisations) -> None:
    run_interlis_import(BASELINE_DSS_XTF)


@pytest.fixture(scope="module")
def agxx_diff_applied(imported_dss_baseline):

    # run the diff creator CLI with incremental-only parameters
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

    rows = DatabaseUtils.execute_fetchall("""
        SELECT count(*) AS count
        FROM tww_od.agxx_building_group
        """)
    assert rows[0]["count"] > 0, "The AGXX baseline did not populate agxx_building_group."


def test_diff_import_workflow(
    agxx_diff_applied,
) -> None:
    """
    Exercise trusted baseline and the three permitted review lifecycles.
    """
    create_and_apply_phase(
        allowed_provider=DBW_WI,
        phase_identifier="phase1_dbw_wi",
    )
    create_and_apply_phase(
        allowed_provider=DBW_GEP,
        phase_identifier="phase2_dbw_gep",
    )
    create_and_apply_phase(
        allowed_provider=FI_BU,
        phase_identifier="phase3_fi_bu",
    )
