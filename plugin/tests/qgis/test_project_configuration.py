import xml.etree.ElementTree as ET
from pathlib import Path

import pytest
from qgis.core import (
    QgsExpression,
    QgsExpressionContext,
    QgsExpressionContextUtils,
    QgsFeature,
    QgsVectorLayer,
)
from qgis.testing import start_app

QGS = Path(__file__).resolve().parents[3] / "project" / "teksi_wastewater.qgs"


@pytest.fixture(scope="module")
def layers():
    start_app()
    return ET.parse(QGS).findall("./projectlayers/maplayer")


def style_scopes(layers):
    for layer in layers:
        name = layer.findtext("layername")
        manager = layer.find("map-layer-style-manager")
        current = manager.get("current") if manager is not None else "default"
        yield name, current, layer
        if manager is not None:
            for style in manager.findall("map-layer-style"):
                qgis = style.find("qgis")
                if qgis is not None:
                    yield name, style.get("name"), qgis


def scope(layers, name, style=None):
    matches = [
        node
        for layer, current, node in style_scopes(layers)
        if layer == name and (style is None or current == style)
    ]
    assert matches, (name, style)
    if style is None:
        return matches[0]
    assert len(matches) == 1, (name, style)
    return matches[0]


def evaluate(expression, layer, attributes):
    feature = QgsFeature(layer.fields())
    for name, value in attributes.items():
        feature[name] = value
    context = QgsExpressionContext()
    context.appendScopes(QgsExpressionContextUtils.globalProjectLayerScopes(layer))
    context.setFeature(feature)
    exp = QgsExpression(expression)
    assert exp.prepare(context), exp.evalErrorString()
    value = exp.evaluate(context)
    assert not exp.hasEvalError(), exp.evalErrorString()
    return value


@pytest.mark.qgis
@pytest.mark.parametrize(
    "name,field,value",
    [
        ("vw_tww_ws_maintenance", "ws_identifier", "Manhole A"),
        ("vw_tww_additional_ws", "identifier", "Structure A"),
        ("re_maintenance_event_wastewater_structure", "id", "relation-id"),
    ],
)
def test_display_expression(layers, name, field, value):
    layer = QgsVectorLayer(f"None?field={field}:string", name, "memory")
    assert layer.isValid()
    expression = scope(layers, name).findtext("previewExpression")
    assert evaluate(expression, layer, {field: value}) == value
