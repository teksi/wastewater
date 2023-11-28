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

"""
This module provides objects which manage a QGEP profile.
"""

import json
from builtins import object


class QgepProfileElement(object):
    """
    Base class for all profile elements
    """

    feat = None

    def __init__(self, element_type):
        self.type = element_type

    def asDict(self):
        """
        Returns this element as a dict.
        """
        return {"type": self.type}

    def feature(self):
        """
        Return the feature which is managed by this element
        """
        return self.feat

    def highlight(self, rubberband):
        """
        Override this method and update the rubberband so it will represent
        the feature which this element represents
        """


class QgepProfileEdgeElement(QgepProfileElement):
    """
    Define the base attributes for all edge elements (reaches and special structures)
    """

    obj_id = None
    gid = None
    blind_connections = None

    def __init__(
        self,
        from_point_id,
        to_point_oid,
        edge_id,
        node_cache,
        edge_cache,
        start_offset,
        end_offset,
        elem_type,
    ):
        QgepProfileElement.__init__(self, elem_type)
        self.reachPoints = {}

        edge = edge_cache.featureById(edge_id)

        # Read the identifiers
        self.obj_id = edge_cache.attrAsUnicode(edge, "obj_id")
        self.gid = edge.id()

        self.addSegment(
            from_point_id,
            to_point_oid,
            edge_id,
            node_cache,
            edge_cache,
            start_offset,
            end_offset,
        )

    def addSegment(
        self,
        from_point_id,
        to_point_id,
        edge_id,
        node_cache,
        edge_cache,
        start_offset,
        end_offset,
    ):
        """
        Adds a segment to the profile

        :param from_point_id: The id of the from node of this edge
        :param to_point_id:   The id of the to node of this edge
        :param edge_id:      The id of this edge
        :param node_cache:   A reference to the cache where the nodes are cached
        :param edge_cache:   A reference to the cache where the edges are cached
        :param start_offset: The offset of the start node relative to the start of the profile
        :param end_offset:   The offset of the end node relative to the start of the profile
        """
        from_point = node_cache.featureById(from_point_id)
        to_point = node_cache.featureById(to_point_id)
        edge = edge_cache.featureById(edge_id)

        if from_point_id not in self.reachPoints:
            self.reachPoints[from_point_id] = {}
        if to_point_id not in self.reachPoints:
            self.reachPoints[to_point_id] = {}

        from_pos = edge_cache.attrAsFloat(edge, "from_pos")
        to_pos = edge_cache.attrAsFloat(edge, "to_pos")

        interpolate_from_obj_id = edge_cache.attrAsUnicode(
            edge, "from_obj_id_interpolate"
        )
        interpolate_to_obj_id = edge_cache.attrAsUnicode(edge, "to_obj_id_interpolate")
        interpolate_from = node_cache.featureByObjId(interpolate_from_obj_id)
        interpolate_to = node_cache.featureByObjId(interpolate_to_obj_id)
        interpolate_from_level = node_cache.attrAsFloat(interpolate_from, "level")
        interpolate_to_level = node_cache.attrAsFloat(interpolate_to, "level")

        if from_pos == 0 and to_pos == 1:
            fromlevel = node_cache.attrAsFloat(from_point, "level")
            tolevel = node_cache.attrAsFloat(to_point, "level")
        else:
            try:
                fromlevel = interpolate_from_level + (
                    from_pos * (interpolate_to_level - interpolate_from_level)
                )
            except TypeError:
                fromlevel = None
            try:
                tolevel = interpolate_from_level + (
                    to_pos * (interpolate_to_level - interpolate_from_level)
                )
            except TypeError:
                tolevel = None

        self.fromLevel = interpolate_from_level
        self.toLevel = interpolate_to_level

        self.reachPoints[from_point_id]["offset"] = start_offset
        self.reachPoints[from_point_id]["level"] = fromlevel
        self.reachPoints[from_point_id]["pos"] = from_pos
        self.reachPoints[from_point_id]["objId"] = node_cache.attrAsUnicode(
            from_point, "obj_id"
        )

        self.reachPoints[to_point_id]["offset"] = end_offset
        self.reachPoints[to_point_id]["level"] = tolevel
        self.reachPoints[to_point_id]["pos"] = to_pos
        self.reachPoints[to_point_id]["objId"] = node_cache.attrAsUnicode(
            to_point, "obj_id"
        )

    def asDict(self):
        """
        Returns this element as a dict.
        """
        reach_points = sorted(
            list(self.reachPoints.values()), key=lambda p: p["offset"]
        )
        startoffset = min([p["offset"] for p in reach_points])
        endoffset = max([p["offset"] for p in reach_points])
        fromlevel = reach_points[0]["level"] or 0
        tolevel = reach_points[-1]["level"] or fromlevel

        el = QgepProfileElement.asDict(self)
        el.update(
            {
                "startOffset": startoffset,
                "endOffset": endoffset,
                "startLevel": fromlevel,
                "endLevel": tolevel,
                "globStartLevel": self.fromLevel,
                "globEndLevel": self.toLevel,
                "objId": self.obj_id,
                "gid": self.gid,
                "reachPoints": list(self.reachPoints.values()),
            }
        )
        return el


