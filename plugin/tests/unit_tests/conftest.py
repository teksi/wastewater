from __future__ import annotations

import pytest


@pytest.fixture
def no_commit_session():
    """Session double documenting that unit-tested services never own commits."""
    class SessionDouble:
        committed = False
        rolled_back = False
        closed = False

        def commit(self):
            self.committed = True
            raise AssertionError("Unit under test must not commit caller-owned sessions.")

        def rollback(self):
            self.rolled_back = True
            raise AssertionError("Unit under test must not roll back caller-owned sessions.")

        def close(self):
            self.closed = True
            raise AssertionError("Unit under test must not close caller-owned sessions.")

    return SessionDouble()
