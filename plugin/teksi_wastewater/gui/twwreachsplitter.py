# -----------------------------------------------------------
#
# TEKSI Wastewater
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

from ..tools.twwmaptooladdfeature import TwwMapToolSplitReachWithNode
from ..utils import get_ui_class
from ..utils.twwlayermanager import TwwLayerManager

DOCK_WIDGET = get_ui_class("twwreachsplitter.ui")


class TwwReachSplitter(QDockWidget, DOCK_WIDGET):
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
        self.layerComboBox.insertItem(self.layerComboBox.count(), self.tr("Wastewater node"), "wastewater_node")
        self.stateButton.setProperty("state", "inactive")

        self.mapToolSplitReachWithWN = TwwMapToolSplitReachWithNode(
            self.iface, TwwLayerManager.layer("vw_wastewater_node")
        )
        self.mapToolSplitReachWithWS = TwwMapToolSplitReachWithNode(
            self.iface, TwwLayerManager.layer("vw_tww_wastewater_structure")
        )

    @pyqtSlot(int)
    def layerChanged(self, index):
        for lyr in [
            TwwLayerManager.layer("vw_tww_reach"),
            TwwLayerManager.layer("vw_wastewater_node"),
            TwwLayerManager.layer("vw_tww_wastewater_structure"),
        ]:
            lyr.commitChanges()

        if (
            self.layerComboBox.itemData(self.layerComboBox.currentIndex())
            == "wastewater_structure"
        ):
            lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
            lyr.startEditing()
            self.iface.mapCanvas().setMapTool(self.mapToolSplitReachWithWS)

        elif self.layerComboBox.itemData(self.layerComboBox.currentIndex()) == "wastewater_node":
            lyr = TwwLayerManager.layer("vw_wastewater_node")
            lyr.startEditing()
            self.iface.mapCanvas().setMapTool(self.mapToolSplitReachWithWN)

    @pyqtSlot()
    def stateChanged(self):
        if self.stateButton.property("state") != "active":
            self.layerComboBox.setEnabled(True)
            self.layerChanged(0)
            self.stateButton.setText(self.tr("Stop Splitting Reaches"))
            self.stateButton.setProperty("state", "active")
        else:
            for lyr in [
                TwwLayerManager.layer("vw_tww_reach"),
                TwwLayerManager.layer("vw_wastewater_node"),
                TwwLayerManager.layer("vw_tww_wastewater_structure"),
            ]:
                lyr.commitChanges()
            self.layerComboBox.setEnabled(False)
            self.stateButton.setText(self.tr("Start Splitting Reaches"))
            self.stateButton.setProperty("state", "inactive")
