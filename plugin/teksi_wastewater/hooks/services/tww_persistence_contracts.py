# teksi_wastewater/hooks/services/tww_persistence_contracts.py

from __future__ import annotations

from pathlib import Path
from typing import Protocol

from teksi_wastewater.hooks.services.tww_quarantine_persistence_preparer import (
    TwwQuarantinePersistencePreparer,
)


class TwwQuarantineBackupService(
    Protocol,
):
    """
    Create, restore and delete quarantine backups.
    """

    def create_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> Path:
        """
        Create a backup before destructive quarantine preparation.
        """

        ...

    def restore_backup(
        self,
        *,
        backup_path: Path,
        import_schema: str,
    ) -> None:
        """
        Restore quarantine from a backup.
        """

        ...

    def delete_backup(
        self,
        *,
        backup_path: Path,
    ) -> None:
        """
        Delete a quarantine backup.
        """

        ...


class TwwQuarantinePersistencePreparerFactory(
    Protocol,
):
    """
    Construct one schema-specific quarantine preparer.
    """

    def quarantine_preparer(
        self,
        *,
        import_schema: str,
        source_model: str,
    ) -> TwwQuarantinePersistencePreparer:
        """
        Return a preparer configured for one source model and schema.
        """

        ...
