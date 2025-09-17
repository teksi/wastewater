# -----------------------------------------------------------
#
# TEKSI Wastewater
#
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

"""
This module implements several map tools for TWW
"""

import logging

from qgis.core import (
    Qgis,
    QgsFeature,
    QgsFeatureRequest,
    QgsGeometry,
    QgsPointLocator,
    QgsPointXY,
    QgsSnappingConfig,
    QgsTolerance,
    QgsWkbTypes,
)
from qgis.gui import (
    QgisInterface,
    QgsMapCanvasSnappingUtils,
    QgsMapTool,
    QgsRubberBand,
    QgsVertexMarker,
)
from qgis.PyQt.QtCore import QCoreApplication, QSettings, Qt, pyqtSignal
from qgis.PyQt.QtGui import QColor, QCursor
from qgis.PyQt.QtWidgets import (
    QAction,
    QApplication,
    QCheckBox,
    QDialog,
    QDialogButtonBox,
    QFormLayout,
    QMenu,
)

from ..utils.twwlayermanager import TwwLayerManager
from .twwnetwork import TwwGraphManager
from .twwprofile import (
    TwwProfile,
    TwwProfileNodeElement,
    TwwProfileReachElement,
    TwwProfileSpecialStructureElement,
)


class CounterMatchFilter(QgsPointLocator.MatchFilter):
    def __init__(self):
        super().__init__()
        self.matches = list()

    def acceptMatch(self, match):
        self.matches.append(match)
        return True


class TwwMapTool(QgsMapTool):
    """
    Base class for all the map tools
    """

    highlightedPoints = []
    logger = logging.getLogger(__name__)
    snapper = None

    def __init__(self, iface: QgisInterface, button, network_analyzer: TwwGraphManager = None):
        QgsMapTool.__init__(self, iface.mapCanvas())
        self.canvas = iface.mapCanvas()
        self.cursor = QCursor(Qt.CrossCursor)
        self.button = button
        self.msgBar = iface.messageBar()
        self.network_analyzer = network_analyzer

        settings = QSettings()
        current_profile_color = settings.value("/TWW/CurrentProfileColor", "#FF9500")

        self.rubberBand = QgsRubberBand(self.canvas)
        self.rubberBand.setColor(QColor(current_profile_color))
        self.rubberBand.setWidth(3)

    def activate(self):
        """
        Gets called when the tool is activated
        """
        QgsMapTool.activate(self)
        self.canvas.setCursor(self.cursor)
        self.button.setChecked(True)

    def deactivate(self):
        """
        Gets called whenever the tool is deactivated directly or indirectly
        """
        QgsMapTool.deactivate(self)
        self.button.setChecked(False)

    # pylint: disable=no-self-use
    def isZoomTool(self):
        """
        Will return if this is a zoom tool
        """
        return False

    def setCursor(self, cursor):
        """
        Set the cursor for this maptool
        """
        self.cursor = QCursor(cursor)

    # ===========================================================================
    # Events
    # ===========================================================================

    def canvasReleaseEvent(self, event):
        """
        Issues rightClicked and leftClicked events
        """
        if event.button() == Qt.RightButton:
            self.rightClicked(event)
        else:
            self.leftClicked(event)

    def canvasDoubleClickEvent(self, event):
        """
        Forwards to doubleClicked
        """
        try:
            self.doubleClicked(event)
        except AttributeError:
            pass

    # ===========================================================================
    # Snapping
    # ===========================================================================
    def init_snapper(self):
        """
        Initialize snapper
        """
        if not self.snapper:
            self.node_layer = self.network_analyzer.getNodeLayer()
            self.snapper = QgsMapCanvasSnappingUtils(self.canvas)
            config = QgsSnappingConfig()
            config.setMode(QgsSnappingConfig.AdvancedConfiguration)
            config.setEnabled(True)
            ils = QgsSnappingConfig.IndividualLayerSettings(
                True, QgsSnappingConfig.VertexAndSegment, 16, QgsTolerance.Pixels
            )
            config.setIndividualLayerSettings(self.node_layer, ils)
            self.snapper.setConfig(config)

    def snap_point(self, event, show_menu: bool = True) -> QgsPointLocator.Match:
        """
        Snap to a point on this network
        :param event: A QMouseEvent
        :param show_menu: determines if a menu shall be shown on a map if several matches are available
        """
        clicked_point = event.pos()

        if not self.snapper:
            self.init_snapper()

        match_filter = CounterMatchFilter()
        match = self.snapper.snapToMap(clicked_point, match_filter)

        if not match.isValid() or len(match_filter.matches) == 1:
            return match
        elif len(match_filter.matches) > 1:
            matches_by_id = {match.featureId(): match for match in match_filter.matches}
            node_features = self.network_analyzer.getFeaturesById(
                self.network_analyzer.getNodeLayer(), list(matches_by_id.keys())
            )

            # Filter wastewater nodes
            filtered_features = {
                fid: node_features.featureById(fid)
                for fid in node_features.asDict()
                if node_features.attrAsUnicode(node_features.featureById(fid), "type")
                == "wastewater_node"
            }

            # Only one wastewater node left: return this
            if len(filtered_features) == 1:
                matches = (
                    match
                    for match in match_filter.matches
                    if match.featureId() == next(iter(filtered_features.keys()))
                )
                return next(matches)

            # Still not sure which point to take?
            # Are there no wastewater nodes filtered? Let the user choose from the reach points
            if not filtered_features:
                filtered_features = node_features.asDict()

            # Ask the user which point he wants to use
            if not show_menu:
                return QgsPointLocator.Match()

            actions = dict()

            menu = QMenu(self.canvas)

            for fid, feature in filtered_features.items():
                try:
                    title = (
                        feature.attribute("description") + " (" + feature.attribute("obj_id") + ")"
                    )
                except TypeError:
                    title = " (" + feature.attribute("obj_id") + ")"
                actions[QAction(title, menu)] = matches_by_id[fid]

            for action in sorted(actions.keys(), key=lambda o: o.text()):
                menu.addAction(action)

            clicked_action = menu.exec_(self.canvas.mapToGlobal(event.pos()))

            if clicked_action is not None:
                return actions[clicked_action]

            return QgsPointLocator.Match()


