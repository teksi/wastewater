from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

from psycopg.types.json import Jsonb

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
@dataclass(
    slots=True,
)
class TwwTrustedImportService:
    """
    Manage the metadata lifecycle of one trusted import.

    Trusted imports create no review features and require no acceptance step.
    Their metadata entry prevents another trusted import from concurrently
    using the same quarantine schema.
    """

    job_id: str

    connection_factory: DatabaseConnectionFactory

    def begin(
        self,
        *,
        metadata: Mapping[
            str,
            Any,
        ],
    ) -> None:
        """
        Atomically register one trusted import in the applying state.

        The method serializes attempts to start imports for the same quarantine
        schema. An existing applying trusted import always blocks a new import.

        No review features or per-class diff tables are created.
        """

        normalized_metadata = dict(
            metadata,
        )

        import_schema = normalized_metadata.get(
            "import_schema",
        )

        if not isinstance(
            import_schema,
            str,
        ) or not import_schema.strip():
            raise ValueError(
                "Trusted-import metadata must contain a non-empty "
                "'import_schema'."
            )

        live_schema = normalized_metadata.get(
            "live_schema",
        )

        if not isinstance(
            live_schema,
            str,
        ) or not live_schema.strip():
            raise ValueError(
                "Trusted-import metadata must contain a non-empty "
                "'live_schema'."
            )

        normalized_job_id = self.job_id.strip()
        normalized_import_schema = (
            import_schema.strip()
        )

        lock_identifier = (
            "teksi-wastewater:"
            f"trusted-import:{normalized_import_schema}"
        )

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT pg_advisory_xact_lock(
                        hashtextextended(
                            %s,
                            0
                        )
                    );
                    """,
                    (
                        lock_identifier,
                    ),
                )

                cursor.execute(
                    """
                    SELECT
                        job_id
                    FROM
                        tww_diff.tww_metadata
                    WHERE
                        job_type = 'trusted_import'
                        AND job_status = 'applying'
                        AND (
                            metadata ->> 'import_schema' = %s
                            OR metadata ->> 'incremental_import_schema' = %s
                        )
                    ORDER BY
                        id
                    LIMIT 1;
                    """,
                    (
                        normalized_import_schema,
                        normalized_import_schema,
                    ),
                )

                active_job = cursor.fetchone()

                if active_job is not None:
                    active_job_id = (
                        active_job["job_id"]
                        if isinstance(
                            active_job,
                            Mapping,
                        )
                        else active_job[0]
                    )

                    raise RuntimeError(
                        "Cannot start trusted import "
                        f"{normalized_job_id!r}: trusted import "
                        f"{active_job_id!r} is already applying "
                        "through quarantine schema "
                        f"{normalized_import_schema!r}."
                    )

                cursor.execute(
                    """
                    INSERT INTO tww_diff.tww_metadata (
                        job_id,
                        job_type,
                        job_status,
                        validation_success,
                        metadata
                    )
                    VALUES (
                        %s,
                        'trusted_import',
                        'applying',
                        TRUE,
                        %s
                    );
                    """,
                    (
                        normalized_job_id,
                        Jsonb(
                            normalized_metadata,
                        ),
                    ),
                )

            connection.commit()

    def mark_applied(
        self,
    ) -> None:
        """
        Mark the current trusted import as successfully applied.

        Only a trusted-import job currently in the ``applying`` state can be
        transitioned.
        """

        self._transition_trusted_import(
            new_status="applied",
        )

    def mark_failed(
        self,
        *,
        reason: str,
    ) -> None:
        """
        Mark the current trusted import as failed.

        The failure reason is added to the job's JSON metadata. Only a
        trusted-import job currently in the ``applying`` state can be
        transitioned.
        """

        if not isinstance(
            reason,
            str,
        ) or not reason.strip():
            raise ValueError(
                "The trusted-import failure reason must be "
                "a non-empty string."
            )

        self._transition_trusted_import(
            new_status="failed",
            metadata_update={
                "failure_reason": reason.strip(),
            },
        )

    def _transition_trusted_import(
        self,
        *,
        new_status: str,
        metadata_update: Mapping[
            str,
            Any,
        ] | None = None,
    ) -> None:
        """
        Atomically transition the current trusted-import job.

        The transition succeeds only when the job:

        - exists;
        - has type ``trusted_import``;
        - is currently in the ``applying`` state.
        """

        if new_status not in {
            "applied",
            "failed",
        }:
            raise ValueError(
                "A trusted import can only transition from "
                f"'applying' to 'applied' or 'failed', got "
                f"{new_status!r}."
            )

        normalized_job_id = self.job_id.strip()

        if not normalized_job_id:
            raise ValueError(
                "job_id must be a non-empty string."
            )

        normalized_metadata_update = dict(
            metadata_update or {},
        )

        query = """
            UPDATE
                tww_diff.tww_metadata
            SET
                job_status = %s,
                metadata = COALESCE(
                    metadata,
                    '{}'::jsonb
                ) || %s
            WHERE
                job_id = %s
                AND job_type = 'trusted_import'
                AND job_status = 'applying'
            RETURNING
                job_id,
                job_status;
        """

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    query,
                    (
                        new_status,
                        Jsonb(
                            normalized_metadata_update,
                        ),
                        normalized_job_id,
                    ),
                )

                transitioned_job = cursor.fetchone()

            if transitioned_job is None:
                connection.rollback()

                raise RuntimeError(
                    "Could not transition trusted import "
                    f"{normalized_job_id!r} from 'applying' "
                    f"to {new_status!r}. The job does not "
                    "exist, is not a trusted import, or is "
                    "no longer applying."
                )

            connection.commit()

