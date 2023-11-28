# -*- coding: utf-8 -*-
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
# with this progsram; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------

import logging

from qgis.PyQt.QtCore import QSettings, Qt, QUrl, pyqtSignal, pyqtSlot
from qgis.PyQt.QtPrintSupport import QPrinter, QPrintPreviewDialog
from qgis.PyQt.QtWebKit import QWebSettings
from qgis.PyQt.QtWebKitWidgets import QWebPage, QWebView
from qgis.PyQt.QtWidgets import QVBoxLayout, QWidget

from ..tools.qgepnetwork import QgepGraphManager
from ..utils.translation import QgepJsTranslator
from ..utils.ui import plugin_root_path


class QgepWebPage(QWebPage):
    logger = logging.getLogger(__name__)

    def __init__(self, parent):
        QWebPage.__init__(self, parent)

    def javaScriptConsoleMessage(self, msg, line, source):
        self.logger.debug("{} line {}: {}".format(source, line, msg))


class QgepPlotSVGWidget(QWidget):
    webView = None
    webPage = None
    frame = None
    profile = None
    verticalExaggeration = 10
    jsTranslator = QgepJsTranslator()

    # Signals emitted triggered by javascript actions
    reachClicked = pyqtSignal([str], name="reachClicked")
    reachMouseOver = pyqtSignal([str], name="reachMouseOver")
    reachMouseOut = pyqtSignal([str], name="reachMouseOut")
    reachPointClicked = pyqtSignal([str, str], name="reachPointClicked")
    reachPointMouseOver = pyqtSignal([str, str], name="reachPointMouseOver")
    reachPointMouseOut = pyqtSignal([str, str], name="reachPointMouseOut")
    specialStructureClicked = pyqtSignal([str], name="specialStructureClicked")
    specialStructureMouseOver = pyqtSignal([str], name="specialStructureMouseOver")
    specialStructureMouseOut = pyqtSignal([str], name="specialStructureMouseOut")

    # Signals emitted for javascript
    profileChanged = pyqtSignal([str], name="profileChanged")
    verticalExaggerationChanged = pyqtSignal([int], name="verticalExaggerationChanged")

    def __init__(self, parent, network_analyzer: QgepGraphManager, url: str = None):
        QWidget.__init__(self, parent)

        self.webView = QWebView()
        self.webView.setPage(QgepWebPage(self.webView))

        self.networkAnalyzer = network_analyzer

        settings = QSettings()

        layout = QVBoxLayout(self)
        if url is None:
            # Starting with QGIS 3.4, QWebView requires paths with / even on windows.
            default_url = (
                plugin_root_path().replace("\\", "/") + "/svgprofile/index.html"
            )
            url = settings.value("/QGEP/SvgProfilePath", default_url)
            url = "file:///" + url

        developer_mode = settings.value("/QGEP/DeveloperMode", False, type=bool)

        if developer_mode is True:
            self.webView.page().settings().setAttribute(
                QWebSettings.DeveloperExtrasEnabled, True
            )
        else:
            self.webView.setContextMenuPolicy(Qt.NoContextMenu)

        self.webView.load(QUrl(url))
        self.frame = self.webView.page().mainFrame()
        self.frame.javaScriptWindowObjectCleared.connect(self.initJs)

        layout.addWidget(self.webView)

    def setProfile(self, profile):
        self.profile = profile
        # Forward to javascript
        self.profileChanged.emit(profile.asJson())

    def initJs(self):
        self.frame.addToJavaScriptWindowObject("profileProxy", self)
        self.frame.addToJavaScriptWindowObject("i18n", self.jsTranslator)

    def changeVerticalExaggeration(self, val):
        self.verticalExaggeration = val
        self.verticalExaggerationChanged.emit(val)

    def printProfile(self):
        printer = QPrinter(QPrinter.HighResolution)
        printer.setOutputFormat(QPrinter.PdfFormat)
        printer.setPaperSize(QPrinter.A4)
        printer.setOrientation(QPrinter.Landscape)

        printpreviewdlg = QPrintPreviewDialog()
        printpreviewdlg.paintRequested.connect(self.printRequested)

        printpreviewdlg.exec_()

    @pyqtSlot(QPrinter)
    def printRequested(self, printer):
        self.webView.print_(printer)

    @pyqtSlot(str)
    def onReachClicked(self, obj_id):
        self.reachClicked.emit(obj_id)

    @pyqtSlot(str)
    def onReachMouseOver(self, obj_id):
        self.reachMouseOver.emit(obj_id)

    @pyqtSlot(str)
    def onReachMouseOut(self, obj_id):
        self.reachMouseOut.emit(obj_id)

    @pyqtSlot(str, str)
    def onReachPointClicked(self, obj_id, reach_obj_id):
        self.reachPointClicked.emit(obj_id, reach_obj_id)

    @pyqtSlot(str, str)
    def onReachPointMouseOver(self, obj_id, reach_obj_id):
        self.reachPointMouseOver.emit(obj_id, reach_obj_id)

    @pyqtSlot(str, str)
    def onReachPointMouseOut(self, obj_id, reach_obj_id):
        self.reachPointMouseOut.emit(obj_id, reach_obj_id)

    @pyqtSlot(str)
    def onSpecialStructureClicked(self, obj_id):
        self.specialStructureClicked.emit(obj_id)

    @pyqtSlot(str)
    def onSpecialStructureMouseOver(self, obj_id):
        self.specialStructureMouseOver.emit(obj_id)

    @pyqtSlot(str)
    def onSpecialStructureMouseOut(self, obj_id):
        self.specialStructureMouseOut.emit(obj_id)

    # Is called from the webView when it's been reloaded and wants to have the
    # profile information resent
    @pyqtSlot()
    def updateProfile(self):
        if self.profile:
            self.profileChanged.emit(self.profile.asJson())
            self.verticalExaggerationChanged.emit(self.verticalExaggeration)
