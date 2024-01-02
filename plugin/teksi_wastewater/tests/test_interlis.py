import logging
import os
import sys

from qgis.testing import start_app, unittest
from teksi_wastewater.interlis.gui.interlis_importer_exporter import (
    InterlisImporterExporter,
)

# Display logging in unittest output
logger = logging.getLogger()
logger.setLevel(logging.WARNING)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.WARNING)
logger.addHandler(handler)


start_app()


def findall_in_xml_kek_2019(root, tag, basket="VSA_KEK_2019_LV95.KEK"):
    ns = {"ili": "http://www.interlis.ch/INTERLIS2.3"}
    return root.findall(f"ili:DATASECTION/ili:{basket}/ili:{tag}", ns)


def findall_in_xml_sia_abwasser_2015(
    root, tag, basket="SIA405_ABWASSER_2015_LV95.SIA405_Abwasser"
):
    ns = {"ili": "http://www.interlis.ch/INTERLIS2.3"}
    return root.findall(f"ili:DATASECTION/ili:{basket}/ili:{tag}", ns)


class TestInterlis(unittest.TestCase):
    def test_import_demo_organisations(self):
        interlisImporterExporter = InterlisImporterExporter()

        os.path.abspath(os.path.dirname(__file__))

        xtf_file_input = os.path.join(
            os.path.dirname(__file__),
            "data",
            "vsa_2020_1_organisationen_testdatensatz.xtf",
        )

        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)
