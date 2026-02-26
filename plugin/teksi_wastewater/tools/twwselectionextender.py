from __future__ import annotations

from collections.abc import Iterable

from qgis.core import Qgis, QgsFeatureRequest
from qgis.PyQt.QtCore import QObject

from ..utils.twwlayermanager import TwwLayerManager


class TwwSelectionExtender(QObject):
    def __init__(self, iface):
        super().__init__()
        self.iface = iface
        self._saved_reach_fids = set()

    def run(self):
        self.extend_selection()

    def tr(self, text):
        return self.iface.mainWindow().tr(text)

    def extend_selection(self, mode: str = "add", status: str = "current") -> None:
        """
        mode: 'replace' | 'add' | 'remove' | 'intersect'
        status: 'current' | 'planned'
        """

        # Load layers
        reach_layer = TwwLayerManager.layer("vw_tww_reach")
        structure_layer = TwwLayerManager.layer("vw_tww_wastewater_structure")
        node_layer = TwwLayerManager.layer("vw_wastewater_node")
        catchment_layer = TwwLayerManager.layer("vw_tww_catchment_area")

        if not reach_layer:
            self._msg(
                self.tr("Selection Extender"),
                self.tr("Layer vw_tww_reach not loaded."),
                Qgis.Warning,
            )

        selected_reach_fids = reach_layer.selectedFeatureIds()
        if not selected_reach_fids:
            self._msg(
                self.tr("Selection Extender"),
                self.tr("No selected reaches in vw_tww_reach. Reaches selection reset"),
                Qgis.Info,
            )
            self.reset()
            return

        # Collect node obj_ids from selected reaches
        node_obj_ids = self._collect_node_obj_ids_from_reaches(reach_layer, selected_reach_fids)

        # Select nodes
        if node_layer and node_obj_ids:
            node_target_fids = self._find_fids_by_obj_id(node_layer, "obj_id", node_obj_ids)
            self._apply_selection(node_layer, node_target_fids, mode)

        # Select structures linked to nodes
        if structure_layer and node_obj_ids:
            structure_target_fids = self._find_fids_by_obj_id(
                structure_layer, "wn_obj_id", node_obj_ids
            )
            self._apply_selection(structure_layer, structure_target_fids, mode)

        # Select catchments linked to nodes
        catch_target_fids=set()
        if catchment_layer and node_obj_ids:
            catch_target_fids = self._find_catchment_fids(catchment_layer, node_obj_ids, status)
            self._apply_selection(catchment_layer, catch_target_fids, mode)

        # Select corresponding reaches
        seed = set(reach_layer.selectedFeatureIds())
        base = set(self._saved_reach_fids)
        self._saved_reach_fids = self._combine_sets(base, seed, mode)
        reach_layer.removeSelection()
        reach_layer.select(list(self._saved_reach_fids))

        self._msg(
            self.tr("Selection Extender"),
            self.tr(
                f"Extended selection: reaches={len(selected_reach_fids)}, nodes={len(node_obj_ids)}, catchments={len(catch_target_fids)}"
            ),
            Qgis.Success,
        )

    def _collect_node_obj_ids_from_reaches(
        self, reach_layer, reach_fids: Iterable[int]
    ) -> set[str]:
        obj_ids: set[str] = set()

        req = QgsFeatureRequest().setFilterFids(list(reach_fids))
        for f in reach_layer.getFeatures(req):
            from_id = f["rp_from_fk_wastewater_networkelement"]
            to_id = f["rp_to_fk_wastewater_networkelement"]

            if isinstance(from_id, str) and from_id:
                obj_ids.add(from_id)
            if isinstance(to_id, str) and to_id:
                obj_ids.add(to_id)

        return obj_ids

    def _find_fids_by_obj_id(self, layer, id_field: str, obj_ids: set[str]) -> set[int]:
        if not obj_ids:
            return set()

        quoted = ",".join("'" + s.replace("'", "''") + "'" for s in obj_ids)
        expr = f"{id_field} IN ({quoted})"

        req = QgsFeatureRequest().setFilterExpression(expr)
        return {f.id() for f in layer.getFeatures(req)}

    def _find_catchment_fids(self, layer, node_obj_ids: set[str], status: str) -> set[int]:
        if not node_obj_ids:
            return set()

        quoted = ",".join("'" + s.replace("'", "''") + "'" for s in node_obj_ids)

        if status == "planned":
            fields = [
                "fk_wastewater_networkelement_ww_planned",
                "fk_wastewater_networkelement_rw_planned",
            ]
        else:
            fields = [
                "fk_wastewater_networkelement_ww_current",
                "fk_wastewater_networkelement_rw_current",
            ]

        expr = " OR ".join([f"{fld} IN ({quoted})" for fld in fields])
        req = QgsFeatureRequest().setFilterExpression(expr)
        return {f.id() for f in layer.getFeatures(req)}

    def _apply_selection(self, layer, target_fids: set[int], mode: str) -> None:
        current = set(layer.selectedFeatureIds())
        target = set(target_fids)
        layer.removeSelection()

        final = self._combine_sets(current, target, mode)

        layer.select(list(final))

    def _combine_sets(self, base: set[int], seed: set[int], mode: str) -> set[int]:
        if mode == "replace":
            return seed
        if mode == "add":
            return base | seed
        if mode == "remove":
            return base - seed
        if mode == "intersect":
            return base & seed
        return base | seed

    def reset(self):
        self._saved_reach_fids.clear()

        reach_layer = TwwLayerManager.layer("vw_tww_reach")
        if reach_layer:
            reach_layer.removeSelection()

    def _msg(self, title: str, text: str, level: Qgis.MessageLevel) -> None:
        self.iface.messageBar().pushMessage(title, text, level=level, duration=4)
