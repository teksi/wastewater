# teksi_wastewater/hooks/services/tww_database_backup_service.py

from __future__ import annotations

from dataclasses import dataclass
import logging
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from typing import Mapping

from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)


logger = logging.getLogger(
    __name__,
)


_SAFE_FILE_COMPONENT = re.compile(
    r"[^A-Za-z0-9_.-]+",
)


@dataclass(
    frozen=True,
    slots=True,
)
class TwwDatabaseBackupService:
    """
    Back up and restore one quarantine schema.

    The service creates PostgreSQL custom-format archives using ``pg_dump``.
    A failed persistence attempt can restore the original quarantine schema
    with ``pg_restore``.

    Database passwords are passed through the subprocess environment and are
    never included in command-line arguments.
    """

    connection_factory: TwwDatabaseConnectionFactory

    backup_directory: Path | None = None

    pg_dump_executable: str = "pg_dump"

    pg_restore_executable: str = "pg_restore"

    def create_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> Path:
        """
        Create a custom-format backup of one quarantine schema.

        The backup is written to a temporary file and moved to its final path
        only after ``pg_dump`` completes successfully.
        """

        normalized_job_id = self._required_value(
            value=job_id,
            label="job_id",
        )

        normalized_schema = self._required_value(
            value=import_schema,
            label="import_schema",
        )

        backup_directory = (
            self._resolved_backup_directory()
        )

        backup_directory.mkdir(
            parents=True,
            exist_ok=True,
        )

        backup_path = (
            backup_directory
            / self._backup_filename(
                job_id=normalized_job_id,
            )
        )

        temporary_path = backup_path.with_suffix(
            backup_path.suffix + ".tmp",
        )

        self._remove_file_if_present(
            temporary_path,
        )

        connection_arguments = (
            self._connection_arguments()
        )

        command = [
            self._resolve_executable(
                self.pg_dump_executable,
            ),
            *connection_arguments,
            "--format=custom",
            "--no-owner",
            "--no-privileges",
            "--schema",
            normalized_schema,
            "--file",
            str(
                temporary_path,
            ),
        ]

        try:
            self._run(
                command,
            )

            if (
                not temporary_path.is_file()
                or temporary_path.stat().st_size == 0
            ):
                raise RuntimeError(
                    "PostgreSQL backup completed without creating "
                    f"a valid archive at {temporary_path!s}."
                )

            self._remove_file_if_present(
                backup_path,
            )

            temporary_path.replace(
                backup_path,
            )

        except Exception:
            self._remove_file_if_present(
                temporary_path,
            )

            raise

        logger.info(
            "Created quarantine backup for job %r at %s.",
            normalized_job_id,
            backup_path,
        )

        return backup_path

    def restore_backup(
        self,
        *,
        backup_path: Path,
        import_schema: str,
    ) -> None:
        """
        Restore a quarantine schema from a custom-format archive.

        Objects contained in the archive are cleaned before restoration. The
        restore runs as one transaction so a failed restore does not leave a
        partially restored quarantine schema.
        """

        normalized_schema = self._required_value(
            value=import_schema,
            label="import_schema",
        )

        resolved_backup_path = Path(
            backup_path,
        )

        if not resolved_backup_path.is_file():
            raise FileNotFoundError(
                "Database backup does not exist: "
                f"{resolved_backup_path!s}"
            )

        if resolved_backup_path.stat().st_size == 0:
            raise RuntimeError(
                "Database backup is empty: "
                f"{resolved_backup_path!s}"
            )

        self._verify_archive(
            resolved_backup_path,
        )

        command = [
            self._resolve_executable(
                self.pg_restore_executable,
            ),
            *self._connection_arguments(),
            "--clean",
            "--if-exists",
            "--no-owner",
            "--no-privileges",
            "--exit-on-error",
            "--single-transaction",
            "--schema",
            normalized_schema,
            str(
                resolved_backup_path,
            ),
        ]

        self._run(
            command,
        )

        logger.info(
            "Restored quarantine schema %r from %s.",
            normalized_schema,
            resolved_backup_path,
        )

    def delete_backup(
        self,
        *,
        backup_path: Path,
    ) -> None:
        """
        Delete one completed database backup.

        Deleting a backup that no longer exists is treated as successful.
        """

        resolved_backup_path = Path(
            backup_path,
        )

        try:
            resolved_backup_path.unlink(
                missing_ok=True,
            )

        except OSError as exception:
            raise RuntimeError(
                "Could not delete database backup "
                f"{resolved_backup_path!s}: {exception}"
            ) from exception

        logger.info(
            "Deleted quarantine backup %s.",
            resolved_backup_path,
        )

    def _verify_archive(
        self,
        backup_path: Path,
    ) -> None:
        """
        Require ``pg_restore`` to recognize the archive.
        """

        command = [
            self._resolve_executable(
                self.pg_restore_executable,
            ),
            "--list",
            str(
                backup_path,
            ),
        ]

        self._run(
            command,
        )

    def _resolved_backup_directory(
        self,
    ) -> Path:
        """
        Return the directory used for temporary quarantine backups.
        """

        if self.backup_directory is not None:
            return Path(
                self.backup_directory,
            )

        return (
            Path(
                tempfile.gettempdir(),
            )
            / "teksi-wastewater"
            / "diff-backups"
        )

    def _backup_filename(
        self,
        *,
        job_id: str,
    ) -> str:
        """
        Return a filesystem-safe backup filename.
        """

        safe_job_id = _SAFE_FILE_COMPONENT.sub(
            "_",
            job_id,
        ).strip(
            "._",
        )

        if not safe_job_id:
            raise ValueError(
                "job_id does not contain any usable filename characters."
            )

        return f"tww-diff-{safe_job_id}.dump"

    def _connection_arguments(
        self,
    ) -> list[
        str,
    ]:
        """
        Return PostgreSQL client connection arguments.

        The password is intentionally omitted and supplied through
        ``PGPASSWORD`` instead.
        """

        parameters = self.connection_factory.parameters

        arguments: list[
            str,
        ] = []

        service = self._optional_parameter(
            parameters,
            "service",
        )

        if service is not None:
            arguments.extend(
                [
                    "--dbname",
                    f"service={service}",
                ]
            )

            return arguments

        host = self._optional_parameter(
            parameters,
            "host",
        )

        port = self._optional_parameter(
            parameters,
            "port",
        )

        database = self._optional_parameter(
            parameters,
            "dbname",
        )

        user = self._optional_parameter(
            parameters,
            "user",
        )

        if host is not None:
            arguments.extend(
                [
                    "--host",
                    host,
                ]
            )

        if port is not None:
            arguments.extend(
                [
                    "--port",
                    port,
                ]
            )

        if database is not None:
            arguments.extend(
                [
                    "--dbname",
                    database,
                ]
            )

        if user is not None:
            arguments.extend(
                [
                    "--username",
                    user,
                ]
            )

        if database is None:
            raise RuntimeError(
                "The database connection configuration does not "
                "contain a PostgreSQL database name or service."
            )

        return arguments

    def _subprocess_environment(
        self,
    ) -> dict[
        str,
        str,
    ]:
        """
        Return the environment used by PostgreSQL client processes.
        """

        environment = dict(
            os.environ,
        )

        password = self._optional_parameter(
            self.connection_factory.parameters,
            "password",
        )

        if password is not None:
            environment[
                "PGPASSWORD"
            ] = password

        return environment

    def _run(
        self,
        command: list[
            str,
        ],
    ) -> None:
        """
        Execute one PostgreSQL client command.
        """

        logger.debug(
            "Executing PostgreSQL backup command: %s",
            self._redacted_command(
                command,
            ),
        )

        try:
            subprocess.run(
                command,
                check=True,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                env=(
                    self._subprocess_environment()
                ),
            )

        except subprocess.CalledProcessError as exception:
            stderr = (
                exception.stderr or ""
            ).strip()

            stdout = (
                exception.stdout or ""
            ).strip()

            detail = (
                stderr
                or stdout
                or (
                    "The PostgreSQL client returned "
                    f"exit code {exception.returncode}."
                )
            )

            raise RuntimeError(
                "PostgreSQL backup command failed: "
                f"{detail}"
            ) from exception

        except OSError as exception:
            raise RuntimeError(
                "Could not start PostgreSQL backup command "
                f"{command[0]!r}: {exception}"
            ) from exception

    def _resolve_executable(
        self,
        executable: str,
    ) -> str:
        """
        Resolve one PostgreSQL client executable.
        """

        configured_path = Path(
            executable,
        )

        if (
            configured_path.is_absolute()
            or configured_path.parent
            != Path(".")
        ):
            if not configured_path.is_file():
                raise RuntimeError(
                    "PostgreSQL client executable does not exist: "
                    f"{configured_path!s}"
                )

            return str(
                configured_path,
            )

        resolved = shutil.which(
            executable,
        )

        if resolved is None:
            raise RuntimeError(
                "PostgreSQL client executable "
                f"{executable!r} was not found in PATH."
            )

        return resolved

    def _optional_parameter(
        self,
        parameters: Mapping[
            str,
            object,
        ],
        key: str,
    ) -> str | None:
        """
        Return one optional connection parameter as a string.
        """

        value = parameters.get(
            key,
        )

        if value in (
            None,
            "",
        ):
            return None

        return str(
            value,
        )

    def _required_value(
        self,
        *,
        value: str,
        label: str,
    ) -> str:
        """
        Return one required non-empty string.
        """

        if not isinstance(
            value,
            str,
        ) or not value.strip():
            raise ValueError(
                f"{label} must be a non-empty string."
            )

        return value.strip()

    def _remove_file_if_present(
        self,
        path: Path,
    ) -> None:
        """
        Remove one file if it exists.
        """

        try:
            path.unlink(
                missing_ok=True,
            )

        except OSError as exception:
            raise RuntimeError(
                f"Could not remove file {path!s}: {exception}"
            ) from exception

    def _redacted_command(
        self,
        command: list[
            str,
        ],
    ) -> str:
        """
        Return a log-safe representation of a command.
        """

        return " ".join(
            command,
        )