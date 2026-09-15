from __future__ import annotations

import json
from typing import Any

import pytest

import teksi_wastewater.hooks.adapters.tww_quarantine_effect_projector as projector_module

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
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    FunctionMapping,
    ModelMapping,
    RelationContext,
    ValueMapping,
)

from ..helpers import (
    FakeQueryResult,
    fake_connection_factory,
)


class GepKnoten:
    pass


class GepHaltung:
    pass


class FunctionMappedClass:
    pass


class FakeRelationContextProvider:
    contexts: tuple[
        RelationContext,
        ...,
    ] = ()

    def relation_contexts(
        self,
    ) -> tuple[
        RelationContext,
        ...,
    ]:
        return self.__class__.contexts


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
            "reach": CanonicalClassMetadata(
                source_id=3,
                identifier="reach",
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
            (
                "reach",
                "status",
            ): CanonicalAttributeMetadata(
                source_id=30,
                identifier="status",
            ),
        },
        values={},
    )

def _mapping(
    *,
    classes: dict[
        str,
        ClassMapping,
    ],
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
    contexts: tuple[
        RelationContext,
        ...,
    ]=(),
    results: tuple[
        FakeQueryResult,
        ...,
    ] = (),
) -> tuple:
    connection_factory, cursor = fake_connection_factory(
        results=results,
    )
    relation_context_provider = (
        FakeRelationContextProvider()
    )
    relation_context_provider.contexts = contexts

    return (
        projector_module(
            connection_factory=connection_factory,
            model_mapping=model_mapping,
            relation_context_provider=relation_context_provider,
        ),
        cursor,
        connection_factory,
    )


def _rows_result(
    *rows: dict[
        str,
        Any,
    ],
) -> FakeQueryResult:
    if not rows:
        return FakeQueryResult(
            column_names=(),
            rows=(),
        )

    column_names = tuple(
        rows[0],
    )

    return FakeQueryResult(
        column_names=column_names,
        rows=tuple(
            tuple(
                row.get(
                    column_name,
                )
                for column_name in column_names
            )
            for row in rows
        ),
    )


def _scalar_result(
    value: Any,
) -> FakeQueryResult:
    return FakeQueryResult(
        column_names=(
            "effect_document",
        ),
        rows=(
            (
                value,
            ),
        ),
    )


def _patch_relation_context_provider(
    monkeypatch,
    contexts: tuple[
        RelationContext,
        ...,
    ],
) -> None:
    FakeRelationContextProvider.contexts = contexts
    FakeRelationContextProvider.init_args = []

    monkeypatch.setattr(
        projector_module,
        "TwwRelationContextProvider",
        FakeRelationContextProvider,
    )


def test_projector_projects_simple_attribute_mapping(
    monkeypatch,
) -> None:
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
        },
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, cursor, connection_factory = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "ch000000ws000001",
                    "statusag": "active",
                }
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    assert document.source.model == "AG64"
    assert document.source.class_id == "quarantine"
    assert document.source.object_id == "import_schema"

    assert len(
        document.effects,
    ) == 1

    effect = document.effects[0]

    assert isinstance(
        effect,
        UpdateAttributeEffect,
    )

    assert effect.identity == CanonicalObjectIdentity(
        class_id="wastewater_structure",
        attributes={
            "obj_id": "ch000000ws000001",
        },
    )

    assert effect.attribute_id == "status"
    assert effect.value == "active"

    assert FakeRelationContextProvider.init_args == [
        {
            "ili_model": "AG64",
            "model_mapping": projector.model_mapping,
            "import_schema": "import_schema",
        }
    ]

    assert len(
        cursor.executed_queries,
    ) == 1

    assert connection_factory.autocommit_values == [
        False,
    ]


def test_projector_applies_value_mapping(
    monkeypatch,
) -> None:
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

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "ch000000ws000002",
                    "funktionag": "Schacht",
                }
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    effect = document.effects[0]

    assert isinstance(
        effect,
        UpdateAttributeEffect,
    )

    assert effect.attribute_id == "function"
    assert effect.value == 1234


def test_projector_skips_unmapped_canonical_class(
    monkeypatch,
) -> None:
    class_mapping = ClassMapping(
        canonical_class_id=None,
        identities={
            "wastewater_structure": _identity_mapping(),
        },
        attributes={},
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, cursor, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    assert document.effects == ()
    assert cursor.executed_queries == []


def test_projector_rejects_unknown_canonical_class(
    monkeypatch,
) -> None:
    class_mapping = ClassMapping(
        canonical_class_id="unknown_class",
        identities={
            "unknown_class": _identity_mapping(),
        },
        attributes={},
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, cursor, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
    )

    with pytest.raises(
        KeyError,
        match="Unknown canonical class",
    ):
        projector.effect_document_from_quarantine(
            schema="import_schema",
            source_model="AG64",
            canonical_metadata=_canonical_metadata(),
        )

    assert cursor.executed_queries == []


def test_projector_rejects_unknown_canonical_attribute(
    monkeypatch,
) -> None:
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

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "ch000000ws000004",
                    "unknownag": "value",
                }
            ),
        ),
    )

    with pytest.raises(
        KeyError,
        match="Unknown canonical attribute",
    ):
        projector.effect_document_from_quarantine(
            schema="import_schema",
            source_model="AG64",
            canonical_metadata=_canonical_metadata(),
        )


