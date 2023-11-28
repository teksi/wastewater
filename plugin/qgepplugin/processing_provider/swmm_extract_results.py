"""
/***************************************************************************
 QGEP-swmm processing provider
                              -------------------
        begin                : 07.2019
        copyright            : (C) 2019 by ig-group.ch
        email                : timothee.produit@ig-group.ch
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

from PyQt5.QtCore import QVariant
from qgis.core import (
    QgsFeature,
    QgsFeatureSink,
    QgsField,
    QgsFields,
    QgsProcessingContext,
    QgsProcessingException,
    QgsProcessingFeedback,
    QgsProcessingParameterFeatureSink,
    QgsProcessingParameterFile,
)

from .qgep_algorithm import QgepAlgorithm
from .QgepSwmm import QgepSwmm

__author__ = "Timothée Produit"
__date__ = "2019-08-01"
__copyright__ = "(C) 2019 by IG-Group.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SwmmExtractResultsAlgorithm(QgepAlgorithm):
    """"""

    RPT_FILE = "RPT_FILE"
    NODE_SUMMARY = "NODE_SUMMARY"
    LINK_SUMMARY = "LINK_SUMMARY"
    XSECTION_SUMMARY = "XSECTION_SUMMARY"

    def name(self):
        return "swmm_extract_results"

    def displayName(self):
        return self.tr("SWMM Extract Results")

    def shortHelpString(self):
        return self.tr(
            """
        Import SWMM results in QGIS temporary tables.
        See: https://qgep.github.io/docs/qgep_swmm/Extract-Results.html
        """
        )

    def helpUrl(self):
        return "https://qgep.github.io/docs/qgep_swmm/Extract-Results.html"

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        description = self.tr("RPT File")
        self.addParameter(
            QgsProcessingParameterFile(
                self.RPT_FILE, description=description, fileFilter="rpt (*.rpt)"
            )
        )

        self.addParameter(
            QgsProcessingParameterFeatureSink(self.NODE_SUMMARY, self.tr("Node summary"))
        )

        self.addParameter(
            QgsProcessingParameterFeatureSink(self.LINK_SUMMARY, self.tr("Link summary"))
        )

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        feedback.setProgress(1)

        # init params
        rpt_file = self.parameterAsFileOutput(parameters, self.RPT_FILE, context)

        # create feature sink for node summary
        fields = QgsFields()

        fields.append(QgsField("id", QVariant.String))
        fields.append(QgsField("type", QVariant.String))
        fields.append(QgsField("average_depth", QVariant.Double))
        fields.append(QgsField("maximum_depth", QVariant.Double))
        fields.append(QgsField("maximum_hgl", QVariant.Double))
        fields.append(QgsField("time_max_day", QVariant.Int))
        fields.append(QgsField("time_max_time", QVariant.String))
        fields.append(QgsField("reported_max_depth", QVariant.Double))
        (sink_node, dest_id) = self.parameterAsSink(parameters, self.NODE_SUMMARY, context, fields)
        if sink_node is None:
            raise QgsProcessingException(self.invalidSinkError(parameters, self.NODE_SUMMARY))

        # Get node summary from output file
        qs = QgepSwmm(None, None, None, None, None, rpt_file, None, feedback)
        node_summary = qs.extract_node_depth_summary()

        # Fill node summary with data
        for ns in node_summary:
            sf = QgsFeature()
            sf.setFields(fields)
            for k in ns.keys():
                index = fields.indexOf(k)
                if index != -1:
                    sf.setAttribute(k, ns[k])
            sink_node.addFeature(sf, QgsFeatureSink.FastInsert)
        feedback.setProgress(50)

        # create feature sink for link summary
        fields = QgsFields()
        fields.append(QgsField("id", QVariant.String))
        fields.append(QgsField("type", QVariant.String))
        fields.append(QgsField("maximum_flow", QVariant.Double))
        fields.append(QgsField("time_max_day", QVariant.Int))
        fields.append(QgsField("time_max_time", QVariant.String))
        fields.append(QgsField("maximum_velocity", QVariant.Double))
        fields.append(QgsField("max_over_full_flow", QVariant.Double))
        fields.append(QgsField("max_over_full_depth", QVariant.Double))
        (sink_link, dest_id) = self.parameterAsSink(parameters, self.LINK_SUMMARY, context, fields)
        if sink_link is None:
            raise QgsProcessingException(self.invalidSinkError(parameters, self.LINK_SUMMARY))

        # Get link summary from output file
        link_summary = qs.extract_link_flow_summary()

        # Fill node summary with data
        for ns in link_summary:
            sf = QgsFeature()
            sf.setFields(fields)
            for k in ns.keys():
                index = fields.indexOf(k)
                if index != -1:
                    sf.setAttribute(k, ns[k])
            sink_link.addFeature(sf, QgsFeatureSink.FastInsert)
        feedback.setProgress(100)

        return {self.NODE_SUMMARY: sink_node, self.LINK_SUMMARY: sink_link}
