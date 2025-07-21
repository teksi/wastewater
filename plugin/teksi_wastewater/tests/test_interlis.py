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

PG_PORT = os.getenv("TWW_PG_PORT", 5432)

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
    def _get_xtf_object_attribute(xtf_file, topicname, classname, tid, attribute):
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
                # xml_attribute = interlis_object.attrib.get(attribute, None)
                # testing with fixed attribute name
                # xml_attribute = interlis_object.attrib.get("height_width_ratio", None)
                xml_attribute = interlis_object.get("height_width_ratio", None)
                return xml_attribute

        return None

    def setUp(self):
        DatabaseUtils.databaseConfig.PGHOST = "db"
        DatabaseUtils.databaseConfig.PGDATABASE = "tww"
        DatabaseUtils.databaseConfig.PGUSER = "postgres"
        DatabaseUtils.databaseConfig.PGPASS = "postgres"
        DatabaseUtils.databaseConfig.PGPORT = str(PG_PORT)

    def test_minimal_import_export(self):
        # Import organisation
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_ORGANISATION_ARBON_ONLY)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT identifier FROM tww_od.organisation WHERE obj_id='ch20p3q400001497';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], "Arbon")

        # Import minimal sia405
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_SIA405_ABWASSER)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT obj_id FROM tww_od.reach WHERE obj_id='ch000000RE000001';"
        )
        self.assertIsNotNone(result)

        result = DatabaseUtils.fetchone(
            "SELECT remark FROM tww_od.wastewater_networkelement WHERE obj_id='ch000000RE000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], "rp_from_level added")

        result = DatabaseUtils.fetchone(
            "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 448.0)

        # check on height_width_ratio decimal(8,5) instead of decimal(5,2)
        result = DatabaseUtils.fetchone(
            "SELECT height_width_ratio FROM tww_od.pipe_profile WHERE obj_id='ch000000PP000003';"
        )
        self.assertIsNotNone(result)

        # self.assertEqual(result[0], 1.13000)
        self.assertEqual(result[0], Decimal("1.13000"))

        # in future if VSA-DSS / SIA405 INTERLIS is also patched change to:
        # self.assertEqual(result[0], 1.12857)

        # update height_width_ratio to long decimal to test export
        # row = {
        # "height_width_ratio": 1.12857,
        # }
        # self.update("pipe_profile", row, 'ch000000PP000003')

        # Import minimal dss
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_DSS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT obj_id FROM tww_od.pipe_profile WHERE obj_id='ch000000PP000001';"
        )
        self.assertIsNotNone(result)

        # Check that we don't loose Z information on second import
        result = DatabaseUtils.fetchone(
            "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 448.0)

        # Import minimal kek
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_KEK_MANHOLE_DAMAGE)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT fk_maintenance_event FROM tww_od.re_maintenance_event_wastewater_structure WHERE fk_wastewater_structure='ch000000WS000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], "fk11abk6EX000002")

        # Check that we don't loose Z information on second import
        result = DatabaseUtils.fetchone(
            "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 448.0)

        # Export minimal sia405_base
        DatabaseUtils.execute("UPDATE tww_od.organisation SET tww_local_extension=true;")
        export_xtf_file = self._get_output_filename("export_minimal_dataset_sia405_base")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_SIA405_BASE_ABWASSER],
            logs_next_to_file=True,
        )

        # Check exported TID
        exported_xtf_filename = self._get_output_filename(
            f"{export_xtf_file}_{config.MODEL_NAME_SIA405_BASE_ABWASSER}.xtf"
        )
        interlis_object = self._get_xtf_object(
            exported_xtf_filename,
            config.TOPIC_NAME_SIA405_ADMINISTRATION,
            "Organisation",
            "ch20p3q400001497",
        )
        self.assertIsNotNone(interlis_object)

        # Export minimal sia405
        export_xtf_file = self._get_output_filename("export_minimal_dataset_sia405")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_SIA405_ABWASSER],
            logs_next_to_file=True,
        )

        # Check exported TID reach
        exported_xtf_filename = self._get_output_filename(
            f"{export_xtf_file}_{config.MODEL_NAME_SIA405_ABWASSER}.xtf"
        )
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_SIA405_ABWASSER, "Haltung", "ch000000RE000001"
        )
        self.assertIsNotNone(interlis_object)

        # Check exported TID and height_width_ratio pipe_profile
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_DSS, "Rohrprofil", "ch000000PP000003"
        )
        self.assertIsNone(interlis_object)
        # xml_tid = interlis_object.attrib.get("TID", None)
        # xml_height_width_ratio = interlis_object.attrib.get("height_width_ratio", None)
        xml_height_width_ratio = self._get_xtf_object_attribute(
            exported_xtf_filename,
            config.TOPIC_NAME_DSS,
            "Rohrprofil",
            "ch000000PP000003",
            "height_width_ratio",
        )

        # add debug output
        logger.debug(f"xml_height_width_ratio =  {xml_height_width_ratio}")

        if xml_height_width_ratio is not None:
            # self.assertIsNotNone(xml_height_width_ratio, xml_height_width_ratio)
            self.assertEqual(xml_height_width_ratio, 1.130)
        # in future if VSA-DSS / SIA405 INTERLIS is also patched  change to:
        # self.assertEqual(xml_height_width_ratio, 1.12857)
        else:
            self.assertEqual(1, 2)

        # Export minimal dss
        export_xtf_file = self._get_output_filename("export_minimal_dataset_dss")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_DSS],
            logs_next_to_file=True,
        )

        # Check exported TID
        exported_xtf_filename = self._get_output_filename(
            f"{export_xtf_file}_{config.MODEL_NAME_DSS}.xtf"
        )
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_DSS, "Rohrprofil", "ch000000PP000001"
        )
        self.assertIsNotNone(interlis_object)

        # Export minimal kek
        export_xtf_file = self._get_output_filename("export_minimal_dataset_kek")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_VSA_KEK],
            logs_next_to_file=True,
        )

        # Check exported TID examination
        exported_xtf_filename = self._get_output_filename(
            f"{export_xtf_file}_{config.MODEL_NAME_VSA_KEK}.xtf"
        )
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_KEK, "Untersuchung", "fk11abk6EX000002"
        )
        self.assertIsNotNone(interlis_object)

        # Import modified minimal sia405 (test update)
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_SIA405_ABWASSER_MODIFIED)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT obj_id FROM tww_od.reach WHERE obj_id='ch000000RE000001';"
        )
        self.assertIsNotNone(result)

        result = DatabaseUtils.fetchone(
            "SELECT remark FROM tww_od.wastewater_networkelement WHERE obj_id='ch000000RE000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], "rp_from_level modified")

        # Check that we don't loose Z information on second import
        result = DatabaseUtils.fetchone(
            "SELECT bottom_level FROM tww_od.wastewater_node WHERE obj_id='ch000000WN000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 448.0)

        # Export selection of minimal dss
        export_xtf_file = self._get_output_filename("export_minimal_dataset_dss_selection")
        interlisImporterExporter.interlis_export(
            xtf_file_output=self._get_output_filename(export_xtf_file),
            export_models=[config.MODEL_NAME_DSS],
            logs_next_to_file=True,
            selected_ids=["ch000000WN000002", "ch000000WN000003", "ch000000RE000002"],
        )

        # Check exported TID pipe_profile
        export_xtf_file = self._get_output_filename("export_minimal_dataset_dss_selection")
        exported_xtf_filename = self._get_output_filename(
            f"{export_xtf_file}_{config.MODEL_NAME_DSS}.xtf"
        )
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_DSS, "Rohrprofil", "ch000000PP000001"
        )
        self.assertIsNone(interlis_object)
        interlis_object = self._get_xtf_object(
            exported_xtf_filename, config.TOPIC_NAME_DSS, "Rohrprofil", "ch000000PP000002"
        )
        self.assertIsNotNone(interlis_object)

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
