# teksi_wastewater/hooks/services/tww_quarantine_persistence_preparer.py

from __future__ import annotations

import logging
from collections.abc import Mapping
from dataclasses import dataclass, field
from typing import Any

from sqlalchemy.orm import Session
from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
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
    frozen=True,
    slots=True,
)
class QuarantineAttributeTarget:
    """
    One source attribute mapped to a canonical attribute.
    """

    source_class_id: str
    source_attribute_id: str
    canonical_class_id: str
    canonical_attribute_id: str
    source_identity_attribute_id: str
    canonical_identity_attribute_id: str


@dataclass(
    slots=True,
)
class TwwQuarantinePersistencePreparer:
    """
    Prepare one retained quarantine schema for persistence.

    Unpermitted non-mandatory update attributes are set to NULL. The existing
    importer is invoked with ``filter_nulls=True``, so these values are excluded
    from live updates.

    Mandatory attributes are retained because they may be required by the
    source INTERLIS model or by the existing importer mapping.

    Created source rows whose object operation is not permitted are removed
    from quarantine.

    Function-backed mappings are not reverse-mapped by this preparer. They
    require their own source-model-specific persistence treatment.

    The caller owns the supplied SQLAlchemy session lifecycle and transaction.
    This preparer may modify ORM objects and flush the session, but it does not
    commit, roll back, or close the session.

    In a combined baseline and incremental workflow, one preparer instance is
    created for each retained source context. A preparer ignores review values
    that cannot be resolved through its own effective model mapping.
    """

    diff_schema_service: TwwDiffSchemaService

    quarantine_session: Session

    quarantine_classes: Any

    model_mapping: ModelMappingLookupCapability

    canonical_metadata: CanonicalModelMetadata

    validation_definition: ValidationDefinition

    source_role: str = "base"

    _source_class_ids_cache: (
        tuple[
            str,
            ...,
        ]
        | None
    ) = field(
        default=None,
        init=False,
        repr=False,
    )

    _source_attribute_targets_cache: dict[
        tuple[
            str,
            str,
        ],
        tuple[
            QuarantineAttributeTarget,
            ...,
        ],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_identity_targets_cache: dict[
        tuple[
            str,
            str,
        ],
        tuple[
            tuple[
                str,
                str,
            ],
            ...,
        ],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_class_cache: dict[
        str,
        Any,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_row_cache: dict[
        tuple[
            str,
            str,
            Any,
        ],
        Any | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    def prepare(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> None:
        """
        Apply persisted permission decisions to this quarantine source.

        The caller must create and register a quarantine backup before calling
        this method.

        The caller owns commit, rollback, and session closure.
        """

        features_by_class = self.diff_schema_service.review_features(
            job_id=job_id,
        )

        nulled_attribute_count = 0
        removed_object_count = 0
        skipped_feature_count = 0

        for (
            canonical_class_id,
            features,
        ) in features_by_class.items():
            for feature in features:
                if self._must_remove_created_object(
                    feature,
                ):
                    removed = self._delete_created_source_object(
                        job_id=job_id,
                        canonical_class_id=(canonical_class_id),
                        feature=feature,
                    )

                    if removed:
                        removed_object_count += 1
                    else:
                        skipped_feature_count += 1

                    continue

                if not feature.attributes.get(
                    "is_altered",
                    False,
                ):
                    continue

                (
                    nulled_count,
                    handled,
                ) = self._null_unpermitted_attributes(
                    job_id=job_id,
                    canonical_class_id=(canonical_class_id),
                    feature=feature,
                )

                nulled_attribute_count += nulled_count

                if not handled:
                    skipped_feature_count += 1

        self.quarantine_session.flush()

        logger.info(
            "Prepared quarantine schema %r for diff job %r "
            "and source role %r: removed %s forbidden created "
            "objects, set %s unpermitted update attributes to "
            "NULL, and skipped %s review features not owned by "
            "this source mapping.",
            import_schema,
            job_id,
            self.source_role,
            removed_object_count,
            nulled_attribute_count,
            skipped_feature_count,
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

        Attribute-level findings contain a non-empty ``attribute_name``.
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
    ) -> tuple[
        int,
        bool,
    ]:
        """
        Set mapped non-mandatory source attributes to NULL.

        Returns the number of nulled source attributes and whether this source
        context handled at least one affected canonical attribute.
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
            return (
                0,
                True,
            )

        identity = self._feature_identity(
            feature,
        )

        if identity.class_id != canonical_class_id:
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "The review feature class does not match its "
                    "persisted canonical identity. Feature class: "
                    f"{canonical_class_id!r}; identity class: "
                    f"{identity.class_id!r}."
                ),
            )

        mandatory_attributes = self.validation_definition.mandatory_for_class(
            canonical_class_id,
        )

        nulled_attribute_count = 0
        handled = False

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
                canonical_attribute_id=(canonical_attribute_id),
            )

            if not targets:
                continue

            target_handled = False

            for target in targets:
                source_identity_value = self._canonical_identity_value(
                    identity=identity,
                    canonical_identity_attribute_id=(target.canonical_identity_attribute_id),
                )

                if source_identity_value is None:
                    continue

                source_row = self._try_source_row(
                    source_class_id=(target.source_class_id),
                    source_identity_attribute_id=(target.source_identity_attribute_id),
                    source_identity_value=(source_identity_value),
                )

                if source_row is None:
                    continue

                setattr(
                    source_row,
                    target.source_attribute_id,
                    None,
                )

                nulled_attribute_count += 1
                target_handled = True
                handled = True

            if not target_handled:
                logger.debug(
                    "Source role %r has a mapping for canonical "
                    "attribute %r.%r but no matching quarantine "
                    "row for identity %r.",
                    self.source_role,
                    canonical_class_id,
                    canonical_attribute_id,
                    dict(
                        identity.attributes,
                    ),
                )

        return (
            nulled_attribute_count,
            handled,
        )

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

        Function-backed mappings are excluded because they cannot be safely
        reverse-mapped through ordinary attribute mappings.
        """

        cache_key = (
            canonical_class_id,
            canonical_attribute_id,
        )

        cached = self._source_attribute_targets_cache.get(
            cache_key,
        )

        if cached is not None:
            return cached

        targets: list[QuarantineAttributeTarget,] = []

        for source_class_id in self._source_class_ids():
            class_mapping = self.model_mapping.try_class_definition(
                source_class_id,
            )

            if class_mapping is None:
                continue

            if class_mapping.function is not None:
                continue

            identity_mapping = class_mapping.identities.get(
                canonical_class_id,
            )

            if identity_mapping is None:
                continue

            for (
                source_attribute_id,
                attribute_mapping,
            ) in class_mapping.attributes.items():
                target_class_id = (
                    attribute_mapping.canonical_class_id or class_mapping.canonical_class_id
                )

                if target_class_id != canonical_class_id:
                    continue

                if attribute_mapping.canonical_attr_id != canonical_attribute_id:
                    continue

                targets.append(
                    QuarantineAttributeTarget(
                        source_class_id=(source_class_id),
                        source_attribute_id=(source_attribute_id),
                        canonical_class_id=(canonical_class_id),
                        canonical_attribute_id=(canonical_attribute_id),
                        source_identity_attribute_id=(identity_mapping.source_attribute),
                        canonical_identity_attribute_id=(identity_mapping.canonical_attribute),
                    )
                )

        result = tuple(
            targets,
        )

        self._source_attribute_targets_cache[cache_key] = result

        return result

    def _delete_created_source_object(
        self,
        *,
        job_id: str,
        canonical_class_id: str,
        feature: ReviewFeature,
    ) -> bool:
        """
        Remove a forbidden created object from this quarantine source.

        Returns ``True`` when at least one source row was deleted. Returns
        ``False`` when this source context has no matching ordinary mapping or
        no matching row.

        Function-backed mappings require their own source-model-specific
        persistence path and are not handled here.
        """

        identity = self._feature_identity(
            feature,
        )

        if identity.class_id != canonical_class_id:
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "The review feature class does not match its "
                    "persisted canonical identity. Feature class: "
                    f"{canonical_class_id!r}; identity class: "
                    f"{identity.class_id!r}."
                ),
            )

        identity_targets = self._source_identity_targets(
            canonical_class_id=canonical_class_id,
            canonical_identity_attribute_ids=tuple(
                sorted(
                    identity.attributes,
                )
            ),
        )

        if not identity_targets:
            return False

        deleted_count = 0

        for (
            source_class_id,
            source_identity_attribute_id,
        ) in identity_targets:
            class_mapping = self.model_mapping.try_class_definition(
                source_class_id,
            )

            if class_mapping is None:
                continue

            identity_mapping = class_mapping.identities.get(
                canonical_class_id,
            )

            if identity_mapping is None:
                continue

            source_identity_value = self._canonical_identity_value(
                identity=identity,
                canonical_identity_attribute_id=(identity_mapping.canonical_attribute),
            )

            if source_identity_value is None:
                continue

            source_row = self._try_source_row(
                source_class_id=source_class_id,
                source_identity_attribute_id=(source_identity_attribute_id),
                source_identity_value=(source_identity_value),
            )

            if source_row is None:
                continue

            self.quarantine_session.delete(
                source_row,
            )

            self._discard_cached_source_row(
                source_class_id=source_class_id,
                source_identity_attribute_id=(source_identity_attribute_id),
                source_identity_value=(source_identity_value),
            )

            deleted_count += 1

        if deleted_count:
            logger.debug(
                "Removed %s source rows for forbidden created "
                "canonical object %r with identity %r from "
                "source role %r in diff job %r.",
                deleted_count,
                canonical_class_id,
                dict(
                    identity.attributes,
                ),
                self.source_role,
                job_id,
            )

        return deleted_count > 0

    def _source_identity_targets(
        self,
        *,
        canonical_class_id: str,
        canonical_identity_attribute_ids: tuple[
            str,
            ...,
        ],
    ) -> tuple[
        tuple[
            str,
            str,
        ],
        ...,
    ]:
        """
        Return source class and source identity attribute pairs.

        This MVP supports canonical identities containing one attribute.
        """

        if (
            len(
                canonical_identity_attribute_ids,
            )
            != 1
        ):
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "Quarantine persistence currently supports "
                    "only single-attribute canonical identities. "
                    f"Canonical class {canonical_class_id!r} has "
                    "identity attributes "
                    f"{canonical_identity_attribute_ids!r}."
                ),
            )

        canonical_identity_attribute_id = canonical_identity_attribute_ids[0]

        cache_key = (
            canonical_class_id,
            canonical_identity_attribute_id,
        )

        cached = self._source_identity_targets_cache.get(
            cache_key,
        )

        if cached is not None:
            return cached

        targets: list[
            tuple[
                str,
                str,
            ],
        ] = []

        for source_class_id in self._source_class_ids():
            class_mapping = self.model_mapping.try_class_definition(
                source_class_id,
            )

            if class_mapping is None:
                continue

            if class_mapping.function is not None:
                continue

            identity_mapping = class_mapping.identities.get(
                canonical_class_id,
            )

            if identity_mapping is None:
                continue

            if identity_mapping.canonical_attribute != canonical_identity_attribute_id:
                continue

            targets.append(
                (
                    source_class_id,
                    identity_mapping.source_attribute,
                )
            )

        result = tuple(
            targets,
        )

        self._source_identity_targets_cache[cache_key] = result

        return result

    def _feature_identity(
        self,
        feature: ReviewFeature,
    ) -> CanonicalObjectIdentity:
        """
        Return the complete canonical identity stored with a review feature.
        """

        payload = feature.attributes.get(
            "identity",
        )

        if not isinstance(
            payload,
            Mapping,
        ):
            raise DiffSchemaContractError(
                column_name="identity",
                message=("The review feature identity must contain " "a JSON object."),
            )

        class_id = payload.get(
            "class_id",
        )

        attributes = payload.get(
            "attributes",
        )

        if (
            not isinstance(
                class_id,
                str,
            )
            or not class_id.strip()
        ):
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "The review feature identity must contain a "
                    "non-empty canonical class identifier."
                ),
            )

        if (
            not isinstance(
                attributes,
                Mapping,
            )
            or not attributes
        ):
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "The review feature identity must contain "
                    "one or more canonical identity attributes."
                ),
            )

        return CanonicalObjectIdentity(
            class_id=class_id.strip(),
            attributes=dict(
                attributes,
            ),
        )

    def _canonical_identity_value(
        self,
        *,
        identity: CanonicalObjectIdentity,
        canonical_identity_attribute_id: str,
    ) -> Any | None:
        """
        Return one canonical identity value when the attribute is present.
        """

        if canonical_identity_attribute_id not in identity.attributes:
            return None

        value = identity.attributes[canonical_identity_attribute_id]

        if value is None:
            raise DiffSchemaContractError(
                column_name="identity",
                message=(
                    "Canonical identity attribute "
                    f"{identity.class_id!r}."
                    f"{canonical_identity_attribute_id!r} "
                    "contains NULL."
                ),
            )

        return value

    def _source_class_ids(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return cached source class identifiers exposed by the quarantine ORM.
        """

        if self._source_class_ids_cache is not None:
            return self._source_class_ids_cache

        classes = self.quarantine_classes

        if isinstance(
            classes,
            Mapping,
        ):
            result = tuple(
                str(
                    class_id,
                )
                for class_id in classes
            )

            self._source_class_ids_cache = result

            return result

        class_ids: list[str,] = []

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

        result = tuple(
            class_ids,
        )

        self._source_class_ids_cache = result

        return result

    def _source_class(
        self,
        source_class_id: str,
    ) -> Any:
        """
        Return one cached quarantine ORM class.
        """

        cached = self._source_class_cache.get(
            source_class_id,
        )

        if cached is not None:
            return cached

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

        self._source_class_cache[source_class_id] = source_class

        return source_class

    def _try_source_row(
        self,
        *,
        source_class_id: str,
        source_identity_attribute_id: str,
        source_identity_value: Any,
    ) -> Any | None:
        """
        Return one quarantine row located through its mapped source identity.

        Successful and missing lookups are cached for this preparation run.
        """

        cache_key = (
            source_class_id,
            source_identity_attribute_id,
            source_identity_value,
        )

        if cache_key in self._source_row_cache:
            return self._source_row_cache[cache_key]

        source_class = self._source_class(
            source_class_id,
        )

        identity_attribute = getattr(
            source_class,
            source_identity_attribute_id,
            None,
        )

        if identity_attribute is None:
            raise DiffSchemaContractError(
                message=(
                    "Quarantine class "
                    f"{source_class.__name__!r} does not expose "
                    "mapped source identity attribute "
                    f"{source_identity_attribute_id!r}."
                ),
            )

        rows = (
            self.quarantine_session.query(
                source_class,
            )
            .filter(identity_attribute == source_identity_value)
            .limit(
                2,
            )
            .all()
        )

        if not rows:
            self._source_row_cache[cache_key] = None

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
                    f"{source_class.__name__!r} with source "
                    f"identity "
                    f"{source_identity_attribute_id!r}="
                    f"{source_identity_value!r}."
                ),
            )

        source_row = rows[0]

        self._source_row_cache[cache_key] = source_row

        return source_row

    def _discard_cached_source_row(
        self,
        *,
        source_class_id: str,
        source_identity_attribute_id: str,
        source_identity_value: Any,
    ) -> None:
        """
        Remove one deleted ORM object from the source-row cache.
        """

        self._source_row_cache.pop(
            (
                source_class_id,
                source_identity_attribute_id,
                source_identity_value,
            ),
            None,
        )
