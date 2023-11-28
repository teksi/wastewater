import collections

import psycopg2
from sqlalchemy.ext.automap import AutomapBase

from .. import config
from .various import exec_, get_pgconf_as_ili_args, get_pgconf_as_psycopg2_dsn, logger


def create_ili_schema(schema, model, log_path, recreate_schema=False):
    logger.info("CONNECTING TO DATABASE...")

    connection = psycopg2.connect(get_pgconf_as_psycopg2_dsn())
    connection.set_session(autocommit=True)
    cursor = connection.cursor()

    if not recreate_schema:
        # If the schema already exists, we just truncate all tables
        cursor.execute(f"SELECT schema_name FROM information_schema.schemata WHERE schema_name = '{schema}';")
        if cursor.rowcount > 0:
            logger.info(f"Schema {schema} already exists, we truncate instead")
            cursor.execute(f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{schema}';")
            for row in cursor.fetchall():
                cursor.execute(f"TRUNCATE TABLE {schema}.{row[0]} CASCADE;")
            return

    logger.info(f"DROPPING THE SCHEMA {schema}...")
    cursor.execute(f'DROP SCHEMA IF EXISTS "{schema}" CASCADE ;')
    logger.info(f"CREATING THE SCHEMA {schema}...")
    cursor.execute(f'CREATE SCHEMA "{schema}";')
    connection.commit()
    connection.close()

    logger.info(f"ILIDB SCHEMAIMPORT INTO {schema}...")
    exec_(
        " ".join(
            [
                f'"{config.JAVA}"',
                "-jar",
                f'"{config.ILI2PG}"',
                "--schemaimport",
                *get_pgconf_as_ili_args(),
                "--dbschema",
                f"{schema}",
                "--setupPgExt",
                "--createGeomIdx",
                "--createFk",
                "--createFkIdx",
                "--createTidCol",
                "--importTid",
                "--noSmartMapping",
                "--defaultSrsCode",
                "2056",
                "--log",
                f'"{log_path}"',
                "--nameLang",
                "de",
                f"{model}",
            ]
        )
    )


def validate_xtf_data(xtf_file, log_path):
    logger.info("VALIDATING XTF DATA...")
    exec_(
        f'"{config.JAVA}" -jar "{config.ILIVALIDATOR}" --modeldir "{config.ILI_FOLDER}" --log "{log_path}" "{xtf_file}"'
    )


def import_xtf_data(schema, xtf_file, log_path):
    logger.info("IMPORTING XTF DATA...")
    exec_(
        " ".join(
            [
                f'"{config.JAVA}"',
                "-jar",
                f'"{config.ILI2PG}"',
                "--import",
                "--deleteData",
                *get_pgconf_as_ili_args(),
                "--dbschema",
                f'"{schema}"',
                "--modeldir",
                f'"{config.ILI_FOLDER}"',
                "--disableValidation",
                "--skipReferenceErrors",
                "--createTidCol",
                "--noSmartMapping",
                "--defaultSrsCode",
                "2056",
                "--log",
                f'"{log_path}"',
                f'"{xtf_file}"',
            ]
        )
    )


def export_xtf_data(schema, model_name, export_model_name, xtf_file, log_path):
    logger.info("EXPORT ILIDB...")

    # if optional export_model_name is set, add it to the args
    if export_model_name:
        export_model_name_args = ["--exportModels", export_model_name]
    else:
        export_model_name_args = []

    exec_(
        " ".join(
            [
                f'"{config.JAVA}"',
                "-jar",
                f'"{config.ILI2PG}"',
                "--export",
                "--models",
                f"{model_name}",
                *export_model_name_args,
                *get_pgconf_as_ili_args(),
                "--dbschema",
                f"{schema}",
                "--modeldir",
                f'"{config.ILI_FOLDER}"',
                "--disableValidation",
                "--skipReferenceErrors",
                "--createTidCol",
                "--noSmartMapping",
                "--defaultSrsCode",
                "2056",
                "--log",
                f'"{log_path}"',
                "--trace",
                f'"{xtf_file}"',
            ]
        )
    )


class TidMaker:
    """
    Helper class that creates globally unique integer primary key forili2pg class (t_id)
    from a a QGEP/QWAT id (obj_id or id).
    """

    def __init__(self, id_attribute="id"):
        self._id_attr = id_attribute
        self._autoincrementer = collections.defaultdict(lambda: len(self._autoincrementer))

    def tid_for_row(self, row, for_class=None):
        # tid are globally unique, while ids are only guaranteed unique per table,
        # so include the base table in the key
        # this finds the base class (the first parent class before sqlalchemy.ext.automap.Base)
        class_for_id = row.__class__.__mro__[row.__class__.__mro__.index(AutomapBase) - 2]
        key = (class_for_id, getattr(row, self._id_attr), for_class)
        # was_created = key not in self._autoincrementer  # just for debugging
        tid = self._autoincrementer[key]
        # if was_created:
        #     # just for debugging
        #     logger.info(f"created tid {tid} for {key}")
        return tid

    def next_tid(self):
        """Get an arbitrary unused tid"""
        key = len(self._autoincrementer)
        return self._autoincrementer[key]
