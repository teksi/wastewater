from dataclasses import dataclass

from sqlalchemy.orm import Session


@dataclass(
    slots=True,
    frozen=True,
)
class InterlisImportSessions:
    """
    Caller-owned sessions used by an INTERLIS quarantine-to-live import.

    The importer may flush these sessions but must not commit, roll back,
    or close them.
    """

    quarantine: Session
    live: Session
