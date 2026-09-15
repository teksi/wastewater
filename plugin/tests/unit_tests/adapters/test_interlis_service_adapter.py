from __future__ import annotations

from pathlib import Path

from teksi_hooks.services.interlis import (
    InterlisContext,
)

from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)
from teksi_wastewater.interlis import model_config
from ..helpers import (
    FakeConnectionFactory,
)


class FakeInterlisImporterExporter:
    def __init__(
        self,
    ) -> None:
        self.schema = None
        self.import_calls = []
        self.export_calls = []
        self.identify_import_model_calls = []

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

    def find_import_ilimodels(
        self,
        **kwargs,
    ):
        self.find_import_ilimodels_calls.append(
            kwargs,
        )

        return (
            "SIA405_ABWASSER_2020_1_LV95",
            (
                "SIA405_ABWASSER_2020_1_LV95",
            ),
        )
def _adapter(
) -> tuple[
    TwwInterlisServiceAdapter,
    FakeInterlisImporterExporter,
    FakeConnectionFactory,
]:
    importer_exporter = (
        FakeInterlisImporterExporter()
    )

    connection_factory = (
        FakeConnectionFactory()
    )

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

    assert (
        "disable_validation"
        not in fake.import_calls[0]
    )

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
        }
    ]


def test_interlis_service_adapter_delegates_export_with_generic_context() -> None:
    adapter, fake, _ = _adapter()

    adapter.export_xtf(
        xtf_file=Path(
            "/tmp/output.xtf",
        ),
        export_models=(
            "SIA405_ABWASSER_2020_1_LV95",
        ),
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
        export_models=(
            "SIA405_ABWASSER_2020_1_LV95",
        ),
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
    adapter, fake, _ = _adapter()

    result = adapter.find_models(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
    )

    assert (
        fake.identify_import_model_calls
        == [
            {
                "xtf_file_input": Path(
                    "/tmp/input.xtf",
                ),
            }
        ]
    )

    assert result == (
        "SIA405_ABWASSER_2020_1_LV95",
        (
            "SIA405_Base_Abwasser_1_LV95",
            "SIA405_ABWASSER_2020_1_LV95",
        ),
    )

def test_interlis_service_adapter_identifies_model() -> None:
    adapter, fake, _ = _adapter()

    selection = adapter.identify_model(
        xtf_file=Path(
            "/tmp/input.xtf",
        ),
    )

    assert (
        fake.identify_import_model_calls
        == [
            {
                "xtf_file_input": Path(
                    "/tmp/input.xtf",
                ),
            }
        ]
    )

    assert selection.group == (
        "sia405_abwasser"
    )
    assert selection.language == "de"
    assert selection.import_model == (
        "SIA405_ABWASSER_2020_1_LV95"
    )
    assert selection.created_models == (
        "SIA405_Base_Abwasser_1_LV95",
        "SIA405_ABWASSER_2020_1_LV95",
    )