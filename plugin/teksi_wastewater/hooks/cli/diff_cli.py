from __future__ import annotations

import argparse
import logging
from collections.abc import Sequence
from pathlib import Path
from typing import Any

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.hook import (
    HookContext,
    HookHandler,
)

from teksi_wastewater.hooks.cli import (
    helpers,
)
from teksi_wastewater.interlis import (
    config,
)


logger = logging.getLogger(
    __name__,
)


_CREATE_COMMAND = "create"
_ACCEPT_COMMAND = "accept"
_REJECT_COMMAND = "reject"
_PERSIST_COMMAND = "persist"

_REVIEW_COMMANDS = (
    _ACCEPT_COMMAND,
    _REJECT_COMMAND,
    _PERSIST_COMMAND,
)


def main(
    argv: Sequence[
        str,
    ]
    | None = None,
) -> int:
    """
    Create and manage TWW diff-review jobs.
    """
    _configure_logging()

    parser = _argument_parser()

    args = parser.parse_args(
        argv,
    )

    connection_factory = (
        helpers.database_connection_factory(
            args,
        )
    )

    connection_factory.apply_to_database_config()

    parameters = _parameters(
        args,
    )

    context = HookContext(
        parameters=parameters,
        logger=logger,
        capabilities={
            DatabaseConnectionFactory: (
                connection_factory
            ),
        },
    )

    hook_file = (
        Path(
            __file__,
        )
        .resolve()
        .parents[
            1
        ]
        / "diff_creator_hook.py"
    )

    HookHandler(
        file=hook_file,
        base_path=hook_file.parent,
    ).run(
        context,
    )

    return 0


def _configure_logging(
) -> None:
    """
    Configure command-line logging.
    """
    logging.basicConfig(
        level=logging.INFO,
        format=(
            "%(asctime)s "
            "%(levelname)-8s "
            "%(name)s: "
            "%(message)s"
        ),
        datefmt="%H:%M:%S",
        force=True,
    )


def _argument_parser(
) -> argparse.ArgumentParser:
    """
    Build the complete diff-review CLI parser.
    """
    parser = argparse.ArgumentParser(
        description=(
            "Create and manage TWW diff-review jobs."
        ),
    )

    subparsers = parser.add_subparsers(
        dest="command",
        required=True,
        metavar="COMMAND",
    )

    _add_create_parser(
        subparsers,
    )

    _add_review_action_parser(
        subparsers,
        command=_ACCEPT_COMMAND,
        help_text=(
            "Accept a pending TWW diff-review job."
        ),
    )

    _add_review_action_parser(
        subparsers,
        command=_REJECT_COMMAND,
        help_text=(
            "Reject a pending TWW diff-review job."
        ),
    )

    _add_review_action_parser(
        subparsers,
        command=_PERSIST_COMMAND,
        help_text=(
            "Apply an accepted TWW diff-review job "
            "to the live schema."
        ),
    )

    return parser


def _add_create_parser(
    subparsers: Any,
) -> None:
    """
    Add the review-job creation command.
    """
    parser = subparsers.add_parser(
        _CREATE_COMMAND,
        help=(
            "Create a TWW diff-review job from "
            "one baseline XTF and an optional "
            "incremental XTF."
        ),
        description=(
            "Import source data into quarantine schemas "
            "and create a TWW diff-review job."
        ),
    )

    parser.add_argument(
        "--job-id",
        default=None,
        help=(
            "Optional stable identifier for the "
            "tww_diff job. A UUID is generated when "
            "the identifier is omitted."
        ),
    )

    parser.add_argument(
        "--job-mode",
        choices=(
            "create",
            "replace",
            "refresh",
        ),
        default="create",
        help=(
            "How an existing diff job with the same "
            "identifier is handled."
        ),
    )

    parser.add_argument(
        "--xtf-input",
        required=True,
        type=Path,
        help=(
            "Path to the baseline or main XTF file."
        ),
    )

    parser.add_argument(
        "--incremental-xtf",
        dest="incremental_xtf",
        type=Path,
        default=None,
        help=(
            "Optional incremental adaptation XTF, "
            "for example an AG-XX transfer."
        ),
    )

    parser.add_argument(
        "--provider-oid",
        required=True,
        help=(
            "Provider organisation OID used for "
            "rights evaluation."
        ),
    )

    parser.add_argument(
        "--dataowner-oid",
        required=True,
        help=(
            "Data-owner organisation OID used for "
            "rights evaluation."
        ),
    )

    parser.add_argument(
        "--orgs-path",
        type=Path,
        default=None,
        help=(
            "Optional organisation or reference XTF."
        ),
    )

    parser.add_argument(
        "--rights-profile",
        default="default",
        help=(
            "Rights-profile directory below the "
            "hook configuration directory."
        ),
    )

    parser.add_argument(
        "--hook-config-dir",
        type=Path,
        default=None,
        help=(
            "Directory containing rights-profile "
            "subdirectories. When omitted, the hook "
            "may use TWW_DIFF_CONF_DIR."
        ),
    )

    parser.add_argument(
        "--skip-rights-evaluation",
        "--skip_rights_evaluation",
        dest="skip_rights_evaluation",
        action="store_true",
        help=(
            "Grant all available rights for this import. "
            "Use only for trusted baseline setup."
        ),
    )

    parser.add_argument(
        "--auto-apply",
        action="store_true",
        help=(
            "Automatically accept and apply the created "
            "job. Use only for trusted baseline setup."
        ),
    )

    parser.add_argument(
        "--supersede-existing-diff-jobs",
        action="store_true",
        help=(
            "Supersede applicable existing diff jobs "
            "when the new job is created."
        ),
    )

    helpers.add_postgres_connection_args(
        parser,
    )


