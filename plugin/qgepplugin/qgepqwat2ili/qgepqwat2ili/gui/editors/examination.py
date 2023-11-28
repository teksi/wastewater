from itertools import chain

from qgis.core import QgsFeature, QgsProject
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QHeaderView, QListWidgetItem, QTreeWidgetItem
from qgis.utils import iface
from sqlalchemy.orm import aliased

from ...qgep.model_qgep import get_qgep_model
from .base import Editor


class ExaminationEditor(Editor):

    class_name = "examination"
    widget_name = "examination.ui"

    def preprocess(self):
        # We auto assign all examinations that have exactly one suggested structure,
        # as 99% of the time, this will be a good match

        QGEP = get_qgep_model()
        suggested_structures = self._get_suggested_structures()
        # TODO : Only assign if there's no already assigned structures. For now, this is fine, as due to
        # ili2pg's limitations, assigned structures are not imported (see import_.py:968 near `if row.abwasserbauwerkref`)
        if len(suggested_structures) == 1:
            assigned_structure = suggested_structures[0]

            exam_to_wastewater_structure = QGEP.re_maintenance_event_wastewater_structure(
                fk_wastewater_structure=assigned_structure.obj_id,
                fk_maintenance_event=self.obj.obj_id,
            )
            self.session.add(exam_to_wastewater_structure)

    def init_widget(self):
        self.reach_layer = QgsProject.instance().mapLayersByName("vw_qgep_reach")[0]
        self.widget.selectorWidget.set_layer(self.reach_layer)
        self.widget.selectorWidget.set_canvas(iface.mapCanvas())
        # self.widget.assignButton.pressed.connect(self.assign_button_clicked)  # doesn't work ?!
        self.widget.assignButton.pressed.connect(lambda: self._assign_button_clicked())
        self.widget.unassignButton.pressed.connect(lambda: self._unassign_button_clicked())
        self.widget.suggestedListWidget.currentItemChanged.connect(self._suggested_reach_changed)
        self.widget.damagesTreeWidget.itemChanged.connect(self._damages_item_changed)
        self.update_widget()

    def update_widget(self):
        # 1. Populate suggested structures
        self.widget.suggestedListWidget.clear()
        for structure in self._get_suggested_structures():
            widget_item = QListWidgetItem(f"Structure {structure.obj_id}/{structure.identifier}")
            widget_item.setData(Qt.UserRole, structure.obj_id)
            self.widget.suggestedListWidget.addItem(widget_item)

        # 2. Populated assigned structures
        self.widget.assignedWidget.clear()
        for structure in self._get_assigned_structures():
            widget_item = QListWidgetItem(f"Structure {structure.obj_id}/{structure.identifier}")
            widget_item.setData(Qt.UserRole, structure.obj_id)
            self.widget.assignedWidget.addItem(widget_item)

        # 3. Populate child damages
        self.widget.damagesTreeWidget.clear()
        for damage in self._get_child_damages():
            editor = self.main_dialog.editors.get(damage, None)
            widget_item = QTreeWidgetItem()
            widget_item.setData(0, Qt.UserRole, damage.obj_id)
            if editor:  # there may be items that are already in the DB
                widget_item.setCheckState(0, editor.listitem.checkState(0))
            widget_item.setText(1, str(damage.distance))
            widget_item.setText(
                2, damage.channel_damage_code__REL.value_de if damage.channel_damage_code__REL else ""
            )
            widget_item.setText(3, damage.comments)
            self.widget.damagesTreeWidget.addTopLevelItem(widget_item)
        self.widget.damagesTreeWidget.header().setSectionResizeMode(QHeaderView.ResizeToContents)

    def validate(self):
        count = len(list(self._get_assigned_structures()))
        if count == 0:
            self.validity = Editor.WARNING
            self.message = "Not associated any wastewater structures."
        elif count == 1:
            self.validity = Editor.VALID
            self.message = "Assigned"
        else:
            self.validity = Editor.WARNING
            self.message = f"Associated to more than one ({count}) wastewater structures. This is allowed by the datamodel, but discouraged."

    def _suggested_reach_changed(self, current_item, _previous_item):
        if current_item is None:
            # No selection
            self.widget.selectorWidget.set_feature(None)
            return

        obj_id = current_item.data(Qt.UserRole)
        features = self.reach_layer.getFeatures(f"ws_obj_id = '{obj_id}'")
        try:
            feature = next(features)
        except StopIteration:
            # Not found
            return
        self.widget.selectorWidget.set_feature(feature)

    def _assign_button_clicked(self):

        feature: QgsFeature = self.widget.selectorWidget.feature

        if feature is None:
            # selectorWidget was empty
            return

        QGEP = get_qgep_model()

        exam_to_wastewater_structure = QGEP.re_maintenance_event_wastewater_structure(
            fk_wastewater_structure=feature["ws_obj_id"],
            fk_maintenance_event=self.obj.obj_id,
        )
        self.session.add(exam_to_wastewater_structure)

        self.main_dialog.refresh_editor(self)
        self.main_dialog.update_tree()

    def _unassign_button_clicked(self):
        QGEP = get_qgep_model()

        structure_id = self.widget.assignedWidget.currentItem().data(Qt.UserRole)
        self.session.query(QGEP.re_maintenance_event_wastewater_structure).filter(
            QGEP.re_maintenance_event_wastewater_structure.fk_maintenance_event == self.obj.obj_id
        ).filter(QGEP.re_maintenance_event_wastewater_structure.fk_wastewater_structure == structure_id).delete()

        # also uncheck relations that have not yet been flushed to DB
        for rel in [i for i in self.session.new if isinstance(i, QGEP.re_maintenance_event_wastewater_structure)]:
            if rel.fk_maintenance_event == self.obj.obj_id and rel.fk_wastewater_structure == structure_id:
                if rel in self.main_dialog.editors:
                    self.main_dialog.editors[rel].listitem.setCheckState(0, False)

        self.main_dialog.refresh_editor(self)
        self.main_dialog.update_tree()

    def _damages_item_changed(self, item, column):
        QGEP = get_qgep_model()
        check_state = item.checkState(0)
        damage_id = item.data(0, Qt.UserRole)
        for obj, editor in self.main_dialog.editors.items():
            if isinstance(obj, QGEP.damage_channel) and obj.obj_id == damage_id:
                # Forward the check event to the main tree
                editor.listitem.setCheckState(0, check_state)
                break

    def _get_suggested_structures(self):

        from_id = self.obj.from_point_identifier
        to_id = self.obj.to_point_identifier

        if from_id is not None and to_id is not None:
            # If both from/to point identifier are set, we are trying to find a channel
            structures_nrm = self._get_suggested_structures_for_channel(from_id, to_id)
            structures_rev = self._get_suggested_structures_for_channel(to_id, from_id)
            return list(structures_nrm) + list(structures_rev)
        elif from_id is not None:
            # If just from point identifier is set, we are trying to find a manhole
            structures = self._get_suggested_structures_for_manhole(from_id)
            return list(structures)
        else:
            # Otherwise we don't have anything to suggest
            return []

    def _get_suggested_structures_for_channel(self, from_id, to_id):

        QGEP = get_qgep_model()

        wastewater_ne_from = aliased(QGEP.wastewater_networkelement)
        wastewater_ne_to = aliased(QGEP.wastewater_networkelement)
        rp_from = aliased(QGEP.reach_point)
        rp_to = aliased(QGEP.reach_point)
        wastewater_st_from = aliased(QGEP.wastewater_structure)
        wastewater_st_to = aliased(QGEP.wastewater_structure)

        return (
            self.session.query(QGEP.wastewater_structure)
            .join(QGEP.reach)
            .join(rp_from, rp_from.obj_id == QGEP.reach.fk_reach_point_from)
            .join(wastewater_ne_from, wastewater_ne_from.obj_id == rp_from.fk_wastewater_networkelement)
            .join(wastewater_st_from, wastewater_st_from.obj_id == wastewater_ne_from.fk_wastewater_structure)
            .join(rp_to, rp_to.obj_id == QGEP.reach.fk_reach_point_to)
            .join(wastewater_ne_to, wastewater_ne_to.obj_id == rp_to.fk_wastewater_networkelement)
            .join(wastewater_st_to, wastewater_st_to.obj_id == wastewater_ne_to.fk_wastewater_structure)
            .filter(wastewater_st_from.identifier == from_id, wastewater_st_to.identifier == to_id)
        )

    def _get_suggested_structures_for_manhole(self, from_id):

        QGEP = get_qgep_model()

        return self.session.query(QGEP.wastewater_structure).filter(QGEP.wastewater_structure.identifier == from_id)

    def _get_assigned_structures(self):

        QGEP = get_qgep_model()

        structures_from_db = (
            self.session.query(QGEP.wastewater_structure)
            .join(QGEP.re_maintenance_event_wastewater_structure)
            .filter(QGEP.re_maintenance_event_wastewater_structure.fk_maintenance_event == self.obj.obj_id)
        )

        # also retrieve structures from relations that have not yet been flushed to DB
        structures_in_session = [
            self.session.query(QGEP.wastewater_structure).get(rel.fk_wastewater_structure)
            for rel in self.session
            if isinstance(rel, QGEP.re_maintenance_event_wastewater_structure)
            and rel.fk_maintenance_event == self.obj.obj_id
        ]

        seen = set()
        for instance in chain(structures_in_session, structures_from_db):
            if instance not in seen:
                seen.add(instance)
                yield instance

    def _get_child_damages(self):
        QGEP = get_qgep_model()

        from_db = self.session.query(QGEP.damage_channel).filter(
            QGEP.damage_channel.fk_examination == self.obj.obj_id
        )

        in_session = [
            inst
            for inst in self.main_dialog.editors.keys()
            if isinstance(inst, QGEP.damage_channel) and inst.fk_examination == self.obj.obj_id
        ]

        seen = set()
        for instance in sorted(chain(in_session, from_db), key=lambda d: d.distance):
            if instance not in seen:
                seen.add(instance)
                yield instance
