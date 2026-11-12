from __future__ import annotations

from types import SimpleNamespace
from typing import Any
from unittest.mock import Mock

import pytest
from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalAttributeMetadata,
    CanonicalClassMetadata,
    CanonicalIdentityMapping,
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    EnforceExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ModelMapping,
    RelationContext,
    ValueMapping,
)
from teksi_wastewater.hooks.projectors.tww_quarantine_effect_projector import (
    TwwQuarantineEffectProjector,
)


class GepKnoten:
    pass


class OtherRelation:
    pass


class FakeRelationContextProvider:
    def __init__(
        self,
        *contexts: RelationContext,
    ) -> None:
        self.contexts = contexts

    def relation_contexts(
        self,
    ) -> tuple[RelationContext, ...]:
        return self.contexts


def _identity_mapping(
    *,
    source_attribute: str = "t_ili_tid",
    canonical_attribute: str = "obj_id",
) -> CanonicalIdentityMapping:
    return CanonicalIdentityMapping(
        source_attribute=source_attribute,
        canonical_attribute=canonical_attribute,
    )


def _canonical_metadata() -> CanonicalModelMetadata:
    return CanonicalModelMetadata(
        classes={
            "wastewater_structure": CanonicalClassMetadata(
                source_id=1,
                identifier="wastewater_structure",
            ),
            "wastewater_node": CanonicalClassMetadata(
                source_id=2,
                identifier="wastewater_node",
            ),
        },
        attributes={
            (
                "wastewater_structure",
                "status",
            ): CanonicalAttributeMetadata(
                source_id=10,
                identifier="status",
            ),
            (
                "wastewater_structure",
                "function",
            ): CanonicalAttributeMetadata(
                source_id=11,
                identifier="function",
            ),
            (
                "wastewater_node",
                "function",
            ): CanonicalAttributeMetadata(
                source_id=20,
                identifier="function",
            ),
        },
        values={},
    )


def _mapping(
    *,
    classes: dict[str, ClassMapping],
    is_ssot: bool = True,
) -> EffectiveModelMappingCapability:
    return EffectiveModelMappingCapability(
        explicit_mapping=ModelMappingCapability(
            mapping=ModelMapping(
                classes=classes,
                is_ssot=is_ssot,
            ),
        ),
        implicit_mapping=None,
    )


def _projector(
    *,
    model_mapping: EffectiveModelMappingCapability,
    contexts: tuple[RelationContext, ...] = (),
) -> TwwQuarantineEffectProjector:
    return TwwQuarantineEffectProjector(
        model_mapping=model_mapping,
        session_context=Mock(),
        relation_context_provider=FakeRelationContextProvider(
            *contexts,
        ),
        canonical_view_effect_projector=Mock(),
        canonical_lookup=Mock(),
        canonical_metadata=_canonical_metadata(),
    )


def _attribute_mapping() -> ClassMapping:
    return ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={
            "statusag": AttributeMapping(
                canonical_class_id="wastewater_structure",
                canonical_attr_id="status",
            ),
        },
    )


def test_attribute_effects_require_target_before_update() -> None:
    class_mapping = _attribute_mapping()
    projector = _projector(
        model_mapping=_mapping(
            classes={"GepKnoten": class_mapping},
        )
    )

    effects = projector._attribute_effects(
        cursor=Mock(),
        relation=GepKnoten,
        row={
            "t_ili_tid": "ch000000ws000001",
            "statusag": "active",
        },
        source_class_id="GepKnoten",
        class_mapping=class_mapping,
        schema="import_schema",
    )

    assert len(effects) == 2
    assert isinstance(effects[0], EnforceExistsEffect)
    assert isinstance(effects[1], UpdateAttributeEffect)
    assert effects[0].identity == CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={"obj_id": "ch000000ws000001"},
    )
    assert effects[1].identity == effects[0].identity
    assert effects[1].attribute_id == "status"
    assert effects[1].value == "active"


def test_attribute_effects_add_one_exists_effect_per_target() -> None:
    class_mapping = ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={
            "statusag": AttributeMapping(
                canonical_class_id="wastewater_structure",
                canonical_attr_id="status",
            ),
            "funktionag": AttributeMapping(
                canonical_class_id="wastewater_structure",
                canonical_attr_id="function",
            ),
        },
    )
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    effects = projector._attribute_effects(
        cursor=Mock(),
        relation=GepKnoten,
        row={
            "t_ili_tid": "ch000000ws000002",
            "statusag": "active",
            "funktionag": "manhole",
        },
        source_class_id="GepKnoten",
        class_mapping=class_mapping,
        schema="import_schema",
    )

    assert sum(isinstance(effect, EnforceExistsEffect) for effect in effects) == 1
    assert sum(isinstance(effect, UpdateAttributeEffect) for effect in effects) == 2


