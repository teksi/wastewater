from __future__ import annotations

from collections.abc import Mapping
from dataclasses import replace
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.exc import NoInspectionAvailable

from ...interlis import config

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



class TwwRelationContextProvider(
    RelationContextProvider,
):
    """
    Build relation contexts for one concrete TEKSI Wastewater source model.

    The provider preserves the curated INTERLIS SQLAlchemy model definitions
    and enriches mapping declarations with source-relation-specific
    information.

    Mapping-document inheritance must already be resolved by
    ModelMappingInheritanceResolver before this provider is constructed.

    Resolution order for an attribute-backed source class:

    1. implicit class mapping;
    2. applicable explicit model defaults;
    3. explicit localized relation declarations;
    4. explicit class attributes;
    5. automap-derived foreign-key mappings for remaining source attributes.

    Explicit class-level function mappings are authoritative and bypass all
    declarative defaults, implicit attributes, localized relations and
    automap-derived foreign-key mappings.
    """

    def __init__(
        self,
        *,
        quarantine_classes: Mapping[
            str,
            Any,
        ],
        model_mapping: EffectiveModelMappingCapability,
    ) -> None:
        self.quarantine_classes = quarantine_classes
        self.model_mapping = model_mapping


    def relation_contexts(
        self,
    ) -> tuple[
        RelationContext,
        ...,
    ]:
        """
        Return resolved relation contexts for the configured quarantine classes.
        """

        contexts: list[
            RelationContext
        ] = []

        for relation in self.quarantine_classes.values():
            contexts.append(
                RelationContext(
                    relation=relation,
                    class_mapping=(
                        self._class_mapping_for_relation(
                            relation,
                        )
                    ),
                )
            )

        return tuple(
            contexts,
        )

    def _class_mapping_for_relation(
        self,
        relation,
    ) -> ClassMapping:
        """
        Return the executable class mapping for one source ORM relation.
        """

        source_class_id = relation.__name__

        explicit_class = (
            self._try_explicit_class_definition(
                source_class_id,
            )
        )

        if (
            explicit_class is not None
            and explicit_class.function is not None
        ):
            return explicit_class

        implicit_class = (
            self._try_implicit_class_definition(
                source_class_id,
            )
        )

        if (
            explicit_class is None
            and implicit_class is None
        ):
            raise KeyError(
                "No explicit or implicit mapping exists for "
                f"source class {source_class_id!r}."
            )

        resolved = self._resolve_attribute_backed_class(
            relation=relation,
            source_class_id=source_class_id,
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

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
        Resolve one attribute-backed class using declarations and ORM metadata.
        """

        source_attributes = self._source_attribute_names(
            relation,
        )

        defaults = self._explicit_defaults()

        canonical_class_id = self._canonical_class_id(
            explicit_class=explicit_class,
            implicit_class=implicit_class,
        )

        applicable_default_attributes = (
            self._applicable_default_attributes(
                source_attributes=source_attributes,
                defaults=defaults,
            )
        )

        relations = self._resolved_relations(
            defaults=defaults,
            explicit_class=explicit_class,
        )

        relation_attributes = (
            self._localized_relation_attribute_mappings(
                canonical_class_id=canonical_class_id,
                source_attributes=source_attributes,
                relations=relations,
            )
        )

        attributes: dict[
            str,
            AttributeMapping,
        ] = {}

        if implicit_class is not None:
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

        return ClassMapping(
            canonical_class_id=canonical_class_id,
            identities=identities,
            attributes=attributes,
            relations=relations,
            function=None,
        )

    def _try_explicit_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        """
        Return the explicit class mapping if one exists.
        """

        capability = getattr(
            self.model_mapping,
            "explicit_mapping",
            None,
        )

        if capability is None:
            return None

        return capability.try_class_definition(
            class_id,
        )

    def _try_implicit_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        """
        Return the implicit class mapping if one exists.
        """

        capability = getattr(
            self.model_mapping,
            "implicit_mapping",
            None,
        )

        if capability is None:
            return None

        return capability.try_class_definition(
            class_id,
        )

    def _explicit_defaults(
        self,
    ) -> MappingDefaults:
        """
        Return defaults from the inheritance-resolved explicit mapping.
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

        The explicit mapping takes precedence when it declares a primary
        canonical class. Otherwise the implicit dictionary-backed mapping
        supplies the primary canonical class.
        """

        if (
            explicit_class is not None
            and explicit_class.canonical_class_id is not None
        ):
            return explicit_class.canonical_class_id

        if implicit_class is not None:
            return implicit_class.canonical_class_id

        return None

    def _source_attribute_names(
        self,
        relation,
    ) -> frozenset[
        str
    ]:
        """
        Return effective SQLAlchemy source attribute identifiers.

        Mapper column attributes are used so manually declared inheritance
        and inherited SQLAlchemy attributes remain visible.
        """

        attribute_names: set[
            str
        ] = set()

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

        return frozenset(
            attribute_names,
        )

    def _applicable_default_attributes(
        self,
        *,
        source_attributes: frozenset[str],
        defaults: MappingDefaults,
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Return model-default attributes available on the source class.

        A default mapping applies only when the corresponding source
        attribute exists in the SQLAlchemy source class.
        """

        return {
            source_attribute: mapping
            for source_attribute, mapping
            in defaults.attributes.items()
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
        Merge default and class-specific explicit relation declarations.
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
        canonical_class_id: str | None,
        source_attributes: frozenset[str],
        relations: Mapping[
            str,
            RelationMapping,
        ],
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Resolve canonical relation declarations to source ORM attributes.

        The relation mapping key is the canonical local FK attribute.
        Localisation values are exact source-model attribute identifiers.
        """

        if canonical_class_id is None:
            return {}

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

            matches = candidates & source_attributes

            if not matches:
                continue

            if len(
                matches,
            ) != 1:
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
                    referenced_class_id=(
                        relation_mapping.referenced_class_id
                    ),
                    referenced_attribute_id=(
                        relation_mapping.referenced_attribute_id
                    ),
                ),
                value_list=None,
            )

        return attributes

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

        Model-default identities are retained only when an effective
        attribute targets the corresponding canonical class.
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
                implicit_class.identities,
            )

        for (
            target_class_id,
            identity,
        ) in defaults.identities.items():
            if target_class_id in target_class_ids:
                identities[
                    target_class_id
                ] = identity

        if explicit_class is not None:
            identities.update(
                explicit_class.identities,
            )

        if (
            canonical_class_id is not None
            and canonical_class_id not in identities
        ):
            identities[
                canonical_class_id
            ] = defaults.identity

        return {
            target_class_id: identity
            for target_class_id, identity
            in identities.items()
            if target_class_id in target_class_ids
        }

    def _with_automap_foreign_keys(
        self,
        *,
        relation,
        class_mapping: ClassMapping,
    ) -> ClassMapping:
        """
        Enrich the mapping with automap-derived FK AttributeMappings.

        Existing mappings are preserved. Automap-derived mappings are only
        added for source attributes not already present.
        """

        foreign_key_mappings = (
            self._automap_foreign_key_mappings(
                relation=relation,
                class_mapping=class_mapping,
            )
        )

        if not foreign_key_mappings:
            return class_mapping

        attributes = dict(
            class_mapping.attributes,
        )

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
    ) -> dict[
        str,
        AttributeMapping,
    ]:
        """
        Derive missing source FK mappings from SQLAlchemy relationships.
        """

        if class_mapping.canonical_class_id is None:
            return {}

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable:
            return {}

        mappings: dict[
            str,
            AttributeMapping,
        ] = {}

        for relationship in mapper.relationships:
            referenced_relation = (
                relationship.mapper.class_
            )

            referenced_source_class_id = (
                referenced_relation.__name__
            )

            referenced_class_mapping = (
                self._resolved_referenced_class_mapping(
                    source_class_id=(
                        referenced_source_class_id
                    ),
                )
            )

            if referenced_class_mapping is None:
                continue

            referenced_class_id = (
                referenced_class_mapping
                .canonical_class_id
            )

            if referenced_class_id is None:
                continue

            referenced_identity = (
                self._primary_identity(
                    referenced_class_mapping,
                )
            )

            if referenced_identity is None:
                continue

            for local_column in (
                relationship.local_columns
            ):
                if not local_column.foreign_keys:
                    continue

                source_attribute = (
                    self._column_attribute_name(
                        local_column,
                    )
                )

                mappings[source_attribute] = (
                    AttributeMapping(
                        canonical_class_id=(
                            class_mapping
                            .canonical_class_id
                        ),
                        canonical_attr_id=(
                            source_attribute
                        ),
                        foreign_key=ForeignKeyMapping(
                            referenced_class_id=(
                                referenced_class_id
                            ),
                            referenced_attribute_id=(
                                referenced_identity
                                .canonical_attribute
                            ),
                        ),
                        value_list=None,
                    )
                )

        return mappings

    def _resolved_referenced_class_mapping(
        self,
        *,
        source_class_id: str,
    ) -> ClassMapping | None:
        """
        Return enough mapping information for a referenced source class.

        This deliberately avoids recursively applying automap enrichment.
        """

        explicit_class = (
            self._try_explicit_class_definition(
                source_class_id,
            )
        )

        if (
            explicit_class is not None
            and explicit_class.function is not None
        ):
            return explicit_class

        implicit_class = (
            self._try_implicit_class_definition(
                source_class_id,
            )
        )

        if (
            explicit_class is None
            and implicit_class is None
        ):
            return None

        canonical_class_id = (
            self._canonical_class_id(
                explicit_class=explicit_class,
                implicit_class=implicit_class,
            )
        )

        identities: dict[
            str,
            CanonicalIdentityMapping,
        ] = {}

        if implicit_class is not None:
            identities.update(
                implicit_class.identities,
            )

        if explicit_class is not None:
            identities.update(
                explicit_class.identities,
            )

        if (
            canonical_class_id is not None
            and canonical_class_id not in identities
        ):
            identities[
                canonical_class_id
            ] = self._explicit_defaults().identity

        return ClassMapping(
            canonical_class_id=canonical_class_id,
            identities=identities,
            attributes={},
            relations={},
            function=(
                explicit_class.function
                if explicit_class is not None
                else None
            ),
        )

    def _primary_identity(
        self,
        class_mapping: ClassMapping,
    ) -> CanonicalIdentityMapping | None:
        """
        Return the identity of the primary canonical class.
        """

        canonical_class_id = (
            class_mapping.canonical_class_id
        )

        if canonical_class_id is None:
            return None

        return class_mapping.identities.get(
            canonical_class_id,
        )

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

        if class_mapping.function is not None:
            return

        source_attributes = (
            self._source_attribute_names(
                relation,
            )
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
                f"{source_class_id!r} refers to source "
                "attributes unavailable from its SQLAlchemy "
                f"model: "
                f"{tuple(sorted(missing_source_attributes))!r}."
            )

        for (
            source_attribute,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            target_class_id = (
                attribute_mapping.canonical_class_id
                or class_mapping.canonical_class_id
            )

            if target_class_id is None:
                raise ValueError(
                    "Resolved mapping has no canonical target "
                    f"class for {source_class_id!r}."
                    f"{source_attribute!r}."
                )

            if (
                target_class_id
                not in class_mapping.identities
            ):
                raise ValueError(
                    "Resolved mapping has no canonical identity "
                    f"for target class {target_class_id!r}, "
                    f"required by {source_class_id!r}."
                    f"{source_attribute!r}."
                )

    def _column_attribute_name(
        self,
        column,
    ) -> str:
        """
        Return the source attribute identifier for a SQLAlchemy column.
        """

        return (
            getattr(
                column,
                "key",
                None,
            )
            or column.name
        )