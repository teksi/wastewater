from __future__ import annotations

from dataclasses import replace
from typing import Any, Mapping

import pytest

from teksi_hooks.models.effects import (
    EffectDocument,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.persistence import (
    DiffJobMode,
)
from teksi_hooks.models.review import (
    DiffSchemaWriteResult,
    PreparedSource,
)


class FakeDiffSchemaService:
    def __init__(
        self,
    ) -> None:
        self.prepared_sources: dict[
            str,
            PreparedSource,
        ] = {}

        self.write_calls: list[
            dict[
                str,
                Any,
            ]
        ] = []

    def prepare_source(
        self,
        *,
        job_id: str,
        source: PreparedSource,
    ) -> None:
        if job_id in self.prepared_sources:
            raise RuntimeError(
                "A prepared source already exists "
                f"for diff workflow {job_id!r}."
            )

        self.prepared_sources[
            job_id
        ] = source

    def prepared_source(
        self,
        *,
        job_id: str,
    ) -> PreparedSource:
        try:
            return self.prepared_sources[
                job_id
            ]
        except KeyError as exception:
            raise KeyError(
                "No prepared source exists for "
                f"diff workflow {job_id!r}."
            ) from exception

    def clear_prepared_source(
        self,
        *,
        job_id: str,
    ) -> None:
        self.prepared_sources.pop(
            job_id,
            None,
        )

    def write(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        features_by_class,
        metadata: Mapping[
            str,
            Any,
        ],
        validation_success: bool,
        job_status: str,
    ) -> DiffSchemaWriteResult:
        self.write_calls.append(
            {
                "job_id": job_id,
                "job_mode": job_mode,
                "features_by_class": (
                    features_by_class
                ),
                "metadata": dict(
                    metadata,
                ),
                "validation_success": (
                    validation_success
                ),
                "job_status": job_status,
            }
        )

        return DiffSchemaWriteResult(
            job_db_id=1,
            job_id=job_id,
            row_count=sum(
                len(
                    features,
                )
                for features
                in features_by_class.values()
            ),
        )


def test_change_creation_service_creates_diff_job_from_quarantine(
    service,
    rights_context,
    diff_schema_service,
) -> None:
    result = service.create_diff_job_from_quarantine(
        job_id="job-1",
        job_mode=DiffJobMode.CREATE,
        source_model="dss",
        rights_context=rights_context,
        import_schema="import_schema",
        live_schema="tww_od",
        metadata={
            "source_role": "base",
            "persist_job": True,
        },
    )

    assert result.job_id == "job-1"
    assert result.import_model == "dss"
    assert result.incremental_import_model is None
    assert result.diff_schema_result is not None

    assert len(
        diff_schema_service.write_calls,
    ) == 1

    write_call = diff_schema_service.write_calls[
        0
    ]

    assert write_call["job_id"] == "job-1"
    assert write_call["job_mode"] == (
        DiffJobMode.CREATE
    )
    assert write_call["job_status"] == "pending"
    assert write_call["validation_success"] is True
    assert (
        write_call["metadata"]["source_role"]
        == "base"
    )
    assert (
        write_call["metadata"]["persist_job"]
        is True
    )


def test_change_creation_service_prepares_base_without_persisting_job(
    service,
    rights_context,
    diff_schema_service,
) -> None:
    result = service.create_diff_job_from_quarantine(
        job_id="job-1",
        job_mode=DiffJobMode.CREATE,
        source_model="dss",
        rights_context=rights_context,
        created_models=(
            "SIA405_Base_Abwasser_1_LV95",
            "SIA405_ABWASSER_2020_1_LV95",
            "DSS_2020_1_LV95",
        ),
        import_schema="base_schema",
        live_schema="tww_od",
        metadata={
            "source_role": "base",
            "persist_job": False,
            "source_file": "/tmp/base.xtf",
            "model_group": "dss",
            "model_language": "de",
        },
    )

    assert result.job_id == "job-1"
    assert result.import_model == "dss"
    assert result.incremental_import_model is None
    assert result.diff_schema_result is None

    assert diff_schema_service.write_calls == []

    prepared = (
        diff_schema_service.prepared_source(
            job_id="job-1",
        )
    )

    assert prepared.source_model == "dss"
    assert prepared.created_models == (
        "SIA405_Base_Abwasser_1_LV95",
        "SIA405_ABWASSER_2020_1_LV95",
        "DSS_2020_1_LV95",
    )
    assert (
        prepared.effect_document
        == result.effect_document
    )
    assert (
        prepared.metadata["source_role"]
        == "base"
    )
    assert (
        prepared.metadata["persist_job"]
        is False
    )
    assert (
        prepared.metadata["source_file"]
        == "/tmp/base.xtf"
    )

@pytest.fixture
def diff_schema_service():
    return FakeDiffSchemaService()


@pytest.fixture
def base_service(
    service,
    diff_schema_service,
):
    service.diff_schema_service = (
        diff_schema_service
    )

    return service


@pytest.fixture
def incremental_service(
    service,
    diff_schema_service,
):
    return replace(
        service,
        diff_schema_service=(
            diff_schema_service
        ),
    )


def test_change_creation_service_merges_prepared_base_and_incremental_source(
    base_service,
    incremental_service,
    rights_context,
    diff_schema_service,
) -> None:
    base_result = (
        base_service
        .create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="dss",
            rights_context=rights_context,
            created_models=(
                "DSS_2020_1_LV95",
            ),
            import_schema="base_schema",
            live_schema="tww_od",
            metadata={
                "source_role": "base",
                "persist_job": False,
                "source_file": "/tmp/base.xtf",
                "model_group": "dss",
                "model_language": "de",
            },
        )
    )

    assert base_result.diff_schema_result is None

    assert (
        diff_schema_service.prepared_source(
            job_id="job-1",
        ).effect_document
        == base_result.effect_document
    )

    result = (
        incremental_service
        .create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="ag96",
            rights_context=rights_context,
            created_models=(
                "Genereller_Entwaesserungsplan_AG",
            ),
            import_schema=(
                "incremental_schema"
            ),
            live_schema="tww_od",
            metadata={
                "source_role": "incremental",
                "persist_job": True,
                "source_file": (
                    "/tmp/incremental.xtf"
                ),
                "model_group": "ag96",
                "model_language": "de",
            },
        )
    )

    assert result.job_id == "job-1"
    assert result.import_model == "dss"
    assert result.incremental_import_model == (
        "ag96"
    )
    assert result.created_models == [
        "DSS_2020_1_LV95",
    ]
    assert result.incremental_created_models == [
        "Genereller_Entwaesserungsplan_AG",
    ]
    assert result.diff_schema_result is not None

    assert len(
        diff_schema_service.write_calls,
    ) == 1

    write_call = diff_schema_service.write_calls[
        0
    ]

    assert write_call["job_id"] == "job-1"
    assert write_call["job_status"] == "pending"
    assert write_call["validation_success"] is True

    metadata = write_call["metadata"]

    assert metadata["source_role"] == (
        "incremental"
    )
    assert metadata["persist_job"] is True
    assert metadata["base_source_model"] == (
        "dss"
    )
    assert metadata[
        "incremental_source_model"
    ] == "ag96"
    assert metadata["base_source_file"] == (
        "/tmp/base.xtf"
    )
    assert metadata[
        "incremental_source_file"
    ] == "/tmp/incremental.xtf"
    assert metadata["base_import_schema"] == (
        "base_schema"
    )
    assert metadata[
        "incremental_import_schema"
    ] == "incremental_schema"

    with pytest.raises(
        KeyError,
        match="prepared source",
    ):
        diff_schema_service.prepared_source(
            job_id="job-1",
        )


