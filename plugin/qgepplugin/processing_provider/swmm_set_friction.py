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
    QgsProcessingParameterString,
)

from .qgep_algorithm import QgepAlgorithm
from .QgepSwmm import QgepSwmm

__author__ = "Timothée Produit"
__date__ = "2019-08-01"
__copyright__ = "(C) 2019 by IG-Group.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class SwmmSetFrictionAlgorithm(QgepAlgorithm):
    """"""

    DATABASE = "DATABASE"
    OVERWRITE_VALUES = "OVERWRITE_VALUES"

    def name(self):
        return "swmm_set_friction"

    def displayName(self):
        return self.tr("SWMM Set default coefficient of friction")

    def shortHelpString(self):
        return self.tr(
            """
        Fill the attribute qgep_od.reach.default_coefficient_of_friction where it is not filled.
        If \"Overwrite existing default values\" is selected, all the default_coefficient_of_friction will be reseted.
        See: https://qgep.github.io/docs/qgep_swmm/coefficient_of_friction.html
        """
        )

    def helpUrl(self):
        return "https://qgep.github.io/docs/qgep_swmm/coefficient_of_friction.html"

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        # The parameters
        description = self.tr("Database")
        self.addParameter(
            QgsProcessingParameterString(
                self.DATABASE, description=description, defaultValue="pg_qgep"
            )
        )

        description = self.tr("Overwrite existing default values")
        self.addParameter(
            QgsProcessingParameterBoolean(
                self.OVERWRITE_VALUES, description=description, defaultValue=False
            )
        )

    def processAlgorithm(
        self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback
    ):
        """Here is where the processing itself takes place."""

        feedback.setProgress(0)

        # init params
        database = self.parameterAsString(parameters, self.DATABASE, context)
        overwrite_values = self.parameterAsBoolean(
            parameters, self.OVERWRITE_VALUES, context
        )
        # Connect to QGEP database and perform translation
        with QgepSwmm(None, database, None, None, None, None, None, feedback) as qs:
            qs.disable_reach_trigger()
            if overwrite_values:
                qs.overwrite_reach_default_friction()
            else:
                qs.set_reach_default_friction()
            qs.enable_reach_trigger()

        feedback.setProgress(100)

        return {}
