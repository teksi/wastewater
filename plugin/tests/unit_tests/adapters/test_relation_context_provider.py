from __future__ import annotations

import pytest
from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.models.mapping import (
    ClassMapping,
    ModelMapping,
)
from teksi_wastewater.hooks.adapters.tww_relation_context_provider import (
    TwwRelationContextProvider,
)


class FakeRelation:
    pass


@pytest.fixture
def quarantine_classes():
    return {
        "FakeRelation": FakeRelation,
    }


@pytest.fixture
def empty_model_mapping():
    return ModelMappingCapability(
        ModelMapping(),
    )


@pytest.fixture
def implicit_model_mapping():
    return ModelMappingCapability(
        ModelMapping(
            classes={
                "FakeRelation": ClassMapping(
                    canonical_class_id=("wastewater_node"),
                ),
            },
        ),
    )


@pytest.fixture
def effective_mapping(
    empty_model_mapping,
    implicit_model_mapping,
):
    return EffectiveModelMappingCapability(
        explicit_mapping=empty_model_mapping,
        implicit_mapping=implicit_model_mapping,
    )


def test_relation_context_provider_uses_effective_implicit_mapping(
    quarantine_classes,
    effective_mapping,
):
    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert (
        len(
            contexts,
        )
        == 1
    )

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "wastewater_node"


def test_relation_context_provider_prefers_explicit_mapping(
    quarantine_classes,
    implicit_model_mapping,
):
    explicit_model_mapping = ModelMappingCapability(
        ModelMapping(
            classes={
                "FakeRelation": ClassMapping(
                    canonical_class_id=("agxx_wastewater_node"),
                ),
            },
        ),
    )

    effective_model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=(explicit_model_mapping),
        implicit_mapping=(implicit_model_mapping),
    )

    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_model_mapping,
    )

    contexts = provider.relation_contexts()

    assert (
        len(
            contexts,
        )
        == 1
    )

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "agxx_wastewater_node"


def test_relation_context_provider_falls_back_to_implicit_mapping(
    quarantine_classes,
    effective_mapping,
):
    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert (
        len(
            contexts,
        )
        == 1
    )

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "wastewater_node"


def test_relation_context_provider_returns_immutable_tuple(
    quarantine_classes,
    effective_mapping,
):
    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert isinstance(
        contexts,
        tuple,
    )


def test_relation_context_provider_preserves_relation_order(
    effective_mapping,
):
    class FirstRelation:
        pass

    class SecondRelation:
        pass

    provider = TwwRelationContextProvider(
        quarantine_classes={
            "FirstRelation": FirstRelation,
            "SecondRelation": SecondRelation,
        },
        model_mapping=effective_mapping,
    )

    provider.model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=(
            ModelMappingCapability(
                ModelMapping(),
            )
        ),
        implicit_mapping=(
            ModelMappingCapability(
                ModelMapping(
                    classes={
                        "FirstRelation": (
                            ClassMapping(
                                canonical_class_id=("first"),
                            )
                        ),
                        "SecondRelation": (
                            ClassMapping(
                                canonical_class_id=("second"),
                            )
                        ),
                    },
                )
            )
        ),
    )

    contexts = provider.relation_contexts()

    assert tuple(context.relation for context in contexts) == (
        FirstRelation,
        SecondRelation,
    )


def test_relation_context_provider_returns_empty_tuple_for_empty_classes(
    effective_mapping,
):
    provider = TwwRelationContextProvider(
        quarantine_classes={},
        model_mapping=effective_mapping,
    )

    assert provider.relation_contexts() == ()


def test_relation_context_provider_raises_for_unmapped_relation():
    effective_model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=(
            ModelMappingCapability(
                ModelMapping(),
            )
        ),
        implicit_mapping=None,
    )

    provider = TwwRelationContextProvider(
        quarantine_classes={
            "FakeRelation": FakeRelation,
        },
        model_mapping=effective_model_mapping,
    )

    with pytest.raises(
        KeyError,
        match=r"mapping exists.*FakeRelation",
    ):
        provider.relation_contexts()


def test_relation_context_provider_keeps_mapping_when_relation_is_not_inspectable(
    quarantine_classes,
    effective_mapping,
):
    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_mapping,
    )

    class_mapping = ClassMapping(
        canonical_class_id="wastewater_node",
        attributes={},
    )

    enriched = provider._with_automap_foreign_keys(
        relation=FakeRelation,
        class_mapping=class_mapping,
    )

    assert enriched == class_mapping


def test_relation_context_provider_returns_function_mapping_unchanged(
    quarantine_classes,
):
    function = object()

    function_mapping = ClassMapping(
        canonical_class_id=None,
        function=function,
    )

    effective_model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=(
            ModelMappingCapability(
                ModelMapping(
                    classes={
                        "FakeRelation": (function_mapping),
                    },
                )
            )
        ),
        implicit_mapping=None,
    )

    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_model_mapping,
    )

    contexts = provider.relation_contexts()

    assert (
        len(
            contexts,
        )
        == 1
    )

    assert contexts[0].class_mapping is function_mapping


def test_relation_context_provider_explicit_class_overrides_implicit_class(
    quarantine_classes,
):
    explicit_mapping = ClassMapping(
        canonical_class_id=("agxx_wastewater_node"),
    )

    implicit_mapping = ClassMapping(
        canonical_class_id=("wastewater_node"),
    )

    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=(
            EffectiveModelMappingCapability(
                explicit_mapping=(
                    ModelMappingCapability(
                        ModelMapping(
                            classes={
                                "FakeRelation": (explicit_mapping),
                            },
                        )
                    )
                ),
                implicit_mapping=(
                    ModelMappingCapability(
                        ModelMapping(
                            classes={
                                "FakeRelation": (implicit_mapping),
                            },
                        )
                    )
                ),
            )
        ),
    )

    context = provider.relation_contexts()[0]

    assert context.class_mapping.canonical_class_id == "agxx_wastewater_node"


def test_relation_context_provider_does_not_mutate_source_mapping(
    quarantine_classes,
    effective_mapping,
):
    original_mapping = effective_mapping.implicit_mapping.class_definition(
        "FakeRelation",
    )

    provider = TwwRelationContextProvider(
        quarantine_classes=quarantine_classes,
        model_mapping=effective_mapping,
    )

    provider.relation_contexts()

    current_mapping = effective_mapping.implicit_mapping.class_definition(
        "FakeRelation",
    )

    assert current_mapping == original_mapping
