# teksi_wastewater/hooks/adapters/tww_incremental_effect_persister.py

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass, field
from typing import Any

from sqlalchemy.orm import Session
from teksi_hooks.models.canonical_object import (
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
    EffectEvaluationStatus,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)

from ...interlis import (
    config,
)
from ...interlis.interlis_model_mapping.model_tww_od import (
    ModelTwwOd,
)
from ..capabilities.incremental_import import (
    IncrementalEffectPersister,
)


@dataclass(
    slots=True,
)
class TwwIncrementalEffectPersister(
    IncrementalEffectPersister,
):
    """
    Stage evaluated incremental effects in a live SQLAlchemy session.

    The supplied session is owned by the incremental-import workflow. This
    adapter may add, modify, delete, and flush ORM objects, but it does not
    commit, roll back, or close the session.
    """

    live_schema: str = config.TWW_OD_SCHEMA

    _row_cache: dict[
        tuple,
        Any | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    def persist_effects(
        self,
        *,
        session: Session,
        document: EffectDocument,
        evaluations: Sequence[EffectEvaluationResult,],
    ) -> None:
        """
        Stage all satisfied and remediable effects.

        Blocked effects cause an immediate failure before further effects from
        this document are staged.
        """

        if len(
            document.effects,
        ) != len(
            evaluations,
        ):
            raise ValueError(
                "Effect evaluation count does not match the "
                "effect-document count. "
                f"Effects: {len(document.effects)}; "
                f"evaluations: {len(evaluations)}."
            )

        canonical_classes = self._canonical_classes()

        for (
            effect,
            evaluation,
        ) in zip(
            document.effects,
            evaluations,
            strict=True,
        ):
            evaluated_effect = getattr(
                evaluation,
                "effect",
                effect,
            )

            if evaluated_effect != effect:
                raise ValueError(
                    "Effect evaluation order does not match the " "effect-document order."
                )

            if evaluation.status == EffectEvaluationStatus.BLOCKED:
                raise RuntimeError(
                    "Blocked incremental effect cannot be "
                    "persisted: "
                    f"{getattr(evaluation, 'message', '')}"
                )

            if evaluation.status == EffectEvaluationStatus.SATISFIED:
                continue

            if evaluation.status != EffectEvaluationStatus.REMEDIABLE:
                raise ValueError("Unsupported effect-evaluation status " f"{evaluation.status!r}.")

            if isinstance(
                effect,
                EnforceExistsEffect,
            ):
                self._ensure_exists(
                    session=session,
                    canonical_classes=canonical_classes,
                    identity=effect.identity,
                )

                continue

            if isinstance(
                effect,
                UpdateAttributeEffect,
            ):
                source_row = self._required_row(
                    session=session,
                    canonical_classes=canonical_classes,
                    identity=effect.identity,
                )

                if not hasattr(
                    source_row,
                    effect.attribute_id,
                ):
                    raise ValueError(
                        "Canonical ORM object "
                        f"{effect.identity.class_id!r} does not "
                        "expose attribute "
                        f"{effect.attribute_id!r}."
                    )

                setattr(
                    source_row,
                    effect.attribute_id,
                    effect.value,
                )

                continue

            if isinstance(
                effect,
                EnforceNotExistsEffect,
            ):
                self._ensure_not_exists(
                    session=session,
                    canonical_classes=canonical_classes,
                    identity=effect.identity,
                )

                continue

            raise TypeError("Unsupported incremental effect type: " f"{type(effect)!r}.")

        session.flush()

    def _ensure_exists(
        self,
        *,
        session: Session,
        canonical_classes: Any,
        identity: CanonicalObjectIdentity,
    ) -> Any:
        """
        Return an existing row or stage creation of a new canonical row.
        """

        source_row = self._try_row(
            session=session,
            canonical_classes=canonical_classes,
            identity=identity,
        )

        if source_row is not None:
            return source_row

        target_class = self._canonical_class(
            canonical_classes=canonical_classes,
            class_id=identity.class_id,
        )

        source_row = target_class()

        for (
            attribute_name,
            attribute_value,
        ) in identity.attributes.items():
            if not hasattr(
                target_class,
                attribute_name,
            ):
                raise ValueError(
                    "Canonical ORM class "
                    f"{identity.class_id!r} does not expose "
                    "identity attribute "
                    f"{attribute_name!r}."
                )

            setattr(
                source_row,
                attribute_name,
                attribute_value,
            )

        session.add(
            source_row,
        )

        self._row_cache[identity.key()] = source_row

        return source_row

    def _ensure_not_exists(
        self,
        *,
        session: Session,
        canonical_classes: Any,
        identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Stage deletion of one canonical object if it exists.
        """

        source_row = self._try_row(
            session=session,
            canonical_classes=canonical_classes,
            identity=identity,
        )

        if source_row is None:
            return

        session.delete(
            source_row,
        )

        self._row_cache[identity.key()] = None

    def _required_row(
        self,
        *,
        session: Session,
        canonical_classes: Any,
        identity: CanonicalObjectIdentity,
    ) -> Any:
        """
        Return one required canonical ORM row.
        """

        source_row = self._try_row(
            session=session,
            canonical_classes=canonical_classes,
            identity=identity,
        )

        if source_row is None:
            raise ValueError("Canonical object does not exist for " f"identity {identity!r}.")

        return source_row

    def _try_row(
        self,
        *,
        session: Session,
        canonical_classes: Any,
        identity: CanonicalObjectIdentity,
    ) -> Any | None:
        """
        Return one canonical ORM row using its complete identity.
        """

        identity_key = identity.key()

        if identity_key in self._row_cache:
            return self._row_cache[identity_key]

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
            self._row_cache[identity_key] = None

            return None

        if (
            len(
                rows,
            )
            > 1
        ):
            raise ValueError("Canonical identity is ambiguous: " f"{identity!r}.")

        source_row = rows[0]

        self._row_cache[identity_key] = source_row

        return source_row

    def _canonical_classes(
        self,
    ) -> Any:
        """
        Return schema-qualified canonical live ORM classes.
        """

        return ModelTwwOd(
            schema=self.live_schema,
        ).classes()

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
            raise ValueError("Unknown canonical ORM class " f"{class_id!r}.")

        return target_class
