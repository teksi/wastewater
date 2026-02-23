import os
from collections import OrderedDict

from qgis.core import Qgis, QgsSettings
from qgis.PyQt.QtCore import QSettings
from qgis.PyQt.QtWidgets import QCheckBox, QDialog
from qgis.PyQt.uic import loadUi

from ...utils.twwlayermanager import TwwLayerManager
from .. import config
from ..processing_algs.extractlabels_interlis import ExtractlabelsInterlisAlgorithm


class InterlisExportSettingsDialog(QDialog):
    def __init__(self, parent):
        super().__init__(parent)
        loadUi(os.path.join(os.path.dirname(__file__), "interlis_export_settings_dialog.ui"), self)

        self.finished.connect(self.on_finish)

        # Fill models selection combobox
        self.export_model_selection_comboBox.addItem(
            config.MODEL_NAME_DSS, [config.MODEL_NAME_DSS]
        )
        self.export_model_selection_comboBox.addItem(
            config.MODEL_NAME_SIA405_ABWASSER, [config.MODEL_NAME_SIA405_ABWASSER]
        )
        self.export_model_selection_comboBox.addItem(
            config.MODEL_NAME_VSA_KEK,
            [config.MODEL_NAME_VSA_KEK, config.MODEL_NAME_SIA405_ABWASSER],
        )
        self.export_model_selection_comboBox.addItem(
            config.MODEL_NAME_SIA405_BASE_ABWASSER, [config.MODEL_NAME_SIA405_BASE_ABWASSER]
        )

        ag6496extension = QSettings().value("/TWW/AGxxExtensions", False)
        # QGIS loads value as string on application restart
        if ag6496extension and ag6496extension != "false":
            self.export_model_selection_comboBox.addItem(
                config.MODEL_NAME_AG96, [config.MODEL_NAME_AG96]
            )
            self.export_model_selection_comboBox.addItem(
                config.MODEL_NAME_AG64, [config.MODEL_NAME_AG64]
            )
        # Fill orientation selection combobox
        self.export_orientation_selection_comboBox.clear()
        self.export_orientation_selection_comboBox.addItem("90°", 90.0)
        self.export_orientation_selection_comboBox.addItem("0°", 0.0)
        self.export_orientation_selection_comboBox.addItem("-90°", -90.0)

        # Fill Werkplan scale selection combobox - removed again - can be re-implemented when subvalues of Werkplan will be introduced in INTERLIS data model
        # self.export_werkplan_scale_selection_comboBox.clear()
        # self.export_werkplan_scale_selection_comboBox.addItem("1:500", 500)
        # self.export_werkplan_scale_selection_comboBox.addItem("1:250", 250)
        # self.export_werkplan_scale_selection_comboBox.addItem("1:200", 200)

        structures_layer = TwwLayerManager.layer("vw_tww_wastewater_structure")
        reaches_layer = TwwLayerManager.layer("vw_tww_reach")
        self.structures = structures_layer.selectedFeatures() if structures_layer else []
        self.reaches = reaches_layer.selectedFeatures() if reaches_layer else []

        self.limit_checkbox.setText(
            f"Limit to selection ({len(self.structures)} structures and {len(self.reaches)} reaches)"
        )

        # Remember save next to file checkbox
        settings_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
        self.save_logs_next_to_file_checkbox.setChecked(
            settings_value is True or settings_value == "true"
        )

        # Populate the labels list (restoring checked states of scales)
        selected_scales = QgsSettings().value("tww_plugin/last_selected_scales", "").split(",")
        qgis_version_ok = Qgis.QGIS_VERSION_INT >= 32602
        self.labels_groupbox.setEnabled(qgis_version_ok)
        self.labels_qgis_warning_label.setVisible(not qgis_version_ok)
        self.scale_checkboxes = OrderedDict()
        for scale_key, scale_disp, scale_val in ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALES:
            checkbox = QCheckBox(f"{scale_disp} [1:{scale_val}]")
            checkbox.setChecked(qgis_version_ok and scale_key in selected_scales)
            self.scale_checkboxes[scale_key] = checkbox
            self.labels_groupbox.layout().addWidget(checkbox)

    def on_finish(self):
        # Remember save next to file checkbox
        QgsSettings().setValue("tww_plugin/logs_next_to_file", self.logs_next_to_file)

        # Save checked state of scales
        if self.labels_groupbox.isChecked():
            selected_scales = []
            for key, checkbox in self.scale_checkboxes.items():
                if checkbox.isChecked():
                    selected_scales.append(key)
            QgsSettings().setValue("tww_plugin/last_selected_scales", ",".join(selected_scales))

    @property
    def logs_next_to_file(self):
        return self.save_logs_next_to_file_checkbox.isChecked()

    @property
    def selected_ids(self):
        if self.limit_checkbox.isChecked():
            ids = []
            for struct in self.structures:
                ids.append(str(struct["wn_obj_id"]))
            for reach in self.reaches:
                ids.append(str(reach["obj_id"]))
                ids.append(str(reach["rp_from_fk_wastewater_networkelement"]))
                ids.append(str(reach["rp_to_fk_wastewater_networkelement"]))
            return ids
        else:
            return None

    @property
    def limit_to_selection(self):
        return self.limit_checkbox.isChecked()

    @property
    def selected_labels_scales_indices(self):
        if self.labels_groupbox.isChecked():
            scales = []
            for i, checkbox in enumerate(self.scale_checkboxes.values()):
                if checkbox.isChecked():
                    scales.append(i)
            return scales
        else:
            return []

    def selected_model(self):
        return self.export_model_selection_comboBox.currentText()

    def selected_models(self):
        return self.export_model_selection_comboBox.currentData()

    @property
    def labels_orientation_offset(self):
        eorientation = self.export_orientation_selection_comboBox.currentData()
        return eorientation