def _add_review_action_parser(
    subparsers: Any,
    *,
    command: str,
    help_text: str,
) -> None:
    """
    Add one review-job lifecycle command.
    """
    parser = subparsers.add_parser(
        command,
        help=help_text,
        description=help_text,
    )

    parser.add_argument(
        "--job-id",
        required=True,
        help=(
            "Identifier of the existing tww_diff "
            "review job."
        ),
    )

    parser.add_argument(
        "--live-schema",
        default=config.TWW_OD_SCHEMA,
        help=(
            "Canonical live schema. Defaults to "
            f"{config.TWW_OD_SCHEMA!r}."
        ),
    )

    if command in {
        _ACCEPT_COMMAND,
        _REJECT_COMMAND,
    }:
        parser.add_argument(
            "--expected-status",
            default="pending",
            help=(
                "Required current job status before "
                f"the job may be {command}ed."
            ),
        )

    if command == _PERSIST_COMMAND:
        parser.add_argument(
            "--expected-status",
            default="accepted",
            help=(
                "Required current job status before "
                "persistence."
            ),
        )

        parser.add_argument(
            "--hook-config-dir",
            type=Path,
            default=None,
            help=(
                "Directory containing rights and "
                "validation configuration required "
                "to reconstruct the retained source "
                "contexts."
            ),
        )

        parser.add_argument(
            "--rights-profile",
            default="default",
            help=(
                "Rights profile used to reconstruct "
                "the persistence configuration."
            ),
        )

    helpers.add_postgres_connection_args(
        parser,
    )


def _parameters(
    args: argparse.Namespace,
) -> dict[
    str,
    Any,
]:
    """
    Build hook parameters for one parsed command.
    """
    if args.command == _CREATE_COMMAND:
        return _create_parameters(
            args,
        )

    if args.command in _REVIEW_COMMANDS:
        return _review_action_parameters(
            args,
        )

    raise ValueError(
        "Unsupported diff-review command "
        f"{args.command!r}."
    )


def _create_parameters(
    args: argparse.Namespace,
) -> dict[
    str,
    Any,
]:
    """
    Build parameters for review-job creation.
    """
    parameters: dict[
        str,
        Any,
    ] = {
        "command": _CREATE_COMMAND,
        "job_mode": args.job_mode,
        "xtf_input": args.xtf_input,
        "provider_oid": args.provider_oid,
        "dataowner_oid": args.dataowner_oid,
        "import_schema": (
            config.IMPORT_SCHEMA
        ),
        "live_schema": (
            config.TWW_OD_SCHEMA
        ),
        "orgs_path": args.orgs_path,
        "incremental_xtf": (
            args.incremental_xtf
        ),
        "incremental_import_schema": (
            config.IMPORT_SCHEMA_INCR
        ),
        "rights_profile": (
            args.rights_profile
        ),
        "hook_config_dir": (
            args.hook_config_dir
        ),
        "skip_rights_evaluation": (
            args.skip_rights_evaluation
        ),
        "auto_apply": args.auto_apply,
        "supersede_existing_diff_jobs": (
            args.supersede_existing_diff_jobs
        ),
    }

    if args.job_id is not None:
        parameters[
            "job_id"
        ] = args.job_id

    return parameters


def _review_action_parameters(
    args: argparse.Namespace,
) -> dict[
    str,
    Any,
]:
    """
    Build parameters for accept, reject or persist.
    """
    parameters: dict[
        str,
        Any,
    ] = {
        "command": args.command,
        "job_id": args.job_id,
        "expected_status": (
            args.expected_status
        ),
        "live_schema": (
            args.live_schema.strip()
        ),
    }

    if not parameters[
        "live_schema"
    ]:
        raise ValueError(
            "live_schema must be a non-empty string."
        )

    if args.command == _PERSIST_COMMAND:
        parameters.update(
            {
                "import_schema": (
                    config.IMPORT_SCHEMA
                ),
                "incremental_import_schema": (
                    config.IMPORT_SCHEMA_INCR
                ),
                "rights_profile": (
                    args.rights_profile
                ),
                "hook_config_dir": (
                    args.hook_config_dir
                ),
                "auto_apply": False,
                "skip_rights_evaluation": False,
                "supersede_existing_diff_jobs": (
                    False
                ),
            }
        )

    return parameters


if __name__ == "__main__":
    raise SystemExit(
        main()
    )