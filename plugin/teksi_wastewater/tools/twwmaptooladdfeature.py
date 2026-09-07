# -----------------------------------------------------------
#
# TEKSI Wastewater
#
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

"""
Some map tools for digitizing features
"""

import math

from qgis.core import (
    NULL,
    Qgis,
    QgsFeature,
    QgsFeatureRequest,
    QgsGeometry,
    QgsPoint,
    QgsPointXY,
    QgsSettings,
    QgsSnappingConfig,
    QgsTolerance,
    QgsWkbTypes,
)
from qgis.gui import (
    QgisInterface,
    QgsAttributeEditorContext,
    QgsMapCanvas,
    QgsMapCanvasSnappingUtils,
    QgsMapTool,
    QgsMapToolAdvancedDigitizing,
    QgsMessageBar,
    QgsRubberBand,
    QgsVertexMarker,
)
from qgis.PyQt.QtCore import Qt, pyqtSignal
from qgis.PyQt.QtGui import QColor, QCursor
from qgis.PyQt.QtWidgets import (
    QApplication,
    QDialog,
    QDialogButtonBox,
    QGridLayout,
    QLabel,
    QLineEdit,
    QMessageBox,
)

from ..utils.twwlayermanager import TwwLayerManager


class TwwRubberBand3D(QgsRubberBand):
    def __init__(self, map_canvas: QgsMapCanvas, geometry_type):
        QgsRubberBand.__init__(self, map_canvas, geometry_type)
        self.points = []

    def addPoint3D(self, point):
        assert isinstance(point, QgsPoint)
        QgsRubberBand.addPoint(self, QgsPointXY(point.x(), point.y()))
        # Workaround crash with QGIS 3.10.2 (https://github.com/qgis/QGIS/issues/34557)
        new_point = QgsPoint(point.x(), point.y(), point.z(), point.m(), point.wkbType())
        self.points.append(new_point)

    def reset3D(self):
        QgsRubberBand.reset(self)
        self.points = []

    def asGeometry3D(self):
        def ensure_z(z):
            if math.isnan(z):
                return QgsSettings().value(
                    "/qgis/digitizing/default_z_value", Qgis.DEFAULT_Z_COORDINATE
                )
            return z

        wkt = (
            "LineStringZ("
            + ", ".join([f"{p.x()} {p.y()} {ensure_z(p.z())}" for p in self.points])
            + ")"
        )
        return QgsGeometry.fromWkt(wkt)


