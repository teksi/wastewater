import collections
import re
import xml.etree.ElementTree as ET
from types import SimpleNamespace

from sqlalchemy.ext.automap import AutomapBase

from ...libs.modelbaker.iliwrapper import globals, ili2dbutils
from .. import config
from .various import execute_subprocess, get_pgconf_as_ili_args, logger


class InterlisToolsException(Exception):
    pass


class InterlisTools:
    def __init__(self):
        class BaseConfiguration:
            java_path = None

        self.java_executable_path = ili2dbutils.get_java_path(BaseConfiguration())

        stdout = SimpleNamespace()
        stdout.emit = logger.info
        stderr = SimpleNamespace()
        stderr.emit = logger.error

        self.ili2pg_executable_path = ili2dbutils.get_ili2db_bin(
            globals.DbIliMode.ili2pg, 4, stdout, stderr
        )

    def import_ili_schema(
        self,
        schema,
        models,
        log_path,
        ext_columns_no_constraints=False,
        create_basket_col=False,
        srid=2056,
    ):
        sql_ext_refs_cols = ""
        if ext_columns_no_constraints:
            sql_ext_refs_cols = "--sqlExtRefCols"

        create_basket_col_args = ""
        if create_basket_col:
            create_basket_col_args = "--createBasketCol"

        logger.info(f"ILIDB SCHEMAIMPORT INTO {schema}...")
        execute_subprocess(
            " ".join(
                [
                    f'"{self.java_executable_path}"',
                    "-jar",
                    f'"{self.ili2pg_executable_path}"',
                    "--schemaimport",
                    *get_pgconf_as_ili_args(),
                    "--dbschema",
                    f"{schema}",
                    "--createGeomIdx",
                    f"{sql_ext_refs_cols}",
                    "--createFk",
                    "--createFkIdx",
                    "--createTidCol",
                    "--importTid",
                    f"{create_basket_col_args}",
                    "--noSmartMapping",
                    "--defaultSrsCode",
                    f"{srid}",
                    "--log",
                    f'"{log_path}"',
                    "--nameLang",
                    "de",
                    "--models",
                    f'"{";".join(models)}"',
                ]
            )
        )

    def validate_xtf_data(self, xtf_file, log_path):
        logger.info("VALIDATING XTF DATA...")
        execute_subprocess(
            f'"{self.java_executable_path}" -jar "{config.ILIVALIDATOR}" --log "{log_path}" "{xtf_file}"'
        )

    def import_xtf_data(self, schema, xtf_file, log_path, srid=2056):
        logger.info("IMPORTING XTF DATA...")
        execute_subprocess(
            " ".join(
                [
                    f'"{self.java_executable_path}"',
                    "-jar",
                    f'"{self.ili2pg_executable_path}"',
                    "--import",
                    "--deleteData",
                    *get_pgconf_as_ili_args(),
                    "--dbschema",
                    f'"{schema}"',
                    "--disableValidation",
                    "--skipReferenceErrors",
                    "--createTidCol",
                    "--noSmartMapping",
                    "--defaultSrsCode",
                    f"{srid}",
                    "--log",
                    f'"{log_path}"',
                    f'"{xtf_file}"',
                ]
            )
        )

    def export_xtf_data(
        self, schema, xtf_file, log_path, model_name, export_model_name, srid=2056
    ):
        logger.info("EXPORT ILIDB...")

        # if optional export_model_name is set, add it to the args
        if export_model_name:
            export_model_name_args = ["--exportModels", export_model_name]
        else:
            export_model_name_args = []

        execute_subprocess(
            " ".join(
                [
                    f'"{self.java_executable_path}"',
                    "-jar",
                    f'"{self.ili2pg_executable_path}"',
                    "--export",
                    "--models",
                    f"{model_name}",
                    *export_model_name_args,
                    *get_pgconf_as_ili_args(),
                    "--dbschema",
                    f"{schema}",
                    "--disableValidation",
                    "--skipReferenceErrors",
                    "--createTidCol",
                    "--noSmartMapping",
                    "--defaultSrsCode",
                    f"{srid}",
                    "--log",
                    f'"{log_path}"',
                    "--trace",
                    f'"{xtf_file}"',
                ]
            )
        )

    @staticmethod
    def get_xtf_models(xtf_file):
        logger.info(f"GET XTF MODELS from {xtf_file}...")

        # from xml file
        tree = ET.parse(xtf_file)
        root = tree.getroot()

        def get_namespace(element):
            m = re.match(r"\{.*\}", element.tag)
            return m.group(0) if m else ""

        namespace = get_namespace(root)

        model_elements = root.findall("./{0}HEADERSECTION/{0}MODELS/{0}MODEL".format(namespace))

        if not model_elements:
            raise InterlisToolsException(f"Couldn't find any model into '{xtf_file}'")

        models = []
        for model_element in model_elements:
            models.append(model_element.attrib.get("NAME", None))

        return models


class TidMaker:
    """
    Helper class that creates globally unique integer primary key forili2pg class (t_id)
    from a a TWW id (obj_id or id).
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
