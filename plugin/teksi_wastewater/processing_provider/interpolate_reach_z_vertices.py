"""

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
    QgsProcessingAlgorithm,
    QgsProcessingParameterVectorLayer,
    QgsProcessingParameterEnum,
    QgsProcessingAlgorithm,
)
from qgis.PyQt.QtCore import QCoreApplication


from .tww_algorithm import TwwAlgorithm
from ..utils.database_utils import DatabaseUtils


__author__ = "Cyril Meder-Graf"
__date__ = "2026-04-22"
__copyright__ = "(C) 2026 by TEKSI"

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = "$Format:%H$"



class InterpolateReachZVertices(TwwAlgorithm):
    """
    Interpolate Z values of reach vertices (curve-safe, DB-backed)
    """

    REACH_LAYER = "REACH_LAYER"
    MODE = "MODE"

    def name(self):
        return "interpolate_reach_z_vertices"

    def displayName(self):
        return self.tr("Interpolate reach Z vertices")

    def flags(self):
        return super().flags() | QgsProcessingAlgorithm.FlagNoThreading

    def initAlgorithm(self, config=None):
        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.REACH_LAYER,
                description=self.tr(
                    "Selected features only – Reach layer. "
                    "Vertices with NULL/0 Z will be interpolated in the database."
                ),
            )
        )

        self.addParameter(
            QgsProcessingParameterEnum(
                self.MODE,
                self.tr("Interpolation mode"),
                options=["local", "global"],
                defaultValue=0,
            )
        )

    def processAlgorithm(self, parameters, context, feedback):
        reach_layer = self.parameterAsVectorLayer(
            parameters, self.REACH_LAYER, context
        )

        mode_idx = self.parameterAsEnum(parameters, self.MODE, context)
        mode = ["local", "global"][mode_idx]

        selected_features = list(reach_layer.getSelectedFeatures())

        if not selected_features:
            raise Exception(self.tr("No reach selected"))

        selected_obj_ids = [f["obj_id"] for f in selected_features]

        feedback.pushInfo(
            self.tr(
                f"Interpolating Z vertices for {len(selected_obj_ids)} reach(es) "
                f"using '{mode}' mode"
            )
        )

        # Start edit session (QGIS-side)
        reach_layer.startEditing()
        reach_layer.beginEditCommand("Interpolate reach Z vertices")

        transaction = reach_layer.dataProvider().transaction()
        if not transaction:
            raise Exception(
                self.tr(
                    "Layer is not in a PostgreSQL transaction – "
                    "cannot safely run interpolation"
                )
            )
        else:

            try:         
                transaction.executeSql(
                    """
                    SELECT tww_app.interpolate_reach_z_vertices(
                        %(obj_ids)s::tww_od.interlis_standardoid[],
                        %(mode)s
                    );
                    """,
                    parameters={
                        "obj_ids": selected_obj_ids,
                        "mode": mode,
                    },
                    logError=True,
                )
            except Exception:
                reach_layer.destroyEditCommand()
                raise

        reach_layer.endEditCommand()
        reach_layer.triggerRepaint()

        feedback.setProgress(100)
        return {}

