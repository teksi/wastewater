from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass, field, replace
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.orm import Session
from geoalchemy2.functions import (
    ST_Equals,
)
from geoalchemy2.elements import (
    WKBElement,
)
from sqlalchemy import select
from sqlalchemy.sql.elements import (
    ClauseElement,
)
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



@dataclass(
    slots=True,
)
class TwwIncrementalEffectEvaluator(
    IncrementalEffectEvaluator,
):
    """
    Evaluate incremental effects against current canonical TWW state.

    Canonical ORM discovery is performed at most once per evaluator instance.
    Callers inject an already prepared canonical class collection to avoid
    reflection entirely.

    The evaluator determines whether each desired-state effect is already
    satisfied. Unsatisfied effects are delegated to
    ``TwwEffectEvaluationPolicy``, which classifies them as either
    ``REMEDIABLE`` or ``BLOCKED``.

    The evaluator assigns the actual effect-document index to every result.
    The policy may use ``effect_index=-1`` because it evaluates one isolated
    unsatisfied effect without knowledge of its document position.

    The supplied SQLAlchemy session is caller-owned. This evaluator does not
    flush, commit, roll back or close it.
    """

    canonical_classes: Mapping[
        str,
        type,
    ] = field(
        repr=False,
    )

    policy: TwwEffectEvaluationPolicy = field(
        default_factory=TwwEffectEvaluationPolicy,
    )


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

        Canonical ORM classes are resolved once and reused for all documents
        evaluated by this instance.
        """
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
                    identity=effect.identity,
                )

            current_object = current_objects[
                identity_key
            ]

            if self._is_satisfied(
                effect=effect,
                session=session,
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
        session: Session,
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
                session=session,
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
        identity: CanonicalObjectIdentity,
    ) -> CanonicalObject | None:
        """
        Load one canonical object using its complete identity.
        """
        target_class = self._canonical_class(
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


    def _canonical_class(
        self,
        *,
        class_id: str,
    ) -> Any:
        """
        Return one canonical ORM class from the prepared collection.
        """
        target_class = self.canonical_classes.get(
            class_id,
        )

        if target_class is None:
            available_class_ids = tuple(
                sorted(
                    str(
                        available_class_id,
                    )
                    for available_class_id
                    in self.canonical_classes
                )
            )

            raise ValueError(
                "Unknown canonical ORM class "
                f"{class_id!r}. Available classes: "
                f"{available_class_ids!r}."
            )

        return target_class


    def _values_equal(
        self,
        *,
        session: Session,
        current_value: Any,
        desired_value: Any,
    ) -> bool:
        """
        Compare current and desired canonical values.

        Database-side geometry expressions are evaluated by PostgreSQL through
        ``ST_Equals``. Ordinary scalar values use native equality with the existing
        string compatibility fallback.
        """
        if (
            current_value is None
            or desired_value is None
        ):
            return (
                current_value is None
                and desired_value is None
            )

        current_is_spatial = (
            self._is_spatial_value(
                current_value,
            )
        )

        desired_is_spatial = (
            self._is_spatial_value(
                desired_value,
            )
        )

        if current_is_spatial != desired_is_spatial:
                raise TypeError(
                    "Cannot compare a spatial value with a "
                    "non-spatial value. Current type: "
                    f"{type(current_value)!r}; desired type: "
                    f"{type(desired_value)!r}."
                )
        if (
            current_is_spatial
            and desired_is_spatial
        ):

            result = session.scalar(
                select(
                    ST_Equals(
                        current_value,
                        desired_value,
                    )
                )
            )

            return result is True

        equality_result = (
            current_value == desired_value
        )

        if isinstance(
            equality_result,
            ClauseElement,
        ):
            # A non-geometry SQL expression cannot safely be compared in Python.
            # Retain it as a pending update.
            return False

        if equality_result:
            return True

        return str(
            current_value,
        ) == str(
            desired_value,
        )


    def _is_spatial_value(
        self,
        value: Any,
    ) -> bool:
        return (
            isinstance(
                value,
                WKBElement,
            )
            or self._is_geometry_expression(
                value,
            )
        )


    def _is_geometry_expression(
        self,
        value: Any,
    ) -> bool:
        """
        Return whether one SQL expression declares a geometry result type.
        """
        if not isinstance(
            value,
            ClauseElement,
        ):
            return False

        expression_type = getattr(
            value,
            "type",
            None,
        )

        return (
            expression_type is not None
            and expression_type.__class__.__name__
            in {
                "Geometry",
                "Geography",
            }
        )