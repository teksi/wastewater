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

from qgis.gui import QgsMessageBar
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
        self.stateButton.clicked.connect(self.stateChanged)
        self.iface = iface
        self.mapToolSplitReachWithWN = TwwMapToolSplitReachWithNode(
            self.iface, TwwLayerManager.layer("vw_wastewater_node"),self.mCbChannelSplitMode.isChecked()
        )
        self.mapToolSplitReachWithWS = TwwMapToolSplitReachWithNode(
            self.iface, TwwLayerManager.layer("vw_tww_wastewater_structure")
        )
        self.mapToolSplitReachWithNoNode = TwwMapToolSplitReachWithNode(
            self.iface, None, self.mCbChannelSplitMode.isChecked()
        )
        self.layerComboBox.insertItem(
            self.layerComboBox.count(),
            self.tr("Wastewater Structure"),
            "wastewater_structure",
        )
        self.layerComboBox.insertItem(
            self.layerComboBox.count(), self.tr("Wastewater node"), "wastewater_node"
        )
        self.layerComboBox.insertItem(
            self.layerComboBox.count(), self.tr("No node"), "no node"
        )
        self.layerComboBox.setCurrentIndex(1)
        self.stateButton.setProperty("state", "inactive")
        self.msgtitle = self.tr(
            f"Split reach with {self.layerComboBox.itemData(self.layerComboBox.currentIndex())}"
        )
        self.msg = "Left Click to digitize"
        self.messageBarItem = QgsMessageBar.createMessage(self.msgtitle, self.msg)
        self.layerComboBox.currentIndexChanged.connect(self.layerChanged)

    @pyqtSlot(int)
    def layerChanged(self, index):
        try:
            self.iface.messageBar().popWidget(self.messageBarItem)
        except Exception:
            pass
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
        else:  # current index is not initialized
            # set current index for messageBar
            self.layerComboBox.setCurrentIndex(1)

        if self.stateButton.property("state") == "active":
            self.msgtitle = self.tr(
                f"Split reach with {self.layerComboBox.itemData(self.layerComboBox.currentIndex())}"
            )
            self.messageBarItem = QgsMessageBar.createMessage(self.msgtitle, self.msg)
            self.iface.messageBar().pushItem(self.messageBarItem)

    @pyqtSlot()
    def stateChanged(self):
        try:
            self.iface.messageBar().popWidget(self.messageBarItem)
        except Exception:
            pass

        if self.stateButton.property("state") != "active":
            self.layerComboBox.setEnabled(True)
            self.layerChanged(0)
            self.stateButton.setText(self.tr("Stop Splitting Reaches"))
            self.stateButton.setProperty("state", "active")
            self.messageBarItem = QgsMessageBar.createMessage(self.msgtitle, self.msg)
            self.iface.messageBar().pushItem(self.messageBarItem)
        else:
            self.layerComboBox.setEnabled(False)
            self.stateButton.setText(self.tr("Start Splitting Reaches"))
            self.stateButton.setProperty("state", "inactive")
