from __future__ import annotations

from pathlib import Path

from teksi_hooks.services.interlis import (
    InterlisContext,
)
from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)
from teksi_wastewater.interlis.model_config import (
    TwwInterlisModelComponent,
    TwwInterlisModelSelection,
    interlis_models,
)

from ..helpers import (
    FakeConnectionFactory,
)


def _model_selection() -> TwwInterlisModelSelection:
    return TwwInterlisModelSelection(
        group="dss",
        language="de",
        imported_models=("DSS_2020_1_LV95",),
        components=(
            TwwInterlisModelComponent(
                group="sia405_base_abwasser",
                language="de",
                model_name=("SIA405_Base_Abwasser_1_LV95"),
                configuration=interlis_models["sia405_base_abwasser"],
            ),
            TwwInterlisModelComponent(
                group="sia405_abwasser",
                language="de",
                model_name=("SIA405_ABWASSER_2020_1_LV95"),
                configuration=interlis_models["sia405_abwasser"],
            ),
            TwwInterlisModelComponent(
                group="dss",
                language="de",
                model_name="DSS_2020_1_LV95",
                configuration=interlis_models["dss"],
            ),
        ),
    )


class FakeInterlisImporterExporter:
    def __init__(
        self,
        *,
        model_selection: TwwInterlisModelSelection | None = None,
    ) -> None:
        self.schema = None

        self.model_selection = model_selection

        self.import_calls: list[
            dict[
                str,
                Any,
            ]
        ] = []

        self.export_calls: list[
            dict[
                str,
                Any,
            ]
        ] = []

        self.identify_import_model_calls: list[
            dict[
                str,
                Any,
            ]
        ] = []

    def interlis_import(
        self,
        **kwargs,
    ) -> None:
        self.import_calls.append(
            kwargs,
        )

    def interlis_export(
        self,
        **kwargs,
    ) -> None:
        self.export_calls.append(
            kwargs,
        )

    def identify_import_model(
        self,
        *,
        xtf_file_input: Path,
    ) -> TwwInterlisModelSelection:
        self.identify_import_model_calls.append(
            {
                "xtf_file_input": xtf_file_input,
            }
        )

        if self.model_selection is None:
            raise RuntimeError("No model selection is configured for this fake.")

        return self.model_selection


def _adapter() -> tuple[
    TwwInterlisServiceAdapter,
    FakeInterlisImporterExporter,
    FakeConnectionFactory,
]:
    importer_exporter = FakeInterlisImporterExporter()

    connection_factory = FakeConnectionFactory()

    adapter = TwwInterlisServiceAdapter(
        importer_exporter=importer_exporter,
        connection_factory=connection_factory,
    )

    return (
        adapter,
        importer_exporter,
        connection_factory,
    )


def test_interlis_service_adapter_imports() -> None:
    assert TwwInterlisServiceAdapter is not None


def test_interlis_service_adapter_delegates_import_with_generic_context() -> None:
    adapter, fake, _ = _adapter()

    adapter.import_xtf(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
        context=InterlisContext(
            schema="test",
        ),
    )

    assert fake.schema == "test"

    assert fake.import_calls == [
        {
            "xtf_file_input": Path(
                "/tmp/input.xtf",
            ),
        }
    ]


def test_interlis_service_adapter_delegates_import_with_tww_context() -> None:
    adapter, fake, _ = _adapter()

    adapter.import_xtf(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
        context=TwwInterlisContext(
            schema="import_schema",
            srid=2056,
            logs_next_to_file=True,
            show_selection_dialog=True,
            filter_nulls=True,
            import_orgs=False,
            disable_validation=True,
        ),
    )

    assert fake.schema == "import_schema"

    assert "disable_validation" not in fake.import_calls[0]

    assert fake.import_calls == [
        {
            "xtf_file_input": Path(
                "/tmp/input.xtf",
            ),
            "show_selection_dialog": True,
            "logs_next_to_file": True,
            "filter_nulls": True,
            "import_orgs": False,
            "srid": 2056,
            "incremental_only": False,
        }
    ]


