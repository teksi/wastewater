# -----------------------------------------------------------
#
# Qgep
# Copyright (C) 2014  Matthias Kuhn
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

import logging

from qgis.PyQt.QtCore import pyqtSlot
from qgis.PyQt.QtWidgets import QDockWidget

from ..tools.qgepmaptooladdfeature import QgepMapToolAddReach
from ..utils import get_ui_class
from ..utils.qgeplayermanager import QgepLayerManager

DOCK_WIDGET = get_ui_class("qgepwizard.ui")


class QgepWizard(QDockWidget, DOCK_WIDGET):
    logger = logging.getLogger(__name__)

    def __init__(self, parent, iface):
        QDockWidget.__init__(self, parent)
        self.setupUi(self)
        self.layerComboBox.currentIndexChanged.connect(self.layerChanged)
        self.stateButton.clicked.connect(self.stateChanged)
        self.iface = iface
        self.layerComboBox.insertItem(
            self.layerComboBox.count(),
            self.tr("Wastewater Structure"),
            "wastewater_structure",
        )
        self.layerComboBox.insertItem(self.layerComboBox.count(), self.tr("Reach"), "reach")
        self.stateButton.setProperty("state", "inactive")

        self.mapToolAddReach = QgepMapToolAddReach(
            self.iface, QgepLayerManager.layer("vw_qgep_reach")
        )

    @pyqtSlot(int)
    def layerChanged(self, index):
        for lyr in [
            QgepLayerManager.layer("vw_qgep_wastewater_structure"),
            QgepLayerManager.layer("vw_qgep_reach"),
        ]:
            lyr.commitChanges()

        if (
            self.layerComboBox.itemData(self.layerComboBox.currentIndex())
            == "wastewater_structure"
        ):
            lyr = QgepLayerManager.layer("vw_qgep_wastewater_structure")
            lyr.startEditing()
            self.iface.setActiveLayer(lyr)
            self.iface.actionAddFeature().trigger()

        elif self.layerComboBox.itemData(self.layerComboBox.currentIndex()) == "reach":
            lyr = QgepLayerManager.layer("vw_qgep_reach")
            lyr.startEditing()
            self.iface.mapCanvas().setMapTool(self.mapToolAddReach)

    @pyqtSlot()
    def stateChanged(self):
        if self.stateButton.property("state") != "active":
            self.layerComboBox.setEnabled(True)
            self.layerChanged(0)
            self.stateButton.setText(self.tr("Stop Data Entry"))
            self.stateButton.setProperty("state", "active")
        else:
            for lyr in [
                QgepLayerManager.layer("vw_qgep_reach"),
                QgepLayerManager.layer("vw_qgep_wastewater_structure"),
            ]:
                lyr.commitChanges()
            self.layerComboBox.setEnabled(False)
            self.stateButton.setText(self.tr("Start Data Entry"))
            self.stateButton.setProperty("state", "inactive")
