import logging
import os
import tempfile
import webbrowser

import psycopg2
from qgis import processing
from qgis.core import Qgis, QgsProject, QgsSettings
from qgis.PyQt.QtCore import QObject, Qt
from qgis.PyQt.QtWidgets import QApplication, QFileDialog, QProgressDialog, QPushButton
from qgis.utils import iface

from ...utils.qt_utils import OverrideCursor
from ...utils.twwlayermanager import TwwLayerManager
from .. import config
from ..interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
)
from ..interlis_model_mapping.interlis_importer_to_intermediate_schema import (
    InterlisImporterToIntermediateSchema,
)
from ..utils.ili2db import InterlisTools
from ..utils.various import (
    CmdException,
    LoggingHandlerContext,
    get_pgconf_as_psycopg2_dsn,
    logger,
    make_log_path,
)
from .interlis_export_settings_dialog import InterlisExportSettingsDialog
from .interlis_import_selection_dialog import InterlisImportSelectionDialog


class InterlisImporterExporterStopped(Exception):
    pass


class InterlisImporterExporterErrorWithLog(Exception):
    def __init__(self, error, additional_text, log_path):
        self.error = error
        self.additional_text = additional_text
        self.log_path = log_path


class InterlisImporterExporter(QObject):
    _PROGRESS_DIALOG_MINIMUM_WIDTH = 350

    def __init__(self):
        super().__init__(parent=None)
        self.import_dialog = None
        self.progress_dialog = None

        self.interlisTools = InterlisTools()
        self.base_log_path = None

    def action_import(self, xtf_file_input=None):
        """
        Is executed when the user clicks the importAction tool
        """
        if xtf_file_input is None:
            default_folder = QgsSettings().value(
                "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
            )
            fileName, _ = QFileDialog.getOpenFileName(
                None,
                self.tr("Import file"),
                default_folder,
                self.tr("Interlis transfer files (*.xtf)"),
            )
            if not fileName:
                # Operation canceled
                return

            QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(fileName))
            xtf_file_input = fileName

        try:
            with OverrideCursor(Qt.WaitCursor):
                self._action_import(xtf_file_input)

        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Import was canceled.", level=Qgis.Warning)

        except InterlisImporterExporterErrorWithLog as exception:
            self._cleanup()
            self.show_failure(
                exception.error,
                exception.additional_text,
                exception.log_path,
            )

        except Exception as exception:
            self._cleanup()
            raise exception

    def action_export(self):
        """
        Is executed when the user clicks the exportAction tool
        """
        try:
            self._action_export()

        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Export was canceled.", level=Qgis.Warning)

        except InterlisImporterExporterErrorWithLog as exception:
            self._cleanup()
            self.show_failure(
                exception.error,
                exception.additional_text,
                exception.log_path,
            )

        except Exception as exception:
            self._cleanup()
            raise exception

    def _action_import(self, xtf_file_input):
        # Configure logging
        setting_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
        logs_next_to_file = setting_value is True or setting_value == "true"
        if logs_next_to_file:
            self.base_log_path = xtf_file_input
        else:
            self.base_log_path = None

        # Validating the input file
        self.progress_dialog = QProgressDialog("", "", 0, 100)
        self.progress_dialog.setMinimumWidth(self._PROGRESS_DIALOG_MINIMUM_WIDTH)
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Import Interlis data...")
        self.progress_dialog.setLabelText("Validating the input file...")
        self.progress_dialog.setValue(5)
        QApplication.processEvents()
        self._import_validate_xtf_file(xtf_file_input)
        self._check_for_canceled()

        # Get model to import from xtf file
        self.progress_dialog.setLabelText("Extract model from xtf...")
        self.progress_dialog.setValue(10)
        QApplication.processEvents()
        import_model, _ = self.interlisTools.get_xtf_models(xtf_file_input)
        self._check_for_canceled()

        # Prepare the temporary ili2pg model
        self.progress_dialog.setLabelText("Creating ili schema...")
        self.progress_dialog.setValue(15)
        QApplication.processEvents()
        self._clear_ili_schema(recreate_schema=True)
        self._check_for_canceled()

        self.progress_dialog.setValue(25)
        QApplication.processEvents()
        self._create_ili_schema([import_model])
        self._check_for_canceled()

        # Import from xtf file to ili2pg model
        self.progress_dialog.setLabelText("Importing XTF data...")
        self.progress_dialog.setValue(50)
        QApplication.processEvents()
        self._import_xtf_file(xtf_file_input=xtf_file_input)
        self._check_for_canceled()

        # Import to the temporary ili2pg model
        self.progress_dialog.setLabelText("Converting to Teksi Wastewater...")
        self.progress_dialog.setValue(75)
        QApplication.processEvents()

        interlisImporterToIntermediateSchema = InterlisImporterToIntermediateSchema(
            model=import_model, callback_progress_done=self._progress_done
        )

        log_handler = logging.FileHandler(
            make_log_path(self.base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        with LoggingHandlerContext(log_handler):
            interlisImporterToIntermediateSchema.tww_import(skip_closing_tww_session=True)

        self.progress_dialog.setValue(self.progress_dialog.maximum())

        self.import_dialog = InterlisImportSelectionDialog()
        self.import_dialog.init_with_session(interlisImporterToIntermediateSchema.session_tww)
        self.import_dialog.resize(iface.mainWindow().size() * 0.75)
        self.import_dialog.show()

    def _import_validate_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ilivalidator")
        try:
            self.interlisTools.validate_xtf_data(
                xtf_file_input,
                log_path,
            )
        except CmdException:
            raise InterlisImporterExporterErrorWithLog(
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
            raise InterlisImporterExporterErrorWithLog(
                "Could not import data",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _action_export(self):
        export_dialog = InterlisExportSettingsDialog(None)

        if export_dialog.exec_() == export_dialog.Rejected:
            return

        default_folder = QgsSettings().value(
            "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
        )
        file_name, _ = QFileDialog.getSaveFileName(
            None,
            self.tr("Export to file"),
            os.path.join(default_folder, "tww-export.xtf"),
            self.tr("Interlis transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return
        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(file_name)

        # Configure logging
        if export_dialog.logs_next_to_file:
            self.base_log_path = file_name
        else:
            self.base_log_path = None

        # Prepare the temporary ili2pg model
        self.progress_dialog = QProgressDialog("", "", 0, 100)
        self.progress_dialog.setMinimumWidth(self._PROGRESS_DIALOG_MINIMUM_WIDTH)
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Export Interlis data...")
        self.progress_dialog.setLabelText("Clearing ili schema...")
        self.progress_dialog.setValue(5)
        QApplication.processEvents()
        self._clear_ili_schema(recreate_schema=True)
        self._check_for_canceled()

        self.progress_dialog.setLabelText("Creating ili schema...")
        self.progress_dialog.setValue(15)
        QApplication.processEvents()
        export_models = export_dialog.selected_models()
        self._create_ili_schema(export_models)
        self._check_for_canceled()

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        labels_file_path = None
        if len(export_dialog.selected_labels_scales_indices):
            self.progress_dialog.setValue(25)
            QApplication.processEvents()
            labels_file_path = os.path.join(tempdir.name, "labels.geojson")
            self._export_labels_file(
                export_dialog=export_dialog, labels_file_path=labels_file_path
            )
            self._check_for_canceled()

        # Export to the temporary ili2pg model
        self.progress_dialog.setLabelText("Converting from Teksi Wastewater...")
        self.progress_dialog.setValue(35)
        QApplication.processEvents()
        self._export_to_intermediate_schema(
            file_name=file_name,
            selected_ids=export_dialog.selected_ids,
            labels_file_path=labels_file_path,
        )
        tempdir.cleanup()  # Cleanup
        self._check_for_canceled()

        self.progress_dialog.setValue(60)
        QApplication.processEvents()
        self._export_xtf_files(file_name_base, export_models)

        self.progress_dialog.setValue(self.progress_dialog.maximum())
        self.show_success(
            "Success",
            f"Data successfully exported to {file_name_base}",
            None,
        )

    def _export_labels_file(self, export_dialog, labels_file_path):
        self.progress_dialog.setLabelText("Extracting labels...")
        QApplication.processEvents()

        structures_lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
        reaches_lyr = TwwLayerManager.layer("vw_tww_reach")
        if not structures_lyr or not reaches_lyr:
            raise InterlisImporterExporterErrorWithLog(
                "Could not find the vw_tww_wastewater_structure and/or the vw_tww_reach layers.",
                "Make sure your Teksi Wastewater project is open.",
                None,
            )
        self._check_for_canceled()

        self.progress_dialog.setValue(self.progress_dialog.value() + 5)
        QApplication.processEvents()
        processing.run(
            "tww:extractlabels_interlis",
            {
                "OUTPUT": labels_file_path,
                "RESTRICT_TO_SELECTION": export_dialog.limit_to_selection,
                "STRUCTURE_VIEW_LAYER": structures_lyr,
                "REACH_VIEW_LAYER": reaches_lyr,
                "SCALES": export_dialog.selected_labels_scales_indices,
            },
        )

    def _export_to_intermediate_schema(self, file_name, selected_ids, labels_file_path):
        log_handler = logging.FileHandler(
            make_log_path(file_name, "tww2ili-export"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        twwInterlisExporter = InterlisExporterToIntermediateSchema(
            selection=selected_ids,
            labels_file=labels_file_path,
            callback_progress_done=self._progress_done,
        )

        with LoggingHandlerContext(log_handler):
            twwInterlisExporter.tww_export()

    def _export_xtf_files(self, file_name_base, export_models):
        progress_step = (self.progress_dialog.maximum() - self.progress_dialog.value()) / (
            2 * len(export_models)
        )
        progress_step = int(progress_step)

        xtf_export_errors = []
        for index, export_model_name in enumerate(export_models):
            export_file_name = f"{file_name_base}_{export_model_name}.xtf"

            # Export from ili2pg model to file
            self.progress_dialog.setLabelText(f"Saving XTF for '{export_model_name}'...")
            QApplication.processEvents()

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
                    InterlisImporterExporterErrorWithLog(
                        error=f"Could not export the model '{export_model_name}' from ili2pg schema",
                        additional_text="Open the logs for more details on the error.",
                        log_path=log_path,
                    )
                )
                continue

            self._check_for_canceled()
            self.progress_dialog.setLabelText(f"Validating XTF for '{export_model_name}'...")
            self.progress_dialog.setValue(self.progress_dialog.value() + progress_step)
            QApplication.processEvents()

            log_path = make_log_path(self.base_log_path, f"ilivalidator-{export_model_name}")
            try:
                self.interlisTools.validate_xtf_data(
                    export_file_name,
                    log_path,
                )
            except CmdException:
                xtf_export_errors.append(
                    InterlisImporterExporterErrorWithLog(
                        error=f"Validation of exported file '{export_file_name}' failed",
                        additional_text=f"The created file is not a valid {export_model_name} XTF file.",
                        log_path=log_path,
                    )
                )
                continue

            self._check_for_canceled()
            self.progress_dialog.setValue(self.progress_dialog.value() + progress_step)
            QApplication.processEvents()

        # In case some export had an error raise the first one
        if xtf_export_errors:
            raise xtf_export_errors[0]

    def _clear_ili_schema(self, recreate_schema=False):
        logger.info("CONNECTING TO DATABASE...")

        connection = psycopg2.connect(
            get_pgconf_as_psycopg2_dsn(), options="-c statement_timeout=1000"
        )
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

    def _create_ili_schema(self, models):
        log_path = make_log_path(self.base_log_path, "ili2pg-schemaimport")
        try:
            self.interlisTools.import_ili_schema(
                config.ABWASSER_SCHEMA,
                models,
                log_path,
            )
        except CmdException:
            raise InterlisImporterExporterErrorWithLog(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _show_results(self, title, message, log_path, level):
        widget = iface.messageBar().createMessage(title, message)
        button = QPushButton(widget)
        button.setText("Show logs")
        button.pressed.connect(lambda p=log_path: webbrowser.open(p))
        widget.layout().addWidget(button)
        iface.messageBar().pushWidget(widget, level)

    def show_failure(self, title, message, log_path):
        self._show_results(title, message, log_path, Qgis.Warning)

    def show_success(self, title, message, log_path):
        self._show_results(title, message, log_path, Qgis.Success)

    def _check_for_canceled(self):
        if self.progress_dialog.wasCanceled():
            raise InterlisImporterExporterStopped

    def _cleanup(self):
        if self.progress_dialog:
            self.progress_dialog.close()

    def _progress_done(self):
        self._check_for_canceled()
        self.progress_dialog.setValue(self.progress_dialog.value() + 1)
