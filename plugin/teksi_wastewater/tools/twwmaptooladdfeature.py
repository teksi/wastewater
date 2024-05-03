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
        self.temp_rubberband.setLineStyle(Qt.DotLine)

    def activate(self):
        """
        When activating the map tool
        """
        QgsMapToolAdvancedDigitizing.activate(self)
        self.canvas.setCursor(QCursor(Qt.CrossCursor))

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
        if event.button() == Qt.RightButton:
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
        dlg.exec_()
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
        self.node_layer = TwwLayerManager.layer("vw_wastewater_node")
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
            self.snapping_marker.setColor(QColor(Qt.magenta))

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
                (ok, vertex_id) = f.geometry().vertexIdFromVertexNr(match.vertexIndex())
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
            dlg.exec_()
            self.last_feature_attributes = dlg.feature().attributes()

        self.rubberband.reset3D()


class TwwMapToolDigitizeDrainageChannel(QgsMapTool):
    """
    This is used to digitize a drainage channel.

    It lets you digitize two points and then creates a polygon based on these two points
    by adding an orthogonal offset at each side.

    Input:

       x==============x

    Output:

       ----------------
       |              |
       ----------------

    Usage:
      Connect to the signals deactivated() and geometryDigitized()
      If geometryDigitized() is called you can use the member variable geometry
      which will contain a rectangle polygon
      deactivated() will be emited after a right click
    """

    geometryDigitized = pyqtSignal()

    def __init__(self, iface, layer):
        QgsMapTool.__init__(self, iface.mapCanvas())
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.layer = layer
        self.rubberband = QgsRubberBand(iface.mapCanvas(), QgsWkbTypes.LineGeometry)
        self.rubberband.setColor(QColor("#ee5555"))
        self.rubberband.setWidth(2)
        self.firstPoint = None
        self.messageBarItem = None
        self.geometry = None

    def activate(self):
        """
        Map tool is activated
        """
        QgsMapTool.activate(self)
        self.canvas.setCursor(QCursor(Qt.CrossCursor))
        msgtitle = self.tr("Digitizing Drainage Channel")
        msg = self.tr("Digitize start and end point. Rightclick to abort.")
        self.messageBarItem = QgsMessageBar.createMessage(msgtitle, msg)
        self.iface.messageBar().pushItem(self.messageBarItem)

    def deactivate(self):
        """
        Map tool is deactivated
        """
        QgsMapTool.deactivate(self)
        self.iface.messageBar().popWidget(self.messageBarItem)
        try:
            self.iface.mapCanvas().scene().removeItem(self.rubberband)
            del self.rubberband
        except AttributeError:
            # Called repeatedly... bail out
            pass
        self.canvas.unsetCursor()

    def canvasMoveEvent(self, event):
        """
        Mouse is moved: Update rubberband
        :param event: coordinates etc.
        """
        mousepos = event.mapPoint()
        self.rubberband.movePoint(mousepos)

    def canvasReleaseEvent(self, event):
        """
        Canvas is released. This means:
          * start digitizing
          * stop digitizing (create a rectangle
            * if the Ctrl-modifier is pressed, ask for the rectangle width
        :param event: coordinates etc.
        """
        if event.button() == Qt.RightButton:
            self.deactivate()
        else:
            mousepos = self.canvas.getCoordinateTransform().toMapCoordinates(
                event.pos().x(), event.pos().y()
            )
            self.rubberband.addPoint(mousepos)
            if self.firstPoint:  # If the first point was set before, we are doing the second one
                lp1 = self.rubberband.asGeometry().asPolyline()[0]
                lp2 = self.rubberband.asGeometry().asPolyline()[1]
                width = 0.2
                if QApplication.keyboardModifiers() & Qt.ControlModifier:
                    dlg = QDialog()
                    dlg.setLayout(QGridLayout())
                    dlg.layout().addWidget(QLabel(self.tr("Enter width")))
                    txt = QLineEdit("0.2")
                    dlg.layout().addWidget(txt)
                    bb = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
                    dlg.layout().addWidget(bb)
                    bb.accepted.connect(dlg.accept)
                    bb.rejected.connect(dlg.reject)
                    if dlg.exec_():
                        try:
                            width = float(txt.text())
                        except ValueError:
                            width = 0.2

                length = math.sqrt(math.pow(lp1.x() - lp2.x(), 2) + math.pow(lp1.y() - lp2.y(), 2))
                xd = lp2.x() - lp1.x()
                yd = lp2.y() - lp1.y()

                pt1 = QgsPointXY(lp1.x() + width * (yd / length), lp1.y() - width * (xd / length))
                pt2 = QgsPointXY(lp1.x() - width * (yd / length), lp1.y() + width * (xd / length))
                pt3 = QgsPointXY(lp2.x() - width * (yd / length), lp2.y() + width * (xd / length))
                pt4 = QgsPointXY(lp2.x() + width * (yd / length), lp2.y() - width * (xd / length))

                self.geometry = QgsGeometry.fromPolygonXY([[pt1, pt2, pt3, pt4, pt1]])

                self.geometryDigitized.emit()

            self.firstPoint = mousepos


