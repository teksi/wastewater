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

MINIMAL_DATASET_DSS = "minimal-dataset-DSS.xtf"
MINIMAL_DATASET_ORGANISATION_ARBON_ONLY = "minimal-dataset-organisation-arbon-only.xtf"
MINIMAL_DATASET_SIA405_ABWASSER = "minimal-dataset-SIA405-ABWASSER.xtf"
TEST_DATASET_DSS = "test-dataset-DSS.xtf"
TEST_DATASET_ORGANISATIONS = "test-dataset-organisations.xtf"

TESTDATA_KEK_CHANNEL_DAMAGE = (
    "testdata_vsa_kek_2020_1_channel_damage/testdata_vsa_kek_2020_1_channel_damage.xtf"
)


class TestInterlis(unittest.TestCase):
    def _get_data_filename(self, name):
        return os.path.join(
            os.path.dirname(__file__),
            "data",
            name,
        )

    def test_import_export(self):
        config.PGHOST = "db"
        config.PGDATABASE = "teksi_wastewater"
        config.PGUSER = "postgres"
        config.PGPASS = "postgres"
        config.PGPORT = str(PG_PORT)

        # Import organisation
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_ORGANISATION_ARBON_ONLY)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)

        # Import minimal vsa
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_SIA405_ABWASSER)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)

        # Import minimal vsa
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_DSS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)

        # Import minimal kek
        xtf_file_input = self._get_data_filename(TESTDATA_KEK_CHANNEL_DAMAGE)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.action_import(xtf_file_input=xtf_file_input)

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

        xtf_file_input = self._get_data_filename(TESTDATA_KEK_CHANNEL_DAMAGE)
        models = InterlisTools.get_xtf_models(xtf_file=xtf_file_input)
        self.assertCountEqual(models, [config.MODEL_NAME_VSA_KEK])
