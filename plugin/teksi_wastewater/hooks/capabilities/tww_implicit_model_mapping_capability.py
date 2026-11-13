from __future__ import annotations

from dataclasses import dataclass, field, replace
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.exc import NoInspectionAvailable
from teksi_hooks.capabilities.mapping import (
    ImplicitModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalIdentityMapping,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ForeignKeyMapping,
    ModelMapping,
    RelationMapping,
    ValueMapping,
)
from teksi_hooks.resolver.model_mapping_resolver import (
    ImplicitModelMappingResolver,
)

from ...interlis import config
from ...interlis.model_config import (
    TwwInterlisModelSelection,
)


@dataclass(slots=True)
class TwwImplicitModelMappingCapability(
    ImplicitModelMappingCapability,
):
    """
    Provide resolved implicit source-to-canonical mappings for one concrete
    TEKSI Wastewater INTERLIS model.

    Dictionary metadata supplies ordinary class, attribute and value
    mappings. The curated INTERLIS SQLAlchemy model supplements missing
    foreign-key attribute and relation mappings.

    Ambiguous relationship roles are not guessed. Explicit model-driven
    mappings supply those roles and take precedence through
    EffectiveModelMappingCapability.
    """

    ili_model: str

    dictionary: Any

    import_schema: str = config.IMPORT_SCHEMA

    source_identity_attribute: str = "t_ili_tid"

    canonical_identity_attribute: str = "obj_id"

    _delegate: ModelMappingCapability = field(
        init=False,
        repr=False,
    )

    _import_model: Any = field(
        init=False,
        repr=False,
    )

    _automap_classes: Any = field(
        init=False,
        repr=False,
    )

    def __post_init__(
        self,
    ) -> None:
        selection = TwwInterlisModelSelection(
            ili_model=self.ili_model,
        )

        self._import_model = selection.model(
            schema=self.import_schema,
        )

        self._automap_classes = self._import_model.classes()

        base_mapping = ImplicitModelMappingResolver(
            dictionary=self.dictionary,
            source_identity_attribute=(self.source_identity_attribute),
            canonical_identity_attribute=(self.canonical_identity_attribute),
        ).resolve()

        resolved_mapping = self._with_orm_metadata(
            mapping=base_mapping,
        )

        self._delegate = ModelMappingCapability(
            mapping=resolved_mapping,
        )

    @property
    def import_model(
        self,
    ) -> Any:
        """
        Return the selected curated INTERLIS ORM model.

        TwwRelationContextProvider may reuse this model to avoid selecting
        the source model independently.
        """

        return self._import_model

    @property
    def automap_classes(
        self,
    ) -> Any:
        """
        Return the prepared SQLAlchemy class collection.
        """

        return self._automap_classes

    @property
    def is_ssot(
        self,
    ) -> bool:
        return self._delegate.is_ssot

    def class_definition(
        self,
        class_id: str,
    ) -> ClassMapping:
        return self._delegate.class_definition(
            class_id,
        )

    def try_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        return self._delegate.try_class_definition(
            class_id,
        )

    def attribute_definition(
        self,
        class_id: str,
        attribute_name: str,
    ) -> AttributeMapping:
        return self._delegate.attribute_definition(
            class_id,
            attribute_name,
        )

    def try_attribute_definition(
        self,
        class_id: str,
        attribute_name: str,
    ) -> AttributeMapping | None:
        return self._delegate.try_attribute_definition(
            class_id,
            attribute_name,
        )

    def value_mapping(
        self,
        class_id: str,
        attribute_name: str,
        value: str,
    ) -> ValueMapping:
        return self._delegate.value_mapping(
            class_id,
            attribute_name,
            value,
        )

    def try_value_mapping(
        self,
        class_id: str,
        attribute_name: str,
        value: str,
    ) -> ValueMapping | None:
        return self._delegate.try_value_mapping(
            class_id,
            attribute_name,
            value,
        )

    def identity_definition(
        self,
        class_id: str,
        canonical_class_id: str,
    ) -> CanonicalIdentityMapping:
        return self._delegate.identity_definition(
            class_id,
            canonical_class_id,
        )

    def try_identity_definition(
        self,
        class_id: str,
        canonical_class_id: str,
    ) -> CanonicalIdentityMapping | None:
        return self._delegate.try_identity_definition(
            class_id,
            canonical_class_id,
        )

    def relation_definition(
        self,
        class_id: str,
        relation_id: str,
    ) -> RelationMapping:
        return self._delegate.relation_definition(
            class_id,
            relation_id,
        )

    def try_relation_definition(
        self,
        class_id: str,
        relation_id: str,
    ) -> RelationMapping | None:
        return self._delegate.try_relation_definition(
            class_id,
            relation_id,
        )

    def _with_orm_metadata(
        self,
        *,
        mapping: ModelMapping,
    ) -> ModelMapping:
        """
        Supplement dictionary-backed classes using curated ORM metadata.
        """

        classes = dict(
            mapping.classes,
        )

        for source_class_id, class_mapping in tuple(
            classes.items(),
        ):
            relation = self._try_automap_class(
                source_class_id,
            )

            if relation is None:
                continue

            classes[source_class_id] = self._with_orm_foreign_keys(
                source_class_id=source_class_id,
                relation=relation,
                class_mapping=class_mapping,
                mapping=mapping,
            )

        return replace(
            mapping,
            classes=classes,
        )

    def _with_orm_foreign_keys(
        self,
        *,
        source_class_id: str,
        relation: Any,
        class_mapping: ClassMapping,
        mapping: ModelMapping,
    ) -> ClassMapping:
        """
        Add unambiguous ORM-derived FK attributes and relations.

        Dictionary mappings remain authoritative. ORM-derived mappings only
        fill missing source attributes and canonical relations.
        """

        canonical_class_id = class_mapping.canonical_class_id

        if canonical_class_id is None:
            return class_mapping

        try:
            mapper = inspect(
                relation,
            )
        except NoInspectionAvailable:
            return class_mapping

        attributes = dict(
            class_mapping.attributes,
        )
        relations = dict(
            class_mapping.relations,
        )

        for relationship in mapper.relationships:
            referenced_relation = relationship.mapper.class_
            referenced_source_class_id = referenced_relation.__name__

            referenced_mapping = mapping.classes.get(
                referenced_source_class_id,
            )

            if referenced_mapping is None:
                continue

            referenced_class_id = referenced_mapping.canonical_class_id

            if referenced_class_id is None:
                continue

            referenced_identity = referenced_mapping.identities.get(
                referenced_class_id,
            )

            if referenced_identity is None:
                continue

            local_columns = tuple(
                column for column in relationship.local_columns if column.foreign_keys
            )

            if len(local_columns) != 1:
                continue

            local_column = local_columns[0]
            source_attribute = self._column_attribute_name(
                local_column,
            )

            canonical_attribute_id = self._canonical_fk_attribute_id(
                source_attribute=source_attribute,
                class_mapping=class_mapping,
            )

            if canonical_attribute_id is None:
                continue

            attributes.setdefault(
                source_attribute,
                AttributeMapping(
                    canonical_class_id=(canonical_class_id),
                    canonical_attr_id=(canonical_attribute_id),
                    foreign_key=ForeignKeyMapping(
                        referenced_class_id=(referenced_class_id),
                        referenced_attribute_id=(referenced_identity.canonical_attribute),
                    ),
                    value_list=None,
                ),
            )

            relations.setdefault(
                canonical_attribute_id,
                RelationMapping(
                    referenced_class_id=(referenced_class_id),
                    referenced_attribute_id=(referenced_identity.canonical_attribute),
                    localisations={},
                ),
            )

        return replace(
            class_mapping,
            attributes=attributes,
            relations=relations,
        )

    def _canonical_fk_attribute_id(
        self,
        *,
        source_attribute: str,
        class_mapping: ClassMapping,
    ) -> str | None:
        """
        Return a canonical FK attribute identifier when it is unambiguous.

        Existing dictionary mappings are used first. Physical names beginning
        with `fk_` may be used directly. Other names require an explicit
        model-driven relation mapping and are intentionally not guessed.
        """

        existing = class_mapping.attributes.get(
            source_attribute,
        )

        if existing is not None and existing.canonical_attr_id is not None:
            return existing.canonical_attr_id

        if source_attribute.startswith(
            "fk_",
        ):
            return source_attribute

        return None

    def _try_automap_class(
        self,
        source_class_id: str,
    ) -> Any | None:
        """
        Return one prepared ORM class when available.
        """

        return getattr(
            self._automap_classes,
            source_class_id,
            None,
        )

    def _column_attribute_name(
        self,
        column: Any,
    ) -> str:
        """
        Return the SQLAlchemy source attribute identifier for a column.
        """

        return str(
            getattr(
                column,
                "key",
                None,
            )
            or column.name
        )
