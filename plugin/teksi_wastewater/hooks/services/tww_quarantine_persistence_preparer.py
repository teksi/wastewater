# teksi_wastewater/hooks/services/tww_quarantine_persistence_preparer.py

from __future__ import annotations

import logging
from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

from sqlalchemy.orm import Session
from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
)
from teksi_hooks.models.review import (
    ReviewFeature,
)
from teksi_hooks.models.validation import (
    ValidationDefinition,
)
from teksi_wastewater.hooks.exceptions import (
    DiffSchemaContractError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)

logger = logging.getLogger(
    __name__,
)


@dataclass(
    slots=True,
    frozen=True,
)
class QuarantineAttributeTarget:
    """
    One quarantine attribute mapped to a canonical attribute.
    """

    source_class_id: str
    source_attribute_id: str
    canonical_class_id: str
    canonical_attribute_id: str


@dataclass(
    slots=True,
)
class TwwQuarantinePersistencePreparer:
    """
    Prepare one quarantine schema for persistence.

    Unpermitted non-mandatory update attributes are set to NULL. The existing
    importer is invoked with filter_nulls=True, so these values are excluded
    from live updates.

    Mandatory attributes are retained because they may be required by the
    source INTERLIS model or by the existing importer mapping.

    Created source rows whose object operation is not permitted are removed
    from quarantine.

    Delete suppression is intentionally kept separate because deletion may be
    represented by source-model-specific lifecycle or basket semantics.
    """

    diff_schema_service: TwwDiffSchemaService

    quarantine_session: Session

    quarantine_classes: Any

    model_mapping: ModelMappingLookupCapability

    canonical_metadata: CanonicalModelMetadata

    validation_definition: ValidationDefinition

    def prepare(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> None:
        """
        Apply persisted permission decisions to quarantine.
        """

        try:
            self._prepare(
                job_id=job_id,
                import_schema=import_schema,
            )

            self.quarantine_session.commit()

        except Exception:
            self.quarantine_session.rollback()
            raise

        finally:
            self.quarantine_session.close()

    def _prepare(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> None:
        """
        Apply persisted permission decisions to quarantine.

        The caller must create and register a quarantine backup before calling
        this method.
        """

        features_by_class = self.diff_schema_service.review_features(
            job_id=job_id,
        )

        nulled_attribute_count = 0
        removed_object_count = 0

        for (
            canonical_class_id,
            features,
        ) in features_by_class.items():
            for feature in features:
                if self._must_remove_created_object(
                    feature,
                ):
                    self._delete_created_source_object(
                        job_id=job_id,
                        canonical_class_id=canonical_class_id,
                        feature=feature,
                    )

                    removed_object_count += 1

                    continue

                if not feature.attributes.get(
                    "is_altered",
                    False,
                ):
                    continue

                nulled_attribute_count += self._null_unpermitted_attributes(
                    job_id=job_id,
                    canonical_class_id=canonical_class_id,
                    feature=feature,
                )

        self.quarantine_session.flush()

        logger.info(
            "Prepared quarantine schema %r for diff job %r: "
            "removed %s forbidden created objects and set %s "
            "unpermitted update attributes to NULL.",
            import_schema,
            job_id,
            removed_object_count,
            nulled_attribute_count,
        )

    def _must_remove_created_object(
        self,
        feature: ReviewFeature,
    ) -> bool:
        """
        Return whether a created source object must be removed.

        An unpermitted created object is represented by an object-level
        permission finding without relying on translated finding messages.
        """

        if not feature.attributes.get(
            "is_created",
            False,
        ):
            return False

        permission_findings = feature.attributes.get(
            "permission_findings",
            (),
        )

        if not isinstance(
            permission_findings,
            (
                list,
                tuple,
            ),
        ):
            raise DiffSchemaContractError(
                column_name="permission_findings",
                message=("The review feature permission findings must " "contain a JSON array."),
            )

        return any(
            self._is_object_level_finding(
                finding,
            )
            for finding in permission_findings
        )

    def _is_object_level_finding(
        self,
        finding: Any,
    ) -> bool:
        """
        Return whether a serialized permission finding is object-level.

        Attribute-level findings contain a non-empty attribute_name.
        """

        if not isinstance(
            finding,
            Mapping,
        ):
            raise DiffSchemaContractError(
                column_name="permission_findings",
                message=("Each persisted permission finding must " "contain a JSON object."),
            )

        attribute_name = finding.get(
            "attribute_name",
        )

        return attribute_name in (
            None,
            "",
        )

    def _null_unpermitted_attributes(
        self,
        *,
        job_id: str,
        canonical_class_id: str,
        feature: ReviewFeature,
    ) -> int:
        """
        Set mapped non-mandatory source attributes to NULL.
        """

        unpermitted_values = feature.attributes.get(
            "unpermitted_values",
            {},
        )

        if not isinstance(
            unpermitted_values,
            Mapping,
        ):
            raise DiffSchemaContractError(
                column_name="unpermitted_values",
                message=("The review feature unpermitted values must " "contain a JSON object."),
            )

        if not unpermitted_values:
            return 0

        mandatory_attributes = self.validation_definition.mandatory_for_class(
            canonical_class_id,
        )

        nulled_attribute_count = 0

        for canonical_attribute_id in unpermitted_values:
            if canonical_attribute_id in mandatory_attributes:
                logger.debug(
                    "Preserving mandatory unpermitted attribute " "%r.%r for diff job %r.",
                    canonical_class_id,
                    canonical_attribute_id,
                    job_id,
                )

                continue

            targets = self._source_attribute_targets(
                canonical_class_id=canonical_class_id,
                canonical_attribute_id=canonical_attribute_id,
            )

            if not targets:
                raise DiffSchemaContractError(
                    message=(
                        "No quarantine attribute mapping exists for "
                        "unpermitted canonical attribute "
                        f"{canonical_class_id!r}."
                        f"{canonical_attribute_id!r}."
                    ),
                )

            for target in targets:
                self._set_source_attribute_null(
                    job_id=job_id,
                    feature=feature,
                    target=target,
                )

                nulled_attribute_count += 1

        return nulled_attribute_count

    def _source_attribute_targets(
        self,
        *,
        canonical_class_id: str,
        canonical_attribute_id: str,
    ) -> tuple[
        QuarantineAttributeTarget,
        ...,
    ]:
        """
        Resolve source attributes mapped to one canonical attribute.

        This lookup supports ordinary resolved attribute mappings. Function-
        backed mappings must be handled by the AGXX-specific persistence path.
        """

        targets: list[QuarantineAttributeTarget,] = []

        for source_class_id in self._source_class_ids():
            class_mapping = self.model_mapping.try_class_definition(
                source_class_id,
            )

            if class_mapping is None:
                continue

            if class_mapping.function is not None:
                continue

            for (
                source_attribute_id,
                attribute_mapping,
            ) in class_mapping.attributes.items():
                if attribute_mapping.canonical_class_id != canonical_class_id:
                    continue

                if attribute_mapping.canonical_attr_id != canonical_attribute_id:
                    continue

                targets.append(
                    QuarantineAttributeTarget(
                        source_class_id=source_class_id,
                        source_attribute_id=source_attribute_id,
                        canonical_class_id=canonical_class_id,
                        canonical_attribute_id=(canonical_attribute_id),
                    )
                )

        return tuple(
            targets,
        )

    def _source_class_ids(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return source class identifiers exposed by quarantine ORM metadata.
        """

        classes = self.quarantine_classes

        if isinstance(
            classes,
            Mapping,
        ):
            return tuple(
                str(
                    class_id,
                )
                for class_id in classes
            )

        class_ids = []

        for class_id in dir(
            classes,
        ):
            if class_id.startswith(
                "_",
            ):
                continue

            source_class = getattr(
                classes,
                class_id,
            )

            if hasattr(
                source_class,
                "__table__",
            ):
                class_ids.append(
                    class_id,
                )

        return tuple(
            class_ids,
        )

    def _set_source_attribute_null(
        self,
        *,
        job_id: str,
        feature: ReviewFeature,
        target: QuarantineAttributeTarget,
    ) -> None:
        """
        Set one mapped source attribute to NULL.
        """

        source_class = self._source_class(
            target.source_class_id,
        )

        source_attribute = getattr(
            source_class,
            target.source_attribute_id,
            None,
        )

        if source_attribute is None:
            raise DiffSchemaContractError(
                message=(
                    "Unknown quarantine attribute "
                    f"{target.source_class_id!r}."
                    f"{target.source_attribute_id!r} for "
                    f"diff job {job_id!r}."
                ),
            )

        source_row = self._source_row(
            job_id=job_id,
            source_class=source_class,
            source_class_id=target.source_class_id,
            source_object_id=feature.object_id,
        )

        setattr(
            source_row,
            target.source_attribute_id,
            None,
        )

    def _delete_created_source_object(
        self,
        *,
        job_id: str,
        canonical_class_id: str,
        feature: ReviewFeature,
    ) -> None:
        """
        Remove a forbidden created object from quarantine.

        This first implementation supports source classes whose canonical
        class maps directly to the review feature class and whose object
        identity is represented by obj_id.
        """

        source_classes = []

        for source_class_id in self._source_class_ids():
            class_mapping = self.model_mapping.try_class_definition(
                source_class_id,
            )

            if class_mapping is None:
                continue

            if class_mapping.canonical_class_id != canonical_class_id:
                continue

            if class_mapping.function is not None:
                continue

            source_classes.append(
                (
                    source_class_id,
                    self._source_class(
                        source_class_id,
                    ),
                )
            )

        if not source_classes:
            raise DiffSchemaContractError(
                message=(
                    "No directly mapped quarantine class exists "
                    f"for forbidden created canonical object "
                    f"{canonical_class_id!r} with obj_id "
                    f"{feature.object_id!r}."
                ),
            )

        deleted_count = 0

        for (
            source_class_id,
            source_class,
        ) in source_classes:
            source_row = self._try_source_row(
                source_class=source_class,
                source_object_id=feature.object_id,
            )

            if source_row is None:
                continue

            self.quarantine_session.delete(
                source_row,
            )

            deleted_count += 1

        if deleted_count == 0:
            raise DiffSchemaContractError(
                message=(
                    "No quarantine object exists for forbidden "
                    f"created canonical object {canonical_class_id!r} "
                    f"with obj_id {feature.object_id!r}."
                ),
            )

    def _source_class(
        self,
        source_class_id: str,
    ) -> Any:
        """
        Return one mapped quarantine ORM class.
        """

        if isinstance(
            self.quarantine_classes,
            Mapping,
        ):
            source_class = self.quarantine_classes.get(
                source_class_id,
            )
        else:
            source_class = getattr(
                self.quarantine_classes,
                source_class_id,
                None,
            )

        if source_class is None:
            raise DiffSchemaContractError(
                message=("Unknown quarantine class " f"{source_class_id!r}."),
            )

        return source_class

    def _source_row(
        self,
        *,
        job_id: str,
        source_class: Any,
        source_class_id: str,
        source_object_id: str,
    ) -> Any:
        """
        Return exactly one quarantine row.
        """

        source_row = self._try_source_row(
            source_class=source_class,
            source_object_id=source_object_id,
        )

        if source_row is None:
            raise DiffSchemaContractError(
                message=(
                    "No quarantine object exists for "
                    f"{source_class_id!r} with obj_id "
                    f"{source_object_id!r} in diff job "
                    f"{job_id!r}."
                ),
            )

        return source_row

    def _try_source_row(
        self,
        *,
        source_class: Any,
        source_object_id: str,
    ) -> Any | None:
        """
        Return one quarantine row located by obj_id.

        Raises when the source identity is missing or ambiguous.
        """

        identity_attribute = getattr(
            source_class,
            "obj_id",
            None,
        )

        if identity_attribute is None:
            raise DiffSchemaContractError(
                message=(
                    "Quarantine class "
                    f"{source_class.__name__!r} does not expose "
                    "an obj_id identity attribute."
                ),
            )

        rows = (
            self.quarantine_session.query(
                source_class,
            )
            .filter(identity_attribute == source_object_id)
            .limit(
                2,
            )
            .all()
        )

        if not rows:
            return None

        if (
            len(
                rows,
            )
            > 1
        ):
            raise DiffSchemaContractError(
                message=(
                    "Multiple quarantine objects exist for "
                    f"{source_class.__name__!r} with obj_id "
                    f"{source_object_id!r}."
                ),
            )

        return rows[0]
