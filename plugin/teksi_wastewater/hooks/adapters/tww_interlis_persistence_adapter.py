# teksi_wastewater/hooks/adapters/tww_interlis_persistence_adapter.py

from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import Any

from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)

from teksi_wastewater.hooks.adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from teksi_wastewater.hooks.capabilities.tww_interlis_persistence_capability import (
    TwwInterlisPersistenceCapability,
    TwwInterlisPersistenceResult,
)
from teksi_wastewater.hooks.exceptions import (
    DiffJobPersistenceError,
)
from teksi_wastewater.interlis import (
    config,
)
from teksi_wastewater.interlis.model_selection import (
    model_selection_for_imported_models,
)


logger = logging.getLogger(
    __name__,
)


@dataclass(
    slots=True,
)
class TwwInterlisPersistenceAdapter(
    TwwInterlisPersistenceCapability,
):
    """
    Persist one prepared quarantine source into the live TWW schema.

    This adapter is a thin workflow boundary around
    ``TwwQuarantineRunner``.

    Baseline sources use the existing intermediate-schema importer.

    Incremental AG-XX sources use the incremental importer and therefore
    require their effective model mapping.

    The adapter does not:

    - import an XTF into quarantine;
    - recreate the quarantine schema;
    - prepare permission-restricted quarantine values;
    - create or restore backups;
    - transition diff-job status;
    - own SQLAlchemy quarantine sessions.
    """

    quarantine_runner: TwwQuarantineRunner

    def persist_quarantine(
        self,
        *,
        job_id: str,
        source_role: str,
        import_schema: str,
        live_schema: str,
        source_model: str,
        model_mapping: ModelMappingLookupCapability,
        quarantine_classes: Any,
    ) -> TwwInterlisPersistenceResult:
        """
        Persist one prepared quarantine source.

        The source role is authoritative:

        ``base``
            Import through the existing intermediate-schema importer.

        ``incremental``
            Import through the AG-XX incremental importer.

        The quarantine schema must already exist and contain all permission
        filtering performed by ``TwwQuarantinePersistencePreparer``.
        """

        self._assert_non_empty(
            job_id=job_id,
            value=job_id,
            parameter_name="job_id",
        )

        self._assert_non_empty(
            job_id=job_id,
            value=source_role,
            parameter_name="source_role",
        )

        self._assert_non_empty(
            job_id=job_id,
            value=import_schema,
            parameter_name="import_schema",
        )

        self._assert_non_empty(
            job_id=job_id,
            value=live_schema,
            parameter_name="live_schema",
        )

        self._assert_non_empty(
            job_id=job_id,
            value=source_model,
            parameter_name="source_model",
        )

        self._assert_supported_source_role(
            job_id=job_id,
            source_role=source_role,
        )

        self._assert_supported_live_schema(
            job_id=job_id,
            live_schema=live_schema,
        )

        try:
            selection_models = (
                model_selection_for_imported_models(
                    source_model,
                )
            )

        except Exception as exception:
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase=(
                    f"model_selection_{source_role}"
                ),
                message=(
                    "Could not resolve the INTERLIS model "
                    f"selection for source model "
                    f"{source_model!r}: {exception}"
                ),
            ) from exception

        incremental_only = (
            source_role
            == "incremental"
        )

        self._assert_selection_matches_role(
            job_id=job_id,
            source_role=source_role,
            incremental_only=incremental_only,
            groups=selection_models.groups,
        )

        logger.info(
            "Persisting prepared %s quarantine source from "
            "schema %r into live schema %r for source model %r.",
            source_role,
            import_schema,
            live_schema,
            source_model,
        )

        try:
            self.quarantine_runner.import_quarantine_to_live(
                import_schema=import_schema,
                live_schema=live_schema,
                selection_models=selection_models,
                model_mapping=model_mapping,
                source_role=source_role,
                quarantine_classes=quarantine_classes,
                filter_nulls=True,
            )

        except Exception as exception:
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase=(
                    f"persist_{source_role}"
                ),
                message=(
                    "The quarantine-to-live import failed for "
                    f"source role {source_role!r}, source model "
                    f"{source_model!r}, quarantine schema "
                    f"{import_schema!r}, and live schema "
                    f"{live_schema!r}: {exception}"
                ),
            ) from exception

        logger.info(
            "Committed prepared %s quarantine source from "
            "schema %r into live schema %r for source model %r.",
            source_role,
            import_schema,
            live_schema,
            source_model,
        )

        return TwwInterlisPersistenceResult(
            import_schema=import_schema,
            live_schema=live_schema,
            source_model=source_model,
            committed=True,
        )

    def assert_incremental_ready(
        self,
    ) -> None:
        """
        Require incremental persistence to be fully configured.
        """

        self.quarantine_runner.assert_incremental_ready()

    def _assert_non_empty(
        self,
        *,
        job_id: str,
        value: str,
        parameter_name: str,
    ) -> None:
        """
        Require one non-empty string parameter.
        """

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase="persistence_contract",
                message=(
                    "Persistence parameter "
                    f"{parameter_name!r} must contain a "
                    "non-empty string."
                ),
            )

    def _assert_supported_source_role(
        self,
        *,
        job_id: str,
        source_role: str,
    ) -> None:
        """
        Require one supported persistence source role.
        """

        if source_role not in {
            "base",
            "incremental",
        }:
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase="persistence_contract",
                message=(
                    "Unsupported persistence source role "
                    f"{source_role!r}. Expected 'base' or "
                    "'incremental'."
                ),
            )

    def _assert_supported_live_schema(
        self,
        *,
        job_id: str,
        live_schema: str,
    ) -> None:
        """
        Require the live schema used by the existing importers.

        The existing importer infrastructure constructs its TWW ORM against
        the configured TWW live schema. Accepting a different schema here
        would report a target that the importer does not actually use.
        """

        if live_schema != config.TWW_OD_SCHEMA:
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase="persistence_contract",
                message=(
                    "The existing quarantine-to-live importers "
                    "only support live schema "
                    f"{config.TWW_OD_SCHEMA!r}; received "
                    f"{live_schema!r}."
                ),
            )

    def _assert_selection_matches_role(
        self,
        *,
        job_id: str,
        source_role: str,
        incremental_only: bool,
        groups: tuple[
            str,
            ...,
        ],
    ) -> None:
        """
        Reject a source role that conflicts with model-selection metadata.

        The source role controls persistence dispatch. Model groups are used
        only as a consistency check.
        """

        is_agxx = bool(
            {
                "ag64",
                "ag96",
            }
            & set(
                groups,
            )
        )

        if incremental_only and not is_agxx:
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase="persistence_contract",
                message=(
                    "The incremental persistence phase resolved "
                    "a model selection without an AG64 or AG96 "
                    f"group: {groups!r}."
                ),
            )

        if (
            source_role == "base"
            and is_agxx
        ):
            raise DiffJobPersistenceError(
                job_id=job_id,
                phase="persistence_contract",
                message=(
                    "The baseline persistence phase resolved an "
                    "AG-XX model selection. AG64 and AG96 sources "
                    "must be persisted through the incremental "
                    f"phase. Groups: {groups!r}."
                ),
            )