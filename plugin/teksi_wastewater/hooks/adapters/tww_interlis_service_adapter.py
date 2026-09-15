
from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from collections.abc import Sequence

from ...interlis.interlis_importer_exporter import InterlisImporterExporter
from ...interlis.model_config import TwwInterlisModelSelection

from teksi_hooks.services.interlis import (
    InterlisContext,
    InterlisService,
)
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from .tww_database_connection_factory import TwwDatabaseConnectionFactory




@dataclass(slots=True, frozen=True)
class TwwInterlisContext(InterlisContext):
    """
    TWW-specific INTERLIS import/export context.

    This context contains operation-level import/export options that are
    specific to the current TEKSI Wastewater importer/exporter.

    Database connection options remain outside this context and are handled by
    TwwDatabaseConnectionFactory.
    """

    srid: int = 2056

    logs_next_to_file: bool = False

    show_selection_dialog: bool = False

    filter_nulls: bool = True

    labels_file: Path | None = None

    selected_label_scale_indices: tuple[
        str,
        ...
    ] = field(
        default_factory=tuple,
    )

    selected_ids: tuple[
        str,
        ...
    ] = field(
        default_factory=tuple,
    )
    import_orgs:  bool = False

    orgs_path: Path | None = None

    limit_to_selection: bool = False
    export_orientation: int  = 90
    include_unplaced: bool = False
    disable_validation: bool = False
    incremental_only: bool = False

    def apply(
        self,
        importer_exporter,
    ) -> None:
        """
        Apply context settings to the wrapped InterlisImporterExporter.

        This intentionally only applies stable operation context. Workflow
        routing flags, such as quarantine-only behavior, are handled by
        TwwQuarantineRunner.
        """

        importer_exporter.schema = self.schema

class TwwInterlisServiceAdapter(InterlisService):
    """
    Plugin-side adapter for the existing INTERLIS importer/exporter.

    The framework uses this through the generic InterlisService contract.

    Import is used to load XTF data into an ili2pg-managed schema, typically
    the quarantine or import schema. Downstream plugin adapters can then map
    the imported ili2pg structure to canonical TEKSI Wastewater objects,
    effects and changes.

    Export remains part of the adapter because it is still useful for
    INTERLIS round-trips, delivery workflows and future headless import/export
    implementations.

    This adapter intentionally keeps the current QGIS-bound
    InterlisImporterExporter behind a framework-facing service interface.
    It will be superseded by TIT.
    """
    def __init__(
        self,
        importer_exporter: InterlisImporterExporter | None = None,
        connection_factory: DatabaseConnectionFactory | None = None,
    ) -> None:
        self._connection_factory = (
            connection_factory
            if connection_factory is not None
            else TwwDatabaseConnectionFactory.from_database_config()
        )

        self._importer_exporter = (
            importer_exporter
            if importer_exporter is not None
            else InterlisImporterExporter()
        )

    def _prepare_operation(
        self,
        context: InterlisContext,
    ) -> None:
        self._connection_factory.apply_to_database_config()
        self._apply_context(
            context,
        )

    def _apply_context(
        self,
        context: InterlisContext,
    ) -> None:
        if isinstance(
            context,
            TwwInterlisContext,
        ):
            context.apply(
                self._importer_exporter,
            )
            return

        self._importer_exporter.schema = context.schema

    def import_xtf(
        self,
        xtf_file: Path,
        context: InterlisContext,
    ) -> None:
        self._prepare_operation(
            context,
        )

        if isinstance(
            context,
            TwwInterlisContext,
        ):
            self._importer_exporter.interlis_import(
                xtf_file_input=xtf_file,
                show_selection_dialog=(
                    context.show_selection_dialog
                ),
                logs_next_to_file=(
                    context.logs_next_to_file
                ),
                filter_nulls=(
                    context.filter_nulls
                ),
                import_orgs=(
                    context.import_orgs
                ),
                srid=context.srid,
                incremental_only=context.incremental_only,
            )
            return

        self._importer_exporter.interlis_import(
            xtf_file_input=xtf_file,
        )

    def export_xtf(
        self,
        xtf_file: Path | None,
        export_models: Sequence[str],
        context: InterlisContext,
    ) -> None:
        self._prepare_operation(
            context,
        )

        if isinstance(
            context,
            TwwInterlisContext,
        ):
            self._importer_exporter.interlis_export(
                xtf_file_output=xtf_file,
                export_models=list(
                    export_models,
                ),
                logs_next_to_file=(
                    context.logs_next_to_file
                ),
                limit_to_selection=context.limit_to_selection,
                labels_file=context.labels_file,
                selected_labels_scales_indices=list(
                    context.selected_label_scale_indices,
                ),
                selected_ids=list(
                    context.selected_ids,
                ),
                srid=context.srid,
                import_orgs=context.import_orgs,
            )
            return

        self._importer_exporter.interlis_export(
            xtf_file_output=xtf_file,
            export_models=list(
                export_models,
            ),
        )

    def identify_model(
        self,
        xtf_file: Path,
    ) -> TwwInterlisModelSelection:
        """
        Identify the configured model group and language of an XTF.
        """

        return self._importer_exporter.identify_import_model(
            xtf_file_input=xtf_file,
        )

    def find_models(
        self,
        xtf_file: Path,
    ) -> tuple[
        str,
        tuple[
            str,
            ...,
        ],
    ]:
        """
        Return the import model and created model names.

        This method implements the generic INTERLIS service contract.
        Consumers needing the semantic group, language or ORM configuration
        should use ``identify_model()``.
        """

        return self.identify_model(
            xtf_file,
        )