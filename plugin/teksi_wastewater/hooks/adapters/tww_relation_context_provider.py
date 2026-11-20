from __future__ import annotations

import logging
from collections.abc import Mapping
from dataclasses import dataclass, field, replace
from enum import StrEnum
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.exc import NoInspectionAvailable
from sqlalchemy.sql import visitors
from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalIdentityMapping,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ForeignKeyMapping,
    MappingDefaults,
    RelationContext,
    RelationMapping,
)
from teksi_hooks.services.relation_context_provider import (
    RelationContextProvider,
)

from .tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)

_AG96_MAPPING_ID_BY_RELATION_NAME: Mapping[
    str,
    str,
] = {
    "gepmassnahme": "GepMassnahme",
    "gepknoten": "GepKnoten",
    "abwasserbauwerk": "GepKnoten",
    "gephaltung": "GepHaltung",
    "haltung": "GepHaltung",
    "einzugsgebiet": "Einzugsgebiet",
    "bautenausserhalbbaugebiet": ("BautenAusserhalbBaugebiet"),
    "ueberlauf_foerderaggregat": ("Ueberlauf_Foerderaggregat"),
    "sbw_einzugsgebiet": "SBWEinzugsgebiet",
    "versickerungsbereichag": ("VersickerungsbereichAG"),
}


class MappingProjectionMode(
    StrEnum,
):
    FULL = "full"
    EXPLICIT_ONLY = "explicit_only"


@dataclass(
    slots=True,
    frozen=True,
)
class ResolvedRelationClassMapping:
    """
    Hold the stable mapping identifier and executable mapping resolved for
    one ORM relation.

    ``source_class_id`` is the stable identifier used by explicit model
    mappings, effect documents and incremental projection.

    Physical ili2pg table names and generated ORM class names are used only
    while resolving this object.
    """

    source_class_id: str

    class_mapping: ClassMapping


