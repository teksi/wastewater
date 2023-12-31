import logging
import os
import tempfile
import webbrowser

from qgis import processing
from qgis.core import Qgis, QgsProject, QgsSettings
from qgis.PyQt.QtWidgets import QApplication, QFileDialog, QProgressDialog, QPushButton
from qgis.utils import iface

from ...utils.twwlayermanager import TwwLayerManager
from .. import config
from ..interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
)
from ..interlis_model_mapping.interlis_importer_to_intermediate_schema import (
    InterlisImporterToIntermediateSchema,
)
from ..utils.ili2db import TwwIliTools
from ..utils.various import CmdException, LoggingHandlerContext, make_log_path
from .gui_import import GuiImport
from .interlis_export_settings_dialog import InterlisExportSettingsDialog


class InterlisImporterExporterStopped(Exception):
    pass


class InterlisImporterExporter:
    def __init__(self, plugin):
        self.plugin = plugin
        self.import_dialog = None
        self.progress_dialog = None

    def action_import(self):
        try:
            self._action_import()
        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Import was canceled.", level=Qgis.Warning)

        except Exception as exception:
            self._cleanup()
            raise exception

    def action_export(self):
        try:
            self._action_export()
        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Export was canceled.", level=Qgis.Warning)

        except Exception as exception:
            self._cleanup()
            raise exception

    def _action_import(self):
        """
        Is executed when the user clicks the importAction tool
        """

        default_folder = QgsSettings().value(
            "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
        )
        file_name, _ = QFileDialog.getOpenFileName(
            None,
            self.plugin.tr("Import file"),
            default_folder,
            self.plugin.tr("Interlis transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return

        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

        # Configure logging
        setting_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
        logs_next_to_file = setting_value is True or setting_value == "true"
        if logs_next_to_file:
            base_log_path = file_name
        else:
            base_log_path = None

        twwIliTools = TwwIliTools()

        # Validating the input file
        self.progress_dialog = QProgressDialog("", "", 0, 100, self.plugin.iface.mainWindow())
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Import Interlis data...")
        self.progress_dialog.setLabelText("Validating the input file...")
        self.progress_dialog.setValue(5)
        QApplication.processEvents()
        log_path = make_log_path(base_log_path, "ilivalidator")
        try:
            twwIliTools.validate_xtf_data(
                file_name,
                log_path,
            )
        except CmdException:
            self.progress_dialog.close()
            self.show_failure(
                "Invalid file",
                "The input file is not a valid XTF file. Open the logs for more details on the error.",
                log_path,
            )
            return

        self._check_for_canceled()
        # Prepare the temporary ili2pg model
        self.progress_dialog.setLabelText("Creating ili schema...")
        self.progress_dialog.setValue(25)
        QApplication.processEvents()
        log_path = make_log_path(base_log_path, "ili2pg-schemaimport")
        try:
            twwIliTools.create_ili_schema(
                config.ABWASSER_SCHEMA,
                [
                    # config.ABWASSER_ILI_MODEL_NAME_KEK,
                    config.ABWASSER_ILI_MODEL_NAME_SIA405,
                    config.ABWASSER_ILI_MODEL_NAME_DSS,
                ],
                log_path,
                recreate_schema=True,
            )
        except CmdException:
            self.progress_dialog.close()
            self.show_failure(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )
            return

        self._check_for_canceled()
        # Export from ili2pg model to file
        self.progress_dialog.setLabelText("Importing XTF data...")
        self.progress_dialog.setValue(50)
        QApplication.processEvents()
        log_path = make_log_path(base_log_path, "ili2pg-import")
        try:
            twwIliTools.import_xtf_data(
                config.ABWASSER_SCHEMA,
                file_name,
                log_path,
            )
        except CmdException:
            self.progress_dialog.close()
            self.show_failure(
                "Could not import data",
                "Open the logs for more details on the error.",
                log_path,
            )
            return

        self._check_for_canceled()
        # Export to the temporary ili2pg model
        self.progress_dialog.setLabelText("Converting to Teksi Wastewater...")
        self.progress_dialog.setValue(75)
        QApplication.processEvents()

        interlisImporterToIntermediateSchema = InterlisImporterToIntermediateSchema(
            callback_progress_done=self._progress_done
        )

        log_handler = logging.FileHandler(
            make_log_path(base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        with LoggingHandlerContext(log_handler):
            interlisImporterToIntermediateSchema.tww_import(skip_closing_tww_session=True)

        self.progress_dialog.setValue(self.progress_dialog.maximum())

        self.import_dialog = GuiImport(self.plugin.iface.mainWindow())
        self.import_dialog.init_with_session(interlisImporterToIntermediateSchema.tww_session)
        self.import_dialog.resize(iface.mainWindow().size() * 0.75)
        self.import_dialog.show()

    def _action_export(self):
        """
        Is executed when the user clicks the exportAction tool
        """

        export_dialog = InterlisExportSettingsDialog(self.plugin.iface.mainWindow())

        if export_dialog.exec_() == export_dialog.Rejected:
            return

        default_folder = QgsSettings().value(
            "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
        )
        file_name, _ = QFileDialog.getSaveFileName(
            None,
            self.plugin.tr("Export to file"),
            os.path.join(default_folder, "tww-export.xtf"),
            self.plugin.tr("Interlis transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return
        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(file_name)

        # Configure logging
        if export_dialog.logs_next_to_file:
            base_log_path = file_name
        else:
            base_log_path = None

        twwIliTools = TwwIliTools()

        # Prepare the temporary ili2pg model
        self.progress_dialog = QProgressDialog("", "", 0, 100, self.plugin.iface.mainWindow())
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Export Interlis data...")
        self.progress_dialog.setLabelText("Creating ili schema...")
        self.progress_dialog.setValue(5)
        QApplication.processEvents()

        log_path = make_log_path(base_log_path, "ili2pg-schemaimport")
        try:
            twwIliTools.create_ili_schema(
                config.ABWASSER_SCHEMA,
                [
                    # config.ABWASSER_ILI_MODEL_NAME_KEK,
                    config.ABWASSER_ILI_MODEL_NAME_SIA405,
                    config.ABWASSER_ILI_MODEL_NAME_DSS,
                ],
                log_path,
                recreate_schema=True,
            )
        except CmdException:
            self.progress_dialog.close()
            self.show_failure(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )
            return

        self._check_for_canceled()
        self.progress_dialog.setValue(25)
        QApplication.processEvents()

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        labels_file_path = None

        if len(export_dialog.selected_labels_scales_indices):
            labels_file_path = os.path.join(tempdir.name, "labels.geojson")

            self.progress_dialog.setLabelText("Extracting labels...")
            QApplication.processEvents()

            structures_lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
            reaches_lyr = TwwLayerManager.layer("vw_tww_reach")
            if not structures_lyr or not reaches_lyr:
                self.progress_dialog.close()
                self.show_failure(
                    "Could not find the vw_tww_wastewater_structure and/or the vw_tww_reach layers.",
                    "Make sure your Teksi Wastewater project is open.",
                    None,
                )
                return

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

        self._check_for_canceled()
        # Export to the temporary ili2pg model
        self.progress_dialog.setLabelText("Converting from Teksi Wastewater...")
        self.progress_dialog.setValue(35)
        QApplication.processEvents()

        log_handler = logging.FileHandler(
            make_log_path(file_name, "tww2ili-export"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        twwInterlisExporter = InterlisExporterToIntermediateSchema(
            selection=export_dialog.selected_ids, labels_file=labels_file_path
        )

        with LoggingHandlerContext(log_handler):
            twwInterlisExporter.tww_export()

        self._check_for_canceled()
        self.progress_dialog.setValue(50)
        QApplication.processEvents()

        # Cleanup
        tempdir.cleanup()

        class XtfExportError:
            def __init__(self, error, additional_text, log_path):
                self.error = error
                self.additional_text = additional_text
                self.log_path = log_path

        xtf_export_errors = []

        for model_name, export_model_name, progress in [
            # (config.ABWASSER_ILI_MODEL_NAME_KEK, None, 50),
            (config.ABWASSER_ILI_MODEL_NAME_SIA405, config.ABWASSER_ILI_MODEL_NAME_SIA405, 70),
        ]:
            export_file_name = f"{file_name_base}_{model_name}.xtf"

            # Export from ili2pg model to file
            self.progress_dialog.setLabelText(f"Saving XTF file [{model_name}]...")
            QApplication.processEvents()
            log_path = make_log_path(base_log_path, f"ili2pg-export-{model_name}")
            try:
                twwIliTools.export_xtf_data(
                    config.ABWASSER_SCHEMA,
                    model_name,
                    export_model_name,
                    export_file_name,
                    log_path,
                )
            except CmdException:
                xtf_export_errors.append(
                    XtfExportError(
                        error=f"Could not export the model {model_name} from ili2pg schema",
                        additional_text="Open the logs for more details on the error.",
                        log_path=log_path,
                    )
                )
                continue

            self._check_for_canceled()
            self.progress_dialog.setLabelText(
                f"Validating the network output file [{model_name}]..."
            )
            self.progress_dialog.setValue(progress + 10)
            QApplication.processEvents()

            log_path = make_log_path(base_log_path, f"ilivalidator-{model_name}")
            try:
                twwIliTools.validate_xtf_data(
                    export_file_name,
                    log_path,
                )
            except CmdException:
                xtf_export_errors.append(
                    XtfExportError(
                        error=f"Validation of exported file '{export_file_name}' failed",
                        additional_text=f"The created file is not a valid {model_name} XTF file.",
                        log_path=log_path,
                    )
                )
                continue

            self._check_for_canceled()
            self.progress_dialog.setValue(progress + 20)
            QApplication.processEvents()

        self.progress_dialog.setValue(self.progress_dialog.maximum())

        if xtf_export_errors:
            for xtf_export_error in xtf_export_errors:
                self.show_failure(
                    xtf_export_error.error,
                    xtf_export_error.additional_text,
                    xtf_export_error.log_path,
                )
            return

        self.show_success(
            "Sucess",
            f"Data successfully exported to {file_name_base}",
            os.path.dirname(log_path),
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
        if self.progress_dialog.wasCanceled():
            raise InterlisImporterExporterStopped

        self.progress_dialog.setValue(self.progress_dialog.value() + 1)
