from __future__ import annotations

from teksi_hooks.models.canonical_object import CanonicalObjectIdentity
from teksi_hooks.models.effects import (
    EffectEvaluationStatus,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_wastewater.hooks.evaluators.tww_effect_evaluation_policy import (
    TwwEffectEvaluationPolicy,
)


def _identity(class_id: str) -> CanonicalObjectIdentity:
    return CanonicalObjectIdentity(
        class_id=class_id,
        attributes={"obj_id": "oid"},
    )


def _effect(effect_type, **values):
    effect = effect_type.__new__(effect_type)
    for key, value in values.items():
        object.__setattr__(effect, key, value)
    return effect


def test_missing_agxx_helper_is_remediable() -> None:
    result = TwwEffectEvaluationPolicy().unsatisfied_status(
        effect=_effect(
            EnforceExistsEffect,
            identity=_identity("agxx_reach_point"),
        ),
        current_object=None,
    )
    assert result.status is EffectEvaluationStatus.REMEDIABLE
    assert result.findings[0].code == "target_will_be_created"


def test_missing_protected_reach_point_is_blocked() -> None:
    result = TwwEffectEvaluationPolicy().unsatisfied_status(
        effect=_effect(
            EnforceExistsEffect,
            identity=_identity("reach_point"),
        ),
        current_object=None,
    )
    assert result.status is EffectEvaluationStatus.BLOCKED
    assert result.findings[0].code == "required_target_missing"


def test_existing_agxx_helper_can_be_deleted() -> None:
    result = TwwEffectEvaluationPolicy().unsatisfied_status(
        effect=_effect(
            EnforceNotExistsEffect,
            identity=_identity("agxx_unconnected_node_bwrel"),
        ),
        current_object=object(),
    )
    assert result.status is EffectEvaluationStatus.REMEDIABLE
    assert result.findings[0].code == "target_will_be_deleted"


def test_update_is_remediable_for_creatable_helper() -> None:
    result = TwwEffectEvaluationPolicy().unsatisfied_status(
        effect=_effect(
            UpdateAttributeEffect,
            identity=_identity("agxx_reach_point"),
            attribute_id="ag64_fk_wastewater_node",
            value="oid",
        ),
        current_object=None,
    )
    assert result.status is EffectEvaluationStatus.REMEDIABLE
    assert result.findings[0].code == "attribute_will_be_updated"
