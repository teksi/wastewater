from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import asdict, dataclass, field, is_dataclass
from datetime import date, datetime
from enum import Enum
import json
import logging
from typing import Any

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.review import (
    SourcePreparer,
)
from teksi_hooks.models.persistence import (
    DiffJobMode,
)
from teksi_hooks.models.review import (
    DiffReviewJob,
    DiffSchemaWriteResult,
    PreparedSource,
    ReviewFeature,
)

from teksi_wastewater.hooks.exceptions import (
    DiffJobEligibilityError,
    DiffJobNotFoundError,
    DiffJobStateError,
    DiffJobTransitionError,
    DiffSchemaContractError,
)

from teksi_wastewater.hooks.capabilities.tww_interlis_persistence_capability import (
    TwwInterlisPersistenceResult,
)

logger = logging.getLogger(
    __name__,
)

@dataclass(
    slots=True,
    frozen=True,
)
class DiffJobCounts:
    """
    Aggregated review-row counts for one diff job.
    """

    total_count: int = 0
    restricted_count: int = 0
    rejected_count: int = 0
    created_count: int = 0
    altered_count: int = 0
    deleted_count: int = 0

    @property
    def persistable_count(
        self,
    ) -> int:
        """
        Return the number of non-rejected review rows.
        """

        return self.total_count - self.rejected_count

@dataclass(
    slots=True,
    frozen=True,
)
class TwwJobPersistenceResult:
    """
    Result of applying one accepted tww_diff review job.
    """

    job_id: str
    previous_status: str
    job_status: str
    review_feature_count: int
    restricted_feature_count: int
    import_schema: str
    live_schema: str
    source_model: str
    interlis_persistence: TwwInterlisPersistenceResult


