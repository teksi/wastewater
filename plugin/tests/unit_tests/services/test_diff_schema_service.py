from __future__ import annotations

from datetime import datetime
from unittest.mock import Mock

import pytest
from teksi_hooks.models.effects import (
    EffectDocument,
)
from teksi_hooks.models.review import (
    PreparedSource,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)


def _effect_document(
    *,
    source: str = "base",
    version: int = 1,
) -> EffectDocument:
    return EffectDocument(
        source=source,
        effects=(),
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


def _prepared_source(
    *,
    source_model: str = "DSS_2020_1_LV95",
    schema: str = "xtf_import",
    version: int = 1,
) -> PreparedSource:
    return PreparedSource(
        source_model=source_model,
        created_models=(source_model,),
        effect_document=_effect_document(
            source=schema,
            version=version,
        ),
        metadata={
            "source_role": "base",
            "source_schema": schema,
            "persist_job": False,
        },
    )


def _service() -> TwwDiffSchemaService:
    return TwwDiffSchemaService(
        connection_factory=Mock(),
    )


def test_diff_schema_service_prepares_and_returns_source() -> None:
    service = _service()

    source = _prepared_source()

    service.prepare_source(
        job_id="job-1",
        source=source,
    )

    result = service.prepared_source(
        job_id="job-1",
    )

    assert result is source


def test_diff_schema_service_preserves_prepared_source_data() -> None:
    service = _service()

    effect_document = _effect_document(
        source="xtf_import",
        version=2,
    )

    source = PreparedSource(
        source_model="DSS_2020_1_LV95",
        created_models=(
            "SIA405_Base_Abwasser_1_LV95",
            "SIA405_ABWASSER_2020_1_LV95",
            "DSS_2020_1_LV95",
        ),
        effect_document=effect_document,
        metadata={
            "source_role": "base",
            "source_schema": "xtf_import",
            "model_group": "dss",
            "model_language": "de",
            "persist_job": False,
        },
    )

    service.prepare_source(
        job_id="job-1",
        source=source,
    )

    result = service.prepared_source(
        job_id="job-1",
    )

    assert result.source_model == "DSS_2020_1_LV95"

    assert result.created_models == (
        "SIA405_Base_Abwasser_1_LV95",
        "SIA405_ABWASSER_2020_1_LV95",
        "DSS_2020_1_LV95",
    )

    assert result.effect_document is effect_document

    assert result.metadata == {
        "source_role": "base",
        "source_schema": "xtf_import",
        "model_group": "dss",
        "model_language": "de",
        "persist_job": False,
    }


def test_diff_schema_service_replaces_source_for_same_job() -> None:
    service = _service()

    first_source = _prepared_source(
        source_model="DSS_2020_1_LV95",
        schema="first_schema",
        version=1,
    )

    replacement_source = _prepared_source(
        source_model="SIA405_ABWASSER_2020_1_LV95",
        schema="replacement_schema",
        version=2,
    )

    service.prepare_source(
        job_id="job-1",
        source=first_source,
    )

    service.prepare_source(
        job_id="job-1",
        source=replacement_source,
    )

    result = service.prepared_source(
        job_id="job-1",
    )

    assert result is replacement_source
    assert result is not first_source


def test_diff_schema_service_keeps_sources_separate_by_job_id() -> None:
    service = _service()

    first_source = _prepared_source(
        source_model="DSS_2020_1_LV95",
        schema="first_schema",
    )

    second_source = _prepared_source(
        source_model="Genereller_Entwaesserungsplan_AG",
        schema="second_schema",
    )

    service.prepare_source(
        job_id="job-1",
        source=first_source,
    )

    service.prepare_source(
        job_id="job-2",
        source=second_source,
    )

    assert (
        service.prepared_source(
            job_id="job-1",
        )
        is first_source
    )

    assert (
        service.prepared_source(
            job_id="job-2",
        )
        is second_source
    )


def test_diff_schema_service_raises_for_missing_prepared_source() -> None:
    service = _service()

    with pytest.raises(
        KeyError,
        match=("No prepared source exists for diff " "workflow 'missing-job'"),
    ):
        service.prepared_source(
            job_id="missing-job",
        )


def test_diff_schema_service_clears_prepared_source() -> None:
    service = _service()

    source = _prepared_source()

    service.prepare_source(
        job_id="job-1",
        source=source,
    )

    service.clear_prepared_source(
        job_id="job-1",
    )

    with pytest.raises(
        KeyError,
        match="No prepared source exists",
    ):
        service.prepared_source(
            job_id="job-1",
        )


def test_diff_schema_service_clear_is_idempotent() -> None:
    service = _service()

    service.clear_prepared_source(
        job_id="missing-job",
    )

    service.clear_prepared_source(
        job_id="missing-job",
    )


def test_diff_schema_service_clears_only_selected_job() -> None:
    service = _service()

    first_source = _prepared_source(
        schema="first_schema",
    )

    second_source = _prepared_source(
        source_model="Genereller_Entwaesserungsplan_AG",
        schema="second_schema",
    )

    service.prepare_source(
        job_id="job-1",
        source=first_source,
    )

    service.prepare_source(
        job_id="job-2",
        source=second_source,
    )

    service.clear_prepared_source(
        job_id="job-1",
    )

    with pytest.raises(
        KeyError,
        match="No prepared source exists",
    ):
        service.prepared_source(
            job_id="job-1",
        )

    assert (
        service.prepared_source(
            job_id="job-2",
        )
        is second_source
    )


def test_diff_schema_service_staging_does_not_use_database() -> None:
    connection_factory = Mock()

    service = TwwDiffSchemaService(
        connection_factory=connection_factory,
    )

    source = _prepared_source()

    service.prepare_source(
        job_id="job-1",
        source=source,
    )

    assert (
        service.prepared_source(
            job_id="job-1",
        )
        is source
    )

    service.clear_prepared_source(
        job_id="job-1",
    )

    connection_factory.connection.assert_not_called()
