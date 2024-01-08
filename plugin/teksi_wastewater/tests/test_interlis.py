import logging
import os
import sys

from qgis.testing import start_app, unittest
from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.gui.interlis_importer_exporter import (
    InterlisImporterExporter,
)
from teksi_wastewater.interlis.utils.ili2db import InterlisTools

# Display logging in unittest output
logger = logging.getLogger()
logger.setLevel(logging.WARNING)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.WARNING)
logger.addHandler(handler)


start_app()

PG_PORT = os.getenv("TWW_PG_PORT", 5432)


class TestInterlis(unittest.TestCase):
    def test_import_demo_organisations(self):
        config.PGHOST = "db"
        config.PGDATABASE = "teksi_wastewater"
        config.PGUSER = "postgres"
        config.PGPASS = "postgres"
        config.PGPORT = str(PG_PORT)

        xtf_file_input = os.path.join(
            os.path.dirname(__file__),
            "data",
            "vsa_2020_1_organisationen_testdatensatz.xtf",
        )

        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)

    def test_get_xtf_models(self):
        xtf_file_input = os.path.join(
            os.path.dirname(__file__),
            "data",
            "vsa_2020_1_organisationen_testdatensatz.xtf",
        )

        import_model, models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)

        self.assertEqual(import_model, config.MODEL_NAME_SIA405_ABWASSER)
        self.assertIn(config.MODEL_NAME_SIA405_BASE_ABWASSER, models)