def test_interlis_service_adapter_delegates_export_with_generic_context() -> None:
    adapter, fake, _ = _adapter()

    adapter.export_xtf(
        xtf_file=Path(
            "/tmp/output.xtf",
        ),
        export_models=("SIA405_ABWASSER_2020_1_LV95",),
        context=InterlisContext(
            schema="export_schema",
        ),
    )

    assert fake.schema == "export_schema"

    assert fake.export_calls == [
        {
            "xtf_file_output": Path(
                "/tmp/output.xtf",
            ),
            "export_models": [
                "SIA405_ABWASSER_2020_1_LV95",
            ],
        }
    ]


def test_interlis_service_adapter_delegates_export_with_tww_context() -> None:
    adapter, fake, _ = _adapter()

    adapter.export_xtf(
        xtf_file=Path(
            "/tmp/output.xtf",
        ),
        export_models=(
            "SIA405_ABWASSER_2020_1_LV95",
            "DSS_2020_1_LV95",
        ),
        context=TwwInterlisContext(
            schema="export_schema",
            srid=2056,
            logs_next_to_file=True,
            labels_file=Path(
                "/tmp/labels.xtf",
            ),
            selected_label_scale_indices=(
                "1000",
                "5000",
            ),
            selected_ids=(
                "ch000000ws000001",
                "ch000000ws000002",
            ),
        ),
    )

    assert fake.schema == "export_schema"

    assert fake.export_calls == [
        {
            "xtf_file_output": Path(
                "/tmp/output.xtf",
            ),
            "export_models": [
                "SIA405_ABWASSER_2020_1_LV95",
                "DSS_2020_1_LV95",
            ],
            "logs_next_to_file": True,
            "labels_file": Path(
                "/tmp/labels.xtf",
            ),
            "limit_to_selection": False,
            "selected_labels_scales_indices": [
                "1000",
                "5000",
            ],
            "selected_ids": [
                "ch000000ws000001",
                "ch000000ws000002",
            ],
            "srid": 2056,
            "import_orgs": False,
        }
    ]


def test_interlis_service_adapter_delegates_export_without_output_file() -> None:
    adapter, fake, _ = _adapter()

    adapter.export_xtf(
        xtf_file=None,
        export_models=("SIA405_ABWASSER_2020_1_LV95",),
        context=TwwInterlisContext(
            schema="export_schema",
        ),
    )

    assert fake.schema == "export_schema"

    assert fake.export_calls == [
        {
            "xtf_file_output": None,
            "export_models": [
                "SIA405_ABWASSER_2020_1_LV95",
            ],
            "logs_next_to_file": False,
            "labels_file": None,
            "limit_to_selection": False,
            "selected_labels_scales_indices": [],
            "selected_ids": [],
            "srid": 2056,
            "import_orgs": False,
        }
    ]


def test_interlis_service_adapter_finds_models() -> None:
    selection = _model_selection()

    importer_exporter = FakeInterlisImporterExporter(
        model_selection=selection,
    )

    adapter = TwwInterlisServiceAdapter(
        importer_exporter=importer_exporter,
        connection_factory=FakeConnectionFactory(),
    )

    xtf_file = Path(
        "/tmp/input.xtf",
    )

    result = adapter.find_models(
        xtf_file,
    )

    assert result == (
        "DSS_2020_1_LV95",
        (
            "SIA405_Base_Abwasser_1_LV95",
            "SIA405_ABWASSER_2020_1_LV95",
            "DSS_2020_1_LV95",
        ),
    )

    assert importer_exporter.identify_import_model_calls == [
        {
            "xtf_file_input": xtf_file,
        }
    ]


def test_interlis_service_adapter_identifies_model() -> None:
    selection = _model_selection()

    importer_exporter = FakeInterlisImporterExporter(
        model_selection=selection,
    )

    adapter = TwwInterlisServiceAdapter(
        importer_exporter=importer_exporter,
        connection_factory=FakeConnectionFactory(),
    )

    xtf_file = Path(
        "/tmp/input.xtf",
    )

    result = adapter.identify_model(
        xtf_file,
    )

    assert result is selection

    assert importer_exporter.identify_import_model_calls == [
        {
            "xtf_file_input": xtf_file,
        }
    ]