@dataclass(
    slots=True,
)
class TwwRelationContextProvider(
    RelationContextProvider,
):
    """
    Build relation contexts for one TEKSI Wastewater quarantine model.

    Physical ORM relation names are resolved to stable source mapping
    identifiers at the provider boundary.

    The stable identifier is retained in ``RelationContext.source_class_id``.
    Downstream projectors must use that identifier and must not derive another
    identifier from the physical ORM table or Python class name.

    For the current incremental-import MVP, explicit AG96 class bindings are
    supported. Export-facing INTERLIS class names remain the responsibility
    of external transformers.

    All derived mapping information is cached for the lifetime of this
    provider. Call ``clear_cache()`` if any ORM, model-mapping or canonical
    model input changes.
    """

    quarantine_classes: Mapping[
        str,
        Any,
    ]

    model_mapping: EffectiveModelMappingCapability

    canonical_model_adapter: TwwCanonicalModelAdapter

    projection_mode: MappingProjectionMode = MappingProjectionMode.FULL

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    _relation_contexts_cache: (
        tuple[
            RelationContext,
            ...,
        ]
        | None
    ) = field(
        default=None,
        init=False,
        repr=False,
    )

    _resolved_relation_mapping_cache: dict[
        Any,
        ResolvedRelationClassMapping | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _explicit_mapping_cache: dict[
        str,
        ClassMapping | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _implicit_mapping_cache: dict[
        str,
        ClassMapping | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _inherited_explicit_mapping_cache: dict[
        Any,
        ClassMapping | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _referenced_mapping_cache: dict[
        Any,
        ClassMapping | None,
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _source_attribute_names_cache: dict[
        Any,
        frozenset[str,],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    _relation_inheritance_hierarchy_cache: dict[
        Any,
        tuple[
            Any,
            ...,
        ],
    ] = field(
        default_factory=dict,
        init=False,
        repr=False,
    )

    # ------------------------------------------------------------------
    # Public provider API
    # ------------------------------------------------------------------

    def relation_contexts(
        self,
    ) -> tuple[
        RelationContext,
        ...,
    ]:
        """
        Return cached contexts for mapped quarantine business relations.
        """
        if self._relation_contexts_cache is None:
            self._relation_contexts_cache = self._build_relation_contexts()

        return self._relation_contexts_cache

    def clear_cache(
        self,
    ) -> None:
        """
        Clear all data derived from the current ORM and mapping inputs.
        """
        self._relation_contexts_cache = None

        self._resolved_relation_mapping_cache.clear()
        self._explicit_mapping_cache.clear()
        self._implicit_mapping_cache.clear()
        self._inherited_explicit_mapping_cache.clear()
        self._referenced_mapping_cache.clear()
        self._source_attribute_names_cache.clear()
        self._relation_inheritance_hierarchy_cache.clear()

    # ------------------------------------------------------------------
    # Relation-context construction
    # ------------------------------------------------------------------

    def _build_relation_contexts(
        self,
    ) -> tuple[
        RelationContext,
        ...,
    ]:
        """
        Build contexts for mapped quarantine business relations.

        Each context retains the stable source mapping identifier that
        successfully resolved the relation.
        """
        contexts: list[RelationContext,] = []

        explicit_mapping = getattr(
            self.model_mapping,
            "explicit_mapping",
            None,
        )

        explicit_model = getattr(
            explicit_mapping,
            "mapping",
            None,
        )

        explicit_class_ids = (
            tuple(
                sorted(
                    explicit_model.classes,
                )
            )
            if explicit_model is not None
            else ()
        )

        self.logger.info(
            "Building relation contexts with projection_mode=%r " "and explicit classes=%r.",
            self.projection_mode,
            explicit_class_ids,
        )

        reflected_count = 0

        for relation_entry in self.quarantine_classes:
            reflected_count += 1

            relation_class = self._relation_class(
                relation_entry,
            )

            relation_name = self._relation_name(
                relation_class,
            )

            if self._is_ili2db_metadata_relation(
                relation_name,
            ):
                self.logger.debug(
                    "Ignoring ili2db metadata relation %r.",
                    relation_name,
                )

                continue

            if self._is_association_class(
                relation_class,
            ):
                self.logger.debug(
                    "Ignoring association relation %r during " "canonical object projection.",
                    relation_name,
                )

                continue

            source_class_ids = self._source_class_ids(
                relation_class,
            )

            self.logger.info(
                "Resolving quarantine relation %r with source " "candidates %r.",
                relation_name,
                source_class_ids,
            )

            resolved = self._resolved_relation_mapping(
                relation=relation_class,
            )

            if resolved is None:
                self.logger.debug(
                    "Ignoring unmapped quarantine relation %r. "
                    "Candidate source identifiers: %r.",
                    relation_name,
                    source_class_ids,
                )

                continue

            relation_context = RelationContext(
                source_class_id=(resolved.source_class_id),
                relation=relation_class,
                class_mapping=(resolved.class_mapping),
            )

            contexts.append(
                relation_context,
            )

            self.logger.debug(
                "Prepared relation context: source_class_id=%r, "
                "physical_relation=%r, declared_class=%r, "
                "projection_backed=%s, attribute_backed=%s.",
                relation_context.source_class_id,
                relation_name,
                self._declared_class_name(
                    relation_class,
                ),
                (relation_context.class_mapping.is_projection_backed),
                (relation_context.class_mapping.is_attribute_backed),
            )

        self._assert_unique_source_class_ids(
            contexts=contexts,
        )

        self.logger.info(
            "Prepared %s relation contexts from %s reflected "
            "quarantine relations. Source classes: %r.",
            len(
                contexts,
            ),
            reflected_count,
            tuple(relation_context.source_class_id for relation_context in contexts),
        )

        return tuple(
            contexts,
        )

    # ------------------------------------------------------------------
    # Main mapping-resolution pipeline
    # ------------------------------------------------------------------

    def _resolved_relation_mapping(
        self,
        *,
        relation,
    ) -> ResolvedRelationClassMapping | None:
        """
        Resolve the stable source-class ID and executable mapping.

        Direct class-level projection mappings are resolved first. Remaining
        attribute-backed mappings use the existing inheritance, defaults,
        identity localization, canonical normalization and validation
        pipeline.
        """
        if relation in self._resolved_relation_mapping_cache:
            return self._resolved_relation_mapping_cache[relation]

        source_class_ids = self._source_class_ids(
            relation,
        )

        direct_projection = self._direct_explicit_projection_entry(
            relation=relation,
        )

        if direct_projection is not None:
            (
                source_class_id,
                class_mapping,
            ) = direct_projection

            resolved = ResolvedRelationClassMapping(
                source_class_id=source_class_id,
                class_mapping=class_mapping,
            )

            self._resolved_relation_mapping_cache[relation] = resolved

            return resolved

        implicit_class = self._first_implicit_class_definition(
            source_class_ids,
        )

        explicit_class = self._inherited_explicit_class_definition(
            relation=relation,
        )

        if self.projection_mode == MappingProjectionMode.EXPLICIT_ONLY:
            if not self._has_explicit_projection(
                relation=relation,
                explicit_class=explicit_class,
            ):
                self._resolved_relation_mapping_cache[relation] = None

                return None

            if not self._has_resolvable_target(
                explicit_class=explicit_class,
                implicit_class=implicit_class,
            ):
                self.logger.debug(
                    "Ignoring explicit-only source relation %r "
                    "because it has no resolvable canonical target.",
                    self._relation_name(
                        relation,
                    ),
                )

                self._resolved_relation_mapping_cache[relation] = None

                return None

        elif explicit_class is None and implicit_class is None:
            self._resolved_relation_mapping_cache[relation] = None

            return None

        source_class_id = self._resolved_attribute_source_class_id(
            relation=relation,
            candidate_ids=source_class_ids,
        )

        class_mapping = self._resolve_attribute_class_mapping(
            relation=relation,
            source_class_id=source_class_id,
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

        resolved = ResolvedRelationClassMapping(
            source_class_id=source_class_id,
            class_mapping=class_mapping,
        )

        self._resolved_relation_mapping_cache[relation] = resolved

        return resolved

    def _class_mapping_for_relation(
        self,
        relation,
    ) -> ClassMapping:
        """
        Return the executable mapping for one ORM relation.
        """
        resolved = self._resolved_relation_mapping(
            relation=relation,
        )

        if resolved is None:
            raise KeyError(
                "No executable mapping exists for source "
                f"relation {self._relation_name(relation)!r}. "
                "Candidate identifiers: "
                f"{self._source_class_ids(relation)!r}."
            )

        return resolved.class_mapping

    def _has_class_mapping(
        self,
        relation,
    ) -> bool:
        """
        Return whether a relation produces a runtime relation context.
        """
        return (
            self._resolved_relation_mapping(
                relation=relation,
            )
            is not None
        )

    def _has_explicit_projection(
        self,
        *,
        relation,
        explicit_class: ClassMapping | None,
    ) -> bool:
        """
        Return whether an attribute-backed relation contributes explicit
        projected content.

        Direct class-level projection mappings are handled before this
        method. Identities and relation declarations provide structural
        support but do not select a relation without mapped attributes.
        """
        if explicit_class is not None and explicit_class.attributes:
            return True

        source_attributes = self._source_attribute_names(
            relation,
        )

        defaults = self._explicit_defaults()

        return any(
            source_attribute in source_attributes for source_attribute in defaults.attributes
        )

    def _has_resolvable_target(
        self,
        *,
        explicit_class: ClassMapping | None,
        implicit_class: ClassMapping | None,
    ) -> bool:
        """
        Return whether an attribute-backed mapping declares a canonical
        target.

        A mapping may omit its primary canonical class and address target
        classes through attribute mappings and identities instead.
        """
        for class_mapping in (
            explicit_class,
            implicit_class,
        ):
            if class_mapping is None:
                continue

            if class_mapping.canonical_class_id is not None:
                return True

            if any(
                attribute_mapping.canonical_class_id is not None
                for attribute_mapping in class_mapping.attributes.values()
            ):
                return True

            if class_mapping.identities:
                return True

        return False

    def _resolved_attribute_source_class_id(
        self,
        *,
        relation,
        candidate_ids: tuple[
            str,
            ...,
        ],
    ) -> str:
        """
        Return the stable mapping identifier for an attribute-backed relation.

        The configured AG96 mapping ID is preferred. Otherwise, the first
        candidate resolving an explicit or implicit mapping is retained.
        """
        physical_name = self._relation_name(
            relation,
        )

        declared_name = self._declared_class_name(
            relation,
        )

        stable_mapping_id = self._ag96_mapping_id(
            physical_name,
            declared_name,
        )

        if stable_mapping_id is not None:
            if (
                self._try_explicit_class_definition(
                    stable_mapping_id,
                )
                is not None
                or self._try_implicit_class_definition(
                    stable_mapping_id,
                )
                is not None
            ):
                return stable_mapping_id

        for candidate_id in candidate_ids:
            if (
                self._try_explicit_class_definition(
                    candidate_id,
                )
                is not None
            ):
                return candidate_id

        for candidate_id in candidate_ids:
            if (
                self._try_implicit_class_definition(
                    candidate_id,
                )
                is not None
            ):
                return candidate_id

        raise KeyError(
            "Could not determine the stable source-class "
            f"identifier for relation {physical_name!r}. "
            f"Candidates: {candidate_ids!r}."
        )

    def _resolve_attribute_class_mapping(
        self,
        *,
        relation,
        source_class_id: str,
        explicit_class: ClassMapping | None,
        implicit_class: ClassMapping | None,
    ) -> ClassMapping:
        """
        Resolve, localize, normalize and validate an attribute-backed mapping.
        """
        if explicit_class is None and implicit_class is None:
            raise KeyError(
                "No explicit or implicit class mapping exists for "
                f"source class {source_class_id!r}."
            )

        self.logger.debug(
            "Resolving attribute-backed source relation %r. "
            "Candidate identifiers: %r; implicit canonical "
            "class: %r; inherited explicit mapping found: %s.",
            source_class_id,
            self._source_class_ids(
                relation,
            ),
            (implicit_class.canonical_class_id if implicit_class is not None else None),
            explicit_class is not None,
        )

        resolved = self._resolve_attribute_backed_class(
            relation=relation,
            source_class_id=source_class_id,
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

        resolved = self._with_localized_identities(
            relation=relation,
            class_mapping=resolved,
        )

        resolved = self._with_physical_canonical_attributes(
            class_mapping=resolved,
        )

        if self.projection_mode == MappingProjectionMode.FULL:
            resolved = self._with_automap_foreign_keys(
                relation=relation,
                class_mapping=resolved,
            )

        self._validate_resolved_class_mapping(
            relation=relation,
            source_class_id=source_class_id,
            class_mapping=resolved,
        )

        return resolved

    def _resolve_attribute_backed_class(
        self,
        *,
        relation,
        source_class_id: str,
        explicit_class: ClassMapping | None,
        implicit_class: ClassMapping | None,
    ) -> ClassMapping:
        """
        Resolve one attribute-backed class using declarations and ORM
        metadata.
        """
        source_attributes = self._source_attribute_names(
            relation,
        )

        defaults = self._explicit_defaults()

        canonical_class_id = self._canonical_class_id(
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

        applicable_default_attributes = self._applicable_default_attributes(
            source_attributes=source_attributes,
            defaults=defaults,
        )

        relations = self._resolved_relations(
            defaults=defaults,
            explicit_class=explicit_class,
        )

        self.logger.debug(
            "Resolving relation declarations for source class %r. "
            "Primary canonical class: %r. Declared canonical "
            "relations: %r.",
            source_class_id,
            canonical_class_id,
            tuple(
                sorted(
                    relations,
                )
            ),
        )

        if self.projection_mode == MappingProjectionMode.FULL:
            relation_attributes = self._localized_relation_attribute_mappings(
                source_class_id=source_class_id,
                canonical_class_id=canonical_class_id,
                source_attributes=source_attributes,
                relations=relations,
            )
        else:
            relation_attributes = {}

        attributes: dict[
            str,
            AttributeMapping,
        ] = {}

        if self.projection_mode == MappingProjectionMode.FULL and implicit_class is not None:
            attributes.update(
                implicit_class.attributes,
            )

        attributes.update(
            applicable_default_attributes,
        )

        attributes.update(
            relation_attributes,
        )

        if explicit_class is not None:
            attributes.update(
                explicit_class.attributes,
            )

        identities = self._resolved_identities(
            defaults=defaults,
            explicit_class=explicit_class,
            implicit_class=implicit_class,
            attributes=attributes,
            canonical_class_id=canonical_class_id,
        )

        primary_identity = (
            explicit_class.identity
            if (explicit_class is not None and explicit_class.identity is not None)
            else (
                implicit_class.identity
                if (implicit_class is not None and implicit_class.identity is not None)
                else defaults.identity
            )
        )

        localisations: dict[
            str,
            str,
        ] = {}

        if implicit_class is not None:
            localisations.update(
                implicit_class.localisations,
            )

        if explicit_class is not None:
            localisations.update(
                explicit_class.localisations,
            )

        return ClassMapping(
            canonical_class_id=canonical_class_id,
            identity=primary_identity,
            identities=identities,
            attributes=attributes,
            relations=relations,
            localisations=localisations,
            projection=None,
        )

    # ------------------------------------------------------------------
    # Explicit and implicit mapping lookup
    # ------------------------------------------------------------------

    def _first_explicit_class_definition(
        self,
        class_ids: tuple[
            str,
            ...,
        ],
    ) -> ClassMapping | None:
        """
        Return the first explicit mapping found for candidate identifiers.
        """
        for class_id in class_ids:
            class_mapping = self._try_explicit_class_definition(
                class_id,
            )

            if class_mapping is not None:
                return class_mapping

        return None

    def _first_implicit_class_definition(
        self,
        class_ids: tuple[
            str,
            ...,
        ],
    ) -> ClassMapping | None:
        """
        Return the first implicit mapping found for candidate identifiers.
        """
        for class_id in class_ids:
            class_mapping = self._try_implicit_class_definition(
                class_id,
            )

            if class_mapping is not None:
                return class_mapping

        return None

    def _try_explicit_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        """
        Return a cached explicit class mapping if one exists.
        """
        if class_id in self._explicit_mapping_cache:
            return self._explicit_mapping_cache[class_id]

        capability = getattr(
            self.model_mapping,
            "explicit_mapping",
            None,
        )

        class_mapping = (
            capability.try_class_definition(
                class_id,
            )
            if capability is not None
            else None
        )

        self._explicit_mapping_cache[class_id] = class_mapping

        return class_mapping

    def _try_implicit_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        """
        Return a cached implicit class mapping if one exists.
        """
        if class_id in self._implicit_mapping_cache:
            return self._implicit_mapping_cache[class_id]

        capability = getattr(
            self.model_mapping,
            "implicit_mapping",
            None,
        )

        class_mapping = (
            capability.try_class_definition(
                class_id,
            )
            if capability is not None
            else None
        )

        self._implicit_mapping_cache[class_id] = class_mapping

        return class_mapping

    def _explicit_defaults(
        self,
    ) -> MappingDefaults:
        """
        Return defaults from the resolved explicit mapping.
        """
        capability = getattr(
            self.model_mapping,
            "explicit_mapping",
            None,
        )

        if capability is None:
            return MappingDefaults()

        mapping = getattr(
            capability,
            "mapping",
            None,
        )

        if mapping is None:
            return MappingDefaults()

        return mapping.defaults

    def _canonical_class_id(
        self,
        *,
        explicit_class: ClassMapping | None,
        implicit_class: ClassMapping | None,
    ) -> str | None:
        """
        Return the primary canonical class identifier.
        """
        if implicit_class is not None and implicit_class.canonical_class_id is not None:
            return implicit_class.canonical_class_id

        if explicit_class is not None:
            return explicit_class.canonical_class_id

        return None

    # ------------------------------------------------------------------
    # Direct projection lookup and inheritance
    # ------------------------------------------------------------------

    def _direct_explicit_projection_entry(
        self,
        *,
        relation,
    ) -> (
        tuple[
            str,
            ClassMapping,
        ]
        | None
    ):
        """
        Return the stable source-class ID and direct projection mapping.

        Projection mappings describe complete concrete class projections and
        are never inherited through the ORM hierarchy.
        """
        source_class_ids = list(
            self._source_class_ids(
                relation,
            )
        )

        implicit_class = self._first_implicit_class_definition(
            tuple(
                source_class_ids,
            )
        )

        if (
            implicit_class is not None
            and implicit_class.canonical_class_id is not None
            and implicit_class.canonical_class_id not in source_class_ids
        ):
            source_class_ids.append(
                implicit_class.canonical_class_id,
            )

        for source_class_id in source_class_ids:
            explicit_class = self._try_explicit_class_definition(
                source_class_id,
            )

            if explicit_class is not None and explicit_class.projection is not None:
                return (
                    source_class_id,
                    explicit_class,
                )

        return None

    def _direct_explicit_projection_definition(
        self,
        *,
        relation,
    ) -> ClassMapping | None:
        """
        Return a directly declared projection mapping.
        """
        entry = self._direct_explicit_projection_entry(
            relation=relation,
        )

        if entry is None:
            return None

        return entry[1]

    def _inherited_explicit_class_definition(
        self,
        *,
        relation,
    ) -> ClassMapping | None:
        """
        Return the cached inherited explicit mapping for one ORM hierarchy.

        Parent mappings are merged from root to child. Child declarations
        override parent declarations with the same key. Projection mappings
        are never inherited.
        """
        if relation in self._inherited_explicit_mapping_cache:
            return self._inherited_explicit_mapping_cache[relation]

        hierarchy = self._relation_inheritance_hierarchy(
            relation,
        )

        merged: ClassMapping | None = None

        for hierarchy_relation in hierarchy:
            source_class_ids = self._source_class_ids(
                hierarchy_relation,
            )

            implicit_class = self._first_implicit_class_definition(
                source_class_ids,
            )

            explicit_class_ids = list(
                source_class_ids,
            )

            if (
                implicit_class is not None
                and implicit_class.canonical_class_id is not None
                and implicit_class.canonical_class_id not in explicit_class_ids
            ):
                explicit_class_ids.append(
                    implicit_class.canonical_class_id,
                )

            explicit_class = self._first_explicit_class_definition(
                tuple(
                    explicit_class_ids,
                )
            )

            self.logger.debug(
                "Explicit inheritance lookup for ORM relation %r: "
                "source identifiers=%r, canonical class=%r, "
                "lookup identifiers=%r, mapping found=%s.",
                self._relation_name(
                    hierarchy_relation,
                ),
                source_class_ids,
                (implicit_class.canonical_class_id if implicit_class is not None else None),
                tuple(
                    explicit_class_ids,
                ),
                explicit_class is not None,
            )

            if explicit_class is None:
                continue

            inheritance_mapping = replace(
                explicit_class,
                projection=None,
            )

            if merged is None:
                merged = inheritance_mapping
            else:
                merged = self._merge_inherited_class_mapping(
                    parent=merged,
                    child=inheritance_mapping,
                )

        self._inherited_explicit_mapping_cache[relation] = merged

        return merged

    def _relation_inheritance_hierarchy(
        self,
        relation,
    ) -> tuple[
        Any,
        ...,
    ]:
        """
        Return cached ORM classes from root parent to child.
        """
        cached = self._relation_inheritance_hierarchy_cache.get(
            relation,
        )

        if cached is not None:
            return cached

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable:
            hierarchy = (relation,)
        else:
            hierarchy_items: list[Any,] = []

            current_mapper = mapper

            while current_mapper is not None:
                hierarchy_items.append(
                    current_mapper.class_,
                )

                current_mapper = current_mapper.inherits

            hierarchy_items.reverse()

            hierarchy = tuple(
                hierarchy_items,
            )

        self._relation_inheritance_hierarchy_cache[relation] = hierarchy

        return hierarchy

    def _merge_inherited_class_mapping(
        self,
        *,
        parent: ClassMapping,
        child: ClassMapping,
    ) -> ClassMapping:
        """
        Merge inherited explicit declarations.
        """
        identities = dict(
            parent.identities,
        )

        identities.update(
            child.identities,
        )

        attributes = dict(
            parent.attributes,
        )

        attributes.update(
            child.attributes,
        )

        relations = dict(
            parent.relations,
        )

        relations.update(
            child.relations,
        )

        localisations = dict(
            parent.localisations,
        )

        localisations.update(
            child.localisations,
        )

        return ClassMapping(
            canonical_class_id=(
                child.canonical_class_id
                if child.canonical_class_id is not None
                else parent.canonical_class_id
            ),
            identity=(child.identity if child.identity is not None else parent.identity),
            identities=identities,
            attributes=attributes,
            relations=relations,
            localisations=localisations,
            projection=None,
        )

    # ------------------------------------------------------------------
    # Source attributes and explicit relation localization
    # ------------------------------------------------------------------

    def _source_attribute_names(
        self,
        relation,
    ) -> frozenset[str,]:
        """
        Return cached effective SQLAlchemy source attribute identifiers.
        """
        cached = self._source_attribute_names_cache.get(
            relation,
        )

        if cached is not None:
            return cached

        attribute_names: set[str,] = set()

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable:
            mapper = None

        if mapper is not None:
            for column_property in mapper.column_attrs:
                key = getattr(
                    column_property,
                    "key",
                    None,
                )

                if key:
                    attribute_names.add(
                        str(
                            key,
                        )
                    )

                for column in getattr(
                    column_property,
                    "columns",
                    (),
                ):
                    attribute_names.add(
                        self._column_attribute_name(
                            column,
                        )
                    )

        table = getattr(
            relation,
            "__table__",
            None,
        )

        if table is not None:
            for column in table.columns:
                attribute_names.add(
                    self._column_attribute_name(
                        column,
                    )
                )

        result = frozenset(
            attribute_names,
        )

        self._source_attribute_names_cache[relation] = result

        return result

    def _applicable_default_attributes(
        self,
        *,
        source_attributes: frozenset[str,],
        defaults: MappingDefaults,
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Return default mappings whose source attributes exist.
        """
        return {
            source_attribute: mapping
            for (
                source_attribute,
                mapping,
            ) in defaults.attributes.items()
            if source_attribute in source_attributes
        }

    def _resolved_relations(
        self,
        *,
        defaults: MappingDefaults,
        explicit_class: ClassMapping | None,
    ) -> dict[
        str,
        RelationMapping,
    ]:
        """
        Merge default and class-specific relation declarations.
        """
        relations = dict(
            defaults.relations,
        )

        if explicit_class is not None:
            relations.update(
                explicit_class.relations,
            )

        return relations

    def _localized_relation_attribute_mappings(
        self,
        *,
        source_class_id: str,
        canonical_class_id: str | None,
        source_attributes: frozenset[str,],
        relations: Mapping[
            str,
            RelationMapping,
        ],
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Resolve explicit relation declarations to source ORM attributes.
        """
        if canonical_class_id is None:
            return {}

        source_attribute_by_normalized_name = {
            source_attribute.casefold(): source_attribute for source_attribute in source_attributes
        }

        attributes: dict[
            str,
            AttributeMapping,
        ] = {}

        for (
            canonical_attribute_id,
            relation_mapping,
        ) in relations.items():
            candidates = {
                canonical_attribute_id,
                *relation_mapping.localisations.values(),
            }

            matches = {
                source_attribute_by_normalized_name[candidate.casefold()]
                for candidate in candidates
                if candidate.casefold() in source_attribute_by_normalized_name
            }

            if not matches:
                continue

            if (
                len(
                    matches,
                )
                != 1
            ):
                raise ValueError(
                    "Several source attributes match canonical "
                    f"relation {canonical_class_id!r}."
                    f"{canonical_attribute_id!r}: "
                    f"{tuple(sorted(matches))!r}."
                )

            source_attribute = next(
                iter(
                    matches,
                )
            )

            attributes[source_attribute] = AttributeMapping(
                canonical_class_id=canonical_class_id,
                canonical_attr_id=canonical_attribute_id,
                foreign_key=ForeignKeyMapping(
                    referenced_class_id=(relation_mapping.referenced_class_id),
                    referenced_attribute_id=(relation_mapping.referenced_attribute_id),
                ),
                value_list=None,
            )

            self.logger.info(
                "Resolved localized relation mapping " "%r.%r -> %r.%r, referencing %r.%r.",
                source_class_id,
                source_attribute,
                canonical_class_id,
                canonical_attribute_id,
                relation_mapping.referenced_class_id,
                relation_mapping.referenced_attribute_id,
            )

        return attributes

    # ------------------------------------------------------------------
    # Identity resolution and localization
    # ------------------------------------------------------------------

    def _localized_identity(
        self,
        *,
        canonical_class_id: str,
        primary_canonical_class_id: str | None,
        identity: CanonicalIdentityMapping,
        source_attributes: frozenset[str,],
    ) -> CanonicalIdentityMapping:
        """
        Localize one canonical identity to an available source attribute.
        """
        if identity.source_attribute in source_attributes:
            return identity

        if (
            canonical_class_id == primary_canonical_class_id
            and identity.canonical_attribute == "obj_id"
            and "t_ili_tid" in source_attributes
        ):
            return replace(
                identity,
                source_attribute="t_ili_tid",
            )

        raise ValueError(
            "Could not localize canonical identity for target "
            f"class {canonical_class_id!r}. Source attribute "
            f"{identity.source_attribute!r} is unavailable. "
            f"Primary canonical class: "
            f"{primary_canonical_class_id!r}. Canonical identity "
            f"attribute: {identity.canonical_attribute!r}. "
            "Available source attributes: "
            f"{tuple(sorted(source_attributes))!r}."
        )

    def _primary_identity(
        self,
        class_mapping: ClassMapping,
    ) -> CanonicalIdentityMapping | None:
        """
        Return the identity of the primary canonical class.
        """
        canonical_class_id = class_mapping.canonical_class_id

        if canonical_class_id is None:
            return None

        identity = class_mapping.identities.get(
            canonical_class_id,
        )

        if identity is not None:
            return identity

        return class_mapping.identity

    def _resolved_identities(
        self,
        *,
        defaults: MappingDefaults,
        explicit_class: ClassMapping | None,
        implicit_class: ClassMapping | None,
        attributes: Mapping[
            str,
            AttributeMapping,
        ],
        canonical_class_id: str | None,
    ) -> dict[
        str,
        CanonicalIdentityMapping,
    ]:
        """
        Resolve identities needed by effective attribute targets.
        """
        target_class_ids = {
            attribute.canonical_class_id
            for attribute in attributes.values()
            if attribute.canonical_class_id is not None
        }

        if canonical_class_id is not None:
            target_class_ids.add(
                canonical_class_id,
            )

        identities: dict[
            str,
            CanonicalIdentityMapping,
        ] = {}

        if implicit_class is not None:
            identities.update(
                {
                    target_class_id: identity
                    for (
                        target_class_id,
                        identity,
                    ) in implicit_class.identities.items()
                    if identity is not None
                }
            )

        for (
            target_class_id,
            identity,
        ) in defaults.identities.items():
            if target_class_id in target_class_ids and identity is not None:
                identities[target_class_id] = identity

        if explicit_class is not None:
            for (
                target_class_id,
                declared_identity,
            ) in explicit_class.identities.items():
                resolved_identity = declared_identity

                if resolved_identity is None:
                    resolved_identity = defaults.identities.get(
                        target_class_id,
                    )

                if resolved_identity is None and target_class_id == canonical_class_id:
                    resolved_identity = explicit_class.identity or defaults.identity

                if resolved_identity is None:
                    raise ValueError(
                        "Could not resolve identity declaration "
                        f"for canonical target class "
                        f"{target_class_id!r}."
                    )

                identities[target_class_id] = resolved_identity

        if canonical_class_id is not None and canonical_class_id not in identities:
            primary_identity = None

            if explicit_class is not None and explicit_class.identity is not None:
                primary_identity = explicit_class.identity
            elif implicit_class is not None and implicit_class.identity is not None:
                primary_identity = implicit_class.identity
            else:
                primary_identity = defaults.identity

            identities[canonical_class_id] = primary_identity

        return {
            target_class_id: identity
            for (
                target_class_id,
                identity,
            ) in identities.items()
            if target_class_id in target_class_ids
        }

    def _with_localized_identities(
        self,
        *,
        relation,
        class_mapping: ClassMapping,
    ) -> ClassMapping:
        """
        Localize canonical identities to physical source attributes.
        """
        if not class_mapping.identities:
            return class_mapping

        relation_name = self._relation_name(
            relation,
        )

        source_attributes = self._source_attribute_names(
            relation,
        )

        identities: dict[
            str,
            CanonicalIdentityMapping,
        ] = {}

        primary_canonical_class_id = class_mapping.canonical_class_id

        for (
            canonical_class_id,
            identity,
        ) in class_mapping.identities.items():
            localized_identity = self._localized_identity(
                canonical_class_id=canonical_class_id,
                primary_canonical_class_id=(primary_canonical_class_id),
                identity=identity,
                source_attributes=source_attributes,
            )

            identities[canonical_class_id] = localized_identity

            if localized_identity.source_attribute != identity.source_attribute:
                self.logger.debug(
                    "Localized identity for source relation %r and "
                    "canonical class %r: source attribute %r -> %r, "
                    "canonical attribute %r.",
                    relation_name,
                    canonical_class_id,
                    identity.source_attribute,
                    localized_identity.source_attribute,
                    localized_identity.canonical_attribute,
                )

        primary_identity = class_mapping.identity

        if primary_canonical_class_id is not None and primary_canonical_class_id in identities:
            primary_identity = identities[primary_canonical_class_id]

        return replace(
            class_mapping,
            identity=primary_identity,
            identities=identities,
        )

    def _with_physical_canonical_attributes(
        self,
        *,
        class_mapping: ClassMapping,
    ) -> ClassMapping:
        """
        Resolve semantic canonical attribute IDs to physical identifiers.
        """
        attributes: dict[
            str,
            AttributeMapping,
        ] = {}

        for (
            source_attribute,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            canonical_class_id = (
                attribute_mapping.canonical_class_id or class_mapping.canonical_class_id
            )

            canonical_attribute_id = attribute_mapping.canonical_attr_id

            if canonical_class_id is None or canonical_attribute_id is None:
                attributes[source_attribute] = attribute_mapping

                continue

            physical_attribute_id = self.canonical_model_adapter.physical_attribute_id(
                class_id=canonical_class_id,
                attribute_id=canonical_attribute_id,
            )

            if physical_attribute_id == canonical_attribute_id:
                attributes[source_attribute] = attribute_mapping

                continue

            attributes[source_attribute] = replace(
                attribute_mapping,
                canonical_attr_id=(physical_attribute_id),
            )

            self.logger.debug(
                "Resolved semantic canonical attribute "
                "%r.%r to physical attribute %r.%r for "
                "source attribute %r.",
                canonical_class_id,
                canonical_attribute_id,
                canonical_class_id,
                physical_attribute_id,
                source_attribute,
            )

        return replace(
            class_mapping,
            attributes=attributes,
        )

    # ------------------------------------------------------------------
    # Canonical-model-backed foreign-key inference
    # ------------------------------------------------------------------

    def _with_automap_foreign_keys(
        self,
        *,
        relation,
        class_mapping: ClassMapping,
    ) -> ClassMapping:
        """
        Add canonical-model-backed foreign-key mappings.
        """
        attributes = dict(
            class_mapping.attributes,
        )

        foreign_key_mappings = self._automap_foreign_key_mappings(
            relation=relation,
            class_mapping=class_mapping,
            mapped_source_attributes=frozenset(
                attributes,
            ),
        )

        if not foreign_key_mappings:
            return class_mapping

        for (
            source_attribute,
            attribute_mapping,
        ) in foreign_key_mappings.items():
            attributes.setdefault(
                source_attribute,
                attribute_mapping,
            )

        return replace(
            class_mapping,
            attributes=attributes,
        )

    def _automap_foreign_key_mappings(
        self,
        *,
        relation,
        class_mapping: ClassMapping,
        mapped_source_attributes: frozenset[str,],
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Derive missing FK mappings from quarantine and canonical ORM metadata.
        """
        target_class_id = class_mapping.canonical_class_id

        if target_class_id is None:
            return {}

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable:
            return {}

        source_class_id = self._relation_name(
            relation,
        )

        inheritance_columns = self._inheritance_local_columns(
            mapper,
        )

        candidates: list[
            tuple[
                str,
                AttributeMapping,
            ],
        ] = []

        for relationship in mapper.relationships:
            if self._is_inheritance_relationship(
                mapper=mapper,
                relationship=relationship,
                inheritance_columns=inheritance_columns,
            ):
                continue

            referenced_relation = relationship.mapper.class_

            referenced_source_class_id = self._relation_name(
                referenced_relation,
            )

            if self._is_ili2db_metadata_relation(
                referenced_source_class_id,
            ):
                continue

            if self._is_association_class(
                referenced_relation,
            ):
                continue

            referenced_class_mapping = self._resolved_referenced_class_mapping(
                relation=referenced_relation,
            )

            if referenced_class_mapping is None:
                continue

            referenced_class_id = referenced_class_mapping.canonical_class_id

            if referenced_class_id is None:
                continue

            referenced_identity = self._primary_identity(
                referenced_class_mapping,
            )

            if referenced_identity is None:
                continue

            canonical_attribute_ids = self.canonical_model_adapter.foreign_key_attributes_to_class(
                class_id=target_class_id,
                referenced_class_id=(referenced_class_id),
            )

            for local_column in relationship.local_columns:
                if local_column in inheritance_columns:
                    continue

                source_attribute = self._column_attribute_name(
                    local_column,
                )

                if source_attribute in mapped_source_attributes:
                    continue

                if self._is_ili2pg_technical_column(
                    source_attribute,
                ):
                    continue

                if not local_column.foreign_keys:
                    continue

                canonical_attribute_id = self._resolve_canonical_foreign_key_attribute(
                    source_class_id=source_class_id,
                    source_attribute=source_attribute,
                    target_class_id=target_class_id,
                    referenced_class_id=(referenced_class_id),
                    canonical_attribute_ids=(canonical_attribute_ids),
                )

                if canonical_attribute_id is None:
                    continue

                candidate_mapping = AttributeMapping(
                    canonical_class_id=target_class_id,
                    canonical_attr_id=canonical_attribute_id,
                    foreign_key=ForeignKeyMapping(
                        referenced_class_id=(referenced_class_id),
                        referenced_attribute_id=(referenced_identity.canonical_attribute),
                    ),
                    value_list=None,
                )

                candidates.append(
                    (
                        source_attribute,
                        candidate_mapping,
                    )
                )

                self.logger.debug(
                    "Inferred canonical foreign-key mapping " "%r.%r -> %r.%r, referencing %r.%r.",
                    source_class_id,
                    source_attribute,
                    target_class_id,
                    canonical_attribute_id,
                    referenced_class_id,
                    referenced_identity.canonical_attribute,
                )

        self._assert_unambiguous_foreign_key_mappings(
            source_class_id=source_class_id,
            candidates=candidates,
        )

        return dict(
            candidates,
        )

    def _resolve_canonical_foreign_key_attribute(
        self,
        *,
        source_class_id: str,
        source_attribute: str,
        target_class_id: str,
        referenced_class_id: str,
        canonical_attribute_ids: tuple[
            str,
            ...,
        ],
    ) -> str | None:
        """
        Resolve one canonical local FK attribute.
        """
        if not canonical_attribute_ids:
            self.logger.debug(
                "Ignoring source foreign key %r.%r because " "canonical class %r has no FK to %r.",
                source_class_id,
                source_attribute,
                target_class_id,
                referenced_class_id,
            )

            return None

        if (
            len(
                canonical_attribute_ids,
            )
            == 1
        ):
            return canonical_attribute_ids[0]

        raise ValueError(
            "Cannot infer the canonical role of source foreign "
            f"key {source_class_id!r}.{source_attribute!r}. "
            f"Canonical class {target_class_id!r} has several "
            f"foreign keys to {referenced_class_id!r}: "
            f"{canonical_attribute_ids!r}. Declare the relation "
            "explicitly."
        )

    def _resolved_referenced_class_mapping(
        self,
        *,
        relation,
    ) -> ClassMapping | None:
        """
        Return cached mapping information for a referenced source relation.
        """
        if relation in self._referenced_mapping_cache:
            return self._referenced_mapping_cache[relation]

        direct_projection_class = self._direct_explicit_projection_definition(
            relation=relation,
        )

        if direct_projection_class is not None:
            self._referenced_mapping_cache[relation] = direct_projection_class

            return direct_projection_class

        source_class_ids = self._source_class_ids(
            relation,
        )

        implicit_class = self._first_implicit_class_definition(
            source_class_ids,
        )

        explicit_class = self._inherited_explicit_class_definition(
            relation=relation,
        )

        if explicit_class is None and implicit_class is None:
            self._referenced_mapping_cache[relation] = None

            return None

        canonical_class_id = self._canonical_class_id(
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

        defaults = self._explicit_defaults()

        primary_identity = (
            explicit_class.identity
            if (explicit_class is not None and explicit_class.identity is not None)
            else (
                implicit_class.identity
                if (implicit_class is not None and implicit_class.identity is not None)
                else defaults.identity
            )
        )

        declared_identities: dict[
            str,
            CanonicalIdentityMapping | None,
        ] = {}

        if implicit_class is not None:
            declared_identities.update(
                implicit_class.identities,
            )

        if explicit_class is not None:
            declared_identities.update(
                explicit_class.identities,
            )

        if canonical_class_id is not None and canonical_class_id not in declared_identities:
            declared_identities[canonical_class_id] = primary_identity

        identities: dict[
            str,
            CanonicalIdentityMapping,
        ] = {}

        for (
            target_class_id,
            declared_identity,
        ) in declared_identities.items():
            resolved_identity = declared_identity

            if resolved_identity is None:
                resolved_identity = defaults.identities.get(
                    target_class_id,
                )

            if resolved_identity is None and target_class_id == canonical_class_id:
                resolved_identity = primary_identity

            if resolved_identity is None:
                raise ValueError(
                    "Could not resolve the inherited identity "
                    "declaration for referenced canonical class "
                    f"{target_class_id!r} from source relation "
                    f"{self._relation_name(relation)!r}."
                )

            identities[target_class_id] = resolved_identity

        relations: dict[
            str,
            RelationMapping,
        ] = dict(
            defaults.relations,
        )

        if explicit_class is not None:
            relations.update(
                explicit_class.relations,
            )

        localisations: dict[
            str,
            str,
        ] = {}

        if implicit_class is not None:
            localisations.update(
                implicit_class.localisations,
            )

        if explicit_class is not None:
            localisations.update(
                explicit_class.localisations,
            )

        referenced_mapping = ClassMapping(
            canonical_class_id=canonical_class_id,
            identity=primary_identity,
            identities=identities,
            attributes={},
            relations=relations,
            localisations=localisations,
            projection=None,
        )

        result = self._with_localized_identities(
            relation=relation,
            class_mapping=referenced_mapping,
        )

        self._referenced_mapping_cache[relation] = result

        return result

    def _assert_unambiguous_foreign_key_mappings(
        self,
        *,
        source_class_id: str,
        candidates: list[
            tuple[
                str,
                AttributeMapping,
            ],
        ],
    ) -> None:
        """
        Reject several source FKs targeting one canonical local attribute.
        """
        source_attributes_by_target: dict[
            tuple[
                str,
                str,
            ],
            list[str,],
        ] = {}

        for (
            source_attribute,
            attribute_mapping,
        ) in candidates:
            target_class_id = attribute_mapping.canonical_class_id

            canonical_attribute_id = attribute_mapping.canonical_attr_id

            if target_class_id is None or canonical_attribute_id is None:
                continue

            target = (
                target_class_id,
                canonical_attribute_id,
            )

            source_attributes_by_target.setdefault(
                target,
                [],
            ).append(
                source_attribute,
            )

        for (
            target,
            source_attributes,
        ) in source_attributes_by_target.items():
            unique_source_attributes = tuple(
                sorted(
                    set(
                        source_attributes,
                    )
                )
            )

            if (
                len(
                    unique_source_attributes,
                )
                <= 1
            ):
                continue

            (
                target_class_id,
                canonical_attribute_id,
            ) = target

            raise ValueError(
                "Several source foreign keys resolve implicitly "
                "to the same canonical relation "
                f"{target_class_id!r}."
                f"{canonical_attribute_id!r} for source class "
                f"{source_class_id!r}: "
                f"{unique_source_attributes!r}. "
                "Declare these relations explicitly."
            )

    # ------------------------------------------------------------------
    # Joined-inheritance detection
    # ------------------------------------------------------------------

    def _inheritance_local_columns(
        self,
        mapper,
    ) -> frozenset:
        """
        Return child-side columns participating in joined inheritance.
        """
        if mapper.inherits is None or mapper.inherit_condition is None:
            return frozenset()

        local_table = mapper.local_table

        return frozenset(
            element
            for element in visitors.iterate(
                mapper.inherit_condition,
            )
            if getattr(
                element,
                "table",
                None,
            )
            is local_table
        )

    def _is_inheritance_relationship(
        self,
        *,
        mapper,
        relationship,
        inheritance_columns: frozenset,
    ) -> bool:
        """
        Return whether one relationship represents ORM inheritance.
        """
        parent_mapper = mapper.inherits

        if parent_mapper is None:
            return False

        if relationship.mapper is not parent_mapper:
            return False

        return bool(
            set(
                relationship.local_columns,
            )
            & set(
                inheritance_columns,
            )
        )

    # ------------------------------------------------------------------
    # Final mapping validation
    # ------------------------------------------------------------------

    def _validate_resolved_class_mapping(
        self,
        *,
        relation,
        source_class_id: str,
        class_mapping: ClassMapping,
    ) -> None:
        """
        Validate one executable relation-specific class mapping.
        """
        if class_mapping.projection is not None:
            return

        source_attributes = self._source_attribute_names(
            relation,
        )

        missing_source_attributes = (
            set(
                class_mapping.attributes,
            )
            - source_attributes
        )

        if missing_source_attributes:
            raise ValueError(
                "Resolved mapping for source class "
                f"{source_class_id!r} refers to unavailable "
                "source attributes: "
                f"{tuple(sorted(missing_source_attributes))!r}."
            )

        canonical_metadata = self.canonical_model_adapter.canonical_model()

        canonical_class_id = class_mapping.canonical_class_id

        if canonical_class_id is not None and canonical_class_id not in canonical_metadata.classes:
            raise ValueError(
                "Resolved mapping targets unknown canonical "
                f"class {canonical_class_id!r} for source "
                f"class {source_class_id!r}."
            )

        for (
            source_attribute,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            target_class_id = attribute_mapping.canonical_class_id or canonical_class_id

            if target_class_id is None:
                raise ValueError(
                    "Resolved mapping has no canonical target "
                    f"class for {source_class_id!r}."
                    f"{source_attribute!r}."
                )

            if target_class_id not in canonical_metadata.classes:
                raise ValueError(
                    "Resolved mapping targets unknown canonical "
                    f"class {target_class_id!r}, required by "
                    f"{source_class_id!r}."
                    f"{source_attribute!r}."
                )

            canonical_attribute_id = attribute_mapping.canonical_attr_id

            if (
                canonical_attribute_id is not None
                and (
                    target_class_id,
                    canonical_attribute_id,
                )
                not in canonical_metadata.attributes
            ):
                raise ValueError(
                    "Resolved mapping targets unknown canonical "
                    f"attribute {target_class_id!r}."
                    f"{canonical_attribute_id!r}, required by "
                    f"{source_class_id!r}."
                    f"{source_attribute!r}."
                )

            if target_class_id not in class_mapping.identities:
                raise ValueError(
                    "Resolved mapping has no canonical identity "
                    f"for target class {target_class_id!r}, "
                    f"required by {source_class_id!r}."
                    f"{source_attribute!r}."
                )

    # ------------------------------------------------------------------
    # Relation and ORM normalization
    # ------------------------------------------------------------------

    def _relation_class(
        self,
        relation_entry,
    ):
        """
        Return the mapped ORM class for one quarantine-class entry.
        """
        if isinstance(
            relation_entry,
            str,
        ):
            try:
                return getattr(
                    self.quarantine_classes,
                    relation_entry,
                )
            except AttributeError:
                try:
                    return self.quarantine_classes[relation_entry]
                except (
                    KeyError,
                    TypeError,
                ) as exception:
                    raise KeyError(
                        "No quarantine ORM class exists for " f"relation {relation_entry!r}."
                    ) from exception

        if (
            getattr(
                relation_entry,
                "__table__",
                None,
            )
            is not None
        ):
            return relation_entry

        raise TypeError(
            "Expected a quarantine relation name or mapped ORM " f"class, got {relation_entry!r}."
        )

    def _relation_name(
        self,
        relation_class,
    ) -> str:
        """
        Return the physical table name of one mapped ORM class.
        """
        table = getattr(
            relation_class,
            "__table__",
            None,
        )

        if table is not None:
            table_name = getattr(
                table,
                "name",
                None,
            )

            if (
                isinstance(
                    table_name,
                    str,
                )
                and table_name
            ):
                return table_name

        class_name = getattr(
            relation_class,
            "__name__",
            None,
        )

        if (
            isinstance(
                class_name,
                str,
            )
            and class_name
        ):
            return class_name

        raise TypeError("Could not determine a relation name for " f"{relation_class!r}.")

    def _declared_class_name(
        self,
        relation_class,
    ) -> str | None:
        """
        Return the declared Python ORM class name.
        """
        class_name = getattr(
            relation_class,
            "__name__",
            None,
        )

        if (
            isinstance(
                class_name,
                str,
            )
            and class_name
        ):
            return class_name

        return None

    def _ag96_mapping_id(
        self,
        *relation_names: str | None,
    ) -> str | None:
        """
        Resolve a stable AG96 mapping ID from physical ORM identifiers.

        Matching is case-insensitive only at this boundary. The exact stable
        mapping identifier is preserved after resolution.
        """
        for relation_name in relation_names:
            if not isinstance(
                relation_name,
                str,
            ):
                continue

            mapping_id = _AG96_MAPPING_ID_BY_RELATION_NAME.get(
                relation_name.casefold(),
            )

            if mapping_id is not None:
                return mapping_id

        return None

    def _source_class_ids(
        self,
        relation,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return mapping candidates for one ORM relation.

        Physical table and declared ORM identifiers remain available for
        implicit mapping lookup. A stable AG96 mapping identifier is appended
        when the relation has a configured binding.

        Export-facing INTERLIS names are deliberately not resolved here.
        """
        if isinstance(
            relation,
            str,
        ):
            physical_name = relation
            declared_name = None
        else:
            physical_name = self._relation_name(
                relation,
            )

            declared_name = self._declared_class_name(
                relation,
            )

        candidates: list[str,] = []

        def append_candidate(
            candidate: str | None,
        ) -> None:
            if (
                isinstance(
                    candidate,
                    str,
                )
                and candidate
                and candidate not in candidates
            ):
                candidates.append(
                    candidate,
                )

        append_candidate(
            physical_name,
        )

        append_candidate(
            declared_name,
        )

        append_candidate(
            self._ag96_mapping_id(
                physical_name,
                declared_name,
            )
        )

        return tuple(
            candidates,
        )

    def _column_attribute_name(
        self,
        column,
    ) -> str:
        """
        Return the source attribute identifier for a SQLAlchemy column.
        """
        return str(
            getattr(
                column,
                "key",
                None,
            )
            or column.name
        )

    # ------------------------------------------------------------------
    # Relation and column classification
    # ------------------------------------------------------------------

    def _is_ili2db_metadata_relation(
        self,
        relation_name: str,
    ) -> bool:
        """
        Return whether a relation contains internal ili2db metadata.
        """
        return relation_name.casefold().startswith("t_ili2db_")

    def _is_association_class(
        self,
        relation_class,
    ) -> bool:
        """
        Return whether an ORM class represents an association table.
        """
        table = getattr(
            relation_class,
            "__table__",
            None,
        )

        if table is None:
            return False

        return (
            str(
                table.name,
            )
            .casefold()
            .endswith("assoc")
        )

    def _is_ili2pg_technical_column(
        self,
        source_attribute: str,
    ) -> bool:
        """
        Return whether a source column is ili2pg infrastructure.

        ``t_ili_tid`` is deliberately excluded because it represents the
        imported INTERLIS object identity.
        """
        return source_attribute.casefold() in {
            "t_id",
            "t_basket",
            "t_seq",
        }

    # ------------------------------------------------------------------
    # Context uniqueness
    # ------------------------------------------------------------------

    def _assert_unique_source_class_ids(
        self,
        *,
        contexts: list[RelationContext,],
    ) -> None:
        """
        Require one concrete ORM relation per stable source mapping ID.
        """
        relation_by_source_class_id: dict[
            str,
            Any,
        ] = {}

        for relation_context in contexts:
            source_class_id = relation_context.source_class_id

            previous_relation = relation_by_source_class_id.get(
                source_class_id,
            )

            if previous_relation is not None:
                raise ValueError(
                    "Several quarantine ORM relations resolve to "
                    f"source class {source_class_id!r}: "
                    f"{self._relation_name(previous_relation)!r} "
                    "and "
                    f"{self._relation_name(relation_context.relation)!r}."
                )

            relation_by_source_class_id[source_class_id] = relation_context.relation
