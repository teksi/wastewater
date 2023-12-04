# -----------------------------------------------------------
#
# Profile
# Copyright (C) 2012  Matthias Kuhn
# -----------------------------------------------------------
#
# licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, print to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------


from qgis.core import QgsFeatureRequest, QgsProject
from qgis.PyQt.QtCore import Qt, pyqtSignal, pyqtSlot
from qgis.PyQt.QtWidgets import (
    QAction,
    QCheckBox,
    QDialog,
    QDialogButtonBox,
    QDockWidget,
    QGridLayout,
    QMessageBox,
)

from ..utils import get_ui_class
from ..utils.twwlayermanager import TwwLayerManager

DOCK_WIDGET_UI = get_ui_class("twwdockwidget.ui")


class TwwProfileDockWidget(QDockWidget, DOCK_WIDGET_UI):
    # Signal emitted when the widget is closed
    closed = pyqtSignal()
    canvas = None
    addDockWidget = None
    # Lookup table for vertical exaggeration values
    veLUT = {1: 1, 2: 2, 3: 3, 4: 5, 5: 10, 6: 20, 7: 30, 8: 50, 9: 100, 10: 500}

    def __init__(self, parent, canvas, add_dock_widget):
        QDockWidget.__init__(self, parent)
        self.setupUi(self)

        self.selectCurrentPathAction = QAction(self.tr("Select current path"), self.selectButton)
        self.selectCurrentPathAction.triggered.connect(self.onSelectCurrentPathAction)
        self.selectButton.setDefaultAction(self.selectCurrentPathAction)
        self.configureSelectionAction = QAction(self.tr("Configure Select"), self.selectButton)
        self.configureSelectionAction.triggered.connect(self.onConfigureSelectAction)
        self.selectButton.addAction(self.configureSelectionAction)
        self.setAttribute(Qt.WA_DeleteOnClose)
        self.canvas = canvas
        self.addDockWidget = add_dock_widget

        self.plotWidget = None

    def showIt(self):
        # self.setLocation( Qt.BottomDockWidgetArea )
        self.location = Qt.BottomDockWidgetArea
        minsize = self.minimumSize()
        maxsize = self.maximumSize()
        self.setMinimumSize(minsize)
        self.setMaximumSize(maxsize)
        self.canvas.setRenderFlag(False)

        self.addDockWidget(self.location, self)
        self.canvas.setRenderFlag(True)

        self.printButton.clicked.connect(self.onPrintButtonClicked)

        self.mSliderVerticalExaggeration.valueChanged.connect(self.onVerticalExaggerationChanged)

    def closeEvent(self, event):
        self.closed.emit()
        return QDockWidget.closeEvent(self, event)

    def addPlotWidget(self, plot_widget):
        self.plotWidget = plot_widget
        self.verticalLayoutForPlot.addWidget(self.plotWidget)
        ve_val = self.veLUT[self.mSliderVerticalExaggeration.value()]
        self.plotWidget.changeVerticalExaggeration(ve_val)

    @pyqtSlot(int)
    def onVerticalExaggerationChanged(self, value):
        ve_val = self.veLUT[value]
        self.mLblVerticalExaggeration.setText(str(ve_val) + "x")

        if self.plotWidget:
            self.plotWidget.changeVerticalExaggeration(ve_val)

    @pyqtSlot()
    def onPrintButtonClicked(self):
        if not self.plotWidget:
            QMessageBox.critical(
                self,
                self.tr("Print function not available"),
                self.tr("Print function not available because of missing dependeny QtWebKit"),
            )
            return

        self.plotWidget.printProfile()

    @pyqtSlot()
    def onConfigureSelectAction(self):
        dlg = QDialog()
        dlg.setWindowTitle(self.tr("Selection Options"))
        dlg.setLayout(QGridLayout())

        ww_current_checkbox = QCheckBox(self.tr("Wastewater current"))
        status, _ = QgsProject.instance().readBoolEntry("Tww", "FollowWastewaterCurrent", True)
        ww_current_checkbox.setChecked(status)
        ww_planned_checkbox = QCheckBox(self.tr("Wastewater planned"))
        status, _ = QgsProject.instance().readBoolEntry("Tww", "FollowWastewaterPlanned", True)
        ww_planned_checkbox.setChecked(status)
        rw_current_checkbox = QCheckBox(self.tr("Rainwater current"))
        status, _ = QgsProject.instance().readBoolEntry("Tww", "FollowRainwaterCurrent", True)
        rw_current_checkbox.setChecked(status)
        rw_planned_checkbox = QCheckBox(self.tr("Rainwater planned"))
        status, _ = QgsProject.instance().readBoolEntry("Tww", "FollowRainwaterPlanned", True)
        rw_planned_checkbox.setChecked(status)
        btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        btn_box.accepted.connect(dlg.accept)
        btn_box.rejected.connect(dlg.reject)
        dlg.layout().addWidget(ww_current_checkbox)
        dlg.layout().addWidget(ww_planned_checkbox)
        dlg.layout().addWidget(rw_current_checkbox)
        dlg.layout().addWidget(rw_planned_checkbox)
        dlg.layout().addWidget(btn_box)

        if dlg.exec_():
            QgsProject.instance().writeEntry(
                "Tww", "FollowWastewaterCurrent", ww_current_checkbox.isChecked()
            )
            QgsProject.instance().writeEntry(
                "Tww", "FollowWastewaterPlanned", ww_planned_checkbox.isChecked()
            )
            QgsProject.instance().writeEntry(
                "Tww", "FollowRainwaterCurrent", rw_current_checkbox.isChecked()
            )
            QgsProject.instance().writeEntry(
                "Tww", "FollowRainwaterPlanned", rw_planned_checkbox.isChecked()
            )

    @pyqtSlot()
    def onSelectCurrentPathAction(self):
        reaches = list()
        wastewater_nodes = list()
        wastewater_structures = list()

        for item in self.edges:
            item_information = item[2]
            if item_information["objType"] == "reach":
                reaches.append(item_information["baseFeature"])

        for item in self.nodes:
            if item["objType"] == "wastewater_node":
                wastewater_nodes.append(item["objId"])

        tww_wastewater_structures_layer = TwwLayerManager.layer("vw_tww_wastewater_structure")
        wastewater_nodes_layer = TwwLayerManager.layer("vw_wastewater_node")
        tww_reach_layer = TwwLayerManager.layer("vw_tww_reach")
        catchment_areas_layer = TwwLayerManager.layer("od_catchment_area")

        wastewater_node_list = ",".join("'" + id + "'" for id in wastewater_nodes)
        reach_list = ",".join("'" + id + "'" for id in reaches)

        if catchment_areas_layer:
            request = QgsFeatureRequest()
            filters = list()
            if QgsProject.instance().readBoolEntry("Tww", "FollowWastewaterCurrent", True)[0]:
                filters.append(
                    f"fk_wastewater_networkelement_ww_current IN ({wastewater_node_list})"
                )
            if QgsProject.instance().readBoolEntry("Tww", "FollowWastewaterPlanned", True)[0]:
                filters.append(
                    f"fk_wastewater_networkelement_ww_planned IN ({wastewater_node_list})"
                )
            if QgsProject.instance().readBoolEntry("Tww", "FollowRainwaterCurrent", True)[0]:
                filters.append(
                    f"fk_wastewater_networkelement_rw_current IN ({wastewater_node_list})"
                )
            if QgsProject.instance().readBoolEntry("Tww", "FollowRainwaterPlanned", True)[0]:
                filters.append(
                    f"fk_wastewater_networkelement_rw_planned IN ({wastewater_node_list})"
                )

            if filters:
                request.setFilterExpression(" OR ".join(filters))
                features = catchment_areas_layer.getFeatures(request)
                catchment_areas_layer.select([f.id() for f in features])

        if tww_reach_layer:
            request = QgsFeatureRequest()
            request.setFilterExpression(f"obj_id IN ({reach_list})")
            features = tww_reach_layer.getFeatures(request)
            tww_reach_layer.select([f.id() for f in features])

        if wastewater_nodes_layer:
            request = QgsFeatureRequest()
            request.setFilterExpression(f"obj_id IN ({wastewater_node_list})")
            features = wastewater_nodes_layer.getFeatures(request)
            ids = list()
            for feature in features:
                ids.append(feature.id())
                wastewater_structures.append(feature["fk_wastewater_structure"])
            wastewater_nodes_layer.select(ids)

        wastewater_structure_list = ",".join(
            "'" + id + "'" for id in wastewater_structures if type(id) is str
        )

        if tww_wastewater_structures_layer:
            request = QgsFeatureRequest()
            request.setFilterExpression(f"obj_id IN ({wastewater_structure_list})")
            features = tww_wastewater_structures_layer.getFeatures(request)
            tww_wastewater_structures_layer.select([f.id() for f in features])

    def setTree(self, nodes, edges):
        self.nodes = nodes
        self.edges = edges
        self.selectCurrentPathAction.setEnabled(self.nodes is not None)
