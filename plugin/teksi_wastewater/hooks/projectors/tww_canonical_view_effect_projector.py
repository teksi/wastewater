from __future__ import annotations

from collections.abc import (
    Mapping,
    MutableSequence,
    Sequence,
)
from dataclasses import dataclass, field
from typing import Any

from sqlalchemy.orm import Session

from teksi_hooks.capabilities.effects import (
    CanonicalViewEffectProjector,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EffectSource,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    CanonicalViewProjectionMapping,
    ProjectionReferenceMapping,
    ValueListMapping,
)

from ..capabilities.tww_canonical_projection_capability import (
    ProjectionValueCandidate,
    SourceReferenceLookupCapability,
    TwwCanonicalProjectionLookupCapability,
)


@dataclass(
    slots=True,
    frozen=True,
)
class ResolvedProjectionReference:
    """
    Hold source rows resolved for one projection reference.

    The rows are indexed by their internal ili2pg ``t_id``. The associated
    mapping retains the configured external identity attribute and optional
    source-row discriminator.
    """

    mapping: ProjectionReferenceMapping

    rows_by_t_id: Mapping[
        int,
        Any,
    ]


@dataclass(
    slots=True,
    frozen=True,
)
class TwwProjectionContext:
    """
    Hold batch-resolved data for one source-class projection.

    All database access required for one complete source class is performed
    while constructing this context. Individual source-row projection must
    use these in-memory lookups and must not execute additional queries.
    """

    projection: CanonicalViewProjectionMapping

    canonical_rows_by_identity: Mapping[
        str,
        Any,
    ]

    references_by_source_attribute: Mapping[
        str,
        ResolvedProjectionReference,
    ] = field(
        default_factory=dict,
    )

    canonical_oids_by_mapping: Mapping[
        str,
        Mapping[
            str,
            str,
        ],
    ] = field(
        default_factory=dict,
    )

    value_candidates_by_source_attribute: Mapping[
        str,
        Mapping[
            Any,
            tuple[
                ProjectionValueCandidate,
                ...,
            ],
        ],
    ] = field(
        default_factory=dict,
    )

    def canonical_row(
        self,
        object_id: str,
    ) -> Any | None:
        """
        Return the canonical comparison row for one source object.
        """

        return self.canonical_rows_by_identity.get(
            object_id,
        )

    def reference(
        self,
        source_attribute: str,
    ) -> ResolvedProjectionReference:
        """
        Return the resolved source-reference lookup for one attribute.
        """

        try:
            return self.references_by_source_attribute[
                source_attribute
            ]

        except KeyError as exception:
            raise KeyError(
                "Projection context does not contain source "
                f"reference {source_attribute!r}."
            ) from exception

    def canonical_oids(
        self,
        mapping_name: str,
    ) -> Mapping[
        str,
        str,
    ]:
        """
        Return canonical OIDs indexed by source-facing OID.
        """

        try:
            return self.canonical_oids_by_mapping[
                mapping_name
            ]

        except KeyError as exception:
            raise KeyError(
                "Projection context does not contain canonical "
                f"OID mapping {mapping_name!r}."
            ) from exception

    def value_candidates(
        self,
        source_attribute: str,
        source_value: Any,
    ) -> tuple[
        ProjectionValueCandidate,
        ...,
    ]:
        """
        Return value-mapping candidates for one source attribute and value.

        Ignored values produce an empty candidate tuple.
        """

        value_mapping = self.projection.value_lists.get(
            source_attribute,
        )

        if value_mapping is None:
            raise KeyError(
                "Projection does not define a value-list "
                f"mapping for {source_attribute!r}."
            )

        if value_mapping.ignores(
            source_value,
        ):
            return ()

        return (
            self.value_candidates_by_source_attribute
            .get(
                source_attribute,
                {},
            )
            .get(
                source_value,
                (),
            )
        )


