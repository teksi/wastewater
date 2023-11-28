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

from qgis.core import QgsProcessingAlgorithm, QgsProcessingParameterVectorLayer

from .qgep_algorithm import QgepAlgorithm

__author__ = "Matthias Kuhn & Maxime Trolliet"
__date__ = "2018-08-07"
__copyright__ = "(C) 2018 by OPENGIS.ch"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"


class ChangeReachDirection(QgepAlgorithm):
    """
    Change the direction of the selected reaches
    """

    REACH_LAYER = "REACH_LAYER"

    def name(self):
        return "change_direction"

    def displayName(self):
        return self.tr("Change reach direction")

    def flags(self):
        return super().flags() | QgsProcessingAlgorithm.FlagNoThreading

    def initAlgorithm(self, config=None):
        """Here we define the inputs and output of the algorithm, along
        with some other properties.
        """

        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.REACH_LAYER,
                description=self.tr(
                    "Selected features only - Reach layer, will be modified in place and its direction will be inverted"
                ),
            )
        )

    def processAlgorithm(self, parameters, context, feedback):
        """Here is where the processing itself takes place."""
        reach_layer = self.parameterAsVectorLayer(parameters, self.REACH_LAYER, context)

        reach_layer.startEditing()

        # feature_count = 0

        iterator = reach_layer.getSelectedFeatures()
        # feature_count = reach_layer.selectedFeatureCount()

        # Loop through relevant reaches
        reach_layer.beginEditCommand("change directions")
        transaction = reach_layer.dataProvider().transaction()
        # if not transaction:
        #    raise Exception: if there is no transaction, complain to the user!
        selected_obj_ids = [feature["obj_id"] for feature in iterator]
        transaction.executeSql(
            "SELECT qgep_od.reach_direction_change('{{{obj_ids}}}');".format(
                obj_ids=",".join(selected_obj_ids)
            ),
            True,
        )
        reach_layer.endEditCommand()
        feedback.setProgress(100)

        return {}
