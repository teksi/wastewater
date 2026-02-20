from qgis.PyQt.QtCore import QObject
from qgis.core import (
    QgsFeatureRequest,
    QgsMessageLog,
    Qgis
)

from ..utils.twwlayermanager import TwwLayerManager

class TwwSelectionExtender(QObject):

    def __init__(self, iface):
        super().__init__()
        self.iface = iface

    def run(self):
        """
        Entry point called by QAction
        """
        self.extend_selection()

    def extend_selection(self, mode="add"):
        """
        mode: 'replace' | 'add' | 'remove' | 'intersect'
        """
        pass