@dataclass(
    slots=True,
)
class TwwCanonicalViewEffectProjector(
    CanonicalViewEffectProjector,
):
    """
    Project TWW source classes against canonical comparison views.

    Canonical model discovery and querying are delegated to
    ``canonical_lookup``. Quarantine source-reference discovery and querying
    are delegated to ``source_lookup``.

    This projector owns semantic dispatch, comparison, disambiguation, and
    effect construction. It does not own sessions, transaction boundaries,
    ORM classes, or canonical persistence.
    """

    canonical_lookup: (
        TwwCanonicalProjectionLookupCapability
    )

    source_lookup: SourceReferenceLookupCapability

    def project_effects(
        self,
        *,
        source_model: str,
        source_class_id: str,
        source_rows: Sequence[
            Any,
        ],
        quarantine_session: Session,
        live_session: Session,
        projection: CanonicalViewProjectionMapping,
    ) -> tuple[
        EffectDocument,
        ...,
    ]:
        """
        Project one complete source class against current canonical state.

        All shared database lookups are performed in batches before
        individual source rows are projected. Returned documents preserve
        source-row order.
        """

        source_rows = tuple(
            source_rows,
        )

        if not source_rows:
            return ()

        self._assert_unique_source_identities(
            source_class_id=source_class_id,
            source_rows=source_rows,
        )

        context = self._projection_context(
            source_rows=source_rows,
            quarantine_session=quarantine_session,
            live_session=live_session,
            projection=projection,
        )

        documents = tuple(
            self._project_source_row(
                source_model=source_model,
                source_class_id=source_class_id,
                source_row=source_row,
                current_row=context.canonical_row(
                    self._source_object_id(
                        source_row,
                    )
                ),
                context=context,
            )
            for source_row in source_rows
        )

        self._assert_complete_projection(
            source_class_id=source_class_id,
            source_rows=source_rows,
            documents=documents,
        )

        return documents

    def _projection_context(
        self,
        *,
        source_rows: Sequence[
            Any,
        ],
        quarantine_session: Session,
        live_session: Session,
        projection: CanonicalViewProjectionMapping,
    ) -> TwwProjectionContext:
        """
        Resolve all shared input data needed by one class projection.
        """

        source_object_ids = tuple(
            dict.fromkeys(
                self._source_object_id(
                    source_row,
                )
                for source_row in source_rows
            )
        )

        canonical_rows_by_identity = (
            self.canonical_lookup.rows_by_identity(
                session=live_session,
                view=projection.canonical_view,
                identities=source_object_ids,
            )
        )

        unexpected_identities = (
            set(
                canonical_rows_by_identity,
            )
            - set(
                source_object_ids,
            )
        )

        if unexpected_identities:
            raise ValueError(
                "Canonical-view lookup returned identities that "
                "were not requested from "
                f"{projection.canonical_view.schema!r}."
                f"{projection.canonical_view.name!r}: "
                f"{tuple(sorted(unexpected_identities))!r}."
            )

        references_by_source_attribute = (
            self._resolved_projection_references(
                source_rows=source_rows,
                quarantine_session=(
                    quarantine_session
                ),
                references=projection.references,
            )
        )

        organisation_oids = (
            self._referenced_external_identities(
                references=(
                    references_by_source_attribute
                ),
                source_class_id="Organisation",
            )
        )

        canonical_oids_by_mapping: dict[
            str,
            Mapping[
                str,
                str,
            ],
        ] = {}

        if organisation_oids:
            canonical_oids_by_mapping[
                "organisation"
            ] = (
                self.canonical_lookup
                .organisation_oids_by_agxx_oid(
                    session=live_session,
                    agxx_oids=organisation_oids,
                )
            )

        value_candidates_by_source_attribute = (
            self._projection_value_candidates(
                source_rows=source_rows,
                live_session=live_session,
                value_lists=projection.value_lists,
            )
        )

        return TwwProjectionContext(
            projection=projection,
            canonical_rows_by_identity=(
                canonical_rows_by_identity
            ),
            references_by_source_attribute=(
                references_by_source_attribute
            ),
            canonical_oids_by_mapping=(
                canonical_oids_by_mapping
            ),
            value_candidates_by_source_attribute=(
                value_candidates_by_source_attribute
            ),
        )

    def _resolved_projection_references(
        self,
        *,
        source_rows: Sequence[
            Any,
        ],
        quarantine_session: Session,
        references: Mapping[
            str,
            ProjectionReferenceMapping,
        ],
    ) -> dict[
        str,
        ResolvedProjectionReference,
    ]:
        """
        Resolve all configured source-side references in batches.

        References with different source attributes but identical source class,
        identity attribute, and discriminator are resolved together.
        """

        t_ids_by_mapping: dict[
            ProjectionReferenceMapping,
            set[
                int,
            ],
        ] = {}

        attributes_by_mapping: dict[
            ProjectionReferenceMapping,
            list[
                str,
            ],
        ] = {}

        for (
            source_attribute,
            reference_mapping,
        ) in references.items():
            referenced_t_ids = t_ids_by_mapping.setdefault(
                reference_mapping,
                set(),
            )

            attributes_by_mapping.setdefault(
                reference_mapping,
                [],
            ).append(
                source_attribute,
            )

            for source_row in source_rows:
                if not hasattr(
                    source_row,
                    source_attribute,
                ):
                    # Projection defaults may contain references that are not
                    # present on every projected source class.
                    continue

                source_reference = getattr(
                    source_row,
                    source_attribute,
                )

                if source_reference is None:
                    return None

                if isinstance(
                    source_reference,
                    int,
                ):
                    referenced_t_ids.add(
                        source_reference,
                    )

        resolved_rows_by_mapping: dict[
            ProjectionReferenceMapping,
            Mapping[
                int,
                Any,
            ],
        ] = {}

        for (
            reference_mapping,
            referenced_t_ids,
        ) in t_ids_by_mapping.items():
            if not referenced_t_ids:
                resolved_rows_by_mapping[
                    reference_mapping
                ] = {}

                continue

            resolved_rows_by_mapping[
                reference_mapping
            ] = self.source_lookup.rows_by_t_id(
                session=quarantine_session,
                source_class_id=(
                    reference_mapping
                    .source_class_id
                ),
                t_ids=tuple(
                    sorted(
                        referenced_t_ids,
                    )
                ),
                discriminator=(
                    reference_mapping
                    .discriminator
                ),
            )

        result: dict[
            str,
            ResolvedProjectionReference,
        ] = {}

        for (
            reference_mapping,
            source_attributes,
        ) in attributes_by_mapping.items():
            resolved_reference = (
                ResolvedProjectionReference(
                    mapping=reference_mapping,
                    rows_by_t_id=(
                        resolved_rows_by_mapping.get(
                            reference_mapping,
                            {},
                        )
                    ),
                )
            )

            for source_attribute in source_attributes:
                result[
                    source_attribute
                ] = resolved_reference

        return result

    def _referenced_external_identities(
        self,
        *,
        references: Mapping[
            str,
            ResolvedProjectionReference,
        ],
        source_class_id: str,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return distinct external identities for one referenced source class.
        """

        identities: dict[
            str,
            None,
        ] = {}

        processed_references: set[
            int,
        ] = set()

        for resolved_reference in references.values():
            reference_marker = id(
                resolved_reference,
            )

            if reference_marker in processed_references:
                continue

            processed_references.add(
                reference_marker,
            )

            mapping = resolved_reference.mapping

            if (
                mapping.source_class_id
                != source_class_id
            ):
                continue

            for row in resolved_reference.rows_by_t_id.values():
                identity = getattr(
                    row,
                    mapping.identity_attribute,
                    None,
                )

                if (
                    isinstance(
                        identity,
                        str,
                    )
                    and identity.strip()
                ):
                    identities[
                        identity.strip()
                    ] = None

        return tuple(
            identities,
        )

    def _projection_value_candidates(
        self,
        *,
        source_rows: Sequence[
            Any,
        ],
        live_session: Session,
        value_lists: Mapping[
            str,
            ValueListMapping,
        ],
    ) -> dict[
        str,
        Mapping[
            Any,
            tuple[
                ProjectionValueCandidate,
                ...,
            ],
        ],
    ]:
        """
        Resolve configured projection value-list lookups in batches.
        """

        result: dict[
            str,
            Mapping[
                Any,
                tuple[
                    ProjectionValueCandidate,
                    ...,
                ],
            ],
        ] = {}

        for (
            source_attribute,
            value_mapping,
        ) in value_lists.items():
            source_values = self._source_values(
                source_rows=source_rows,
                source_attribute=source_attribute,
                mapping=value_mapping,
            )

            if not source_values:
                result[
                    source_attribute
                ] = {}

                continue

            result[
                source_attribute
            ] = (
                self.canonical_lookup
                .value_candidates_by_source_value(
                    session=live_session,
                    mapping=value_mapping,
                    source_values=source_values,
                )
            )

        return result

    def _source_values(
        self,
        *,
        source_rows: Sequence[
            Any,
        ],
        source_attribute: str,
        mapping: ValueListMapping,
    ) -> tuple[
        Any,
        ...,
    ]:
        """
        Return distinct, non-null, non-ignored source values.
        """

        values: dict[
            Any,
            None,
        ] = {}

        attribute_found = False

        for source_row in source_rows:
            if not hasattr(
                source_row,
                source_attribute,
            ):
                continue

            attribute_found = True

            source_value = getattr(
                source_row,
                source_attribute,
            )

            if (
                source_value is None
                or mapping.ignores(
                    source_value,
                )
            ):
                continue

            try:
                values[
                    source_value
                ] = None

            except TypeError as exception:
                raise TypeError(
                    "Projection value-list source value must be "
                    "hashable. Attribute "
                    f"{source_attribute!r} produced "
                    f"{source_value!r}."
                ) from exception

        if not attribute_found:
            # Defaults may contain values not present on every projected class.
            return ()

        return tuple(
            values,
        )

    def _project_source_row(
        self,
        *,
        source_model: str,
        source_class_id: str,
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> EffectDocument:
        """
        Project one source row using class-specific semantic rules.
        """

        if source_class_id == "GepKnoten":
            effects = self._project_gepknoten(
                source_row=source_row,
                current_row=current_row,
                context=context,
            )

        elif source_class_id == "GepHaltung":
            effects = self._project_gephaltung(
                source_row=source_row,
                current_row=current_row,
                context=context,
            )

        elif (
            source_class_id
            == "Ueberlauf_Foerderaggregat"
        ):
            effects = (
                self
                ._project_ueberlauf_foerderaggregat(
                    source_row=source_row,
                    current_row=current_row,
                    context=context,
                )
            )

        else:
            raise ValueError(
                "No TWW canonical-view effect projection "
                "exists for source class "
                f"{source_class_id!r}."
            )

        return EffectDocument(
            source=EffectSource(
                model=source_model,
                class_id=source_class_id,
                object_id=self._source_object_id(
                    source_row,
                ),
            ),
            effects=tuple(
                effects,
            ),
        )

    def _project_gepknoten(
        self,
        *,
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> tuple[
        Effect,
        ...,
    ]:
        """
        Project one AGXX GepKnoten row.

        Target-class and target-attribute disambiguation belongs here. All
        required reference and value mappings are already available in
        ``context``.
        """

        del source_row
        del current_row
        del context

        return ()

    def _project_gephaltung(
        self,
        *,
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> tuple[
        Effect,
        ...,
    ]:
        """
        Project one AGXX GepHaltung row.
        """

        del source_row
        del current_row
        del context

        return ()

    def _project_ueberlauf_foerderaggregat(
        self,
        *,
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> tuple[
        Effect,
        ...,
    ]:
        """
        Project one AGXX overflow or pump row.
        """

        del source_row
        del current_row
        del context

        return ()

    def _resolved_reference(
        self,
        *,
        source_row: Any,
        source_attribute: str,
        context: TwwProjectionContext,
        required: bool = False,
    ) -> str | None:
        """
        Resolve one source-side reference to its configured external identity.

        String source values are treated as already externalized identities.
        Integer source values are interpreted as ili2pg ``t_id`` references.
        """

        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"reference {source_attribute!r}."
            )

        source_reference = getattr(
            source_row,
            source_attribute,
        )

        if source_reference is None:
            if required:
                raise ValueError(
                    "Required source reference "
                    f"{source_attribute!r} is null for "
                    "source object "
                    f"{self._source_object_id(source_row)!r}."
                )

            return None

        if isinstance(
            source_reference,
            str,
        ):
            normalized = source_reference.strip()

            if normalized:
                return normalized

            if required:
                raise ValueError(
                    "Required source reference "
                    f"{source_attribute!r} is empty for "
                    "source object "
                    f"{self._source_object_id(source_row)!r}."
                )

            return None

        if not isinstance(
            source_reference,
            int,
        ):
            raise TypeError(
                "Source reference "
                f"{source_attribute!r} must be an ili2pg "
                "`t_id`, an external string identity, or null; "
                f"received {type(source_reference)!r}."
            )

        resolved_reference = context.reference(
            source_attribute,
        )

        referenced_row = (
            resolved_reference
            .rows_by_t_id
            .get(
                source_reference,
            )
        )

        if referenced_row is None:
            raise ValueError(
                "Could not resolve source reference "
                f"{source_attribute!r}=t_id "
                f"{source_reference!r} for source object "
                f"{self._source_object_id(source_row)!r}."
            )

        identity_attribute = (
            resolved_reference
            .mapping
            .identity_attribute
        )

        referenced_identity = getattr(
            referenced_row,
            identity_attribute,
            None,
        )

        if (
            not isinstance(
                referenced_identity,
                str,
            )
            or not referenced_identity.strip()
        ):
            raise ValueError(
                "Referenced source row with t_id "
                f"{source_reference!r} does not expose a valid "
                f"{identity_attribute!r} identity."
            )

        return referenced_identity.strip()

    def _canonical_oid(
        self,
        *,
        source_oid: str | None,
        mapping_name: str,
        context: TwwProjectionContext,
        source_row: Any,
        reference_name: str,
        required: bool = False,
    ) -> str | None:
        """
        Convert one source-facing OID to its canonical TWW OID.
        """

        if source_oid is None:
            if required:
                raise ValueError(
                    f"Required {reference_name} is absent "
                    "for source object "
                    f"{self._source_object_id(source_row)!r}."
                )

            return None

        canonical_oid = context.canonical_oids(
            mapping_name,
        ).get(
            source_oid,
        )

        if canonical_oid is None:
            raise ValueError(
                f"Could not map {reference_name} source OID "
                f"{source_oid!r} through canonical mapping "
                f"{mapping_name!r} for source object "
                f"{self._source_object_id(source_row)!r}."
            )

        return canonical_oid

    def _single_value_candidate(
        self,
        *,
        source_row: Any,
        source_attribute: str,
        context: TwwProjectionContext,
    ) -> ProjectionValueCandidate | None:
        """
        Return the single ordinary value-list candidate for one source value.

        Ignored and null values return ``None``. Multiple candidates require
        class-specific semantic disambiguation and therefore raise an error.
        """

        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"value-list attribute "
                f"{source_attribute!r}."
            )

        source_value = getattr(
            source_row,
            source_attribute,
        )

        value_mapping = (
            context.projection.value_lists.get(
                source_attribute,
            )
        )

        if value_mapping is None:
            raise KeyError(
                "Projection does not define a value-list "
                f"mapping for {source_attribute!r}."
            )

        if (
            source_value is None
            or value_mapping.ignores(
                source_value,
            )
        ):
            return None

        candidates = context.value_candidates(
            source_attribute,
            source_value,
        )

        if not candidates:
            self._raise_missing_value_mapping(
                source_row=source_row,
                source_attribute=source_attribute,
                source_value=source_value,
                mapping=value_mapping,
            )

        if len(
            candidates,
        ) != 1:
            raise ValueError(
                "Projection value mapping for source attribute "
                f"{source_attribute!r} with value "
                f"{source_value!r} returned "
                f"{len(candidates)} candidates. Class-specific "
                "target disambiguation is required."
            )

        return candidates[
            0
        ]

    def _append_source_update_if_changed(
        self,
        *,
        effects: MutableSequence[
            Effect,
        ],
        source_row: Any,
        current_row: Any | None,
        source_attribute: str,
        identity: CanonicalObjectIdentity,
        target_attribute: str,
        current_attribute: str | None = None,
    ) -> None:
        """
        Append one permitted non-null source update when values differ.

        Null source values are neutralized incremental values and produce no
        effect.
        """

        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"attribute {source_attribute!r}."
            )

        desired_value = getattr(
            source_row,
            source_attribute,
        )

        if desired_value is None:
            return

        comparison_attribute = (
            current_attribute
            or source_attribute
        )

        current_value = self._row_value(
            current_row,
            comparison_attribute,
        )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute=target_attribute,
            desired_value=desired_value,
            current_value=current_value,
        )

    def _append_mapped_update_if_changed(
        self,
        *,
        effects: MutableSequence[
            Effect,
        ],
        source_row: Any,
        current_row: Any | None,
        source_attribute: str,
        identity: CanonicalObjectIdentity,
        target_attribute: str,
        context: TwwProjectionContext,
        current_attribute: str | None = None,
    ) -> None:
        """
        Append an ordinary value-list update when presentation values differ.

        Relations returning multiple candidates must be handled by
        class-specific semantic logic instead.
        """

        value_mapping = (
            context.projection.value_lists[
                source_attribute
            ]
        )
        source_value = getattr(
            source_row,
            source_attribute,
        )

        if source_value is None or value_mapping.ignores(
            source_value,
        ):
            return

        comparison_attribute = (
            current_attribute
            or source_attribute
        )

        current_value = self._row_value(
            current_row,
            comparison_attribute,
        )

        if self._values_equal(
            current_value=current_value,
            desired_value=source_value,
        ):
            return

        if source_value is None:
            desired_value = None

        else:
            candidate = self._single_value_candidate(
                source_row=source_row,
                source_attribute=source_attribute,
                context=context,
            )

            if candidate is None:
                desired_value = None

            else:
                desired_value = candidate.value

                if (
                    candidate.target_class_id
                    is not None
                    or candidate.target_attribute_id
                    is not None
                ):
                    raise ValueError(
                        "Projection value mapping for "
                        f"{source_attribute!r} returned target "
                        "metadata. Use class-specific semantic "
                        "disambiguation instead of the ordinary "
                        "mapped-update helper."
                    )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute=target_attribute,
            desired_value=desired_value,
            current_value=current_value,
        )

    def _append_update_if_changed(
        self,
        *,
        effects: MutableSequence[
            Effect,
        ],
        identity: CanonicalObjectIdentity,
        target_attribute: str,
        desired_value: Any,
        current_value: Any,
    ) -> None:
        """
        Append one canonical attribute update when values differ.
        """

        if self._values_equal(
            current_value=current_value,
            desired_value=desired_value,
        ):
            return

        effects.append(
            UpdateAttributeEffect(
                identity=identity,
                attribute_id=target_attribute,
                value=desired_value,
            )
        )

    def _raise_missing_value_mapping(
        self,
        *,
        source_row: Any,
        source_attribute: str,
        source_value: Any,
        mapping: ValueListMapping,
        exception: Exception | None = None,
    ) -> None:
        """
        Raise an error when a source value has no projection candidates.
        """

        message = (
            "No canonical projection value mapping exists in "
            f"{mapping.relation!r} for source attribute "
            f"{source_attribute!r} with value "
            f"{source_value!r} on source object "
            f"{self._source_object_id(source_row)!r}."
        )

        if exception is None:
            raise ValueError(
                message,
            )

        raise ValueError(
            message,
        ) from exception

    def _row_value(
        self,
        row: Any | None,
        attribute: str,
    ) -> Any:
        """
        Return one value from an ORM row or mapping-compatible row.
        """

        if row is None:
            return None

        if isinstance(
            row,
            Mapping,
        ):
            if attribute not in row:
                raise ValueError(
                    "Canonical comparison row does not expose "
                    f"attribute {attribute!r}. Available "
                    "attributes: "
                    f"{tuple(sorted(row))!r}."
                )

            return row[
                attribute
            ]

        if not hasattr(
            row,
            attribute,
        ):
            raise ValueError(
                "Canonical comparison row does not expose "
                f"attribute {attribute!r}."
            )

        return getattr(
            row,
            attribute,
        )

    def _source_object_id(
        self,
        source_row: Any,
    ) -> str:
        """
        Return the stable external identity of one source row.
        """

        value = getattr(
            source_row,
            "t_ili_tid",
            None,
        )

        if value is None:
            value = getattr(
                source_row,
                "obj_id",
                None,
            )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(
                "Projection source row does not expose a valid "
                "`t_ili_tid` or `obj_id`."
            )

        return value.strip()

    def _values_equal(
        self,
        *,
        current_value: Any,
        desired_value: Any,
    ) -> bool:
        """
        Compare current and desired values across compatible wrappers.
        """

        if current_value == desired_value:
            return True

        if (
            current_value is None
            or desired_value is None
        ):
            return False

        return str(
            current_value,
        ) == str(
            desired_value,
        )

    def _assert_unique_source_identities(
        self,
        *,
        source_class_id: str,
        source_rows: Sequence[
            Any,
        ],
    ) -> None:
        """
        Require unique source object identities within one projected class.
        """

        seen: set[
            str,
        ] = set()

        for source_row in source_rows:
            object_id = self._source_object_id(
                source_row,
            )

            if object_id in seen:
                raise ValueError(
                    "Projection source class "
                    f"{source_class_id!r} contains duplicate "
                    f"object identity {object_id!r}."
                )

            seen.add(
                object_id,
            )

    def _assert_complete_projection(
        self,
        *,
        source_class_id: str,
        source_rows: Sequence[
            Any,
        ],
        documents: Sequence[
            EffectDocument,
        ],
    ) -> None:
        """
        Require exactly one source-aligned document per source row.
        """

        if len(
            documents,
        ) != len(
            source_rows,
        ):
            raise ValueError(
                "Canonical-view projection returned "
                f"{len(documents)} effect documents for "
                f"{len(source_rows)} source rows in class "
                f"{source_class_id!r}."
            )

        for (
            source_row,
            document,
        ) in zip(
            source_rows,
            documents,
            strict=True,
        ):
            expected_object_id = (
                self._source_object_id(
                    source_row,
                )
            )

            if (
                document.source.class_id
                != source_class_id
            ):
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"class {document.source.class_id!r}; "
                    f"expected {source_class_id!r}."
                )

            if (
                document.source.object_id
                != expected_object_id
            ):
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"object {document.source.object_id!r}; "
                    f"expected {expected_object_id!r}."
                )