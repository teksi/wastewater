from __future__ import annotations

from datetime import datetime
from pathlib import Path
from types import SimpleNamespace
from typing import Any
from unittest.mock import Mock

import pytest

from teksi_hooks.models.canonical_object import (
    CanonicalClassMetadata,
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    EffectDocument,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.review import (
    ReviewFeature,
)

from teksi_wastewater.hooks.services import (
    tww_change_creation_service as service_module,
)
from teksi_wastewater.hooks.services.tww_change_creation_service import (
    TwwChangeCreationService,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    DiffJobMode,
    DiffSchemaWriteResult,
)


@pytest.fixture
def service() -> TwwChangeCreationService:
    return _ready_service()


@pytest.fixture
def rights_context():
    return SimpleNamespace(
        provider_oid="ch080qwzPR000017",
        dataowner_oid="ch080qwzPR000018",
    )

def _identity(
    object_id: str,
    *,
    class_id: str = "wastewater_structure",
) -> CanonicalObjectIdentity:
    return CanonicalObjectIdentity(
        class_id=class_id,
        attributes={
            "obj_id": object_id,
        },
    )


def _effect(
    effect_type,
    **attributes: Any,
):
    effect = effect_type.__new__(
        effect_type,
    )

    for name, value in attributes.items():
        object.__setattr__(
            effect,
            name,
            value,
        )

    return effect


def _update_effect(
    *,
    identity: CanonicalObjectIdentity,
    attribute_id: str,
    value: Any,
) -> UpdateAttributeEffect:
    return _effect(
        UpdateAttributeEffect,
        identity=identity,
        attribute_id=attribute_id,
        value=value,
    )


def _constraint_effect(
    effect_type,
    *,
    identity: CanonicalObjectIdentity,
):
    return _effect(
        effect_type,
        identity=identity,
    )


def _document(
    *effects,
    source: Any = None,
    version: int = 1,
) -> EffectDocument:
    return EffectDocument(
        source=source,
        effects=tuple(
            effects,
        ),
        created_at=datetime(
            2026,
            1,
            1,
            12,
            0,
            0,
        ),
        version=version,
    )


def _canonical_metadata() -> CanonicalModelMetadata:
    return CanonicalModelMetadata(
        classes={},
        attributes={},
        values={},
    )


def _ready_service(
    **overrides,
) -> TwwChangeCreationService:
    values = {
        "connection_factory": Mock(),
        "quarantine_runner": Mock(),
        "canonical_metadata": _canonical_metadata(),
        "effect_projector": Mock(),
        "rights_evaluator": Mock(),
        "object_provider_factory": Mock(),
        "diff_schema_service": Mock(),
    }

    values.update(
        overrides,
    )

    return TwwChangeCreationService(
        **values,
    )


def test_change_creation_service_requires_collaborators() -> None:
    service = TwwChangeCreationService(
        connection_factory=Mock(),
        quarantine_runner=Mock(),
        canonical_metadata=_canonical_metadata(),
        effect_projector=None,
        rights_evaluator=None,
        object_provider_factory=None,
        diff_schema_service=Mock(),
    )

    with pytest.raises(
        RuntimeError,
        match=(
            "effect_projector, rights_evaluator, "
            "object_provider_factory"
        ),
    ):
        service._ensure_ready_for_diff_job()


@pytest.mark.parametrize(
    "job_mode",
    (
        DiffJobMode.CREATE,
        DiffJobMode.REPLACE,
    ),
)
def test_change_creation_service_accepts_supported_job_modes(
    job_mode: DiffJobMode,
) -> None:
    _ready_service()._assert_supported_job_mode(
        job_mode,
    )


def test_change_creation_service_rejects_refresh_mode() -> None:
    with pytest.raises(
        NotImplementedError,
        match="refresh is not implemented",
    ):
        _ready_service()._assert_supported_job_mode(
            DiffJobMode.REFRESH,
        )


def test_change_creation_service_builds_default_import_context() -> None:
    service = _ready_service()

    orgs_path = Path(
        "/tmp/organisations.xtf",
    )

    context = service._import_context(
        context=None,
        schema="xtf_import",
        orgs_path=orgs_path,
    )

    assert context.schema == "xtf_import"
    assert context.import_orgs is True
    assert context.orgs_path == orgs_path


def test_change_creation_service_builds_context_without_organisations() -> None:
    context = _ready_service()._import_context(
        context=None,
        schema="xtf_agxx",
        orgs_path=None,
    )

    assert context.schema == "xtf_agxx"
    assert context.import_orgs is False
    assert context.orgs_path is None


def test_change_creation_service_replaces_import_context_values() -> None:
    service = _ready_service()

    original = service._import_context(
        context=None,
        schema="original_schema",
        orgs_path=Path(
            "/tmp/original-organisations.xtf",
        ),
    )

    updated = service._import_context(
        context=original,
        schema="incremental_schema",
        orgs_path=None,
    )

    assert updated is not original
    assert updated.schema == "incremental_schema"
    assert updated.import_orgs is False
    assert updated.orgs_path is None

    assert original.schema == "original_schema"
    assert original.import_orgs is True


def test_change_creation_service_uses_explicit_validation_log_path() -> None:
    explicit_path = Path(
        "/tmp/explicit.log",
    )

    assert _ready_service()._validation_log_path(
        validation_log_path=explicit_path,
        xtf_file=Path(
            "/tmp/delivery.xtf",
        ),
        name="validate_import_quarantine",
    ) == explicit_path


def test_change_creation_service_derives_validation_log_path() -> None:
    assert _ready_service()._validation_log_path(
        validation_log_path=None,
        xtf_file=Path(
            "/tmp/delivery.xtf",
        ),
        name="validate_import_quarantine",
    ) == Path(
        "/tmp/delivery_validate_import_quarantine.log",
    )


def test_change_creation_service_incremental_updates_override_base_updates() -> None:
    identity = _identity(
        "ch000000ws000001",
    )

    base_status = _update_effect(
        identity=identity,
        attribute_id="status",
        value="operational",
    )

    base_identifier = _update_effect(
        identity=identity,
        attribute_id="identifier",
        value="Base identifier",
    )

    incremental_status = _update_effect(
        identity=identity,
        attribute_id="status",
        value="inoperative",
    )

    incremental_remark = _update_effect(
        identity=identity,
        attribute_id="remark",
        value="Incremental remark",
    )

    merged = _ready_service()._merge_effect_documents(
        base_document=_document(
            base_status,
            base_identifier,
            version=1,
        ),
        incremental_document=_document(
            incremental_status,
            incremental_remark,
            version=2,
        ),
    )

    assert merged.effects == (
        incremental_status,
        base_identifier,
        incremental_remark,
    )

    assert merged.version == 2


def test_change_creation_service_keeps_updates_for_different_objects() -> None:
    first_status = _update_effect(
        identity=_identity(
            "ch000000ws000001",
        ),
        attribute_id="status",
        value="operational",
    )

    second_status = _update_effect(
        identity=_identity(
            "ch000000ws000002",
        ),
        attribute_id="status",
        value="inoperative",
    )

    merged = _ready_service()._merge_effect_documents(
        base_document=_document(
            first_status,
        ),
        incremental_document=_document(
            second_status,
        ),
    )

    assert merged.effects == (
        first_status,
        second_status,
    )


def test_change_creation_service_merges_constraint_effects_by_type() -> None:
    identity = _identity(
        "ch000000ws000001",
    )

    base_exists = _constraint_effect(
        EnforceExistsEffect,
        identity=identity,
    )

    incremental_exists = _constraint_effect(
        EnforceExistsEffect,
        identity=identity,
    )

    incremental_not_exists = _constraint_effect(
        EnforceNotExistsEffect,
        identity=identity,
    )

    merged = _ready_service()._merge_effect_documents(
        base_document=_document(
            base_exists,
        ),
        incremental_document=_document(
            incremental_exists,
            incremental_not_exists,
        ),
    )

    assert merged.effects == (
        incremental_exists,
        incremental_not_exists,
    )


def test_change_creation_service_rejects_unsupported_effect_type() -> None:
    unsupported_effect = SimpleNamespace(
        identity=_identity(
            "ch000000ws000001",
        ),
    )

    with pytest.raises(
        TypeError,
        match="Unsupported effect type",
    ):
        _ready_service()._merge_effect_documents(
            base_document=_document(
                unsupported_effect,
            ),
            incremental_document=_document(),
        )


def test_change_creation_service_builds_one_change_per_identity() -> None:
    identity = _identity(
        "ch000000ws000001",
    )

    status_effect = _update_effect(
        identity=identity,
        attribute_id="status",
        value="operational",
    )

    identifier_effect = _update_effect(
        identity=identity,
        attribute_id="identifier",
        value="Updated identifier",
    )

    constraint_effect = _constraint_effect(
        EnforceExistsEffect,
        identity=identity,
    )

    current_object = object()
    built_change = object()

    relation_lookup = Mock()
    relation_lookup.current_object.return_value = current_object

    change_builder = Mock()
    change_builder.build.return_value = built_change

    changes = _ready_service(
        change_builder=change_builder,
    )._build_changes(
        effect_document=_document(
            status_effect,
            identifier_effect,
            constraint_effect,
        ),
        relation_lookup=relation_lookup,
    )

    assert changes == (
        built_change,
    )

    relation_lookup.current_object.assert_called_once_with(
        identity,
    )

    change_builder.build.assert_called_once_with(
        current_object=current_object,
        effects=(
            status_effect,
            identifier_effect,
        ),
    )


def test_change_creation_service_builds_separate_changes_per_identity() -> None:
    first_effect = _update_effect(
        identity=_identity(
            "ch000000ws000001",
        ),
        attribute_id="status",
        value="operational",
    )

    second_effect = _update_effect(
        identity=_identity(
            "ch000000ws000002",
        ),
        attribute_id="status",
        value="inoperative",
    )

    relation_lookup = Mock()

    relation_lookup.current_object.side_effect = (
        object(),
        object(),
    )

    first_change = object()
    second_change = object()

    change_builder = Mock()

    change_builder.build.side_effect = (
        first_change,
        second_change,
    )

    changes = _ready_service(
        change_builder=change_builder,
    )._build_changes(
        effect_document=_document(
            first_effect,
            second_effect,
        ),
        relation_lookup=relation_lookup,
    )

    assert changes == (
        first_change,
        second_change,
    )


def test_change_creation_service_ignores_constraint_only_documents() -> None:
    identity = _identity(
        "ch000000ws000001",
    )

    relation_lookup = Mock()
    change_builder = Mock()

    changes = _ready_service(
        change_builder=change_builder,
    )._build_changes(
        effect_document=_document(
            _constraint_effect(
                EnforceExistsEffect,
                identity=identity,
            ),
            _constraint_effect(
                EnforceNotExistsEffect,
                identity=identity,
            ),
        ),
        relation_lookup=relation_lookup,
    )

    assert changes == ()

    relation_lookup.current_object.assert_not_called()
    change_builder.build.assert_not_called()


def test_change_creation_service_uses_configured_live_relation_lookup() -> None:
    relation_lookup = Mock()

    service = _ready_service(
        live_relation_lookup=relation_lookup,
    )

    assert service._live_relation_lookup(
        "custom_live_schema",
    ) is relation_lookup


def test_change_creation_service_builds_default_live_relation_lookup(
    monkeypatch,
) -> None:
    relation_lookup = object()

    constructor = Mock(
        return_value=relation_lookup,
    )

    monkeypatch.setattr(
        service_module,
        "TwwRelationLookupAdapter",
        constructor,
    )

    connection_factory = Mock()

    service = _ready_service(
        connection_factory=connection_factory,
        live_relation_lookup=None,
    )

    assert service._live_relation_lookup(
        "custom_live_schema",
    ) is relation_lookup

    constructor.assert_called_once_with(
        connection_factory=connection_factory,
        schema="custom_live_schema",
    )


def test_change_creation_service_imports_base_and_incremental_xtf(
    monkeypatch,
) -> None:
    quarantine_runner = Mock()

    quarantine_runner.import_xtf_to_quarantine.side_effect = (
        (
            "DSS_2020_1_LV95",
            (
                "DSS_2020_1_LV95",
            ),
        ),
        (
            "Genereller_Entwaesserungsplan_AG",
            (
                "Genereller_Entwaesserungsplan_AG",
            ),
        ),
    )

    service = _ready_service(
        quarantine_runner=quarantine_runner,
    )

    delegated_result = object()
    delegated_arguments = {}

    def fake_create_diff_job_from_quarantine(
        self,
        **kwargs,
    ):
        delegated_arguments.update(
            kwargs,
        )

        return delegated_result

    monkeypatch.setattr(
        TwwChangeCreationService,
        "create_diff_job_from_quarantine",
        fake_create_diff_job_from_quarantine,
    )

    rights_context = SimpleNamespace(
        provider_oid="ch080qwzPR000017",
        dataowner_oid="ch080qwzPR000018",
    )

    xtf_file = Path(
        "/tmp/base.xtf",
    )

    orgs_path = Path(
        "/tmp/organisations.xtf",
    )

    incremental_xtf = Path(
        "/tmp/incremental.xtf",
    )

    result = service.create_diff_job_from_xtf(
        job_id="job-1",
        job_mode=DiffJobMode.CREATE,
        xtf_file=xtf_file,
        orgs_path=orgs_path,
        rights_context=rights_context,
        import_schema="xtf_import",
        live_schema="tww_od",
        metadata={
                "source_role": "base",
                "source_xtf": str(
                    xtf_file,
                ),
                "source_schema": "xtf_import",
                "persist_job": False,
            },
    )

    assert result is delegated_result

    assert result.diff_schema_result is None

    assert (
        quarantine_runner
        .import_xtf_to_quarantine
        .call_count
        == 2
    )

    base_call = (
        quarantine_runner
        .import_xtf_to_quarantine
        .call_args_list[0]
    )

    assert base_call.kwargs[
        "xtf_file"
    ] == xtf_file

    assert base_call.kwargs[
        "schema"
    ] == "xtf_import"

    assert base_call.kwargs[
        "context"
    ].schema == "xtf_import"

    assert base_call.kwargs[
        "context"
    ].import_orgs is True

    assert base_call.kwargs[
        "context"
    ].orgs_path == orgs_path

    incremental_call = (
        quarantine_runner
        .import_xtf_to_quarantine
        .call_args_list[1]
    )

    assert incremental_call.kwargs[
        "xtf_file"
    ] == incremental_xtf

    assert incremental_call.kwargs[
        "schema"
    ] == "xtf_import_incremental"

    assert incremental_call.kwargs[
        "context"
    ].schema == "xtf_import_incremental"

    assert incremental_call.kwargs[
        "context"
    ].import_orgs is False

    assert incremental_call.kwargs[
        "context"
    ].orgs_path is None

    assert (
        quarantine_runner
        .validate_quarantine_or_raise
        .call_count
        == 2
    )

    assert delegated_arguments[
        "job_id"
    ] == "job-1"

    assert delegated_arguments[
        "job_mode"
    ] == DiffJobMode.CREATE

    assert delegated_arguments[
        "source_model"
    ] == "DSS_2020_1_LV95"

    assert delegated_arguments[
        "created_models"
    ] == (
        "DSS_2020_1_LV95",
    )

    assert delegated_arguments[
        "incremental_source_model"
    ] == (
        "Genereller_Entwaesserungsplan_AG"
    )

    assert delegated_arguments[
        "incremental_created_models"
    ] == (
        "Genereller_Entwaesserungsplan_AG",
    )

    assert delegated_arguments[
        "incremental_import_schema"
    ] == "xtf_import_incremental"

    assert delegated_arguments[
        "import_schema"
    ] == "xtf_import"

    assert delegated_arguments[
        "live_schema"
    ] == "tww_od"

    assert delegated_arguments[
        "rights_context"
    ] is rights_context

def test_change_creation_service_rejects_unpersisted_incremental_source(
    service,
    rights_context,
) -> None:
    with pytest.raises(
        ValueError,
        match="incremental source must finalize",
    ):
        service.create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="AG96",
            rights_context=rights_context,
            import_schema="incremental_schema",
            metadata={
                "source_role": "incremental",
                "persist_job": False,
            },
        ) 

def test_change_creation_service_requires_prepared_base_source(
    service,
    rights_context,
) -> None:
    with pytest.raises(
        KeyError,
        match="prepared",
    ):
        service.create_diff_job_from_quarantine(
            job_id="missing-job",
            job_mode=DiffJobMode.CREATE,
            source_model="AG96",
            rights_context=rights_context,
            import_schema="incremental_schema",
            metadata={
                "source_role": "incremental",
                "persist_job": True,
            },
        )