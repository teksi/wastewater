import decimal
import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestImport(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    # - level calculation failing because only no reference level
    #   -> not updated structure with calculated values
    #   -> still in quarantine
    @unittest.skip("This test needs the demo data to work")
    def test_calculation_level_fail(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000011"

        row = {
            "_depth": 12.220,
            "co_level": None,
            "wn_bottom_level": None,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id)

        # it should be calculated correctly in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it should be visible in the vw_manhole view
        row = self.select("vw_manhole", obj_id)
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)

        # delete it manually
        self.delete("import_manhole_quarantine", obj_id, schema="tww_od.import_")

    # - ws bottom level calculation
    #   -> updated structure with calculated values
    @unittest.skip("This test needs the demo data to work")
    def test_calculation_wn_bottom_level(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000071"

        row = {
            "_depth": 2.220,
            "wn_bottom_level": None,
            "co_level": 22.220,
            "inlet_3_material": 5081,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id, "tww_app")

        # it should be calculated correctly in the live view tww_od.vw_tww_wastewater_structure
        row = self.select("vw_tww_wastewater_structure", obj_id, "tww_od")
        self.assertEqual(row["_depth"], decimal.Decimal("2.220"))
        self.assertEqual(row["co_level"], decimal.Decimal("22.220"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("20"))

        # it should be visible in the vw_manhole view
        row = self.select("vw_manhole", obj_id)
        self.assertEqual(row["_depth"], decimal.Decimal("2.220"))
        self.assertEqual(row["co_level"], decimal.Decimal("22.220"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("20"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, "tww_od.import_")
        self.assertIsNone(row)

    # - cover level calculation
    #   -> updated structure with calculated values
    #   -> deleted in quarantine
    @unittest.skip("This test needs the demo data to work")
    def test_calculation_co_level(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000071"

        row = {
            "_depth": 7.780,
            "wn_bottom_level": 22.220,
            "co_level": None,
            "inlet_3_material": 5081,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id, "tww_od.import_")

        # it should be calculated correctly in the live view vw_tww_wastewater_structure
        row = self.select("vw_tww_wastewater_structure", obj_id, "tww_app")
        self.assertIsNotNone(row)
        self.assertEqual(row["_depth"], decimal.Decimal("7.780"))
        self.assertEqual(row["co_level"], decimal.Decimal("30"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("22.220"))

        # it should be visible in the vw_manhole view
        row = self.select("vw_manhole", obj_id, "tww_app")
        self.assertEqual(row["_depth"], decimal.Decimal("7.780"))
        self.assertEqual(row["co_level"], decimal.Decimal("30"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("22.220"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, "tww_od.import_")
        self.assertIsNone(row)

    # - delete of structure
    #   -> delete in live
    @unittest.skip("This test needs the demo data to work")
    def test_delete_structure(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000037"

        # change deleted from false to true
        row = {"deleted": True, "verified": True}

        # update
        self.update("vw_manhole", row, obj_id)

        # it should be deleted in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNone(row)

        # it should not be visible anymore in the vw_manhole view
        row = self.select("vw_manhole", obj_id)
        self.assertIsNone(row)

    # - delete of structure but have verified at false
    #   -> do not delete in live
    @unittest.skip("This test needs the demo data to work")
    def test_delete_structure_failing(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000044"

        # change deleted from false to true
        # but do not set verified to true
        row = {"deleted": True, "verified": False}

        # update
        self.update("vw_manhole", row, obj_id)

        # it should not be deleted in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNotNone(row)

        # it should still be visible anymore in the vw_manhole view
        row = self.select("vw_manhole", obj_id)
        self.assertIsNotNone(row)

    # - correct update with 1 old outlet and 1 new outlet and 0 old inlet and 0 new inlet
    #   -> updated structure
    #   -> updated reach
    #   -> updated reach_point
    #   -> deleted in quarantene
    @unittest.skip("This test needs the demo data to work")
    def test_update_with_outlet(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000012"

        # change remark from 'Strasseneinlauf' to 'Strassenauslauf'
        # change co_material from 233 to 3015
        row = {
            "remark": "Strassenauslauf",
            "co_material": 3015,
            "outlet_1_material": 5081,
            "outlet_1_clear_height": 160,
            "outlet_1_depth_m": 100,
            "photo1": "funky_selfie.png",
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id)

        # it should be in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNotNone(row)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be in the view vw_manhole
        row = self.select("vw_manhole", obj_id)
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 3015)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be in the live table tww_od.reach and tww_od.reach_point
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL(
                "SELECT re.material, re.clear_height, rp.level, ws.co_level\
            FROM {schema}.reach re\
            LEFT JOIN {schema}.reach_point rp ON rp.obj_id = re.fk_reach_point_from\
            LEFT JOIN {schema}.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement\
            LEFT JOIN {schema}.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
            WHERE ws.obj_id = %(obj_id)s"
            ).format(schema=psycopg.sql.Identifier("tww_od")),
            {"obj_id": obj_id},
        )
        row = cur.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row["material"], 5081)
        self.assertEqual(row["clear_height"], 160)
        self.assertEqual(row["level"], decimal.Decimal("301.700"))

        # the photo should be in the live table tww_od.file
        row = self.select("file", obj_id, "tww_od")
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL(
                "SELECT *\
            FROM {schema}.file\
            WHERE object = %(obj_id)s"
            ).format(schema=psycopg.sql.Identifier("tww_od")),
            {"obj_id": obj_id},
        )
        row = cur.fetchone()
        self.assertEqual(row["identifier"], "funky_selfie.png")

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id)
        self.assertIsNone(row)

    # - incorrect update with a wrong cover material
    #   -> updated reach
    #   -> updated reach_point
    #   -> still in quarantene (inlet_okay t, outlet_okay t but structure_okay f)
    #   - update material
    #     -> updated structure
    #     -> deleted in quarantene
    @unittest.skip("This test needs the demo data to work")
    def test_update_with_wrong_material(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000012"

        # change co_material from 233 to 666, what not exists in the table tww_vl.cover_material
        row = {"co_material": 666, "outlet_1_material": 5081, "verified": True}

        # update
        self.update("vw_manhole", row, obj_id, schema="tww_od.import_")

        # it should be in the live table tww_od.reach and tww_od.reach_point
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL(
                "SELECT re.material, re.clear_height, rp.level, ws.co_level\
            FROM tww_od.reach re\
            LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from\
            LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement\
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
            WHERE ws.obj_id = %(obj_id)s"
            ),
            {"obj_id": obj_id},
        )

        row = cur.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row["material"], 5081)

        # it shouldn't be updated in the view vw_manhole
        row = self.select("vw_manhole", obj_id, schema="tww_od.import_")
        self.assertNotEqual(row["co_material"], 666)

        # it should be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 666)
        self.assertTrue(row["outlet_okay"])
        self.assertTrue(row["inlet_okay"])
        self.assertFalse(row["structure_okay"])

        row = {"co_material": 5547}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od.import_")

        # it should be updated in the view vw_manhole
        row = self.select("vw_manhole", obj_id)
        self.assertEqual(row["co_material"], 5547)

        # it shouldn't be anymore in the quarantine tww_od.import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 1 new outlet and 0 old inlet and 1 new inlet
    #   -> updated structure
    #   -> updated reach for outlet
    #   -> still in quarantene
    #   - update inlet_okay true
    #     -> deleted in quarantene
    @unittest.skip("This test needs the demo data to work")
    def test_update_with_unexpected_inlet(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000012"

        # change remark from 'Strasseneinlauf' to 'Strassenauslauf'
        # change co_material from 233 to 3015
        row = {
            "remark": "Strassenauslauf",
            "co_material": 3015,
            "outlet_1_material": 5081,
            "outlet_1_clear_height": 160,
            "outlet_1_depth_m": 100,
            "inlet_3_material": 5081,
            "inlet_3_clear_height": 160,
            "inlet_3_depth_m": 100,
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id, schema="tww_od.import_")

        # it should be in the view vw_manhole
        row = self.select("vw_manhole", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 3015)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be in the live table tww_od.reach and tww_od.reach_point
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL(
                "SELECT re.material, re.clear_height, rp.level, ws.co_level\
            FROM {schema}.reach re\
            LEFT JOIN {schema}.reach_point rp ON rp.obj_id = re.fk_reach_point_from\
            LEFT JOIN {schema}.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement\
            LEFT JOIN {schema}.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
            WHERE ws.obj_id = %(obj_id)s"
            ).format(schema=psycopg.sql.Identifier("tww_od")),
            {"obj_id": obj_id},
        )
        row = cur.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row["material"], 5081)
        self.assertEqual(row["clear_height"], 160)
        self.assertEqual(row["level"], decimal.Decimal("301.700"))

        # it should be still in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)

        row = {"inlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od.import_")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 0 new outlet and 0 old inlet and 0 new inlet
    #   -> updated structure
    #   -> still in quarantene
    #   - update outlet_okay true
    #     -> deleted in quarantene
    @unittest.skip("This test needs the demo data to work")
    def test_update_with_unexpected_outlet(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA000012"

        # change remark from 'Strasseneinlauf' to 'Strassenauslauf'
        # change co_material from 233 to 3015
        row = {"remark": "Strassenauslauf", "co_material": 3015, "verified": True}

        # update
        self.update("vw_manhole", row, obj_id, schema="tww_od.import_")

        # it should be in the view vw_manhole
        row = self.select("vw_manhole", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 3015)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be still in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)

        row = {"outlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od.import_")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 1 new outlet and 4 old inlet and 4 new inlet
    #   -> updated structure
    #   -> updated reach for outlet
    #   -> still in quarantene
    #   - update inlet_okay true
    #     -> deleted in quarantene
    @unittest.skip("This test needs the demo data to work")
    def test_update_with_multiple_inlets(self):
        # obj_id from the test data
        obj_id = "ch13p7mzMA005266"

        # change remark from 'E09' to 'E10'
        # change co_material from 3016 to 3015
        row = {
            "remark": "E10",
            "co_material": 3015,
            "co_level": 500,
            "outlet_1_material": 5081,
            "outlet_1_clear_height": 160,
            "outlet_1_depth_m": 100,
            "inlet_3_material": 5081,
            "inlet_3_clear_height": 160,
            "inlet_3_depth_m": 100,
            "verified": True,
        }

        # update
        self.update("vw_manhole", row, obj_id)

        # it should be in the view vw_manhole
        row = self.select("vw_manhole", obj_id)
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 3015)
        self.assertEqual(row["remark"], "E10")

        # it should be in the live table tww_od.reach and tww_od.reach_point
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL(
                "SELECT re.material, re.clear_height, rp.level, ws.co_level\
            FROM {schema}.reach re\
            LEFT JOIN {schema}.reach_point rp ON rp.obj_id = re.fk_reach_point_from\
            LEFT JOIN {schema}.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement\
            LEFT JOIN {schema}.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
            WHERE ws.obj_id = %(obj_id)s"
            ).format(schema=psycopg.sql.Identifier("tww_od")),
            {"obj_id": obj_id},
        )
        row = cur.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row["material"], 5081)
        self.assertEqual(row["clear_height"], 160)
        self.assertEqual(row["level"], decimal.Decimal("400"))

        # it should be still in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNotNone(row)

        row = {"inlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od.import_")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od.import_")
        self.assertIsNone(row)

    # - general test
    @unittest.skip("This test needs the demo data to work")
    def test_general(self):
        # it should be in the live table tww_od.reach and tww_od.reach_point
        cur = self.cursor()
        cur.execute(
            psycopg.sql.SQL("SELECT * FROM {schema}.wastewater_structure LIMIT 1").format(
                schema=psycopg.sql.Identifier("tww_od")
            )
        )
        row = cur.fetchone()
        self.assertIsNotNone(row)


if __name__ == "__main__":
    unittest.main()
