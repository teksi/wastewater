from __future__ import annotations

import argparse
import logging
import os
import sys
from pathlib import Path
from uuid import uuid4

from qgis.testing import start_app, unittest
from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)
from teksi_wastewater.hooks.cli import helpers
from teksi_wastewater.hooks.services.tww_trusted_import_service import (
    TwwTrustedImportService,
)
from teksi_wastewater.interlis import config, model_config
from teksi_wastewater.interlis.utils.ili2db import InterlisTools
from teksi_wastewater.utils.database_utils import DatabaseUtils

from ..helpers import (
    get_xtf_object,
    get_xtf_object_node_text,
)

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

if not any(isinstance(handler, logging.StreamHandler) for handler in logger.handlers):
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    logger.addHandler(handler)


start_app()


PG_HOST = os.getenv("PG_HOST", "db")
PG_DATABASE = os.getenv("PG_DATABASE", "tww")
PG_USER = os.getenv("PG_USER", "postgres")
PG_PASSWORD = os.getenv("PG_PASSWORD", "postgres")
PG_PORT = int(os.getenv("PG_PORT", "5432"))

DATA_DIR = Path(__file__).resolve().parent / "data"
OUTPUT_DIR = Path(__file__).resolve().parent / "output"

MINIMAL_DATASET_DSS = "minimal-dataset-DSS.xtf"
MINIMAL_DATASET_ORGANISATION_ARBON_ONLY = "minimal-dataset-organisation-arbon-only.xtf"
MINIMAL_DATASET_SIA405_ABWASSER = "minimal-dataset-SIA405-ABWASSER.xtf"
MINIMAL_DATASET_SIA405_ABWASSER_MODIFIED = "minimal-dataset-SIA405-ABWASSER-modified.xtf"
MINIMAL_DATASET_KEK_MANHOLE_DAMAGE = "minimal-dataset-VSA-KEK-manhole-damage.xtf"
TEST_DATASET_DSS = "test-dataset-DSS.xtf"
TEST_DATASET_ORGANISATIONS = "test-dataset-organisations.xtf"


