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


def catchment_layer(layers):
    # The polygon layer has the same name but no hydraulic edit expressions.
    layer_id = "vw_tww_catchment_area_totals_fccd22f0_6775_46cf_8065_a8ecd98f82b3"
    matches = [layer for layer in layers if layer.findtext("id") == layer_id]
    assert len(matches) == 1, layer_id
    return matches[0]


@pytest.fixture
def hydraulic_expression_layers():
    from qgis.core import QgsProject

    project = QgsProject.instance()
    definitions = [
        (
            "vw_tww_log_card",
            "None?field=obj_id:string&field=identifier:string",
            [("log", "Log A")],
        ),
        (
            "vw_tww_wastewater_node",
            "None?field=obj_id:string&field=identifier:string",
            [("node", "Node A")],
        ),
        (
            "hydraulic_char_data_status",
            "None?field=code:integer&field=value_en:string",
            [(6372, "current"), (6373, "current_optimised"), (6371, "planned")],
        ),
    ]
    added = []
    try:
        for name, uri, rows in definitions:
            layer = QgsVectorLayer(uri, name, "memory")
            assert layer.isValid()
            features = []
            for row in rows:
                feature = QgsFeature(layer.fields())
                feature.setAttributes(list(row))
                features.append(feature)
            assert layer.dataProvider().addFeatures(features)[0]
            project.addMapLayer(layer, False)
            added.append(layer.id())
        yield QgsVectorLayer(
            "None?field=fk_log_card:string&field=wn_obj_id:string",
            "catchment",
            "memory",
        )
    finally:
        project.removeMapLayers(added)


@pytest.mark.qgis
@pytest.mark.parametrize(
    "field,status",
    [
        ("hc_c_identifier", "current"),
        ("hc_o_identifier", "current_optimised"),
        ("hc_p_identifier", "planned"),
    ],
)
@pytest.mark.parametrize("log_id,name", [("log", "Log A"), ("missing", "Node A")])
def test_hydraulic_identifier_default(
    layers, hydraulic_expression_layers, field, status, log_id, name
):
    node = catchment_layer(layers)
    default = node.find(f"./defaults/default[@field='{field}']")
    assert default is not None
    assert default.get("applyOnUpdate") == "1"
    assert (
        evaluate(
            default.get("expression"),
            hydraulic_expression_layers,
            {"fk_log_card": log_id, "wn_obj_id": "node"},
        )
        == f"{name}-{status}"[:20]
    )


@pytest.mark.qgis
@pytest.mark.parametrize("prefix", ["hc_c_", "hc_o_", "hc_p_"])
@pytest.mark.parametrize(
    "minimum,maximum,expected",
    [(20, 10, False), (5, 10, True), (10, 10, True), (5, None, True)],
)
def test_hydraulic_flow_constraint(layers, prefix, minimum, maximum, expected):
    node = catchment_layer(layers)
    min_field = prefix + "pump_flow_min"
    max_field = prefix + "pump_flow_max"
    layer = QgsVectorLayer(
        f"None?field={min_field}:double&field={max_field}:double", "catchment", "memory"
    )
    constraint = node.find(f"./constraintExpressions/constraint[@field='{min_field}']")
    assert constraint is not None
    assert (
        bool(evaluate(constraint.get("exp"), layer, {min_field: minimum, max_field: maximum}))
        == expected
    )


@pytest.mark.qgis
def test_field_edit_options(layers):
    # Some AG-64/96 extension fields exist in the provider but not in the saved
    # fieldConfiguration. Do not discard these valid extension options.
    extensions = {
        ("vw_tww_reach", "AG-64/96"): {"ws_ag96_fk_measure"},
        ("vw_tww_wastewater_structure", "AG-64/96"): {
            "co_ag64_fk_wastewater_node",
            "wn_ag64_fk_provider",
            "wn_ag64_function",
            "wn_ag64_remark",
            "wn_ag96_fk_provider",
            "wn_ag96_is_gateway",
            "wn_ag96_remark",
        },
    }
    # The serialized fieldConfiguration can itself still contain retired names.
    # Explicitly check those names rather than treating them as valid options.
    reach_labels = {"ws__bottom_label", "ws__cover_label", "ws__input_label", "ws__output_label"}
    retired = {
        ("measuring_point", "default"): {"fk_reference_station"},
        ("vw_tww_overflow", "AG-64/96"): {
            "construction_type",
            "hydraulic_overflow_length",
            "length",
            "level_max",
            "level_min",
            "opening_shape",
            "operating_point",
            "placement_of_actuation",
            "placement_of_pump",
            "pump_flow_max_single",
            "pump_flow_min_single",
            "start_level",
            "stop_level",
            "weir_edge",
            "weir_kind",
            "width",
        },
        ("vw_tww_reach", "AG-64/96"): reach_labels,
        ("vw_tww_reach", "new style"): reach_labels,
        ("vw_tww_wastewater_structure", "AG-64/96"): {
            "_input_label",
            "_label",
            "_output_label",
            "wn_fk_wastewater_structure",
        },
    }
    for name, style, node in style_scopes(layers):
        fields = {field.get("name") for field in node.findall("./fieldConfiguration/field")}
        options = {
            field.get("name")
            for tag in ("editable", "labelOnTop", "reuseLastValue", "reuseLastValuePolicy")
            for field in node.findall(f"./{tag}/field")
        }
        if fields:
            assert not options - fields - extensions.get((name, style), set()), (name, style)
        assert not options & retired.get((name, style), set()), (name, style)
        if (name, style) in extensions:
            assert extensions[name, style] <= options

    channel = scope(layers, "mvw_tww_channel", "default")
    for field in ("_from_ne", "_to_ne"):
        assert channel.find(f"./editable/field[@name='{field}']").get("editable") == "0"
