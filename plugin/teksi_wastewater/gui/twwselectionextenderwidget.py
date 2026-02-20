from qgis.PyQt.QtWidgets import QDockWidget
from qgis.PyQt import uic
import os

FORM_CLASS, _ = uic.loadUiType(
    os.path.join(os.path.dirname(__file__), "twwselectionextenderwidget.ui")
)

class TwwSelectionExtenderWidget(QDockWidget, FORM_CLASS):

    def __init__(self, iface, parent=None):
        super().__init__(parent)
        self.iface = iface
        self.setupUi(self)