def test_attribute_effects_apply_static_value_mapping() -> None:
    class_mapping = ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={
            "funktionag": AttributeMapping(
                canonical_class_id="wastewater_structure",
                canonical_attr_id="function",
                values={
                    "Schacht": ValueMapping(
                        canonical_value_id=1234,
                        value="manhole",
                    ),
                },
            ),
        },
    )
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    effects = projector._attribute_effects(
        cursor=Mock(),
        relation=GepKnoten,
        row={
            "t_ili_tid": "ch000000ws000003",
            "funktionag": "Schacht",
        },
        source_class_id="GepKnoten",
        class_mapping=class_mapping,
        schema="import_schema",
    )

    update = next(
        effect for effect in effects if isinstance(effect, UpdateAttributeEffect)
    )
    assert update.value == 1234


def test_attribute_effects_skip_null_source_values() -> None:
    class_mapping = _attribute_mapping()
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    effects = projector._attribute_effects(
        cursor=Mock(),
        relation=GepKnoten,
        row={
            "t_ili_tid": "ch000000ws000004",
            "statusag": None,
        },
        source_class_id="GepKnoten",
        class_mapping=class_mapping,
        schema="import_schema",
    )

    assert effects == ()


def test_attribute_effects_project_cross_class_target() -> None:
    class_mapping = ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
            "wastewater_node": _identity_mapping(),
        },
        attributes={
            "funktionag": AttributeMapping(
                canonical_class_id="wastewater_node",
                canonical_attr_id="function",
            ),
        },
    )
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    effects = projector._attribute_effects(
        cursor=Mock(),
        relation=GepKnoten,
        row={
            "t_ili_tid": "ch000000ws000005",
            "funktionag": "value",
        },
        source_class_id="GepKnoten",
        class_mapping=class_mapping,
        schema="import_schema",
    )

    update = next(
        effect for effect in effects if isinstance(effect, UpdateAttributeEffect)
    )
    assert update.identity == CanonicalObjectIdentity(
        class_id="wastewater_node",
        attributes={"obj_id": "ch000000ws000005"},
    )


def test_attribute_target_without_identity_is_rejected() -> None:
    class_mapping = ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={
            "funktionag": AttributeMapping(
                canonical_class_id="wastewater_node",
                canonical_attr_id="function",
            ),
        },
    )
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    with pytest.raises(
        ValueError,
        match="No resolved identity mapping exists",
    ):
        projector._attribute_effects(
            cursor=Mock(),
            relation=GepKnoten,
            row={
                "t_ili_tid": "ch000000ws000006",
                "funktionag": "value",
            },
            source_class_id="GepKnoten",
            class_mapping=class_mapping,
            schema="import_schema",
        )


def test_unknown_canonical_attribute_is_rejected() -> None:
    class_mapping = ClassMapping(
        canonical_class_id="wastewater_structure",
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={
            "unknownag": AttributeMapping(
                canonical_class_id="wastewater_structure",
                canonical_attr_id="unknown_attribute",
            ),
        },
    )
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    with pytest.raises(KeyError, match="Unknown canonical attribute"):
        projector._attribute_effects(
            cursor=Mock(),
            relation=GepKnoten,
            row={
                "t_ili_tid": "ch000000ws000007",
                "unknownag": "value",
            },
            source_class_id="GepKnoten",
            class_mapping=class_mapping,
            schema="import_schema",
        )


def test_identity_rejects_missing_source_attribute() -> None:
    class_mapping = _attribute_mapping()
    projector = _projector(
        model_mapping=_mapping(classes={"GepKnoten": class_mapping})
    )

    with pytest.raises(ValueError, match="Source identity attribute"):
        projector._identity(
            row={},
            class_mapping=class_mapping,
        )


def test_source_object_id_supports_mapping_and_orm_rows() -> None:
    projector = _projector(model_mapping=_mapping(classes={}))
    assert projector._source_object_id({"t_ili_tid": "source-1"}) == "source-1"
    assert projector._source_object_id(
        SimpleNamespace(obj_id="source-2")
    ) == "source-2"


def test_source_object_id_rejects_missing_identity() -> None:
    projector = _projector(model_mapping=_mapping(classes={}))
    with pytest.raises(ValueError, match="does not expose"):
        projector._source_object_id({})


def test_normalized_source_class_ids_preserve_order() -> None:
    projector = _projector(model_mapping=_mapping(classes={}))
    assert projector._normalized_source_class_ids(
        [" GepKnoten ", "OtherRelation"]
    ) == ("GepKnoten", "OtherRelation")


def test_duplicate_source_class_id_is_rejected() -> None:
    projector = _projector(model_mapping=_mapping(classes={}))
    with pytest.raises(ValueError, match="Duplicate"):
        projector._normalized_source_class_ids(
            ["GepKnoten", " GepKnoten "],
        )


def test_clear_cache_clears_all_source_discovery_caches() -> None:
    projector = _projector(model_mapping=_mapping(classes={}))
    projector._source_identity_cache[("schema", "table", "id")] = {1: "oid"}
    projector._source_foreign_key_target_cache[(GepKnoten, "fk")] = None
    projector._source_identity_owner_cache[GepKnoten] = None
    projector._value_list_cache[("vl", "value_de", "code", "x")] = 1

    projector.clear_cache()

    assert projector._source_identity_cache == {}
    assert projector._source_foreign_key_target_cache == {}
    assert projector._source_identity_owner_cache == {}
    assert projector._value_list_cache == {}