class TwwProfileMapTool(TwwMapTool):
    """
    The map tool used for PROFILE

    Allows to find the shortest path between several nodes.
    """

    profileChanged = pyqtSignal(object)
    profile = TwwProfile()
    segmentOffset = 0

    selectedPathPoints = []
    pathPolyline = []

    def __init__(self, canvas, button, network_analyzer):
        TwwMapTool.__init__(self, canvas, button, network_analyzer)
        settings = QSettings()

        helper_line_color = settings.value("/TWW/HelperLineColor", "#FFD900")
        highlight_color = settings.value("/TWW/HighlightColor", "#40FF40")

        # Init rubberband to visualize current status
        self.rbHelperLine = QgsRubberBand(self.canvas)
        self.rbHelperLine.setColor(QColor(helper_line_color))
        self.rbHelperLine.setWidth(2)

        self.rbHighlight = QgsRubberBand(self.canvas)
        self.rbHighlight.setColor(QColor(highlight_color))
        self.rbHighlight.setWidth(5)

        self.profile.setRubberband(self.rbHighlight)

        self.saveTool = None

    def setActive(self):
        """
        activates this map tool
        """
        self.saveTool = self.canvas.mapTool()
        self.canvas.setMapTool(self)

    def deactivate(self):
        """
        Called whenever this map tool is deactivated.
        Used to clean up code
        """
        TwwMapTool.deactivate(self)
        self.rubberBand.reset()
        self.rbHelperLine.reset()
        self.selectedPathPoints = []
        self.pathPolyline = []

    def findPath(self, start_point, end_point):
        """
        Tries to find the shortest path between pStart and pEnd.
        If it finds a path:
         * The path is visualized with a QgsRubberband
         * The profile plot is updated to represent the current path

        @param start_point: The id of the start point of the path
        @param end_point:   The id of the end point of the path
        """
        QApplication.setOverrideCursor(Qt.WaitCursor)
        # try:
        (vertices, edges) = self.network_analyzer.shortestPath(start_point, end_point)
        self.appendProfile(vertices, edges)
        #        except:
        #            pass
        QApplication.restoreOverrideCursor()
        if len(vertices) > 0:
            return True
        else:
            return False

    # pylint: disable=too-many-locals
    def appendProfile(self, vertices, edges):
        """
        Appends to the current profile

        @param vertices: A collection of vertices to append
        @param edges:    A collection of edges which connect the vertices
        """
        self.logger.debug("Append profile")
        self.logger.info(" * " + repr(len(vertices)) + " vertices")
        for v in vertices:
            self.logger.debug("   *" + repr(v))
        self.logger.info(" * " + repr(len(edges)) + " edges")
        for e in edges:
            self.logger.debug("   *" + repr(e))

        # Fetch all the needed edges in one batch
        edge_layer = self.network_analyzer.getEdgeLayer()
        edge_ids = [edge["feature"] for p1, p2, edge in edges]

        edge_features = self.network_analyzer.getFeaturesById(edge_layer, edge_ids)

        # We need some additional nodes, where we need to interpolate...
        interpolate_nodes_from = [
            edge_features.attrAsUnicode(feat, "from_obj_id_interpolate")
            for feat in list(edge_features.asDict().values())
        ]
        interpolate_nodes_to = [
            edge_features.attrAsUnicode(feat, "to_obj_id_interpolate")
            for feat in list(edge_features.asDict().values())
        ]
        additional_ids = [self.network_analyzer.vertexIds[node] for node in interpolate_nodes_from]
        additional_ids += [self.network_analyzer.vertexIds[node] for node in interpolate_nodes_to]

        # Now, fetch the nodes we need
        node_layer = self.network_analyzer.getNodeLayer()
        node_ids = vertices + additional_ids
        node_features = self.network_analyzer.getFeaturesById(node_layer, node_ids)

        if len(vertices) > 1:
            self.rubberBand.reset()

            elem = TwwProfileNodeElement(vertices[0], node_features, self.segmentOffset)
            self.profile.addElement(vertices[0], elem)

            for p1, p2, edge in edges:
                from_offset = self.segmentOffset
                to_offset = self.segmentOffset + edge["weight"]

                if "reach" == edge["objType"]:
                    if self.profile.hasElement(edge["baseFeature"]):
                        self.profile[edge["baseFeature"]].addSegment(
                            p1,
                            p2,
                            edge["feature"],
                            node_features,
                            edge_features,
                            from_offset,
                            to_offset,
                        )
                    else:
                        elem = TwwProfileReachElement(
                            p1,
                            p2,
                            edge["feature"],
                            node_features,
                            edge_features,
                            from_offset,
                            to_offset,
                        )
                        self.profile.addElement(elem.obj_id, elem)

                elif "special_structure" == edge["objType"]:
                    if self.profile.hasElement(edge["baseFeature"]):
                        self.profile[edge["baseFeature"]].addSegment(
                            p1,
                            p2,
                            edge["feature"],
                            node_features,
                            edge_features,
                            from_offset,
                            to_offset,
                        )
                    else:
                        elem = TwwProfileSpecialStructureElement(
                            p1,
                            p2,
                            edge["feature"],
                            node_features,
                            edge_features,
                            from_offset,
                            to_offset,
                        )
                        self.profile.addElement(elem.obj_id, elem)

                elem = TwwProfileNodeElement(p2, node_features, to_offset)
                self.profile.addElement(p2, elem)

                self.segmentOffset = to_offset

            # Create rubberband geometry
            for feat_id in edge_ids:
                self.pathPolyline.extend(edge_features[feat_id].geometry().asPolyline())

            self.rubberBand.addGeometry(QgsGeometry.fromPolylineXY(self.pathPolyline), node_layer)
            self.profileChanged.emit(self.profile)
            return True
        else:
            return False

    def canvasMoveEvent(self, event):
        """
        Mouse moved: update helper line

        @param event: The mouse event with coordinates and all
        """
        if self.selectedPathPoints:
            self.rbHelperLine.reset()
            for point in self.selectedPathPoints:
                self.rbHelperLine.addPoint(point[1])
            mouse_pos = self.canvas.getCoordinateTransform().toMapCoordinates(
                event.pos().x(), event.pos().y()
            )
            self.rbHelperLine.addPoint(mouse_pos)

    def rightClicked(self, _):
        """
        Cancel any ongoing path selection

        @param event: The mouse event with coordinates and all
        """
        self.selectedPathPoints = []
        self.pathPolyline = []
        self.rbHelperLine.reset()
        self.profile.reset()
        self.segmentOffset = 0

    def leftClicked(self, event):
        """
        Select startpoint / intermediate point / endpoint

        @param event: The mouse event with coordinates and all
        """
        match = self.snap_point(event)

        if match.isValid():
            if self.selectedPathPoints:
                pf = self.findPath(self.selectedPathPoints[-1][0], match.featureId())
                if pf:
                    self.selectedPathPoints.append((match.featureId(), QgsPointXY(match.point())))
                else:
                    msg = self.msgBar.createMessage("No path found")
                    self.msgBar.pushWidget(msg, Qgis.Info)
            else:
                self.selectedPathPoints.append((match.featureId(), QgsPointXY(match.point())))


