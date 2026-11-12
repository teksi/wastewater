from __future__ import annotations

from pathlib import Path
from types import SimpleNamespace
from unittest.mock import Mock

import pytest
from teksi_hooks.exceptions import DiffJobEligibilityError

from teksi_wastewater.hooks.services.tww_persistence_context_factory import (
    TwwPersistenceContextFactory,
)


def _factory() -> TwwPersistenceContextFactory:
    return TwwPersistenceContextFactory(
        model_config_dir=Path("/model"),
        quarantine_classes_factory=Mock(),
        logger=Mock(),
    )


def _metadata(role: str) -> dict[str, str]:
    return {
        f"{role}_import_schema": f"schema_{role}",
        f"{role}_source_model": f"model_{role}",
        f"{role}_mapping_model_id": f"mapping_{role}",
        f"{role}_model_language": "de",
        f"{role}_model_group": role,
    }


def test_source_descriptor_requires_complete_role_specific_metadata() -> None:
    job = SimpleNamespace(
        job_id="job",
        metadata={"base_import_schema": "schema"},
    )
    with pytest.raises(DiffJobEligibilityError):
        _factory()._source_descriptor(
            job=job,
            source_role="base",
        )


def test_absent_incremental_descriptor_is_optional() -> None:
    job = SimpleNamespace(job_id="job", metadata=_metadata("base"))
    assert _factory()._source_descriptor(
        job=job,
        source_role="incremental",
    ) is None


def test_source_descriptors_preserve_base_incremental_order() -> None:
    factory = _factory()
    job = SimpleNamespace(job_id="job", metadata={**_metadata("base"), **_metadata("incremental")})
    descriptors = tuple(factory._source_descriptor(job=job, source_role=role) for role in ("base", "incremental"))
    assert tuple(item["source_role"] for item in descriptors) == ("base", "incremental")

def test_context_factory_rejects_missing_sessions() -> None:
    with pytest.raises(RuntimeError, match="no quarantine session"):
        _factory()._assert_session_context(
            SimpleNamespace(quarantine=None, live=object()),
        )