class QgepProfileReachElement(QgepProfileEdgeElement):
    """
    Define the profile for the REACH element
    """

    usageCurrent = None
    width = None
    length = None
    gradient = None
    detail_geometry = None
    material = None

    def __init__(
        self,
        from_point_id,
        to_point_id,
        reach_id,
        node_cache,
        edge_cache,
        start_offset,
        end_offset,
    ):
        """
        :param from_point_id: The id of the from node of this edge
        :param to_point_id:   The id of the to node of this edge
        :param edgeId:      The id of this edge
        :param node_cache:   A reference to the cache where the nodes are cached
        :param edge_cache:   A reference to the cache where the edges are cached
        :param start_offset: The offset of the start node relative to the start of the profile
        :param end_offset:   The offset of the end node relative to the start of the profile
        """
        QgepProfileEdgeElement.__init__(
            self,
            from_point_id,
            to_point_id,
            reach_id,
            node_cache,
            edge_cache,
            start_offset,
            end_offset,
            "reach",
        )
        reach = edge_cache.featureById(reach_id)
        self.feat = reach

        try:
            self.width = edge_cache.attrAsFloat(reach, "clear_height") / 1000.0
        except TypeError:
            pass

        self.usageCurrent = edge_cache.attrAsFloat(reach, "usage_current")
        self.material = edge_cache.attrAsUnicode(reach, "material")
        self.length = edge_cache.attrAsFloat(reach, "length_full")

        self.detail_geometry = edge_cache.attrAsGeometry(reach, "detail_geometry")

        # The levels can be unset (None). Catch it
        try:
            self.gradient = (self.fromLevel - self.toLevel) / self.length
        except TypeError:
            pass

    def asDict(self):
        """
        Returns this element as a dict.
        """
        el = QgepProfileEdgeElement.asDict(self)

        # Global length: whole reach
        el.update(
            {
                "usageCurrent": self.usageCurrent,
                "width_m": self.width,
                "gradient": self.gradient,
                "length": self.length,
                "material": self.material,
            }
        )
        return el

    def highlight(self, rubberband):
        """
        Highlights this element
        """
        rubberband.setToGeometry(self.detail_geometry, None)