class TwwTreeMapTool(TwwMapTool):
    """
    The map tool used to find TREES (upstream or downstream)
    """

    treeChanged = pyqtSignal(list, list)

    def __init__(self, canvas, button, network_analyzer):
        TwwMapTool.__init__(self, canvas, button, network_analyzer)

        self.direction = "downstream"
        self.saveTool = None

    def setDirection(self, direction):
        """
        Set the direction to track the graph.
        :param direction:  Can be 'upstream' or 'downstream'
        """
        self.direction = direction

    def getTree(self, node_id: str):
        """
        Does the work. Tracks the graph up- or downstream.
        :param node_id: The node from which the tracking should be started
        """
        QApplication.setOverrideCursor(Qt.WaitCursor)
        upstream = self.direction == "upstream"

        self.rubberBand.reset()

        nodes, edges = self.network_analyzer.getTree(node_id, upstream)
        polylines = self.network_analyzer.getEdgeGeometry([edge[2]["feature"] for edge in edges])

        # Fix for QGIS < 2.0
        filtered_polylines = [pl for pl in polylines if pl]

        self.rubberBand.addGeometry(
            QgsGeometry.fromMultiPolylineXY(filtered_polylines),
            self.network_analyzer.getNodeLayer(),
        )

        self.treeChanged.emit(nodes, edges)

        QApplication.restoreOverrideCursor()

    def canvasMoveEvent(self, event):
        """
        Whenever the mouse is moved update the rubberband and the snapping.
        :param event: QMouseEvent with coordinates
        """
        match = self.snap_point(event, False)

        for marker in self.highlightedPoints:
            self.canvas.scene().removeItem(marker)

        self.highlightedPoints = []

        if match.isValid():
            marker = QgsVertexMarker(self.canvas)
            marker.setCenter(match.point())
            marker.setColor(QColor("#FFFF33"))
            marker.setIconSize(10)
            marker.setIconType(QgsVertexMarker.ICON_X)
            marker.setPenWidth(2)
            self.highlightedPoints.append(marker)

    def rightClicked(self, _):
        """
        Resets the rubberband on right clickl
        :param _: QMouseEvent
        """
        self.rubberBand.reset()

    def leftClicked(self, event):
        """
        Snaps to the network graph
        :param event: QMouseEvent
        """
        match = self.snap_point(event)

        if match.isValid():
            self.getTree(match.featureId())

    def setActive(self):
        """
        Activates this map tool
        """
        self.saveTool = self.canvas.mapTool()
        self.canvas.setMapTool(self)

    def deactivate(self):
        """
        Deactivates this map tool. Removes the rubberband etc.
        """
        TwwMapTool.deactivate(self)
        self.rubberBand.reset()

        for marker in self.highlightedPoints:
            self.canvas.scene().removeItem(marker)

        self.highlightedPoints = []


