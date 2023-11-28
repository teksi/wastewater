import os
import sys
from collections import defaultdict

from qgis.core import Qgis
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QFont
from qgis.PyQt.QtWidgets import QDialog, QHeaderView, QTreeWidgetItem
from qgis.PyQt.uic import loadUi
from qgis.utils import iface
from sqlalchemy import inspect
from sqlalchemy.orm import Session

from ..qgep.model_qgep import get_qgep_model
from .editors.base import Editor

# Required for loadUi to find the custom widget
sys.path.append(os.path.join(os.path.dirname(__file__), "..", ".."))


class GuiImport(QDialog):
    def __init__(self, parent):
        super().__init__(parent)
        loadUi(os.path.join(os.path.dirname(__file__), "gui_import.ui"), self)

        self.accepted.connect(self.commit_session)
        self.rejected.connect(self.rollback_session)

        header = self.treeWidget.header()
        header.setSectionResizeMode(QHeaderView.ResizeToContents)
        header.setSectionResizeMode(0, QHeaderView.Stretch)

        # No required here, but this way we load before opening the dialog
        get_qgep_model()

    def init_with_session(self, session: Session):
        """
        Shows the dialog with data from a session, and executes the dialog allowing to filter the rows to import
        """
        self.session = session

        self.category_items = defaultdict(QTreeWidgetItem)  # keys are instances' classes
        self.editors = {}

        self.debugGroupBox.setChecked(False)

        self.treeWidget.clear()
        self.update_tree()

        self.treeWidget.itemChanged.connect(self.item_changed)
        self.treeWidget.currentItemChanged.connect(self.current_item_changed)

        # Execute the dialog
        self.resize(iface.mainWindow().size() * 0.75)
        self.show()

    def update_tree(self):
        """
        Populates the tree, creating/updating items
        """

        for obj in self.session:
            if obj not in self.editors:
                self.editors[obj] = Editor.factory(self, self.session, obj)
            editor = self.editors[obj]

            cls = obj.__class__

            # Hide unmodified value lists items that may have been added to the session
            if editor.status == Editor.EXISTING and cls.__table__.schema == "qgep_vl":
                continue

            if cls not in self.category_items:
                self.category_items[cls].setText(0, cls.__name__)
                # self.category_items[cls].setCheckState(0, Qt.Checked)  # for now we remove per class checkboxes
                self.category_items[cls].setFont(0, QFont(QFont().defaultFamily(), weight=QFont.Weight.Bold))
                self.treeWidget.addTopLevelItem(self.category_items[cls])

            editor.update_listitem()
            self.category_items[cls].addChild(editor.listitem)

            if editor.validity != Editor.VALID:
                self.treeWidget.expandItem(self.category_items[cls])

        # Show counts
        for cls, category_item in self.category_items.items():
            category_item.setText(0, f"{cls.__name__} ({category_item.childCount()})")

    def item_changed(self, item, column):
        """
        Adds or removes item's object from session.

        (propagation to parent/children is disabled for now)
        """

        checked = item.checkState(0) == Qt.Checked

        # add or remove object from session
        obj = self.get_obj_from_listitem(item)
        if obj is not None:
            if checked:
                self.session.add(obj)
            else:
                self.session.expunge(obj)

        # For now we remove per class checkboxes

        # checked_state = item.checkState(0)

        # if checked_state == Qt.PartiallyChecked:
        #     return

        # # propagate to children
        # for child in [item.child(i) for i in range(item.childCount())]:
        #     child.setCheckState(0, checked_state)

        # # propagate to parent
        # parent = item.parent()
        # if parent:
        #     has_checked = False
        #     has_unchecked = False
        #     for sibling in [parent.child(i) for i in range(parent.childCount())]:
        #         if sibling.checkState(0) == Qt.Checked:
        #             has_checked = True
        #         if sibling.checkState(0) == Qt.Unchecked:
        #             has_unchecked = True
        #         if has_checked and has_unchecked:
        #             break

        #     if has_checked and has_unchecked:
        #         parent.setCheckState(0, Qt.PartiallyChecked)
        #     elif has_checked:
        #         parent.setCheckState(0, Qt.Checked)
        #     elif has_unchecked:
        #         parent.setCheckState(0, Qt.Unchecked)
        #     else:
        #         # no children at all !!
        #         parent.setCheckState(0, Qt.PartiallyChecked)

    def current_item_changed(self, current_item, previous_item):
        """
        Calls refresh_widget_for_obj for the currently selected object
        """
        for editor in self.editors.values():
            if editor.listitem == current_item:
                self.refresh_editor(editor)
                break
        else:
            self.debugTextEdit.clear()
            self.validityLabel.clear()
            current_widget = self.stackedWidget.currentWidget()
            if current_widget:
                self.stackedWidget.removeWidget(current_widget)

    def refresh_editor(self, editor):
        """
        Refreshes the widget for the object, including validation, debug and status text
        """
        # Revalidate the widget
        editor.update_state()

        # Update the list item
        editor.update_listitem()

        # Update generic widget contents
        self.debugTextEdit.clear()
        self.validityLabel.clear()

        #   Show all attributes in the debug text edit
        self.debugTextEdit.append("-- ATTRIBUTES --")
        for c in inspect(editor.obj).mapper.column_attrs:
            val = getattr(editor.obj, c.key)
            self.debugTextEdit.append(f"{c.key}: {val}")
        #   Show sqlalchemy state in the debug text edit
        self.debugTextEdit.append("-- SQLALCHEMY STATUS --")
        for status_name in ["transient", "pending", "persistent", "deleted", "detached", "modified", "expired"]:
            if getattr(inspect(editor.obj), status_name):
                self.debugTextEdit.append(f"{status_name} ")
        self.debugTextEdit.append("-- DEBUG --")
        self.debugTextEdit.append(repr(editor.obj))

        #   Show the validity label
        self.validityLabel.setText(editor.message)
        if editor.validity == Editor.INVALID:
            self.validityLabel.setStyleSheet("background-color: red; padding: 15px;")
        elif editor.validity == Editor.WARNING:
            self.validityLabel.setStyleSheet("background-color: orange; padding: 15px;")
        elif editor.validity == Editor.VALID:
            self.validityLabel.setStyleSheet("background-color: lightgreen; padding: 15px;")
        else:
            self.validityLabel.setStyleSheet("background-color: lightgray; padding: 15px;")

        # Update the actual widget
        editor.update_widget()

        # Instantiate the specific widget (this has no effect if it's already active)
        self.stackedWidget.addWidget(editor.widget)
        self.stackedWidget.setCurrentWidget(editor.widget)

    def commit_session(self):
        # TODO : rollback to pre-commit state, allowing user to try to fix issues
        # probably a matter of creating a savepoint before saving with
        # session.begin_nested() and one additionnal self.session.commit()
        self.session.commit()
        self.session.close()
        iface.messageBar().pushMessage("Sucess", "Data successfully imported", level=Qgis.Success)

    def rollback_session(self):
        self.session.rollback()
        self.session.close()
        iface.messageBar().pushMessage("Error", "Import was canceled", level=Qgis.Warning)

    def get_obj_from_listitem(self, listitem):
        for obj, editor in self.editors.items():
            if editor.listitem == listitem:
                return obj
        return None
