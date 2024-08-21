import logging
import os
import sys

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

        # Import minimal dss
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_DSS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT obj_id FROM tww_od.pipe_profile WHERE obj_id='ch000000PP000001';"
        )
        self.assertIsNotNone(result)

        # Import minimal kek
        xtf_file_input = self._get_data_filename(MINIMAL_DATASET_KEK_MANHOLE_DAMAGE)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        result = DatabaseUtils.fetchone(
            "SELECT fk_maintenance_event FROM tww_od.re_maintenance_event_wastewater_structure WHERE fk_wastewater_structure='ch000000WS000001';"
        )
        self.assertIsNotNone(result)
        self.assertEqual(result[0], "fk11abk6EX000002")

        # Export minimal sia405
        export_xtf_file = self._get_output_filename("export_minimal_dataset_sia405.xtf")
        interlisImporterExporter.interlis_export(
            xtf_file_output=export_xtf_file,
            export_models=[config.MODEL_NAME_SIA405_ABWASSER],
            logs_next_to_file=True,
        )

        # Export minimal dss
        export_xtf_file = self._get_output_filename("export_minimal_dataset_dss.xtf")
        interlisImporterExporter.interlis_export(
            xtf_file_output=export_xtf_file,
            export_models=[config.MODEL_NAME_DSS],
            logs_next_to_file=True,
        )

        # Export minimal kek
        export_xtf_file = self._get_output_filename("export_minimal_dataset_kek.xtf")
        interlisImporterExporter.interlis_export(
            xtf_file_output=export_xtf_file,
            export_models=[config.MODEL_NAME_VSA_KEK],
            logs_next_to_file=True,
        )

    def test_dss_dataset_import_export(self):
        # Import organisation
        xtf_file_input = self._get_data_filename(TEST_DATASET_ORGANISATIONS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        # Import minimal dss
        xtf_file_input = self._get_data_filename(TEST_DATASET_DSS)
        interlisImporterExporter = InterlisImporterExporter()
        interlisImporterExporter.interlis_import(xtf_file_input=xtf_file_input)

        # Export minimal dss
        export_xtf_file = self._get_output_filename("minimal_dss_dataset.xtf")
        interlisImporterExporter.interlis_export(
            xtf_file_output=export_xtf_file,
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
