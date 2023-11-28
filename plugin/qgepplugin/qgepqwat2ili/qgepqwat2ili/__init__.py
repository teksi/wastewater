import argparse
import sys
from logging import INFO, FileHandler, Formatter

from . import config, utils
from .qgep.export import qgep_export
from .qgep.import_ import qgep_import
from .qgep.mapping import get_qgep_mapping
from .qgep.model_abwasser import Base as BaseAbwasser
from .qgep.model_qgep import Base as BaseQgep
from .qwat.export import qwat_export
from .qwat.import_ import qwat_import
from .qwat.mapping import get_qwat_mapping
from .qwat.model_qwat import Base as BaseQwat
from .qwat.model_wasser import Base as BaseWasser
from .utils.various import make_log_path


def main(args):

    parser = argparse.ArgumentParser(
        description="ili2QWAT / ili2QGEP entrypoint", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    subparsers = parser.add_subparsers(title="subcommands", dest="parser")
    # subparsers.required = True

    parser_qgep = subparsers.add_parser(
        "qgep",
        help="import/export QGEP datamodel",
        description="ili2QGEP entrypoint",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    # group = parser_qgep.add_mutually_exclusive_group(required=True)
    parser_qgep.add_argument("direction", choices=["import", "export"])
    parser_qgep.add_argument(
        "--selection",
        help="if provided, limits the export to networkelements that are provided in the selection (comma separated list of ids)",
    )
    # TODO: this only makes sense for export
    parser_qgep.add_argument(
        "--labels_file",
        help="if provided, includes the label positions in the export (the file should be the results of the provided `qgep:extractlabels_interlis` QGIS algorithm as geojson)",
    )
    parser_qgep.add_argument(
        "--recreate_schema", action="store_true", help="drops schema and reruns ili2pg importschema"
    )
    parser_qgep.add_argument(
        "--skip_validation",
        action="store_true",
        help="skips running ilivalidator on input/output xtf (required to import invalid files, invalid outputs are still generated)",
    )
    parser_qgep.add_argument("path", help="path to the input/output .xtf file")
    parser_qgep.add_argument(
        "--pgservice",
        help="name of the pgservice to use to connect to the database",
        default=config.QGEP_DEFAULT_PGSERVICE,
    )
    parser_qgep.add_argument(
        "--log",
        action="store_true",
        help="saves the log files next to the input/output file",
    )
    parser_qgep.add_argument(
        "--export_sia405",
        action="store_true",
        help="export the model SIA405_ABWASSER_2015_LV95 (instead of default VSA_KEK_2019_LV95)",
    )

    parser_qwat = subparsers.add_parser(
        "qwat",
        help="import/export QWAT datamodel",
        description="ili2QWAT entrypoint",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser_qwat.add_argument("direction", choices=["import", "export"])
    parser_qwat.add_argument(
        "--include_hydraulics",
        action="store_true",
        help="if provided, exports will include hydraulischer_strang and hydraulischer_node classes (these are currently likely to make the export invalid due to issues with the current ili model)",
    )
    parser_qwat.add_argument(
        "--recreate_schema", action="store_true", help="drops schema and reruns ili2pg importschema"
    )
    parser_qwat.add_argument(
        "--skip_validation",
        action="store_true",
        help="skips running ilivalidator on input/output xtf (required to import invalid files, invalid outputs are still generated)",
    )
    parser_qwat.add_argument("path", help="path to the input/output .xtf file")
    parser_qwat.add_argument(
        "--pgservice",
        help="name of the pgservice to use to connect to the database",
        default=config.QWAT_DEFAULT_PGSERVICE,
    )
    parser_qwat.add_argument(
        "--log",
        action="store_true",
        help="saves a log file next to the input/output file",
    )

    parser_tpl = subparsers.add_parser(
        "tpl", help="generate code templates [dev]", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser_tpl.add_argument("model", choices=["qgep", "qwat"])
    parser_tpl.add_argument(
        "--pgservice",
        help=f"name of the pgservice to use to connect to the database (defaults to {config.QGEP_DEFAULT_PGSERVICE} or {config.QWAT_DEFAULT_PGSERVICE})",
    )

    parser_setupdb = subparsers.add_parser(
        "setupdb", help="setup test db", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser_setupdb.set_defaults(parser="setupdb")
    parser_setupdb.add_argument("type", choices=["empty", "full"], help="type")

    args = parser.parse_args(args)

    if not args.parser:
        parser.print_help(sys.stderr)
        exit(1)

    # Set log path
    log_path = args.path if args.parser in ["qgep", "qwat"] and args.log else None

    # Write root logger to file
    filename = make_log_path(log_path, "qgepqwat2ili")
    file_handler = FileHandler(filename, mode="w", encoding="utf-8")
    file_handler.setLevel(INFO)
    file_handler.setFormatter(Formatter("%(levelname)-8s %(message)s"))
    utils.various.logger.addHandler(file_handler)

    if args.parser == "qgep":
        config.PGSERVICE = args.pgservice
        SCHEMA = config.ABWASSER_SCHEMA
        ILI_MODEL = config.ABWASSER_ILI_MODEL
        if args.export_sia405:
            ILI_MODEL_NAME = config.ABWASSER_ILI_MODEL_NAME_SIA405
            ILI_EXPORT_MODEL_NAME = config.ABWASSER_ILI_MODEL_NAME_SIA405
        else:
            ILI_MODEL_NAME = config.ABWASSER_ILI_MODEL_NAME
            ILI_EXPORT_MODEL_NAME = None

        if args.direction == "export":
            utils.ili2db.create_ili_schema(
                SCHEMA, ILI_MODEL, make_log_path(log_path, "ilicreate"), recreate_schema=args.recreate_schema
            )
            qgep_export(selection=args.selection.split(",") if args.selection else None, labels_file=args.labels_file)

            utils.ili2db.export_xtf_data(
                SCHEMA, ILI_MODEL_NAME, ILI_EXPORT_MODEL_NAME, args.path, make_log_path(log_path, "iliexport")
            )

            if not args.skip_validation:
                try:
                    utils.ili2db.validate_xtf_data(args.path, make_log_path(log_path, "ilivalidate"))
                except utils.various.CmdException:
                    print("Ilivalidator doesn't recognize output as valid ! Run with --skip_validation to ignore")
                    exit(1)

        elif args.direction == "import":
            if args.selection:
                print("Selection is only supported on export")
                exit(1)
            if not args.skip_validation:
                try:
                    utils.ili2db.validate_xtf_data(args.path, make_log_path(log_path, "ilivalidate"))
                except utils.various.CmdException:
                    print("Ilivalidator doesn't recognize input as valid ! Run with --skip_validation to ignore")
                    exit(1)
            utils.ili2db.create_ili_schema(
                SCHEMA, ILI_MODEL, make_log_path(log_path, "ilicreate"), recreate_schema=args.recreate_schema
            )
            utils.ili2db.import_xtf_data(SCHEMA, args.path, make_log_path(log_path, "iliimport"))
            qgep_import()

    elif args.parser == "qwat":
        config.PGSERVICE = args.pgservice
        SCHEMA = config.WASSER_SCHEMA
        ILI_MODEL = config.WASSER_ILI_MODEL
        ILI_MODEL_NAME = config.WASSER_ILI_MODEL_NAME
        ILI_EXPORT_MODEL_NAME = None

        if args.direction == "export":
            utils.ili2db.create_ili_schema(
                SCHEMA, ILI_MODEL, make_log_path(log_path, "ilicreate"), recreate_schema=args.recreate_schema
            )
            qwat_export(include_hydraulics=args.include_hydraulics)
            utils.ili2db.export_xtf_data(
                SCHEMA, ILI_MODEL_NAME, ILI_EXPORT_MODEL_NAME, args.path, make_log_path(log_path, "iliexport")
            )
            if not args.skip_validation:
                try:
                    utils.ili2db.validate_xtf_data(args.path, make_log_path(log_path, "ilivalidate"))
                except utils.various.CmdException:
                    print("Ilivalidator doesn't recognize output as valid ! Run with --skip_validation to ignore")
                    exit(1)

        elif args.direction == "import":
            if args.include_hydraulics:
                print("--include_hydraulics is only supported on export")
                exit(1)
            if not args.skip_validation:
                try:
                    utils.ili2db.validate_xtf_data(args.path, make_log_path(log_path, "ilivalidate"))
                except utils.various.CmdException:
                    print("Ilivalidator doesn't recognize input as valid ! Run with --skip_validation to ignore")
                    exit(1)
            utils.ili2db.create_ili_schema(
                SCHEMA, ILI_MODEL, make_log_path(log_path, "ilicreate"), recreate_schema=args.recreate_schema
            )
            utils.ili2db.import_xtf_data(SCHEMA, args.path, make_log_path(log_path, "iliimport"))
            qwat_import()

    elif args.parser == "tpl":
        config.PGSERVICE = args.pgservice

        if args.model == "qgep":
            if config.PGSERVICE is None:
                config.PGSERVICE = config.QGEP_DEFAULT_PGSERVICE
            utils.ili2db.create_ili_schema(config.ABWASSER_SCHEMA, config.ABWASSER_ILI_MODEL, recreate_schema=True)
            QGEPMAPPING = get_qgep_mapping()
            utils.templates.generate_template("qgep", "abwasser", BaseQgep, BaseAbwasser, QGEPMAPPING)

        elif args.model == "qwat":
            if config.PGSERVICE is None:
                config.PGSERVICE = config.QWAT_DEFAULT_PGSERVICE
            utils.ili2db.create_ili_schema(config.WASSER_SCHEMA, config.WASSER_ILI_MODEL, recreate_schema=True)
            QWATMAPPING = get_qwat_mapping()
            utils.templates.generate_template("qwat", "wasser", BaseQwat, BaseWasser, QWATMAPPING)

        else:
            print("Unknown model")
            exit(1)

    elif args.parser == "setupdb":
        utils.various.setup_test_db(args.type)

    else:
        print("Unknown operation")
        exit(1)

    print("Operation completed sucessfully !")
