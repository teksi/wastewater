import argparse
import sys

from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
    InterlisImporterExporterError,
)


class TeksiWastewaterCmd:
    SUBPARSER_NAME_INTERLIS_IMPORT = "interlis_import"
    SUBPARSER_NAME_INTERLIS_EXPORT = "interlis_export"

    def __init__(self):
        self.parser = argparse.ArgumentParser()
        self.args = None

        subparsers = self.parser.add_subparsers(dest="subparser_name", help="sub-command help")

        self._add_subparser_interlis_import(subparsers=subparsers)
        self._add_subparser_interlis_export(subparsers=subparsers)

    def _add_subparser_interlis_import(self, subparsers):
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_IMPORT, help=f"{self.SUBPARSER_NAME_INTERLIS_IMPORT} help"
        )

        subparser.add_argument(
            "--xtf_file",
            help="XTF input file",
        )

    def _add_subparser_interlis_export(self, subparsers):
        subparser = subparsers.add_parser(
            self.SUBPARSER_NAME_INTERLIS_EXPORT, help=f"{self.SUBPARSER_NAME_INTERLIS_EXPORT} help"
        )

        subparser.add_argument(
            "--xtf_file",
            help="XTF outup file",
        )
        subparser.add_argument(
            "--selection",
            help="if provided, limits the export to networkelements that are provided in the selection (comma separated list of ids)",
        )
        subparser.add_argument(
            "--labels_file",
            help="if provided, includes the label positions in the export (the file should be the results of the provided `tww:extractlabels_interlis` QGIS algorithm as geojson)",
        )

    def parse_arguments(
        self,
    ):
        self.args = self.parser.parse_args()

    def execute(self):
        print(self.args)

        if self.SUBPARSER_NAME_INTERLIS_IMPORT == self.args.subparser_name:
            self.execute_interlis_import()
        elif self.SUBPARSER_NAME_INTERLIS_EXPORT == self.args.subparser_name:
            self.execute_interlis_export()
        else:
            self.parser.print_help(sys.stderr)
            exit(1)

    def execute_interlis_import(self):
        interlisImporterExporter = InterlisImporterExporter()

        try:
            interlisImporterExporter.interlis_import(xtf_file_input=self.args.xtf_file)

            print(f"Data successfully imported from {self.args.xtf_file}")

        except InterlisImporterExporterError as exception:
            print(f"Export error: {exception.error}", file=sys.stderr)
            if exception.additional_text:
                print(f"Additional details: {exception.additional_text}", file=sys.stderr)
            if exception.log_path:
                print(f"Log file: {exception.log_path}", file=sys.stderr)

        except Exception as exception:
            raise exception

    def execute_interlis_export(self):
        interlisImporterExporter = InterlisImporterExporter()

        try:
            interlisImporterExporter.interlis_export(
                xtf_file_output=self.args.xtf_file,
                export_models=[config.MODEL_NAME_DSS],
                logs_next_to_file=True,
            )
            print(f"Data successfully exported to {self.args.xtf_file}")

        except InterlisImporterExporterError as exception:
            print(f"Export error: {exception.error}", file=sys.stderr)
            if exception.additional_text:
                print(f"Additional details: {exception.additional_text}", file=sys.stderr)
            if exception.log_path:
                print(f"Log file: {exception.log_path}", file=sys.stderr)

        except Exception as exception:
            raise exception


if __name__ == "__main__":
    teksi_wastewater_cmd = TeksiWastewaterCmd()

    teksi_wastewater_cmd.parse_arguments()

    if not teksi_wastewater_cmd.args:
        teksi_wastewater_cmd.parser.print_help(sys.stderr)
        exit(1)

    teksi_wastewater_cmd.execute()
