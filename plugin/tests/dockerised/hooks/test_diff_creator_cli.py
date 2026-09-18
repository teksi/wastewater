# dockerised/hooks/test_diff_exporter_cli.py

from __future__ import annotations

import shlex
from pathlib import Path

import pytest
from teksi_wastewater.utils.database_utils import (
    DatabaseUtils,
)

from ..helpers import run_cli

pytestmark = pytest.mark.no_qgis


DATA_DIR = Path(__file__).parent / "data"

CONFIG_DIR = Path(__file__).parent / "config"

ORGS_XTF = DATA_DIR / "test-dataset-organisations.xtf"

INTERLIS_CLI_PATH = Path("/usr/src/plugin/teksi_wastewater/" "hooks/cli/importer_exporter.py")

DBW_WI = "ch080qwzPR000017"
DBW_GEP = "ch080qwzPR000020"
FI_BU = "ch080qwzGE000001"

PROVIDERS = (
    FI_BU,
    DBW_GEP,
    DBW_WI,
)

DATAOWNER_OID = "ch080qwzPR000018"


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


def run_import_cli(
    *,
    job_id: str,
    job_mode: str,
    xtf_file: Path,
    provider_oid: str,
    dataowner_oid: str,
    incremental_xtf: Path,
) -> None:
    """
    Run the diff-exporter CLI for a base and incremental XTF pair.
    """

    command = shlex.join(
        [
            "diff-exporter",
            "--job-id",
            job_id,
            "--job-mode",
            job_mode,
            "--xtf-input",
            str(
                xtf_file,
            ),
            "--provider-oid",
            provider_oid,
            "--dataowner-oid",
            dataowner_oid,
            "--orgs-path",
            str(
                ORGS_XTF,
            ),
            "--incremental-xtf",
            str(
                incremental_xtf,
            ),
            "--rights-profile",
            "CI",
            "--hook-config-dir",
            str(
                CONFIG_DIR,
            ),
        ]
    )

    run_cli(
        command,
        INTERLIS_CLI_PATH,
    )


def run_interlis_import(
    xtf_file: Path,
    *,
    incremental_only: bool = False,
) -> None:
    """
    Import one baseline XTF through the INTERLIS CLI.

    When ``incremental_only`` is enabled, only the incremental AG-XX values
    are applied. The regular canonical update path is skipped.
    """

    assert xtf_file.is_file(), f"Missing INTERLIS fixture: {xtf_file}"

    arguments = [
        "interlis_import",
        "--xtf_file",
        str(
            xtf_file,
        ),
    ]

    if incremental_only:
        arguments.append(
            "--incremental_only",
        )

    arguments.extend(
        DB_ARGS,
    )

    run_cli(
        shlex.join(
            arguments,
        ),
        INTERLIS_CLI_PATH,
    )


def import_baseline() -> None:
    """
    Import the trusted DSS and AG-XX baselines.

    """

    run_interlis_import(
        ORGS_XTF,
    )

    run_interlis_import(
        DATA_DIR / "test_baseline_import_DSS_2020_1_LV95.xtf",
    )

    run_interlis_import(
        DATA_DIR / ("test_baseline_Genereller_Entwaesserungsplan_AG.xtf"),
        incremental_only=True,
    )


