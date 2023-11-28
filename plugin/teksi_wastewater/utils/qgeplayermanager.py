"""
This module helps managing the QGEP project layers.
"""

from qgis.core import QgsProject
from qgis.PyQt.QtCore import QObject, pyqtSignal


class QgepLayerNotifier(QObject):
    """
    This class sends out notification when a given set of layers is available or unavailable.
    """

    layersAvailable = pyqtSignal([dict])
    layersUnavailable = pyqtSignal()

    layersAvailableChanged = pyqtSignal(bool)

    available = False

    def __init__(self, parent, layers):
        QObject.__init__(self, parent)
        self.layers = layers

        QgsProject.instance().layersWillBeRemoved.connect(self.layersWillBeRemoved)
        QgsProject.instance().layersAdded.connect(self.layersAdded)

    def layersWillBeRemoved(self, _):
        """
        Gets called when a layer is removed

        @param _: The layers about to be removed
        """

        if self.available:
            for qgep_id in self.layers:
                lyrs = [
                    lyr
                    for (lyr_id, lyr) in list(QgsProject.instance().mapLayers().items())
                    if lyr_id.startswith(qgep_id)
                ]
                if not lyrs:
                    self.layersUnavailable.emit()
                    self.layersAvailableChanged.emit(False)
                    self.available = False

    def layersAdded(self, _):
        """
        Gets called when a layer is added
        @param _: the layers to check
        """
        if not self.available:
            lyrlist = dict()
            for qgep_id in self.layers:
                lyr = [
                    lyr
                    for (lyr_id, lyr) in list(QgsProject.instance().mapLayers().items())
                    if lyr_id.startswith(qgep_id)
                ]
                if not lyr:
                    return
                lyrlist[qgep_id] = lyr[0]

            self.available = True
            self.layersAvailableChanged.emit(True)
            self.layersAvailable.emit(lyrlist)


# pylint: disable=too-few-public-methods
class QgepLayerManager:
    """
    Gives access to QGEP layers by the table name.
    """

    def __init__(self):
        pass

    @staticmethod
    def layer(qgep_id):
        """
        Get a layer by its table name. Searches for the layer in the map layer registry.
        :param qgep_id:  The id of the layer to look for
        :return:         A layer matching this id or None
        """
        lyr = [
            lyr
            for (lyr_id, lyr) in list(QgsProject.instance().mapLayers().items())
            if lyr_id.startswith(qgep_id)
        ]
        if lyr:
            return lyr[0]
        else:
            return None
