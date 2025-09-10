#!/usr/bin/env python3

import argparse
import sys

from qgis.core import QgsApplication
from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
    InterlisImporterExporterError,
)
from teksi_wastewater.interlis.processing_algs.extractlabels_interlis import (
    ExtractlabelsInterlisAlgorithm,
)
from teksi_wastewater.utils.database_utils import DatabaseUtils

QgsApplication.setPrefixPath("/usr", True)


class TeksiWastewaterCmd:
    SUBPARSER_NAME_INTERLIS_IMPORT = "interlis_import"
    SUBPARSER_NAME_INTERLIS_EXPORT = "interlis_export"

    def __init__(self):
        self.parser = argparse.ArgumentParser()
        self.args = None

        self.parser.add_argument(
            "--qgs_app_prefix_path",
            help="QGIS Application prefix path",
        )

        self.parser.add_argument(
            "--srid",
            default=2056,
            help="SRID for import/export",
        )

        subparsers = self.parser.add_subparsers(dest="subparser_name", help="sub-command --help")

        self._add_subparser_interlis_import(subparsers=subparsers)
        self._add_subparser_interlis_export(subparsers=subparsers)

    def _add_subparser_interlis_import(self, subparsers):
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_IMPORT,
            help=f"{self.SUBPARSER_NAME_INTERLIS_IMPORT} --help",
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
            "--logs_next_to_file",
            help="Put log files next to XTF import file",
            action="store_true",
        )
        subparser.add_argument(
            "--filter_nulls",
            help="Filter out NULL values from import",
            action="store_true",
        )

        self._add_postgres_connection_args(subparser)

    def _add_subparser_interlis_export(self, subparsers):
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_EXPORT,
            help=f"{self.SUBPARSER_NAME_INTERLIS_EXPORT} --help",
        )

        subparser.add_argument("--xtf_file", help="XTF output file", required=True)
        subparser.add_argument(
            "--selection",
            help="if provided, limits the export to networkelements that are provided in the selection (comma separated list of ids)",
        )
        subparser.add_argument(
            "--export_model",
            default=config.MODEL_NAME_DSS,
            choices=[
                config.MODEL_NAME_SIA405_ABWASSER,
                config.MODEL_NAME_SIA405_BASE_ABWASSER,
                config.MODEL_NAME_DSS,
                config.MODEL_NAME_VSA_KEK,
                config.MODEL_NAME_AG96,
                config.MODEL_NAME_AG64,
            ],
            help="Model to export (default:  %(default)s)",
        )
        subparser.add_argument(
            "--logs_next_to_file",
            help="Put log files next to XTF output file",
            action="store_true",
        )
        subparser.add_argument("--labels_file", help="json file containing labeling candidates")
        subparser.add_argument(
            "--label_scale_pipeline_registry_1_1000",
            help="Export labels in scale 1:1'000, can be combined with other scales (Leitungskataster/Cadastre des conduites souterraines)",
            action="store_true",
        )
        subparser.add_argument(
            "--label_scale_network_plan_1_250",
            help="Export labels in scale 1:250, can be combined with other scales (Werkplan/Plan de reseau)",
            action="store_true",
        )
        subparser.add_argument(
            "--label_scale_network_plan_1_500",
            help="Export labels in scale 1:500, can be combined with other scales (Werkplan/Plan de reseau)",
            action="store_true",
        )
        subparser.add_argument(
            "--label_scale_overviewmap_1_10000",
            help="Export labels in scale 1:10'000, can be combined with other scales (Uebersichtsplan/Plan d'ensemble)",
            action="store_true",
        )
        subparser.add_argument(
            "--label_scale_overviewmap_1_5000",
            help="Export labels in scale 1:5'000, can be combined with other scales (Uebersichtsplan/Plan d'ensemble)",
            action="store_true",
        )
        subparser.add_argument(
            "--label_scale_overviewmap_1_2000",
            help="Export labels in scale 1:2'000, can be combined with other scales (Uebersichtsplan/Plan d'ensemble)",
            action="store_true",
        )

        subparser.add_argument(
            "--selected_ids",
            help="If provided, limits the export to networkelements that are provided in the selection (comma separated list of ids)",
        )

        self._add_postgres_connection_args(subparser)

    def _add_postgres_connection_args(self, subparser):
        subparser.add_argument(
            "--pgservice",
            help="Postgres service name",
        )
        subparser.add_argument(
            "--pghost",
            help="Postgres host",
        )
        subparser.add_argument(
            "--pgport",
            help="Postgres port",
        )
        subparser.add_argument(
            "--pgdatabase",
            help="Postgres database",
        )
        subparser.add_argument(
            "--pguser",
            help="Postgres user",
        )
        subparser.add_argument(
            "--pgpass",
            help="Postgres password",
        )

    def parse_arguments(
        self,
    ):
        self.args = self.parser.parse_args()

    def execute(self):
        if self.SUBPARSER_NAME_INTERLIS_IMPORT == self.args.subparser_name:
            self.execute_interlis_import()
        elif self.SUBPARSER_NAME_INTERLIS_EXPORT == self.args.subparser_name:
            self.execute_interlis_export()
        else:
            self.parser.print_help(sys.stderr)
            exit(1)

    def execute_interlis_import(self):
        if self.args.qgs_app_prefix_path:
            QgsApplication.setPrefixPath(self.args.qgs_app_prefix_path, True)
        qgs = QgsApplication([], False)
        qgs.initQgis()

        DatabaseUtils.databaseConfig.PGSERVICE = self.args.pgservice
        DatabaseUtils.databaseConfig.PGHOST = self.args.pghost
        DatabaseUtils.databaseConfig.PGPORT = self.args.pgport
        DatabaseUtils.databaseConfig.PGDATABASE = self.args.pgdatabase
        DatabaseUtils.databaseConfig.PGUSER = self.args.pguser
        DatabaseUtils.databaseConfig.PGPASS = self.args.pgpass

        interlisImporterExporter = InterlisImporterExporter()

        try:
            interlisImporterExporter.interlis_import(
                xtf_file_input=self.args.xtf_file,
                show_selection_dialog=self.args.show_selection_dialog,
                logs_next_to_file=self.args.logs_next_to_file,
                filter_nulls=self.args.filter_nulls,
                srid=self.args.srid,
            )

            print(f"\nData successfully imported from {self.args.xtf_file}")

        except InterlisImporterExporterError as exception:
            print(f"Import error: {exception.error}", file=sys.stderr)
            if exception.additional_text:
                print(f"Additional details: {exception.additional_text}", file=sys.stderr)
            if exception.log_path:
                print(f"Log file: {exception.log_path}", file=sys.stderr)

        except Exception as exception:
            qgs.exitQgis()
            raise exception

        qgs.exitQgis()

    def execute_interlis_export(self):
        if self.args.qgs_app_prefix_path:
            QgsApplication.setPrefixPath(self.args.qgs_app_prefix_path, True)
        qgs = QgsApplication([], False)
        qgs.initQgis()

        DatabaseUtils.databaseConfig.PGSERVICE = self.args.pgservice
        DatabaseUtils.databaseConfig.PGHOST = self.args.pghost
        DatabaseUtils.databaseConfig.PGPORT = self.args.pgport
        DatabaseUtils.databaseConfig.PGDATABASE = self.args.pgdatabase
        DatabaseUtils.databaseConfig.PGUSER = self.args.pguser
        DatabaseUtils.databaseConfig.PGPASS = self.args.pgpass

        label_scales = []
        if self.args.label_scale_pipeline_registry_1_1000:
            label_scales.append(
                ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_PIPELINE_REGISTRY_1_1000
            )
        if self.args.label_scale_network_plan_1_250:
            label_scales.append(ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_NETWORK_PLAN_1_250)
        if self.args.label_scale_network_plan_1_500:
            label_scales.append(ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_NETWORK_PLAN_1_500)
        if self.args.label_scale_overviewmap_1_10000:
            label_scales.append(ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_OVERVIEWMAP_1_10000)
        if self.args.label_scale_overviewmap_1_5000:
            label_scales.append(ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_OVERVIEWMAP_1_5000)
        if self.args.label_scale_overviewmap_1_2000:
            label_scales.append(ExtractlabelsInterlisAlgorithm.AVAILABLE_SCALE_OVERVIEWMAP_1_2000)

        selected_ids = []
        if self.args.selected_ids:
            selected_ids = self.args.selected_ids.split(",")

        interlisImporterExporter = InterlisImporterExporter()
        try:
            interlisImporterExporter.interlis_export(
                xtf_file_output=self.args.xtf_file,
                export_models=[self.args.export_model],
                logs_next_to_file=self.args.logs_next_to_file,
                labels_file=self.args.labels_file,
                selected_labels_scales_indices=label_scales,
                selected_ids=selected_ids,
                srid=self.args.srid,
            )
            print(f"\nData successfully exported to {self.args.xtf_file}")

        except InterlisImporterExporterError as exception:
            print(f"Export error: {exception.error}", file=sys.stderr)
            if exception.additional_text:
                print(f"Additional details: {exception.additional_text}", file=sys.stderr)
            if exception.log_path:
                print(f"Log file: {exception.log_path}", file=sys.stderr)

        except Exception as exception:
            qgs.exitQgis()
            raise exception

        qgs.exitQgis()


if __name__ == "__main__":
    teksi_wastewater_cmd = TeksiWastewaterCmd()

    teksi_wastewater_cmd.parse_arguments()

    if not teksi_wastewater_cmd.args:
        teksi_wastewater_cmd.parser.print_help(sys.stderr)
        exit(1)

    teksi_wastewater_cmd.execute()
