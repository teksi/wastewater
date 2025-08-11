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
                # xml_attribute = interlis_object.attrib.get("HoehenBreitenverhaeltnis", None)
                # Attributname has to be German, as xtf is German
                # xml_attribute = interlis_object.get("HoehenBreitenverhaeltnis", None)
                # https://www.plus2net.com/python/xml-reading.php
                # /TRANSFER/DATASECTION/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser.Rohrprofil/@TID
                # /TRANSFER/DATASECTION/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser.Rohrprofil/HoehenBreitenverhaeltnis
                #  /TRANSFER/DATASECTION/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser.Rohrprofil[@TID='ch000000PP000003']/HoehenBreitenverhaeltnis/text()
                
                #xml_attribute = interlis_object.find("HoehenBreitenverhaeltnis").text
                # https://xpath.playground.fontoxml.com/?state=H4sIABhLmmgAA%2B2abXPiNhCA%2F4rKl7ubCX6LHULG9dUJ5sJAILW5ZDpNhzEgsIqRqS3ydnP%2FvWuDY5lAXpykd0cvHwKSdlfS6vFqJfOlNA2GuHQg7ZQu3ZC4fR9HpYPSl6%2BlndL11Iev%2Bkf4RJc4jEhAf70oyYJ0UUKYDoIhoWOo%2BNytl%2Feh6qNxQfWubbadumUjUKIRtHqMzQ5E8erqSiCU4dAnkTDwxEa7a9mthqMIuxclUERIP7bMmmU71lG30WmjM%2FgKn2AhEUGO1YbWuLt2s905by%2B1QO%2BkU7NazrKUllHbPLFA2mmYqqT1zMNz03Esu6dIitSTe62zqgZGP9uN1SGOgnFIZvEYoT0bBBTEtEMx16Nuthom173V7toNy0H1TjzaB%2FvPlMSl1l0XvFH9qHNyAgJ34kOXuRFmaIwpDl2Gh6h%2Fg67ZKJizdKGQLGg76P3gA4qn9CmeEvo07R8jRZK0MoxCSXvijetibhEWdTWza%2FIVUPXArIS0rX%2FlRhEO0WGjBn44NJ2m1ZX5OT%2FDiNB0qeujbmJq4EnJ31Er%2BeBtgtUWZrcM90xMhzic07EBZlVJllRdvNfEqdXAjdTDYWjjEbKtetKPIs12%2F1GTTtRqBfrRRV7unr5P8AgWhLKnGOGFeUuH7vxv1wuTcetiWuIF8C0mA4%2FGM0h9YVsLX4AC18opOcxl88ggtHeIWUhwXxeXVTnLLMSkjx9zAi%2FH61sEiGRzPH3UQl6St1Gf0wkDgI8JOCcceCQaeMapaQqOO51ifxKDoItrpdZZuRmG7hxiDjTXYczRjOAx9n1MGDiIs8PJZQ%2FlswktBnc7CKfQsTvw2Ari585PxLs4YlvAdY1MMY0js2zsSRI4KCuvk1KM%2FZyUso5uoxlQFga%2B37MIjRgm4yVGGdgFaeaQLMa0M8O3xPX77vwKh5P1WCv%2Fd6yVHx%2Frt0cxT1IxGu3AC2dhMCKrOcTp6XYGWI6qZrLtJZPfiNtxgD1MD0ESjEIG6bnYZ5REBiT7EIU2NnMmTpMe2M0s32FWXWz1s5WLTxe%2FlMvIHQ4h4R0FIRp4eDBBkOtuGh8SkQckMq93RYbwH3JlEqBymRv3q6OUHmceQEmTKvL%2Bj4iSjeGBBp%2BDb2RlX6ts3pYfACrRfC5Tac9vglUBCo5dP04go1kc21ZAsBcgbN3utpqTlZMtrL6RgWbAsKGq%2B4Icx5CkxPvDHfPl5JTbsWuGfiQbSkXV9iuqoKoanE9lqFMMWdmrqFVV0PZg14RyfHCN5TmT4opNPV0uCg7GPuxeeQ8sk5H23RYAx%2B61GgUhy0HyZpw9IeBsA2fdxzirCJpcgLPqriZUd2OmMs40uSrsyhCk3oCzOCx8f5ylXyYU3EdX0%2FXsCdlq0DYSlnpnmYOuWdvsnJ6tbSb9X8c9J%2FB8TCdp%2FIWRAVBZXTHK8oi8HWbbvm9uPvQ9FbN8CCmG2WuEvRxmy%2FD7XWC2DIir%2B%2BXyjnTr%2BIJT%2BSQeXjjrjcJg2vPxJfYX56SYtbT58T22OJncXfzjZGI6xtZohOFW4NLY2xOUasxWrpaXh%2FHAKiTnBWM3DmW5Gk7yBNwEr7B8ozmHK4iIBaNR7zTwby4JJf7A84OQgEPupDjNM3gv5c75Ycanj07rj1ajba2eFl8ar1%2FlaYwfqzUD1MX7U9Gzw879heMuQHQxJ8hboHCTk8sy7hvislFdXCfP27uEG%2FcnmVuEujXiL0uVioWVGhxA4cFaeQvV2dKo8i2So0Uqr8W3Tt%2FiyPg8lhY4vD5KPxOg10iAlihJglYEpRenRy9A6VmqiQ4sQO4dvS6mP8OAQvxDjt%2FnOLyB33KguwZe4zn9Fbxl%2B%2FO3GPV3q3el7%2F7aeA8oMnzN3n%2BA0Q%2FgzQJ8T%2BdQ%2BvovLvN4bbQiAAA%3D
                xml_attribute = root.findall("./TRANSFER/DATASECTION/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser/SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser.Rohrprofil[@TID='ch000000PP000003']/HoehenBreitenverhaeltnis/text()")
                
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
        # old
        xml_height_width_ratio = self._get_xtf_object_attribute(
        exported_xtf_filename,
         config.TOPIC_NAME_DSS,
         "Rohrprofil",
         "ch000000PP000003",
         "HoehenBreitenverhaeltnis",
         )

        # Check exported TID and height_width_ratio pipe_profile
        # interlis_object = self._get_xtf_object(
            # exported_xtf_filename,
            # config.TOPIC_NAME_SIA405_ABWASSER,
            # "Rohrprofil",
            # "ch000000PP000003",
        # )
        # xml_height_width_ratio = interlis_object.get("HoehenBreitenverhaeltnis", None)
        # debug - print to find out how interlis_object looks like

        print(interlis_object)
        # xml_height_width_ratio = interlis_object.find("HoehenBreitenverhaeltnis").text
        # xml_height_width_ratio = interlis_object.find("HoehenBreitenverhaeltnis")
        self.assertEqual(xml_height_width_ratio, 1.13)

        # # add debug output
        # logger.debug(f"xml_height_width_ratio =  {xml_height_width_ratio}")

        # if xml_height_width_ratio is not None:
        # # self.assertIsNotNone(xml_height_width_ratio, xml_height_width_ratio)
        # self.assertEqual(xml_height_width_ratio, 1.130)
        # # in future if VSA-DSS / SIA405 INTERLIS is also patched  change to:
        # # self.assertEqual(xml_height_width_ratio, 1.12857)
        # else:
        # self.assertEqual(1, 2)

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
