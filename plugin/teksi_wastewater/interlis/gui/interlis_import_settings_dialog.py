import os

from qgis.core import  QgsSettings
from qgis.PyQt.QtWidgets import QDialog
from qgis.PyQt.uic import loadUi



class InterlisImportSettingsDialog(QDialog):
    def __init__(self, parent):
        super().__init__(parent)
        loadUi(os.path.join(os.path.dirname(__file__), "interlis_import_settings_dialog.ui"), self)

        self.finished.connect(self.on_finish)

        filter_nulls_import_value = QgsSettings().value("tww_plugin/filter_nulls_import", True)
        self.filter_nulls_checkbox.setChecked(
            filter_nulls_import_value is True or filter_nulls_import_value == "true"
        )

        settings_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
        self.save_logs_next_to_file_checkbox.setChecked(
            settings_value is True or settings_value == "true"
        )


    def on_finish(self):
        # Remember save next to file checkbox
        QgsSettings().setValue("tww_plugin/logs_next_to_file", self.logs_next_to_file)

        # Remember save next to file checkbox
        QgsSettings().setValue("tww_plugin/filter_nulls_import", self.filter_nulls)


    @property
    def logs_next_to_file(self):
        return self.save_logs_next_to_file_checkbox.isChecked()

    @property
    def filter_nulls(self):
        return self.filter_nulls_checkbox.isChecked()


