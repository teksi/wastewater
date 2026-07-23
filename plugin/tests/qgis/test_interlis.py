import logging
import os
import re
import sys
import xml.etree.ElementTree as ET
from decimal import Decimal

from qgis.testing import start_app, unittest
from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
)
from teksi_wastewater.interlis.utils.ili2db import InterlisTools
from teksi_wastewater.utils.database_utils import DatabaseUtils

# Display logging in unittest output
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
logger.addHandler(handler)


start_app()

PG_PORT = os.getenv("PG_PORT", 5432)

MINIMAL_DATASET_DSS = "minimal-dataset-DSS.xtf"
MINIMAL_DATASET_ORGANISATION_ARBON_ONLY = "minimal-dataset-organisation-arbon-only.xtf"
MINIMAL_DATASET_SIA405_ABWASSER = "minimal-dataset-SIA405-ABWASSER.xtf"
MINIMAL_DATASET_SIA405_ABWASSER_MODIFIED = "minimal-dataset-SIA405-ABWASSER-modified.xtf"
MINIMAL_DATASET_KEK_MANHOLE_DAMAGE = "minimal-dataset-VSA-KEK-manhole-damage.xtf"
TEST_DATASET_DSS = "test-dataset-DSS.xtf"
TEST_DATASET_ORGANISATIONS = "test-dataset-organisations.xtf"


class TestInterlis(unittest.TestCase):
    def _get_data_filename(self, name):
        return os.path.join(
            os.path.dirname(__file__),
            "data",
            name,
        )

    def _get_output_filename(self, name):

        directory = os.path.join(os.path.dirname(__file__), "output")
        if not os.path.exists(directory):
            os.makedirs(directory)

        return os.path.join(directory, name)

    @staticmethod
    def _get_xtf_object(xtf_file, topicname, classname, tid):
        # from xml file
        tree = ET.parse(xtf_file)
        root = tree.getroot()

        def get_namespace(element):
            m = re.match(r"\{.*\}", element.tag)
            return m.group(0) if m else ""

        namespace = get_namespace(root)

        interlis_objects = root.findall(
            "./{0}DATASECTION/{0}{1}/{0}{1}.{2}".format(namespace, topicname, classname)
        )

        for interlis_object in interlis_objects:
            xml_tid = interlis_object.attrib.get("TID", None)

            if xml_tid == tid:
                return interlis_object

        return None

    @staticmethod
    def _get_xtf_object_node_text(
        xtf_file, topicname: str, classname: str, tid: str, attributename: str
    ) -> str:

        # from xml file
        tree = ET.parse(xtf_file)
        root = tree.getroot()

        def get_namespace(element):
            m = re.match(r"\{.*\}", element.tag)
            return m.group(0) if m else ""

        namespace: str = get_namespace(root)

        # findtext with Clark Notation: https://de.wikipedia.org/wiki/Namensraum_(XML)#Namensraum-Notation_nach_James_Clark
        return root.findtext(
            f"./{namespace}DATASECTION/{namespace}{topicname}"
            f"/{namespace}{topicname}.{classname}[@TID='{tid}']"
            f"/{namespace}{attributename}"
        )

    def setUp(self):
        DatabaseUtils.databaseConfig.PGHOST = "db"
        DatabaseUtils.databaseConfig.PGDATABASE = "tww"
        DatabaseUtils.databaseConfig.PGUSER = "postgres"
        DatabaseUtils.databaseConfig.PGPASS = "postgres"
        DatabaseUtils.databaseConfig.PGPORT = str(PG_PORT)

    def test_dss_dataset_import_export(self):
        # Import organisation
        xtf_file_input = self._get_data_filename(TEST_DATASET_ORGANISATIONS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        # Import testdataset dss
        xtf_file_input = self._get_data_filename(TEST_DATASET_DSS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        # new location for this check
        # check if urgency_figure is imported
        result = DatabaseUtils.fetchone(
            "SELECT urgency_figure FROM tww_od.wastewater_structure WHERE obj_id='ch080qwzVE000019';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 50)

        # Export minimal dss
        export_xtf_file = self._get_output_filename("export_minimal_dss_dataset.xtf")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_DSS],
            logs_next_to_file=True,
            user_interaction=False,
        )

    def test_get_xtf_models(self):
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_DSS)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_DSS])

        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_SIA405_ABWASSER)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_SIA405_ABWASSER])

        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_ORGANISATION_ARBON_ONLY)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_SIA405_BASE_ABWASSER])

        xtf_file_input = self._get_data_filename(TEST_DATASET_DSS)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(
            models,
            ["Units", "Base", config.MODEL_NAME_SIA405_BASE_ABWASSER, config.MODEL_NAME_DSS],
        )

        xtf_file_input = self._get_data_filename(TEST_DATASET_ORGANISATIONS)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_SIA405_BASE_ABWASSER])

        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_KEK_MANHOLE_DAMAGE)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_VSA_KEK])
