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

import os
import re

from processing.core.ProcessingConfig import ProcessingConfig
from qgis.core import (
    QgsProcessingContext,
    QgsProcessingException,
    QgsProcessingFeedback,
    QgsProcessingParameterFile,
    QgsProcessingParameterFileDestination,
)

from .qgep_algorithm import QgepAlgorithm
from .QgepSwmm import QgepSwmm

__author__ = "Timothée Produit"
__date__ = "2019-08-01"
__copyright__ = "(C) 2019 by IG-Group.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SwmmExecuteAlgorithm(QgepAlgorithm):
    """"""

    INP_FILE = "INP_FILE"
    RPT_FILE = "RPT_FILE"

    def name(self):
        return "swmm_execute"

    def displayName(self):
        return self.tr("SWMM Execute")

    def shortHelpString(self):
        return self.tr(
            """
        Launch a swmm simulation.
         Note that usually a .inp file exported with QGEP is not directly launchable. It must be checked and edited with a SWMM interface.
         See: https://qgep.github.io/docs/qgep_swmm/Execute.html
         """
        )

    def helpUrl(self):
        return "https://qgep.github.io/docs/qgep_swmm/Execute.html"

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        description = self.tr("INP File")
        self.addParameter(
            QgsProcessingParameterFile(
                self.INP_FILE, description=description, extension="inp"
            )
        )

        description = self.tr("RPT File")
        self.addParameter(
            QgsProcessingParameterFileDestination(
                self.RPT_FILE, description=description, fileFilter="rpt (*.rpt)"
            )
        )

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        # init params
        rpt_file = self.parameterAsFile(parameters, self.RPT_FILE, context)
        inp_file = self.parameterAsFileOutput(parameters, self.INP_FILE, context)
        swmm_cli = os.path.abspath(ProcessingConfig.getSetting("SWMM_PATH"))
        if not swmm_cli:
            # raise GeoAlgorithmExecutionException(
            # 'Swmm command line toom is not configured.\n\
            # Please configure it before running Swmm algorithms.')
            raise QgsProcessingException(
                self.tr(
                    "Swmm command line tool is not configured.\n\
                    Please configure it before running Swmm algorithms."
                )
            )

        with QgepSwmm(
            None, None, None, inp_file, None, rpt_file, swmm_cli, feedback
        ) as qs:
            prompt = qs.execute_swmm()

        feedback.pushInfo(prompt)

        if re.search("There are errors", prompt):
            feedback.reportError(prompt)
            feedback.reportError(
                "There were errors, run the file in SWMM GUI for more details"
            )

        feedback.setProgress(100)

        return {}
