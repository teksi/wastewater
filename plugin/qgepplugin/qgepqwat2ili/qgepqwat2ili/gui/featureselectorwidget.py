# -----------------------------------------------------------
#
# QGIS wincan 2 QGEP Plugin
# Copyright (C) 2016 Denis Rouzaud
#
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
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------


from qgis.core import (
    Qgis,
    QgsApplication,
    QgsExpression,
    QgsExpressionContext,
    QgsExpressionContextScope,
    QgsFeature,
)
from qgis.gui import QgsHighlight, QgsMapToolIdentifyFeature
from qgis.PyQt.QtCore import QSettings, QTimer, pyqtSignal, pyqtSlot
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QAction, QHBoxLayout, QLineEdit, QToolButton, QWidget


class CanvasExtent(object):
    Fixed = 1
    Pan = 2
    Scale = 3


class FeatureSelectorWidget(QWidget):
    feature_identified = pyqtSignal(QgsFeature)

    def __init__(self, parent):
        QWidget.__init__(self, parent)

        edit_layout = QHBoxLayout()
        edit_layout.setContentsMargins(0, 0, 0, 0)
        edit_layout.setSpacing(2)
        self.setLayout(edit_layout)

        self.line_edit = QLineEdit(self)
        self.line_edit.setReadOnly(True)
        edit_layout.addWidget(self.line_edit)

        self.highlight_feature_button = QToolButton(self)
        self.highlight_feature_button.setPopupMode(QToolButton.MenuButtonPopup)
        self.highlight_feature_action = QAction(
            QgsApplication.getThemeIcon("/mActionHighlightFeature.svg"), "Highlight feature", self
        )
        self.scale_highlight_feature_action = QAction(
            QgsApplication.getThemeIcon("/mActionScaleHighlightFeature.svg"), "Scale and highlight feature", self
        )
        self.pan_highlight_feature_action = QAction(
            QgsApplication.getThemeIcon("/mActionPanHighlightFeature.svg"), "Pan and highlight feature", self
        )
        self.highlight_feature_button.addAction(self.highlight_feature_action)
        self.highlight_feature_button.addAction(self.scale_highlight_feature_action)
        self.highlight_feature_button.addAction(self.pan_highlight_feature_action)
        self.highlight_feature_button.setDefaultAction(self.highlight_feature_action)
        edit_layout.addWidget(self.highlight_feature_button)

        self.map_identification_button = QToolButton(self)
        self.map_identification_button.setIcon(QgsApplication.getThemeIcon("/mActionMapIdentification.svg"))
        self.map_identification_button.setText("Select on map")
        self.map_identification_button.setCheckable(True)
        edit_layout.addWidget(self.map_identification_button)

        self.map_identification_button.clicked.connect(self.map_identification)
        self.highlight_feature_button.triggered.connect(self.highlight_action_triggered)

        self.layer = None
        self.map_tool = None
        self.canvas = None
        self.window_widget = None
        self.highlight = None
        self.feature = QgsFeature()

    def set_canvas(self, map_canvas):
        self.map_tool = QgsMapToolIdentifyFeature(map_canvas)
        self.map_tool.setButton(self.map_identification_button)
        self.canvas = map_canvas

    def set_layer(self, layer):
        self.layer = layer

    def set_feature(self, feature, canvas_extent=CanvasExtent.Fixed):
        self.line_edit.clear()
        self.feature = feature

        if self.feature is None or not self.feature.isValid() or self.layer is None:
            return

        expression = QgsExpression(self.layer.displayExpression())
        context = QgsExpressionContext()
        scope = QgsExpressionContextScope()
        context.appendScope(scope)
        scope.setFeature(feature)
        feature_title = expression.evaluate(context)
        if feature_title == "":
            feature_title = feature.id()
        self.line_edit.setText(str(feature_title))
        self.highlight_feature(canvas_extent)

    def clear(self):
        self.feature = QgsFeature()
        self.line_edit.clear()

    @pyqtSlot()
    def map_identification(self):
        if self.layer is None or self.map_tool is None or self.canvas is None:
            return

        self.map_tool.setLayer(self.layer)
        self.canvas.setMapTool(self.map_tool)

        self.window_widget = QWidget.window(self)
        self.canvas.window().raise_()
        self.canvas.activateWindow()
        self.canvas.setFocus()

        self.map_tool.featureIdentified.connect(self.map_tool_feature_identified)
        self.map_tool.deactivated.connect(self.map_tool_deactivated)

    def map_tool_feature_identified(self, feature):
        feature = QgsFeature(feature)
        self.feature_identified.emit(feature)
        self.unset_map_tool()
        self.set_feature(feature)

    def map_tool_deactivated(self):
        if self.window_widget is not None:
            self.window_widget.raise_()
            self.window_widget.activateWindow()

    def highlight_feature(self, canvas_extent=CanvasExtent.Fixed):
        if self.canvas is None or not self.feature.isValid():
            return

        geom = self.feature.geometry()

        if geom is None:
            return

        if canvas_extent == CanvasExtent.Scale:
            feature_bounding_box = geom.boundingBox()
            feature_bounding_box = self.canvas.mapSettings().layerToMapCoordinates(self.layer, feature_bounding_box)
            extent = self.canvas.extent()
            if not extent.contains(feature_bounding_box):
                extent.combineExtentWith(feature_bounding_box)
                extent.scale(1.1)
                self.canvas.setExtent(extent)
                self.canvas.refresh()

        elif canvas_extent == CanvasExtent.Pan:
            centroid = geom.centroid()
            center = centroid.asPoint()

            center = self.canvas.mapSettings().layerToMapCoordinates(self.layer, center)
            self.canvas.zoomByFactor(1.0, center)  # refresh is done in this method

        # highlight
        self.delete_highlight()
        self.highlight = QgsHighlight(self.canvas, geom, self.layer)

        settings = QSettings()
        color = QColor(settings.value("/Map/highlight/color", Qgis.DEFAULT_HIGHLIGHT_COLOR.name()))
        alpha = int(settings.value("/Map/highlight/colorAlpha", Qgis.DEFAULT_HIGHLIGHT_COLOR.alpha()))
        buffer = 2 * float(settings.value("/Map/highlight/buffer", Qgis.DEFAULT_HIGHLIGHT_BUFFER_MM))
        min_width = 2 * float(settings.value("/Map/highlight/min_width", Qgis.DEFAULT_HIGHLIGHT_MIN_WIDTH_MM))

        self.highlight.setColor(color)  # sets also fill with default alpha
        color.setAlpha(alpha)
        self.highlight.setFillColor(color)  # sets fill with alpha
        self.highlight.setBuffer(buffer)
        self.highlight.setMinWidth(min_width)
        self.highlight.setWidth(4.0)
        self.highlight.show()

        self.timer = QTimer(self)
        self.timer.setSingleShot(True)
        self.timer.timeout.connect(self.delete_highlight)
        self.timer.start(3000)

    def delete_highlight(self):
        if self.highlight is not None:
            self.highlight.hide()
            del self.highlight
            self.highlight = None

    def unset_map_tool(self):
        if self.canvas is not None and self.map_tool is not None:
            # this will call mapTool.deactivated
            self.canvas.unsetMapTool(self.map_tool)

    def highlight_action_triggered(self, action):
        self.highlight_feature_button.setDefaultAction(action)

        if action == self.highlight_feature_action:
            self.highlight_feature()

        elif action == self.scale_highlight_feature_action:
            self.highlight_feature(CanvasExtent.Scale)

        elif action == self.pan_highlight_feature_action:
            self.highlight_feature(CanvasExtent.Pan)
