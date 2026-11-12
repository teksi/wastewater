from __future__ import annotations

import pytest

from teksi_wastewater.hooks.cli.diff_cli import _argument_parser, _parameters


def test_create_command_keeps_job_mode_separate_from_lifecycle_command() -> None:
    args = _argument_parser().parse_args(
        [
            "create",
            "--job-id",
            "job",
            "--job-mode",
            "replace",
            "--xtf-input",
            "base.xtf",
            "--incremental-xtf",
            "incremental.xtf",
            "--provider-oid",
            "ch080qwzPR000017",
            "--dataowner-oid",
            "ch080qwzPR000018",
        ]
    )
    parameters = _parameters(args)
    assert parameters["command"] == "create"
    assert parameters["job_mode"] == "replace"
    assert parameters["xtf_input"].name == "base.xtf"
    assert parameters["incremental_xtf"].name == "incremental.xtf"


@pytest.mark.parametrize("command", ("accept", "reject", "persist"))
def test_lifecycle_commands_do_not_require_create_inputs(command: str) -> None:
    args = _argument_parser().parse_args(
        [command, "--job-id", "job"]
    )
    parameters = _parameters(args)
    assert parameters["command"] == command
    assert parameters["job_id"] == "job"
    assert "xtf_input" not in parameters
    assert "provider_oid" not in parameters
