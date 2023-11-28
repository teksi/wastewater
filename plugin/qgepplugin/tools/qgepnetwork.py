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
Manages a graph of a wastewater network
"""
from __future__ import print_function

import copyreg
import re
import time

# pylint: disable=no-name-in-module
from builtins import object, str, zip
from collections import defaultdict

import networkx as nx
from qgis.core import NULL, Qgis, QgsGeometry, QgsMessageLog, QgsPointXY
from qgis.PyQt.QtCore import QObject, Qt, pyqtSignal

from qgepplugin.utils.qt_utils import OverrideCursor


class QgepGraphManager(QObject):
    """
    Manages a graph
    """

    edge_layer = None
    edge_layer_id = -1
    nodeLayer = None
    nodeLayerId = -1
    dirty = True
    graph = None
    vertexIds = {}
    nodesOnStructure = defaultdict(list)
    # Logs performance of graph creation
    timings = []

    message_emitted = pyqtSignal(str, str, Qgis.MessageLevel)

    def __init__(self):
        QObject.__init__(self)

    def setReachLayer(self, reach_layer):
        """
        Set the reach layer (edges)
        """
        self.edge_layer = reach_layer
        self.dirty = True

        if reach_layer:
            self.edge_layer_id = reach_layer.id()
        else:
            self.edge_layer_id = 0

        if self.nodeLayer and self.edge_layer:
            self.createGraph()

    def setNodeLayer(self, node_layer):
        """
        Set the node layer
        """
        self.dirty = True

        self.nodeLayer = node_layer

        if node_layer:
            self.nodeLayerId = node_layer.id()

        else:
            self.nodeLayerId = 0

        if self.nodeLayer and self.edge_layer:
            self.createGraph()

    def _addVertices(self):
        """
        Initializes the graph with the vertices from the node layer
        """
        node_provider = self.nodeLayer.dataProvider()

        features = node_provider.getFeatures()

        # Add all vertices
        for feat in features:
            fid = feat.id()

            obj_id = feat["obj_id"]
            obj_type = feat["type"]

            try:
                vertex = feat.geometry().asPoint()
            except ValueError:
                # TODO Add to problem log
                pass
            self.graph.add_node(fid, point=vertex, objType=obj_type, objId=obj_id)

            self.vertexIds[str(obj_id)] = fid

        self._profile("add vertices")

    def _addEdges(self):
        """
        Initializes the graph with the edges
        """
        # Add all edges (reach)
        reach_provider = self.edge_layer.dataProvider()

        features = reach_provider.getFeatures()

        # Loop through all reaches
        for feat in features:
            try:
                obj_id = feat["obj_id"]
                obj_type = feat["type"]
                from_obj_id = feat["from_obj_id"]
                to_obj_id = feat["to_obj_id"]

                length = feat["length_calc"]

                pt_id1 = self.vertexIds[from_obj_id]
                pt_id2 = self.vertexIds[to_obj_id]

                self.graph.add_edge(
                    pt_id1,
                    pt_id2,
                    weight=length,
                    feature=feat.id(),
                    baseFeature=obj_id,
                    objType=obj_type,
                )
            except KeyError as e:
                print(e)

        self._profile("add edges")

    def refresh(self):
        """
        Refreshes the network graph. It will force a refresh of the materialized views in the database and then reload
        and recreate the graph.
        """
        with OverrideCursor(Qt.WaitCursor):
            transaction = self.nodeLayer.dataProvider().transaction()
            temporary_edit_session = False
            if not transaction:
                self.nodeLayer.startEditing()
                temporary_edit_session = True
                transaction = self.nodeLayer.dataProvider().transaction()

                if not transaction:
                    self.message_emitted.emit(
                        self.tr("Error"),
                        self.tr("Could not initialize transaction"),
                        Qgis.Critical,
                    )
                    return

            query_template = "SELECT qgep_network.refresh_network_simple();"
            res, error = transaction.executeSql(query_template)
            if not res:
                self.message_emitted.emit(self.tr("Error"), error, Qgis.Critical)
            else:
                self.message_emitted.emit(
                    self.tr("Success"),
                    self.tr("Network successfully updated"),
                    Qgis.Success,
                )

            if temporary_edit_session:
                self.nodeLayer.commitChanges()

            # recreate networkx graph
            self.graph.clear()
            self.createGraph()

    def _profile(self, name):
        """
        Adds a performance profile snapshot with the given name
        """
        spenttime = 0
        if self.timings:
            spenttime = time.process_time() - self.timings[-1][1]
        self.timings.append((name, spenttime))

    # Creates a network graph
    def createGraph(self):
        """
        Create a graph
        """
        self._profile("create graph")
        # try:
        self.vertexIds = {}
        self.nodesOnStructure = defaultdict(list)
        self._profile("initiate dicts")
        self.graph = nx.DiGraph()

        self._profile("initiate graph")

        self._addVertices()
        self._addEdges()

        self.print_profile()
        self.dirty = False

    def getNodeLayer(self):
        """
        Getter for the node layer
        """
        return self.nodeLayer

    def getEdgeLayer(self):
        """
        Getter for the reach layer
        :return:
        """
        return self.edge_layer

    def getNodeLayerId(self):
        """
        Getter for the node layer's id
        """
        return self.nodeLayerId

    def getReachLayerId(self):
        """
        Getter for the reach layer's id
        """
        return self.edge_layer_id

    def shortestPath(self, start_point, end_point):
        """
        Finds the shortest path from the start point
        to the end point
        :param start_point: The start node
        :param end_point:   The end node
        :return:       A (path, edges) tuple
        """
        if self.dirty:
            self.createGraph()

        try:
            path = nx.algorithms.dijkstra_path(self.graph, start_point, end_point)
            edges = [
                (u, v, self.graph.edges[u, v]) for (u, v) in zip(path[0:], path[1:])
            ]

            p = (path, edges)

        except nx.NetworkXNoPath:
            print("no path found")
            p = ([], [])

        return p

    def getTree(self, node, upstream=False):
        """
        Get
        :param node:    A start node
        :param upstream: Should the graph be reversed (upstream search)
        :return:        A list of edges
        """
        if self.dirty:
            self.createGraph()

        # fix point pickle
        def pickle_point(p):
            return QgsPointXY, (
                p.x(),
                p.y(),
            )

        copyreg.pickle(QgsPointXY, pickle_point)

        if upstream:
            my_graph = self.graph.reverse()
        else:
            my_graph = self.graph

        # Returns pred, weight
        pred, _ = nx.bellman_ford_predecessor_and_distance(my_graph, node)
        edges = [
            (v[0], u, my_graph.edges[v[0], u]) for (u, v) in list(pred.items()) if v
        ]
        nodes = [
            my_graph.nodes[n]
            for n in set(list(pred.keys()) + [v[0] for v in list(pred.values()) if v])
            if n is not None
        ]

        return nodes, edges

    def getEdgeGeometry(self, edges):
        """
        Get the geometry for some edges
        :param edges:  A list of edges
        :return:       A list of polylines
        """
        cache = self.getFeaturesById(self.edge_layer, edges)
        polylines = [
            feat.geometry().asPolyline() for feat in list(cache.asDict().values())
        ]
        return polylines

    # pylint: disable=no-self-use
    def getFeaturesById(self, layer, ids):
        """
        Get some features by their id
        """
        feat_cache = QgepFeatureCache(layer)
        data_provider = layer.dataProvider()

        features = data_provider.getFeatures()

        for feat in features:
            if feat.id() in ids:
                feat_cache.addFeature(feat)

        return feat_cache

    # pylint: disable=no-self-use
    def getFeaturesByAttr(self, layer, attr, values):
        """
        Get some features by an attribute value
        """
        feat_cache = QgepFeatureCache(layer)
        data_provider = feat_cache.layer.dataProvider()

        # Batch query and filter locally
        features = data_provider.getFeatures()

        for feat in features:
            if feat_cache.attrAsUnicode(feat, attr) in values:
                feat_cache.addFeature(feat)

        return feat_cache

    def print_profile(self):
        """
        Will print some performance profiling information
        """
        for (name, spenttime) in self.timings:
            print(name + ":" + str(spenttime))


class QgepFeatureCache(object):
    """
    A feature cache.
    The DB can be slow sometimes, so if we know, that we'll be using some features
    several times consecutively it's better to keep it in memory.
    There is no check done for maximum size. You have to care for your memory
    yourself, when using this class!
    """

    _featuresById = None
    _featuresByObjId = None
    objIdField = None
    layer = None

    def __init__(self, layer, obj_id_field="obj_id"):
        self._featuresById = {}
        self._featuresByObjId = {}
        self.objIdField = obj_id_field
        self.layer = layer

    def __getitem__(self, key):
        return self.featureById(key)

    def addFeature(self, feat):
        """
        Add a feature to the cache
        """
        self._featuresById[feat.id()] = feat
        self._featuresByObjId[self.attrAsUnicode(feat, self.objIdField)] = feat

    def featureById(self, fid):
        """
        Get a feature by its feature id
        """
        return self._featuresById[fid]

    def featureByObjId(self, obj_id):
        """
        Get a feature by its object id
        """
        return self._featuresByObjId[obj_id]

    def attrAsFloat(self, feat, attr):
        """
        Get an attribute as float
        """
        try:
            return float(self.attr(feat, attr))
        except TypeError:
            return None

    def attrAsUnicode(self, feat, attr):
        """
        Get an attribute as unicode string
        """
        return self.attr(feat, attr)

    # pylint: disable=no-self-use
    def attr(self, feat, attr):
        """
        Get an attribute
        """
        try:
            if feat[attr] == NULL:
                return None
            else:
                return feat[attr]
        except KeyError:
            QgsMessageLog.logMessage(
                "Unknown field {}".format(attr), "qgep", Qgis.Critical
            )
            return None

    def attrAsGeometry(self, feat, attr):
        """
        Get an attribute as geometry
        """
        ewktstring = self.attrAsUnicode(feat, attr)
        # Strip SRID=21781; token, TODO: Fix this upstream
        m = re.search("(.*;)?(.*)", ewktstring)
        return QgsGeometry.fromWkt(m.group(2))

    def asDict(self) -> dict:
        """
        Returns all features a s a dictionary with ids as keys
        """
        return self._featuresById

    def asObjIdDict(self):
        """
        Returns all features as a dictionary with object ids as keys.
        """
        return self._featuresById