class TwwAreaSnapper(QgsMapCanvasSnappingUtils):
    def __init__(self, map_canvas):
        QgsMapCanvasSnappingUtils.__init__(self, map_canvas)
        self.filter = CounterMatchFilter()

        # This manages the priority of the snapping layers. The earlier in the list, the higher the priority.
        # Can be used to prefer points (wastewater nodes) over lines (reaches)
        self.layer_priority = list()

    def snapToMap(self, pt):
        self.filter.matches = list()
        match = QgsMapCanvasSnappingUtils.snapToMap(self, pt, self.filter)

        def sorter(match):
            layer = match.layer()
            try:
                return self.layer_priority.index(layer)
            except ValueError:
                return 0

        layer_tolerances = dict()
        for layer_config in self.layers():
            layer_tolerances[layer_config.layer] = QgsTolerance.toleranceInProjectUnits(
                layer_config.tolerance,
                layer_config.layer,
                self.mapSettings(),
                layer_config.unit,
            )

        matches = sorted(self.filter.matches, key=sorter)
        matches = [m for m in matches if m.distance() < layer_tolerances[m.layer()]]

        if matches:
            match = matches[0]
        elif self.config().mode() == QgsSnappingConfig.AdvancedConfiguration:
            for layer in self.layers():
                if layer.type & QgsPointLocator.Area:
                    loc = self.locatorForLayer(layer.layer)
                    results = loc.pointInPolygon(pt)
                    if results:
                        return results[0]

        return match


