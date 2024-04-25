import os
import webbrowser

from qgis.core import Qgis, QgsProject, QgsSettings
from qgis.PyQt.QtCore import QFileInfo, QObject, Qt
from qgis.PyQt.QtWidgets import QApplication, QFileDialog, QProgressDialog, QPushButton
from qgis.utils import iface

from ...utils.qt_utils import OverrideCursor
from ..interlis_importer_exporter import (
    InterlisImporterExporter,
    InterlisImporterExporterError,
    InterlisImporterExporterStopped,
)
from .interlis_export_settings_dialog import InterlisExportSettingsDialog


class InterlisImporterExporterGui(QObject):
    _PROGRESS_DIALOG_MINIMUM_WIDTH = 350

    def __init__(self):
        super().__init__(parent=None)
        self.import_dialog = None
        self.progress_dialog = None

        self.interlis_importer_exporter = InterlisImporterExporter(
            progress_done_callback=self._progress_done_callback
        )

    def action_import(self):
        """
        Is executed when the user clicks the importAction tool
        """
        default_folder = QgsSettings().value(
            "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
        )
        xtf_file_input, _ = QFileDialog.getOpenFileName(
            None,
            self.tr("Import file"),
            default_folder,
            self.tr("INTERLIS transfer files (*.xtf)"),
        )
        if not xtf_file_input:
            # Operation canceled
            return

        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(xtf_file_input))

        setting_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
        logs_next_to_file = setting_value is True or setting_value == "true"

        self.progress_dialog = QProgressDialog("", "", 0, 100)
        self.progress_dialog.setMinimumWidth(self._PROGRESS_DIALOG_MINIMUM_WIDTH)
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Import INTERLIS data...")

        try:
            with OverrideCursor(Qt.WaitCursor):
                self.interlis_importer_exporter.interlis_import(
                    xtf_file_input, show_selection_dialog=True, logs_next_to_file=logs_next_to_file
                )
                iface.mapCanvas().refreshAllLayers()

        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Import was canceled.", level=Qgis.Warning)

        except InterlisImporterExporterError as exception:
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
            self.tr("INTERLIS transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return
        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

        self.progress_dialog = QProgressDialog("", "", 0, 100)
        self.progress_dialog.setMinimumWidth(self._PROGRESS_DIALOG_MINIMUM_WIDTH)
        self.progress_dialog.setCancelButtonText("Cancel")
        self.progress_dialog.setMinimumDuration(0)
        self.progress_dialog.setWindowTitle("Export INTERLIS data...")

        try:
            self.interlis_importer_exporter.interlis_export(
                xtf_file_output=file_name,
                export_models=export_dialog.selected_models(),
                logs_next_to_file=export_dialog.logs_next_to_file,
                limit_to_selection=export_dialog.limit_to_selection,
                export_orientation=export_dialog.labels_orientation_offset,
                selected_labels_scales_indices=export_dialog.selected_labels_scales_indices,
                selected_ids=export_dialog.selected_ids,
            )

            self.show_success(
                "Success",
                f"Data successfully exported to {QFileInfo(file_name).path()}",
                None,
            )

        except InterlisImporterExporterStopped:
            self._cleanup()
            iface.messageBar().pushMessage("Warning", "Export was canceled.", level=Qgis.Warning)

        except InterlisImporterExporterError as exception:
            self._cleanup()
            self.show_failure(
                exception.error,
                exception.additional_text,
                exception.log_path,
            )

        except Exception as exception:
            self._cleanup()
            raise exception

    def _progress_done_callback(self, progress, text=None):
        self._check_for_canceled()
        if text:
            self.progress_dialog.setLabelText(text)
        self.progress_dialog.setValue(progress)
        QApplication.processEvents()

    def _show_results(self, title, message, log_path, level):
        widget = iface.messageBar().createMessage(title, message)
        if log_path:
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
