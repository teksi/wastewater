from __future__ import annotations

from pathlib import Path

import pytest
from teksi_hooks.exceptions import (
    Severity,
)
from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
)
from teksi_wastewater.hooks.adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from teksi_wastewater.hooks.exceptions import (
    QuarantineValidationError,
)


class FakeInterlisImporterExporter:
    def __init__(
        self,
    ) -> None:
        self.schema = None
        self.import_to_quarantine_calls = []
        self.find_import_ilimodels_calls = []
        self.import_from_quarantine_to_live_calls = []
        self.export_live_to_quarantine_calls = []
        self.export_from_quarantine_to_xtf_calls = []

    def interlis_import_to_quarantine(
        self,
        **kwargs,
    ):
        self.import_to_quarantine_calls.append(
            kwargs,
        )

        return (
            "SIA405_ABWASSER_2020",
            [
                "SIA405_ABWASSER_2020",
                "SIA405_BASE_ABWASSER_2020",
            ],
        )

    def find_import_ilimodels(
        self,
        xtf_file_input,
    ):
        self.find_import_ilimodels_calls.append(
            xtf_file_input,
        )

        return (
            "SIA405_ABWASSER_2020",
            (
                "SIA405_ABWASSER_2020",
                "SIA405_BASE_ABWASSER_2020",
            ),
        )

    def interlis_import_from_quarantine_to_live(
        self,
        **kwargs,
    ) -> None:
        self.import_from_quarantine_to_live_calls.append(
            kwargs,
        )

    def interlis_export_live_to_quarantine(
        self,
        **kwargs,
    ) -> None:
        self.export_live_to_quarantine_calls.append(
            kwargs,
        )

    def interlis_export_from_quarantine_to_xtf(
        self,
        **kwargs,
    ) -> None:
        self.export_from_quarantine_to_xtf_calls.append(
            kwargs,
        )


class FakeInterlisTools:
    def __init__(
        self,
        *,
        should_fail: bool = False,
    ) -> None:
        self.should_fail = should_fail
        self.validate_db_data_calls = []

    def validate_db_data(
        self,
        **kwargs,
    ) -> None:
        self.validate_db_data_calls.append(
            kwargs,
        )

        if self.should_fail:
            raise RuntimeError("Validation failed.")


def test_import_xtf_to_quarantine_delegates_to_importer() -> None:
    importer = FakeInterlisImporterExporter()

    runner = TwwQuarantineRunner(
        importer_exporter=importer,
        interlis_tools=FakeInterlisTools(),
    )

    import_model, created_models = runner.import_xtf_to_quarantine(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
        context=TwwInterlisContext(
            schema="ignored_schema",
            srid=2056,
            logs_next_to_file=True,
            filter_nulls=True,
            import_orgs=True,
            orgs_path=Path(
                "/tmp/orgs.xtf",
            ),
        ),
        schema="import_schema",
    )

    assert importer.schema == "import_schema"

    assert import_model == "SIA405_ABWASSER_2020"

    assert created_models == (
        "SIA405_ABWASSER_2020",
        "SIA405_BASE_ABWASSER_2020",
    )

    assert importer.import_to_quarantine_calls == [
        {
            "xtf_file_input": "/tmp/input.xtf",
            "logs_next_to_file": True,
            "filter_nulls": True,
            "srid": 2056,
            "import_orgs": True,
            "orgs_path": Path(
                "/tmp/orgs.xtf",
            ),
        }
    ]


def test_import_xtf_to_quarantine_uses_default_context() -> None:
    importer = FakeInterlisImporterExporter()

    runner = TwwQuarantineRunner(
        importer_exporter=importer,
        interlis_tools=FakeInterlisTools(),
    )

    runner.import_xtf_to_quarantine(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
        schema="import_schema",
    )

    assert importer.schema == "import_schema"

    assert importer.import_to_quarantine_calls == [
        {
            "xtf_file_input": "/tmp/input.xtf",
            "logs_next_to_file": False,
            "filter_nulls": True,
            "srid": 2056,
            "import_orgs": False,
            "orgs_path": None,
        }
    ]