class TwwMapToolConnectNetworkElements(QgsMapTool):
    """
    This map tool connects wastewater networkelements.

    It works on two lists of layers:
      source layers with fields with a foreign key to a networkelement
      target layers which depict networkelements (reaches and network nodes)

    The tool will snap to source layers first and once one is chosen to a target layer.

    It will then ask which field(s) should be connected and perform the update on the database
    """

    def __init__(self, iface, action):
        QgsMapTool.__init__(self, iface.mapCanvas())
        self.iface = iface
        self.action = action

        self.rbline = QgsRubberBand(self.iface.mapCanvas(), QgsWkbTypes.LineGeometry)
        self.rbline.setColor(QColor("#f4530e"))
        self.rbline.setWidth(3)
        self.rbmarkers = QgsRubberBand(self.iface.mapCanvas(), QgsWkbTypes.PointGeometry)
        self.rbmarkers.setColor(QColor("#f4530e"))
        self.rbmarkers.setIconSize(6)

        self.source_snapper = TwwAreaSnapper(self.iface.mapCanvas())
        self.target_snapper = TwwAreaSnapper(self.iface.mapCanvas())

        self.source_feature = QgsFeature()
        self.rb_source_feature = QgsRubberBand(self.iface.mapCanvas())
        self.rb_source_feature.setColor(QColor("#88f49e79"))
        self.rb_source_feature.setWidth(3)
        self.target_feature = QgsFeature()
        self.rb_target_feature = QgsRubberBand(self.iface.mapCanvas())
        self.rb_target_feature.setColor(QColor("#f49e79"))
        self.rb_target_feature.setWidth(3)

    def activate(self):
        """
        Called by QGIS whenever the tool is activated.
        """

        def is_closer_to_start_of_edge(source, target):
            feature = next(source.layer().getFeatures(QgsFeatureRequest(source.featureId())))
            distance_from_start = feature.geometry().lineLocatePoint(
                QgsGeometry.fromPointXY(source.point())
            )
            length = feature.geometry().length()

            return distance_from_start < length / 2

        # A dict of layers
        #  and for each layer the fields to use as foreign key
        #  as well as the possible target layers
        # Reaches can be connected to reaches and nodes
        # Catchment areas only to nodes
        self.network_element_sources = {
            TwwLayerManager.layer("vw_tww_reach"): {
                "fields": [
                    {
                        "id": "rp_from_fk_wastewater_networkelement",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Reach Point From"
                        ),
                        "filter": lambda source, target: target.layer()
                        != TwwLayerManager.layer("vw_tww_reach"),
                        "is_checked": lambda source, target: is_closer_to_start_of_edge(
                            source, target
                        ),
                    },
                    {
                        "id": "rp_to_fk_wastewater_networkelement",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Reach Point To"
                        ),
                        "is_checked": lambda source, target: not is_closer_to_start_of_edge(
                            source, target
                        ),
                    },
                ],
                "target_layers": [
                    TwwLayerManager.layer("vw_wastewater_node"),
                    TwwLayerManager.layer("vw_tww_reach"),
                ],
            },
            TwwLayerManager.layer("vw_tww_catchment_area"): {
                "fields": [
                    {
                        "id": "fk_wastewater_networkelement_rw_current",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Rainwater current"
                        ),
                    },
                    {
                        "id": "fk_wastewater_networkelement_rw_planned",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Rainwater planned"
                        ),
                    },
                    {
                        "id": "fk_wastewater_networkelement_ww_current",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Wastewater current"
                        ),
                    },
                    {
                        "id": "fk_wastewater_networkelement_ww_planned",
                        "name": QCoreApplication.translate(
                            "TwwMapToolConnectNetworkElements", "Wastewater planned"
                        ),
                    },
                ],
                "target_layers": [TwwLayerManager.layer("vw_wastewater_node")],
            },
        }

        self.setSnapLayers(self.source_snapper, list(self.network_element_sources.keys()))

        self.reset()

        self.action.setChecked(True)

        self.iface.mapCanvas().setCursor(QCursor(Qt.CrossCursor))

    def setSnapLayers(self, snapper, layers):
        config = QgsSnappingConfig()
        config.setMode(QgsSnappingConfig.AdvancedConfiguration)
        config.setEnabled(True)

        for layer in layers:
            if layer:
                ils = QgsSnappingConfig.IndividualLayerSettings(
                    True, QgsSnappingConfig.VertexAndSegment, 16, QgsTolerance.Pixels
                )
                config.setIndividualLayerSettings(layer, ils)

                layer.destroyed.connect(self.deactivate)

        snapper.setConfig(config)
        snapper.layer_priority = layers

    def canvasMoveEvent(self, event):
        """
        When the mouse moves, update the rubberbands.
        """
        pt = event.originalMapPoint()
        snap_match = self.snapper.snapToMap(pt)

        if snap_match.isValid():
            if snap_match.type() != QgsPointLocator.Area:
                pt = snap_match.point()
            self.matchpoint = pt

            if self.source_match:
                # There is already a source feature : snap to target feature
                # candidates
                if self.target_feature.id() != snap_match.featureId():
                    self.target_feature = self.get_feature_for_match(snap_match)
                    self.rb_target_feature.setToGeometry(
                        self.target_feature.geometry(), snap_match.layer()
                    )
                self.rb_target_feature.show()
                self.rbmarkers.movePoint(pt)
            else:
                # Snapped to source feature, update source feature rubber band
                # and target layer snapper
                if self.source_feature.id() != snap_match.featureId():
                    self.source_feature = self.get_feature_for_match(snap_match)
                    self.rb_source_feature.setToGeometry(
                        self.source_feature.geometry(), snap_match.layer()
                    )
                    self.setSnapLayers(
                        self.target_snapper,
                        self.network_element_sources[snap_match.layer()]["target_layers"],
                    )
                self.rb_source_feature.show()
                self.rbmarkers.movePoint(pt, 0)
            self.rbmarkers.show()
        else:
            self.rbmarkers.hide()
            if self.source_match:
                self.rb_target_feature.hide()
            else:
                self.rb_source_feature.hide()

        self.rbline.movePoint(pt)

        self.snapresult = snap_match

    def canvasReleaseEvent(self, event):
        """
        On a click update the rubberbands and the snapping results if it's a left click. Reset if it's a right click.
        """
        if event.button() == Qt.LeftButton:
            if self.snapresult.isValid():
                if self.source_match:
                    self.connect_features(self.source_match, self.snapresult)
                else:
                    self.rbline.show()
                    self.rbline.addPoint(self.matchpoint)
                    self.source_match = self.snapresult
                    self.snapper = self.target_snapper
        else:
            self.reset()

    def deactivate(self):
        """
        Called by QGIS whenever this tool is deactivated.
        """
        self.reset()
        self.action.setChecked(False)

    def reset(self):
        """
        Resets the tool to a pristine state
        """
        self.source_match = None
        self.rbline.hide()
        self.rbline.reset()
        self.rbmarkers.hide()
        self.rbmarkers.reset(QgsWkbTypes.PointGeometry)
        self.rbmarkers.addPoint(QgsPointXY())
        self.snapresult = None
        self.source_match = None
        self.snapper = self.source_snapper
        self.source_feature = QgsFeature()
        self.target_feature = QgsFeature()
        self.rb_source_feature.reset()
        self.rb_target_feature.reset()

    def get_feature_for_match(self, match):
        """
        Get the feature for a snapping result
        @param match: The QgsPointLocator.SnapMatch object
        @return: A feature
        """
        return next(match.layer().getFeatures(QgsFeatureRequest().setFilterFid(match.featureId())))

    def connect_features(self, source, target):
        """
        Connects the source feature with the target feature.

        @param source: A QgsPointLocator.Match object. Its foreign key will be updated.
                       A dialog will be opened which asks the user for which foreign key(s) he wants to update.
        @param target: A QgsPointLocator.Match object. This feature will be used as link target.
                       Its obj_id attribute will be used as primary key.
        """
        dlg = QDialog(self.iface.mainWindow())
        dlg.setWindowTitle(self.tr("Select properties to connect"))
        dlg.setLayout(QFormLayout())

        properties = list()

        for prop in self.network_element_sources[source.layer()]["fields"]:
            if "filter" in prop.keys():
                if not prop["filter"](source, target):
                    continue
            cbx = QCheckBox(prop["name"])
            cbx.setObjectName(prop["id"])

            if "is_checked" in prop.keys():
                cbx.setChecked(prop["is_checked"](source, target))
            properties.append(cbx)
            dlg.layout().addWidget(cbx)

        btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        dlg.layout().addWidget(btn_box)
        btn_box.accepted.connect(dlg.accept)
        btn_box.rejected.connect(dlg.reject)

        source_feature = self.get_feature_for_match(source)
        target_feature = self.get_feature_for_match(target)

        if dlg.exec_():
            for cbx in properties:
                if cbx.isChecked():
                    source_feature[cbx.objectName()] = target_feature["obj_id"]
            if not source.layer().isEditable():
                self.iface.messageBar().pushMessage(
                    "TWW",
                    self.tr('Layer "{layername}" is not in edit mode').format(
                        layername=source.layer().name()
                    ),
                    Qgis.Warning,
                    5,
                )
            elif source.layer().updateFeature(source_feature):
                self.iface.messageBar().pushMessage(
                    "TWW",
                    self.tr("Connected {} to {}").format(
                        source_feature["identifier"], target_feature["identifier"]
                    ),
                    Qgis.Info,
                    5,
                )
            else:
                self.iface.messageBar().pushMessage(
                    "TWW", self.tr("Error connecting features"), Qgis.Warning, 5
                )

        self.reset()
