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


class FakeModel:
    def classes(self):
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
                    canonical_class_id="wastewater_node",
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


def test_relation_context_provider_uses_effective_implicit_mapping_for_dss(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    provider = TwwRelationContextProvider(
        ili_model="DSS_2020_1_LV95",
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert len(contexts) == 1

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "wastewater_node"


def test_relation_context_provider_prefers_explicit_agxx_mapping(
    monkeypatch,
    implicit_model_mapping,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    explicit_model_mapping = ModelMappingCapability(
        ModelMapping(
            classes={
                "FakeRelation": ClassMapping(
                    canonical_class_id="agxx_wastewater_node",
                ),
            },
        ),
    )

    effective_model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=explicit_model_mapping,
        implicit_mapping=implicit_model_mapping,
    )

    provider = TwwRelationContextProvider(
        ili_model="Abwasserkataster_AG_V2_LV95",
        model_mapping=effective_model_mapping,
    )

    contexts = provider.relation_contexts()

    assert len(contexts) == 1

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "agxx_wastewater_node"


def test_relation_context_provider_falls_back_to_implicit_mapping_for_unmapped_agxx_class(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    provider = TwwRelationContextProvider(
        ili_model="Abwasserkataster_AG_V2_LV95",
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert len(contexts) == 1

    context = contexts[0]

    assert context.relation is FakeRelation
    assert context.class_mapping.canonical_class_id == "wastewater_node"


def test_relation_context_provider_returns_immutable_tuple(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    provider = TwwRelationContextProvider(
        ili_model="DSS_2020_1_LV95",
        model_mapping=effective_mapping,
    )

    contexts = provider.relation_contexts()

    assert isinstance(
        contexts,
        tuple,
    )


def test_relation_context_provider_raises_for_unknown_group(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        "teksi_wastewater.hooks.adapters.tww_relation_context_provider.model_config.groups_for_models",
        lambda model: {
            "unknown",
        },
    )

    with pytest.raises(
        ValueError,
        match="No model defined for group",
    ):
        TwwRelationContextProvider(
            ili_model="UnknownModel",
            model_mapping=effective_mapping,
        )

def test_relation_context_provider_raises_for_empty_model_group(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        "teksi_wastewater.hooks.adapters.tww_relation_context_provider.model_config.groups_for_models",
        lambda model: set(),
    )

    with pytest.raises(
        ValueError,
        match="Expected exactly one model group",
    ):
        TwwRelationContextProvider(
            ili_model="UnknownModel",
            model_mapping=effective_mapping,
        )


def test_relation_context_provider_raises_for_multiple_model_groups(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        "teksi_wastewater.hooks.adapters.tww_relation_context_provider.model_config.groups_for_models",
        lambda model: {
            "dss",
            "ag64",
        },
    )

    with pytest.raises(
        ValueError,
        match="Expected exactly one model group",
    ):
        TwwRelationContextProvider(
            ili_model="AmbiguousModel",
            model_mapping=effective_mapping,
        )

def test_relation_context_provider_passes_import_schema_to_model_loader(
    monkeypatch,
    effective_mapping,
):
    seen = {}

    def fake_get_model(
        self,
        schema,
    ):
        seen["schema"] = schema
        return FakeModel()

    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        fake_get_model,
    )

    TwwRelationContextProvider(
        ili_model="DSS_2020_1_LV95",
        model_mapping=effective_mapping,
        import_schema="custom_import_schema",
    )

    assert seen == {
        "schema": "custom_import_schema",
    }

def test_relation_context_provider_raises_for_unmapped_relation(
    monkeypatch,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    effective_model_mapping = EffectiveModelMappingCapability(
        explicit_mapping=ModelMappingCapability(
            ModelMapping(),
        ),
        implicit_mapping=None,
    )

    provider = TwwRelationContextProvider(
        ili_model="DSS_2020_1_LV95",
        model_mapping=effective_model_mapping,
    )

    with pytest.raises(
        KeyError,
        match="Unknown class",
    ):
        provider.relation_contexts()

def test_relation_context_provider_keeps_mapping_when_relation_is_not_inspectable(
    monkeypatch,
    effective_mapping,
):
    monkeypatch.setattr(
        TwwRelationContextProvider,
        "_get_model",
        lambda self, schema: FakeModel(),
    )

    provider = TwwRelationContextProvider(
        ili_model="DSS_2020_1_LV95",
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