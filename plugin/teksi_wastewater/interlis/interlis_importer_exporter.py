from collections.abc import Collection
from dataclasses import dataclass
import logging
import os
import socket
import tempfile
from pathlib import Path
from typing import Iterable

import requests

from ..utils.database_utils import DatabaseUtils
from ..utils.integrity_checker import TWWIntegrityChecker
from . import config,model_selection
from .interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
    InterlisExporterToIntermediateSchemaError,
)
from .interlis_model_mapping.interlis_importer_from_intermediate_schema import (
    InterlisImporterFromIntermediateSchema,
)
from .interlis_model_mapping.model_interlis_ag64 import ModelInterlisAG64
from .interlis_model_mapping.model_interlis_ag96 import ModelInterlisAG96
from .interlis_model_mapping.model_interlis_dss import ModelInterlisDss
from .interlis_model_mapping.model_interlis_sia405_abwasser import (
    ModelInterlisSia405Abwasser,
)
from .interlis_model_mapping.model_interlis_sia405_base_abwasser import (
    ModelInterlisSia405BaseAbwasser,
)
from .interlis_model_mapping.model_interlis_vsa_kek import ModelInterlisVsaKek
from .interlis_model_mapping.model_tww import ModelTwwSys, ModelTwwVl
from .interlis_model_mapping.model_tww_ag6496 import ModelTwwAG6496
from .interlis_model_mapping.model_tww_od import ModelTwwOd
from .utils.ili2db import InterlisTools
from .utils.various import (
    CmdException,
    InterlisImporterExporterError,
    InterlisImporterExporterStopped,
    LoggingHandlerContext,
    logger,
    make_log_path,
)
from .model_config import (
    InterlisLangModel,
    InterlisModel,
    interlis_models,
    TwwInterlisModelSelection,
)

@dataclass(slots=True, frozen=True)
class ProgressScope:
    """
    Maps phase-local progress values to workflow-level progress values.

    A phase can report progress from 0 to 100, while the caller decides
    whether that phase represents the full workflow or only part of it.
    """

    start: float = 0
    end: float = 100

    def map(
        self,
        value: float,
    ) -> float:
        return self.start + (
            self.end
            - self.start
        ) * value / 100

