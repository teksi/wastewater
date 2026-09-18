from __future__ import annotations

import logging
from dataclasses import dataclass

from teksi_wastewater.hooks.capabilities.tww_interlis_persistence_capability import (
    TwwInterlisPersistenceCapability,
    TwwInterlisPersistenceResult,
)
from teksi_wastewater.hooks.exceptions import (
    DiffJobPersistenceError,
)
from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
)
from teksi_wastewater.interlis.model_selection import (
    model_selection_for_imported_models,
)

logger = logging.getLogger(
    __name__,
)


from dataclasses import dataclass


@dataclass(
    slots=True,
)
class TwwInterlisPersistenceAdapter(TwwInterlisPersistenceCapability):
    """
    Persist one prepared quarantine schema through the existing importer.
    """

    importer_exporter: InterlisImporterExporter

    def persist_quarantine(
        self,
        *,
        import_schema: str,
        live_schema: str,
        source_model: str,
    ) -> TwwInterlisPersistenceResult:
        """
        Import prepared quarantine data into the live schema.

        Parameters
        ----------
        import_schema:
            Existing ili2pg quarantine schema containing the prepared source
            data.

        live_schema:
            Canonical live target schema.

        source_model:
            Primary imported INTERLIS model name stored with the diff job.

        Returns
        -------
        TwwInterlisPersistenceResult
            Result confirming that the existing importer completed and
            committed its live transaction.

        Raises
        ------
        DiffJobPersistenceError
            If the input contract is invalid, the target schema is unsupported,
            AGXX persistence is requested before its incremental importer is
            implemented, model selection fails, or the importer fails.
        """

        self._assert_non_empty(
            value=import_schema,
            parameter_name="import_schema",
        )

        self._assert_non_empty(
            value=live_schema,
            parameter_name="live_schema",
        )

        self._assert_non_empty(
            value=source_model,
            parameter_name="source_model",
        )

        self._assert_supported_live_schema(
            live_schema=live_schema,
        )

        try:
            selection_models = model_selection_for_imported_models(
                source_model,
            )
        except Exception as exception:
            raise DiffJobPersistenceError(
                job_id="unknown",
                phase="model_selection",
                message=(
                    "Could not resolve the INTERLIS model selection "
                    f"for source model {source_model!r}: "
                    f"{exception}"
                ),
            ) from exception

        incremental_only = self._incremental_only(
            groups=selection_models.groups,
        )

        if incremental_only:
            raise DiffJobPersistenceError(
                job_id="unknown",
                phase="applying",
                message=(
                    "AGXX quarantine persistence is not implemented. "
                    "Implement "
                    "InterlisImporterExporter._import_incremental() "
                    f"before applying source model {source_model!r}."
                ),
            )

        previous_schema = self.importer_exporter.schema

        try:
            self.importer_exporter.schema = import_schema

            logger.info(
                "Importing prepared quarantine schema %r into "
                "live schema %r for source model %r.",
                import_schema,
                live_schema,
                source_model,
            )

            self.importer_exporter.interlis_import_from_quarantine_to_live(
                selection_models=selection_models,
                show_selection_dialog=False,
                logs_next_to_file=False,
                filter_nulls=True,
                srid=self.importer_exporter.srid,
                incremental_only=incremental_only,
            )

        except Exception as exception:
            raise DiffJobPersistenceError(
                job_id="unknown",
                phase="applying",
                message=(
                    "The quarantine-to-live importer failed for "
                    f"source model {source_model!r}, quarantine "
                    f"schema {import_schema!r}, and live schema "
                    f"{live_schema!r}: {exception}"
                ),
            ) from exception

        finally:
            self.importer_exporter.schema = previous_schema

        logger.info(
            "Committed prepared quarantine schema %r into " "live schema %r for source model %r.",
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

    def _assert_non_empty(
        self,
        *,
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
                job_id="unknown",
                phase="applying",
                message=(
                    f"Persistence parameter "
                    f"{parameter_name!r} must contain "
                    "a non-empty string."
                ),
            )

    def _assert_supported_live_schema(
        self,
        *,
        live_schema: str,
    ) -> None:
        """
        Require the live schema supported by the existing importer.

        The existing importer constructs ModelTwwOd without receiving a
        dynamic schema. Accepting another live schema here would report a
        target that the importer does not actually use.
        """

        if live_schema != config.TWW_OD_SCHEMA:
            raise DiffJobPersistenceError(
                job_id="unknown",
                phase="applying",
                message=(
                    "The existing quarantine-to-live importer only "
                    f"supports live schema "
                    f"{config.TWW_OD_SCHEMA!r}; received "
                    f"{live_schema!r}."
                ),
            )

    def _incremental_only(
        self,
        *,
        groups: tuple[
            str,
            ...,
        ],
    ) -> bool:
        """
        Return whether the selected import uses the AGXX incremental path.
        """

        return bool(
            {
                "ag64",
                "ag96",
            }
            & set(
                groups,
            )
        )