def assert_baseline_imported() -> None:
    """
    Assert that the legacy imports populated canonical and AG-XX live data.
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

    rows = DatabaseUtils.execute_fetchall("""
        SELECT count(*) AS count
        FROM tww_od.agxx_building_group
        """)

    assert rows[0]["count"] > 0, "The AG-XX baseline did not populate agxx_building_group."


def assert_job_created(
    job_id: str,
) -> None:
    """
    Assert that a pending diff job and at least one review row exist.
    """

    rows = DatabaseUtils.execute_fetchall(
        """
        SELECT
            id,
            job_id,
            job_status,
            validation_success
        FROM tww_diff.metadata
        WHERE job_id = %s
        """,
        (job_id,),
    )

    assert len(rows) == 1, f"Expected one metadata row for {job_id!r}, " f"found {len(rows)}."

    job = rows[0]

    assert job["job_id"] == job_id
    assert job["job_status"] == "pending"
    assert job["validation_success"] is True

    total_count, _ = _diff_counts(
        job_id,
    )

    assert total_count > 0, f"Job {job_id!r} did not produce any diff rows."


def assert_job_status(
    job_id: str,
    expected_status: str,
) -> None:
    """
    Assert the status stored in the authoritative diff metadata table.
    """

    rows = DatabaseUtils.execute_fetchall(
        """
        SELECT job_status
        FROM tww_diff.metadata
        WHERE job_id = %s
        """,
        (job_id,),
    )

    assert len(rows) == 1, f"Expected one metadata row for {job_id!r}, " f"found {len(rows)}."

    actual_status = rows[0]["job_status"]

    assert actual_status == expected_status, (
        f"Expected job {job_id!r} to have status " f"{expected_status!r}, got {actual_status!r}."
    )


def import_run(
    *,
    allowed_provider: str,
    xtf_phase_identifier: str,
) -> None:
    """
    Try a phase with forbidden providers first, then persist the allowed run.
    """

    ordered_providers = [provider for provider in PROVIDERS if provider != allowed_provider]

    ordered_providers.append(
        allowed_provider,
    )

    xtf_file = DATA_DIR / (f"test_{xtf_phase_identifier}_" "DSS_2020_1_LV95.xtf")

    incremental_xtf = DATA_DIR / (
        f"test_{xtf_phase_identifier}_" "Genereller_Entwaesserungsplan_AG.xtf"
    )

    assert xtf_file.is_file(), f"Missing test fixture: {xtf_file}"

    assert incremental_xtf.is_file(), f"Missing test fixture: {incremental_xtf}"

    for provider in ordered_providers:
        job_id = f"{xtf_phase_identifier}-" f"job-{provider}"

        run_import_cli(
            job_id=job_id,
            job_mode="create",
            xtf_file=xtf_file,
            provider_oid=provider,
            dataowner_oid=DATAOWNER_OID,
            incremental_xtf=incremental_xtf,
        )

        assert_job_created(
            job_id,
        )

        if provider != allowed_provider:
            assert_update_forbidden(
                job_id,
            )

            reject_update(
                job_id,
            )

            continue

        assert_update_allowed(
            job_id,
        )

        persist_update(
            job_id,
        )


def _diff_counts(
    job_id: str,
) -> tuple[int, int]:
    """
    Return total and rejected diff-row counts for a review job.
    """

    metadata_rows = DatabaseUtils.execute_fetchall(
        """
        SELECT id
        FROM tww_diff.metadata
        WHERE job_id = %s
        """,
        (job_id,),
    )

    assert len(metadata_rows) == 1, (
        f"Expected exactly one metadata row for job {job_id!r}, " f"found {len(metadata_rows)}."
    )

    job_db_id = metadata_rows[0]["id"]

    table_rows = DatabaseUtils.execute_fetchall("""
        SELECT table_name
        FROM information_schema.columns
        WHERE table_schema = 'tww_diff'
        GROUP BY table_name
        HAVING bool_or(
            column_name = 'job_id'
        )
        AND bool_or(
            column_name = 'is_rejected'
        )
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


def assert_update_forbidden(
    job_id: str,
) -> None:
    """
    Assert that a job contains at least one rejected diff row.
    """

    total_count, rejected_count = _diff_counts(
        job_id,
    )

    assert total_count > 0, (
        f"Expected forbidden job {job_id!r} to contain changes, " "but no diff rows were created."
    )

    assert rejected_count > 0, (
        f"Expected job {job_id!r} to contain rejected changes, "
        f"but all {total_count} rows were permitted."
    )


def assert_update_allowed(
    job_id: str,
) -> None:
    """
    Assert that a job contains changes without rejected rows.
    """

    total_count, rejected_count = _diff_counts(
        job_id,
    )

    assert total_count > 0, (
        f"Expected permitted job {job_id!r} to contain changes, " "but no diff rows were created."
    )

    assert rejected_count == 0, (
        f"Expected job {job_id!r} to be fully permitted, "
        f"but {rejected_count} of {total_count} rows were rejected."
    )


def reject_update(
    job_id: str,
) -> None:
    """
    Reject a pending review job without modifying live data.

    This currently assumes a database-side job rejection function.
    """

    DatabaseUtils.execute_fetchall(
        """
        SELECT tww_app.fct_reject_diff_job(
            %s
        )
        """,
        (job_id,),
    )

    assert_job_status(
        job_id,
        "rejected",
    )


def persist_update(
    job_id: str,
) -> None:
    """
    Apply a fully permitted review job to live data.

    This currently assumes a database-side transactional apply function.
    """

    total_count, rejected_count = _diff_counts(
        job_id,
    )

    assert total_count > 0, f"Cannot apply empty job {job_id!r}."

    assert rejected_count == 0, (
        f"Cannot apply job {job_id!r}: " f"{rejected_count} diff rows are rejected."
    )

    DatabaseUtils.execute_fetchall(
        """
        SELECT tww_app.fct_apply_diff_job(
            %s
        )
        """,
        (job_id,),
    )

    assert_job_status(
        job_id,
        "applied",
    )


def test_diff_import_workflow(
    clean_db_once,
) -> None:
    import_baseline()

    assert_baseline_imported()

    import_run(
        allowed_provider=DBW_WI,
        xtf_phase_identifier="phase1_dbw_wi",
    )

    import_run(
        allowed_provider=DBW_GEP,
        xtf_phase_identifier="phase2_dbw_gep",
    )

    import_run(
        allowed_provider=FI_BU,
        xtf_phase_identifier="phase3_fi_bu",
    )
