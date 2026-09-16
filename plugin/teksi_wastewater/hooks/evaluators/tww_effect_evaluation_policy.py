# teksi_wastewater/hooks/evaluators/tww_effect_evaluation_policy.py

from __future__ import annotations

from dataclasses import dataclass

from teksi_hooks.exceptions import (
    Severity,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObject,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectEvaluationResult,
    EffectEvaluationStatus,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)


@dataclass(
    slots=True,
    frozen=True,
)
class TwwEffectEvaluationPolicy:
    """
    Classify unsatisfied effects for AGXX incremental persistence.
    """

    creatable_classes: frozenset[
        str,
    ] = frozenset(
        {
            "agxx_wastewater_node",
            "agxx_wastewater_networkelement",
            "agxx_wastewater_structure",
            "agxx_last_modification",
            "agxx_unconnected_node_bwrel",
            "agxx_reach_point",
        }
    )

    deletable_classes: frozenset[
        str,
    ] = frozenset(
        {
            "agxx_wastewater_node",
            "agxx_wastewater_networkelement",
            "agxx_wastewater_structure",
            "agxx_last_modification",
            "agxx_unconnected_node_bwrel",
            "agxx_reach_point",
        }
    )

    protected_classes: frozenset[
        str,
    ] = frozenset(
        {
            "wastewater_node",
            "wastewater_networkelement",
            "wastewater_structure",
            "reach_point",
            "reach",
            "cover",
        }
    )

    def unsatisfied_status(
        self,
        *,
        effect: Effect,
        current_object: CanonicalObject | None,
    ) -> EffectEvaluationResult:
        """
        Classify one unsatisfied TWW desired-state effect.
        """

        class_id = effect.identity.class_id

        if isinstance(
            effect,
            EnforceExistsEffect,
        ):
            return self._classify_missing_object(
                class_id=class_id,
            )

        if isinstance(
            effect,
            EnforceNotExistsEffect,
        ):
            return self._classify_existing_object(
                class_id=class_id,
            )

        if isinstance(
            effect,
            UpdateAttributeEffect,
        ):
            return self._classify_attribute_update(
                effect=effect,
                current_object=current_object,
            )

        return self._blocked(
            code="unsupported_effect",
            message=(
                f"Unsupported TWW effect type "
                f"{type(effect).__name__!r}."
            ),
            class_id=class_id,
        )

    def _classify_missing_object(
        self,
        *,
        class_id: str,
    ) -> EffectEvaluationResult:
        """
        Classify an unsatisfied enforce-exists effect.
        """

        if class_id in self.creatable_classes:
            return self._remediable(
                code="target_will_be_created",
                message=(
                    f"Target object in class {class_id!r} does not "
                    "exist and will be created during persistence."
                ),
                class_id=class_id,
            )

        return self._blocked(
            code="required_target_missing",
            message=(
                f"Required target object in class {class_id!r} "
                "does not exist and may not be created by "
                "incremental persistence."
            ),
            class_id=class_id,
        )

    def _classify_existing_object(
        self,
        *,
        class_id: str,
    ) -> EffectEvaluationResult:
        """
        Classify an unsatisfied enforce-not-exists effect.
        """

        if class_id in self.deletable_classes:
            return self._remediable(
                code="target_will_be_deleted",
                message=(
                    f"Target object in class {class_id!r} exists "
                    "and will be deleted during persistence."
                ),
                class_id=class_id,
            )

        return self._blocked(
            code="protected_target_exists",
            message=(
                f"Target object in protected class {class_id!r} "
                "exists and may not be deleted by incremental "
                "persistence."
            ),
            class_id=class_id,
        )

    def _classify_attribute_update(
        self,
        *,
        effect: UpdateAttributeEffect,
        current_object: CanonicalObject | None,
    ) -> EffectEvaluationResult:
        """
        Classify one unsatisfied attribute update.
        """

        class_id = effect.identity.class_id

        if (
            current_object is None
            and class_id not in self.creatable_classes
        ):
            return self._blocked(
                code="update_target_missing",
                message=(
                    f"Cannot update attribute {effect.attribute_id!r} "
                    f"because target object in class {class_id!r} "
                    "does not exist."
                ),
                class_id=class_id,
                attribute_name=effect.attribute_id,
            )

        return self._remediable(
            code="attribute_will_be_updated",
            message=(
                f"Attribute {class_id!r}.{effect.attribute_id!r} "
                "does not have the desired value and will be "
                "updated during persistence."
            ),
            class_id=class_id,
            attribute_name=effect.attribute_id,
        )

    def _remediable(
        self,
        *,
        code: str,
        message: str,
        class_id: str,
        attribute_name: str | None = None,
    ) -> EffectEvaluationResult:
        """
        Build one remediable result.
        """

        return EffectEvaluationResult(
            effect_index=-1,
            status=EffectEvaluationStatus.REMEDIABLE,
            findings=(
                ValidationFinding(
                    code=code,
                    severity=Severity.WARNING,
                    message=message,
                    attribute_name=attribute_name,
                ),
            ),
            metadata={
                "target_class_id": class_id,
            },
        )

    def _blocked(
        self,
        *,
        code: str,
        message: str,
        class_id: str,
        attribute_name: str | None = None,
    ) -> EffectEvaluationResult:
        """
        Build one blocked result.
        """

        return EffectEvaluationResult(
            effect_index=-1,
            status=EffectEvaluationStatus.BLOCKED,
            findings=(
                ValidationFinding(
                    code=code,
                    severity=Severity.ERROR,
                    message=message,
                    attribute_name=attribute_name,
                ),
            ),
            metadata={
                "target_class_id": class_id,
            },
        )
