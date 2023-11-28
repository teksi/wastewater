import os
from collections import OrderedDict

from qgis.core import Qgis, QgsSettings
from qgis.PyQt.QtWidgets import QCheckBox, QDialog
from qgis.PyQt.uic import loadUi

from ....utils.qgeplayermanager import QgepLayerManager
from ..processing_algs.extractlabels_interlis import ExtractlabelsInterlisAlgorithm


class GuiExport(QDialog):
    def __init__(self, parent):
        super().__init__(parent)
        loadUi(os.path.join(os.path.dirname(__file__), "gui_export.ui"), self)

        self.finished.connect(self.on_finish)

        # Execute the dialog
        # self.resize(iface.mainWindow().size() * 0.75)

        structures_layer = QgepLayerManager.layer("vw_qgep_wastewater_structure")
        reaches_layer = QgepLayerManager.layer("vw_qgep_reach")
        self.structures = structures_layer.selectedFeatures() if structures_layer else []
        self.reaches = reaches_layer.selectedFeatures() if reaches_layer else []

        self.limit_checkbox.setText(
            f"Limit to selection ({len(self.structures)} structures and {len(self.reaches)} reaches)"
        )

        # Remember save next to file checkbox
        s = QgsSettings().value("qgep_plugin/logs_next_to_file", False)
        self.save_logs_next_to_file_checkbox.setChecked(s == True or s == "true")

        # Populate the labels list (restoring checked states of scaes)
        selected_scales = QgsSettings().value("qgep_plugin/last_selected_scales", "").split(",")
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
        QgsSettings().setValue("qgep_plugin/logs_next_to_file", self.logs_next_to_file)

        # Save checked state of scales
        if self.labels_groupbox.isChecked():
            selected_scales = []
            for key, checkbox in self.scale_checkboxes.items():
                if checkbox.isChecked():
                    selected_scales.append(key)
            QgsSettings().setValue("qgep_plugin/last_selected_scales", ",".join(selected_scales))

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
