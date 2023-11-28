import decimal
import logging
import os
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET

from qgepqwat2ili import main, utils
from qgepqwat2ili.qgep.model_qgep import get_qgep_model
from sqlalchemy.orm import Session

# Display logging in unittest output
logger = logging.getLogger()
logger.setLevel(logging.WARNING)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.WARNING)
logger.addHandler(handler)


def findall_in_xml_kek_2019(root, tag, basket="VSA_KEK_2019_LV95.KEK"):
    ns = {"ili": "http://www.interlis.ch/INTERLIS2.3"}
    return root.findall(f"ili:DATASECTION/ili:{basket}/ili:{tag}", ns)


def findall_in_xml_sia_abwasser_2015(root, tag, basket="SIA405_ABWASSER_2015_LV95.SIA405_Abwasser"):
    ns = {"ili": "http://www.interlis.ch/INTERLIS2.3"}
    return root.findall(f"ili:DATASECTION/ili:{basket}/ili:{tag}", ns)


class TestQGEPUseCases(unittest.TestCase):
    def test_case_a_import_wincan_xtf(self):
        """
        # A. import Wincan-generated xtf data into QGEP

        We recieve data from a TV inspection company as a Wincan exported .xtf file. We want this data loaded into QGEP.
        """

        path = os.path.join(os.path.dirname(__file__), "..", "data", "test_data", "case_a_import_from_wincan.xtf")

        # Prepare db (we import in a full schema)
        main(["setupdb", "full"])

        QGEP = get_qgep_model()
        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.damage_channel).count(), 0)
        self.assertEqual(session.query(QGEP.examination).count(), 0)
        self.assertEqual(session.query(QGEP.data_media).count(), 0)
        self.assertEqual(session.query(QGEP.file).count(), 0)
        self.assertEqual(session.query(QGEP.organisation).count(), 15)
        session.close()

        main(["qgep", "import", path, "--recreate_schema"])

        # make sure all elements got imported
        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.damage_channel).count(), 8)
        self.assertEqual(session.query(QGEP.examination).count(), 1)
        self.assertEqual(session.query(QGEP.data_media).count(), 2)
        self.assertEqual(session.query(QGEP.file).count(), 4)
        self.assertEqual(session.query(QGEP.organisation).count(), 18)

        # checking some properties
        damage = session.query(QGEP.damage_channel).get("fk11abk6w70lrfne")
        self.assertEqual(damage.quantification1, decimal.Decimal("300"))

        data = session.query(QGEP.file).get("fk11abk6w70lrfnc")
        self.assertEqual(data.identifier, "8486-8486.0010_0001.mpg")
        self.assertEqual(data.path_relative, "inspectiondata20210120/videos/")
        session.close()

        # assert idempotency

        main(["qgep", "import", path, "--recreate_schema"])
        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.damage_channel).count(), 8)
        self.assertEqual(session.query(QGEP.examination).count(), 1)
        self.assertEqual(session.query(QGEP.data_media).count(), 2)
        self.assertEqual(session.query(QGEP.file).count(), 4)
        self.assertEqual(session.query(QGEP.organisation).count(), 18)
        session.close()

    def test_case_b_export_complete_qgep_to_xtf(self):
        """
        # B. export the whole QGEP model to interlis
        """

        # Prepare db
        main(["setupdb", "full"])

        path = os.path.join(tempfile.mkdtemp(), "export.xtf")
        main(["qgep", "export", path, "--recreate_schema"])

    def test_case_d_import_complete_xtf_to_qgep(self):
        """
        # D. import a whole valid interlis transfer file into QGEP
        """

        # Incomming XTF case_c_import_all_without_errors.xtf
        # THIS INPUT FILE IS VALID !
        path = os.path.join(
            os.path.dirname(__file__), "..", "data", "test_data", "case_d_import_all_without_errors.xtf"
        )

        # Prepare subset db (we import in an empty schema)
        main(["setupdb", "empty"])

        QGEP = get_qgep_model()

        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.channel).count(), 0)
        self.assertEqual(session.query(QGEP.manhole).count(), 0)
        session.close()

        main(["qgep", "import", path, "--recreate_schema"])

        # make sure all elements got imported
        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.channel).count(), 102)
        self.assertEqual(session.query(QGEP.manhole).count(), 49)

        # checking some properties  # TODO : add some more...
        self.assertEqual(session.query(QGEP.manhole).get("ch080qwzNS000113").year_of_construction, 1950)
        session.close()

    def test_case_e_export_selection(self):
        """
        # E. export a selection
        """

        # Prepare db
        main(["setupdb", "full"])

        # 1. Export VSA_KEK_2019_LV95
        path = os.path.join(tempfile.mkdtemp(), "export_VSA_KEK_2019_LV95.xtf")
        selection = [
            # reach_id
            "ch13p7mzRE001221",
            # node_a_id
            "ch13p7mzWN003445",
            # node_b_id
            "ch13p7mzWN008122",
        ]
        labels_file = os.path.join(os.path.dirname(__file__), "data", "labels.geojson")
        main(
            [
                "qgep",
                "export",
                path,
                "--recreate_schema",
                "--selection",
                ",".join(selection),
                "--labels_file",
                labels_file,
            ]
        )

        # Perform various checks
        logger.warning("Perform various checks VSA_KEK_2019_LV95 ...")

        root = ET.parse(path)

        self.assertEqual(len(findall_in_xml_kek_2019(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Kanal")), 1)
        self.assertEqual(
            len(findall_in_xml_kek_2019(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Normschacht")), 2
        )
        self.assertEqual(
            len(findall_in_xml_kek_2019(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Haltung_Text")), 3
        )
        self.assertEqual(
            len(findall_in_xml_kek_2019(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Abwasserbauwerk_Text")), 6
        )

    def test_case_f_export_selection_sia405(self):
        """
        # F. export a selection
        """

        path = os.path.join(tempfile.mkdtemp(), "export_VSA_KEK_2019_LV95.xtf")
        selection = [
            # reach_id
            "ch13p7mzRE001221",
            # node_a_id
            "ch13p7mzWN003445",
            # node_b_id
            "ch13p7mzWN008122",
        ]
        labels_file = os.path.join(os.path.dirname(__file__), "data", "labels.geojson")
        main(
            [
                "qgep",
                "export",
                path,
                "--export_sia405",
                "--recreate_schema",
                "--selection",
                ",".join(selection),
                "--labels_file",
                labels_file,
            ]
        )

        # Perform various checks
        logger.warning("Perform various checks SIA405_ABWASSER_2015_LV95 ...")

        root = ET.parse(path)

        self.assertEqual(
            len(findall_in_xml_sia_abwasser_2015(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Kanal")), 1
        )
        self.assertEqual(
            len(findall_in_xml_sia_abwasser_2015(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Normschacht")), 2
        )
        self.assertEqual(
            len(findall_in_xml_sia_abwasser_2015(root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Haltung_Text")), 3
        )
        self.assertEqual(
            len(
                findall_in_xml_sia_abwasser_2015(
                    root, "SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Abwasserbauwerk_Text"
                )
            ),
            6,
        )


class TestRegressions(unittest.TestCase):
    def test_regression_001_self_referencing_organisation(self):
        """
        Due to current logic of the import script, organisations may be created multiple times.

        Currently passing because metaattribute_common is disabled on organisation
        """

        path = os.path.join(
            os.path.dirname(__file__), "..", "data", "test_data", "regression_001_self_referencing_organisation.xtf"
        )

        # Prepare db (we import in an empty schema)
        main(["setupdb", "empty"])

        QGEP = get_qgep_model()

        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.organisation).count(), 0)
        session.close()

        main(["qgep", "import", path, "--recreate_schema"])

        session = Session(utils.sqlalchemy.create_engine())
        self.assertEqual(session.query(QGEP.organisation).count(), 1)
        organisation = session.query(QGEP.organisation).first()
        self.assertEqual(organisation, organisation.fk_dataowner__REL)
        self.assertEqual(organisation, organisation.fk_provider__REL)
        session.close()