@dataclass(
    slots=True,
)
class TwwDiffSchemaService(
    SourcePreparer,
):
    """
    Plugin-side database adapter for tww_diff review state.

    This service owns database access to the stable tww_diff schema.

    It does not:

    - classify changes;
    - evaluate rights;
    - validate source values;
    - compare geometries;
    - normalize geometries;
    - create GeoPackages;
    - build QGIS layers;
    - prepare quarantine values;
    - apply changes to the live schema.
    """

    connection_factory: DatabaseConnectionFactory
    schema: str = "tww_diff"
    srid: int = 2056

    _prepared_sources: dict[
        str,
        PreparedSource,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _allowed_status_transitions: Mapping[
        str,
        frozenset[str],
    ] = field(
        default_factory=lambda: {
            "preparing": frozenset(
                {
                    "pending",
                    "failed",
                }
            ),
            "pending": frozenset(
                {
                    "accepted",
                    "rejected",
                }
            ),
            "accepted": frozenset(
                {
                    "applying",
                    "failed",
                }
            ),
            "applying": frozenset(
                {
                    "applied",
                    "failed",
                }
            ),
            "applied": frozenset(
                {
                    "archived",
                }
            ),
            "rejected": frozenset(
                {
                    "archived",
                }
            ),
            "failed": frozenset(
                {
                    "archived",
                }
            ),
            "archived": frozenset(),
        },
        init=False,
        repr=False,
    )

    def write(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode = DiffJobMode.CREATE,
        features_by_class: Mapping[
            str,
            Sequence[ReviewFeature],
        ],
        metadata: Mapping[
            str,
            Any,
        ] | None = None,
        validation_success: bool = False,
        job_status: str = "pending",
    ) -> DiffSchemaWriteResult:
        """
        Write review features into tww_diff.
        """

        metadata = metadata or {}

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            cursor = connection.cursor()

            if job_mode == DiffJobMode.REPLACE:
                self._delete_existing_job(
                    cursor=cursor,
                    job_id=job_id,
                )
            elif job_mode == DiffJobMode.CREATE:
                self._assert_job_does_not_exist(
                    cursor=cursor,
                    job_id=job_id,
                )
            else:
                raise NotImplementedError(
                    "Diff-job refresh is not implemented."
                )

            job_db_id = self._insert_metadata(
                cursor=cursor,
                job_id=job_id,
                metadata=metadata,
                validation_success=validation_success,
                job_status=job_status,
            )

            row_count = 0

            for class_id, features in features_by_class.items():
                table_columns = self._table_columns(
                    cursor=cursor,
                    table_name=class_id,
                )

                self._assert_required_columns(
                    table_name=class_id,
                    table_columns=table_columns,
                )

                for feature in features:
                    self._insert_feature(
                        cursor=cursor,
                        job_db_id=job_db_id,
                        table_name=class_id,
                        feature=feature,
                        table_columns=table_columns,
                    )

                    row_count += 1

            connection.commit()

        return DiffSchemaWriteResult(
            job_db_id=job_db_id,
            job_id=job_id,
            row_count=row_count,
        )

    def review_job(
        self,
        *,
        job_id: str,
        include_features: bool = True,
    ) -> DiffReviewJob | None:
        """
        Return one persisted diff review job.
        """

        with self.connection_factory.connection(
            autocommit=True,
        ) as connection:
            cursor = connection.cursor()

            job_row = self._review_job_row(
                cursor=cursor,
                job_id=job_id,
            )

            if job_row is None:
                return None

            features_by_class: dict[
                str,
                list[ReviewFeature],
            ] = {}

            if include_features:
                features_by_class = self._review_features_by_class(
                    cursor=cursor,
                    job_db_id=job_row["id"],
                )

        return DiffReviewJob(
            job_db_id=job_row["id"],
            job_id=job_row["job_id"],
            job_status=job_row["job_status"],
            validation_success=job_row["validation_success"],
            metadata=self._merged_job_metadata(
                row=job_row,
            ),
            features_by_class=features_by_class,
        )

    def require_review_job(
        self,
        *,
        job_id: str,
        include_features: bool = True,
    ) -> DiffReviewJob:
        """
        Return one persisted review job or raise an explicit error.
        """

        job = self.review_job(
            job_id=job_id,
            include_features=include_features,
        )

        if job is None:
            raise DiffJobNotFoundError(
                job_id=job_id,
            )

        return job

    def review_features(
        self,
        *,
        job_id: str,
    ) -> dict[
        str,
        list[ReviewFeature],
    ]:
        """
        Return review features grouped by canonical class identifier.
        """

        job = self.require_review_job(
            job_id=job_id,
            include_features=True,
        )

        return {
            class_id: list(features)
            for class_id, features in job.features_by_class.items()
        }

    def job_counts(
        self,
        *,
        job_id: str,
    ) -> DiffJobCounts:
        """
        Return aggregated review-row counts for one diff job.
        """

        with self.connection_factory.connection(
            autocommit=True,
        ) as connection:
            cursor = connection.cursor()

            job_db_id = self._job_db_id(
                cursor=cursor,
                job_id=job_id,
            )

            total_count = 0
            restricted_count = 0
            rejected_count = 0
            created_count = 0
            altered_count = 0
            deleted_count = 0

            for table_name in self._review_table_names(
                cursor=cursor,
            ):
                cursor.execute(
                    f"""
                    SELECT
                        count(*) AS total_count,

                        count(*) FILTER (
                            WHERE unpermitted_values <> '{{}}'::jsonb
                        ) AS restricted_count,

                        count(*) FILTER (
                            WHERE jsonb_array_length(
                                validation_findings
                            ) > 0
                        ) AS rejected_count,

                        count(*) FILTER (
                            WHERE is_created
                        ) AS created_count,

                        count(*) FILTER (
                            WHERE is_altered
                        ) AS altered_count,

                        count(*) FILTER (
                            WHERE is_deleted
                        ) AS deleted_count

                    FROM {self._table(table_name)}
                    WHERE job_id = %s;
                    """,
                    (
                        job_db_id,
                    ),
                )

                row = cursor.fetchone()

                if row is None:
                    raise DiffSchemaContractError(
                        table_name=(
                            f"{self.schema}.{table_name}"
                        ),
                        message=(
                            "Could not determine review-row counts."
                        ),
                    )

                total_count += int(
                    row[0],
                )

                restricted_count += int(
                    row[1],
                )

                rejected_count += int(
                    row[2],
                )

                created_count += int(
                    row[3],
                )

                altered_count += int(
                    row[4],
                )

                deleted_count += int(
                    row[5],
                )

        return DiffJobCounts(
            total_count=total_count,
            restricted_count=restricted_count,
            rejected_count=rejected_count,
            created_count=created_count,
            altered_count=altered_count,
            deleted_count=deleted_count,
        )

    def review_feature_count(
        self,
        *,
        job_id: str,
    ) -> int:
        """
        Return the total number of review rows for one job.
        """

        return self.job_counts(
            job_id=job_id,
        ).total_count

    def rejected_row_count(
        self,
        *,
        job_id: str,
    ) -> int:
        """
        Return the number of blocking review rows.
        """

        return self.job_counts(
            job_id=job_id,
        ).rejected_count

    def restricted_row_count(
        self,
        *,
        job_id: str,
    ) -> int:
        """
        Return the number of blocking review rows.
        """

        return self.job_counts(
            job_id=job_id,
        ).restricted_count

    def assert_job_can_be_accepted(
        self,
        *,
        job_id: str,
    ) -> DiffReviewJob:
        """
        Validate that one pending job is eligible for acceptance.
        """

        job = self.require_review_job(
            job_id=job_id,
            include_features=False,
        )

        if job.job_status != "pending":
            raise DiffJobStateError(
                job_id=job_id,
                expected_status="pending",
                actual_status=job.job_status,
            )

        if not job.validation_success:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    "source validation was not successful."
                ),
            )

        rejected_count = self.rejected_row_count(
            job_id=job_id,
        )

        if rejected_count:
            raise DiffJobEligibilityError(
                job_id=job_id,
                reason=(
                    f"{rejected_count} review rows contain "
                    "blocking findings."
                ),
            )

        return job

    def transition_job_status(
        self,
        *,
        job_id: str,
        expected_status: str,
        new_status: str,
        failure: Mapping[
            str,
            Any,
        ] | None = None,
    ) -> None:
        """
        Atomically transition one review job to a new lifecycle state.
        """

        self._assert_supported_status_transition(
            expected_status=expected_status,
            new_status=new_status,
        )

        failure_payload = dict(
            failure or {},
        )

        if (
            new_status == "failed"
            and not failure_payload
        ):
            failure_payload = {
                "phase": expected_status,
                "message": (
                    "The diff review workflow failed without "
                    "additional diagnostic information."
                ),
            }

        assignments = [
            "job_status = %s",
            "updated_at = now()",
        ]
        parameters: list[Any] = [
            new_status,
        ]

        if new_status == "accepted":
            assignments.extend(
                [
                    "accepted_at = now()",
                    "failure = '{}'::jsonb",
                ]
            )

        elif new_status == "applying":
            assignments.extend(
                [
                    "application_started_at = now()",
                    "application_finished_at = NULL",
                    "failure = '{}'::jsonb",
                ]
            )

        elif new_status == "applied":
            assignments.extend(
                [
                    "application_finished_at = now()",
                    "failure = '{}'::jsonb",
                ]
            )

        elif new_status == "failed":
            assignments.extend(
                [
                    "application_finished_at = now()",
                    "failure = %s::jsonb",
                ]
            )
            parameters.append(
                self._json_dumps(
                    failure_payload,
                )
            )

        parameters.extend(
            [
                job_id,
                expected_status,
            ]
        )

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            cursor = connection.cursor()

            cursor.execute(
                f"""
                UPDATE {self._table("metadata")}
                SET
                    {", ".join(assignments)}
                WHERE job_id = %s
                  AND job_status = %s
                RETURNING id;
                """,
                tuple(parameters),
            )

            row = cursor.fetchone()

            if row is None:
                self._raise_transition_error(
                    cursor=cursor,
                    job_id=job_id,
                    expected_status=expected_status,
                    new_status=new_status,
                )

            connection.commit()

    def accept_job(
        self,
        *,
        job_id: str,
    ) -> None:
        """
        Accept one eligible pending review job.
        """

        self.assert_job_can_be_accepted(
            job_id=job_id,
        )

        self.transition_job_status(
            job_id=job_id,
            expected_status="pending",
            new_status="accepted",
        )

    def reject_job(
        self,
        *,
        job_id: str,
    ) -> None:
        """
        Reject one pending review job.
        """

        self.transition_job_status(
            job_id=job_id,
            expected_status="pending",
            new_status="rejected",
        )

    def acquire_job_for_application(
        self,
        *,
        job_id: str,
    ) -> None:
        """
        Acquire one accepted job for persistence.
        """

        self.transition_job_status(
            job_id=job_id,
            expected_status="accepted",
            new_status="applying",
        )

    def mark_job_applied(
        self,
        *,
        job_id: str,
    ) -> None:
        """
        Mark one applying job as successfully applied.
        """

        self.transition_job_status(
            job_id=job_id,
            expected_status="applying",
            new_status="applied",
        )

    def mark_job_failed(
        self,
        *,
        job_id: str,
        expected_status: str,
        phase: str,
        error_type: str,
        message: str,
    ) -> None:
        """
        Mark one active review job as failed.
        """

        self.transition_job_status(
            job_id=job_id,
            expected_status=expected_status,
            new_status="failed",
            failure={
                "phase": phase,
                "error_type": error_type,
                "message": message,
            },
        )

    def archive_job(
        self,
        *,
        job_id: str,
        expected_status: str,
    ) -> None:
        """
        Archive one terminal review job.
        """

        self.transition_job_status(
            job_id=job_id,
            expected_status=expected_status,
            new_status="archived",
        )

    def set_backup_path(
        self,
        *,
        job_id: str,
        expected_status: str,
        backup_path: str | None,
    ) -> None:
        """
        Store or clear the optional quarantine backup path.

        The diff schema records backup metadata only. Backup creation,
        restoration and deletion are outside this service.
        """

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            cursor = connection.cursor()

            cursor.execute(
                f"""
                UPDATE {self._table("metadata")}
                SET
                    backup_path = %s,
                    updated_at = now()
                WHERE job_id = %s
                  AND job_status = %s
                RETURNING id;
                """,
                (
                    backup_path,
                    job_id,
                    expected_status,
                ),
            )

            row = cursor.fetchone()

            if row is None:
                self._raise_expected_status_error(
                    cursor=cursor,
                    job_id=job_id,
                    expected_status=expected_status,
                )

            connection.commit()

    def clear_backup_path(
        self,
        *,
        job_id: str,
        expected_status: str,
    ) -> None:
        """
        Clear the optional quarantine backup path.
        """

        self.set_backup_path(
            job_id=job_id,
            expected_status=expected_status,
            backup_path=None,
        )

    def _raise_expected_status_error(
        self,
        *,
        cursor,
        job_id: str,
        expected_status: str,
    ) -> None:
        cursor.execute(
            f"""
            SELECT job_status
            FROM {self._table("metadata")}
            WHERE job_id = %s;
            """,
            (
                job_id,
            ),
        )

        row = cursor.fetchone()

        if row is None:
            raise DiffJobNotFoundError(
                job_id=job_id,
            )

        raise DiffJobStateError(
            job_id=job_id,
            expected_status=expected_status,
            actual_status=str(row[0]),
        )

    def _raise_transition_error(
        self,
        *,
        cursor,
        job_id: str,
        expected_status: str,
        new_status: str,
    ) -> None:
        cursor.execute(
            f"""
            SELECT job_status
            FROM {self._table("metadata")}
            WHERE job_id = %s;
            """,
            (
                job_id,
            ),
        )

        row = cursor.fetchone()

        if row is None:
            raise DiffJobNotFoundError(
                job_id=job_id,
            )

        raise DiffJobTransitionError(
            job_id=job_id,
            expected_status=expected_status,
            new_status=new_status,
            actual_status=str(row[0]),
        )

    def _assert_supported_status_transition(
        self,
        *,
        expected_status: str,
        new_status: str,
    ) -> None:
        allowed_targets = self._allowed_status_transitions.get(
            expected_status,
        )

        if allowed_targets is None:
            raise ValueError(
                f"Unknown diff-job status: {expected_status!r}."
            )

        if new_status not in allowed_targets:
            raise ValueError(
                "Unsupported diff-job status transition: "
                f"{expected_status!r} -> {new_status!r}."
            )

    def _review_job_row(
        self,
        *,
        cursor,
        job_id: str,
    ) -> dict[
        str,
        Any,
    ] | None:
        cursor.execute(
            f"""
            SELECT
                id,
                job_id,
                job_status,
                import_tstamp,
                diff_tstamp,
                updated_at,
                accepted_at,
                application_started_at,
                application_finished_at,
                validation_success,
                source_model,
                source_file,
                import_schema,
                live_schema,
                backup_path,
                metadata,
                failure
            FROM {self._table("metadata")}
            WHERE job_id = %s;
            """,
            (
                job_id,
            ),
        )

        return self._fetchone_mapping(
            cursor,
        )

    def _merged_job_metadata(
        self,
        *,
        row: Mapping[
            str,
            Any,
        ],
    ) -> dict[
        str,
        Any,
    ]:
        metadata = self._json_object(
            row.get(
                "metadata",
            ),
            field_name="metadata",
        )

        metadata.update(
            {
                "import_tstamp": row.get(
                    "import_tstamp",
                ),
                "diff_tstamp": row.get(
                    "diff_tstamp",
                ),
                "updated_at": row.get(
                    "updated_at",
                ),
                "accepted_at": row.get(
                    "accepted_at",
                ),
                "application_started_at": row.get(
                    "application_started_at",
                ),
                "application_finished_at": row.get(
                    "application_finished_at",
                ),
                "source_model": row.get(
                    "source_model",
                ),
                "source_file": row.get(
                    "source_file",
                ),
                "import_schema": row.get(
                    "import_schema",
                ),
                "live_schema": row.get(
                    "live_schema",
                ),
                "backup_path": row.get(
                    "backup_path",
                ),
                "failure": self._json_object(
                    row.get(
                        "failure",
                    ),
                    field_name="failure",
                ),
            }
        )

        return metadata

    def _review_features_by_class(
        self,
        *,
        cursor,
        job_db_id: int,
    ) -> dict[
        str,
        list[ReviewFeature],
    ]:
        features_by_class: dict[
            str,
            list[ReviewFeature],
        ] = {}

        for table_name in self._review_table_names(
            cursor=cursor,
        ):
            features = self._review_features_for_table(
                cursor=cursor,
                table_name=table_name,
                job_db_id=job_db_id,
            )

            if features:
                features_by_class[table_name] = features

        return features_by_class

    def _review_features_for_table(
        self,
        *,
        cursor,
        table_name: str,
        job_db_id: int,
    ) -> list:
        column_types = self._table_column_types(
            cursor=cursor,
            table_name=table_name,
        )

        self._assert_required_columns(
            table_name=table_name,
            table_columns=set(column_types),
        )

        cursor.execute(
            f"""
            SELECT *
            FROM {self._table(table_name)}
            WHERE job_id = %s
            ORDER BY diff_id;
            """,
            (
                job_db_id,
            ),
        )

        rows = self._fetchall_mappings(
            cursor,
        )

        return [
            self._review_feature_from_row(
                class_id=table_name,
                row=row,
                column_types=column_types,
            )
            for row in rows
        ]

    def _review_feature_from_row(
        self,
        *,
        class_id: str,
        row: Mapping[
            str,
            Any,
        ],
        column_types: Mapping[
            str,
            str,
        ],
    ) -> ReviewFeature:
        attributes: dict[
            str,
            Any,
        ] = {
            "is_created": bool(
                row["is_created"],
            ),
            "is_altered": bool(
                row["is_altered"],
            ),
            "is_deleted": bool(
                row["is_deleted"],
            ),
            "is_rejected": bool(
                row["is_rejected"],
            ),
            "import_values": self._json_object(
                row["import_values"],
                field_name="import_values",
            ),
            "canonical_values": self._json_object(
                row["canonical_values"],
                field_name="canonical_values",
            ),
            "changed_attributes": self._json_array(
                row["changed_attributes"],
                field_name="changed_attributes",
            ),
            "unpermitted_values": self._json_object(
                row["unpermitted_values"],
                field_name="unpermitted_values",
            ),
            "permission_findings": self._json_array(
                row["permission_findings"],
                field_name="permission_findings",
            ),
            "validation_findings": self._json_array(
                row["validation_findings"],
                field_name="validation_findings",
            ),
            "diff_id": row.get(
                "diff_id",
            ),
            "created_at": row.get(
                "created_at",
            ),
        }

        geometries: dict[
            str,
            Any,
        ] = {}

        reserved_columns = self._reserved_feature_columns()

        for column_name, value in row.items():
            if column_name in reserved_columns:
                continue

            if column_types.get(
                column_name,
            ) == "geometry":
                geometries[column_name] = value
                continue

            attributes[column_name] = value

        return ReviewFeature(
            class_id=class_id,
            object_id=str(
                row["obj_id"],
            ),
            attributes=attributes,
            geometries=geometries,
        )

    def _review_table_names(
        self,
        *,
        cursor,
    ) -> tuple[
        str,
        ...,
    ]:
        cursor.execute(
            """
            SELECT table_name
            FROM information_schema.columns
            WHERE table_schema = %s
            GROUP BY table_name
            HAVING bool_or(
                column_name = 'job_id'
            )
            AND bool_or(
                column_name = 'obj_id'
            )
            AND bool_or(
                column_name = 'is_rejected'
            )
            ORDER BY table_name;
            """,
            (
                self.schema,
            ),
        )

        return tuple(
            str(row[0])
            for row in cursor.fetchall()
        )

    def _job_db_id(
        self,
        *,
        cursor,
        job_id: str,
    ) -> int:
        cursor.execute(
            f"""
            SELECT id
            FROM {self._table("metadata")}
            WHERE job_id = %s;
            """,
            (
                job_id,
            ),
        )

        row = cursor.fetchone()

        if row is None:
            raise DiffJobNotFoundError(
                job_id=job_id,
            )

        return int(row[0])

    def _fetchone_mapping(
        self,
        cursor,
    ) -> dict[
        str,
        Any,
    ] | None:
        row = cursor.fetchone()

        if row is None:
            return None

        column_names = self._cursor_column_names(
            cursor,
        )

        return dict(
            zip(
                column_names,
                row,
                strict=True,
            )
        )

    def _fetchall_mappings(
        self,
        cursor,
    ) -> list[
        dict[
            str,
            Any,
        ],
    ]:
        column_names = self._cursor_column_names(
            cursor,
        )

        return [
            dict(
                zip(
                    column_names,
                    row,
                    strict=True,
                )
            )
            for row in cursor.fetchall()
        ]

    def _cursor_column_names(
        self,
        cursor,
    ) -> tuple[
        str,
        ...,
    ]:
        if cursor.description is None:
            raise RuntimeError(
                "The database cursor has no result description."
            )

        return tuple(
            str(
                description.name
                if hasattr(
                    description,
                    "name",
                )
                else description[0]
            )
            for description in cursor.description
        )

    def _json_object(
        self,
        value: Any,
        *,
        field_name: str,
    ) -> dict[
        str,
        Any,
    ]:
        decoded = self._decode_json(
            value,
        )

        if not isinstance(
            decoded,
            dict,
        ):
            raise DiffSchemaContractError(
                column_name=field_name,
                message=(
                    "The diff field must contain a JSON object."
                ),
            )

        return decoded

    def _json_array(
        self,
        value: Any,
        *,
        field_name: str,
    ) -> list:
        decoded = self._decode_json(
            value,
        )

        if not isinstance(
            decoded,
            list,
        ):
            raise DiffSchemaContractError(
                column_name=field_name,
                message=(
                    "The diff field must contain a JSON array."
                ),
            )

        return decoded

    def _decode_json(
        self,
        value: Any,
    ) -> Any:
        if isinstance(
            value,
            str,
        ):
            return json.loads(
                value,
            )

        return value

    def _delete_existing_job(
        self,
        *,
        cursor,
        job_id: str,
    ) -> None:
        cursor.execute(
            f"""
            DELETE FROM {self._table("metadata")}
            WHERE job_id = %s;
            """,
            (
                job_id,
            ),
        )

    def _assert_job_does_not_exist(
        self,
        *,
        cursor,
        job_id: str,
    ) -> None:
        cursor.execute(
            f"""
            SELECT EXISTS (
                SELECT 1
                FROM {self._table("metadata")}
                WHERE job_id = %s
            );
            """,
            (
                job_id,
            ),
        )

        row = cursor.fetchone()

        if row is None:
            raise RuntimeError(
                "Could not determine whether the diff job exists."
            )

        if bool(
            row[0],
        ):
            raise RuntimeError(
                f"Diff job {job_id!r} already exists."
            )

    def _insert_metadata(
        self,
        *,
        cursor,
        job_id: str,
        metadata: Mapping[
            str,
            Any,
        ],
        validation_success: bool,
        job_status: str,
    ) -> int:
        cursor.execute(
            f"""
            INSERT INTO {self._table("metadata")} (
                job_id,
                job_status,
                validation_success,
                source_model,
                source_file,
                import_schema,
                live_schema,
                backup_path,
                metadata
            )
            VALUES (
                %s,
                %s,
                %s,
                %s,
                %s,
                %s,
                %s,
                %s,
                %s::jsonb
            )
            RETURNING id;
            """,
            (
                job_id,
                job_status,
                validation_success,
                metadata.get(
                    "source_model",
                ),
                metadata.get(
                    "source_file",
                ),
                metadata.get(
                    "import_schema",
                ),
                metadata.get(
                    "live_schema",
                ),
                metadata.get(
                    "backup_path",
                ),
                self._json_dumps(
                    metadata,
                ),
            ),
        )

        row = cursor.fetchone()

        if row is None:
            raise RuntimeError(
                f"Could not create diff review job {job_id!r}."
            )

        return int(row[0])

    def _insert_feature(
        self,
        *,
        cursor,
        job_db_id: int,
        table_name: str,
        feature: ReviewFeature,
        table_columns: set[str],
    ) -> None:
        values = self._base_column_values(
            job_db_id=job_db_id,
            feature=feature,
        )

        values.update(
            self._extra_column_values(
                feature=feature,
                table_columns=table_columns,
            )
        )

        columns: list[str] = []
        expressions: list[str] = []
        parameters: list[Any] = []

        for column_name, value in values.items():
            if column_name not in table_columns:
                continue

            columns.append(
                self._quote_identifier(
                    column_name,
                )
            )

            expression, expression_parameters = (
                self._value_expression(
                    column_name=column_name,
                    value=value,
                )
            )

            expressions.append(
                expression,
            )
            parameters.extend(
                expression_parameters,
            )

        for geometry_name, geometry_value in feature.geometries.items():
            if geometry_name not in table_columns:
                continue

            columns.append(
                self._quote_identifier(
                    geometry_name,
                )
            )

            expression, expression_parameters = (
                self._geometry_expression(
                    geometry_value,
                )
            )

            expressions.append(
                expression,
            )
            parameters.extend(
                expression_parameters,
            )

        if not columns:
            raise DiffSchemaContractError(
                table_name=(
                    f"{self.schema}.{table_name}"
                ),
                message=(
                    "The review feature contains no persistable columns."
                ),
            )

        cursor.execute(
            f"""
            INSERT INTO {self._table(table_name)} (
                {", ".join(columns)}
            )
            VALUES (
                {", ".join(expressions)}
            );
            """,
            tuple(parameters),
        )

    def _base_column_values(
        self,
        *,
        job_db_id: int,
        feature: ReviewFeature,
    ) -> dict[
        str,
        Any,
    ]:
        attributes = feature.attributes

        return {
            "job_id": job_db_id,
            "obj_id": feature.object_id,
            "is_created": attributes.get(
                "is_created",
                False,
            ),
            "is_altered": attributes.get(
                "is_altered",
                False,
            ),
            "is_deleted": attributes.get(
                "is_deleted",
                False,
            ),
            "import_values": attributes.get(
                "import_values",
                {},
            ),
            "canonical_values": attributes.get(
                "canonical_values",
                {},
            ),
            "changed_attributes": attributes.get(
                "changed_attributes",
                (),
            ),
            "unpermitted_values": attributes.get(
                "unpermitted_values",
                {},
            ),
            "permission_findings": attributes.get(
                "permission_findings",
                (),
            ),
            "validation_findings": attributes.get(
                "validation_findings",
                (),
            ),
        }

    def _extra_column_values(
        self,
        *,
        feature: ReviewFeature,
        table_columns: set[str],
    ) -> dict[
        str,
        Any,
    ]:
        reserved_columns = self._reserved_feature_columns()

        return {
            key: value
            for key, value in feature.attributes.items()
            if (
                key in table_columns
                and key not in reserved_columns
            )
        }

    def _reserved_feature_columns(
        self,
    ) -> frozenset:
        return frozenset(
            {
                "diff_id",
                "job_id",
                "obj_id",
                "is_created",
                "is_altered",
                "is_deleted",
                "is_rejected",
                "import_values",
                "canonical_values",
                "changed_attributes",
                "unpermitted_values",
                "permission_findings",
                "validation_findings",
                "created_at",
            }
        )

    def _value_expression(
        self,
        *,
        column_name: str,
        value: Any,
    ) -> tuple[
        str,
        list[Any],
    ]:
        if column_name in {
            "import_values",
            "canonical_values",
            "changed_attributes",
            "unpermitted_values",
            "permission_findings",
            "validation_findings",
        }:
            return (
                "%s::jsonb",
                [
                    self._json_dumps(
                        value,
                    )
                ],
            )

        return (
            "%s",
            [
                self._database_value(
                    value,
                )
            ],
        )

    def _geometry_expression(
        self,
        value: Any,
    ) -> tuple[
        str,
        list[Any],
    ]:
        if value is None:
            return (
                "%s",
                [
                    None,
                ],
            )

        if isinstance(
            value,
            bytes,
        ):
            return (
                "ST_GeomFromWKB(%s, %s)",
                [
                    value,
                    self.srid,
                ],
            )

        wkt = self._geometry_to_wkt(
            value,
        )

        if wkt is None:
            raise DiffSchemaContractError(
                column_name="geometry",
                message=(
                    "Unsupported non-null geometry representation."
                ),
            )

        return (
            "ST_GeomFromText(%s, %s)",
            [
                wkt,
                self.srid,
            ],
        )

    def _geometry_to_wkt(
        self,
        value: Any,
    ) -> str | None:
        if value is None:
            return None

        if hasattr(
            value,
            "asWkt",
        ):
            return value.asWkt()

        if hasattr(
            value,
            "ExportToWkt",
        ):
            return value.ExportToWkt()

        if hasattr(
            value,
            "wkt",
        ):
            return value.wkt

        if isinstance(
            value,
            str,
        ):
            return value

        return None

    def _database_value(
        self,
        value: Any,
    ) -> Any:
        if isinstance(
            value,
            (
                datetime,
                date,
            ),
        ):
            return value.isoformat()

        if is_dataclass(
            value,
        ):
            return self._json_dumps(
                asdict(
                    value,
                )
            )

        if isinstance(
            value,
            Enum,
        ):
            return value.value

        return value

    def _table_columns(
        self,
        *,
        cursor,
        table_name: str,
    ) -> set:
        return set(
            self._table_column_types(
                cursor=cursor,
                table_name=table_name,
            )
        )

    def _table_column_types(
        self,
        *,
        cursor,
        table_name: str,
    ) -> dict[
        str,
        str,
    ]:
        cursor.execute(
            """
            SELECT
                column_name,
                CASE
                    WHEN udt_name = 'geometry'
                        THEN 'geometry'
                    ELSE data_type
                END AS column_type
            FROM information_schema.columns
            WHERE table_schema = %s
              AND table_name = %s
            ORDER BY ordinal_position;
            """,
            (
                self.schema,
                table_name,
            ),
        )

        return {
            str(row[0]): str(row[1])
            for row in cursor.fetchall()
        }

    def _assert_required_columns(
        self,
        *,
        table_name: str,
        table_columns: set[str],
    ) -> None:
        required_columns = {
            "job_id",
            "obj_id",
            "is_created",
            "is_altered",
            "is_deleted",
            "is_rejected",
            "import_values",
            "canonical_values",
            "changed_attributes",
            "unpermitted_values",
            "permission_findings",
            "validation_findings",
        }

        missing_columns = required_columns.difference(
            table_columns,
        )

        if missing_columns:
            raise DiffSchemaContractError(
                table_name=(
                    f"{self.schema}.{table_name}"
                ),
                message=(
                    f"Missing columns: {sorted(missing_columns)}"
                ),
            )

    def _json_dumps(
        self,
        value: Any,
    ) -> str:
        return json.dumps(
            value,
            default=self._json_default,
        )

    def _json_default(
        self,
        value: Any,
    ) -> Any:
        if isinstance(
            value,
            (
                datetime,
                date,
            ),
        ):
            return value.isoformat()

        if is_dataclass(
            value,
        ):
            return asdict(
                value,
            )

        if isinstance(
            value,
            Enum,
        ):
            return value.value

        return str(
            value,
        )

    def _table(
        self,
        table_name: str,
    ) -> str:
        return (
            f"{self._quote_identifier(self.schema)}."
            f"{self._quote_identifier(table_name)}"
        )

    def _quote_identifier(
        self,
        value: str,
    ) -> str:
        return (
            '"'
            + value.replace(
                '"',
                '""',
            )
            + '"'
        )

    def prepare_source(
        self,
        *,
        job_id: str,
        source: PreparedSource,
    ) -> None:
        """
        Stage one prepared source in memory.
        """

        self._prepared_sources[job_id] = source

    def prepared_source(
        self,
        *,
        job_id: str,
    ) -> PreparedSource:
        """
        Return the prepared source for one diff workflow.
        """

        try:
            return self._prepared_sources[job_id]
        except KeyError as exception:
            raise KeyError(
                "No prepared source exists for diff workflow "
                f"{job_id!r}."
            ) from exception

    def clear_prepared_source(
        self,
        *,
        job_id: str,
    ) -> None:
        """
        Remove the prepared source for a completed diff workflow.
        """

        self._prepared_sources.pop(
            job_id,
            None,
        )
