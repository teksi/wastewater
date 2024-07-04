import logging
import os
import tempfile

try:
    import psycopg

    PSYCOPG_VERSION = 3
    DEFAULTS_CONN_ARG = {"autocommit": True}
except ImportError:
    import psycopg2 as psycopg

    PSYCOPG_VERSION = 2
    DEFAULTS_CONN_ARG = {}

from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication

from . import config
from .gui.interlis_import_selection_dialog import InterlisImportSelectionDialog
from .interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
    InterlisExporterToIntermediateSchemaError,
)
from .interlis_model_mapping.interlis_importer_to_intermediate_schema import (
    InterlisImporterToIntermediateSchema,
)
from .interlis_model_mapping.model_interlis_dss import ModelInterlisDss
from .interlis_model_mapping.model_interlis_sia405_abwasser import (
    ModelInterlisSia405Abwasser,
)
from .interlis_model_mapping.model_interlis_vsa_kek import ModelInterlisVsaKek
from .interlis_model_mapping.model_tww import ModelTwwSys, ModelTwwVl
from .interlis_model_mapping.model_tww_od import ModelTwwOd
from .utils.ili2db import InterlisTools
from .utils.various import (
    CmdException,
    LoggingHandlerContext,
    get_pgconf_as_psycopg_dsn,
    logger,
    make_log_path,
)


class InterlisImporterExporterStopped(Exception):
    pass


class InterlisImporterExporterError(Exception):
    def __init__(self, error, additional_text, log_path):
        self.error = error
        self.additional_text = additional_text
        self.log_path = log_path


