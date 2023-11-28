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

import logging

from qgis.core import QgsProject
from qgis.PyQt.QtCore import QSettings, pyqtSlot
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QDialog, QFileDialog

from ..utils import get_ui_class

DIALOG_UI = get_ui_class("qgepsettingsdialog.ui")

LOGFORMAT = "%(asctime)s:%(levelname)s:%(module)s:%(message)s"


class QgepSettingsDialog(QDialog, DIALOG_UI):
    settings = QSettings()

    def __init__(self, parent=None):
        QDialog.__init__(self, parent)
        self.setupUi(self)

        project = QgsProject.instance()

        svgprofile_path = self.settings.value("/QGEP/SvgProfilePath", None)
        if svgprofile_path:
            self.mGbOverrideDefaultProfileTemplate.setChecked(True)
            self.mProfileTemplateFile.setText(svgprofile_path)
        else:
            self.mGbOverrideDefaultProfileTemplate.setChecked(False)

        develmode = self.settings.value("/QGEP/DeveloperMode", False, type=bool)
        self.mCbDevelMode.setChecked(develmode)

        adminmode = self.settings.value("/QGEP/AdminMode", False, type=bool)
        self.mCbAdminMode.setChecked(adminmode)

        lyr_special_structures, _ = project.readEntry("QGEP", "SpecialStructureLayer")
        lyr_graph_edges, _ = project.readEntry("QGEP", "GraphEdgeLayer")
        lyr_graph_nodes, _ = project.readEntry("QGEP", "GraphNodeLayer")

        self.initLayerCombobox(self.mCbSpecialStructures, lyr_special_structures)
        self.initLayerCombobox(self.mCbGraphEdges, lyr_graph_edges)
        self.initLayerCombobox(self.mCbGraphNodes, lyr_graph_nodes)

        self.mCurrentProfileColorButton.setColor(
            QColor(self.settings.value("/QGEP/CurrentProfileColor", "#FF9500"))
        )
        self.mHelperLineColorButton.setColor(
            QColor(self.settings.value("/QGEP/HelperLineColor", "#FFD900"))
        )
        self.mHighlightColorButton.setColor(
            QColor(self.settings.value("/QGEP/HighlightColor", "#40FF40"))
        )

        self.mPbnChooseProfileTemplateFile.clicked.connect(self.onChooseProfileTemplateFileClicked)
        self.mPbnChooseLogFile.clicked.connect(self.onChooseLogFileClicked)

        self.accepted.connect(self.onAccept)

        loglevel = self.settings.value("/QGEP/LogLevel", "Warning")
        self.mCbLogLevel.setCurrentIndex(self.mCbLogLevel.findText(self.tr(loglevel)))

        logfile = self.settings.value("/QGEP/LogFile", None)

        if logfile is not None:
            self.mGbLogToFile.setChecked(True)
            self.mLogFile.setText(logfile)
        else:
            self.mGbLogToFile.setChecked(False)

    def initLayerCombobox(self, combobox, default):
        reg = QgsProject.instance()
        for key, layer in list(reg.mapLayers().items()):
            combobox.addItem(layer.name(), key)

        idx = combobox.findData(default)
        if idx != -1:
            combobox.setCurrentIndex(idx)

    @pyqtSlot()
    def onAccept(self):
        qgeplogger = logging.getLogger("qgep")
        # General settings
        if self.mGbOverrideDefaultProfileTemplate.isChecked() and self.mProfileTemplateFile.text():
            self.settings.setValue("/QGEP/SvgProfilePath", self.mProfileTemplateFile.text())
        else:
            self.settings.remove("/QGEP/SvgProfilePath")

        self.settings.setValue("/QGEP/DeveloperMode", self.mCbDevelMode.isChecked())
        self.settings.setValue("/QGEP/AdminMode", self.mCbAdminMode.isChecked())

        # Logging
        if hasattr(qgeplogger, "qgepFileHandler"):
            qgeplogger.removeHandler(qgeplogger.qgepFileHandler)
            del qgeplogger.qgepFileHandler

        if self.mGbLogToFile.isChecked():
            logfile = str(self.mLogFile.text())
            log_handler = logging.FileHandler(logfile)
            fmt = logging.Formatter(LOGFORMAT)
            log_handler.setFormatter(fmt)
            qgeplogger.addHandler(log_handler)
            qgeplogger.qgepFileHandler = log_handler
            self.settings.setValue("/QGEP/LogFile", logfile)
        else:
            self.settings.setValue("/QGEP/LogFile", None)

        if self.tr("Debug") == self.mCbLogLevel.currentText():
            qgeplogger.setLevel(logging.DEBUG)
            self.settings.setValue("/QGEP/LogLevel", "Debug")
        elif self.tr("Info") == self.mCbLogLevel.currentText():
            qgeplogger.setLevel(logging.INFO)
            self.settings.setValue("/QGEP/LogLevel", "Info")
        elif self.tr("Warning") == self.mCbLogLevel.currentText():
            qgeplogger.setLevel(logging.WARNING)
            self.settings.setValue("/QGEP/LogLevel", "Warning")
        elif self.tr("Error") == self.mCbLogLevel.currentText():
            qgeplogger.setLevel(logging.ERROR)
            self.settings.setValue("/QGEP/LogLevel", "Error")

        # Save colors
        self.settings.setValue("/QGEP/HelperLineColor", self.mHelperLineColorButton.color().name())
        self.settings.setValue("/QGEP/HighlightColor", self.mHighlightColorButton.color().name())
        self.settings.setValue(
            "/QGEP/CurrentProfileColor", self.mCurrentProfileColorButton.color().name()
        )

        # Project specific settings
        project = QgsProject.instance()

        specialstructure_idx = self.mCbSpecialStructures.currentIndex()
        graph_edgelayer_idx = self.mCbGraphEdges.currentIndex()
        graph_nodelayer_idx = self.mCbGraphNodes.currentIndex()

        project.writeEntry(
            "QGEP",
            "SpecialStructureLayer",
            self.mCbSpecialStructures.itemData(specialstructure_idx),
        )
        project.writeEntry(
            "QGEP", "GraphEdgeLayer", self.mCbGraphEdges.itemData(graph_edgelayer_idx)
        )
        project.writeEntry(
            "QGEP", "GraphNodeLayer", self.mCbGraphNodes.itemData(graph_nodelayer_idx)
        )

    @pyqtSlot()
    def onChooseProfileTemplateFileClicked(self):
        filename, __ = QFileDialog.getOpenFileName(
            self,
            self.tr("Select profile template"),
            "",
            self.tr("HTML files(*.htm *.html)"),
        )
        self.mProfileTemplateFile.setText(filename)

    @pyqtSlot()
    def onChooseLogFileClicked(self):
        filename, __ = QFileDialog.getSaveFileName(
            self, self.tr("Select log file"), "", self.tr("Log files(*.log)")
        )
        self.mLogFile.setText(filename)
