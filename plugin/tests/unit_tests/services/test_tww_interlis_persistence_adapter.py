# tests/unit/hooks/adapters/test_tww_interlis_persistence_adapter.py

from __future__ import annotations

from unittest.mock import Mock, patch

import pytest

from teksi_wastewater.hooks.adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from teksi_wastewater.hooks.exceptions import (
    DiffJobPersistenceError,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwInterlisPersistenceResult,
)


def _selection(
    *,
    groups: tuple[
        str,
        ...,
    ] = (
        "sia405_base_abwasser",
        "sia405_abwasser",
        "dss",
    ),
):
    selection = Mock()
    selection.groups = groups

    return selection


def _adapter():
    importer_exporter = Mock()

    importer_exporter.schema = "previous_schema"
    importer_exporter.srid = 2056

    adapter = TwwInterlisPersistenceAdapter(
        importer_exporter=importer_exporter,
    )

    return (
        adapter,
        importer_exporter,
    )


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_imports_non_agxx_model(
    model_selection_for_imported_models,
) -> None:
    model_selection = _selection()

    model_selection_for_imported_models.return_value = (
        model_selection
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    result = adapter.persist_quarantine(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    assert result == TwwInterlisPersistenceResult(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
        committed=True,
    )

    model_selection_for_imported_models.assert_called_once_with(
        "DSS_2020_1_LV95",
    )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_called_once_with(
        selection_models=model_selection,
        show_selection_dialog=False,
        logs_next_to_file=False,
        filter_nulls=True,
        srid=2056,
        incremental_only=False,
    )


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_uses_import_schema_during_import(
    model_selection_for_imported_models,
) -> None:
    model_selection_for_imported_models.return_value = (
        _selection()
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    observed_schemas = []

    def import_from_quarantine(
        **_,
    ) -> None:
        observed_schemas.append(
            importer_exporter.schema,
        )

    importer_exporter.interlis_import_from_quarantine_to_live.side_effect = (
        import_from_quarantine
    )

    adapter.persist_quarantine(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    assert observed_schemas == [
        "xtf_import",
    ]


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_restores_previous_schema_after_success(
    model_selection_for_imported_models,
) -> None:
    model_selection_for_imported_models.return_value = (
        _selection()
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    adapter.persist_quarantine(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    assert importer_exporter.schema == "previous_schema"


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_restores_previous_schema_after_failure(
    model_selection_for_imported_models,
) -> None:
    model_selection_for_imported_models.return_value = (
        _selection()
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    importer_exporter.interlis_import_from_quarantine_to_live.side_effect = (
        RuntimeError(
            "Importer failed.",
        )
    )

    with pytest.raises(
        DiffJobPersistenceError,
        match="Importer failed",
    ):
        adapter.persist_quarantine(
            import_schema="xtf_import",
            live_schema="tww_od",
            source_model="DSS_2020_1_LV95",
        )

    assert importer_exporter.schema == "previous_schema"


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_forces_filter_nulls(
    model_selection_for_imported_models,
) -> None:
    model_selection = _selection()

    model_selection_for_imported_models.return_value = (
        model_selection
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    adapter.persist_quarantine(
        import_schema="xtf_import",
        live_schema="tww_od",
        source_model="DSS_2020_1_LV95",
    )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_called_once_with(
        selection_models=model_selection,
        show_selection_dialog=False,
        logs_next_to_file=False,
        filter_nulls=True,
        srid=2056,
        incremental_only=False,
    )


@pytest.mark.parametrize(
    (
        "parameter_name",
        "import_schema",
        "live_schema",
        "source_model",
    ),
    [
        (
            "import_schema",
            "",
            "tww_od",
            "DSS_2020_1_LV95",
        ),
        (
            "import_schema",
            " ",
            "tww_od",
            "DSS_2020_1_LV95",
        ),
        (
            "live_schema",
            "xtf_import",
            "",
            "DSS_2020_1_LV95",
        ),
        (
            "source_model",
            "xtf_import",
            "tww_od",
            "",
        ),
    ],
)
def test_persist_quarantine_rejects_empty_parameters(
    parameter_name: str,
    import_schema: str,
    live_schema: str,
    source_model: str,
) -> None:
    (
        adapter,
        importer_exporter,
    ) = _adapter()

    with pytest.raises(
        DiffJobPersistenceError,
        match=parameter_name,
    ):
        adapter.persist_quarantine(
            import_schema=import_schema,
            live_schema=live_schema,
            source_model=source_model,
        )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_not_called()


def test_persist_quarantine_rejects_unsupported_live_schema(
) -> None:
    (
        adapter,
        importer_exporter,
    ) = _adapter()

    with pytest.raises(
        DiffJobPersistenceError,
        match="only supports live schema",
    ):
        adapter.persist_quarantine(
            import_schema="xtf_import",
            live_schema="custom_live",
            source_model="DSS_2020_1_LV95",
        )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_not_called()


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_wraps_model_selection_failure(
    model_selection_for_imported_models,
) -> None:
    model_selection_for_imported_models.side_effect = (
        LookupError(
            "Unknown model.",
        )
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    with pytest.raises(
        DiffJobPersistenceError,
        match="Could not resolve the INTERLIS model selection",
    ):
        adapter.persist_quarantine(
            import_schema="xtf_import",
            live_schema="tww_od",
            source_model="UnknownModel",
        )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_not_called()


@pytest.mark.parametrize(
    "groups",
    [
        (
            "ag64",
        ),
        (
            "ag96",
        ),
    ],
)
@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_rejects_agxx_until_incremental_import_exists(
    model_selection_for_imported_models,
    groups: tuple[
        str,
        ...,
    ],
) -> None:
    model_selection_for_imported_models.return_value = (
        _selection(
            groups=groups,
        )
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    with pytest.raises(
        DiffJobPersistenceError,
        match="AGXX quarantine persistence is not implemented",
    ):
        adapter.persist_quarantine(
            import_schema="xtf_import_incr",
            live_schema="tww_od",
            source_model="Genereller_Entwaesserungsplan_AG",
        )

    importer_exporter.interlis_import_from_quarantine_to_live.assert_not_called()


@patch(
    "teksi_wastewater.hooks.adapters."
    "tww_interlis_persistence_adapter."
    "model_selection_for_imported_models"
)
def test_persist_quarantine_wraps_importer_failure(
    model_selection_for_imported_models,
) -> None:
    model_selection_for_imported_models.return_value = (
        _selection()
    )

    (
        adapter,
        importer_exporter,
    ) = _adapter()

    importer_exporter.interlis_import_from_quarantine_to_live.side_effect = (
        RuntimeError(
            "SQLAlchemy commit failed.",
        )
    )

    with pytest.raises(
        DiffJobPersistenceError,
        match="SQLAlchemy commit failed",
    ) as exception_info:
        adapter.persist_quarantine(
            import_schema="xtf_import",
            live_schema="tww_od",
            source_model="DSS_2020_1_LV95",
        )

    assert exception_info.value.__cause__ is not None
    assert importer_exporter.schema == "previous_schema"