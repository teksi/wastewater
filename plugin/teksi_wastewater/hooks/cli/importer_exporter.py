#!/usr/bin/env python3

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)
from teksi_wastewater.hooks.cli import helpers
from teksi_wastewater.interlis import config, model_config, model_selection
from teksi_wastewater.interlis.interlis_importer_exporter import (
    InterlisImporterExporterError,
)


class TeksiWastewaterCmd:
    SUBPARSER_NAME_INTERLIS_IMPORT = "interlis_import"
    SUBPARSER_NAME_INTERLIS_EXPORT = "interlis_export"

    def __init__(
        self,
    ) -> None:
        self.parser = argparse.ArgumentParser()
        self.args = None

        self.parser.add_argument(
            "--srid",
            default=2056,
            type=int,
            help="SRID for import/export",
        )

        subparsers = self.parser.add_subparsers(
            dest="subparser_name",
            help="sub-command --help",
        )

        self._add_subparser_interlis_import(
            subparsers=subparsers,
        )

        self._add_subparser_interlis_export(
            subparsers=subparsers,
        )

    def _add_subparser_interlis_import(
        self,
        subparsers,
    ) -> None:
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_IMPORT,
            help=(f"{self.SUBPARSER_NAME_INTERLIS_IMPORT} " "--help"),
        )

        subparser.add_argument(
            "--xtf_file",
            help="XTF input file",
            required=True,
        )

        subparser.add_argument(
            "--show_selection_dialog",
            help="Show the object selection dialog at import time",
            action="store_true",
        )

        subparser.add_argument(
            "--incremental_only",
            help="Only import incremental data for non-VSA datamodels",
            action="store_true",
        )

        subparser.add_argument(
            "--logs_next_to_file",
            help="Put log files next to XTF import file",
            action="store_true",
        )

        subparser.add_argument(
            "--filter_nulls",
            action=argparse.BooleanOptionalAction,
            default=True,
            help=("Filter NULL values during import. " "Enabled by default."),
        )

        # subparser.add_argument(
        #     "--schema",
        #     default=config.IMPORT_SCHEMA,
        #     help=(
        #         "ili2pg schema used for the INTERLIS import "
        #         f"(default: {config.IMPORT_SCHEMA})."
        #     ),
        # )

        helpers.add_postgres_connection_args(
            subparser,
        )

    def _add_subparser_interlis_export(
        self,
        subparsers,
    ) -> None:
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_EXPORT,
            help=(f"{self.SUBPARSER_NAME_INTERLIS_EXPORT} " "--help"),
        )

        subparser.add_argument(
            "--xtf_file",
            help="XTF output file",
            required=True,
        )

        subparser.add_argument(
            "--export_model",
            default=model_config.interlis_models["dss"].lang_name(
                "de",
            ),
            choices=sorted(
                model_selection.ALL_SUPPORTED_MODELS,
            ),
            help="Model to export (default: %(default)s)",
        )

        subparser.add_argument(
            "--logs_next_to_file",
            help="Put log files next to XTF output file",
            action="store_true",
        )

        subparser.add_argument(
            "--labels_file",
            help="JSON file containing labeling candidates",
        )

        subparser.add_argument(
            "--label_scale_pipeline_registry_1_1000",
            help=(
                "Export labels at scale 1:1'000 "
                "(Leitungskataster/Cadastre des conduites "
                "souterraines)"
            ),
            action="store_true",
        )

        subparser.add_argument(
            "--label_scale_network_plan_1_250",
            help=("Export labels at scale 1:250 " "(Werkplan/Plan de réseau)"),
            action="store_true",
        )

        subparser.add_argument(
            "--label_scale_network_plan_1_500",
            help=("Export labels at scale 1:500 " "(Werkplan/Plan de réseau)"),
            action="store_true",
        )

        subparser.add_argument(
            "--label_scale_overviewmap_1_10000",
            help=("Export labels at scale 1:10'000 " "(Übersichtsplan/Plan d'ensemble)"),
            action="store_true",
        )

        subparser.add_argument(
            "--label_scale_overviewmap_1_5000",
            help=("Export labels at scale 1:5'000 " "(Übersichtsplan/Plan d'ensemble)"),
            action="store_true",
        )

        subparser.add_argument(
            "--label_scale_overviewmap_1_2000",
            help=("Export labels at scale 1:2'000 " "(Übersichtsplan/Plan d'ensemble)"),
            action="store_true",
        )

        subparser.add_argument(
            "--selected_ids",
            help=("Limit export to comma-separated network-element " "identifiers"),
        )

        # subparser.add_argument(
        #     "--schema",
        #     default=config.EXPORT_SCHEMA,
        #     help=(
        #         "ili2pg schema used for the INTERLIS import "
        #         f"(default: {config.EXPORT_SCHEMA})."
        #     ),
        # )

        helpers.add_postgres_connection_args(
            subparser,
        )

    def parse_arguments(
        self,
    ) -> None:
        self.args = self.parser.parse_args()

    def execute(
        self,
    ) -> None:
        if self.args is None:
            raise RuntimeError("CLI arguments have not been parsed.")

        if self.args.subparser_name == self.SUBPARSER_NAME_INTERLIS_IMPORT:
            self.schema = config.IMPORT_SCHEMA
            self.execute_interlis_import()
            return

        if self.args.subparser_name == self.SUBPARSER_NAME_INTERLIS_EXPORT:
            self.schema = config.EXPORT_SCHEMA
            self.execute_interlis_export()
            return

        self.parser.print_help(
            sys.stderr,
        )

        raise SystemExit(
            1,
        )

    def execute_interlis_import(
        self,
    ) -> None:
        connection_factory = helpers.database_connection_factory(
            self.args,
        )

        service = TwwInterlisServiceAdapter(connection_factory=connection_factory)

        context = TwwInterlisContext(
            schema=self.schema,
            srid=self.args.srid,
            show_selection_dialog=(self.args.show_selection_dialog),
            logs_next_to_file=(self.args.logs_next_to_file),
            filter_nulls=self.args.filter_nulls,
            incremental_only=self.args.incremental_only,
        )

        xtf_file = Path(
            self.args.xtf_file,
        )

        try:
            service.import_xtf(
                xtf_file=xtf_file,
                context=context,
            )
        except InterlisImporterExporterError as exception:
            self._print_interlis_error(
                operation="Import",
                exception=exception,
            )

            raise

        print(f"\nData successfully imported from {xtf_file}")

    def execute_interlis_export(
        self,
    ) -> None:
        connection_factory = helpers.database_connection_factory(
            self.args,
        )

        service = TwwInterlisServiceAdapter(connection_factory=connection_factory)

        selected_ids = (
            tuple(
                selected_id.strip()
                for selected_id in self.args.selected_ids.split(
                    ",",
                )
                if selected_id.strip()
            )
            if self.args.selected_ids
            else ()
        )

        if selected_ids:
            print(f"selected_ids = {selected_ids!r}")
        else:
            print("No selection argument. " "Exporting the whole dataset.")

        labels_file = (
            Path(
                self.args.labels_file,
            )
            if self.args.labels_file
            else None
        )

        context = TwwInterlisContext(
            schema=self.schema,
            srid=self.args.srid,
            logs_next_to_file=(self.args.logs_next_to_file),
            labels_file=labels_file,
            selected_label_scale_indices=tuple(
                self.get_label_scales(),
            ),
            selected_ids=selected_ids,
            limit_to_selection=bool(
                selected_ids,
            ),
        )

        xtf_file = Path(
            self.args.xtf_file,
        )

        try:
            service.export_xtf(
                xtf_file=xtf_file,
                export_models=(self.args.export_model,),
                context=context,
            )
        except InterlisImporterExporterError as exception:
            self._print_interlis_error(
                operation="Export",
                exception=exception,
            )

            raise

        print(f"\nData successfully exported to {xtf_file}")

    def _print_interlis_error(
        self,
        *,
        operation: str,
        exception: InterlisImporterExporterError,
    ) -> None:
        print(
            f"{operation} error: {exception.error}",
            file=sys.stderr,
        )

        if exception.additional_text:
            print(
                f"Additional details: " f"{exception.additional_text}",
                file=sys.stderr,
            )

        if exception.log_path:
            print(
                f"Log file: {exception.log_path}",
                file=sys.stderr,
            )

    def get_label_scales(
        self,
    ) -> list:
        """
        Return selected label scale identifiers.
        """

        available_scales = {
            "pipeline_registry_1_1000": ("Leitungskataster"),
            "network_plan_1_250": "Werkplan.250",
            "network_plan_1_500": "Werkplan.500",
            "overviewmap_1_10000": ("Uebersichtsplan.UeP10"),
            "overviewmap_1_5000": ("Uebersichtsplan.UeP5"),
            "overviewmap_1_2000": ("Uebersichtsplan.UeP2"),
        }

        label_scales = []

        if self.args.label_scale_pipeline_registry_1_1000:
            label_scales.append(available_scales["pipeline_registry_1_1000"])

        if self.args.label_scale_network_plan_1_250:
            label_scales.append(available_scales["network_plan_1_250"])

        if self.args.label_scale_network_plan_1_500:
            label_scales.append(available_scales["network_plan_1_500"])

        if self.args.label_scale_overviewmap_1_10000:
            label_scales.append(available_scales["overviewmap_1_10000"])

        if self.args.label_scale_overviewmap_1_5000:
            label_scales.append(available_scales["overviewmap_1_5000"])

        if self.args.label_scale_overviewmap_1_2000:
            label_scales.append(available_scales["overviewmap_1_2000"])

        return label_scales


def main() -> int:
    command = TeksiWastewaterCmd()

    command.parse_arguments()
    command.execute()

    return 0


if __name__ == "__main__":
    raise SystemExit(
        main(),
    )