def test_import_quarantine_to_live_validates_then_imports() -> None:
    importer = FakeInterlisImporterExporter()
    tools = FakeInterlisTools()

    runner = TwwQuarantineRunner(
        importer_exporter=importer,
        interlis_tools=tools,
    )

    runner.import_quarantine_to_live(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
        context=TwwInterlisContext(
            schema="ignored_schema",
            srid=2056,
            logs_next_to_file=True,
            filter_nulls=True,
            show_selection_dialog=True,
        ),
        validation_log_path=Path(
            "/tmp/validation.log",
        ),
        schema="import_schema",
    )

    assert importer.schema == "import_schema"

    assert importer.find_import_ilimodels_calls == [
        "/tmp/input.xtf",
    ]

    assert tools.validate_db_data_calls == [
        {
            "schema": "import_schema",
            "model_name": "SIA405_ABWASSER_2020",
            "log_path": "/tmp/validation_SIA405_ABWASSER_2020.log",
            "srid": 2056,
        }
    ]

    assert importer.import_from_quarantine_to_live_calls == [
        {
            "import_model": "SIA405_ABWASSER_2020",
            "created_models": (
                "SIA405_ABWASSER_2020",
                "SIA405_BASE_ABWASSER_2020",
            ),
            "logs_next_to_file": True,
            "filter_nulls": True,
            "srid": 2056,
            "show_selection_dialog": True,
        }
    ]


def test_export_live_to_quarantine_delegates_to_importer() -> None:
    importer = FakeInterlisImporterExporter()

    runner = TwwQuarantineRunner(
        importer_exporter=importer,
        interlis_tools=FakeInterlisTools(),
    )

    runner.export_live_to_quarantine(
        xtf_file=Path(
            "/tmp/output.xtf",
        ),
        export_models=("SIA405_ABWASSER_2020",),
        context=TwwInterlisContext(
            schema="ignored_schema",
            srid=2056,
            logs_next_to_file=True,
            labels_file=Path(
                "/tmp/labels.xtf",
            ),
            selected_label_scale_indices=(
                "1000",
                "5000",
            ),
            selected_ids=("ch000000ws000001",),
            import_orgs=True,
        ),
        schema="export_schema",
    )

    assert importer.schema == "export_schema"

    assert importer.export_live_to_quarantine_calls == [
        {
            "xtf_file_output": "/tmp/output.xtf",
            "export_models": ("SIA405_ABWASSER_2020",),
            "logs_next_to_file": True,
            "limit_to_selection": False,
            "export_orientation": 90,
            "labels_file": "/tmp/labels.xtf",
            "selected_labels_scales_indices": [
                "1000",
                "5000",
            ],
            "selected_ids": [
                "ch000000ws000001",
            ],
            "include_unplaced": False,
            "import_orgs": True,
        }
    ]


def test_export_quarantine_to_xtf_validates_then_exports() -> None:
    importer = FakeInterlisImporterExporter()
    tools = FakeInterlisTools()

    runner = TwwQuarantineRunner(
        importer_exporter=importer,
        interlis_tools=tools,
    )

    runner.export_quarantine_to_xtf(
        xtf_file=Path(
            "/tmp/output.xtf",
        ),
        export_models=(
            "SIA405_ABWASSER_2020",
            "VSADSSMINI_2020",
        ),
        context=TwwInterlisContext(
            schema="ignored_schema",
            srid=2056,
            logs_next_to_file=True,
        ),
        validation_log_path=Path(
            "/tmp/export_validation.log",
        ),
        schema="export_schema",
    )

    assert importer.schema == "export_schema"

    assert tools.validate_db_data_calls == [
        {
            "schema": "export_schema",
            "model_name": "SIA405_ABWASSER_2020",
            "log_path": "/tmp/export_validation_SIA405_ABWASSER_2020.log",
            "srid": 2056,
        },
        {
            "schema": "export_schema",
            "model_name": "VSADSSMINI_2020",
            "log_path": "/tmp/export_validation_VSADSSMINI_2020.log",
            "srid": 2056,
        },
    ]

    assert importer.export_from_quarantine_to_xtf_calls == [
        {
            "xtf_file_output": "/tmp/output.xtf",
            "export_models": (
                "SIA405_ABWASSER_2020",
                "VSADSSMINI_2020",
            ),
            "logs_next_to_file": True,
        }
    ]


