import os
from collections import defaultdict

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QBrush, QColor
from qgis.PyQt.QtWidgets import QTreeWidgetItem, QWidget
from qgis.PyQt.uic import loadUi
from sqlalchemy import inspect


class Editor:
    """
    Base class to manage import options for TWW classes.

    Editor subclasses are responsible of:
    - managing a listwidgetitem
    - providing a widget to edit options
    - change the current session objects according to widget interaction
    - validate objects according to the current session
    """

    # Validity
    INVALID = "INVALID"
    UNKNOWN = "UNKNOWN"
    WARNING = "WARNING"
    VALID = "VALID"

    # State
    NEW = "NEW"
    DELETED = "DELETED"
    MODIFIED = "MODIFIED"
    EXISTING = "EXISTING"

    class_name = "base"
    widget_name = "base.ui"

    registry = defaultdict(lambda: Editor)

    def __init_subclass__(cls):
        """
        Populates Editor.registry
        """
        Editor.registry[cls.class_name] = cls

    @staticmethod
    def factory(main_dialog, session, obj):
        """
        Creates an Editor instance, choosing the correct subclass from the registry
        """
        editor_class = Editor.registry[obj.__class__.__name__]
        return editor_class(main_dialog, session, obj)

    def __init__(self, main_dialog, session, obj):
        self.main_dialog = main_dialog
        self.session = session
        self.obj = obj

        self._tree_widget_item = None

        self.preprocess()

        self.update_state()

    @property
    def tree_widget_item(self):
        """
        The editor's QTreeWidgetItem (created on the fly if needed)
        """
        if self._tree_widget_item is None:
            self.update_tree_widget_item()

        return self._tree_widget_item

    def update_tree_widget_item(self):
        if self._tree_widget_item is None:
            self._tree_widget_item = QTreeWidgetItem()
            self._tree_widget_item.setCheckState(
                0, Qt.Checked if self.initially_checked() else Qt.Unchecked
            )

        disp_id = str(
            getattr(self.obj, "obj_id", getattr(self.obj, "value_en", "?"))
        )  # some elements may not have obj_id, such as value_lists
        self._tree_widget_item.setText(0, getattr(self.obj, "identifier", disp_id))
        self._tree_widget_item.setToolTip(0, disp_id)

        self._tree_widget_item.setText(1, self.status)

        self._tree_widget_item.setText(2, self.validity)
        if self.status == Editor.EXISTING:
            color = "lightgray"
        elif self.validity == Editor.INVALID:
            color = "red"
        elif self.validity == Editor.WARNING:
            color = "orange"
        elif self.validity == Editor.VALID:
            color = "lightgreen"
        else:
            color = "lightgray"
        self._tree_widget_item.setBackground(2, QBrush(QColor(color)))

    @property
    def widget(self):
        """
        The editor's widget (created on the fly if needed)
        """
        if not hasattr(self, "_widget"):

            class BaseWidget(QWidget):
                pass

            self._widget = BaseWidget()
            loadUi(os.path.join(os.path.dirname(__file__), self.widget_name), self._widget)
            self.init_widget()
        return self._widget

    def preprocess(self):
        """
        Run some preprocessing steps (such as auto-assigning data)... To be overriden by subclasses.
        """

    def init_widget(self):
        """
        Initialize the widget here, for things like connecting signals... To be overriden by subclasses.
        """

    def update_widget(self):
        """
        Update the widget here, for things like repopulating from session... To be overriden by subclasses.
        """

    def update_state(self):
        """
        Updates status and calls validate. Call this when the underlying object may have changed.
        """
        obj_inspect = inspect(self.obj)
        if obj_inspect.pending:
            self.status = Editor.NEW
        elif obj_inspect.deleted:
            self.status = Editor.DELETED
        elif obj_inspect.persistent:
            self.status = Editor.EXISTING
        else:
            self.status = Editor.UNKNOWN

        # For modified use the session is_modified method (slower but more correct)
        if self.session.is_modified(self.obj):
            self.status = Editor.MODIFIED

        self.validate()

    def validate(self):
        """
        Updates validity and message. To be overriden by subclasses. You should probably call update_state if you need to revalidate.
        """
        self.validity = Editor.VALID
        self.message = "No validity check"

    def initially_checked(self):
        """
        Determines if the item must be initially checked. To be overriden by subclasses.
        """
        return True
