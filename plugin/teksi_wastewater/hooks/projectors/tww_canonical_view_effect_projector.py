from __future__ import annotations

from collections.abc import (
    Mapping,
    MutableSequence,
    Sequence,
)
from dataclasses import dataclass, field
from typing import Any

from geoalchemy2.functions import (
    ST_Force3D,
)
from teksi_hooks.capabilities.effects import (
    CanonicalViewEffectProjector,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EffectProjectionResult,
    EffectSource,
    EnforceExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    CanonicalViewProjectionMapping,
    ProjectionReferenceMapping,
    RelationContext,
    ValueListMapping,
)

from ..adapters.tww_session_manager import (
    TwwSessionContext,
)
from ..capabilities.tww_canonical_projection_capability import (
    ProjectionValueCandidate,
    SourceReferenceLookupCapability,
    TwwCanonicalProjectionLookupCapability,
)

_AGXX_GEPHALTUNG_EXTENSION_VALUES: Mapping[
    str,
    frozenset[str,],
] = {
    "nutzungsartag_ist": frozenset(
        {
            "Platzwasser",
            "Strassenwasser",
        }
    ),
    "nutzungsartag_geplant": frozenset(
        {
            "Platzwasser",
            "Strassenwasser",
        }
    ),
    "funktionhierarchisch": frozenset(
        {
            "PAA.Arealentwaesserung",
        }
    ),
}


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
            return self.references_by_source_attribute[source_attribute]

        except KeyError as exception:
            raise KeyError(
                "Projection context does not contain source " f"reference {source_attribute!r}."
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
            return self.canonical_oids_by_mapping[mapping_name]

        except KeyError as exception:
            raise KeyError(
                "Projection context does not contain canonical " f"OID mapping {mapping_name!r}."
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
                "Projection does not define a value-list " f"mapping for {source_attribute!r}."
            )

        if value_mapping.ignores(
            source_value,
        ):
            return ()

        return self.value_candidates_by_source_attribute.get(
            source_attribute,
            {},
        ).get(
            source_value,
            (),
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

    canonical_lookup: TwwCanonicalProjectionLookupCapability

    source_lookup: SourceReferenceLookupCapability

    session_context: TwwSessionContext

    def project_effects(
        self,
        *,
        source_model: str,
        source_class_id: str,
        source_rows: Sequence[Any,],
        relation_context: RelationContext,
        projection: CanonicalViewProjectionMapping,
    ) -> EffectProjectionResult:
        """
        Project one complete source class against current canonical state.

        All shared database lookups are performed in batches before
        individual source rows are projected. Returned documents preserve
        source-row order.
        """

        del relation_context

        source_rows = tuple(
            source_rows,
        )

        if not source_rows:
            return EffectProjectionResult(
                documents=(),
                source_objects=(),
            )

        self._assert_unique_source_identities(
            source_class_id=source_class_id,
            source_rows=source_rows,
        )

        context = self._projection_context(
            source_rows=source_rows,
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

        return EffectProjectionResult(
            documents=documents,
            source_objects=source_rows,
        )

    def _projection_context(
        self,
        *,
        source_rows: Sequence[Any,],
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

        canonical_rows_by_identity = self.canonical_lookup.canonical_view_rows_by_identity(
            session=self.session_context.live,
            view=projection.canonical_view,
            identities=source_object_ids,
        )

        if canonical_rows_by_identity is None:
            raise TypeError(
                "Canonical projection lookup "
                f"{type(self.canonical_lookup).__name__}.rows_by_identity() "
                "returned None. The lookup contract requires a mapping, "
                "using an empty mapping when no rows match."
            )

        unexpected_identities = set(
            canonical_rows_by_identity,
        ) - set(
            source_object_ids,
        )

        if unexpected_identities:
            raise ValueError(
                "Canonical-view lookup returned identities that "
                "were not requested from "
                f"{projection.canonical_view.schema!r}."
                f"{projection.canonical_view.name!r}: "
                f"{tuple(sorted(unexpected_identities))!r}."
            )

        references_by_source_attribute = self._resolved_projection_references(
            source_rows=source_rows,
            references=projection.references,
        )

        organisation_oids = self._referenced_external_identities(
            references=(references_by_source_attribute),
            source_class_id="Organisation",
        )

        canonical_oids_by_mapping: dict[
            str,
            Mapping[
                str,
                str,
            ],
        ] = {}

        if organisation_oids:
            canonical_oids_by_mapping["organisation"] = (
                self.canonical_lookup.organisation_oids_by_agxx_oid(
                    session=self.session_context.live,
                    agxx_oids=organisation_oids,
                )
            )

        value_candidates_by_source_attribute = self._projection_value_candidates(
            source_rows=source_rows,
            value_lists=projection.value_lists,
        )

        return TwwProjectionContext(
            projection=projection,
            canonical_rows_by_identity=(canonical_rows_by_identity),
            references_by_source_attribute=(references_by_source_attribute),
            canonical_oids_by_mapping=(canonical_oids_by_mapping),
            value_candidates_by_source_attribute=(value_candidates_by_source_attribute),
        )

    def _resolved_projection_references(
        self,
        *,
        source_rows: Sequence[Any,],
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
            set[int,],
        ] = {}

        attributes_by_mapping: dict[
            ProjectionReferenceMapping,
            list[str,],
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
                    continue

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
                resolved_rows_by_mapping[reference_mapping] = {}

                continue

            resolved_rows_by_mapping[reference_mapping] = self.source_lookup.rows_by_t_id(
                session=self.session_context.quarantine,
                source_class_id=(reference_mapping.source_class_id),
                t_ids=tuple(
                    sorted(
                        referenced_t_ids,
                    )
                ),
                discriminator=(reference_mapping.discriminator),
            )

        result: dict[
            str,
            ResolvedProjectionReference,
        ] = {}

        for (
            reference_mapping,
            source_attributes,
        ) in attributes_by_mapping.items():
            resolved_reference = ResolvedProjectionReference(
                mapping=reference_mapping,
                rows_by_t_id=(
                    resolved_rows_by_mapping.get(
                        reference_mapping,
                        {},
                    )
                ),
            )

            for source_attribute in source_attributes:
                result[source_attribute] = resolved_reference

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

        processed_references: set[int,] = set()

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

            if mapping.source_class_id != source_class_id:
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
                    identities[identity.strip()] = None

        return tuple(
            identities,
        )

    def _projection_value_candidates(
        self,
        *,
        source_rows: Sequence[Any,],
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

        The canonical lookup returns ordinary and targeted projection candidates
        through the same protocol method.
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
                result[source_attribute] = {}

                continue

            source_value_by_normalized_value: dict[
                str,
                Any,
            ] = {}

            for source_value in source_values:
                normalized_value = str(
                    source_value,
                )

                previous_source_value = source_value_by_normalized_value.get(
                    normalized_value,
                )

                if previous_source_value is not None and previous_source_value != source_value:
                    raise ValueError(
                        "Several source values normalize to "
                        "the same value-list lookup value "
                        f"{normalized_value!r}: "
                        f"{previous_source_value!r} and "
                        f"{source_value!r}."
                    )

                source_value_by_normalized_value[normalized_value] = source_value

            candidates_by_normalized_value = self.canonical_lookup.value_codes_by_value(
                session=self.session_context.live,
                relation=value_mapping.relation,
                values=tuple(source_value_by_normalized_value),
            )

            candidates_by_source_value: dict[
                Any,
                tuple[
                    ProjectionValueCandidate,
                    ...,
                ],
            ] = {}

            for (
                normalized_value,
                candidates,
            ) in candidates_by_normalized_value.items():
                source_value = source_value_by_normalized_value.get(
                    normalized_value,
                )

                if source_value is None:
                    raise ValueError(
                        "Canonical value-list lookup returned "
                        "an unrequested source-facing value "
                        f"{normalized_value!r} for relation "
                        f"{value_mapping.relation!r}."
                    )

                candidates_by_source_value[source_value] = tuple(
                    candidates,
                )

            result[source_attribute] = candidates_by_source_value

        return result

    def _source_values(
        self,
        *,
        source_rows: Sequence[Any,],
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

            if source_value is None or mapping.ignores(
                source_value,
            ):
                continue

            try:
                values[source_value] = None

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

        elif source_class_id == "Ueberlauf_Foerderaggregat":
            effects = self._project_ueberlauf_foerderaggregat(
                source_row=source_row,
                current_row=current_row,
                context=context,
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
        Project AGXX-only GepKnoten content.

        Ordinary DSS attributes are ignored for connected wastewater nodes.
        Missing AGXX extension rows are created only when at least one
        non-neutral update targets the row.
        """
        effects: list[Effect,] = []

        source_object_id = self._source_object_id(
            source_row,
        )

        wastewater_node_extension_identity = CanonicalObjectIdentity(
            class_id="agxx_wastewater_node",
            attributes={
                "fk_wastewater_node": source_object_id,
            },
        )

        wastewater_networkelement_extension_identity = CanonicalObjectIdentity(
            class_id=("agxx_wastewater_networkelement"),
            attributes={
                "fk_wastewater_networkelement": (source_object_id),
            },
        )

        last_modification_identity = CanonicalObjectIdentity(
            class_id="agxx_last_modification",
            attributes={
                "fk_element": source_object_id,
            },
        )

        node_extension_effects_start = len(
            effects,
        )

        self._append_mapped_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="istschnittstelle",
            identity=(wastewater_node_extension_identity),
            target_attribute="ag96_is_gateway",
            context=context,
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=(wastewater_node_extension_identity),
            effects_start_index=(node_extension_effects_start),
        )

        self._append_agxx_gep_metadata_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            extension_identity=(wastewater_networkelement_extension_identity),
            last_modification_identity=(last_modification_identity),
        )

        self._append_agxx_wi_metadata_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            extension_identity=(wastewater_networkelement_extension_identity),
            last_modification_identity=(last_modification_identity),
        )

        self._append_gepknoten_measure_update(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
        )

        self._append_gepknoten_function_update(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
        )

        self._append_unconnected_node_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
        )

        return tuple(
            effects,
        )

    def _append_agxx_wi_metadata_updates(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
        extension_identity: CanonicalObjectIdentity,
        last_modification_identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Project common AGXX/WI metadata and create extension rows as needed.
        """
        extension_effects_start = len(
            effects,
        )

        self._append_agxx_wiprovider_update(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            identity=extension_identity,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="bemerkung_wi",
            identity=extension_identity,
            target_attribute="ag64_remark",
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=extension_identity,
            effects_start_index=(extension_effects_start),
        )

        last_modification_effects_start = len(
            effects,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="letzte_aenderung_wi",
            identity=last_modification_identity,
            target_attribute=("ag64_last_modification"),
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=last_modification_identity,
            effects_start_index=(last_modification_effects_start),
        )

    def _append_agxx_wiprovider_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
        identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Project ``datenbewirtschafter_wi`` to the common AGXX provider extension.
        """
        source_provider_oid = self._resolved_reference(
            source_row=source_row,
            source_attribute=("datenbewirtschafter_wi"),
            context=context,
        )

        canonical_provider_oid = self._canonical_oid(
            source_oid=source_provider_oid,
            mapping_name="organisation",
            context=context,
            source_row=source_row,
            reference_name="AGXX/WI data provider",
        )

        if canonical_provider_oid is None:
            return

        current_provider_oid = self._row_value(
            current_row,
            "datenbewirtschafter_wi",
        )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute="ag64_fk_provider",
            desired_value=canonical_provider_oid,
            current_value=current_provider_oid,
        )

    def _append_unconnected_node_updates(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> None:
        """
        Project values stored in ``agxx_unconnected_node_bwrel``.

        Connected DSS wastewater nodes remain unaffected. If an applicable
        fallback row is missing, it is created only when at least one non-null
        update is emitted.
        """
        if current_row is None:
            return

        is_synthetic = bool(
            self._row_value(
                current_row,
                "_mapping_is_synthetic",
            )
        )

        has_unconnected_fallback = bool(
            self._row_value(
                current_row,
                "_mapping_has_unc_fallback",
            )
        )

        if not is_synthetic and not has_unconnected_fallback:
            return

        identity = CanonicalObjectIdentity(
            class_id="agxx_unconnected_node_bwrel",
            attributes={
                "obj_id": self._source_object_id(
                    source_row,
                ),
            },
        )

        effects_start = len(
            effects,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="deckelkote",
            identity=identity,
            target_attribute="co_level",
        )

        self._append_unconnected_geometry_update(
            effects=effects,
            source_row=source_row,
            source_attribute="detailgeometrie",
            target_attribute="detail_geometry3d_geometry",
            identity=identity,
        )

        self._append_mapped_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="lagegenauigkeit",
            identity=identity,
            target_attribute="co_positional_accuracy",
            context=context,
        )

        bottom_level = getattr(
            source_row,
            "sohlenkote",
            None,
        )

        self._append_unconnected_geometry_update(
            effects=effects,
            source_row=source_row,
            source_attribute="lage",
            target_attribute="situation3d_geometry",
            identity=identity,
            z_value=bottom_level,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="rueckstaukote_ist",
            identity=identity,
            target_attribute="backflow_level_current",
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="sohlenkote",
            identity=identity,
            target_attribute="bottom_level",
        )

        self._append_mapped_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="funktionhierarchisch",
            identity=identity,
            target_attribute="ch_function_hierarchic",
            context=context,
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=identity,
            effects_start_index=effects_start,
        )

    def _append_unconnected_geometry_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        source_attribute: str,
        target_attribute: str,
        identity: CanonicalObjectIdentity,
        z_value: Any | None = None,
    ) -> None:
        """
        Append one three-dimensional unconnected-node geometry update.

        Null source geometries are neutral and therefore produce no effect.

        Geometry conversion is delegated to ``_append_force_3d_update()``, which
        represents the conversion as a PostGIS ``ST_Force3D`` expression. The
        effect persister is responsible for executing that expression when the
        canonical update is applied.
        """
        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"geometry attribute {source_attribute!r}."
            )

        source_geometry = getattr(
            source_row,
            source_attribute,
        )

        if source_geometry is None:
            return

        self._append_force_3d_update(
            effects=effects,
            source_row=source_row,
            source_attribute=source_attribute,
            target_attribute=target_attribute,
            identity=identity,
            z_value=z_value,
        )

    def _append_force_3d_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        source_attribute: str,
        target_attribute: str,
        identity: CanonicalObjectIdentity,
        z_value: Any | None = None,
    ) -> None:
        """
        Append one geometry update using PostGIS ``ST_Force3D``.

        Existing Z coordinates are preserved. Two-dimensional coordinates receive
        the supplied Z value. When no Z value is supplied, PostGIS uses its
        default value.

        Geometry conversion is intentionally represented as a SQLAlchemy
        expression so no Shapely dependency or client-side geometry conversion is
        required.
        """
        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"geometry attribute {source_attribute!r}."
            )

        source_geometry = getattr(
            source_row,
            source_attribute,
        )

        if source_geometry is None:
            return

        if z_value is None:
            desired_geometry = ST_Force3D(
                source_geometry,
            )
        else:
            desired_geometry = ST_Force3D(
                source_geometry,
                z_value,
            )

        effects.append(
            UpdateAttributeEffect(
                identity=identity,
                attribute_id=target_attribute,
                value=desired_geometry,
            )
        )

    def _append_agxx_gepprovider_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
        identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Project ``datenbewirtschafter_gep`` to the AG96 provider extension.
        """
        source_provider_oid = self._resolved_reference(
            source_row=source_row,
            source_attribute=("datenbewirtschafter_gep"),
            context=context,
        )

        canonical_provider_oid = self._canonical_oid(
            source_oid=source_provider_oid,
            mapping_name="organisation",
            context=context,
            source_row=source_row,
            reference_name=("AG96 data provider"),
        )

        if canonical_provider_oid is None:
            return

        current_provider_oid = self._row_value(
            current_row,
            "datenbewirtschafter_gep",
        )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute="ag96_fk_provider",
            desired_value=canonical_provider_oid,
            current_value=current_provider_oid,
        )

    def _append_gepknoten_measure_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
    ) -> None:
        """
        Project the AG96 measure reference on the structure extension.
        """
        if not hasattr(
            source_row,
            "gepmassnahmeref",
        ):
            return

        desired_measure_id = getattr(
            source_row,
            "gepmassnahmeref",
        )

        if desired_measure_id is None:
            return

        wastewater_structure_object_id = self._row_value(
            current_row,
            ("_mapping_wastewater_" "structure_obj_id"),
        )

        if (
            not isinstance(
                wastewater_structure_object_id,
                str,
            )
            or not wastewater_structure_object_id.strip()
        ):
            raise ValueError(
                "Cannot project GepKnoten measure reference "
                f"for source object "
                f"{self._source_object_id(source_row)!r}: "
                "the canonical comparison row does not "
                "identify an associated wastewater structure."
            )

        identity = CanonicalObjectIdentity(
            class_id=("agxx_wastewater_structure"),
            attributes={
                "fk_wastewater_structure": (wastewater_structure_object_id.strip()),
            },
        )

        current_measure_id = self._row_value(
            current_row,
            "gepmassnahmeref",
        )

        effects_start = len(
            effects,
        )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute="ag96_fk_measure",
            desired_value=desired_measure_id,
            current_value=current_measure_id,
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=identity,
            effects_start_index=effects_start,
        )

    def _append_gepknoten_function_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> None:
        """
        Project ``funktionag`` through the AGXX semantic candidate mapping.

        AGXX wastewater-node extension rows may be created. DSS subtype rows
        must already exist and are never created by this method.
        """
        if not hasattr(
            source_row,
            "funktionag",
        ):
            return

        source_value = getattr(
            source_row,
            "funktionag",
        )

        value_mapping = context.projection.value_lists.get(
            "funktionag",
        )

        if value_mapping is None:
            raise KeyError(
                "GepKnoten projection does not define "
                "the required ``funktionag`` value-list "
                "mapping."
            )

        if source_value is None or value_mapping.ignores(
            source_value,
        ):
            return

        current_value = self._row_value(
            current_row,
            "funktionag",
        )

        if self._values_equal(
            current_value=current_value,
            desired_value=source_value,
        ):
            return

        candidates = context.value_candidates(
            "funktionag",
            source_value,
        )

        if not candidates:
            self._raise_missing_value_mapping(
                source_row=source_row,
                source_attribute="funktionag",
                source_value=source_value,
                mapping=value_mapping,
            )

        current_subtype = self._row_value(
            current_row,
            "ws_type",
        )

        selected_candidate = self._select_gepknoten_function_candidate(
            source_row=source_row,
            source_value=source_value,
            current_subtype=current_subtype,
            candidates=candidates,
        )

        target_class_id = selected_candidate.target_class_id

        target_attribute_id = selected_candidate.target_attribute_id

        if target_class_id is None or target_attribute_id is None:
            raise ValueError(
                "GepKnoten ``funktionag`` mapping "
                f"for value {source_value!r} must define "
                "both target class and target attribute."
            )

        if target_class_id == "agxx_wastewater_node":
            identity = CanonicalObjectIdentity(
                class_id=target_class_id,
                attributes={
                    "fk_wastewater_node": (
                        self._source_object_id(
                            source_row,
                        )
                    ),
                },
            )

        else:
            wastewater_structure_object_id = self._row_value(
                current_row,
                ("_mapping_wastewater_" "structure_obj_id"),
            )

            if (
                not isinstance(
                    wastewater_structure_object_id,
                    str,
                )
                or not wastewater_structure_object_id.strip()
            ):
                raise ValueError(
                    "Cannot project GepKnoten "
                    f"``funktionag`` value "
                    f"{source_value!r} for source object "
                    f"{self._source_object_id(source_row)!r}: "
                    "the canonical comparison row does "
                    "not identify a wastewater structure."
                )

            identity = CanonicalObjectIdentity(
                class_id=target_class_id,
                attributes={
                    "obj_id": (wastewater_structure_object_id.strip()),
                },
            )

        effects_start = len(
            effects,
        )

        effects.append(
            UpdateAttributeEffect(
                identity=identity,
                attribute_id=target_attribute_id,
                value=selected_candidate.value,
            )
        )

        if target_class_id == "agxx_wastewater_node":
            self._prepend_exists_if_updates_added(
                effects=effects,
                identity=identity,
                effects_start_index=effects_start,
            )

    def _select_gepknoten_function_candidate(
        self,
        *,
        source_row: Any,
        source_value: Any,
        current_subtype: Any,
        candidates: tuple[
            ProjectionValueCandidate,
            ...,
        ],
    ) -> ProjectionValueCandidate:
        """
        Select the candidate compatible with the current canonical subtype.

        Structural subtype transitions are rejected by the MVP.
        """
        extension_candidates = tuple(
            candidate
            for candidate in candidates
            if (candidate.target_class_id == "agxx_wastewater_node")
        )

        if (
            len(
                extension_candidates,
            )
            == 1
        ):
            return extension_candidates[0]

        target_class_by_subtype = {
            "manhole": "manhole",
            "special_structure": ("special_structure"),
            "discharge_point": ("discharge_point"),
            "infiltration_installation": ("infiltration_installation"),
            "wwtp_structure": "wwtp_structure",
        }

        current_target_class = target_class_by_subtype.get(
            current_subtype,
        )

        compatible_candidates = tuple(
            candidate
            for candidate in candidates
            if (candidate.target_class_id == current_target_class)
        )

        if (
            len(
                compatible_candidates,
            )
            == 1
        ):
            return compatible_candidates[0]

        available_targets = tuple(
            sorted(
                {
                    (
                        candidate.target_class_id,
                        candidate.target_attribute_id,
                    )
                    for candidate in candidates
                },
                key=lambda target: (
                    str(target[0]),
                    str(target[1]),
                ),
            )
        )

        if current_target_class is None:
            raise ValueError(
                "Cannot project GepKnoten "
                f"``funktionag`` value {source_value!r} "
                f"for source object "
                f"{self._source_object_id(source_row)!r}. "
                f"The current wastewater-structure subtype "
                f"is {current_subtype!r}, and the MVP does "
                "not create or replace canonical subtypes. "
                f"Available mapping targets: "
                f"{available_targets!r}."
            )

        raise ValueError(
            "GepKnoten ``funktionag`` value "
            f"{source_value!r} for source object "
            f"{self._source_object_id(source_row)!r} "
            "would require a canonical subtype change or "
            "has an ambiguous mapping. Current subtype: "
            f"{current_subtype!r}; expected target class: "
            f"{current_target_class!r}; available targets: "
            f"{available_targets!r}."
        )

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
        Project AGXX-only GepHaltung content.

        Missing AGXX extension rows are created only when corresponding
        non-null source values produce updates. Existing rows are updated in
        place. DSS channel and structure rows must already exist.
        """
        effects: list[Effect,] = []

        source_object_id = self._source_object_id(
            source_row,
        )

        networkelement_extension_identity = CanonicalObjectIdentity(
            class_id=("agxx_wastewater_networkelement"),
            attributes={
                "fk_wastewater_networkelement": (source_object_id),
            },
        )

        last_modification_identity = CanonicalObjectIdentity(
            class_id="agxx_last_modification",
            attributes={
                "fk_element": source_object_id,
            },
        )

        reach_extension_identity = CanonicalObjectIdentity(
            class_id="agxx_reach",
            attributes={
                "fk_reach": source_object_id,
            },
        )

        self._append_agxx_wi_metadata_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            extension_identity=(networkelement_extension_identity),
            last_modification_identity=(last_modification_identity),
        )

        self._append_agxx_gep_metadata_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            extension_identity=(networkelement_extension_identity),
            last_modification_identity=(last_modification_identity),
        )

        reach_effects_start = len(
            effects,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="lichte_hoehe_geplant",
            identity=reach_extension_identity,
            target_attribute=("ag96_clear_height_planned"),
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="lichte_breite_geplant",
            identity=reach_extension_identity,
            target_attribute=("ag96_clear_width_planned"),
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=reach_extension_identity,
            effects_start_index=reach_effects_start,
        )

        self._append_gephaltung_measure_update(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
        )

        self._append_gephaltung_extension_value_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
        )

        return tuple(
            effects,
        )

    def _append_agxx_gep_metadata_updates(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
        extension_identity: CanonicalObjectIdentity,
        last_modification_identity: CanonicalObjectIdentity,
    ) -> None:
        """
        Project common AG96/GEP metadata and create extension rows as needed.
        """
        extension_effects_start = len(
            effects,
        )

        self._append_agxx_gepprovider_update(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            identity=extension_identity,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="bemerkung_gep",
            identity=extension_identity,
            target_attribute="ag96_remark",
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=extension_identity,
            effects_start_index=(extension_effects_start),
        )

        last_modification_effects_start = len(
            effects,
        )

        self._append_source_update_if_changed(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            source_attribute="letzte_aenderung_gep",
            identity=last_modification_identity,
            target_attribute=("ag96_last_modification"),
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=last_modification_identity,
            effects_start_index=(last_modification_effects_start),
        )

    def _append_gephaltung_measure_update(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
    ) -> None:
        """
        Project the AG96 measure reference on the structure extension.
        """
        if not hasattr(
            source_row,
            "gepmassnahmeref",
        ):
            return

        desired_measure_id = getattr(
            source_row,
            "gepmassnahmeref",
        )

        if desired_measure_id is None:
            return

        structure_object_id = self._row_value(
            current_row,
            "_mapping_wastewater_structure_obj_id",
        )

        if (
            not isinstance(
                structure_object_id,
                str,
            )
            or not structure_object_id.strip()
        ):
            raise ValueError(
                "Cannot project GepHaltung measure reference for "
                f"source object "
                f"{self._source_object_id(source_row)!r}: "
                "the canonical comparison row does not expose "
                "`_mapping_wastewater_structure_obj_id`."
            )

        identity = CanonicalObjectIdentity(
            class_id=("agxx_wastewater_structure"),
            attributes={
                "fk_wastewater_structure": (structure_object_id.strip()),
            },
        )

        current_measure_id = self._row_value(
            current_row,
            "gepmassnahmeref",
        )

        effects_start = len(
            effects,
        )

        self._append_update_if_changed(
            effects=effects,
            identity=identity,
            target_attribute="ag96_fk_measure",
            desired_value=desired_measure_id,
            current_value=current_measure_id,
        )

        self._prepend_exists_if_updates_added(
            effects=effects,
            identity=identity,
            effects_start_index=effects_start,
        )

    def _append_gephaltung_extension_value_updates(
        self,
        *,
        effects: MutableSequence[Effect,],
        source_row: Any,
        current_row: Any | None,
        context: TwwProjectionContext,
    ) -> None:
        """
        Project channel values added to existing DSS value lists for AGXX.

        Ordinary DSS values are ignored. Only the explicitly registered AGXX
        extension values are projected by the incremental importer.
        """
        structure_object_id = self._row_value(
            current_row,
            "_mapping_wastewater_structure_obj_id",
        )

        if (
            not isinstance(
                structure_object_id,
                str,
            )
            or not structure_object_id.strip()
        ):
            raise ValueError(
                "Cannot project AGXX GepHaltung channel extensions "
                f"for source object "
                f"{self._source_object_id(source_row)!r}: "
                "the canonical comparison row does not expose "
                "`_mapping_wastewater_structure_obj_id`."
            )

        channel_identity = CanonicalObjectIdentity(
            class_id="channel",
            attributes={
                "obj_id": structure_object_id.strip(),
            },
        )

        mappings = {
            "nutzungsartag_ist": "usage_current",
            "nutzungsartag_geplant": ("usage_planned"),
            "funktionhierarchisch": ("function_hierarchic"),
        }

        for (
            source_attribute,
            target_attribute,
        ) in mappings.items():
            if not hasattr(
                source_row,
                source_attribute,
            ):
                continue

            source_value = getattr(
                source_row,
                source_attribute,
            )

            if source_value is None:
                continue

            extension_values = _AGXX_GEPHALTUNG_EXTENSION_VALUES[source_attribute]

            if source_value not in extension_values:
                continue

            self._append_mapped_update_if_changed(
                effects=effects,
                source_row=source_row,
                current_row=current_row,
                source_attribute=source_attribute,
                identity=channel_identity,
                target_attribute=target_attribute,
                context=context,
            )

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
        Project AGXX-only overflow and pump metadata.

        Ordinary DSS overflow attributes are deliberately ignored because they
        were handled by the baseline import.

        The canonical subtype is validated against the AGXX ``art`` value. The
        MVP does not create, delete or replace pump, leaping-weir or prank-weir
        subtype rows.
        """
        if current_row is None:
            raise ValueError(
                "Cannot project AGXX overflow source object "
                f"{self._source_object_id(source_row)!r}: "
                "no canonical comparison row exists."
            )

        self._assert_overflow_subtype(
            source_row=source_row,
            current_row=current_row,
        )

        effects: list[Effect,] = []

        source_object_id = self._source_object_id(
            source_row,
        )

        overflow_extension_identity = CanonicalObjectIdentity(
            class_id="agxx_overflow",
            attributes={
                "fk_overflow": source_object_id,
            },
        )

        last_modification_identity = CanonicalObjectIdentity(
            class_id="agxx_last_modification",
            attributes={
                "fk_element": source_object_id,
            },
        )

        self._append_agxx_gep_metadata_updates(
            effects=effects,
            source_row=source_row,
            current_row=current_row,
            context=context,
            extension_identity=(overflow_extension_identity),
            last_modification_identity=(last_modification_identity),
        )

        return tuple(
            effects,
        )

    def _assert_overflow_subtype(
        self,
        *,
        source_row: Any,
        current_row: Any,
    ) -> None:
        """
        Require the AGXX source type to match the existing canonical subtype.

        Structural subtype transitions are deliberately outside the MVP because
        they would require creating one subtype row and deleting another.
        """
        if not hasattr(
            source_row,
            "art",
        ):
            raise ValueError(
                "AGXX overflow source row does not expose " "the required `art` discriminator."
            )

        source_type = getattr(
            source_row,
            "art",
        )

        expected_subtype_by_source_type = {
            "Foerderaggregat": "pump",
            "Leapingwehr": "leapingweir",
            "Streichwehr": "prank_weir",
        }

        expected_subtype = expected_subtype_by_source_type.get(
            source_type,
        )

        if expected_subtype is None:
            raise ValueError(
                "Unsupported AGXX overflow type "
                f"{source_type!r} for source object "
                f"{self._source_object_id(source_row)!r}. "
                "Supported types are "
                f"{tuple(expected_subtype_by_source_type)!r}."
            )

        current_subtype = self._row_value(
            current_row,
            "ov_type",
        )

        if current_subtype == expected_subtype:
            return

        raise ValueError(
            "AGXX overflow subtype change is outside the MVP. "
            f"Source object {self._source_object_id(source_row)!r} "
            f"declares type {source_type!r}, which requires "
            f"canonical subtype {expected_subtype!r}, but the "
            f"existing canonical subtype is {current_subtype!r}."
        )

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
                "Projection source row does not expose " f"reference {source_attribute!r}."
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

        referenced_row = resolved_reference.rows_by_t_id.get(
            source_reference,
        )

        if referenced_row is None:
            raise ValueError(
                "Could not resolve source reference "
                f"{source_attribute!r}=t_id "
                f"{source_reference!r} for source object "
                f"{self._source_object_id(source_row)!r}."
            )

        identity_attribute = resolved_reference.mapping.identity_attribute

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

        value_mapping = context.projection.value_lists.get(
            source_attribute,
        )

        if value_mapping is None:
            raise KeyError(
                "Projection does not define a value-list " f"mapping for {source_attribute!r}."
            )

        if source_value is None or value_mapping.ignores(
            source_value,
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

        if (
            len(
                candidates,
            )
            != 1
        ):
            raise ValueError(
                "Projection value mapping for source attribute "
                f"{source_attribute!r} with value "
                f"{source_value!r} returned "
                f"{len(candidates)} candidates. Class-specific "
                "target disambiguation is required."
            )

        return candidates[0]

    def _append_source_update_if_changed(
        self,
        *,
        effects: MutableSequence[Effect,],
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
                "Projection source row does not expose " f"attribute {source_attribute!r}."
            )

        desired_value = getattr(
            source_row,
            source_attribute,
        )

        if desired_value is None:
            return

        comparison_attribute = current_attribute or source_attribute

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
        effects: MutableSequence[Effect,],
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

        if not hasattr(
            source_row,
            source_attribute,
        ):
            raise ValueError(
                "Projection source row does not expose "
                f"value-list attribute {source_attribute!r}."
            )

        value_mapping = context.projection.value_lists[source_attribute]
        source_value = getattr(
            source_row,
            source_attribute,
        )

        if source_value is None or value_mapping.ignores(
            source_value,
        ):
            return

        comparison_attribute = current_attribute or source_attribute

        current_value = self._row_value(
            current_row,
            comparison_attribute,
        )

        if self._values_equal(
            current_value=current_value,
            desired_value=source_value,
        ):
            return

        candidate = self._single_value_candidate(
            source_row=source_row,
            source_attribute=source_attribute,
            context=context,
        )

        if candidate is None:
            return

        if candidate.target_class_id is not None or candidate.target_attribute_id is not None:
            raise ValueError(
                "Projection value mapping for "
                f"{source_attribute!r} returned target "
                "metadata. Use class-specific semantic "
                "disambiguation instead of the ordinary "
                "mapped-update helper."
            )

        desired_value = candidate.value

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
        effects: MutableSequence[Effect,],
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

            return row[attribute]

        if not hasattr(
            row,
            attribute,
        ):
            raise ValueError(
                "Canonical comparison row does not expose " f"attribute {attribute!r}."
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
                "Projection source row does not expose a valid " "`t_ili_tid` or `obj_id`."
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

        if current_value is None or desired_value is None:
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
        source_rows: Sequence[Any,],
    ) -> None:
        """
        Require unique source object identities within one projected class.
        """

        seen: set[str,] = set()

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
        source_rows: Sequence[Any,],
        documents: Sequence[EffectDocument,],
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
            expected_object_id = self._source_object_id(
                source_row,
            )

            if document.source.class_id != source_class_id:
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"class {document.source.class_id!r}; "
                    f"expected {source_class_id!r}."
                )

            if document.source.object_id != expected_object_id:
                raise ValueError(
                    "Canonical-view projection returned source "
                    f"object {document.source.object_id!r}; "
                    f"expected {expected_object_id!r}."
                )

    def _prepend_exists_if_updates_added(
        self,
        *,
        effects: MutableSequence[Effect,],
        identity: CanonicalObjectIdentity,
        effects_start_index: int,
    ) -> None:
        """
        Require one canonical object when updates were added for its identity.

        The existence effect is inserted before the generated updates so the
        evaluator can project creation into its in-memory desired state before
        evaluating subsequent attribute updates. Empty extension objects are
        not created when all source values are null, ignored or unchanged.
        """
        if effects_start_index < 0 or effects_start_index > len(
            effects,
        ):
            raise ValueError("effects_start_index is outside the effect sequence.")

        updates_added = any(
            isinstance(
                effect,
                UpdateAttributeEffect,
            )
            and effect.identity == identity
            for effect in effects[effects_start_index:]
        )

        if not updates_added:
            return

        already_required = any(
            isinstance(
                effect,
                EnforceExistsEffect,
            )
            and effect.identity == identity
            for effect in effects
        )

        if already_required:
            return

        effects.insert(
            effects_start_index,
            EnforceExistsEffect(
                identity=identity,
            ),
        )
