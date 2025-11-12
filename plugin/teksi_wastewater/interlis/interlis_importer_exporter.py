import logging
import os
import tempfile
from pathlib import Path

from ..utils.database_utils import DatabaseUtils
from . import config
from .gui.interlis_import_selection_dialog import InterlisImportSelectionDialog
from .interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
    InterlisExporterToIntermediateSchemaError,
)
from .interlis_model_mapping.interlis_importer_to_intermediate_schema import (
    InterlisImporterToIntermediateSchema,
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
from .utils.interlis_export_checker import TWWExportChecker
from .utils.various import (
    CmdException,
    InterlisImporterExporterError,
    InterlisImporterExporterStopped,
    LoggingHandlerContext,
    logger,
    make_log_path,
)


class InterlisImporterExporter:

    def __init__(self, progress_done_callback=None):
        self.progress_done_callback = progress_done_callback
        self.interlisTools = InterlisTools()
        self.base_log_path = None

        self.model_classes_interlis = None
        self.model_classes_tww_od = None
        self.model_classes_tww_vl = None
        self.model_classes_tww_sys = None
        self.model_classes_tww_app = None

        self.filter_nulls = None
        self.srid = 2056
        self.current_progress = 0

    def _init_model_classes(self, model):
        ModelInterlis = None
        if model == config.MODEL_NAME_AG96:
            ModelInterlis = ModelInterlisAG96
        elif model == config.MODEL_NAME_AG64:
            ModelInterlis = ModelInterlisAG64
        elif model == config.MODEL_NAME_SIA405_BASE_ABWASSER:
            ModelInterlis = ModelInterlisSia405BaseAbwasser
        elif model == config.MODEL_NAME_SIA405_ABWASSER:
            ModelInterlis = ModelInterlisSia405Abwasser
        elif model == config.MODEL_NAME_DSS:
            ModelInterlis = ModelInterlisDss
        elif model == config.MODEL_NAME_VSA_KEK:
            ModelInterlis = ModelInterlisVsaKek
        self.model_classes_interlis = ModelInterlis().classes()
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

        if (
            model == config.MODEL_NAME_AG96 or model == config.MODEL_NAME_AG64
        ) and self.model_classes_tww_app is None:
            self.model_classes_tww_app = ModelTwwAG6496().classes()
            self._progress_done(self.current_progress + 1)

    def interlis_import(
        self,
        xtf_file_input,
        show_selection_dialog=False,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = None,
    ):
        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_input
        else:
            self.base_log_path = None

        self.filter_nulls = filter_nulls

        if srid:
            self.srid = srid

        # Validating the input file
        self._progress_done(5, "Validating the input file...")
        self._import_validate_xtf_file(xtf_file_input)

        # Get model to import from xtf file
        self._progress_done(10, "Extract model from xtf...")
        import_models = self.interlisTools.get_xtf_models(xtf_file_input)

        import_model = ""
        if config.MODEL_NAME_SIA405_BASE_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_BASE_ABWASSER

        # override base model if necessary
        if config.MODEL_NAME_VSA_KEK in import_models:
            import_model = config.MODEL_NAME_VSA_KEK
        elif config.MODEL_NAME_SIA405_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        elif config.MODEL_NAME_DSS in import_models:
            import_model = config.MODEL_NAME_DSS

        elif config.MODEL_NAME_SIA405_BASE_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        elif config.MODEL_NAME_AG96 in import_models:
            import_model = config.MODEL_NAME_AG96
        elif config.MODEL_NAME_AG64 in import_models:
            import_model = config.MODEL_NAME_AG64

        if not import_model:
            error_text = f"No supported model was found among '{import_models}'."
            if len(import_models) == 1:
                error_text = f"The model '{import_models[0]}' is not supported."
            raise InterlisImporterExporterError("Import error", error_text, None)
        logger.info(
            f"Model '{import_model}' was choosen for import among found models '{import_models}'"
        )

        # Prepare the temporary ili2pg model
        self._progress_done(15, "Creating ili schema...")
        self._clear_ili_schema(recreate_tables=True)

        self._progress_done(20)
        self._create_ili_schema(
            [import_model], ext_columns_no_constraints=True, create_basket_col=True
        )

        # Import from xtf file to ili2pg model
        self._progress_done(30, "Importing XTF data...")
        self._import_xtf_file(xtf_file_input=xtf_file_input)

        # Disable symbology triggers
        self._progress_done(35, "Disable symbology and modification triggers...")
        self._import_disable_symbology_and_modification_triggers()

        try:
            # Import from the temporary ili2pg model
            self._progress_done(40, "Converting to TEKSI Wastewater...")
            tww_session = self._import_from_intermediate_schema(import_model)

            if show_selection_dialog:
                from PyQt5.QtCore import Qt
                from PyQt5.QtWidgets import QApplication

                self._progress_done(90, "Import objects selection...")
                import_dialog = InterlisImportSelectionDialog()
                import_dialog.init_with_session(tww_session)
                QApplication.restoreOverrideCursor()
                if import_dialog.exec_() == import_dialog.Rejected:
                    tww_session.rollback()
                    tww_session.close()
                    raise InterlisImporterExporterStopped()
                QApplication.setOverrideCursor(Qt.WaitCursor)
            else:
                self._progress_done(90, "Commit session...")
                tww_session.commit()
            tww_session.close()

            # Update the sequence values
            self._progress_done(92, "Update sequence values...")
            self._import_set_od_sequences()

            # Update main_cover and main_wastewater_node
            self._progress_done(95, "Update main cover and refresh materialized views...")
            self._import_update_main_cover_and_refresh_mat_views()

            # Validate subclasses after import
            self._check_subclass_counts(raise_err=True)

            # Update organisations
            self._progress_done(96, "Set organisations filter...")
            self._import_manage_organisations()

            # Reenable symbology triggers
            self._progress_done(97, "Reenable symbology and modification triggers...")
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

        self._progress_done(100)
        logger.info("INTERLIS import finished.")

    def execute_export(
        self,
        xtf_file_output,
        export_models,
        logs_next_to_file=True,
        limit_to_selection=False,
        export_orientation=90.0,
        labels_file=None,
        selected_labels_scales_indices=[],
        selected_ids=None,
    ):
        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(xtf_file_output)

        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_output
        else:
            self.base_log_path = None

        self._progress_done(5, "Clearing ili schema...")
        self._clear_ili_schema(recreate_tables=True)

        self._progress_done(15, "Creating ili schema...")
        create_basket_col = False
        if config.MODEL_NAME_VSA_KEK in export_models:
            create_basket_col = True
        self._create_ili_schema(export_models, create_basket_col=create_basket_col)

        self._progress_done(25, "Creating ili schema...")
        create_basket_col = False
        if config.MODEL_NAME_VSA_KEK in export_models:
            create_basket_col = True
        self._create_ili_schema(export_models, create_basket_col=create_basket_col)

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        if len(selected_labels_scales_indices):
            self._progress_done(30)
            if not labels_file:
                labels_file = os.path.join(tempdir.name, "labels.geojson")
                self._export_labels_file(
                    limit_to_selection=limit_to_selection,
                    selected_labels_scales_indices=selected_labels_scales_indices,
                    labels_file_path=labels_file,
                    export_model=export_models[0],
                    export_orientation=export_orientation,
                )

        if export_models[0] == config.MODEL_NAME_AG96:
            file_path = "data/Organisationstabelle_AG96.xtf"
            abs_file_path = Path(__file__).parent.resolve() / file_path
            logger.info("Importing AG-96 organisation to intermediate schema")
            self._import_xtf_file(abs_file_path)
        elif export_models[0] == config.MODEL_NAME_AG64:
            file_path = "data/Organisationstabelle_AG64.xtf"
            abs_file_path = Path(__file__).parent.resolve() / file_path
            logger.info("Importing AG-64 organisation to intermediate schema")
            self._import_xtf_file(abs_file_path)

        # Export to the temporary ili2pg model
        self._progress_done(35, "Converting from TEKSI Wastewater...")
        self._export_to_intermediate_schema(
            export_model=export_models[0],
            file_name=xtf_file_output,
            selected_ids=selected_ids,
            export_orientation=export_orientation,
            labels_file_path=labels_file,
            basket_enabled=create_basket_col,
        )
        tempdir.cleanup()  # Cleanup

        self._progress_done(75)
        self._export_xtf_files(file_name_base, export_models)

        self._progress_done(100)
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
    ):

        if srid:
            self.srid = srid

        if export_models[0] == "SIA405_Base_Abwasser_1_LV95":
            failed, errormsg, _ = self._check_organisation_tww_local_extension_count()
            if failed:
                logger.info(
                    "INTERLIS export has been stopped as there have been no organisations for exporting!"
                )
                # self._progress_done(100, "Export aborted...")
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
        exportChecker = TWWExportChecker(
            export_models=export_models, limit_to_selection=limit_to_selection
        )
        results = exportChecker.run_integrity_checks(limit_to_selection)
        if not results["failed"]:
            logger.info(f"All checks passed! ({results['stats']['ok']} OK)")
            self.execute_export(
                xtf_file_output,
                export_models,
                logs_next_to_file,
                limit_to_selection,
                export_orientation,
                labels_file,
                selected_labels_scales_indices,
                selected_ids,
            )
        else:
            if user_interaction:
                from PyQt5.QtWidgets import QMessageBox

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
                    # self._progress_done(100, "Export aborted...")
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
                    self.execute_export(
                        xtf_file_output,
                        export_models,
                        logs_next_to_file,
                        limit_to_selection,
                        export_orientation,
                        labels_file,
                        selected_labels_scales_indices,
                        selected_ids,
                    )
            else:
                logger.error(f"Failed checks:\n{results['failed_checks']}")
                logger.info(
                    f" {results['stats']['failed']} failed, {results['stats']['ok']} passed"
                )
                logger.info(
                    "INTERLIS export has been stopped due to failing export checks - see logs for details."
                )
                raise InterlisImporterExporterError(
                    "INTERLIS Export aborted!",
                    results["failed_checks"],
                    None,
                )

    def _import_validate_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ilivalidator")
        try:
            self.interlisTools.validate_xtf_data(
                xtf_file_input,
                log_path,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Invalid file",
                "The input file is not a valid XTF file. Open the logs for more details on the error.",
                log_path,
            )

    def _import_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ili2pg-import")
        try:
            self.interlisTools.import_xtf_data(
                config.ABWASSER_SCHEMA,
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

    def _import_from_intermediate_schema(self, import_model):
        log_handler = logging.FileHandler(
            make_log_path(self.base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        self._init_model_classes(import_model)

        interlisImporterToIntermediateSchema = InterlisImporterToIntermediateSchema(
            model=import_model,
            model_classes_interlis=self.model_classes_interlis,
            model_classes_tww_od=self.model_classes_tww_od,
            model_classes_tww_vl=self.model_classes_tww_vl,
            model_classes_tww_app=self.model_classes_tww_app,
            callback_progress_done=self._progress_done_intermediate_schema,
            filter_nulls=self.filter_nulls,
        )

        with LoggingHandlerContext(log_handler):
            interlisImporterToIntermediateSchema.tww_import(skip_closing_tww_session=True)

        return interlisImporterToIntermediateSchema.session_tww

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
        export_model,
        export_orientation=90.0,
    ):
        self._progress_done(self.current_progress, "Extracting labels...")

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

        self._progress_done(self.current_progress + 2)
        if export_model == config.MODEL_NAME_AG96:
            catch_lyr = TwwLayerManager.layer("catchment_area")
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
                },
            )
        elif export_model == config.MODEL_NAME_DSS:
            catch_lyr = TwwLayerManager.layer("catchment_area")

            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "CATCHMENT_LAYER": catch_lyr,
                    "SCALES": selected_labels_scales_indices,
                },
            )
        elif export_model == config.MODEL_NAME_AG64:
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "REPLACE_WS_WITH_WN": True,
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
                },
            )

    def _export_to_intermediate_schema(
        self,
        export_model,
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

        self._init_model_classes(export_model)

        twwInterlisExporter = InterlisExporterToIntermediateSchema(
            model=export_model,
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

    def _export_xtf_files(self, file_name_base, export_models):
        progress_step = (100 - self.current_progress) / (2 * len(export_models))
        progress_step = int(progress_step)

        xtf_export_errors = []
        for index, export_model_name in enumerate(export_models):
            export_file_name = f"{file_name_base}_{export_model_name}.xtf"

            # Export from ili2pg model to file
            self._progress_done(self.current_progress, f"Saving XTF for '{export_model_name}'...")
            log_path = make_log_path(self.base_log_path, f"ili2pg-export-{export_model_name}")
            try:
                self.interlisTools.export_xtf_data(
                    schema=config.ABWASSER_SCHEMA,
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

            self._progress_done(
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

            self._progress_done(self.current_progress + progress_step)

        # In case some export had an error raise the first one
        if xtf_export_errors:
            raise xtf_export_errors[0]

    def _clear_ili_schema(self, recreate_tables=False):
        logger.info("CONNECTING TO DATABASE...")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(
                f"SELECT schema_name FROM information_schema.schemata WHERE schema_name = '{config.ABWASSER_SCHEMA}';"
            )
            if cursor.rowcount == 0:
                cursor.execute(f"CREATE SCHEMA {config.ABWASSER_SCHEMA} CASCADE;")
            else:
                cursor.execute(
                    f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{config.ABWASSER_SCHEMA}';"
                )
                logger.info(f"Truncating all tables in schema {config.ABWASSER_SCHEMA}")
                rows = cursor.fetchall()
                for row in rows:
                    cursor.execute(f"TRUNCATE TABLE {config.ABWASSER_SCHEMA}.{row[0]} CASCADE;")
                if recreate_tables:
                    logger.info(f"Deleting all tables in schema {config.ABWASSER_SCHEMA} ")
                    for row in rows:
                        cursor.execute(f"DROP TABLE {config.ABWASSER_SCHEMA}.{row[0]} CASCADE;")

    def _create_ili_schema(
        self, models, ext_columns_no_constraints=False, create_basket_col=False
    ):
        log_path = make_log_path(self.base_log_path, "ili2pg-schemaimport")
        try:
            self.interlisTools.import_ili_schema(
                config.ABWASSER_SCHEMA,
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

    def _progress_done_intermediate_schema(self):
        self._progress_done(self.current_progress + 0.5)

    def _progress_done(self, progress, text=None):
        self.current_progress = progress
        if self.progress_done_callback:
            self.progress_done_callback(int(progress), text)
