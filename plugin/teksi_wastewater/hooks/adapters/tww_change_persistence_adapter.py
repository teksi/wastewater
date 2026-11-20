from __future__ import annotations

from dataclasses import (
    dataclass,
    field,
    replace,
)

from teksi_hooks.capabilities.persistence import (
    ChangePersistenceCapability,
)
from teksi_hooks.models.persistence import (
    ChangePersistenceDecision,
    ChangePersistenceDocument,
    ChangePersistenceResult,
    PersistenceResult,
)
from teksi_hooks.models.review import (
    DiffSnapshot,
)
from teksi_hooks.models.validation import (
    Change,
    ChangeOperation,
)

from .tww_session_manager import (
    TwwSessionManager,
)


@dataclass(
    slots=True,
)
class TwwChangePersistenceAdapter(
    ChangePersistenceCapability,
):
    """
    Persist an accepted immutable diff snapshot to TEKSI Wastewater.

    Authorization is not reevaluated during persistence. The adapter applies
    the object-level and attribute-level decisions produced during review.

    Inserts and deletes remain complete row-level operations.

    For updates, values for attributes rejected during review are replaced
    with ``None`` in a derived ``Change`` object. The original reviewed
    ``Change`` remains unchanged.

    The downstream TEKSI Wastewater update implementation must ignore incoming
    ``None`` values, preserving the corresponding existing live values.

    The session manager owns transaction completion and session closure. This
    adapter borrows the live session and does not commit, roll back, or close
    it directly.
    """

    session_manager: TwwSessionManager = field(
        repr=False,
    )

    def persist_snapshot(
        self,
        snapshot: DiffSnapshot,
        decisions: ChangePersistenceDocument,
    ) -> PersistenceResult:
        """
        Persist one accepted snapshot atomically.

        The complete decision document is applied inside one persistence
        scope. The live transaction is committed only when all decisions
        succeed. An exception causes the session manager to roll back the
        transaction.
        """

        self._assert_compatible_document(
            snapshot=snapshot,
            decisions=decisions,
        )

        with self.session_manager.persistence_scope() as session_context:
            cursor = self._borrowed_cursor(
                session_context.live,
            )

            try:
                change_results = self._persist_decisions(
                    cursor=cursor,
                    decisions=decisions,
                )

                # Make database-side errors visible before the scope commits.
                session_context.live.flush()

            finally:
                cursor.close()

        return PersistenceResult(
            snapshot_id=snapshot.snapshot_id,
            change_results=change_results,
        )

    def _persist_decisions(
        self,
        *,
        cursor,
        decisions: ChangePersistenceDocument,
    ) -> tuple[
        ChangePersistenceResult,
        ...,
    ]:
        """
        Persist all ordered decisions in the supplied document.

        The entire method executes inside the persistence scope's live
        transaction.
        """

        results: list[ChangePersistenceResult,] = []

        for (
            change_index,
            decision,
        ) in enumerate(
            decisions.decisions,
        ):
            affected_rows = self._persist_decision(
                cursor=cursor,
                decision=decision,
            )

            results.append(
                ChangePersistenceResult(
                    change_index=change_index,
                    identity=decision.change.identity,
                    affected_rows=affected_rows,
                )
            )

        return tuple(
            results,
        )

    def _persist_decision(
        self,
        *,
        cursor,
        decision: ChangePersistenceDecision,
    ) -> int:
        """
        Persist one object-level decision.
        """

        change = decision.change

        if change.operation == ChangeOperation.INSERT:
            if not decision.permitted:
                return 0

            return self._apply_insert(
                cursor=cursor,
                change=change,
            )

        if change.operation == ChangeOperation.UPDATE:
            persistence_change = self._prepare_update(
                decision=decision,
            )

            if not self._has_persistable_update(
                persistence_change,
            ):
                return 0

            return self._apply_update(
                cursor=cursor,
                change=persistence_change,
            )

        if change.operation == ChangeOperation.DELETE:
            if not decision.permitted:
                return 0

            return self._apply_delete(
                cursor=cursor,
                change=change,
            )

        raise ValueError("Unsupported change operation: " f"{change.operation!r}.")

    def _prepare_update(
        self,
        *,
        decision: ChangePersistenceDecision,
    ) -> Change:
        """
        Return an update with rejected changed values replaced by ``None``.

        Persistence decisions are validated against the reviewed change. The
        original ``Change`` remains unchanged.
        """

        change = decision.change

        if change.operation != ChangeOperation.UPDATE:
            raise ValueError(
                "_prepare_update() requires an update decision, " f"got {change.operation!r}."
            )

        changed_attribute_ids = {
            attribute_change.attribute_name for attribute_change in change.changed_attributes
        }

        unknown_decisions = decision.decided_attributes - changed_attribute_ids

        if unknown_decisions:
            raise ValueError(
                "Persistence decisions refer to attributes "
                "that are not changed: "
                f"{sorted(unknown_decisions)!r}."
            )

        missing_decisions = changed_attribute_ids - decision.decided_attributes

        if missing_decisions:
            raise ValueError(
                "Persistence decisions are missing for changed "
                f"attributes: {sorted(missing_decisions)!r}."
            )

        persistence_values = dict(
            change.new_values,
        )

        for attribute_id in decision.unpermitted_attributes:
            persistence_values[attribute_id] = None

        return replace(
            change,
            new_values=persistence_values,
        )

    def _has_persistable_update(
        self,
        change: Change,
    ) -> bool:
        """
        Return whether an update retains a non-null changed value.
        """

        if change.operation != ChangeOperation.UPDATE:
            return False

        return any(
            change.new_values.get(
                attribute_change.attribute_name,
            )
            is not None
            for attribute_change in change.changed_attributes
        )

    def _assert_compatible_document(
        self,
        *,
        snapshot: DiffSnapshot,
        decisions: ChangePersistenceDocument,
    ) -> None:
        """
        Ensure the decisions belong to the supplied immutable snapshot.
        """

        if decisions.version != 1:
            raise ValueError(
                "Unsupported persistence-decision document " f"version: {decisions.version!r}."
            )

        if decisions.snapshot_id != snapshot.snapshot_id:
            raise ValueError(
                "Persistence decisions cannot be applied to "
                "another snapshot. Snapshot: "
                f"{snapshot.snapshot_id!r}; decision document: "
                f"{decisions.snapshot_id!r}."
            )

    def _apply_insert(
        self,
        *,
        cursor,
        change: Change,
    ) -> int:
        """
        Persist one unaltered insert.

        Return the number of affected physical database rows. The
        implementation must use the supplied cursor and must not commit.
        """

        raise NotImplementedError("TWW insert persistence is not configured.")

    def _apply_update(
        self,
        *,
        cursor,
        change: Change,
    ) -> int:
        """
        Persist one prepared update.

        Incoming ``None`` values must be ignored by the downstream TWW update
        operation. Return the number of affected physical database rows.

        The implementation must use the supplied cursor and must not commit.
        """

        raise NotImplementedError("TWW update persistence is not configured.")

    def _apply_delete(
        self,
        *,
        cursor,
        change: Change,
    ) -> int:
        """
        Persist one permitted row-level deletion.

        Return the number of affected physical database rows. The
        implementation must use the supplied cursor and must not commit.
        """

        raise NotImplementedError("TWW delete persistence is not configured.")

    def _borrowed_cursor(
        self,
        session,
    ):
        """
        Create a DBAPI cursor from the scope-owned live session.

        The caller owns closing the cursor. The adapter must not close the
        SQLAlchemy connection, DBAPI connection, or session.
        """

        sqlalchemy_connection = session.connection()

        connection_fairy = sqlalchemy_connection.connection

        driver_connection = getattr(
            connection_fairy,
            "driver_connection",
            None,
        )

        if driver_connection is None:
            driver_connection = getattr(
                connection_fairy,
                "connection",
                None,
            )

        if driver_connection is None:
            raise RuntimeError(
                "Could not access the DBAPI connection owned " "by the live SQLAlchemy session."
            )

        return driver_connection.cursor()