def test_validate_quarantine_returns_empty_tuple_on_success(
    tmp_path,
) -> None:
    tools = FakeInterlisTools()

    runner = TwwQuarantineRunner(
        importer_exporter=FakeInterlisImporterExporter(),
        interlis_tools=tools,
    )

    findings = runner.validate_quarantine(
        model_names=("SIA405_ABWASSER_2020",),
        log_path=tmp_path / "validation.log",
        srid=2056,
        schema="import_schema",
    )

    assert findings == ()

    assert tools.validate_db_data_calls == [
        {
            "schema": "import_schema",
            "model_name": "SIA405_ABWASSER_2020",
            "log_path": str(
                tmp_path / "validation_SIA405_ABWASSER_2020.log",
            ),
            "srid": 2056,
        }
    ]


def test_validate_quarantine_extracts_findings_from_log(
    tmp_path,
) -> None:
    tools = FakeInterlisTools(
        should_fail=True,
    )

    runner = TwwQuarantineRunner(
        importer_exporter=FakeInterlisImporterExporter(),
        interlis_tools=tools,
    )

    model_log_path = tmp_path / "validation_SIA405_ABWASSER_2020.log"

    model_log_path.write_text(
        "\n".join(
            [
                "Info: harmless message",
                "Error: geometry is invalid",
                "Validation failed for object",
            ]
        ),
        encoding="utf-8",
    )

    findings = runner.validate_quarantine(
        model_names=("SIA405_ABWASSER_2020",),
        log_path=tmp_path / "validation.log",
        srid=2056,
        schema="import_schema",
    )

    assert (
        len(
            findings,
        )
        == 2
    )

    assert {finding.message for finding in findings} == {
        "Error: geometry is invalid",
        "Validation failed for object",
    }

    assert all(finding.severity == Severity.ERROR for finding in findings)


def test_validate_quarantine_falls_back_to_exception_message_when_log_is_empty(
    tmp_path,
) -> None:
    tools = FakeInterlisTools(
        should_fail=True,
    )

    runner = TwwQuarantineRunner(
        importer_exporter=FakeInterlisImporterExporter(),
        interlis_tools=tools,
    )

    findings = runner.validate_quarantine(
        model_names=("SIA405_ABWASSER_2020",),
        log_path=tmp_path / "validation.log",
        srid=2056,
        schema="import_schema",
    )

    assert (
        len(
            findings,
        )
        == 1
    )

    assert findings[0].code == "quarantine_validation_failed"
    assert findings[0].severity == Severity.ERROR
    assert findings[0].message == "Validation failed."


def test_validate_quarantine_or_raise_raises_on_error(
    tmp_path,
) -> None:
    tools = FakeInterlisTools(
        should_fail=True,
    )

    runner = TwwQuarantineRunner(
        importer_exporter=FakeInterlisImporterExporter(),
        interlis_tools=tools,
    )

    with pytest.raises(
        QuarantineValidationError,
    ):
        runner.validate_quarantine_or_raise(
            model_names=("SIA405_ABWASSER_2020",),
            log_path=tmp_path / "validation.log",
            srid=2056,
            schema="import_schema",
        )


def test_log_path_for_model_sanitizes_model_name() -> None:
    runner = TwwQuarantineRunner(
        importer_exporter=FakeInterlisImporterExporter(),
        interlis_tools=FakeInterlisTools(),
    )

    path = runner._log_path_for_model(
        log_path=Path(
            "/tmp/validation.log",
        ),
        model_name="Model.Name: With/Separators",
    )

    assert path == Path(
        "/tmp/validation_Model_Name__With_Separators.log",
    )