class TwwMapToolAddFeature(QgsMapToolAdvancedDigitizing):
    """
    Base class for adding features
    """

    def __init__(self, iface: QgisInterface, layer):
        QgsMapToolAdvancedDigitizing.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.layer = layer
        self.rubberband = TwwRubberBand3D(iface.mapCanvas(), layer.geometryType())
        self.rubberband.setColor(QColor("#ee5555"))
        self.rubberband.setWidth(1)
        self.temp_rubberband = QgsRubberBand(iface.mapCanvas(), layer.geometryType())
        self.temp_rubberband.setColor(QColor("#ee5555"))
        self.temp_rubberband.setWidth(1)
        self.temp_rubberband.setLineStyle(Qt.PenStyle.DotLine)

    def activate(self):
        """
        When activating the map tool
        """
        QgsMapToolAdvancedDigitizing.activate(self)
        self.canvas.setCursor(QCursor(Qt.CursorShape.CrossCursor))
        msgtitle = self.tr("Advanced Digitizing")
        msg = self.tr("Digitize start and end point. Rightclick to abort.")
        self.messageBarItem = QgsMessageBar.createMessage(msgtitle, msg)
        self.iface.messageBar().pushItem(self.messageBarItem)

    def deactivate(self):
        """
        On deactivating the map tool
        """
        QgsMapToolAdvancedDigitizing.deactivate(self)
        self.canvas.unsetCursor()

    # pylint: disable=no-self-use
    def isZoomTool(self):
        """
        This is no zoom tool
        """
        return False

    # ===========================================================================
    # Events
    # ===========================================================================

    def cadCanvasReleaseEvent(self, event):
        """
        Called when a mouse button is
        :param event:
        :return:
        """
        if event.button() == Qt.MouseButton.RightButton:
            self.right_clicked(event)
        else:
            self.left_clicked(event)

    def left_clicked(self, event):
        """
        When the canvas is left clicked we add a new point to the rubberband.
        :type event: QMouseEvent
        """
        mousepos = self.canvas.getCoordinateTransform().toMapCoordinates(
            event.pos().x(), event.pos().y()
        )
        self.rubberband.addPoint(mousepos)
        self.temp_rubberband.reset()

    def right_clicked(self, _):
        """
        On a right click we create a new feature from the existing rubberband and show the add
        dialog
        """
        f = QgsFeature(self.layer.fields())
        f.setGeometry(self.rubberband.asGeometry())
        dlg = self.iface.getFeatureForm(self.layer, f)
        dlg.setMode(QgsAttributeEditorContext.AddFeatureMode)
        dlg.exec()
        self.rubberband.reset3D()
        self.temp_rubberband.reset()

    def cadCanvasMoveEvent(self, event):
        """
        When the mouse is moved the rubberband needs to be updated
        :param event: The coordinates etc.
        """

        # When a generated event arrives it's a QMoveEvent... No idea why, but this prevents from an exception
        try:
            QgsMapToolAdvancedDigitizing.cadCanvasMoveEvent(self, event)
            mousepos = event.mapPoint()
            self.temp_rubberband.movePoint(mousepos)
            self.mouse_move(event)

        except TypeError:
            pass

    def mouse_move(self, event):
        pass


