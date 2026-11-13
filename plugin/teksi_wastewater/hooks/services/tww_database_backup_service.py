from __future__ import annotations

import logging
import os
import re
import shutil
import subprocess
import tempfile
from collections.abc import Mapping
from dataclasses import dataclass, field
from pathlib import Path
from time import perf_counter

from ..adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
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

    Backups use PostgreSQL custom-format archives created by ``pg_dump``.
    Restores use ``pg_restore --clean`` and run in one transaction.

    PostgreSQL credentials are passed through the subprocess environment and
    are never written to command-line arguments or logs.

    The caller must release application-owned database transactions before
    calling ``restore_backup()``. Defensive PostgreSQL and subprocess timeouts
    prevent external or accidentally retained sessions from blocking recovery
    indefinitely.
    """

    connection_factory: TwwDatabaseConnectionFactory

    backup_directory: Path | None = None

    pg_dump_executable: str = "pg_dump"

    pg_restore_executable: str = "pg_restore"

    dump_timeout_seconds: float = 300.0

    archive_verification_timeout_seconds: float = 60.0

    restore_timeout_seconds: float = 360.0

    restore_lock_timeout_milliseconds: int = 30_000

    restore_statement_timeout_milliseconds: int = 300_000

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    def create_backup(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> Path:
        """
        Create a custom-format backup of one quarantine schema.

        The archive is first written to a temporary path and moved to its
        final path only after ``pg_dump`` succeeds and creates a non-empty
        file.
        """
        normalized_job_id = self._required_value(
            value=job_id,
            label="job_id",
        )

        normalized_schema = self._required_value(
            value=import_schema,
            label="import_schema",
        )

        backup_directory = self._resolved_backup_directory()

        backup_directory.mkdir(
            parents=True,
            exist_ok=True,
        )

        backup_path = backup_directory / self._backup_filename(
            job_id=normalized_job_id,
            import_schema=normalized_schema,
        )

        temporary_path = backup_path.with_suffix(
            backup_path.suffix + ".tmp",
        )

        self._remove_file_if_present(
            temporary_path,
        )

        command = [
            self._resolve_executable(
                self.pg_dump_executable,
            ),
            *self._connection_arguments(),
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
                operation=("PostgreSQL quarantine backup creation"),
                timeout_seconds=(self.dump_timeout_seconds),
            )

            if not temporary_path.is_file() or temporary_path.stat().st_size == 0:
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

        except BaseException:
            self._remove_file_if_present(
                temporary_path,
            )

            raise

        self.logger.info(
            "Created quarantine backup for job %r and schema %r " "at %s.",
            normalized_job_id,
            normalized_schema,
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

        Archive objects are cleaned before restoration. The restore runs in
        one transaction so a failed restore cannot leave a partially restored
        schema.

        A PostgreSQL lock timeout turns retained-session conflicts into a
        prompt, explicit failure instead of an indefinite ``pg_restore`` wait.
        """
        normalized_schema = self._required_value(
            value=import_schema,
            label="import_schema",
        )

        resolved_backup_path = Path(
            backup_path,
        )

        if not resolved_backup_path.is_file():
            raise FileNotFoundError("Database backup does not exist: " f"{resolved_backup_path!s}")

        if resolved_backup_path.stat().st_size == 0:
            raise RuntimeError("Database backup is empty: " f"{resolved_backup_path!s}")

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
            operation=("PostgreSQL quarantine backup restoration"),
            timeout_seconds=(self.restore_timeout_seconds),
            environment_overrides={
                "PGOPTIONS": self._restore_pgoptions(),
            },
        )

        self.logger.info(
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
                "Could not delete database backup " f"{resolved_backup_path!s}: {exception}"
            ) from exception

        self.logger.info(
            "Deleted quarantine backup %s.",
            resolved_backup_path,
        )

    def _verify_archive(
        self,
        backup_path: Path,
    ) -> None:
        """
        Require ``pg_restore`` to recognize one custom-format archive.
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
            operation=("PostgreSQL backup archive verification"),
            timeout_seconds=(self.archive_verification_timeout_seconds),
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
        import_schema: str,
    ) -> str:
        """
        Return a filesystem-safe backup filename for one job and schema.
        """
        safe_job_id = _SAFE_FILE_COMPONENT.sub(
            "_",
            job_id,
        ).strip(
            "._",
        )

        safe_import_schema = _SAFE_FILE_COMPONENT.sub(
            "_",
            import_schema,
        ).strip(
            "._",
        )

        if not safe_job_id:
            raise ValueError("job_id does not contain any usable filename " "characters.")

        if not safe_import_schema:
            raise ValueError("import_schema does not contain any usable filename " "characters.")

        return f"tww-diff-{safe_job_id}-" f"{safe_import_schema}.dump"

    def _connection_arguments(
        self,
    ) -> list[str,]:
        """
        Return PostgreSQL client connection arguments.

        The password is intentionally omitted and supplied through
        ``PGPASSWORD`` instead.
        """
        parameters = self.connection_factory.parameters

        service = self._optional_parameter(
            parameters,
            "service",
        )

        if service is not None:
            return [
                "--dbname",
                f"service={service}",
            ]

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

        if database is None:
            raise RuntimeError(
                "The database connection configuration does not "
                "contain a PostgreSQL database name or service."
            )

        arguments: list[str,] = []

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

        return arguments

    def _subprocess_environment(
        self,
        *,
        overrides: (
            Mapping[
                str,
                str,
            ]
            | None
        ) = None,
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
            environment["PGPASSWORD"] = password

        if overrides:
            for key, value in overrides.items():
                if key == "PGOPTIONS":
                    existing_value = environment.get(
                        key,
                        "",
                    ).strip()

                    environment[key] = " ".join(
                        item
                        for item in (
                            existing_value,
                            value.strip(),
                        )
                        if item
                    )

                    continue

                environment[key] = value

        return environment

    def _restore_pgoptions(
        self,
    ) -> str:
        """
        Return defensive PostgreSQL settings used by ``pg_restore``.
        """
        lock_timeout = self._positive_integer(
            value=(self.restore_lock_timeout_milliseconds),
            label=("restore_lock_timeout_milliseconds"),
        )

        statement_timeout = self._positive_integer(
            value=(self.restore_statement_timeout_milliseconds),
            label=("restore_statement_timeout_milliseconds"),
        )

        return f"-c lock_timeout={lock_timeout}ms " f"-c statement_timeout={statement_timeout}ms"

    def _run(
        self,
        command: list[str,],
        *,
        operation: str,
        timeout_seconds: float,
        environment_overrides: (
            Mapping[
                str,
                str,
            ]
            | None
        ) = None,
    ) -> None:
        """
        Execute one PostgreSQL client command with bounded runtime.
        """
        normalized_timeout = self._positive_timeout(
            value=timeout_seconds,
            label="timeout_seconds",
        )

        redacted_command = self._redacted_command(
            command,
        )

        self.logger.info(
            "Executing %s: %s",
            operation,
            redacted_command,
        )

        started = perf_counter()

        try:
            completed = subprocess.run(
                command,
                check=True,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=normalized_timeout,
                env=self._subprocess_environment(
                    overrides=environment_overrides,
                ),
            )

        except subprocess.TimeoutExpired as exception:
            elapsed = perf_counter() - started

            stdout = self._decoded_output(
                exception.stdout,
            )

            stderr = self._decoded_output(
                exception.stderr,
            )

            detail = self._command_output_detail(
                stdout=stdout,
                stderr=stderr,
            )

            self.logger.error(
                "%s timed out after %.3f seconds. Command: %s%s",
                operation,
                elapsed,
                redacted_command,
                self._formatted_detail_suffix(
                    detail,
                ),
            )

            raise RuntimeError(
                f"{operation} exceeded "
                f"{normalized_timeout:.3f} seconds. "
                f"Command: {redacted_command}"
                f"{self._formatted_detail_suffix(detail)}"
            ) from exception

        except subprocess.CalledProcessError as exception:
            elapsed = perf_counter() - started

            stdout = self._decoded_output(
                exception.stdout,
            )

            stderr = self._decoded_output(
                exception.stderr,
            )

            detail = self._command_output_detail(
                stdout=stdout,
                stderr=stderr,
            )

            if not detail:
                detail = "The PostgreSQL client returned " f"exit code {exception.returncode}."

            self.logger.error(
                "%s failed after %.3f seconds with exit code %s. " "Command: %s. Detail: %s",
                operation,
                elapsed,
                exception.returncode,
                redacted_command,
                detail,
            )

            raise RuntimeError(
                f"{operation} failed with exit code " f"{exception.returncode}: {detail}"
            ) from exception

        except OSError as exception:
            elapsed = perf_counter() - started

            self.logger.error(
                "Could not start %s after %.3f seconds. " "Command: %s. Detail: %s",
                operation,
                elapsed,
                redacted_command,
                exception,
            )

            raise RuntimeError(
                f"Could not start {operation} command " f"{command[0]!r}: {exception}"
            ) from exception

        except BaseException:
            elapsed = perf_counter() - started

            self.logger.exception(
                "%s was interrupted after %.3f seconds. " "Command: %s",
                operation,
                elapsed,
                redacted_command,
            )

            raise

        elapsed = perf_counter() - started

        self.logger.info(
            "%s succeeded after %.3f seconds.",
            operation,
            elapsed,
        )

        if completed.stderr:
            stderr = completed.stderr.strip()

            if stderr:
                self.logger.debug(
                    "%s stderr: %s",
                    operation,
                    stderr,
                )

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

        if configured_path.is_absolute() or configured_path.parent != Path("."):
            if not configured_path.is_file():
                raise RuntimeError(
                    "PostgreSQL client executable does not exist: " f"{configured_path!s}"
                )

            return str(
                configured_path,
            )

        resolved = shutil.which(
            executable,
        )

        if resolved is None:
            raise RuntimeError(
                "PostgreSQL client executable " f"{executable!r} was not found in PATH."
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
        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(f"{label} must be a non-empty string.")

        return value.strip()

    def _positive_timeout(
        self,
        *,
        value: float,
        label: str,
    ) -> float:
        """
        Return one positive subprocess timeout in seconds.
        """
        if isinstance(
            value,
            bool,
        ):
            raise TypeError(f"{label} must be a positive number.")

        try:
            normalized_value = float(
                value,
            )

        except (
            TypeError,
            ValueError,
        ) as exception:
            raise TypeError(f"{label} must be a positive number.") from exception

        if normalized_value <= 0:
            raise ValueError(f"{label} must be greater than zero.")

        return normalized_value

    def _positive_integer(
        self,
        *,
        value: int,
        label: str,
    ) -> int:
        """
        Return one positive integer setting.
        """
        if isinstance(
            value,
            bool,
        ) or not isinstance(
            value,
            int,
        ):
            raise TypeError(f"{label} must be a positive integer.")

        if value <= 0:
            raise ValueError(f"{label} must be greater than zero.")

        return value

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
            raise RuntimeError(f"Could not remove file {path!s}: {exception}") from exception

    def _redacted_command(
        self,
        command: list[str,],
    ) -> str:
        """
        Return a platform-appropriate, log-safe command representation.
        """
        return subprocess.list2cmdline(
            command,
        )

    def _decoded_output(
        self,
        value: str | bytes | None,
    ) -> str:
        """
        Return subprocess output as normalized text.
        """
        if value is None:
            return ""

        if isinstance(
            value,
            bytes,
        ):
            return value.decode(
                "utf-8",
                errors="replace",
            ).strip()

        return value.strip()

    def _command_output_detail(
        self,
        *,
        stdout: str,
        stderr: str,
    ) -> str:
        """
        Select the most useful PostgreSQL client output.
        """
        return stderr or stdout

    def _formatted_detail_suffix(
        self,
        detail: str,
    ) -> str:
        """
        Format optional subprocess output for an exception or log message.
        """
        if not detail:
            return ""

        return f" Detail: {detail}"