class TestInterlis(unittest.TestCase):
    """
    QGIS-enabled integration tests for the hooks-based INTERLIS services.

    These tests use a disposable database and therefore explicitly permit
    recreation of the import and export quarantine schemas.
    """

    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()

        OUTPUT_DIR.mkdir(
            parents=True,
            exist_ok=True,
        )

        DatabaseUtils.databaseConfig.PGHOST = PG_HOST
        DatabaseUtils.databaseConfig.PGDATABASE = PG_DATABASE
        DatabaseUtils.databaseConfig.PGUSER = PG_USER
        DatabaseUtils.databaseConfig.PGPASS = PG_PASSWORD
        DatabaseUtils.databaseConfig.PGPORT = str(PG_PORT)

        cls.connection_args = argparse.Namespace(
            pghost=PG_HOST,
            pgdatabase=PG_DATABASE,
            pguser=PG_USER,
            pgpass=PG_PASSWORD,
            pgport=PG_PORT,
        )

        cls.connection_factory = helpers.database_connection_factory(
            cls.connection_args,
        )

        cls.interlis_service = TwwInterlisServiceAdapter(
            connection_factory=cls.connection_factory,
        )

    def _data_file(
        self,
        name: str,
    ) -> Path:
        path = DATA_DIR / name

        self.assertTrue(
            path.is_file(),
            (
                f"Missing INTERLIS test fixture: {path}. "
                "Ensure the current plugin checkout is mounted into "
                "the QGIS test container."
            ),
        )

        return path

    def _output_file(
        self,
        name: str,
    ) -> Path:
        path = OUTPUT_DIR / name

        # Prevent a stale result from an earlier test run from satisfying
        # the current test.
        path.unlink(
            missing_ok=True,
        )

        return path

    @staticmethod
    def _model_name(
        group: str,
        *,
        lang: str = "de",
    ) -> str:
        return model_config.interlis_models[group].lang_name(
            lang,
        )

    @staticmethod
    def _topic_name(
        group: str,
        *,
        lang: str = "de",
    ) -> str:
        topics = model_config.interlis_models[group].topics_by_lang(
            lang,
        )

        if len(topics) != 1:
            raise AssertionError(
                "Expected exactly one topic for INTERLIS group "
                f"{group!r} and language {lang!r}, got "
                f"{sorted(topics)!r}."
            )

        return next(
            iter(
                topics,
            )
        )

    def _import_xtf(
        self,
        fixture_name: str,
        *,
        incremental_only: bool = False,
        filter_nulls: bool = True,
    ) -> Path:
        """
        Import an XTF through the same hooks services used by the CLI.

        Every invocation gets a separate trusted-import job ID so job state
        cannot accidentally be shared between sequential imports.
        """
        xtf_file = self._data_file(
            fixture_name,
        )

        job_id = str(
            uuid4(),
        )

        trusted_import_service = TwwTrustedImportService(
            connection_factory=self.connection_factory,
            job_id=job_id,
        )

        context = TwwInterlisContext(
            schema=config.IMPORT_SCHEMA,
            srid=2056,
            show_selection_dialog=False,
            logs_next_to_file=True,
            filter_nulls=filter_nulls,
            incremental_only=incremental_only,
            allow_schema_recreation=True,
        )

        try:
            trusted_import_service.begin(
                metadata={
                    "workflow_type": "trusted_import",
                    "import_schema": config.IMPORT_SCHEMA,
                    "incremental_import_schema": None,
                    "live_schema": config.TWW_OD_SCHEMA,
                    "allow_schema_recreation": True,
                },
            )

            self.interlis_service.import_xtf(
                xtf_file=xtf_file,
                context=context,
            )

            trusted_import_service.mark_applied()
        except Exception as exception:
            try:
                trusted_import_service.mark_failed(
                    reason=str(
                        exception,
                    ),
                )
            except Exception:
                logger.exception(
                    "Could not mark trusted-import job %s as failed.",
                    job_id,
                )

            raise

        logger.info(
            "Successfully imported %s using trusted-import job %s.",
            xtf_file,
            job_id,
        )

        return xtf_file

    def _export_xtf(
        self,
        output_name: str,
        *,
        model_group: str,
        selected_ids: tuple[str, ...] = (),
    ) -> Path:
        """
        Export an XTF through the same hooks adapter used by the CLI.
        """
        output_file = self._output_file(
            output_name,
        )

        context = TwwInterlisContext(
            schema=config.EXPORT_SCHEMA,
            srid=2056,
            logs_next_to_file=True,
            labels_file=None,
            selected_label_scale_indices=(),
            selected_ids=selected_ids,
            limit_to_selection=bool(
                selected_ids,
            ),
            allow_schema_recreation=True,
        )

        self.interlis_service.export_xtf(
            xtf_file=output_file,
            export_models=(
                self._model_name(
                    model_group,
                ),
            ),
            context=context,
        )

        self.assertTrue(
            output_file.is_file(),
            (
                "INTERLIS export completed without creating the expected "
                f"output file: {output_file}"
            ),
        )

        return output_file

    def _assert_scalar(
        self,
        query: str,
        expected,
    ) -> None:
        result = DatabaseUtils.fetchone(
            query,
        )

        self.assertIsNotNone(
            result,
            ("Expected the database query to return one row:\n" f"{query.strip()}"),
        )

        self.assertEqual(
            result[0],
            expected,
            (f"Expected {expected!r}, got {result[0]!r} for query:\n" f"{query.strip()}"),
        )

    def test_dss_dataset_import_export(self) -> None:
        self._import_xtf(
            TEST_DATASET_ORGANISATIONS,
        )

        self._import_xtf(
            TEST_DATASET_DSS,
        )

        self._assert_scalar(
            """
            SELECT urgency_figure
            FROM tww_od.wastewater_structure
            WHERE obj_id = 'ch080qwzVE000019';
            """,
            50,
        )

        export_xtf_file = self._export_xtf(
            "export_test_dss_dataset.xtf",
            model_group="dss",
        )

        topic_name = self._topic_name(
            "dss",
        )

        exported_object = get_xtf_object(
            export_xtf_file,
            topic_name,
            "Abwasserbauwerk",
            "ch080qwzVE000019",
        )

        self.assertIsNotNone(
            exported_object,
            ("Expected wastewater structure ch080qwzVE000019 " "in the exported DSS transfer."),
        )

    def test_minimal_sequential_import_export(self) -> None:
        """
        Exercise the sequential import workflow through the hooks services.
        """
        self._import_xtf(
            MINIMAL_DATASET_ORGANISATION_ARBON_ONLY,
        )
        self._import_xtf(
            MINIMAL_DATASET_SIA405_ABWASSER,
        )
        self._import_xtf(
            MINIMAL_DATASET_DSS,
        )
        self._import_xtf(
            MINIMAL_DATASET_KEK_MANHOLE_DAMAGE,
        )

        self._assert_scalar(
            """
            SELECT identifier
            FROM tww_od.organisation
            WHERE obj_id = 'ch20p3q400001497';
            """,
            "Arbon",
        )

        self._assert_scalar(
            """
            SELECT bottom_level
            FROM tww_od.wastewater_node
            WHERE obj_id = 'ch000000WN000001';
            """,
            448.0,
        )

        self._assert_scalar(
            """
            SELECT fk_maintenance_event
            FROM tww_od.re_maintenance_event_wastewater_structure
            WHERE fk_wastewater_structure = 'ch000000WS000001';
            """,
            "fk11abk6EX000002",
        )

        export_xtf_file = self._export_xtf(
            "export_minimal_kek_dataset.xtf",
            model_group="vsa_kek",
        )

        exported_examination = get_xtf_object(
            export_xtf_file,
            self._topic_name(
                "vsa_kek",
            ),
            "Untersuchung",
            "fk11abk6EX000002",
        )

        self.assertIsNotNone(
            exported_examination,
        )

    def test_modified_sia405_import_and_selected_dss_export(
        self,
    ) -> None:
        self._import_xtf(
            MINIMAL_DATASET_ORGANISATION_ARBON_ONLY,
        )
        self._import_xtf(
            MINIMAL_DATASET_SIA405_ABWASSER,
        )
        self._import_xtf(
            MINIMAL_DATASET_DSS,
        )
        self._import_xtf(
            MINIMAL_DATASET_KEK_MANHOLE_DAMAGE,
        )
        self._import_xtf(
            MINIMAL_DATASET_SIA405_ABWASSER_MODIFIED,
        )

        self._assert_scalar(
            """
            SELECT remark
            FROM tww_od.wastewater_networkelement
            WHERE obj_id = 'ch000000RE000001';
            """,
            "rp_from_level modified",
        )

        export_xtf_file = self._export_xtf(
            "export_minimal_dss_selection.xtf",
            model_group="dss",
            selected_ids=(
                "ch000000WN000002",
                "ch000000WN000003",
                "ch000000RE000002",
            ),
        )

        topic_name = self._topic_name(
            "dss",
        )

        excluded_pipe_profile = get_xtf_object(
            export_xtf_file,
            topic_name,
            "Rohrprofil",
            "ch000000PP000001",
        )
        self.assertIsNone(
            excluded_pipe_profile,
        )

        included_pipe_profile = get_xtf_object(
            export_xtf_file,
            topic_name,
            "Rohrprofil",
            "ch000000PP000002",
        )
        self.assertIsNotNone(
            included_pipe_profile,
        )

    def test_export_preserves_height_width_ratio(self) -> None:
        self._import_xtf(
            MINIMAL_DATASET_ORGANISATION_ARBON_ONLY,
        )
        self._import_xtf(
            MINIMAL_DATASET_SIA405_ABWASSER,
        )

        export_xtf_file = self._export_xtf(
            "export_minimal_sia405_abwasser.xtf",
            model_group="sia405_abwasser",
        )

        height_width_ratio = get_xtf_object_node_text(
            export_xtf_file,
            self._topic_name(
                "sia405_abwasser",
            ),
            "Rohrprofil",
            "ch000000PP000003",
            "HoehenBreitenverhaeltnis",
        )

        self.assertEqual(
            height_width_ratio,
            "1.12857",
        )

    def test_get_xtf_models(self) -> None:
        test_cases = (
            (
                MINIMAL_DATASET_DSS,
                (
                    self._model_name(
                        "dss",
                    ),
                ),
            ),
            (
                MINIMAL_DATASET_SIA405_ABWASSER,
                (
                    self._model_name(
                        "sia405_abwasser",
                    ),
                ),
            ),
            (
                MINIMAL_DATASET_ORGANISATION_ARBON_ONLY,
                (
                    self._model_name(
                        "sia405_base_abwasser",
                    ),
                ),
            ),
            (
                TEST_DATASET_DSS,
                (
                    "Units",
                    "Base",
                    self._model_name(
                        "sia405_base_abwasser",
                    ),
                    self._model_name(
                        "dss",
                    ),
                ),
            ),
            (
                TEST_DATASET_ORGANISATIONS,
                (
                    self._model_name(
                        "sia405_base_abwasser",
                    ),
                ),
            ),
            (
                MINIMAL_DATASET_KEK_MANHOLE_DAMAGE,
                (
                    self._model_name(
                        "vsa_kek",
                    ),
                ),
            ),
        )

        for fixture_name, expected_models in test_cases:
            with self.subTest(
                fixture=fixture_name,
            ):
                xtf_file = self._data_file(
                    fixture_name,
                )

                models = InterlisTools.get_xtf_models(
                    xtf_file=xtf_file,
                )

                self.assertCountEqual(
                    models,
                    expected_models,
                )
