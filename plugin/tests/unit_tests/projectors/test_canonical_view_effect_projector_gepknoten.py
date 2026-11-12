from __future__ import annotations

from types import SimpleNamespace
from unittest.mock import Mock

import pytest

from teksi_wastewater.hooks.projectors.tww_canonical_view_effect_projector import (
    TwwCanonicalViewEffectProjector,
)


def _projector() -> TwwCanonicalViewEffectProjector:
    return TwwCanonicalViewEffectProjector.__new__(
        TwwCanonicalViewEffectProjector,
    )


@pytest.mark.parametrize(
    ("origin", "method_name"),
    (
        ("wastewater_node", "_project_connected_gepknoten"),
        (
            "agxx_unconnected_node_bwrel",
            "_project_unconnected_wastewater_node",
        ),
        ("reach_point", "_project_reach_point_gepknoten"),
    ),
)
def test_gepknoten_dispatches_by_mapping_origin(
    origin: str,
    method_name: str,
) -> None:
    projector = _projector()
    expected = (object(),)
    setattr(projector, method_name, Mock(return_value=expected))
    result = projector._project_gepknoten(
        source_row=SimpleNamespace(obj_id="oid"),
        current_row={"_mapping_origin": origin},
        context=Mock(),
    )
    assert result is expected


def test_missing_comparison_row_bootstraps_reach_point() -> None:
    projector = _projector()
    expected = (object(),)
    projector._project_new_reach_point_gepknoten = Mock(
        return_value=expected,
    )
    result = projector._project_gepknoten(
        source_row=SimpleNamespace(obj_id="oid"),
        current_row=None,
        context=Mock(),
    )
    assert result is expected


def test_unknown_mapping_origin_fails_closed() -> None:
    projector = _projector()
    with pytest.raises(ValueError, match="Unsupported GepKnoten"):
        projector._project_gepknoten(
            source_row=SimpleNamespace(obj_id="oid"),
            current_row={"_mapping_origin": "unknown"},
            context=Mock(),
        )


@pytest.mark.parametrize(
    ("source_value", "expected"),
    (
        ("PAA", "PAA.unbekannt"),
        ("PAA.other", "PAA.unbekannt"),
        ("SAA", "SAA.unbekannt"),
        ("SAA.other", "SAA.unbekannt"),
        (None, "SAA.unbekannt"),
        ("unexpected", "SAA.unbekannt"),
    ),
)
def test_unconnected_function_family_fallback(
    source_value,
    expected: str,
) -> None:
    projector = _projector()
    assert projector._unconnected_function_fallback(
        source_value=source_value,
    ) == expected