def test_change_creation_service_incremental_updates_override_base_updates(
    service,
    identity,
) -> None:
    base_update = UpdateAttributeEffect(
        identity=identity,
        attribute_id="status",
        value="base",
    )

    unrelated_base_update = (
        UpdateAttributeEffect(
            identity=identity,
            attribute_id="function",
            value="manhole",
        )
    )

    incremental_update = (
        UpdateAttributeEffect(
            identity=identity,
            attribute_id="status",
            value="incremental",
        )
    )

    base_document = EffectDocument(
        source="base",
        effects=(
            base_update,
            unrelated_base_update,
        ),
    )

    incremental_document = EffectDocument(
        source="incremental",
        effects=(
            incremental_update,
        ),
    )

    result = service._merge_effect_documents(
        base_document=base_document,
        incremental_document=(
            incremental_document
        ),
    )

    assert result.source == "incremental"

    assert result.effects == (
        incremental_update,
        unrelated_base_update,
    )


def test_change_creation_service_merges_constraint_effects_by_type(
    service,
    identity,
) -> None:
    base_exists = EnforceExistsEffect(
        identity=identity,
    )

    base_not_exists = EnforceNotExistsEffect(
        identity=identity,
    )

    incremental_exists = EnforceExistsEffect(
        identity=identity,
    )

    base_document = EffectDocument(
        source="base",
        effects=(
            base_exists,
            base_not_exists,
        ),
    )

    incremental_document = EffectDocument(
        source="incremental",
        effects=(
            incremental_exists,
        ),
    )

    result = service._merge_effect_documents(
        base_document=base_document,
        incremental_document=(
            incremental_document
        ),
    )

    assert len(
        result.effects,
    ) == 2

    assert result.effects[0] is (
        incremental_exists
    )
    assert result.effects[1] is (
        base_not_exists
    )


