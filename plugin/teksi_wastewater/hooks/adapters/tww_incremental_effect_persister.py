from __future__ import annotations

from collections.abc import Mapping, Sequence
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

from ..capabilities.incremental_import import (
    IncrementalEffectPersister,
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
class TwwIncrementalEffectPersister(
    IncrementalEffectPersister,
):
    """
    Stage evaluated incremental effects in a live SQLAlchemy session.

    Canonical ORM discovery is performed at most once per persister instance.
    Callers may inject an already prepared canonical class collection to avoid
    reflection entirely. Otherwise, ``ModelTwwOd`` is prepared lazily on the
    first persistence call and retained for subsequent documents.

    The supplied session is owned by the incremental-import workflow. This
    adapter may add, modify and delete ORM objects, but it does not flush,
    commit, roll back or close the session. The importer flushes once after all
    effect documents have been staged.
    """

    canonical_classes: Mapping[
        str,
        type,
    ] = field(
        repr=False,
    )

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
        evaluations: Sequence[
            EffectEvaluationResult,
        ],
    ) -> None:
        """
        Stage all satisfied and remediable effects from one document.

        Blocked effects cause an immediate failure before further effects from
        this document are staged. No flush is performed here because the
        incremental importer flushes once after all documents have been
        persisted.
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
                    "Effect evaluation order does not match the "
                    "effect-document order."
                )

            if (
                evaluation.status
                == EffectEvaluationStatus.BLOCKED
            ):
                raise RuntimeError(
                    "Blocked incremental effect cannot be "
                    "persisted: "
                    f"{getattr(evaluation, 'message', '')}"
                )

            if (
                evaluation.status
                == EffectEvaluationStatus.SATISFIED
            ):
                continue

            if (
                evaluation.status
                != EffectEvaluationStatus.REMEDIABLE
            ):
                raise ValueError(
                    "Unsupported effect-evaluation status "
                    f"{evaluation.status!r}."
                )

            if isinstance(
                effect,
                EnforceExistsEffect,
            ):
                self._ensure_exists(
                    session=session,
                    identity=effect.identity,
                )

                continue

            if isinstance(
                effect,
                UpdateAttributeEffect,
            ):
                source_row = self._required_row(
                    session=session,
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
                    identity=effect.identity,
                )

                continue

            raise TypeError(
                "Unsupported incremental effect type: "
                f"{type(effect)!r}."
            )

    def clear_cache(
        self,
    ) -> None:
        """
        Clear cached ORM rows and lazily discovered canonical classes.

        Call this when the live schema is recreated while the same persister
        instance remains in use.
        """
        self._row_cache.clear()

    def _ensure_exists(
        self,
        *,
        session: Session,
        identity: CanonicalObjectIdentity,
    ) -> Any:
        """
        Return an existing row or stage creation of a new canonical row.
        """
        source_row = self._try_row(
            session=session,
            identity=identity,
        )

        if source_row is not None:
            return source_row

        target_class = self._canonical_class(
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

        self._row_cache[
            identity.key()
        ] = source_row

        return source_row

    def _ensure_not_exists(
        self,
        *,
        session: Session,
        identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Stage deletion of one canonical object if it exists.
        """
        source_row = self._try_row(
            session=session,
            identity=identity,
        )

        if source_row is None:
            return

        session.delete(
            source_row,
        )

        self._row_cache[
            identity.key()
        ] = None

    def _required_row(
        self,
        *,
        session: Session,
        identity: CanonicalObjectIdentity,
    ) -> Any:
        """
        Return one required canonical ORM row.
        """
        source_row = self._try_row(
            session=session,
            identity=identity,
        )

        if source_row is None:
            raise ValueError(
                "Canonical object does not exist for "
                f"identity {identity!r}."
            )

        return source_row

    def _try_row(
        self,
        *,
        session: Session,
        identity: CanonicalObjectIdentity,
    ) -> Any | None:
        """
        Return one canonical ORM row using its complete identity.

        Rows are retained across document calls so several effects targeting
        the same canonical identity do not repeat the database lookup.
        """
        identity_key = identity.key()

        if identity_key in self._row_cache:
            return self._row_cache[
                identity_key
            ]

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
            self._row_cache[
                identity_key
            ] = None

            return None

        if len(
            rows,
        ) > 1:
            raise ValueError(
                "Canonical identity is ambiguous: "
                f"{identity!r}."
            )

        source_row = rows[
            0
        ]

        self._row_cache[
            identity_key
        ] = source_row

        return source_row

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

    def _validate_live_schema(
        self,
    ) -> None:
        """
        Require a non-empty configured canonical live schema.
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