class InterlisImporterExporter:
    def __init__(self, progress_done_callback=None):
        self.progress_done_callback = progress_done_callback
        self.interlisTools = InterlisTools()
        self.base_log_path = None

        self.model_classes_interlis = None
        self.model_classes_tww_od = None
        self.model_classes_tww_vl = None
        self.model_classes_tww_sys = None

        self.current_progress = 0

    def interlis_import(self, xtf_file_input, show_selection_dialog=False, logs_next_to_file=True):
        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_input
        else:
            self.base_log_path = None

        # Validating the input file
        self._progress_done(5, "Validating the input file...")
        self._import_validate_xtf_file(xtf_file_input)

        # Get model to import from xtf file
        self._progress_done(10, "Extract model from xtf...")
        import_models = self.interlisTools.get_xtf_models(xtf_file_input)

        import_model = ""
        if config.MODEL_NAME_VSA_KEK in import_models:
            import_model = config.MODEL_NAME_VSA_KEK
        elif config.MODEL_NAME_SIA405_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        elif config.MODEL_NAME_DSS in import_models:
            import_model = config.MODEL_NAME_DSS
        elif config.MODEL_NAME_SIA405_BASE_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        else:
            error_text = f"No supported model was found among '{import_models}'."
            if len(import_models) == 1:
                error_text = f"The model '{import_models[0]}' is not supported."
            raise InterlisImporterExporterError("Import error", error_text, None)
        logger.info(
            f"Model '{import_model}' was choosen for import among found models '{import_models}'"
        )

        # Prepare the temporary ili2pg model
        self._progress_done(10, "Creating ili schema...")
        self._clear_ili_schema(recreate_schema=True)

        self._progress_done(20)
        self._create_ili_schema(
            [import_model], ext_columns_no_constraints=True, create_basket_col=True
        )

        # Import from xtf file to ili2pg model
        self._progress_done(30, "Importing XTF data...")
        self._import_xtf_file(xtf_file_input=xtf_file_input)

        # Disable symbology triggers
        self._progress_done(35, "Disable symbolgy triggers...")
        self._import_disable_symbology_triggers()

        # Import from the temporary ili2pg model
        self._progress_done(40, "Converting to TEKSI Wastewater...")
        tww_session = self._import_from_intermediate_schema(import_model)

        if show_selection_dialog:
            self._progress_done(90, "Import objects selection...")
            import_dialog = InterlisImportSelectionDialog()
            import_dialog.init_with_session(tww_session)
            QApplication.restoreOverrideCursor()
            if import_dialog.exec_() == import_dialog.Rejected:
                tww_session.rollback()
                tww_session.close()
                self._import_enable_symbology_triggers()
                raise InterlisImporterExporterStopped()
            QApplication.setOverrideCursor(Qt.WaitCursor)
        else:
            self._progress_done(90, "Commit session...")
            tww_session.commit()
        tww_session.close()

        # Update main_cover and main_wastewater_node
        self._progress_done(95, "Update main cover and refresh materialized views...")
        self._import_update_main_cover_and_refresh_mat_views()

        # Reenable symbology triggers
        self._progress_done(95, "Reenable symbology triggers...")
        self._import_enable_symbology_triggers()

        self._progress_done(100)
        logger.info("INTERLIS import finished.")

    def interlis_export(
        self,
        xtf_file_output,
        export_models,
        logs_next_to_file=True,
        limit_to_selection=False,
        export_orientation=90.0,
        selected_labels_scales_indices=[],
        selected_ids=[],
    ):
        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(xtf_file_output)

        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_output
        else:
            self.base_log_path = None

        self._progress_done(5, "Clearing ili schema...")
        self._clear_ili_schema(recreate_schema=True)

        self._progress_done(15, "Creating ili schema...")
        create_basket_col = False
        if config.MODEL_NAME_VSA_KEK in export_models:
            create_basket_col = True
        self._create_ili_schema(export_models, create_basket_col=create_basket_col)

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        labels_file_path = None
        if len(selected_labels_scales_indices):
            self._progress_done(25)
            labels_file_path = os.path.join(tempdir.name, "labels.geojson")
            self._export_labels_file(
                limit_to_selection=limit_to_selection,
                # neu export orientation
                export_orientation=export_orientation,
                selected_labels_scales_indices=selected_labels_scales_indices,
                labels_file_path=labels_file_path,
            )

        # Export to the temporary ili2pg model
        self._progress_done(35, "Converting from TEKSI Wastewater...")
        self._export_to_intermediate_schema(
            export_model=export_models[0],
            file_name=xtf_file_output,
            selected_ids=selected_ids,
            export_orientation=export_orientation,
            labels_file_path=labels_file_path,
            basket_enabled=create_basket_col,
        )
        tempdir.cleanup()  # Cleanup

        self._progress_done(60)
        self._export_xtf_files(file_name_base, export_models)

        self._progress_done(100)
        logger.info("INTERLIS export finished.")

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
            callback_progress_done=self._progress_done_intermediate_schema,
        )

        with LoggingHandlerContext(log_handler):
            interlisImporterToIntermediateSchema.tww_import(skip_closing_tww_session=True)

        return interlisImporterToIntermediateSchema.session_tww

    def _import_update_main_cover_and_refresh_mat_views(self):
        connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)
        cursor = connection.cursor()

        logger.info("Update wastewater structure fk_main_cover")
        cursor.execute("SELECT tww_app.wastewater_structure_update_fk_main_cover('', True);")

        logger.info("Update wastewater structure fk_main_wastewater_node")
        cursor.execute(
            "SELECT tww_app.wastewater_structure_update_fk_main_wastewater_node('', True);"
        )

        logger.info("Refresh materialized views")
        cursor.execute("SELECT tww_app.network_refresh_network_simple();")

        connection.commit()
        connection.close()

    def _import_disable_symbology_triggers(self):
        connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)
        cursor = connection.cursor()

        logger.info("Disable symbology triggers")
        cursor.execute("SELECT tww_sys.disable_symbology_triggers();")

        connection.commit()
        connection.close()

    def _import_enable_symbology_triggers(self):
        connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)
        cursor = connection.cursor()

        logger.info("Enable symbology triggers")
        cursor.execute("SELECT tww_sys.enable_symbology_triggers();")

        logger.info("update_wastewater_node_symbology for all datasets - please be patient")
        cursor.execute("SELECT tww_app.update_wastewater_node_symbology(NULL, True);")
        logger.info("update_wastewater_structure_label for all datasets - please be patient")
        cursor.execute("SELECT tww_app.update_wastewater_structure_label(NULL, True);")
        logger.info("update_wn_symbology_by_overflow for all datasets - please be patient")
        cursor.execute("SELECT tww_app.update_wn_symbology_by_overflow(NULL, True);")

        connection.commit()
        connection.close()

    def _export_labels_file(
        self,
        limit_to_selection,
        export_orientation,
        selected_labels_scales_indices,
        labels_file_path,
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

        self._progress_done(self.current_progress + 5)
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

    def _clear_ili_schema(self, recreate_schema=False):
        logger.info("CONNECTING TO DATABASE...")

        connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
        if PSYCOPG_VERSION == 2:
            connection.set_session(autocommit=True)
        cursor = connection.cursor()

        if not recreate_schema:
            # If the schema already exists, we just truncate all tables
            cursor.execute(
                f"SELECT schema_name FROM information_schema.schemata WHERE schema_name = '{config.ABWASSER_SCHEMA}';"
            )
            if cursor.rowcount > 0:
                logger.info(f"Schema {config.ABWASSER_SCHEMA} already exists, we truncate instead")
                cursor.execute(
                    f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{config.ABWASSER_SCHEMA}';"
                )
                for row in cursor.fetchall():
                    cursor.execute(f"TRUNCATE TABLE {config.ABWASSER_SCHEMA}.{row[0]} CASCADE;")
                return

        logger.info(f"DROPPING THE SCHEMA {config.ABWASSER_SCHEMA}...")
        cursor.execute(f'DROP SCHEMA IF EXISTS "{config.ABWASSER_SCHEMA}" CASCADE ;')
        logger.info(f"CREATING THE SCHEMA {config.ABWASSER_SCHEMA}...")
        cursor.execute(f'CREATE SCHEMA "{config.ABWASSER_SCHEMA}";')
        connection.commit()
        connection.close()

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
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _init_model_classes(self, model):
        ModelInterlis = ModelInterlisSia405Abwasser
        if model == config.MODEL_NAME_DSS:
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

    def _progress_done_intermediate_schema(self):
        self._progress_done(self.current_progress + 0.5)

    def _progress_done(self, progress, text=None):
        self.current_progress = progress
        if self.progress_done_callback:
            self.progress_done_callback(int(progress), text)
