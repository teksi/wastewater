from qgis.core import Qgis
from qgis.PyQt.QtCore import QSize
from qgis.PyQt.QtWidgets import QApplication, QDockWidget

from ..utils import get_ui_class

DOCK_WIDGET_UI = get_ui_class("twwselectionextenderwidget.ui")


class TwwSelectionExtenderWidget(QDockWidget, DOCK_WIDGET_UI):

    def __init__(self, iface, parent=None):
        super().__init__(parent)
        self.iface = iface
        self.controller = None
        self.setupUi(self)
        self.setMinimumSize(QSize(260, 220))

        self.Select.clicked.connect(self._on_select_clicked)
        self.reset.clicked.connect(self._on_reset_clicked)

        self.add.setChecked(True)
        self.current.setChecked(True)
        self.planned.setChecked(False)

    def tr(self, text: str) -> str:
        return QApplication.translate("TwwSelectionExtenderWidget", text)

    def setController(self, controller):
        self.controller = controller

    # --------------------
    # UI -> parmeters
    # --------------------
    def _get_mode(self) -> str:
        if self.replace.isChecked():
            return "replace"
        if self.add.isChecked():
            return "add"
        if self.remove.isChecked():
            return "remove"
        if self.intersect.isChecked():
            return "intersect"
        return "add"

    def _get_status(self) -> str:
        # fallback current
        if self.planned.isChecked():
            return "planned"
        return "current"

    # --------------------
    # Action
    # --------------------
    def _on_select_clicked(self):
        if self.controller is None:
            self.iface.messageBar().pushWarning(
                self.tr("Selection Extender"), self.tr("Controller not set.")
            )
            return

        self.controller.extend_selection(mode=self._get_mode(), status=self._get_status())

    def _on_reset_clicked(self):
        if self.controller is None:
            self.iface.messageBar().pushWarning(
                self.tr("Selection Extender"),
                self.tr("Controller not set."),
            )
            return

        self.controller.reset()

        self.iface.messageBar().pushMessage(
            self.tr("Selection Extender"),
            self.tr("Reach memory reset."),
            level=Qgis.Info,
            duration=3,
        )