class TwwMapToolAddReach(TwwMapToolAddFeature):
    """
    Create a new reach with the mouse.
    Will snap to wastewater nodes for the first and last point and auto-connect
    these.
    """

    first_snapping_match = None
    last_snapping_match = None
    last_feature_attributes = None

    def __init__(self, iface: QgisInterface, layer):
        TwwMapToolAddFeature.__init__(self, iface, layer)
        self.snapping_marker = None
        self.node_layer = TwwLayerManager.layer("vw_tww_wastewater_node")
        assert self.node_layer is not None
        self.reach_layer = TwwLayerManager.layer("vw_tww_reach")
        assert self.reach_layer is not None
        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)

        layer_snapping_configs = [
            {"layer": self.node_layer, "mode": QgsSnappingConfig.Vertex},
            {"layer": self.reach_layer, "mode": QgsSnappingConfig.VertexAndSegment},
        ]
        self.snapping_configs = []
        self.snapping_utils = QgsMapCanvasSnappingUtils(self.iface.mapCanvas())

        for lsc in layer_snapping_configs:
            config = QgsSnappingConfig()
            config.setMode(QgsSnappingConfig.AdvancedConfiguration)
            config.setEnabled(True)
            settings = QgsSnappingConfig.IndividualLayerSettings(
                True, lsc["mode"], 10, QgsTolerance.Pixels
            )
            config.setIndividualLayerSettings(lsc["layer"], settings)
            self.snapping_configs.append(config)

    def left_clicked(self, event):
        """
        The mouse is clicked: snap to neary points which are on the wastewater node layer
        and update the rubberband
        :param event: The coordinates etc.
        """
        point3d, match = self.snap(event)
        if self.rubberband.numberOfVertices() == 0:
            self.first_snapping_match = match
        self.last_snapping_match = match
        self.rubberband.addPoint3D(point3d)
        self.temp_rubberband.reset()
        self.temp_rubberband.addPoint(QgsPointXY(point3d.x(), point3d.y()))

        if self.snapping_marker is not None:
            self.iface.mapCanvas().scene().removeItem(self.snapping_marker)
            self.snapping_marker = None

    def mouse_move(self, event):
        _, match = self.snap(event)
        # snap indicator
        if not match.isValid():
            if self.snapping_marker is not None:
                self.iface.mapCanvas().scene().removeItem(self.snapping_marker)
                self.snapping_marker = None
            return

        # TODO QGIS 3: see if vertices can be removed

        # we have a valid match
        if self.snapping_marker is None:
            self.snapping_marker = QgsVertexMarker(self.iface.mapCanvas())
            self.snapping_marker.setPenWidth(3)
            self.snapping_marker.setColor(QColor(Qt.GlobalColor.magenta))

        if match.hasVertex():
            if match.layer():
                icon_type = QgsVertexMarker.ICON_BOX  # vertex snap
            else:
                icon_type = QgsVertexMarker.ICON_X  # intersection snap
        else:
            icon_type = QgsVertexMarker.ICON_DOUBLE_TRIANGLE  # must be segment snap
        self.snapping_marker.setIconType(icon_type)
        self.snapping_marker.setCenter(match.point())

    def snap(self, event):
        """
        Snap to nearby points on the wastewater node layer which may be used as connection
        points for this reach.
        :param event: The mouse event
        :return: The snapped position in map coordinates
        """

        for config in self.snapping_configs:
            self.snapping_utils.setConfig(config)
            match = self.snapping_utils.snapToMap(QgsPointXY(event.originalMapPoint()))
            if match.isValid():
                return QgsPoint(match.point()), match

        # if no match, snap to all layers (according to map settings) and try to grab Z
        match = (
            self.iface.mapCanvas().snappingUtils().snapToMap(QgsPointXY(event.originalMapPoint()))
        )
        if match.isValid() and match.hasVertex():
            if match.layer():
                req = QgsFeatureRequest(match.featureId())
                f = next(match.layer().getFeatures(req))
                assert f.isValid()
                ok, vertex_id = f.geometry().vertexIdFromVertexNr(match.vertexIndex())
                assert ok
                point = f.geometry().constGet().vertexAt(vertex_id)
                assert isinstance(point, QgsPoint)
                return point, match
            else:
                return QgsPoint(match.point()), match

        return QgsPoint(event.originalMapPoint()), match

    def right_clicked(self, _):
        """
        The party is over, the reach digitized. Create a feature from the rubberband and
        show the feature form.
        """

        self.temp_rubberband.reset()

        if self.snapping_marker is not None:
            self.iface.mapCanvas().scene().removeItem(self.snapping_marker)
            self.snapping_marker = None

        if len(self.rubberband.points) >= 2:
            fields = self.layer.fields()
            f = QgsFeature(fields)
            if not self.last_feature_attributes:
                self.last_feature_attributes = [None] * fields.count()
            for idx, field in enumerate(fields):
                if field.name() in [
                    "clear_height",
                    "material",
                    "ch_usage_current",
                    "ch_function_hierarchic",
                    "ch_function_hydraulic",
                    "horizontal_positioning",
                    "ws_status",
                    "ws_year_of_construction",
                    "ws_fk_owner",
                    "ws_fk_operator",
                    "inside_coating",
                    "fk_pipe_profile",
                    "remark",
                ]:
                    f.setAttribute(idx, self.last_feature_attributes[idx])

                else:
                    # try client side default value first
                    v = self.layer.defaultValue(idx, f)
                    if v != NULL:
                        f.setAttribute(idx, v)
                    else:
                        f.setAttribute(idx, self.layer.dataProvider().defaultValue(idx))

            from_lbl = self.get_rp_identifier_from_match("from", f)
            to_lbl = self.get_rp_identifier_from_match("to", f)

            if from_lbl and to_lbl:
                identifier = f"{from_lbl}-{to_lbl}"
            else:
                identifier = f.attribute("obj_id")
            field = self.layer.fields().indexFromName("identifier")
            f.setAttribute(field, identifier)

            f.setGeometry(self.rubberband.asGeometry3D())

            snapping_results = {
                "from": self.first_snapping_match,
                "to": self.last_snapping_match,
            }
            for dest, match in list(snapping_results.items()):
                level_field_index = self.layer.fields().indexFromName(f"rp_{dest}_level")
                pt_idx = 0 if dest == "from" else -1
                if match.isValid() and match.layer() in (
                    self.node_layer,
                    self.reach_layer,
                ):
                    request = QgsFeatureRequest(match.featureId())
                    network_element = next(match.layer().getFeatures(request))
                    assert network_element.isValid()
                    # set the related network element
                    field = self.layer.fields().indexFromName(
                        f"rp_{dest}_fk_wastewater_networkelement"
                    )
                    f.setAttribute(field, network_element.attribute("obj_id"))
                    # assign level if the match is a node or if we have 3D from snapping
                    if match.layer() == self.node_layer:
                        level = network_element["bottom_level"]
                        f.setAttribute(level_field_index, level)
                elif self.rubberband.points[pt_idx].z() != 0:
                    level = self.rubberband.points[pt_idx].z()
                    level = level if not math.isnan(level) else NULL
                    f.setAttribute(level_field_index, level)

            dlg = self.iface.getFeatureForm(self.layer, f)
            dlg.setMode(QgsAttributeEditorContext.AddFeatureMode)
            dlg.exec()
            self.last_feature_attributes = dlg.feature().attributes()

        self.rubberband.reset3D()

    def get_rp_identifier_from_match(self, idx, feat):
        if idx == "from":
            match = self.first_snapping_match
        elif idx == "to":
            match = self.last_snapping_match
        else:
            return None

        if match.isValid() and match.layer() == self.node_layer:
            request = QgsFeatureRequest(match.featureId())
            network_element = next(self.node_layer.getFeatures(request))
            assert network_element.isValid()
            return network_element.attribute("identifier")
        else:  # no valid match or reach-reach connection
            return feat.attribute(f"rp_{idx}_obj_id")

