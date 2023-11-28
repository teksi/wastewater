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


import datetime

from qgis.core import (
    QgsProcessingContext,
    QgsProcessingFeedback,
    QgsProcessingParameterBoolean,
    QgsProcessingParameterEnum,
    QgsProcessingParameterFile,
    QgsProcessingParameterFileDestination,
    QgsProcessingParameterString,
    QgsProject,
)

from .qgep_algorithm import QgepAlgorithm
from .QgepSwmm import QgepSwmm

__author__ = "Timothée Produit"
__date__ = "2019-08-01"
__copyright__ = "(C) 2019 by IG-Group.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SwmmCreateInputAlgorithm(QgepAlgorithm):
    """"""

    DATABASE = "DATABASE"
    TEMPLATE_INP_FILE = "TEMPLATE_INP_FILE"
    INP_FILE = "INP_FILE"
    STATE = "STATE"
    ONLY_SELECTED = "ONLY_SELECTED"

    def name(self):
        return "swmm_create_input"

    def displayName(self):
        return self.tr("SWMM Create Input")

    def shortHelpString(self):
        return self.tr(
            """
        This tool will export the entire PRIMARY network as an input file for SWMM.
        If \"Export only selected network\" is selected, the entire selected network is exported, including the secondary network.
        Note that at this stage of the development, export of special structures (pumps, weirs, dividers) and related curves must be checked.
        Advices to improve the export can be submited as github issues.
        See: https://qgep.github.io/docs/qgep_swmm/Create-Input.html
        """
        )

    def helpUrl(self):
        return "https://qgep.github.io/docs/qgep_swmm/Create-Input.html"

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """
        self.stateOptions = ["current", "planned"]
        # The parameters
        description = self.tr("Database")
        self.addParameter(
            QgsProcessingParameterString(
                self.DATABASE, description=description, defaultValue="pg_qgep"
            )
        )

        description = self.tr("State (current or planned)")
        self.addParameter(
            QgsProcessingParameterEnum(
                self.STATE,
                description=description,
                options=self.stateOptions,
                defaultValue=self.stateOptions[0],
            )
        )

        description = self.tr("Template INP File")
        self.addParameter(
            QgsProcessingParameterFile(
                self.TEMPLATE_INP_FILE, description=description, extension="inp"
            )
        )

        description = self.tr("Destination INP File")
        self.addParameter(
            QgsProcessingParameterFileDestination(
                self.INP_FILE, description=description, fileFilter="inp (*.inp)"
            )
        )

        description = self.tr(
            "Export only selected network (including the secondary network if selected)"
        )
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.ONLY_SELECTED, description=description, defaultValue=False
            )
        )

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        feedback.setProgress(0)

        # init params
        database = self.parameterAsString(parameters, self.DATABASE, context)
        state = self.parameterAsString(parameters, self.STATE, context)
        template_inp_file = self.parameterAsFile(parameters, self.TEMPLATE_INP_FILE, context)
        inp_file = self.parameterAsFileOutput(parameters, self.INP_FILE, context)
        state = self.stateOptions[int(state)]
        if state not in ["current", "planned"]:
            feedback.reportError(
                'State must be "planned" or "current", state was set to "current"'
            )
            state = "current"
        only_selected = self.parameterAsBoolean(parameters, self.ONLY_SELECTED, context)

        # Get selection
        if only_selected:
            hierarchy = None
            structures_layers = QgsProject.instance().mapLayersByName(
                "vw_qgep_wastewater_structure"
            )
            if structures_layers:
                structures = structures_layers[0].selectedFeatures()
                selected_structures = []
                for struct in structures:
                    selected_structures.append(str(struct["wn_obj_id"]))
            else:
                self.structures = []

            reaches_layers = QgsProject.instance().mapLayersByName("vw_qgep_reach")
            if reaches_layers:
                reaches = reaches_layers[0].selectedFeatures()
                selected_reaches = []
                for reach in reaches:
                    selected_reaches.append(str(reach["obj_id"]))
        else:
            hierarchy = "primary"
            selected_structures = None
            selected_reaches = None
        # Connect to QGEP database and perform translation
        with QgepSwmm(
            datetime.datetime.today().isoformat(),
            database,
            state,
            inp_file,
            template_inp_file,
            None,
            None,
            feedback,
        ) as qs:
            qs.write_input(hierarchy, selected_structures, selected_reaches)
        feedback.setProgress(100)

        return {self.INP_FILE: inp_file}