class TwwMapToolSplitReachWithNode(QgsMapToolAdvancedDigitizing):
    """
    This is used to split a reach feature by creating a node.

    It lets you create a node and then uses this node to split the reach layer
    and add a wastewater node/strucrure


    """

    def __init__(self, iface: QgisInterface, layer, split_channels = True):
        # TwwMapToolAddFeature __init__ without rubberband
        QgsMapToolAdvancedDigitizing.__init__(self, iface.mapCanvas(), iface.cadDockWidget())
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.layer = layer
        self.split_channels=split_channels

        # see TwwMapToolAddReach __init__
        self.snapping_marker = None
        self.node_layer = layer
        self.reach_layer = TwwLayerManager.layer("vw_tww_reach")
        assert self.reach_layer is not None
        self.setAdvancedDigitizingAllowed(True)
        self.setAutoSnapEnabled(True)


        layer_snapping_configs = [
            {"layer": self.reach_layer, "mode": QgsSnappingConfig.VertexAndSegment},
        ]
        self.snapping_configs = []
        self.snapping_utils = QgsMapCanvasSnappingUtils(self.iface.mapCanvas())

        for lsc in layer_snapping_configs:
            config = QgsSnappingConfig()
            config.setMode(QgsSnappingConfig.AdvancedConfiguration)
            config.setEnabled(True)
            settings = QgsSnappingConfig.IndividualLayerSettings(
                True, lsc["mode"], 10, QgsTolerance.ProjectUnits
            )
            config.setIndividualLayerSettings(lsc["layer"], settings)
            self.snapping_configs.append(config)

        # prepare messageBarItem
        self.msgtitle = self.tr(f"Split reach with {self.node_layer.name() if self.node_layer else 'no wastewater node'}")
        msg = None
        self.messageBarItem = QgsMessageBar.createMessage(self.msgtitle, msg)

    def activate(self):
        """
        Map tool is activated
        """
        QgsMapToolAdvancedDigitizing.activate(self)
        self.canvas.setCursor(QCursor(Qt.CrossCursor))

    def deactivate(self):
        """
        Map tool is deactivated
        """
        try:
            self.iface.messageBar().popWidget(self.messageBarItem)
        except Exception:
            pass
        QgsMapToolAdvancedDigitizing.deactivate(self)
        self.canvas.unsetCursor()

    def isZoomTool(self):
        """
        This is no zoom tool
        """
        return False

    # ===========================================================================
    # Events
    # ===========================================================================

    def cadCanvasMoveEvent(self, event):
        """
        Mouse is moved: Update snap
        :param event: coordinates etc.
        """
        _, match, _ = self.snap(event)
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
            self.snapping_marker.setColor(QColor(Qt.magenta))

        if match.hasVertex():
            if match.layer():
                icon_type = QgsVertexMarker.ICON_BOX  # vertex snap
            else:
                icon_type = QgsVertexMarker.ICON_X  # intersection snap
        elif match.hasEdge():  # more robust than a simple else clause for further usage
            icon_type = QgsVertexMarker.ICON_DOUBLE_TRIANGLE
        else:  # debug only
            icon_type = QgsVertexMarker.CIRCLE
        self.snapping_marker.setIconType(icon_type)
        self.snapping_marker.setCenter(match.point())

    def cadCanvasReleaseEvent(self, event):
        if event.button() == Qt.RightButton:
            self.right_clicked()
        if event.button() == Qt.LeftButton:
            self.left_clicked(event)

    def mouse_move(self, event):
        _, match, _ = self.snap(event)
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
            self.snapping_marker.setColor(QColor(Qt.magenta))

        if match.hasVertex():
            if match.layer():
                icon_type = QgsVertexMarker.ICON_BOX  # vertex snap
            else:
                icon_type = QgsVertexMarker.ICON_X  # intersection snap
        else:
            icon_type = QgsVertexMarker.ICON_DOUBLE_TRIANGLE  # must be segment snap
        self.snapping_marker.setIconType(icon_type)
        self.snapping_marker.setCenter(match.point())

    # ===========================================================================
    # Actions
    # ===========================================================================

    def left_clicked(self, event):
        """
        When the canvas is left clicked we add a new point.
        :type event: QMouseEvent
        """
        self.finishEditing(event)

    def right_clicked(self, _):
        """
        On a right click nothing happens
        """

    def snap(self, event):
        """
        Snap to nearby points on the reach layer which may be used as connection
        points for this reach.
        :param event: The mouse event
        :return: The snapped position in map coordinates, match and snapped vertex id

        """

        for config in self.snapping_configs:
            self.snapping_utils.setConfig(config)  # only snap to reaches
            match = self.snapping_utils.snapToMap(QgsPointXY(event.originalMapPoint()))
            if match.isValid():
                if match.layer():
                    req = QgsFeatureRequest(match.featureId())
                    f = next(match.layer().getFeatures(req))
                    assert f.isValid()
                    (ok, vertex_id) = f.geometry().vertexIdFromVertexNr(match.vertexIndex())
                    assert ok

                    if match.hasVertex():
                        point = f.geometry().constGet().vertexAt(vertex_id)
                        assert isinstance(point, QgsPoint)
                        return point, match, vertex_id
                    else:
                        return QgsPoint(match.point()), match, None

                    if match.hasEdge():
                        point = match.interpolatedPoint(match.layer().sourceCrs())
                        assert isinstance(point, QgsPoint)
                        return point, match, vertex_id
                    else:
                        return QgsPoint(match.point()), match, None

            return QgsPoint(event.originalMapPoint()), match, None

    def finishEditing(self, event):
        # snap
        point3d, match, vertex_id = self.snap(event)
        if self.snapping_marker is not None:
            self.iface.mapCanvas().scene().removeItem(self.snapping_marker)
            self.snapping_marker = None
        
        # create point feature
        if self.point_layer:
            fields = self.node_layer.fields()
            f = QgsFeature(fields)
            for idx, _ in enumerate(fields):
                v = self.node_layer.defaultValue(idx, f)
                if v != NULL:
                    f.setAttribute(idx, v)
                else:
                    f.setAttribute(idx, self.reach_layer.dataProvider().defaultValue(idx))
            # alter geometry and bottom level
            f.setGeometry(point3d)
            if self.node_layer.id() == "vw_tww_wastewater_structure":
                prefix = "wn_"
            else:
                prefix = ""
            lvl_field = fields.indexFromName(f"{prefix}bottom_level")
            if point3d.z() == point3d.z():  # check for nan
                f.setAttribute(lvl_field, point3d.z())
            dlg = self.iface.getFeatureForm(self.node_layer, f)
            dlg.setMode(QgsAttributeEditorContext.AddFeatureMode)
            dlg.exec_()
            oid_idx = self.node_layer.fields().indexFromName(f"{prefix}obj_id")
            if dlg.feature().attributes()[lvl_field]:
                point3d.setZ(
                    dlg.feature().attributes()[lvl_field]
                )  # update if level was altered in dlg
            pt_oid = dlg.feature().attributes()[oid_idx]

        # split reach
        req = QgsFeatureRequest(match.featureId())
        f_old = next(match.layer().getFeatures(req))
        assert f_old.isValid()

        """
        Backup plan:
        split_line[QgsPoint(point3d.setX(point3d.x()+.00001),
            ,QgsPoint(point3d.setX(point3d.x()-.00001)
            ]
        """

        # split using Point instead of PointXY is documented but fails with 3.28.11
        try:
            split_line = [point3d,point3d]
            result, new_geometries, _ = f_old.geometry().splitGeometry(split_line, True, True)
        except:
            split_line = [QgsPointXY(point3d),QgsPointXY(point3d)]
            result, new_geometries, _ = f_old.geometry().splitGeometry(split_line, True, True)
        finally:
            assert len(new_geometries) = 2 
            re_oid_field=self.reach_layer.fields().indexFromName("obj_id")
            re_oid_to = self.reach_layer.dataProvider().defaultValue(re_oid_field)
            re_oid_from = self.reach_layer.dataProvider().defaultValue(re_oid_field)
            for geoms in new_geometries:
                assert geoms
                fields = self.reach_layer.fields()
                if point3d.equals(geoms.vertexAt(0)):
                    dest = "from"
                else:
                    dest="to"

                f = QgsFeature(fields)
                if self.split_channels:
                    keep_fields = [
                        "ws_status",
                        "ws_year_of_construction",
                        "ws_fk_owner",
                        "ws_fk_operator",
                        "ch_usage_current",
                        "ch_function_hierarchic",
                        "ch_function_hydraulic",
                    ]
                else:
                    # keep all wastewater structure and channel fields
                    keep_fields = [field for field in fields if field[0:2] in ["ch", "ws"]]
                # now add the other fields you always want to keep
                keep_fields.extend(
                    [
                        "clear_height",
                        "material",
                        "horizontal_positioning",
                        "inside_coating",
                        "fk_pipe_profile",
                        "remark",
                        "rp_from_obj_id",
                        "rp_to_obj_id",
                    ]
                )
                keep_fields.remove(f"rp_{dest}_obj_id")
                for idx, field in enumerate(fields):
                    if field in keep_fields:
                        f.setAttribute(idx, f_old.attributes()[idx])
                    elif field = re_oid_field:
                        if dest = "from":
                            f.setAttribute(idx,re_oid_from)
                        else:
                            f.setAttribute(idx,re_oid_to)
                    else:
                        # try client side default value first
                        v = self.reach_layer.defaultValue(idx, f)
                        if v != NULL:
                            f.setAttribute(idx, v)
                        else:
                            f.setAttribute(idx, self.reach_layer.dataProvider().defaultValue(idx))

                f.setGeometry(geoms)
                ne = self.reach_layer.fields().indexFromName(
                    f"rp_{dest}_fk_wastewater_networkelement"
                )
                if self.point_layer:
                    f.setAttribute(ne, pt_oid)
                else:
                    if dest = "from":
                        f.setAttribute(ne,re_oid_to)
                    else:
                        f.setAttribute(ne,re_oid_from)
                        
                lvl = self.reach_layer.fields().indexFromName(f"rp_{dest}_level")
                f.setAttribute(lvl, point3d.z())
                ne = self.reach_layer.fields().indexFromName(
                    f"rp_{dest}_fk_wastewater_networkelement"
                )
                self.reach_layer.dataProvider().addFeatures([f])

            self.reach_layer.deleteFeature(f_old.id())
