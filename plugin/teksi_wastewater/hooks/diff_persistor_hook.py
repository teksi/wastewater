from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.hook import (
    HookBase,
    HookContext,
    HookMetadata,
)
from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from teksi_wastewater.hooks.diff_creator_hook import Hook as DiffCreatorHook
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)


class Hook(
    HookBase,
):
    """
    Persist one accepted TWW diff-review job.

    Persistence composition is owned by ``diff_creator_hook`` so the dedicated
    persistor and the CLI ``persist`` command cannot diverge in runtime-context
    reconstruction, source-role metadata handling, or ordered base/incremental
    application.
    """

    required_capabilities = frozenset(
        {
            DatabaseConnectionFactory,
        }
    )

    @property
    def metadata(
        self,
    ) -> HookMetadata:
        return HookMetadata(
            name="Persist TWW Diff Review Job",
            description=(
                "Applies one accepted TWW diff-review job from its retained "
                "base and optional incremental quarantine schemas to the live "
                "TWW database."
            ),
        )

    def run_hook(
        self,
        context: HookContext,
    ) -> None:
        """
        Persist one accepted review job through the shared implementation.
        """
        context.logger.info("Starting TWW diff persistor hook.")

        connection_factory = context.capability(
            DatabaseConnectionFactory,
        )

        if not isinstance(
            connection_factory,
            TwwDatabaseConnectionFactory,
        ):
            raise TypeError(
                "The TWW diff persistor hook requires a " "TwwDatabaseConnectionFactory."
            )

        job_id = self._required_string(
            parameters=context.parameters,
            key="job_id",
        )

        shared_hook = DiffCreatorHook()
        shared_hook.connection_factory = connection_factory
        shared_hook.job_id = job_id
        shared_hook.diff_schema_service = TwwDiffSchemaService(
            connection_factory=connection_factory,
        )

        shared_hook._persist_existing_job(
            context=context,
        )

    def _required_string(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> str:
        """
        Return one required non-empty hook parameter.
        """
        value = parameters.get(
            key,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(f"Parameter {key!r} must be a non-empty string.")

        return value.strip()
