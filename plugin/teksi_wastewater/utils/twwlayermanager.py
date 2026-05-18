"""
This module helps managing the TWW project layers.
"""

from qgis.core import QgsProject


# pylint: disable=too-few-public-methods
class TwwLayerManager:
    """
    Gives access to TWW layers by the table name.
    """

    def __init__(self):
        pass

    @staticmethod
    def layer(tww_id):
        """
        Get a layer by its table name. Searches for the layer in the map layer registry.
        :param tww_id:  The id of the layer to look for
        :return:         A layer matching this id or None
        """
        lyr = [
            lyr
            for (lyr_id, lyr) in list(QgsProject.instance().mapLayers().items())
            if lyr_id.startswith(tww_id)
        ]
        if lyr:
            return lyr[0]
        else:
            return None