class TwwMapToolRectangularGeometryBase(QgsMapTool):
    """
    Base class for rectangular geometry digitizing.

    Provides:
      - snapping
      - replacement validation
      - length display
      - rectangle creation
      - snapping marker
    """

    geometryDigitized = pyqtSignal()

    def __init__(self, iface, layer,ws_oid):
        super().__init__(iface.mapCanvas())

        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.layer = layer
        self.can_start=True
        self.ws_geom_layer = TwwLayerManager.layer("vw_wastewater_structure")
        assert self.ws_geom_layer is not None
        request = QgsFeatureRequest().setFilterExpression(
            f"obj_id = '{ws_oid}'"
        )

        ws_feature = next(self.ws_geom_layer.getFeatures(request), None)
        if not ws_feature:
            raise RuntimeError(
                self.tr("Wastewater structure could not be found.")
            )
        detail_geometry = ws_feature.geometry().asPolygon()
        if detail_geometry and not self.validateReplacement():
            self.can_start=False
            
        self.geometry = None
        self.messageBarItem = None

        self.firstPoint = None

        self.rubberband = QgsRubberBand(
            iface.mapCanvas(),
            QgsWkbTypes.LineGeometry,
        )
        self.rubberband.setColor(QColor("#ee5555"))
        self.rubberband.setWidth(2)

        self.snapping_marker = None

        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)

        self.snapping_utils = QgsMapCanvasSnappingUtils(
            self.iface.mapCanvas()
        )

    # ------------------------------------------------------------------
    # Common helpers
    # ------------------------------------------------------------------

    def validateReplacement(self):
        """
        Override if detailed_geometry can be checked directly.
        """

        reply = QMessageBox.question(
            self.iface.mainWindow(),
            self.tr("Replace geometry"),
            self.tr(
                "A detailed geometry already exists.\n\n"
                "Do you want to replace it?"
            ),
            QMessageBox.Yes | QMessageBox.No,
        )

        return reply == QMessageBox.Yes

    def createRectangle(self, lp1, lp2, width):
        length = math.sqrt(
            math.pow(lp1.x() - lp2.x(), 2)
            + math.pow(lp1.y() - lp2.y(), 2)
        )

        if length == 0:
            return None

        xd = lp2.x() - lp1.x()
        yd = lp2.y() - lp1.y()

        pt1 = QgsPointXY(
            lp1.x() + width * (yd / length),
            lp1.y() - width * (xd / length),
        )

        pt2 = QgsPointXY(
            lp1.x() - width * (yd / length),
            lp1.y() + width * (xd / length),
        )

        pt3 = QgsPointXY(
            lp2.x() - width * (yd / length),
            lp2.y() + width * (xd / length),
        )

        pt4 = QgsPointXY(
            lp2.x() + width * (yd / length),
            lp2.y() - width * (xd / length),
        )

        return QgsGeometry.fromPolygonXY(
            [[pt1, pt2, pt3, pt4, pt1]]
        )

    def askWidth(self, default_value="0.20"):
        dlg = QDialog()
        dlg.setWindowTitle(self.tr("Rectangle Width"))

        dlg.setLayout(QGridLayout())

        dlg.layout().addWidget(QLabel(self.tr("Width [m]")))

        txt = QLineEdit(default_value)
        dlg.layout().addWidget(txt)

        bb = QDialogButtonBox(
            QDialogButtonBox.StandardButton.Ok
            | QDialogButtonBox.StandardButton.Cancel
        )

        dlg.layout().addWidget(bb)

        bb.accepted.connect(dlg.accept)
        bb.rejected.connect(dlg.reject)

        if not dlg.exec():
            return None

        try:
            return float(txt.text()) / 2.0
        except ValueError:
            return None

    # ------------------------------------------------------------------
    # Snapping
    # ------------------------------------------------------------------

    def configureSnapping(self, layers):
        self.snapping_configs = []

        for layer in layers:

            config = QgsSnappingConfig()
            config.setEnabled(True)
            config.setMode(QgsSnappingConfig.AdvancedConfiguration)

            settings = QgsSnappingConfig.IndividualLayerSettings(
                True,
                QgsSnappingConfig.Vertex,
                10,
                QgsTolerance.Pixels,
            )

            config.setIndividualLayerSettings(
                layer,
                settings,
            )

            self.snapping_configs.append(config)

    def snap(self, event):

        for config in self.snapping_configs:

            self.snapping_utils.setConfig(config)

            match = self.snapping_utils.snapToMap(
                QgsPointXY(event.originalMapPoint())
            )

            if match.isValid():
                return QgsPointXY(match.point()), match

        match = self.canvas.snappingUtils().snapToMap(
            QgsPointXY(event.originalMapPoint())
        )

        if match.isValid():
            return QgsPointXY(match.point()), match

        return QgsPointXY(event.originalMapPoint()), match

    def updateSnapMarker(self, match):

        if not match.isValid():

            if self.snapping_marker is not None:
                self.canvas.scene().removeItem(
                    self.snapping_marker
                )
                self.snapping_marker = None

            return

        if self.snapping_marker is None:

            self.snapping_marker = QgsVertexMarker(self.canvas)
            self.snapping_marker.setPenWidth(3)
            self.snapping_marker.setColor(
                QColor(Qt.magenta)
            )

        self.snapping_marker.setCenter(match.point())

    # ------------------------------------------------------------------
    # Generic map tool methods
    # ------------------------------------------------------------------

    def activate(self):

        super().activate()
        if not self.canStart():
            self.deactivate()
            return

        self.canvas.setCursor(
            QCursor(Qt.CursorShape.CrossCursor)
        )

    def deactivate(self):

        super().deactivate()

        try:
            self.canvas.scene().removeItem(
                self.rubberband
            )
        except Exception:
            pass

        try:
            self.canvas.scene().removeItem(
                self.snapping_marker
            )
        except Exception:
            pass

        self.canvas.unsetCursor()

    def canvasMoveEvent(self, event):

        mousepos, match = self.snap(event)

        self.updateSnapMarker(match)

        if self.firstPoint:

            self.rubberband.movePoint(mousepos)

            length = self.firstPoint.distance(mousepos)

            self.iface.statusBarIface().showMessage(
                self.tr(
                    f"Length: {length:.2f} m"
                )
            )


