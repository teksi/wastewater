# -*- coding: utf-8 -*-

"""
/***************************************************************************
 QGEP processing provider
                              -------------------
        begin                : 18.11.2017
        copyright            : (C) 2017 by OPENGIS.ch
        email                : matthias@opengis.ch
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

from qgis.core import (
    QgsExpression,
    QgsFeatureRequest,
    QgsGeometry,
    QgsPointXY,
    QgsProcessingParameterBoolean,
    QgsProcessingParameterNumber,
    QgsProcessingParameterVectorLayer,
)

from .qgep_algorithm import QgepAlgorithm

__author__ = "Matthias Kuhn"
__date__ = "2017-11-18"
__copyright__ = "(C) 2017 by OPENGIS.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SnapReachAlgorithm(QgepAlgorithm):
    """"""

    DISTANCE = "DISTANCE"
    REACH_LAYER = "REACH_LAYER"
    WASTEWATER_NODE_LAYER = "WASTEWATER_NODE_LAYER"
    ONLY_SELECTED = "ONLY_SELECTED"

    def name(self):
        return self.tr("qgep_snap_rach")

    def displayName(self):
        return self.tr("Snap reach geometry")

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        self.addParameter(
            QgsProcessingParameterNumber(
                self.DISTANCE,
                type=QgsProcessingParameterNumber.Double,
                description=self.tr(
                    "Maximum snapping distance in meters. Set to 0 for no maximum."
                ),
                defaultValue=10.0,
            )
        )
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.ONLY_SELECTED,
                description=self.tr("Snap only selected reaches."),
                defaultValue=True,
            )
        )
        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.REACH_LAYER,
                description=self.tr(
                    "Reach layer, will be modified in place and used as snapping target"
                ),
            )
        )
        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.WASTEWATER_NODE_LAYER,
                description=self.tr(
                    "Wastewater node layer, will be used as snapping target"
                ),
            )
        )

    def processAlgorithm(self, parameters, context, feedback):
        """Here is where the processing itself takes place."""

        reach_layer = self.parameterAsVectorLayer(parameters, self.REACH_LAYER, context)
        wastewater_node_layer = self.parameterAsVectorLayer(
            parameters, self.WASTEWATER_NODE_LAYER, context
        )
        distance = self.parameterAsDouble(parameters, self.DISTANCE, context)
        only_selected = self.parameterAsBool(parameters, self.ONLY_SELECTED, context)

        reach_layer.startEditing()

        feature_count = 0
        if only_selected:
            iterator = reach_layer.getSelectedFeatures()
            feature_count = reach_layer.selectedFeatureCount()
        else:
            iterator = reach_layer.getFeatures()
            feature_count = reach_layer.featureCount()

        # Loop through relevant reaches
        reach_layer.beginEditCommand("Snap reaches to points")
        try:
            reaches = list()
            current_feature = 0
            for reach in iterator:
                reaches.append(reach)
                # Batch processing: process blocks of 2000 reaches
                if len(reaches) == 2000:
                    self.processFeatures(
                        reaches, reach_layer, wastewater_node_layer, distance
                    )
                    reaches = list()

                current_feature += 1
                feedback.setProgress(current_feature * 100.0 / feature_count)

            self.processFeatures(reaches, reach_layer, wastewater_node_layer, distance)
        except:  # NOQA
            reach_layer.destroyEditCommand()
            raise
        reach_layer.endEditCommand()
        feedback.setProgress(100)

        return {}

    def processFeatures(
        self, reaches, reach_layer, wastewater_node_layer, distance_threshold
    ):
        ids = list()
        to_ids = list()
        # Gather ids of connected networkelements
        # to_ids are also gathered separately, because they can be either
        # reaches or nodes
        for reach in reaches:
            if reach["rp_from_fk_wastewater_networkelement"]:
                ids.append(reach["rp_from_fk_wastewater_networkelement"])

            if reach["rp_to_fk_wastewater_networkelement"]:
                ids.append(reach["rp_to_fk_wastewater_networkelement"])
                to_ids.append(reach["rp_to_fk_wastewater_networkelement"])

        # Get all nodes on which to snap
        quoted_ids = [QgsExpression.quotedValue(objid) for objid in ids]
        node_request = QgsFeatureRequest()
        filter_expression = '"obj_id" IN ({ids})'.format(ids=",".join(quoted_ids))
        node_request.setFilterExpression(filter_expression)
        node_request.setSubsetOfAttributes([])

        nodes = dict()
        for node in wastewater_node_layer.getFeatures(node_request):
            nodes[node["obj_id"]] = node

        # Get all reaches on which to snap
        quoted_to_ids = [QgsExpression.quotedValue(objid) for objid in to_ids]
        reach_request = QgsFeatureRequest()
        filter_expression = '"obj_id" IN ({ids})'.format(ids=",".join(quoted_to_ids))
        reach_request.setFilterExpression(filter_expression)
        reach_request.setSubsetOfAttributes([])

        target_reaches = dict()
        for target_reach in reach_layer.getFeatures(reach_request):
            target_reaches[target_reach["obj_id"]] = target_reach

        for reach in reaches:
            reach_geometry = QgsGeometry(reach.geometry())
            from_id = reach["rp_from_fk_wastewater_networkelement"]
            if from_id in list(nodes.keys()):
                if (
                    distance_threshold == 0
                    or reach_geometry.sqrDistToVertexAt(
                        nodes[from_id].geometry().asPoint(), 0
                    )
                    < distance_threshold
                ):
                    reach_geometry.moveVertex(nodes[from_id].geometry().constGet(), 0)

            to_id = reach["rp_to_fk_wastewater_networkelement"]
            if to_id in list(nodes.keys()):
                last_vertex = reach_geometry.constGet().nCoordinates() - 1
                if (
                    distance_threshold == 0
                    or reach_geometry.sqrDistToVertexAt(
                        nodes[to_id].geometry().asPoint(), last_vertex
                    )
                    < distance_threshold
                ):
                    reach_geometry.moveVertex(
                        nodes[to_id].geometry().constGet(), last_vertex
                    )

            if to_id in list(target_reaches.keys()):
                last_vertex = reach_geometry.constGet().nCoordinates() - 1
                target_reach = target_reaches[to_id]
                (
                    distance,
                    point,
                    min_distance_point,
                    after_vertex,
                ) = target_reach.geometry().closestSegmentWithContext(
                    QgsPointXY(reach_geometry.vertexAt(last_vertex))
                )
                if distance_threshold == 0 or distance < distance_threshold:
                    reach_geometry.moveVertex(point.x(), point.y(), last_vertex)

            reach.setGeometry(reach_geometry)
            reach_layer.updateFeature(reach)
