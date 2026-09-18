# teksi_wastewater/hooks/capabilities/incremental_import.py

from __future__ import annotations

from collections.abc import Sequence
from typing import Any, Protocol

from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
)
from teksi_hooks.models.mapping import (
    ClassMapping,
)


class FunctionEffectResolver(
    Protocol,
):
    """
    Resolve one function-backed source row into canonical effects.
    """

    def resolve_effects(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
    ) -> EffectDocument:
        """
        Execute the configured read-only mapping function and parse its result.
        """

        ...


class IncrementalEffectEvaluator(
    Protocol,
):
    """
    Evaluate projected effects against current canonical state.
    """

    def evaluate(
        self,
        document: EffectDocument,
    ) -> tuple[
        EffectEvaluationResult,
        ...,
    ]:
        """
        Evaluate every effect in document order.
        """

        ...


class IncrementalEffectPersister(
    Protocol,
):
    """
    Stage accepted desired-state effects in a live database session.
    """

    def persist_effects(
        self,
        *,
        document: EffectDocument,
        evaluations: Sequence[EffectEvaluationResult,],
    ) -> None:
        """
        Stage satisfied and remediable effects.

        Blocked effects must never be passed to this method.
        """

        ...
