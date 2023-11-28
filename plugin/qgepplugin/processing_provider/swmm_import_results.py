# -*- coding: utf-8 -*-

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

from qgis.core import (
    QgsProcessingContext,
    QgsProcessingFeedback,
    QgsProcessingParameterBoolean,
    QgsProcessingParameterFile,
    QgsProcessingParameterString,
)

from .qgep_algorithm import QgepAlgorithm
from .QgepSwmm import QgepSwmm

__author__ = "Timothée Produit"
__date__ = "2021-04-30"
__copyright__ = "(C) 2021 by map.ig-group.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SwmmImportResultsAlgorithm(QgepAlgorithm):
    """"""

    RPT_FILE = "RPT_FILE"
    DATABASE = "DATABASE"
    SIM_DESCRIPTION = "SIM_DESCRIPTION"
    IMPORT_SUMMARY = "IMPORT_SUMMARY"
    IMPORT_FULL_RESULTS = "IMPORT_FULL_RESULTS"
    POPULATE_BACKFLOW_LEVEL = "POPULATE_BACKFLOW_LEVEL"
    POPULATE_HYDRAULIC_LOAD = "POPULATE_HYDRAULIC_LOAD"

    def name(self):
        return "swmm_import_results"

    def displayName(self):
        return self.tr("SWMM Import Results")

    def shortHelpString(self):
        return self.tr(
            """
            Import SWMM results in QGEP database.
            See: https://qgep.github.io/docs/qgep_swmm/Extract-Results.html
            """
        )

    def helpUrl(self):
        return "https://qgep.github.io/docs/qgep_swmm/Import-Results.html"

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        description = self.tr("SWMM report file (.rpt)")
        self.addParameter(
            QgsProcessingParameterFile(self.RPT_FILE, description=description)
        )

        description = self.tr("Database")
        self.addParameter(
            QgsProcessingParameterString(
                self.DATABASE, description=description, defaultValue="pg_qgep"
            )
        )

        description = self.tr("Simulation name")
        self.addParameter(
            QgsProcessingParameterString(
                self.SIM_DESCRIPTION,
                description=description,
                defaultValue="SWMM simulation, rain T100, current",
            )
        )

        description = self.tr("Import summary")
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.IMPORT_SUMMARY, description=description, defaultValue=True
            )
        )

        description = self.tr("Import full results")
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.IMPORT_FULL_RESULTS, description=description, defaultValue=False
            )
        )

        description = self.tr(
            "Import Max HGL in qgep_od.wastewater_node.backflow_level"
        )
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.POPULATE_BACKFLOW_LEVEL,
                description=description,
                defaultValue=False,
            )
        )

        description = self.tr(
            "Import Max/Full Flow in qgep_od.reach.dss2020_hydraulic_load_current"
        )
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.POPULATE_HYDRAULIC_LOAD,
                description=description,
                defaultValue=False,
            )
        )

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        feedback.pushInfo("The import started, it can take a few minutes.")
        feedback.setProgress(1)

        # init params
        rpt_file = self.parameterAsFileOutput(parameters, self.RPT_FILE, context)
        database = self.parameterAsString(parameters, self.DATABASE, context)
        sim_description = self.parameterAsString(
            parameters, self.SIM_DESCRIPTION, context
        )
        import_summary = self.parameterAsBoolean(
            parameters, self.IMPORT_SUMMARY, context
        )
        import_full_result = self.parameterAsBoolean(
            parameters, self.IMPORT_FULL_RESULTS, context
        )
        import_backflow_level = self.parameterAsBoolean(
            parameters, self.POPULATE_BACKFLOW_LEVEL, context
        )
        import_hydraulic_load = self.parameterAsBoolean(
            parameters, self.POPULATE_HYDRAULIC_LOAD, context
        )

        # Get node summary from output file
        with QgepSwmm(
            sim_description, database, None, None, None, rpt_file, None, feedback
        ) as qs:
            if import_summary:
                qs.import_summary(sim_description)
            if import_full_result:
                qs.import_full_results(sim_description)
            if import_backflow_level:
                qs.import_backflow_level()
            if import_hydraulic_load:
                qs.import_hydraulic_load()

        feedback.setProgress(100)

        return {}