class QgepProfileSpecialStructureElement(QgepProfileEdgeElement):
    """
    The profile element for STRUCTURE elements.
    It's also responsible for manholes, as there is no particular
    reason to distinguish these here.
    """

    bottom_level = None
    cover_level = None
    description = None
    ww_node_offset = None
    detailGeometry = None
    type = None

    def __init__(
        self,
        from_point_id,
        to_point_id,
        edge_id,
        node_cache,
        edge_cache,
        start_offset,
        end_offset,
    ):
        QgepProfileEdgeElement.__init__(
            self,
            from_point_id,
            to_point_id,
            edge_id,
            node_cache,
            edge_cache,
            start_offset,
            end_offset,
            "special_structure",
        )
        special_structure = edge_cache.featureById(edge_id)
        self.feat = special_structure

        self.addSegment(
            from_point_id,
            to_point_id,
            edge_id,
            node_cache,
            edge_cache,
            start_offset,
            end_offset,
        )

    def addSegment(
        self,
        from_point_id,
        to_point_id,
        edge_id,
        node_cache,
        edge_cache,
        start_offset,
        end_offset,
    ):
        """
        Adds a segment to the special structure. There are normally two parts:
        From the start to the wastewater node and from there to the end

        :param from_point_id: The id of the from node of this edge
        :param to_point_id:   The id of the to node of this edge
        :param edge_id:      The id of this edge
        :param node_cache:   A reference to the cache where the nodes are cached
        :param edge_cache:   A reference to the cache where the edges are cached
        :param start_offset: The offset of the start node relative to the start of the profile
        :param end_offset:   The offset of the end node relative to the start of the profile
        """
        QgepProfileEdgeElement.addSegment(
            self,
            from_point_id,
            to_point_id,
            edge_id,
            node_cache,
            edge_cache,
            start_offset,
            end_offset,
        )
        from_point = node_cache.featureById(from_point_id)
        to_point = node_cache.featureById(to_point_id)
        specialstructure = edge_cache.featureById(edge_id)

        self.bottom_level = edge_cache.attrAsFloat(specialstructure, "bottom_level")

        defining_wastewater_node = None

        if "wastewater_node" == node_cache.attrAsUnicode(from_point, "type"):
            defining_wastewater_node = from_point
            self.ww_node_offset = start_offset
        elif "wastewater_node" == node_cache.attrAsUnicode(to_point, "type"):
            defining_wastewater_node = to_point
            self.ww_node_offset = end_offset

        # There should always be a wastewater node but checking does not hurt
        if defining_wastewater_node is not None:
            self.node_type = node_cache.attrAsUnicode(
                defining_wastewater_node, "node_type"
            )
            self.cover_level = node_cache.attrAsFloat(
                defining_wastewater_node, "cover_level"
            )
            self.description = node_cache.attrAsUnicode(
                defining_wastewater_node, "description"
            )
            self.usage_current = node_cache.attrAsFloat(
                defining_wastewater_node, "usage_current"
            )
            self.detailGeometry = node_cache.attrAsGeometry(
                defining_wastewater_node, "detail_geometry"
            )

    def highlight(self, rubberband):
        """
        Highlights this element
        """
        rubberband.setToGeometry(self.detailGeometry, None)

    def asDict(self):
        el = QgepProfileEdgeElement.asDict(self)
        el.update(
            {
                "bottomLevel": self.bottom_level,
                "description": self.description,
                "coverLevel": self.cover_level,
                "usageCurrent": self.usage_current,
                "wwNodeOffset": self.ww_node_offset,
                "nodeType": self.node_type,
            }
        )
        return el


class QgepProfileNodeElement(QgepProfileElement):
    """
    A node (wastewater node or reach point)
    """

    cover_level = None
    offset = None

    def __init__(self, point_id, node_cache, offset):
        QgepProfileElement.__init__(self, "node")

        point = node_cache.featureById(point_id)

        self.offset = offset
        self.cover_level = node_cache.attrAsFloat(point, "cover_level")
        self.backflow_level = node_cache.attrAsFloat(point, "backflow_level")

    def asDict(self):
        el = QgepProfileElement.asDict(self)
        el.update(
            {
                "offset": self.offset,
                "coverLevel": self.cover_level,
                "backflowLevel": self.backflow_level,
            }
        )
        return el


class QgepProfile(object):
    """
    Manages a profile of reaches and special structures
    """

    rubberband = None

    def __init__(self, elements=None):
        if elements is None:
            elements = {}
        self.elements = elements

    def setRubberband(self, rubberband):
        """
        Well... this sets the rubberband
        :param rubberband:  A QgsRubberBand
        """
        self.rubberband = rubberband

    def copy(self):
        """
        Create a deep copy of the profile
        :return: A copy of this profile
        """
        new_profile = QgepProfile(self.elements.copy())
        new_profile.setRubberband(self.rubberband)
        return new_profile

    def __getitem__(self, key):
        return self.elements[key]

    def hasElement(self, key):
        """
        Check if an element with a given object id is already present in the profile
        :param key: An object id
        :return:    Boolean
        """
        return key in self.elements

    def addElement(self, key, elem):
        """
        Add an element to this profile
        :param key:  The object id
        :param elem: A subclass of QgepProfileElement
        """
        self.elements[key] = elem

    def getElements(self):
        """
        Get all elements of this profile
        :return: A list of elements
        """
        return list(self.elements.values())

    def asJson(self):
        """
        Prepare profile as JSON string, so the javascript responsible for the
        svg will know what to do with the data.
        """
        return json.dumps(
            [element.asDict() for element in list(self.elements.values())]
        )

    def reset(self):
        """
        Reset the profile ( forget about all elements )
        """
        self.elements = {}

    def highlight(self, obj_id):
        """
        Update a rubberband to highlight a given object
        :param obj_id: the object id of the object to hihglight
        """
        if obj_id is not None:
            self.elements[obj_id].highlight(self.rubberband)
        else:
            self.rubberband.reset()