def test_change_creation_service_rejects_unpersisted_incremental_source(
    service,
    rights_context,
) -> None:
    with pytest.raises(
        ValueError,
        match=(
            "incremental source must finalize"
        ),
    ):
        service.create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="ag96",
            rights_context=rights_context,
            import_schema=(
                "incremental_schema"
            ),
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
        match="prepared source",
    ):
        service.create_diff_job_from_quarantine(
            job_id="missing-job",
            job_mode=DiffJobMode.CREATE,
            source_model="ag96",
            rights_context=rights_context,
            import_schema=(
                "incremental_schema"
            ),
            metadata={
                "source_role": "incremental",
                "persist_job": True,
            },
        )


def test_change_creation_service_rejects_unknown_source_role(
    service,
    rights_context,
) -> None:
    with pytest.raises(
        ValueError,
        match="source_role",
    ):
        service.create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="dss",
            rights_context=rights_context,
            import_schema="import_schema",
            metadata={
                "source_role": "unknown",
                "persist_job": True,
            },
        )


@pytest.mark.parametrize(
    "persist_job",
    (
        None,
        0,
        1,
        "true",
        "false",
    ),
)
def test_change_creation_service_requires_boolean_persist_job(
    service,
    rights_context,
    persist_job,
) -> None:
    with pytest.raises(
        TypeError,
        match="persist_job",
    ):
        service.create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="dss",
            rights_context=rights_context,
            import_schema="import_schema",
            metadata={
                "source_role": "base",
                "persist_job": persist_job,
            },
        )


def test_change_creation_service_keeps_prepared_source_when_write_fails(
    base_service,
    incremental_service,
    rights_context,
    diff_schema_service,
    monkeypatch,
) -> None:
    base_service.create_diff_job_from_quarantine(
        job_id="job-1",
        job_mode=DiffJobMode.CREATE,
        source_model="dss",
        rights_context=rights_context,
        created_models=(
            "DSS_2020_1_LV95",
        ),
        import_schema="base_schema",
        live_schema="tww_od",
        metadata={
            "source_role": "base",
            "persist_job": False,
        },
    )

    def fail_write(
        **_kwargs,
    ):
        raise RuntimeError(
            "Database write failed."
        )

    monkeypatch.setattr(
        diff_schema_service,
        "write",
        fail_write,
    )

    with pytest.raises(
        RuntimeError,
        match="Database write failed",
    ):
        incremental_service.create_diff_job_from_quarantine(
            job_id="job-1",
            job_mode=DiffJobMode.CREATE,
            source_model="ag96",
            rights_context=rights_context,
            created_models=(
                "Genereller_Entwaesserungsplan_AG",
            ),
            import_schema=(
                "incremental_schema"
            ),
            live_schema="tww_od",
            metadata={
                "source_role": "incremental",
                "persist_job": True,
            },
        )

    prepared = (
        diff_schema_service.prepared_source(
            job_id="job-1",
        )
    )

    assert prepared.source_model == "dss"