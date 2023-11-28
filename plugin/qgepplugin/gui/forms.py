import qgis
from qgis.core import QgsProject
from qgis.PyQt.QtWidgets import QPushButton

from ..tools.qgepmaptooladdfeature import QgepMapToolDigitizeDrainageChannel


def geometryDigitized(fid, layer, tool):
    layer.changeGeometry(fid, tool.geometry)
    layer.triggerRepaint()
    tool.deactivate()


def mapToolDeactivated(tool):
    tool.deactivated.disconnect()
    qgis.utils.plugins["qgepplugin"].iface.mapCanvas().unsetMapTool(tool)
    tool.deleteLater()


def digitizeDrainageChannel(fid, layerid):
    layer = QgsProject.instance().mapLayer(layerid)
    layer.startEditing()
    tool = QgepMapToolDigitizeDrainageChannel(qgis.utils.plugins["qgepplugin"].iface, layer)
    qgis.utils.plugins["qgepplugin"].iface.mapCanvas().setMapTool(tool)
    tool.geometryDigitized.connect(lambda: geometryDigitized(fid, layer, tool))
    # form.window().hide()
    tool.deactivated.connect(lambda: mapToolDeactivated(tool))


def manholeOpen(form, layer, feature):
    button = form.findChild(QPushButton, "btn_digitize_drainage_channel")

    try:
        button.clicked.disconnect()
    except TypeError:
        pass

    if feature.isValid():
        button.clicked.connect(lambda: digitizeDrainageChannel(form, feature, layer))
        button.setEnabled(layer.isEditable())

        enable_button = lambda: button.setEnabled(True)
        disable_button = lambda: button.setEnabled(False)

        layer.editingStarted.connect(enable_button)
        layer.editingStopped.connect(disable_button)

        form.destroyed.connect(lambda: layer.editingStarted.disconnect(enable_button))
        form.destroyed.connect(lambda: layer.editingStopped.disconnect(disable_button))
    else:
        button.setEnabled(False)
