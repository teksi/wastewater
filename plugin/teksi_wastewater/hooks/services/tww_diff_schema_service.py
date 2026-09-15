from __future__ import annotations

from dataclasses import asdict, dataclass, is_dataclass, field
from datetime import date, datetime
from enum import Enum
import json
from typing import Any
from collections.abc import Mapping, Sequence

from teksi_hooks.models.review import (
    ReviewFeature,
    DiffSchemaWriteResult,
    PreparedSource,
)
from teksi_hooks.models.persistence import (
    DiffJobMode,
)
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.review import (
    SourcePreparer,
)


@dataclass(slots=True)
class TwwDiffSchemaService(SourcePreparer):
    """
    Plugin-side database writer for hook-side diff review state.

    This service only handles database access to the stable tww_diff schema.

    It does not:

    - classify changes;
    - evaluate rights;
    - validate values;
    - compare geometries;
    - normalize geometries;
    - create GeoPackages;
    - build QGIS layers.

    Expected database contract:

    - tww_diff.metadata exists;
    - one table per canonical class exists in tww_diff;
    - class rows reference metadata.id through job_id;
    - is_rejected is generated from permission_findings and validation_findings.
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

    def write(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode = DiffJobMode.CREATE,
        features_by_class: Mapping[
            str,
            Sequence[
                ReviewFeature,
            ],
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

        Parameters
        ----------
        job_id:
            Stable logical job identifier.

        features_by_class:
            Review features grouped by canonical class id.

        metadata:
            Optional job metadata.

        validation_success:
            Whether quarantine/import validation succeeded.

        job_status:
            Job status stored in tww_diff.metadata.job_status.

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
        if bool(row[0]):
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
                self._json_dumps(
                    metadata,
                ),
            ),
        )

        return cursor.fetchone()[0]

    def _insert_feature(
        self,
        *,
        cursor,
        job_db_id: int,
        table_name: str,
        feature: ReviewFeature,
        table_columns: set[
            str,
        ],
    ) -> None:
        values = self._base_column_values(
            job_db_id=job_db_id,
            feature=feature,
        )

        extra_values = self._extra_column_values(
            feature=feature,
            table_columns=table_columns,
        )

        values.update(
            extra_values,
        )

        columns = []
        expressions = []
        parameters = []

        for column_name, value in values.items():
            if column_name not in table_columns:
                continue

            columns.append(
                self._quote_identifier(
                    column_name,
                )
            )

            expression, expression_parameters = self._value_expression(
                column_name=column_name,
                value=value,
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

            expression, expression_parameters = self._geometry_expression(
                geometry_value,
            )

            expressions.append(
                expression,
            )

            parameters.extend(
                expression_parameters,
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
            tuple(
                parameters,
            ),
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
        table_columns: set[
            str,
        ],
    ) -> dict[
        str,
        Any,
    ]:
        reserved_columns = {
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

        return {
            key: value
            for key, value in feature.attributes.items()
            if key in table_columns
            and key not in reserved_columns
        }

    def _value_expression(
        self,
        *,
        column_name: str,
        value: Any,
    ) -> tuple[
        str,
        list[
            Any,
        ],
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
        list[
            Any,
        ],
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
            return (
                "%s",
                [
                    None,
                ],
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
        
        if isinstance(value,Enum):
            return value.value

        return value

    def _table_columns(
        self,
        *,
        cursor,
        table_name: str,
    ) -> set[
        str,
    ]:
        cursor.execute(
            """
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = %s
              AND table_name = %s;
            """,
            (
                self.schema,
                table_name,
            ),
        )

        return {
            row[0]
            for row in cursor.fetchall()
        }

    def _assert_required_columns(
        self,
        *,
        table_name: str,
        table_columns: set[
            str,
        ],
    ) -> None:
        required_columns = {
            "job_id",
            "obj_id",
            "is_created",
            "is_altered",
            "is_deleted",
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
            raise RuntimeError(
                "Diff table "
                f"{self.schema}.{table_name} is missing columns: "
                f"{sorted(missing_columns)}"
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

        A previously prepared source for the same job identifier is replaced.
        No review job or review feature is persisted by this operation.
        """

        self._prepared_sources[
            job_id
        ] = source

    def prepared_source(
        self,
        *,
        job_id: str,
    ) -> PreparedSource:
        """
        Return the prepared source for one diff workflow.

        Raises
        ------
        KeyError
            If no prepared source exists for the job identifier.
        """

        try:
            return self._prepared_sources[
                job_id
            ]
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

        Missing prepared sources are ignored so cleanup remains idempotent.
        """

        self._prepared_sources.pop(
            job_id,
            None,
        )
