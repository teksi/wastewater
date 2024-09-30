import os
import sys
from collections import defaultdict
from enum import IntEnum

from qgis.core import Qgis
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QBrush, QColor, QFont
from qgis.PyQt.QtWidgets import QDialog, QHeaderView, QMessageBox, QTreeWidgetItem
from qgis.PyQt.uic import loadUi
from qgis.utils import iface
from sqlalchemy import inspect
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import get_history

from ...utils.qt_utils import OverrideCursor
from .editors.base import Editor

# Required for loadUi to find the custom widget
sys.path.append(os.path.join(os.path.dirname(__file__), "..", ".."))


class InterlisImportSelectionDialog(QDialog):

    class Columns(IntEnum):
        NAME = 0
        STATE = 1
        VALIDITY = 2

    class ColumnsDebug(IntEnum):
        KEY = 0
        VALUE = 1
        VALUE_OLD = 2

    def __init__(self, parent=None):
        super().__init__(parent)
        loadUi(
            os.path.join(os.path.dirname(__file__), "interlis_import_selection_dialog.ui"), self
        )

        self.accepted.connect(self.commit_session)
        self.rejected.connect(self.rollback_session)

        self.treeWidget.header().setSectionResizeMode(QHeaderView.ResizeToContents)
        self.treeWidget.header().setSectionResizeMode(self.Columns.NAME, QHeaderView.Stretch)

        self.debugTreeWidget.header().setSectionResizeMode(QHeaderView.ResizeToContents)
        self.debugTreeWidget.header().setSectionResizeMode(
            self.ColumnsDebug.KEY, QHeaderView.Interactive
        )
        self.debugTreeWidget.header().setSectionResizeMode(
            self.ColumnsDebug.VALUE, QHeaderView.Interactive
        )
        self.debugTreeWidget.hideColumn(self.ColumnsDebug.VALUE_OLD)

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
            if editor.status == Editor.EXISTING and cls.__table__.schema == "tww_vl":
                continue

            if cls not in self.category_items:
                self.category_items[cls].setText(self.Columns.NAME, cls.__name__)
                self.category_items[cls].setCheckState(self.Columns.NAME, Qt.Checked)
                self.category_items[cls].setFont(
                    self.Columns.NAME, QFont(QFont().defaultFamily(), weight=QFont.Weight.Bold)
                )
                self.treeWidget.addTopLevelItem(self.category_items[cls])

            editor.update_tree_widget_item()
            self.category_items[cls].addChild(editor.tree_widget_item)

            if editor.status != Editor.EXISTING:
                self.category_items[cls].setText(self.Columns.STATE, "*")

            if editor.validity != Editor.VALID:
                self.treeWidget.expandItem(self.category_items[cls])

        # Show counts
        for cls, category_item in self.category_items.items():
            category_item.setText(
                self.Columns.NAME, f"{cls.__name__} ({category_item.childCount()})"
            )

    def item_changed(self, item, column):
        """
        Adds or removes item's object from session.

        (propagation to parent/children is disabled for now)
        """

        checked = item.checkState(self.Columns.NAME) == Qt.Checked

        # add or remove object from session
        obj = self.get_obj_from_listitem(item)
        if obj is not None:
            if checked:
                self.session.add(obj)
            else:
                self.session.expunge(obj)

        checked_state = item.checkState(self.Columns.NAME)
        if checked_state == Qt.PartiallyChecked:
            return

        # propagate to children
        for child in [item.child(i) for i in range(item.childCount())]:
            child.setCheckState(self.Columns.NAME, checked_state)

        # propagate to parent
        parent = item.parent()
        if parent:
            has_checked = False
            has_unchecked = False
            for sibling in [parent.child(i) for i in range(parent.childCount())]:
                if sibling.checkState(self.Columns.NAME) == Qt.Checked:
                    has_checked = True
                if sibling.checkState(self.Columns.NAME) == Qt.Unchecked:
                    has_unchecked = True
                if has_checked and has_unchecked:
                    break

            if has_checked and has_unchecked:
                parent.setCheckState(self.Columns.NAME, Qt.PartiallyChecked)
            elif has_checked:
                parent.setCheckState(self.Columns.NAME, Qt.Checked)
            elif has_unchecked:
                parent.setCheckState(self.Columns.NAME, Qt.Unchecked)
            else:
                # no children at all !!
                parent.setCheckState(self.Columns.NAME, Qt.PartiallyChecked)

    def current_item_changed(self, current_item, previous_item):
        """
        Calls refresh_widget_for_obj for the currently selected object
        """
        for editor in self.editors.values():
            if editor.tree_widget_item == current_item:
                self.refresh_editor(editor)
                break
        else:
            self.debugTreeWidget.clear()
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
        editor.update_tree_widget_item()

        # Update generic widget contents
        self.validityLabel.clear()
        self.debugTreeWidget.clear()

        if editor.status == Editor.MODIFIED:
            self.debugTreeWidget.showColumn(self.ColumnsDebug.VALUE_OLD)
        else:
            self.debugTreeWidget.hideColumn(self.ColumnsDebug.VALUE_OLD)

        # Show all attributes in the debug text edit
        treeWidgetItemAttributes = QTreeWidgetItem()
        treeWidgetItemAttributes.setText(self.ColumnsDebug.KEY, "Attributes")
        for attribute in inspect(editor.obj).mapper.column_attrs:
            treeWidgetItemAttribute = QTreeWidgetItem()
            treeWidgetItemAttribute.setText(self.ColumnsDebug.KEY, attribute.key)
            val = getattr(editor.obj, attribute.key)
            if val is not None:
                treeWidgetItemAttribute.setText(self.ColumnsDebug.VALUE, f"{val}")

            if editor.status == Editor.MODIFIED:

                history = get_history(editor.obj, attribute.key)

                value_old = None
                if history.unchanged != ():
                    value_old = history.unchanged[0]

                if history.deleted != ():
                    value_old = history.deleted[0]

                if value_old is not None:
                    treeWidgetItemAttribute.setText(self.ColumnsDebug.VALUE_OLD, f"{value_old}")

                if val != value_old:
                    brush = QBrush(QColor("orange"))
                    treeWidgetItemAttribute.setBackground(self.ColumnsDebug.KEY, brush)
                    treeWidgetItemAttribute.setBackground(self.ColumnsDebug.VALUE, brush)
                    treeWidgetItemAttribute.setBackground(self.ColumnsDebug.VALUE_OLD, brush)

            treeWidgetItemAttributes.addChild(treeWidgetItemAttribute)

        self.debugTreeWidget.addTopLevelItem(treeWidgetItemAttributes)
        self.debugTreeWidget.expandItem(treeWidgetItemAttributes)

        # Debug
        treeWidgetItemDebug = QTreeWidgetItem()
        treeWidgetItemDebug.setText(self.ColumnsDebug.KEY, "Debug")

        #   Show sqlalchemy state in the debug text edit
        sqlAlchemyStates = []
        for status_name in [
            "transient",
            "pending",
            "persistent",
            "deleted",
            "detached",
            "modified",
            "expired",
        ]:
            if getattr(inspect(editor.obj), status_name):
                sqlAlchemyStates.append(f"{status_name}")

        treeWidgetItemSqlAlchemyState = QTreeWidgetItem()
        treeWidgetItemSqlAlchemyState.setText(self.ColumnsDebug.KEY, "Sql Alchemy status")
        treeWidgetItemSqlAlchemyState.setText(self.ColumnsDebug.VALUE, ", ".join(sqlAlchemyStates))
        treeWidgetItemDebug.addChild(treeWidgetItemSqlAlchemyState)

        treeWidgetItemEditorObject = QTreeWidgetItem()
        treeWidgetItemEditorObject.setText(self.ColumnsDebug.KEY, "Editor object")
        treeWidgetItemEditorObject.setText(self.ColumnsDebug.VALUE, repr(editor.obj))
        treeWidgetItemDebug.addChild(treeWidgetItemEditorObject)

        self.debugTreeWidget.addTopLevelItem(treeWidgetItemDebug)
        self.debugTreeWidget.resizeColumnToContents(self.ColumnsDebug.KEY)

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
        try:
            with OverrideCursor(Qt.WaitCursor):
                self.session.commit()
                self.session.close()
        except Exception as exception:
            QMessageBox.critical(self, "Import error", f"Details: {exception}")
            return

        if iface:
            iface.messageBar().pushMessage(
                "Sucess", "Data successfully imported", level=Qgis.Success
            )

    def rollback_session(self):
        with OverrideCursor(Qt.WaitCursor):
            self.session.rollback()
            self.session.close()

        if iface:
            iface.messageBar().pushMessage("Error", "Import was canceled", level=Qgis.Warning)

    def get_obj_from_listitem(self, listitem):
        for obj, editor in self.editors.items():
            if editor.tree_widget_item == listitem:
                return obj
        return None