def test_projector_parses_function_mapping_payload(
    monkeypatch,
) -> None:
    class_mapping = ClassMapping(
        function=FunctionMapping(
            schema="tww_app",
            name="fct_agxx_mapping_jsonb",
            parameters={
                "row": "$row",
            },
        ),
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=FunctionMappedClass,
                class_mapping=class_mapping,
            ),
        ),
    )

    payload = {
        "version": 1,
        "effects": [
            {
                "kind": "update_attribute",
                "identity": {
                    "class_id": "wastewater_structure",
                    "attributes": {
                        "obj_id": "ch000000ws000006",
                    },
                },
                "attribute_id": "status",
                "value": "active",
            },
            {
                "kind": "enforce_exists",
                "identity": {
                    "class_id": "reach",
                    "attributes": {
                        "obj_id": "ch000000re000001",
                    },
                },
            },
            {
                "kind": "enforce_not_exists",
                "identity": {
                    "class_id": "reach",
                    "attributes": {
                        "obj_id": "ch000000re000002",
                    },
                },
            },
        ],
    }

    projector, cursor, _ = _projector(
        model_mapping=_mapping(
            classes={
                "FunctionMappedClass": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "source_1",
                    "funktionag": "value",
                }
            ),
            _scalar_result(
                payload,
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    assert len(
        document.effects,
    ) == 3

    assert isinstance(
        document.effects[0],
        UpdateAttributeEffect,
    )

    assert document.effects[0].attribute_id == "status"
    assert document.effects[0].value == "active"

    assert isinstance(
        document.effects[1],
        EnforceExistsEffect,
    )

    assert isinstance(
        document.effects[2],
        EnforceNotExistsEffect,
    )

    assert len(
        cursor.executed_queries,
    ) == 2


def test_projector_parses_string_function_mapping_payload(
    monkeypatch,
) -> None:
    class_mapping = ClassMapping(
        function=FunctionMapping(
            schema="tww_app",
            name="fct_agxx_mapping_jsonb",
            parameters={
                "row": "$row",
            },
        ),
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=FunctionMappedClass,
                class_mapping=class_mapping,
            ),
        ),
    )

    payload = {
        "version": 1,
        "effects": [
            {
                "kind": "update_attribute",
                "identity": {
                    "class_id": "wastewater_structure",
                    "attributes": {
                        "obj_id": "ch000000ws000007",
                    },
                },
                "tww_attribute_id": "status",
                "value": "planned",
            }
        ],
    }

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "FunctionMappedClass": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "source_1",
                }
            ),
            _scalar_result(
                json.dumps(
                    payload,
                )
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    effect = document.effects[0]

    assert isinstance(
        effect,
        UpdateAttributeEffect,
    )

    assert effect.attribute_id == "status"
    assert effect.value == "planned"


def test_projector_returns_no_effects_for_empty_function_payload(
    monkeypatch,
) -> None:
    class_mapping = ClassMapping(
        function=FunctionMapping(
            schema="tww_app",
            name="fct_agxx_mapping_jsonb",
            parameters={
                "row": "$row",
            },
        ),
    )

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=FunctionMappedClass,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "FunctionMappedClass": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "source_1",
                }
            ),
            _scalar_result(
                None,
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    assert document.effects == ()


def test_projector_rejects_unsafe_function_parameter_name() -> None:
    projector, cursor, _ = _projector(
        model_mapping=_mapping(
            classes={},
        ),
    )

    function_mapping = FunctionMapping(
        schema="tww_app",
        name="fct_agxx_mapping_jsonb",
        parameters={
            "bad-name": "$row",
        },
    )

    with pytest.raises(
        ValueError,
        match="Unsafe SQL identifier",
    ):
        projector._call_function_mapping(
            cursor=cursor,
            function_mapping=function_mapping,
            row={
                "t_ili_tid": "source_1",
            },
        )

    assert cursor.executed_queries == []


def test_projector_rejects_unsupported_function_effect_kind() -> None:
    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={},
        ),
    )

    with pytest.raises(
        ValueError,
        match="Unsupported effect kind",
    ):
        projector._effect_from_payload(
            {
                "kind": "unsupported",
                "identity": {
                    "class_id": "wastewater_structure",
                    "attributes": {
                        "obj_id": "ch000000ws000008",
                    },
                },
            }
        )

def test_projector_projects_cross_class_attribute_mapping(
    monkeypatch,
) -> None:
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

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "ch000000ws000005",
                    "funktionag": "value",
                }
            ),
        ),
    )

    document = projector.effect_document_from_quarantine(
        schema="import_schema",
        source_model="AG64",
        canonical_metadata=_canonical_metadata(),
    )

    assert len(
        document.effects,
    ) == 1

    effect = document.effects[
        0
    ]

    assert isinstance(
        effect,
        UpdateAttributeEffect,
    )

    assert effect.identity == CanonicalObjectIdentity(
        class_id="wastewater_node",
        attributes={
            "obj_id": "ch000000ws000005",
        },
    )

    assert effect.attribute_id == "function"
    assert effect.value == "value"

def test_projector_rejects_attribute_target_without_identity(
    monkeypatch,
) -> None:
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

    _patch_relation_context_provider(
        monkeypatch,
        contexts=(
            RelationContext(
                relation=GepKnoten,
                class_mapping=class_mapping,
            ),
        ),
    )

    projector, _, _ = _projector(
        model_mapping=_mapping(
            classes={
                "GepKnoten": class_mapping,
            },
        ),
        results=(
            _rows_result(
                {
                    "t_ili_tid": "ch000000ws000005",
                    "funktionag": "value",
                }
            ),
        ),
    )

    with pytest.raises(
        ValueError,
        match="identity",
    ):
        projector.effect_document_from_quarantine(
            schema="import_schema",
            source_model="AG64",
            canonical_metadata=_canonical_metadata(),
        )

