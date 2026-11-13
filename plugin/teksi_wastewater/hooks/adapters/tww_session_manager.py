from __future__ import annotations

from dataclasses import dataclass, field

from sqlalchemy import text
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session
from teksi_hooks.models.persistence import DiffSourceRole
from teksi_wastewater.interlis.utils import (
    tww_sqlalchemy,
)


@dataclass(
    slots=True,
    frozen=True,
)
class TwwSessionContext:
    """
    Hold sessions borrowed for one TWW workflow operation.

    The scope owns live-session transaction handling and closure of all
    sessions.

    Projection consumers must treat quarantine sessions as read-only.

    Persistence preparation may mutate and commit the applicable quarantine
    session so that an external importer can observe the prepared state.
    Quarantine recovery after a failed persistence operation is handled by
    the backup service rather than by rolling back that committed session.

    Consumers must not close any session.
    """

    live: Session

    quarantine: Session

    quarantine_incremental: Session | None = None

    def quarantine_for_role(
        self,
        source_role: DiffSourceRole,
    ) -> Session:
        if source_role == DiffSourceRole.BASE:
            return self.quarantine

        if source_role == DiffSourceRole.INCREMENTAL:
            if self.quarantine_incremental is None:
                raise RuntimeError(
                    "Incremental persistence requires an incremental " "quarantine session."
                )

            return self.quarantine_incremental

        raise ValueError(f"Unsupported source role: {source_role!r}.")

    def for_incremental_source(
        self,
    ) -> TwwSessionContext:
        """
        Return a context whose active quarantine is the incremental source.
        """
        if self.quarantine_incremental is None:
            raise RuntimeError(
                "Incremental persistence requires a dedicated " "incremental quarantine session."
            )

        return TwwSessionContext(
            live=self.live,
            quarantine=self.quarantine_incremental,
            quarantine_incremental=(self.quarantine_incremental),
        )

    def for_base_source(
        self,
    ) -> TwwSessionContext:
        """
        Return a context whose active quarantine is the base source.
        """
        return TwwSessionContext(
            live=self.live,
            quarantine=self.quarantine,
            quarantine_incremental=None,
        )


class TwwSessionScope:
    """
    Own the sessions used by one TWW workflow operation.

    A projection scope closes all sessions without committing them.

    A persistence scope commits the live session when the complete operation
    succeeds and rolls it back when the operation fails.

    Quarantine preparation commits, when required for an external importer,
    are performed explicitly by the persistence service. Those commits are
    outside the live transaction and are recovered through the quarantine
    backup service on failure.
    """

    def __init__(
        self,
        *,
        quarantine_session: Session,
        live_session: Session,
        transactional: bool,
        defer_constraints: bool = False,
        quarantine_incremental_session: Session | None = None,
    ) -> None:
        self._quarantine_session = quarantine_session

        self._live_session = live_session
        self._quarantine_incremental_session = quarantine_incremental_session
        self._transactional = transactional

        self._defer_constraints = defer_constraints

        self._context = TwwSessionContext(
            live=live_session,
            quarantine=quarantine_session,
            quarantine_incremental=quarantine_incremental_session,
        )

        self._entered = False

    def __enter__(
        self,
    ) -> TwwSessionContext:
        if self._entered:
            raise RuntimeError("TWW session scope cannot be entered more " "than once.")

        self._entered = True

        if self._defer_constraints:
            self._live_session.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        return self._context

    def __exit__(
        self,
        exc_type,
        exc_value,
        traceback,
    ) -> bool:
        try:
            if self._transactional:
                if exc_type is None:
                    self._live_session.commit()
                else:
                    self._live_session.rollback()
            elif exc_type is not None:
                self._live_session.rollback()

            if exc_type is not None:
                for session in self._quarantine_sessions():
                    session.rollback()
        finally:
            self._live_session.close()

            for session in self._quarantine_sessions():
                session.close()

        return False

    def _quarantine_sessions(
        self,
    ) -> tuple[Session, ...]:
        sessions = [
            self._quarantine_session,
        ]

        if (
            self._quarantine_incremental_session is not None
            and self._quarantine_incremental_session is not self._quarantine_session
        ):
            sessions.append(
                self._quarantine_incremental_session,
            )

        return tuple(sessions)


@dataclass(
    slots=True,
)
class TwwSessionManager:
    """
    Create and manage SQLAlchemy sessions for TWW workflows.

    The manager centralizes:

    - session creation;
    - live-schema validation;
    - deferred-constraint setup;
    - live transaction commit and rollback;
    - session closure.

    Services, importers, projectors, evaluators and persisters borrow the
    sessions exposed by a scope and must not manage their lifecycle.
    """

    engine: Engine = field(
        default_factory=(tww_sqlalchemy.create_engine),
        repr=False,
    )

    def projection_scope(
        self,
    ) -> TwwSessionScope:
        """
        Return a read-only scope for diff creation and verification.

        The scope contains one active quarantine session and one live
        session. Neither session is committed. Both sessions are closed when
        the scope exits.

        Individual base and incremental diff-creation passes use separate
        projection scopes, so no additional incremental quarantine session
        is required here.
        """
        return TwwSessionScope(
            quarantine_session=(self._quarantine_session()),
            live_session=self._live_session(),
            transactional=False,
            defer_constraints=False,
        )

    def persistence_scope(
        self,
        *,
        include_incremental: bool = False,
    ) -> TwwSessionScope:
        """
        Return a transactional quarantine-to-live persistence scope.

        The scope always contains:

        - one base quarantine session;
        - one live session.

        When ``include_incremental`` is true, the scope additionally contains
        a separate incremental quarantine session. This keeps base and
        incremental quarantine preparation in independent SQLAlchemy units of
        work while sharing the same live transaction.

        The scope:

        - defers live database constraints on entry;
        - commits the live session on successful exit;
        - rolls back the live session on exceptional exit;
        - closes every created session unconditionally.

        Quarantine preparation commits, when required for visibility to the
        legacy importer, remain the responsibility of the persistence service.
        """
        quarantine_incremental_session = (
            self._quarantine_session() if include_incremental else None
        )

        return TwwSessionScope(
            quarantine_session=(self._quarantine_session()),
            quarantine_incremental_session=(quarantine_incremental_session),
            live_session=self._live_session(),
            transactional=True,
            defer_constraints=True,
        )

    def _quarantine_session(
        self,
    ) -> Session:
        """
        Create one session for quarantine data.

        Base and incremental quarantine sessions use the same engine but own
        separate SQLAlchemy identity maps and transaction state.
        """
        return Session(
            self.engine,
            autocommit=False,
            autoflush=False,
        )

    def _live_session(
        self,
    ) -> Session:
        """
        Create a session for live TWW data.
        """
        return Session(
            self.engine,
            autocommit=False,
            autoflush=False,
        )
