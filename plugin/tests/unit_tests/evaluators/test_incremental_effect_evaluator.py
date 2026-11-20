from __future__ import annotations

from unittest.mock import Mock

import pytest
from geoalchemy2.elements import WKBElement
from sqlalchemy import literal
from teksi_wastewater.hooks.evaluators.tww_incremental_effect_evaluator import (
    TwwIncrementalEffectEvaluator,
)


def _evaluator() -> TwwIncrementalEffectEvaluator:
    return TwwIncrementalEffectEvaluator(canonical_classes={})


def test_scalar_values_compare_by_value_and_string_compatibility() -> None:
    evaluator = _evaluator()
    session = Mock()
    assert evaluator._values_equal(
        session=session,
        current_value=7,
        desired_value=7,
    )
    assert evaluator._values_equal(
        session=session,
        current_value=7,
        desired_value="7",
    )
    assert not evaluator._values_equal(
        session=session,
        current_value=7,
        desired_value=8,
    )
    session.scalar.assert_not_called()


def test_sql_expression_is_not_coerced_to_python_boolean() -> None:
    evaluator = _evaluator()
    assert not evaluator._values_equal(
        session=Mock(),
        current_value=1,
        desired_value=literal(2) + 1,
    )


def test_spatial_and_non_spatial_values_raise_contract_error() -> None:
    evaluator = _evaluator()
    geometry = WKBElement(
        bytes.fromhex("010100002008080000000000000000F03F0000000000000040"),
        extended=True,
    )
    with pytest.raises(TypeError, match="spatial value"):
        evaluator._values_equal(
            session=Mock(),
            current_value=geometry,
            desired_value="01010000",
        )


def test_two_typed_geometries_are_compared_in_postgis() -> None:
    evaluator = _evaluator()
    geometry = WKBElement(
        bytes.fromhex("010100002008080000000000000000F03F0000000000000040"),
        extended=True,
    )
    session = Mock()
    session.scalar.return_value = True
    assert evaluator._values_equal(
        session=session,
        current_value=geometry,
        desired_value=geometry,
    )
    session.scalar.assert_called_once()