# ======================================================================
# Drainage Channel
# ======================================================================

class TwwMapToolDigitizeDrainageChannel(
    TwwMapToolRectangularGeometryBase
):
    """
    Drainage channel:

    * starts automatically at wastewater node
    * one click for endpoint
    * width defaults to 0.20m
    * Ctrl -> custom width
    """

    def __init__(
        self,
        iface,
        layer,
        ws_oid,
    ):
        super().__init__(iface, layer, ws_oid)

        self.node_layer = TwwLayerManager.layer("vw_tww_wastewater_node")
        assert self.node_layer is not None
        self.ws_layer = TwwLayerManager.layer("vw_tww_wastewater_structure")
        assert self.ws_layer is not None
        request = QgsFeatureRequest().setFilterExpression(
            f"obj_id = '{ws_oid}'"
        )

        ws_feature = next(self.ws_layer.getFeatures(request), None)
        if not ws_feature:
            raise RuntimeError(
                self.tr("Wastewater structure could not be found.")
            )
        wn_oid=ws_feature.value('wn_obj_id')
        request = QgsFeatureRequest().setFilterExpression(
            f"obj_id = '{wn_oid}'"
        )

        self.wn_feature = next(self.node_layer.getFeatures(request), None)
        if self.wn_feature:
            node_point = self.wn_feature.geometry().asPoint()

            self.firstPoint = QgsPointXY(
                node_point.x(),
                node_point.y(),
            )
        else:
            QMessageBox.warning(
                self.iface.mainWindow(),
                self.tr("Drainage channel"),
                self.tr(
                    "The selected wastewater structure "
                    "has no associated wastewater node."
                ),
            )
            return

        self.configureSnapping([])

    def activate(self):

        super().activate()

        self.rubberband.reset()

        self.rubberband.addPoint(self.firstPoint)

        msgtitle = self.tr(
            "Digitize Drainage Channel"
        )

        msg = self.tr(
            "Click channel endpoint. "
            "Hold CTRL for custom width. "
            "Right click to abort."
        )

        self.messageBarItem = (
            self.iface.messageBar().createMessage(
                msgtitle,
                msg,
            )
        )

        self.iface.messageBar().pushWidget(
            self.messageBarItem
        )

    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.deactivate()
            return

        endpoint, _ = self.snap(event)

        width = 0.10

        if QApplication.keyboardModifiers() & Qt.ControlModifier:

            custom_width = self.askWidth("0.20")

            if custom_width is None:
                return

            width = custom_width

        self.geometry = self.createRectangle(
            self.firstPoint,
            endpoint,
            width,
        )

        if self.geometry:

            self.geometryDigitized.emit()

            self.deactivate()


