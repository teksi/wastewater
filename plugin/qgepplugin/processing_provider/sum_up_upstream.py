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


import statistics

from PyQt5.QtCore import QVariant
from qgis.core import (
    NULL,
    QgsExpression,
    QgsExpressionContext,
    QgsExpressionContextUtils,
    QgsFeature,
    QgsFeatureRequest,
    QgsFeatureSink,
    QgsField,
    QgsGeometry,
    QgsProcessing,
    QgsProcessingContext,
    QgsProcessingException,
    QgsProcessingFeedback,
    QgsProcessingParameterBoolean,
    QgsProcessingParameterDefinition,
    QgsProcessingParameterEnum,
    QgsProcessingParameterExpression,
    QgsProcessingParameterFeatureSink,
    QgsProcessingParameterField,
    QgsProcessingParameterVectorLayer,
    QgsWkbTypes,
)

from .qgep_algorithm import QgepAlgorithm

__author__ = "Matthias Kuhn"
__date__ = "2019-04-09"
__copyright__ = "(C) 2018 by OPENGIS.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class Reach:
    def __init__(self, from_id, to_id, value, geometry):
        self.from_id = from_id
        self.to_id = to_id
        self.value = value
        self.geometry = geometry


class SumUpUpstreamAlgorithm(QgepAlgorithm):
    """"""

    REACH_LAYER = "REACH_LAYER"
    WASTEWATER_NODE_LAYER = "WASTEWATER_NODE_LAYER"
    VALUE_EXPRESSION = "VALUE_EXPRESSION"
    REACH_PK_NAME = "REACH_PK_NAME"
    NODE_PK_NAME = "NODE_PK_NAME"
    NODE_FROM_FK_NAME = "NODE_FROM_FK_NAME"
    NODE_TO_FK_NAME = "NODE_TO_FK_NAME"
    BRANCH_BEHAVIOR = "BRANCH_BEHAVIOR"
    CREATE_LOOP_LAYER = "CREATE_LOOP_LAYER"

    OUTPUT = "OUTPUT"
    LOOP_OUTPUT = "LOOP_OUTPUT"

    def name(self):
        return "qgep_values_upstream"

    def displayName(self):
        return self.tr("Sum up upstream")

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        description = self.tr(
            'Source value expression. Use <code>COALESCE("field_name", 0)</code> to treat <code>NULL</code> values as 0.'
        )
        self.addParameter(
            QgsProcessingParameterExpression(
                self.VALUE_EXPRESSION,
                description=description,
                parentLayerParameterName=self.REACH_LAYER,
            )
        )
        description = self.tr("Branch behavior")
        self.addParameter(
            QgsProcessingParameterEnum(
                self.BRANCH_BEHAVIOR,
                description=description,
                options=[self.tr("Minimum"), self.tr("Maximum"), self.tr("Average")],
            )
        )

        self.addParameter(
            QgsProcessingParameterFeatureSink(self.OUTPUT, self.tr("Summed up"))
        )

        description = self.tr("Create a layer with nodes in loops")
        self.addAdvancedParameter(
            QgsProcessingParameterBoolean(
                self.CREATE_LOOP_LAYER, description=description, defaultValue=False
            )
        )

        self.addAdvancedParameter(
            QgsProcessingParameterFeatureSink(
                self.LOOP_OUTPUT,
                self.tr(
                    'Loop nodes (Only created if "Crate a layer with nodes in loops" option is activated)'
                ),
                optional=True,
            )
        )
        description = self.tr("Reach Layer")
        self.addAdvancedParameter(
            QgsProcessingParameterVectorLayer(
                self.REACH_LAYER,
                description=description,
                types=[QgsProcessing.TypeVectorLine],
                defaultValue="vw_qgep_reach",
            )
        )
        description = self.tr("Wastewater Node Layer")
        self.addAdvancedParameter(
            QgsProcessingParameterVectorLayer(
                self.WASTEWATER_NODE_LAYER,
                description=description,
                types=[QgsProcessing.TypeVector],
                defaultValue="vw_wastewater_node",
            )
        )

        description = self.tr("Primary Key Field Reach")
        self.addAdvancedParameter(
            QgsProcessingParameterField(
                self.REACH_PK_NAME,
                description=description,
                parentLayerParameterName=self.REACH_LAYER,
                defaultValue="obj_id",
            )
        )

        description = self.tr("Primary Key Field Node")
        self.addAdvancedParameter(
            QgsProcessingParameterField(
                self.NODE_PK_NAME,
                description=description,
                parentLayerParameterName=self.WASTEWATER_NODE_LAYER,
                defaultValue="obj_id",
            )
        )

        description = self.tr("Foreign Key Field From")
        self.addAdvancedParameter(
            QgsProcessingParameterField(
                self.NODE_FROM_FK_NAME,
                description=description,
                parentLayerParameterName=self.REACH_LAYER,
                defaultValue="rp_from_fk_wastewater_networkelement",
            )
        )

        description = self.tr("Foreign Key Field To")
        self.addAdvancedParameter(
            QgsProcessingParameterField(
                self.NODE_TO_FK_NAME,
                description=description,
                parentLayerParameterName=self.REACH_LAYER,
                defaultValue="rp_to_fk_wastewater_networkelement",
            )
        )

    def addAdvancedParameter(self, parameter):
        parameter.setFlags(
            parameter.flags() | QgsProcessingParameterDefinition.FlagAdvanced
        )
        self.addParameter(parameter)

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        feedback.setProgress(0)

        # init params
        reach_layer = self.parameterAsVectorLayer(parameters, self.REACH_LAYER, context)
        wastewater_node_layer = self.parameterAsVectorLayer(
            parameters, self.WASTEWATER_NODE_LAYER, context
        )
        value_expression = self.parameterAsExpression(
            parameters, self.VALUE_EXPRESSION, context
        )
        reach_pk_name = self.parameterAsFields(parameters, self.REACH_PK_NAME, context)[
            0
        ]
        node_pk_name = self.parameterAsFields(parameters, self.NODE_PK_NAME, context)[0]
        node_from_fk_name = self.parameterAsFields(
            parameters, self.NODE_FROM_FK_NAME, context
        )[0]
        node_to_fk_name = self.parameterAsFields(
            parameters, self.NODE_TO_FK_NAME, context
        )[0]
        branch_behavior = self.parameterAsEnum(
            parameters, self.BRANCH_BEHAVIOR, context
        )
        create_loop_layer = self.parameterAsBool(
            parameters, self.CREATE_LOOP_LAYER, context
        )

        if branch_behavior == 0:
            aggregate_method = lambda values: min(values) if values else 0
        elif branch_behavior == 1:
            aggregate_method = lambda values: max(values) if values else 0
        elif branch_behavior == 2:
            aggregate_method = lambda values: statistics.mean(values) if values else 0
        else:
            aggregate_method = lambda values: feedback.pushError(
                "Aggregate method not implemented"
            )

        # create feature sink
        fields = wastewater_node_layer.fields()
        fields.append(QgsField("value", QVariant.Double))
        (sink, dest_id) = self.parameterAsSink(
            parameters,
            self.OUTPUT,
            context,
            fields,
            QgsWkbTypes.Point,
            reach_layer.sourceCrs(),
        )

        loop_sink = None
        loop_dest_id = None
        if create_loop_layer:
            (loop_sink, loop_dest_id) = self.parameterAsSink(
                parameters,
                self.LOOP_OUTPUT,
                context,
                fields,
                QgsWkbTypes.Point,
                reach_layer.sourceCrs(),
            )

        if sink is None:
            raise QgsProcessingException(self.invalidSinkError(parameters, self.OUTPUT))

        feature_count = reach_layer.featureCount()

        reaches_by_from_node = dict()
        reaches_by_id = dict()

        expression = QgsExpression(value_expression)
        context = QgsExpressionContext(
            QgsExpressionContextUtils.globalProjectLayerScopes(reach_layer)
        )
        expression.prepare(context)

        progress = 0
        feedback.setProgressText(self.tr("Indexing reaches"))
        for reach in reach_layer.getFeatures(QgsFeatureRequest()):
            if reach[node_from_fk_name] == NULL:
                continue

            context.setFeature(reach)
            value = expression.evaluate(context)
            reach_obj = Reach(
                reach[node_from_fk_name],
                reach[node_to_fk_name],
                value,
                reach.geometry(),
            )
            reaches_by_from_node.setdefault(reach_obj.from_id, []).append(reach_obj)
            reaches_by_id[reach[reach_pk_name]] = reach_obj

            feedback.setProgress(progress / feature_count * 10)
            progress += 1

        loop_nodes = []
        current_feature = 0
        calculated_values = {}

        feedback.setProgressText(self.tr("Analyzing network"))
        for node in wastewater_node_layer.getFeatures():

            from_node_id = node[node_pk_name]

            processed_nodes = []
            times = []
            if from_node_id in reaches_by_from_node.keys():
                for reach in reaches_by_from_node[from_node_id]:
                    times.append(
                        self.calculate_branch(
                            reach,
                            reaches_by_from_node,
                            reaches_by_id,
                            list(processed_nodes),
                            calculated_values,
                            aggregate_method,
                            loop_nodes,
                            feedback,
                        )
                    )

            if times:
                time = aggregate_method(times)
            else:
                time = 0

            current_feature += 1

            calculated_values[node[node_pk_name]] = time
            new_node = QgsFeature(node)
            new_node.setFields(fields)
            new_node.setAttributes(node.attributes() + [time])

            sink.addFeature(new_node, QgsFeatureSink.FastInsert)

            if create_loop_layer and from_node_id in loop_nodes:
                loop_sink.addFeature(node, QgsFeatureSink.FastInsert)

            feedback.setProgress(10 + current_feature / feature_count * 90)

        result = {self.OUTPUT: dest_id}
        if create_loop_layer:
            result[self.LOOP_OUTPUT] = loop_dest_id

        return result

    def process_node(
        self,
        node_id,
        previous_reach,
        reaches_by_from_node,
        reaches_by_id,
        processed_nodes,
        calculated_values,
        aggregate_method,
        loop_nodes,
        feedback,
    ):
        time = 0

        while node_id in reaches_by_from_node.keys() or node_id in reaches_by_id.keys():
            if node_id in calculated_values:
                return calculated_values[node_id] + time
            if node_id in processed_nodes:
                # feedback.reportError(self.tr('Loop at node: {}'.format(node_id)))
                loop_nodes.append(node_id)
                return 0

            processed_nodes.append(node_id)

            if feedback.isCanceled():
                return NULL

            if node_id not in reaches_by_from_node:
                # Blind connection: add proportionally
                reach = reaches_by_id[node_id]
                offset = reach.geometry.lineLocatePoint(
                    QgsGeometry(previous_reach.geometry.constGet().endPoint())
                )
                length = reach.geometry.length()
                remaining_part = 1 - offset / length
                # feedback.pushInfo('Length: {} Offset: {} Part: {}'.format(length, offset, remaining_part, reach.value * remaining_part))
                time += reach.value * remaining_part
                node_id = reach.to_id
            else:
                current_reaches = reaches_by_from_node[node_id]
                if len(current_reaches) == 1:
                    # In case there is just one downstream reach, calculate in here
                    # Starting a recursive approach results in a maximum call stack exception
                    time += current_reaches[0].value
                    node_id = current_reaches[0].to_id
                    previous_reach = current_reaches[0]
                else:
                    # Branching occurred: calculate every possible path and aggregate all values
                    times = []
                    for reach in current_reaches:
                        times.append(
                            self.calculate_branch(
                                reach,
                                reaches_by_from_node,
                                reaches_by_id,
                                list(processed_nodes),
                                calculated_values,
                                aggregate_method,
                                loop_nodes,
                                feedback,
                            )
                        )

                    if times:
                        time += aggregate_method(times)

                    return time

        return time

    def calculate_branch(
        self,
        reach,
        reaches_by_from_node,
        reaches_by_id,
        processed_nodes,
        calculated_values,
        aggregate_method,
        loop_nodes,
        feedback,
    ):
        return reach.value + self.process_node(
            reach.to_id,
            reach,
            reaches_by_from_node,
            reaches_by_id,
            processed_nodes,
            calculated_values,
            aggregate_method,
            loop_nodes,
            feedback,
        )
