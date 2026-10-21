from __future__ import annotations

from dataclasses import dataclass, field, replace
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.orm import Session

from teksi_hooks.models.canonical_object import (
    CanonicalObject,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EffectEvaluationResult,
    EffectEvaluationStatus,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)

from ..capabilities.incremental_import import (
    IncrementalEffectEvaluator,
)
from ..evaluators.tww_effect_evaluation_policy import (
    TwwEffectEvaluationPolicy,
)
from ...interlis import (
    config,
)
from ...interlis.interlis_model_mapping.model_tww_od import (
    ModelTwwOd,
)


@dataclass(
    slots=True,
)
class TwwIncrementalEffectEvaluator(
    IncrementalEffectEvaluator,
):
    """
    Evaluate incremental effects against current canonical TWW state.

    The evaluator determines whether each desired-state effect is already
    satisfied.

    Unsatisfied effects are delegated to ``TwwEffectEvaluationPolicy``, which
    classifies them as either:

    - ``REMEDIABLE``;
    - ``BLOCKED``.

    The evaluator assigns the actual effect-document index to every result.
    The policy may use ``effect_index=-1`` because it evaluates one isolated
    unsatisfied effect without knowledge of its document position.

    The supplied SQLAlchemy session is caller-owned. This evaluator does not
    flush, commit, roll back, or close it.
    """

    policy: TwwEffectEvaluationPolicy = field(
        default_factory=TwwEffectEvaluationPolicy,
    )

    live_schema: str = config.TWW_OD_SCHEMA

    def evaluate(
        self,
        *,
        session: Session,
        document: EffectDocument,
    ) -> tuple[
        EffectEvaluationResult,
        ...,
    ]:
        """
        Evaluate every effect in document order.
        """

        canonical_classes = self._canonical_classes()

        current_objects: dict[
            tuple,
            CanonicalObject | None,
        ] = {}

        results: list[
            EffectEvaluationResult,
        ] = []

        for (
            effect_index,
            effect,
        ) in enumerate(
            document.effects,
        ):
            identity_key = effect.identity.key()

            if identity_key not in current_objects:
                current_objects[
                    identity_key
                ] = self._current_object(
                    session=session,
                    canonical_classes=(
                        canonical_classes
                    ),
                    identity=effect.identity,
                )

            current_object = current_objects[
                identity_key
            ]

            if self._is_satisfied(
                effect=effect,
                current_object=current_object,
            ):
                result = self._satisfied_result(
                    effect_index=effect_index,
                    effect=effect,
                )

            else:
                policy_result = (
                    self.policy.unsatisfied_status(
                        effect=effect,
                        current_object=current_object,
                    )
                )

                result = replace(
                    policy_result,
                    effect_index=effect_index,
                )

            results.append(
                result,
            )

            current_objects[
                identity_key
            ] = self._project_effect_state(
                effect=effect,
                current_object=current_object,
                evaluation=result,
            )

        return tuple(
            results,
        )

    def _is_satisfied(
        self,
        *,
        effect: Effect,
        current_object: CanonicalObject | None,
    ) -> bool:
        """
        Return whether one effect already matches canonical state.
        """

        if isinstance(
            effect,
            EnforceExistsEffect,
        ):
            return current_object is not None

        if isinstance(
            effect,
            EnforceNotExistsEffect,
        ):
            return current_object is None

        if isinstance(
            effect,
            UpdateAttributeEffect,
        ):
            if current_object is None:
                return False

            current_value = current_object.values.get(
                effect.attribute_id,
            )

            return self._values_equal(
                current_value=current_value,
                desired_value=effect.value,
            )

        return False

    def _satisfied_result(
        self,
        *,
        effect_index: int,
        effect: Effect,
    ) -> EffectEvaluationResult:
        """
        Build one satisfied effect-evaluation result.
        """

        metadata: dict[
            str,
            Any,
        ] = {
            "target_class_id": (
                effect.identity.class_id
            ),
        }

        if isinstance(
            effect,
            UpdateAttributeEffect,
        ):
            metadata[
                "target_attribute_id"
            ] = effect.attribute_id

        return EffectEvaluationResult(
            effect_index=effect_index,
            status=EffectEvaluationStatus.SATISFIED,
            findings=(),
            metadata=metadata,
        )

    def _project_effect_state(
        self,
        *,
        effect: Effect,
        current_object: CanonicalObject | None,
        evaluation: EffectEvaluationResult,
    ) -> CanonicalObject | None:
        """
        Project a non-blocked effect into the in-memory evaluation state.

        This lets later effects in the same document observe preceding desired
        state without flushing changes to the database.

        For example:

        1. ``EnforceExistsEffect`` for a missing object;
        2. ``UpdateAttributeEffect`` for that object.

        The update is evaluated against the object that the preceding effect
        plans to create.
        """

        if (
            evaluation.status
            == EffectEvaluationStatus.BLOCKED
        ):
            return current_object

        if isinstance(
            effect,
            EnforceExistsEffect,
        ):
            if current_object is not None:
                return current_object

            return CanonicalObject(
                identity=effect.identity,
                values=dict(
                    effect.identity.attributes,
                ),
            )

        if isinstance(
            effect,
            EnforceNotExistsEffect,
        ):
            return None

        if isinstance(
            effect,
            UpdateAttributeEffect,
        ):
            if current_object is None:
                return current_object

            updated_values = dict(
                current_object.values,
            )

            updated_values[
                effect.attribute_id
            ] = effect.value

            return CanonicalObject(
                identity=current_object.identity,
                values=updated_values,
            )

        return current_object

    def _current_object(
        self,
        *,
        session: Session,
        canonical_classes: Any,
        identity: CanonicalObjectIdentity,
    ) -> CanonicalObject | None:
        """
        Load one canonical object using its complete identity.
        """

        target_class = self._canonical_class(
            canonical_classes=canonical_classes,
            class_id=identity.class_id,
        )

        query = session.query(
            target_class,
        )

        for (
            attribute_name,
            attribute_value,
        ) in identity.attributes.items():
            orm_attribute = getattr(
                target_class,
                attribute_name,
                None,
            )

            if orm_attribute is None:
                raise ValueError(
                    "Canonical ORM class "
                    f"{identity.class_id!r} does not expose "
                    "identity attribute "
                    f"{attribute_name!r}."
                )

            query = query.filter(
                orm_attribute == attribute_value,
            )

        rows = query.limit(
            2,
        ).all()

        if not rows:
            return None

        if len(
            rows,
        ) > 1:
            raise ValueError(
                "Canonical identity is ambiguous: "
                f"{identity!r}."
            )

        return CanonicalObject(
            identity=identity,
            values=self._row_values(
                rows[
                    0
                ],
            ),
        )

    def _row_values(
        self,
        source_row: Any,
    ) -> dict[
        str,
        Any,
    ]:
        """
        Return mapped column values from one canonical ORM row.

        Relationship attributes and SQLAlchemy internal state are excluded.
        """

        mapper = inspect(
            type(
                source_row,
            )
        )

        return {
            attribute.key: getattr(
                source_row,
                attribute.key,
            )
            for attribute in mapper.column_attrs
        }

    def _canonical_classes(
        self,
    ) -> Any:
        """
        Return schema-qualified canonical live ORM classes.
        """

        if (
            not isinstance(
                self.live_schema,
                str,
            )
            or not self.live_schema.strip()
        ):
            raise ValueError(
                "live_schema must be a non-empty string."
            )

        return ModelTwwOd().classes()

    def _canonical_class(
        self,
        *,
        canonical_classes: Any,
        class_id: str,
    ) -> Any:
        """
        Return one canonical ORM class.
        """

        if isinstance(
            canonical_classes,
            dict,
        ):
            target_class = canonical_classes.get(
                class_id,
            )

        else:
            target_class = getattr(
                canonical_classes,
                class_id,
                None,
            )

            if target_class is None:
                classes_collection = getattr(
                    canonical_classes,
                    "classes",
                    None,
                )

                if classes_collection is not None:
                    target_class = getattr(
                        classes_collection,
                        class_id,
                        None,
                    )

        if target_class is None:
            raise ValueError(
                "Unknown canonical ORM class "
                f"{class_id!r}."
            )

        return target_class

    def _values_equal(
        self,
        *,
        current_value: Any,
        desired_value: Any,
    ) -> bool:
        """
        Compare current and desired canonical values.

        Native equality remains authoritative. A string fallback handles
        compatible identifier, enum, numeric, and database-wrapper values that
        use different Python representations.
        """

        if current_value == desired_value:
            return True

        if (
            current_value is None
            or desired_value is None
        ):
            return False

        return str(
            current_value,
        ) == str(
            desired_value,
        )