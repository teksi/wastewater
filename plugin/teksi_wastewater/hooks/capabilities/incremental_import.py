# teksi_wastewater/hooks/capabilities/incremental_import.py

from __future__ import annotations

from collections.abc import Sequence
from typing import Any, Protocol

from sqlalchemy.orm import Session
from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
)

        
class IncrementalEffectEvaluator(
    Protocol,
):
    """
    Evaluate projected effects against current canonical state.
    """

    def evaluate(
        self,
        session: Session,
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
    Stage accepted desired-state effects in a caller-owned live session.
    """

    def persist_effects(
        self,
        *,
        session: Session,
        document: EffectDocument,
        evaluations: Sequence[EffectEvaluationResult,],
    ) -> None:
        """
        Stage satisfied and remediable effects.

        The supplied session is owned by the incremental importer. This method
        may add, update, delete, and flush ORM state, but it must not commit,
        roll back, or close the session.

        Blocked effects must never be passed to this method.
        """

        ...
