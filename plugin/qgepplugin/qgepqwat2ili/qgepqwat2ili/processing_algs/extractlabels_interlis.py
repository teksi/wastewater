import json
import os
import tempfile
import uuid
from functools import partial

from PyQt5.QtCore import QCoreApplication
from qgis import processing
from qgis.core import (
    QgsProcessingContext,
    QgsProcessingFeedback,
    QgsProcessingParameterBoolean,
    QgsProcessingParameterEnum,
    QgsProcessingParameterFileDestination,
    QgsProcessingParameterVectorLayer,
    QgsWkbTypes,
)

from qgepplugin.processing_provider.qgep_algorithm import QgepAlgorithm

from ....utils.qgeplayermanager import QgepLayerManager


class ExtractlabelsInterlisAlgorithm(QgepAlgorithm):
    """This runs the native extractlabels algorithm for the given scales, and attaches obj_id and scale to the results.

    Otherwise, the output is difficult to use, because the FeatureID isn't stable (since it's the primary
    key of the reach and structure views is not an integer)"""

    tr = partial(QCoreApplication.translate, "ExtractlabelsInterlisAlgorithm")
    AVAILABLE_SCALES = [
        # ili key, display name, scale value
        ("Leitungskataster", tr("Leitungskataster"), 1000),  # TODO: check scale ?
        ("Werkplan", tr("Werkplan"), 500),  # TODO: check scale ?
        ("Uebersichtsplan.UeP10", tr("Uebersichtsplan 1:10000"), 10000),
        ("Uebersichtsplan.UeP5", tr("Uebersichtsplan 1:5000"), 5000),
        ("Uebersichtsplan.UeP2", tr("Uebersichtsplan 1:2000"), 2000),
    ]

    OUTPUT = "OUTPUT"
    INPUT_RESTRICT_TO_SELECTION = "RESTRICT_TO_SELECTION"
    INPUT_SCALES = "SCALES"
    INPUT_STRUCTURE_VIEW_LAYER = "STRUCTURE_VIEW_LAYER"
    INPUT_REACH_VIEW_LAYER = "REACH_VIEW_LAYER"

    def name(self):
        return "extractlabels_interlis"

    def displayName(self):
        return self.tr("Extract labels for interlis")

    def initAlgorithm(self, config=None):

        self.addParameter(
            QgsProcessingParameterFileDestination(
                self.OUTPUT,
                description=self.tr("Output labels file"),
                fileFilter="geojson (*.geojson)",
            )
        )

        self.addParameter(
            QgsProcessingParameterBoolean(
                self.INPUT_RESTRICT_TO_SELECTION,
                description=self.tr("Restrict to selection"),
            )
        )

        self.addParameter(
            QgsProcessingParameterEnum(
                self.INPUT_SCALES,
                description=self.tr("Scales to export"),
                allowMultiple=True,
                options=[f"{self.tr(i[1])} [1:{i[2]}]" for i in self.AVAILABLE_SCALES],
                defaultValue=[i for i in range(len(self.AVAILABLE_SCALES))],
            )
        )

        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.INPUT_STRUCTURE_VIEW_LAYER,
                description=self.tr("Structure view layer"),
                types=[QgsWkbTypes.PointGeometry],
            )
        )

        self.addParameter(
            QgsProcessingParameterVectorLayer(
                self.INPUT_REACH_VIEW_LAYER,
                description=self.tr("Reach view layer"),
                types=[QgsWkbTypes.LineGeometry],
            )
        )

    def processAlgorithm(self, parameters, context: QgsProcessingContext, feedback: QgsProcessingFeedback):

        labels_file_path = self.parameterAsFileOutput(parameters, self.OUTPUT, context)
        restrict_to_selection = self.parameterAsBoolean(parameters, self.INPUT_RESTRICT_TO_SELECTION, context)
        structure_view_layer = self.parameterAsVectorLayer(parameters, self.INPUT_STRUCTURE_VIEW_LAYER, context)
        reach_view_layer = self.parameterAsVectorLayer(parameters, self.INPUT_REACH_VIEW_LAYER, context)
        scales = [self.AVAILABLE_SCALES[i] for i in self.parameterAsEnums(parameters, self.INPUT_SCALES, context)]

        # Clear the output file if it exists
        if os.path.isfile(labels_file_path):
            os.remove(labels_file_path)

        # Compute the extent
        if restrict_to_selection:
            extent = structure_view_layer.boundingBoxOfSelected()
            extent.combineExtentWith(reach_view_layer.boundingBoxOfSelected())
        else:
            extent = structure_view_layer.extent()
            extent.combineExtentWith(reach_view_layer.extent())

        # Store a mapping from FeatureID to obj_id (used below)
        reach_feats = reach_view_layer.getFeatures()
        structure_feats = structure_view_layer.getFeatures()
        rowid_to_obj_id = {
            "vw_qgep_reach": {f.id(): f.attribute("obj_id") for f in reach_feats},
            "vw_qgep_wastewater_structure": {f.id(): f.attribute("obj_id") for f in structure_feats},
        }

        annotated_paths = []

        # Extract all labels at all scales
        for scale_id, scale_display, scale_value in scales:

            # Make an unique temporary name
            unique = uuid.uuid4().hex
            extract_path = os.path.join(tempfile.gettempdir(), f"labels-{scale_id}_{unique}.geojson")

            # Extract the labels
            feedback.pushInfo(f"Extracting labels for scale {scale_display} [1:{scale_value}]")
            processing.run(
                "native:extractlabels",
                {
                    "DPI": 96,  # TODO: check what this changes
                    "EXTENT": extent,
                    "INCLUDE_UNPLACED": True,
                    "MAP_THEME": None,
                    "OUTPUT": extract_path,
                    "SCALE": scale_value,
                },
                # this is a child algotihm
                is_child_algorithm=True,
                context=context,
                feedback=feedback,
            )

            # Load the extracted labels
            with open(extract_path, "r") as extract_path_handle:
                geojson = json.load(extract_path_handle)

            # Check that labels were generated
            labels_count = len(geojson["features"])
            feedback.pushInfo(f"{labels_count} labels generated")
            if labels_count == 0:
                continue

            # Annotate features with qgep_obj_id and scal
            lyr_name_to_key = {
                QgepLayerManager.layer("vw_qgep_wastewater_structure").name(): "vw_qgep_wastewater_structure",
                QgepLayerManager.layer("vw_qgep_reach").name(): "vw_qgep_reach",
            }
            for label in geojson["features"]:
                layer_name = label["properties"]["Layer"]
                # this is a non-QGEP layer, we don't annotate it
                if layer_name not in lyr_name_to_key:
                    continue
                lyr = lyr_name_to_key[layer_name]
                rowid = label["properties"]["FeatureID"]
                label["properties"]["Layer"] = lyr
                label["properties"]["qgep_obj_id"] = rowid_to_obj_id[lyr][rowid]
                label["properties"]["scale"] = scale_id

            # Save
            annotated_path = extract_path + ".annotated.geojson"
            with open(annotated_path, "w") as annotated_path_handle:
                json.dump(geojson, annotated_path_handle)

            annotated_paths.append(annotated_path)

        # time.sleep(60)

        # Merge all scales to one geojson
        feedback.pushInfo(f"Merging all labels ({annotated_paths}) to {labels_file_path}")
        processing.run(
            "native:mergevectorlayers",
            {
                "LAYERS": annotated_paths,
                "OUTPUT": labels_file_path,
            },
            # this is a child algotihm
            is_child_algorithm=True,
            context=context,
            feedback=feedback,
        )

        feedback.setProgress(100)

        return {}
