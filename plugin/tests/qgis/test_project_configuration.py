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


@pytest.mark.qgis
def test_form_fields(layers):
    extensions = {
        "co_ag64_fk_wastewater_node",
        "wn_ag64_fk_provider",
        "wn_ag64_function",
        "wn_ag64_remark",
        "wn_ag96_fk_provider",
        "wn_ag96_is_gateway",
        "wn_ag96_remark",
    }
    ag_fields = {
        f"ag{version}_{field}"
        for version in (64, 96)
        for field in ("fk_provider", "last_modification", "remark")
    }
    mappings = [
        ("measuring_point", "default", {"fk_reference_station": None}),
        ("mvw_tww_channel", "default", {"_from_node": "_from_ne", "_to_node": "_to_ne"}),
        (
            "vw_tww_channel_maintenance",
            "0-default",
            {"_from_node": "_from_ne", "_to_node": "_to_ne"},
        ),
        (
            "vw_tww_overflow",
            "AG-64/96",
            {
                **{name: f"ov_{name}" for name in ag_fields},
                **{
                    name: f"pu_{name}"
                    for name in (
                        "construction_type",
                        "operating_point",
                        "stop_level",
                        "start_level",
                        "pump_flow_min_single",
                        "pump_flow_max_single",
                        "placement_of_pump",
                        "placement_of_actuation",
                    )
                },
                **{
                    name: f"pw_{name}"
                    for name in (
                        "hydraulic_overflow_length",
                        "level_max",
                        "level_min",
                        "weir_edge",
                        "weir_kind",
                    )
                },
                **{name: f"lw_{name}" for name in ("length", "width", "opening_shape")},
            },
        ),
        ("vw_tww_reach", "AG-64/96", {name: f"ne_{name}" for name in ag_fields}),
        (
            "vw_tww_wastewater_node",
            "without overflow",
            {"backflow_level": "backflow_level_current"},
        ),
        (
            "vw_tww_wastewater_structure",
            "AG-64/96",
            {
                "_input_label": None,
                "_output_label": None,
                "ag96_fk_measure": "ws_ag96_fk_measure",
                "wn_ag64_last_modification": "ne_ag64_last_modification",
                "wn_ag96_last_modification": "ne_ag96_last_modification",
            },
        ),
    ]
    for name, style, renamed in mappings:
        node = scope(layers, name, style)
        fields = {
            field.get("name")
            for field in node.findall("./attributeEditorForm//attributeEditorField")
        }
        for old, new in renamed.items():
            assert old not in fields, (name, style, old)
            if new:
                assert new in fields, (name, style, new)
        if name == "vw_tww_wastewater_structure":
            assert extensions <= fields