class InterlisImporterExporter:

    def __init__(self, progress_done_callback=None, lang = 'de'):
        self.progress_done_callback = progress_done_callback
        self.interlisTools = InterlisTools()
        self.base_log_path = None

        self.model_classes_interlis = None
        self.model_classes_tww_od = None
        self.model_classes_tww_vl = None
        self.model_classes_tww_sys = None
        self.model_classes_tww_app = None

        self.from_quarantine_only = False
        self.to_quarantine_only = False
        self.language = lang

        self.filter_nulls = None
        self.srid = 2056
        self.current_progress = 0
        self.schema =None

    def _init_model_classes(self, selection_models):
        model_interlis = selection_models.primary_component.quarantine_model(self.schema)

        if model_interlis is None:
            raise InterlisImporterExporterError(
                "Unsupported INTERLIS model",
                "No model class found.",
                None,
            )

        self.model_classes_interlis = model_interlis.classes()
        self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_od is None:
            self.model_classes_tww_od = ModelTwwOd().classes()
            self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_vl is None:
            self.model_classes_tww_vl = ModelTwwVl().classes()
            self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_sys is None:
            self.model_classes_tww_sys = ModelTwwSys().classes()
            self._progress_done(self.current_progress + 1)

        if any( group in {"ag64", "ag96"} for group in selection_models.groups) and self.model_classes_tww_app is None:
            self.model_classes_tww_app = ModelTwwAG6496().classes()
            self._progress_done(self.current_progress + 1)

    def _progress_done_in_scope(
        self,
        scope: ProgressScope,
        progress: float,
        text=None,
    ):
        self._progress_done(
            scope.map(
                progress,
            ),
            text,
        )

    def interlis_import(
        self,
        xtf_file_input,
        show_selection_dialog=False,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = None,
        import_orgs=False,
        user_interaction=False,
        incremental_only=False,
    ):
        if not self.schema:
            self.schema=config.IMPORT_SCHEMA

        self._clear_ili_schema(recreate_tables=True)
        selection_models=self.interlis_import_to_quarantine(
            xtf_file_input=xtf_file_input,
            logs_next_to_file=logs_next_to_file,
            filter_nulls=filter_nulls,
            srid = srid,
            import_orgs=import_orgs,
            disable_validation=False,
            progress_scope=ProgressScope(
                start=self.current_progress,
                end=35,
            ),
            incremental_only=incremental_only,
        )
        self.interlis_import_from_quarantine_to_live(
            selection_models=selection_models,
            show_selection_dialog=show_selection_dialog,
            logs_next_to_file=logs_next_to_file,
            filter_nulls=filter_nulls,
            srid = srid,
            progress_scope=ProgressScope(
                start=35,
                end=100,
            ),
            incremental_only=incremental_only,
        )

    def _prepare_interlis_import(
        self,
        xtf_file_input=None,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = 2056,
        selection_models: TwwInterlisModelSelection | None = None,
        progress_scope: ProgressScope = ProgressScope(),
        incremental_only=False,
    ) -> TwwInterlisModelSelection:
        if logs_next_to_file and xtf_file_input:
            self.base_log_path = xtf_file_input
        else:
            self.base_log_path = None

        self.filter_nulls = filter_nulls

        if not self.schema:
            self.schema = config.IMPORT_SCHEMA

        if srid:
            self.srid = srid

        if selection_models is not None:
            if (
                selection_models.import_model
                not in {
                    "Genereller_Entwaesserungsplan_AG",
                    "Abwasserkataster_AG_V2_LV95",
                }
                and incremental_only
            ):
                raise InterlisImporterExporterError(
                    error=(
                        "incremental_only flag is not applicable "
                        f"to {selection_models.import_model}."
                    )
                )

            return selection_models

        if not xtf_file_input:
            raise InterlisImporterExporterError(
                error=(
                    "Cannot prepare INTERLIS import without either "
                    "selection_models or xtf_file_input."
                )
            )

        self._progress_done_in_scope(
            progress_scope,
            5,
            "Extract model from xtf...",
        )

        return self.find_import_selection_models(
            xtf_file_input,
        )

    def interlis_import_to_quarantine(
        self,
        xtf_file_input,
        orgs_path: Path | None = None,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = 2056,
        import_orgs=False,
        disable_validation=False,
        progress_scope: ProgressScope = ProgressScope(),
        incremental_only=False,
        
    ):
            selection_models=self._prepare_interlis_import(
                xtf_file_input=xtf_file_input,
                logs_next_to_file=logs_next_to_file,
                filter_nulls=filter_nulls,
                srid=srid,
                progress_scope=progress_scope,
                incremental_only=incremental_only,
                )

            created_models = tuple(selection_models.created_models)

            if not created_models:
                raise InterlisImporterExporterError(
                    "Missing model",
                    (
                        "Could not determine INTERLIS model names required to create "
                        "the quarantine schema."
                    ), None,
                )

            # Validating the input file
            if not disable_validation:
                self._progress_done_in_scope(progress_scope, 10, "Validating the input file...")
                self._import_validate_xtf_file(xtf_file_input)


            # Prepare the temporary ili2pg model
            self._progress_done_in_scope(progress_scope, 35, "Creating ili schema...")

            self._create_ili_schema(
                created_models, ext_columns_no_constraints=True, create_basket_col=True
            )

            if import_orgs or orgs_path:
                if orgs_path:
                    self._import_validate_xtf_file(orgs_path)
                    self._import_xtf_file(orgs_path)
                else:
                    self.import_vsa_orgs()

            # Import from xtf file to ili2pg model
            self._progress_done_in_scope(progress_scope,50, "Importing XTF data...")
            self._import_xtf_file(xtf_file_input=xtf_file_input)
            self._progress_done_in_scope(progress_scope, 100, "INTERLIS import into quarantine schema finished.")

            return selection_models

    def interlis_import_from_quarantine_to_live(
        self,
        selection_models: TwwInterlisModelSelection,
        show_selection_dialog=False,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = None,
        progress_scope: ProgressScope = ProgressScope(),
        incremental_only=False,
    ):

            selection_models =self._prepare_interlis_import(
                logs_next_to_file=logs_next_to_file,
                filter_nulls=filter_nulls,
                srid=srid,
                selection_models=selection_models,
                progress_scope=progress_scope,
                incremental_only=incremental_only,
                )
            
            # Disable symbology triggers
            self._progress_done_in_scope(progress_scope, 10, "Disable symbology and modification triggers...")
            self._import_disable_symbology_and_modification_triggers()

            try:
                if incremental_only:
                    # Import from the temporary ili2pg model
                    self._progress_done_in_scope(progress_scope, 20, "Converting incremental values to TEKSI Wastewater...")
                    tww_session = self._import_incremental(selection_models.import_model)
                    self._progress_done_in_scope(progress_scope, 80, "Commit session...")
                    tww_session.commit()
                    tww_session.close()
                else:
                    # Import from the temporary ili2pg model
                    self._progress_done_in_scope(progress_scope, 20, "Converting to TEKSI Wastewater...")
                    tww_session = self._import_from_intermediate_schema(selection_models)

                    if show_selection_dialog:
                        from qgis.PyQt.QtCore import Qt
                        from qgis.PyQt.QtWidgets import QApplication, QDialog
                        from .gui.interlis_import_selection_dialog import InterlisImportSelectionDialog

                        self._progress_done_in_scope(progress_scope, 80, "Import objects selection...")
                        import_dialog = InterlisImportSelectionDialog()
                        import_dialog.init_with_session(tww_session)
                        QApplication.restoreOverrideCursor()
                        if import_dialog.exec() == QDialog.DialogCode.Rejected:
                            tww_session.rollback()
                            tww_session.close()
                            raise InterlisImporterExporterStopped()
                        QApplication.setOverrideCursor(Qt.CursorShape.WaitCursor)
                    else:
                        self._progress_done_in_scope(progress_scope, 80, "Commit session...")
                        tww_session.commit()
                    tww_session.close()

                # Update the sequence values
                self._progress_done_in_scope(progress_scope, 85, "Update sequence values...")
                self._import_set_od_sequences()

                # Update main_cover and main_wastewater_node
                self._progress_done_in_scope(progress_scope, 90, "Update main cover and refresh materialized views...")
                self._import_update_main_cover_and_refresh_mat_views()

                # Validate subclasses after import
                integrityChecker = TWWIntegrityChecker(logger=logger)
                _ = integrityChecker._check_subclass_counts(raise_err=True)

                # Update organisations
                self._progress_done_in_scope(progress_scope, 95, "Set organisations filter...")
                self._import_manage_organisations()

                # Reenable symbology triggers
                self._progress_done_in_scope(progress_scope, 97, "Reenable symbology and modification triggers...")
                self._import_enable_symbology_and_modification_triggers()

            except Exception as exception:
                # Make sure to re-enable triggers in case an exception occourred
                try:
                    self._import_enable_symbology_and_modification_triggers()
                except Exception as enable_trigger_exception:
                    logger.error(
                        f"Symbology triggers couldn't be re-enabled because an exception occourred: '{enable_trigger_exception}'"
                    )

                # Raise the original exception for further error handling
                raise exception

            self._progress_done_in_scope(progress_scope, 100)
            logger.info("INTERLIS import finished.")

    def find_import_selection_models(
        self,
        xtf_file_input: Path,
    ) -> TwwInterlisModelSelection:
        selection = self.identify_import_model(
            xtf_file_input,
        )

        logger.info(
            "Models %r were chosen for import among imported models %r.",
            selection.created_models,
            selection.imported_models,
        )

        return selection

    def execute_export(
        self,
        xtf_file_output,
        export_models: Collection[str],
        logs_next_to_file=True,
        limit_to_selection=False,
        export_orientation=90.0,
        labels_file=None,
        selected_labels_scales_indices=[],
        selected_ids=None,
        include_unplaced: bool = False,
        import_orgs: bool = False,
    ):

        self.interlis_export_live_to_quarantine(
            xtf_file_output=xtf_file_output,
            export_models=export_models,
            logs_next_to_file=logs_next_to_file,
            limit_to_selection=limit_to_selection,
            export_orientation=export_orientation,
            labels_file=labels_file,
            selected_labels_scales_indices=selected_labels_scales_indices,
            selected_ids=selected_ids,
            include_unplaced=include_unplaced,
            import_orgs = import_orgs,
            progress_scope=ProgressScope(
                start=self.current_progress,
                end=65,
            ),
        )

        self.interlis_export_from_quarantine_to_xtf(
            xtf_file_output=xtf_file_output,
            export_models=export_models,
            logs_next_to_file=logs_next_to_file,
            progress_scope=ProgressScope(
                start=65,
                end=100,
            ),
        )

    def _prepare_interlis_export(
        self,
        xtf_file_output=None,
        logs_next_to_file=True,
    ):
        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(xtf_file_output)

        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_output
        else:
            self.base_log_path = None

        if not self.schema:
            self.schema = config.EXPORT_SCHEMA

        return file_name_base

    def interlis_export_live_to_quarantine(
        self,
        xtf_file_output,
        export_models: Collection[str],
        logs_next_to_file=True,
        limit_to_selection=False,
        export_orientation=90.0,
        labels_file=None,
        selected_labels_scales_indices=[],
        selected_ids=None,
        include_unplaced: bool = False,
        import_orgs: bool = False,
        progress_scope: ProgressScope = ProgressScope(),
    ):

        _=self._prepare_interlis_export(
            xtf_file_output=xtf_file_output,
            logs_next_to_file=logs_next_to_file,
        )
        if not self.from_quarantine_only:
            self._progress_done_in_scope(progress_scope, 5, "Clearing ili schema...")
            self._clear_ili_schema(recreate_tables=True)

            self._progress_done_in_scope(progress_scope, 15, "Creating ili schema...")
            create_basket_col = False
            export_models = set(export_models)
            selection_models = model_selection.selection_models_for_imported_models(export_models)
            if "vsa_kek" in selection_models.groups:
                create_basket_col = True
            self._create_ili_schema(export_models, create_basket_col=create_basket_col)


            # Export the labels file
            tempdir = tempfile.TemporaryDirectory()
            if len(selected_labels_scales_indices):
                if not labels_file:
                    self._progress_done_in_scope(progress_scope, 30, "Creating labels")
                    labels_file = os.path.join(tempdir.name, "labels.geojson")
                    self._export_labels_file(
                        limit_to_selection=limit_to_selection,
                        selected_labels_scales_indices=selected_labels_scales_indices,
                        labels_file_path=labels_file,
                        model_groups=selection_models.groups,
                        export_orientation=export_orientation,
                        include_unplaced=include_unplaced,
                    )


            if "ag96" in selection_models.groups:
                self._progress_done_in_scope(progress_scope, 35, "Importing AG-96 organisations to intermediate schema")
                file_path = "data/Organisationstabelle_AG96.xtf"
                abs_file_path = Path(__file__).parent.resolve() / file_path
                logger.info("Importing AG-96 organisation to intermediate schema")
                self._import_xtf_file(abs_file_path)
            elif "ag64" in selection_models.groups:
                self._progress_done_in_scope(progress_scope, 35, "Importing AG-64 organisations to intermediate schema")
                file_path = "data/Organisationstabelle_AG64.xtf"
                abs_file_path = Path(__file__).parent.resolve() / file_path
                logger.info("Importing AG-64 organisation to intermediate schema")
                self._import_xtf_file(abs_file_path)
            elif import_orgs:
                self._progress_done_in_scope(progress_scope, 35, "Importing VSA organisations to intermediate schema")
                self.import_vsa_orgs()

            # Export to the temporary ili2pg model
            self._progress_done_in_scope(progress_scope, 45, "Converting from TEKSI Wastewater to intermediate schema...")
            self._export_to_intermediate_schema(
                selection_models=selection_models,
                file_name=xtf_file_output,
                selected_ids=selected_ids,
                export_orientation=export_orientation,
                labels_file_path=labels_file,
                basket_enabled=create_basket_col,
            )
            tempdir.cleanup()  # Cleanup
            self._progress_done_in_scope(progress_scope, 100, "Converted from TEKSI Wastewater to intermediate schema")

    def interlis_export_from_quarantine_to_xtf(
        self,
        xtf_file_output,
        export_models=None,
        logs_next_to_file=True,
        progress_scope: ProgressScope = ProgressScope(),
    ):
        file_name_base=self._prepare_interlis_export(
            xtf_file_output=xtf_file_output,
            logs_next_to_file=logs_next_to_file,
        )
            
        self._progress_done_in_scope(progress_scope, 0, "starting INTERLIS export")
        self._export_xtf_files(file_name_base, export_models)

        self._progress_done_in_scope(progress_scope, 100, "INTERLIS export finished.")
        logger.info("INTERLIS export finished.")

    def interlis_export(
        self,
        xtf_file_output,
        export_models,
        logs_next_to_file=True,
        user_interaction=False,
        limit_to_selection=False,
        export_orientation=90.0,
        labels_file=None,
        selected_labels_scales_indices=[],
        selected_ids=None,
        srid: int = None,
        include_unplaced: bool = False,
        import_orgs: bool = False,
    ):
        if not self.schema:
            self.schema=config.EXPORT_SCHEMA
        if srid:
            self.srid = srid

        if not self.from_quarantine_only:
            exportChecker = TWWIntegrityChecker(
                models=export_models, limit_to_selection=limit_to_selection, logger=logger
            )
            if export_models[0] == "SIA405_Base_Abwasser_1_LV95":
                failed, errormsg, _ = exportChecker._check_organisation_tww_local_extension_count()
                if failed:
                    logger.info(
                        "INTERLIS export has been stopped as there have been no organisations for exporting!"
                    )
                    # self._progress_done_in_scope(progress_scope, 100, "Export aborted...")
                    # return
                    raise InterlisImporterExporterError(
                        "INTERLIS Export aborted!",
                        errormsg,
                        None,
                    )
                else:
                    logger.info("INTERLIS export continued as organisations are available!")
                    logger.info(f"Debug.print export_model '{export_models[0]}, case False'")
            else:
                logger.info(f"Debug.print export_model '{export_models[0]}'")

            # go thru all available checks and register if check failed or not.

            results = exportChecker.run_integrity_checks()
            if not results.failed:
                logger.info(f"All checks passed! ({results['stats']['ok']} OK)")
            else:
                if user_interaction:
                    from qgis.PyQt.QtWidgets import QMessageBox

                    logger.debug("Adding QMessageBox ...")
                    # Add Message box to ask if export should still be continued or not

                    mb = QMessageBox()

                    # TypeError: warning(parent: Optional[QWidget], title: Optional[str], text: Optional[str], buttons: Union[QMessageBox.StandardButtons, QMessageBox.StandardButton] = QMessageBox.Ok, defaultButton: QMessageBox.StandardButton = QMessageBox.NoButton): not enough arguments

                    # mb = QMessageBox.warning(
                    # self,
                    # 'Stop exporting',
                    # 'Do you want to quit?',
                    # QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
                    # )
                    mb.setWindowTitle("Stop exporting")
                    mb.setIcon(QMessageBox.Warning)
                    mb.setText(
                        "Stop exporting: Some export checks failed - check the logs for details. (if you have a selection you can still try (click Cancel) "
                    )
                    mb.setInformativeText(
                        f" {results['stats']['failed']} failed, {results['stats']['ok']} passed"
                    )
                    mb.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
                    return_value = mb.exec()
                    if return_value == QMessageBox.Ok:
                        errormsg = "INTERLIS export has been stopped due to failing export checks - see logs for details."
                        logger.info(
                            "INTERLIS export has been stopped due to failing export checks - see logs for details."
                        )
                        # self._progress_done_in_scope(progress_scope, 100, "Export aborted...")
                        # return
                        raise InterlisImporterExporterError(
                            "INTERLIS Export aborted!",
                            errormsg,
                            None,
                        )
                    elif return_value == QMessageBox.Cancel:
                        logger.info(
                            "INTERLIS export has been continued manually in spite of failing export checks."
                        )

                else:
                    msg='\n'.join(issue.message for issue in results.failed_checks)
                    logger.error(f"Failed checks:{msg}")
                    logger.info(
                        f" {results.stats['failed']} failed, {results.stats['ok']} passed"
                    )
                    logger.info(
                        "INTERLIS export has been stopped due to failing export checks - see logs for details."
                    )
                    raise InterlisImporterExporterError(
                        "INTERLIS Export aborted!",
                        "\n".join(issue.message for issue in results.failed_checks),
                        None,
                    )
        self.execute_export(
                    xtf_file_output,
                    export_models,
                    logs_next_to_file,
                    limit_to_selection,
                    export_orientation,
                    labels_file,
                    selected_labels_scales_indices,
                    selected_ids,
                    import_orgs,
                )

    def _import_validate_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ilivalidator")
        try:
            self.interlisTools.validate_xtf_data(
                xtf_file_input,
                log_path,
            )
        except CmdException:
            try:
                with open(
                    log_path,
                    encoding="utf-8",
                    errors="replace",
                ) as log_file:
                    log_content = log_file.read()

                print(
                    "\n===== ilivalidator log start =====\n"
                    f"{log_content}"
                    "\n===== ilivalidator log end =====\n"
                )
            except OSError as exc:
                print(
                    "\n===== ilivalidator log unavailable =====\n"
                    f"log_path: {log_path}\n"
                    f"error: {exc!r}\n"
                    "===== ilivalidator log unavailable end =====\n"
                )
            raise InterlisImporterExporterError(
                "Invalid file",
                "The input file is not a valid XTF file. Open the logs for more details on the error.",
                log_path,
            )

    def validate_quarantine_schema(
        self,
        model_name,
    ):
        if not model_name:
            raise InterlisImporterExporterError(
                "Invalid quarantine schema",
                "Cannot validate quarantine schema without model name.",
                None,
            )

        log_path = make_log_path(
            self.base_log_path,
            "ili2pg_validate",
        )

        try:
            self.interlisTools.validate_db_data(
                schema=self.schema,
                log_path=log_path,
                model_name=model_name,
                srid=self.srid,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Invalid quarantine schema",
                (
                    "The quarantine schema is not valid according to "
                    "the INTERLIS model. Open the logs for details."
                ),
                log_path,
            )

    def _import_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ili2pg-import")
        try:
            self.interlisTools.import_xtf_data(
                self.schema,
                xtf_file_input,
                log_path,
                self.srid,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Could not import data",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _import_from_intermediate_schema(self, selection_models):
        log_handler = logging.FileHandler(
            make_log_path(self.base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        self._init_model_classes(selection_models)

        interlisImporterFromIntermediateSchema = InterlisImporterFromIntermediateSchema(
            model=selection_models.import_model,
            model_classes_interlis=self.model_classes_interlis,
            model_classes_tww_od=self.model_classes_tww_od,
            model_classes_tww_vl=self.model_classes_tww_vl,
            model_classes_tww_app=self.model_classes_tww_app,
            callback_progress_done=self._progress_done_intermediate_schema,
            filter_nulls=self.filter_nulls,
        )

        with LoggingHandlerContext(log_handler):
            interlisImporterFromIntermediateSchema.tww_import(skip_closing_tww_session=True)

        return interlisImporterFromIntermediateSchema.session_tww

    def _import_set_od_sequences(self):
        logger.info("Set Sequence values")
        DatabaseUtils.execute("SELECT tww_app.reset_od_seqval();")

    def _import_manage_organisations(self):
        logger.info("Update organisation tww_active")
        DatabaseUtils.execute("SELECT tww_app.set_organisations_active();")

    def _import_update_main_cover_and_refresh_mat_views(self):
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("Update wastewater structure fk_main_cover")
            cursor.execute("SELECT tww_app.wastewater_structure_update_fk_main_cover('', True);")

            logger.info("Update wastewater structure fk_main_wastewater_node")
            cursor.execute(
                "SELECT tww_app.wastewater_structure_update_fk_main_wastewater_node('', True);"
            )

            logger.info("Refresh materialized views")
            cursor.execute("SELECT tww_app.network_refresh_network_simple();")

    def _import_disable_symbology_and_modification_triggers(self):
        DatabaseUtils.disable_symbology_triggers()
        DatabaseUtils.disable_modification_triggers()

    def _import_enable_symbology_and_modification_triggers(self):
        DatabaseUtils.enable_symbology_triggers()
        DatabaseUtils.update_symbology()
        DatabaseUtils.enable_modification_triggers()

    def _export_labels_file(
        self,
        limit_to_selection,
        selected_labels_scales_indices,
        labels_file_path,
        model_groups,
        export_orientation=90.0,
        include_unplaced=False,
        progress_scope: ProgressScope = ProgressScope(),
    ):
        self._progress_done_in_scope(progress_scope, self.current_progress, "Extracting labels...")

        try:
            # We only import now to avoid useless exception if dependencies aren't met
            from qgis import processing

            from ..utils.twwlayermanager import TwwLayerManager
        except ImportError:
            raise InterlisImporterExporterError(
                "Export labels error",
                "Could not load export labels as qgis.processing module is not available.",
                None,
            )

        structures_lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
        reaches_lyr = TwwLayerManager.layer("vw_tww_reach")
        if not structures_lyr or not reaches_lyr:
            raise InterlisImporterExporterError(
                "Could not find the vw_tww_wastewater_structure and/or the vw_tww_reach layers.",
                "Make sure your TEKSI Wastewater project is open.",
                None,
            )

        self._progress_done_in_scope(progress_scope, self.current_progress + 2)
        if "ag96" in model_groups:
            catch_lyr = TwwLayerManager.layer("vw_tww_catchment_area")
            meas_pt_lyr = TwwLayerManager.layer("measure_point")
            meas_lin_lyr = TwwLayerManager.layer("measure_line")
            meas_ply_lyr = TwwLayerManager.layer("measure_polygon")
            building_group_lyr = TwwLayerManager.layer("building_group")

            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "CATCHMENT_LAYER": catch_lyr,
                    "MEASURE_POINT_LAYER": meas_pt_lyr,
                    "MEASURE_LINE_LAYER": meas_lin_lyr,
                    "MEASURE_POLYGON_LAYER": meas_ply_lyr,
                    "BUILDING_GROUP_LAYER": building_group_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "REPLACE_WS_WITH_WN": True,
                    "INPUT_INCLUDE_UNPLACED": include_unplaced,
                },
            )
        elif "dss" in model_groups:
            catch_lyr = TwwLayerManager.layer("vw_tww_catchment_area")

            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "CATCHMENT_LAYER": catch_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "INPUT_INCLUDE_UNPLACED": include_unplaced,
                },
            )
        elif "ag64" in model_groups:
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "REPLACE_WS_WITH_WN": True,
                    "INPUT_INCLUDE_UNPLACED": include_unplaced,
                },
            )
        else:
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "EXPORT_ORIENTATION": export_orientation,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "INPUT_INCLUDE_UNPLACED": include_unplaced,
                },
            )

    def _export_to_intermediate_schema(
        self,
        selection_models,
        file_name=None,
        selected_ids=None,
        export_orientation=90.0,
        labels_file_path=None,
        basket_enabled=False,
    ):
        log_handler = logging.FileHandler(
            make_log_path(file_name, "tww2ili-export"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        self._init_model_classes(selection_models)

        twwInterlisExporter = InterlisExporterToIntermediateSchema(
            export_model_groups=selection_models.groups,
            model_classes_interlis=self.model_classes_interlis,
            model_classes_tww_od=self.model_classes_tww_od,
            model_classes_tww_vl=self.model_classes_tww_vl,
            model_classes_tww_sys=self.model_classes_tww_sys,
            model_classes_tww_app=self.model_classes_tww_app,
            labels_orientation_offset=export_orientation,
            selection=selected_ids,
            labels_file=labels_file_path,
            basket_enabled=basket_enabled,
            callback_progress_done=self._progress_done_intermediate_schema,
        )

        with LoggingHandlerContext(log_handler):
            try:
                twwInterlisExporter.tww_export()
            except (
                InterlisExporterToIntermediateSchemaError
            ) as interlisExporterToIntermediateSchemaError:
                raise InterlisImporterExporterError(
                    "Could not export to the interlis schema",
                    f"{interlisExporterToIntermediateSchemaError}",
                    None,
                )

    def _export_xtf_files(self, file_name_base, export_models, progress_scope: ProgressScope = ProgressScope()):
        progress_step = (100 - self.current_progress) / (2 * len(export_models))
        progress_step = int(progress_step)

        xtf_export_errors = []
        for index, export_model_name in enumerate(export_models):
            export_file_name = f"{file_name_base}_{export_model_name}.xtf"

            # Export from ili2pg model to file
            self._progress_done_in_scope(progress_scope, self.current_progress, f"Saving XTF for '{export_model_name}'...")
            log_path = make_log_path(self.base_log_path, f"ili2pg-export-{export_model_name}")
            try:
                self.interlisTools.export_xtf_data(
                    schema=self.schema,
                    xtf_file=export_file_name,
                    log_path=log_path,
                    model_name=export_model_name,
                    export_model_name=export_model_name,
                    srid=self.srid,
                )
            except CmdException:
                xtf_export_errors.append(
                    InterlisImporterExporterError(
                        error=f"Could not export the model '{export_model_name}' from ili2pg schema",
                        additional_text="Open the logs for more details on the error.",
                        log_path=log_path,
                    )
                )
                continue

            self._progress_done_in_scope(progress_scope,
                self.current_progress + progress_step,
                f"Validating XTF for '{export_model_name}'...",
            )
            log_path = make_log_path(self.base_log_path, f"ilivalidator-{export_model_name}")
            try:
                self.interlisTools.validate_xtf_data(
                    export_file_name,
                    log_path,
                )
            except CmdException:
                xtf_export_errors.append(
                    InterlisImporterExporterError(
                        error=f"Validation of exported file '{export_file_name}' failed",
                        additional_text=f"The created file is not a valid {export_model_name} XTF file.",
                        log_path=log_path,
                    )
                )
                continue

            self._progress_done_in_scope(progress_scope, self.current_progress + progress_step)

        # In case some export had an error raise the first one
        if xtf_export_errors:
            raise xtf_export_errors[0]

    def _clear_ili_schema(self, recreate_tables=False):
        logger.info("CONNECTING TO DATABASE...")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(
                f"SELECT schema_name FROM information_schema.schemata WHERE schema_name = '{self.schema}';"
            )
            if cursor.rowcount == 0:
                cursor.execute(f"CREATE SCHEMA {self.schema};")
            else:
                cursor.execute(
                    f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{self.schema}';"
                )
                logger.info(f"Truncating all tables in schema {self.schema}")
                rows = cursor.fetchall()
                if recreate_tables:
                    logger.info(f"Deleting all tables in schema {self.schema} ")
                    for row in rows:
                        cursor.execute(f"DROP TABLE {self.schema}.{row[0]} CASCADE;")
                else:
                    for row in rows:
                        cursor.execute(
                            f"TRUNCATE TABLE {self.schema}.{row[0]} CASCADE;"
                        )

    def _create_ili_schema(
        self, models, ext_columns_no_constraints=False, create_basket_col=False
    ):
        log_path = make_log_path(self.base_log_path, "ili2pg-schemaimport")
        try:
            self.interlisTools.import_ili_schema(
                self.schema,
                models,
                log_path,
                ext_columns_no_constraints=ext_columns_no_constraints,
                create_basket_col=create_basket_col,
                srid=self.srid,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _progress_done_intermediate_schema(self, progress_scope: ProgressScope = ProgressScope()):
        self._progress_done_in_scope(progress_scope,self.current_progress + 0.5)

    def _progress_done(self, progress, text=None):
        self.current_progress = progress
        if self.progress_done_callback:
            self.progress_done_callback(int(progress), text)

    def _has_internet(self, url: str = None, timeout=1):
        from urllib.parse import urlparse

        try:
            if url:
                host = urlparse(url).hostname
            else:
                host = "vsa.ch"

            if not isinstance(host, str):
                return False

            socket.create_connection((host, 443), timeout=timeout)
            return True

        except OSError:
            return False

    def import_vsa_orgs(self):
        if self._has_internet():
            try:
                response = requests.get(config.VSA_ORG_URL, timeout=(2, 10))
                response.raise_for_status()

                tmp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".xtf")
                tmp_file.write(response.content)
                tmp_file.close()

                logger.info(f"Downloaded VSA organisations file to {tmp_file.name}")
                orgs_path = Path(tmp_file.name)
                logger.info("Importing VSA organisation to intermediate schema")
                self._import_xtf_file(orgs_path)

            except Exception as e:
                logger.warning(f"Could not download VSA file: {e}")
            finally:
                try:
                    os.remove(tmp_file.name)
                except Exception:
                    pass

        else:
            logger.warning(
                "No internet connection detected → skipping download of vsa organisations"
            )

    def identify_import_model(
        self,
        xtf_file_input: Path,
    ) -> TwwInterlisModelSelection:
        """
        Identify the semantic model group and language used by an XTF transfer.

        The returned selection is the authoritative model context for subsequent
        import, mapping and relation-context construction.
        """

        imported_models = tuple(
            self.interlisTools.get_xtf_models(
                xtf_file_input,
            )
        )

        if not imported_models:
            raise InterlisImporterExporterError(
                "Import error",
                f"No model was found in {xtf_file_input!s}.",
                None,
            )

        try:
            return (
                model_selection
                .model_selection_for_imported_models(
                    imported_models,
                )
            )
        except LookupError as exception:
            raise InterlisImporterExporterError(
                "Import error",
                str(
                    exception,
                ),
                None,
            ) from exception

    def selection_models_for_imported_models(
        imported_models: str | Iterable[str],
    ) -> tuple[
        str,
        InterlisLangModel,
        InterlisModel,
    ]:
        """
        Resolve one configured semantic model from imported INTERLIS names.
        """

        if isinstance(
            imported_models,
            str,
        ):
            imported_model_names = {
                imported_models,
            }
        else:
            imported_model_names = set(
                imported_models,
            )

        matches = [
            (
                group,
                language_model,
                model,
            )
            for group, model in interlis_models.items()
            for language_model in model.models
            if language_model.model in imported_model_names
        ]

        if not matches:
            raise LookupError(
                "No configured INTERLIS model matches imported models "
                f"{sorted(imported_model_names)!r}."
            )

        matched_groups = {
            group
            for group, _, _ in matches
        }

        if len(
            matched_groups,
        ) != 1:
            raise LookupError(
                "Imported models resolve to multiple semantic model "
                f"groups: {sorted(matched_groups)!r}."
            )

        exact_matches = [
            match
            for match in matches
            if match[1].model in imported_model_names
        ]

        if len(
            exact_matches,
        ) != 1:
            raise LookupError(
                "Imported models do not resolve to exactly one configured "
                "model and language: "
                f"{sorted(imported_model_names)!r}."
            )

        return exact_matches[0]

    def _import_incremental(self, import_model):
        pass