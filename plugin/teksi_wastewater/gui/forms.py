import qgis
from qgis.core import QgsProject

from ..tools.twwmaptooladdfeature import TwwMapToolDigitizeDrainageChannel


def geometryDigitized(fid, layer, tool):
    layer.changeGeometry(fid, tool.geometry)
    layer.triggerRepaint()
    tool.deactivate()


def mapToolDeactivated(tool):
    tool.deactivated.disconnect()
    qgis.utils.plugins["teksi_wastewater"].iface.mapCanvas().unsetMapTool(tool)
    tool.deleteLater()


def digitizeDrainageChannel(fid, layerid):
    layer = QgsProject.instance().mapLayer(layerid)
    layer.startEditing()
    tool = TwwMapToolDigitizeDrainageChannel(qgis.utils.plugins["teksi_wastewater"].iface, layer)
    qgis.utils.plugins["teksi_wastewater"].iface.mapCanvas().setMapTool(tool)
    tool.geometryDigitized.connect(lambda: geometryDigitized(fid, layer, tool))
    # form.window().hide()
    tool.deactivated.connect(lambda: mapToolDeactivated(tool))
