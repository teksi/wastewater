# -----------------------------------------------------------
#
# Profile
# Copyright (C) 2024  TEKSI
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

"""
This module provides functions to split TWW reaches.
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

        # split using Point instead of PointXY is documented but fails with 3.28.11
        try:
            split_line = [point3d,point3d]
            result, new_geometries, _ = f_old.geometry().splitGeometry(split_line, True, True)
        except:
            split_line = [QgsPointXY(point3d),QgsPointXY(point3d)]
            result, new_geometries, _ = f_old.geometry().splitGeometry(split_line, True, True)
        finally:
            assert len(new_geometries) == 2
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
                    elif field == re_oid_field:
                        if dest == "from":
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