# ======================================================================
# Generic rectangular detail geometry
# ======================================================================

class TwwMapToolDigitizeRectangularGeometry(
    TwwMapToolRectangularGeometryBase
):
    """
    Generic rectangular detail geometry.

    * two clicks
    * always asks for width
    * not tied to wastewater node
    """

    def __init__(self, iface, layer):

        super().__init__(iface, layer)

        self.firstPoint = None

        self.configureSnapping([])

    def activate(self):

        super().activate()

        msgtitle = self.tr(
            "Digitize Rectangular Detail Geometry"
        )

        msg = self.tr(
            "Digitize start and end point. "
            "Width will be requested afterwards. "
            "Right click to abort."
        )

        self.messageBarItem = (
            self.iface.messageBar().createMessage(
                msgtitle,
                msg,
            )
        )

        self.iface.messageBar().pushWidget(
            self.messageBarItem
        )

    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.deactivate()
            return

        point, _ = self.snap(event)

        self.rubberband.addPoint(point)

        if self.firstPoint is None:

            self.firstPoint = point

            return

        width = self.askWidth("1.00")

        if width is None:
            return

        self.geometry = self.createRectangle(
            self.firstPoint,
            point,
            width,
        )

        if self.geometry:

            self.geometryDigitized.emit()

            self.deactivate()