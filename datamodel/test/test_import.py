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

    def test_import_insert(self):
        row = {
            "identifier": "foobarbaz",
            "co_level": 123.456,
            "wn_bottom_level": 120.456,
            "verified": True,
        }

        # update
        obj_id = self.insert_check("import_vw_manhole", row)

        # it should be calculated correctly in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it should be visible in the import_vw_manhole view
        row = self.select("import_vw_manhole", obj_id)
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)

        # delete it manually
        self.delete("import_manhole_quarantine", obj_id, schema="tww_od")

    # - level calculation failing because only no reference level
    #   -> not updated structure with calculated values
    #   -> still in quarantine
    def test_calculation_level_fail(self):

        row = {
            "identifier": "import_20",
            "ws_type": "manhole",
            "ma_function": 8736,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600000 1200000)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        row = {
            "_depth": 12.220,
            "co_level": None,
            "wn_bottom_level": None,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be calculated correctly in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it should be visible in the import_vw_manhole view
        row = self.select("import_vw_manhole", obj_id)
        self.assertNotEqual(row["_depth"], decimal.Decimal("12.220"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)

        # delete it manually
        self.delete("import_manhole_quarantine", obj_id, schema="tww_od")

    # - ws bottom level calculation
    #   -> updated structure with calculated values
    def test_calculation_wn_bottom_level(self):
        row = {
            "identifier": "import_30",
            "ws_type": "manhole",
            "ma_function": 8736,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600001 1200001)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        row = {
            "_depth": 2.220,
            "wn_bottom_level": None,
            "co_level": 22.220,
            "inlet_3_material": 5081,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("import_vw_manhole", row, obj_id, "tww_app")

        # it should be calculated correctly in the live view tww_app.vw_tww_wastewater_structure
        row = self.select("vw_tww_wastewater_structure", obj_id)
        self.assertEqual(row["_depth"], decimal.Decimal("2.220"))
        self.assertEqual(row["co_level"], decimal.Decimal("22.220"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("20"))

        # it should be visible in the vw_manhole view
        row = self.select("import_vw_manhole", obj_id)
        self.assertEqual(row["_depth"], decimal.Decimal("2.220"))
        self.assertEqual(row["co_level"], decimal.Decimal("22.220"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("20"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, "tww_od")
        self.assertIsNone(row)

    # - cover level calculation
    #   -> updated structure with calculated values
    #   -> deleted in quarantine
    def test_calculation_co_level(self):
        # obj_id from the test data
        row = {
            "identifier": "import_40",
            "ws_type": "manhole",
            "ma_function": 8736,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600002 1200002)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        row = {
            "_depth": 7.780,
            "wn_bottom_level": 22.220,
            "co_level": None,
            "inlet_3_material": 5081,
            "outlet_1_material": 5081,
            "verified": True,
        }

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be calculated correctly in the live view vw_tww_wastewater_structure
        row = self.select("vw_tww_wastewater_structure", obj_id)
        self.assertIsNotNone(row)
        self.assertEqual(row["_depth"], decimal.Decimal("7.780"))
        self.assertEqual(row["co_level"], decimal.Decimal("30"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("22.220"))

        # it should be visible in the import_vw_manhole view
        row = self.select("import_vw_manhole", obj_id, "tww_app")
        self.assertEqual(row["_depth"], decimal.Decimal("7.780"))
        self.assertEqual(row["co_level"], decimal.Decimal("30"))
        self.assertEqual(row["wn_bottom_level"], decimal.Decimal("22.220"))

        # it shouldn't be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, "tww_od")
        self.assertIsNone(row)

    # - delete of structure
    #   -> delete in live
    def test_delete_structure(self):
        row = {
            "identifier": "import_40",
            "ws_type": "manhole",
            "ma_function": 8736,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600003 1200003)'), 2056)"
            ),
        }
        obj_id = self.insert_check(
            "vw_tww_wastewater_structure",
            row,
        )

        # change deleted from false to true
        row = {"deleted": True, "verified": True}

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be deleted in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNone(row)

        # it should not be visible anymore in the import_vw_manhole view
        row = self.select("import_vw_manhole", obj_id)
        self.assertIsNone(row)

    # - delete of structure but have verified at false
    #   -> do not delete in live
    def test_delete_structure_failing(self):
        # test data
        row = {
            "identifier": "import_50",
            "ws_type": "manhole",
            "ma_function": 8736,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600004 1200004)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        # change deleted from false to true
        # but do not set verified to true
        row = {"deleted": True, "verified": False}

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should not be deleted in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNotNone(row)

        # it should still be visible anymore in the import_vw_manhole view
        row = self.select("import_vw_manhole", obj_id)
        self.assertIsNotNone(row)

    # - correct update with 1 old outlet and 1 new outlet and 0 old inlet and 0 new inlet
    #   -> updated structure
    #   -> updated reach
    #   -> updated reach_point
    #   -> deleted in quarantene

    def test_update_with_outlet(self):
        # obj_id from the test data
        ws_row = {
            "identifier": "import_60",
            "ws_type": "manhole",
            "ma_function": 8736,
            "co_level": 456.123,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600005 1200005)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", ws_row)

        ws_row_new = self.select("vw_tww_wastewater_structure", obj_id)

        re_row = {
            "clear_height": 100,
            "rp_from_fk_wastewater_networkelement": ws_row_new["wn_obj_id"],
            "ws_identifier": "import_60_out",
            "ch_usage_current": 4514,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(2600005, 1200005, 'NaN'), ST_MakePoint(2600006, 1200006, 'NaN')), 2056))"
            ),
        }

        _ = self.insert_check("vw_tww_reach", re_row)

        # change remark from 'Strasseneinlauf' to 'Strassenauslauf'
        # change co_material from 233 to 3015
        row = {
            "remark": "Strassenauslauf",
            "co_material": 3015,
            "outlet_1_material": 5081,
            "outlet_1_clear_height": 160,
            "outlet_1_depth_m": 1.123,
            "photo1": "funky_selfie.png",
            "verified": True,
        }

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be in the live table tww_od.wastewater_structure
        row = self.select("wastewater_structure", obj_id, "tww_od")
        self.assertIsNotNone(row)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be in the view import_vw_manhole
        row = self.select("import_vw_manhole", obj_id)
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
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
            WHERE ws.obj_id = %(obj_id)s"
            ).format(schema=psycopg.sql.Identifier("tww_od")),
            {"obj_id": obj_id},
        )
        row = cur.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row["material"], 5081)
        self.assertEqual(row["clear_height"], 160)
        self.assertEqual(row["level"], decimal.Decimal("455.000"))

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

    def test_update_with_wrong_material(self):
        # obj_id from the test data
        ws_row = {
            "identifier": "import_70",
            "ws_type": "manhole",
            "ma_function": 8736,
            "co_level": 456.123,
            "co_material": 5547,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600006 1200006)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", ws_row)

        # change co_material from 233 to 666, what not exists in the table tww_vl.cover_material
        row = {"co_material": 666, "outlet_1_material": 5081, "verified": True}

        # update
        self.update("import_vw_manhole", row, obj_id)

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

        # it shouldn't be updated in the view import_vw_manhole
        row = self.select("import_vw_manhole", obj_id)
        self.assertNotEqual(row["co_material"], 666)

        # it should be in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 666)
        self.assertTrue(row["outlet_okay"])
        self.assertTrue(row["inlet_okay"])
        self.assertFalse(row["structure_okay"])

        row = {"co_material": 5547}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od")

        # it should be updated in the view import_vw_manhole
        row = self.select("import_vw_manhole", obj_id)
        self.assertEqual(row["co_material"], 5547)

        # it shouldn't be anymore in the quarantine tww_od.import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 1 new outlet and 0 old inlet and 1 new inlet
    #   -> updated structure
    #   -> updated reach for outlet
    #   -> still in quarantene
    #   - update inlet_okay true
    #     -> deleted in quarantene

    def test_update_with_unexpected_inlet(self):
        # obj_id from the test data
        ws_row = {
            "identifier": "import_80",
            "ws_type": "manhole",
            "ma_function": 8736,
            "co_level": 456.123,
            "co_material": 233,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600007 1200007)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", ws_row)

        ws_row_new = self.select("vw_tww_wastewater_structure", obj_id)

        re_row = {
            "clear_height": 100,
            "rp_from_fk_wastewater_networkelement": ws_row_new["wn_obj_id"],
            "ws_identifier": "import_80_out",
            "ch_usage_current": 4514,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(2600007, 1200007, 'NaN'), ST_MakePoint(2600006, 1200006, 'NaN')), 2056))"
            ),
        }

        _ = self.insert_check("vw_tww_reach", re_row)

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
        self.update("import_vw_manhole", row, obj_id)

        # it should be in the view vw_manhole
        row = self.select("import_vw_manhole", obj_id)
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
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
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
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)

        row = {"inlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 0 new outlet and 0 old inlet and 0 new inlet
    #   -> updated structure
    #   -> still in quarantene
    #   - update outlet_okay true
    #     -> deleted in quarantene
    # @unittest.skip("This test needs the demo data to work")
    def test_update_with_unexpected_outlet(self):
        # obj_id from the test data
        ws_row = {
            "identifier": "import_90",
            "ws_type": "manhole",
            "ma_function": 8736,
            "co_level": 456.123,
            "co_material": 233,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600008 1200008)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", ws_row)

        ws_row_new = self.select("vw_tww_wastewater_structure", obj_id)

        re_row = {
            "clear_height": 100,
            "rp_to_fk_wastewater_networkelement": ws_row_new["wn_obj_id"],
            "ws_identifier": "import_90_in",
            "ch_usage_current": 4514,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(2600007, 1200008, 'NaN'), ST_MakePoint(2600008, 1200008, 'NaN')), 2056))"
            ),
        }

        _ = self.insert_check("vw_tww_reach", re_row)

        # change remark from 'Strasseneinlauf' to 'Strassenauslauf'
        # change co_material from 233 to 3015
        row = {"remark": "Strassenauslauf", "co_material": 3015, "verified": True}

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be in the view vw_manhole
        row = self.select("import_vw_manhole", obj_id)
        self.assertIsNotNone(row)
        self.assertEqual(row["co_material"], 3015)
        self.assertEqual(row["remark"], "Strassenauslauf")

        # it should be still in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)

        row = {"outlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNone(row)

    # - problematic update with 1 old outlet and 1 new outlet and 1 old inlet and 2 new inlet
    #   -> updated structure
    #   -> updated reach for outlet
    #   -> still in quarantene
    #   - update inlet_okay true
    #     -> deleted in quarantene

    def test_update_with_multiple_inlets(self):
        ws_row = {
            "identifier": "import_100",
            "ws_type": "manhole",
            "ma_function": 8736,
            "co_level": 456.123,
            "co_material": 233,
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600009 12000097)'), 2056)"
            ),
        }
        obj_id = self.insert_check("vw_tww_wastewater_structure", ws_row)

        ws_row_new = self.select("vw_tww_wastewater_structure", obj_id)

        re_row = {
            "clear_height": 100,
            "rp_to_fk_wastewater_networkelement": ws_row_new["wn_obj_id"],
            "ws_identifier": "import_100_in",
            "ch_usage_current": 4514,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(2600007, 1200009, 'NaN'), ST_MakePoint(2600009, 1200009, 'NaN')), 2056))"
            ),
        }

        _ = self.insert_check("vw_tww_reach", re_row)

        # change remark from 'E09' to 'E10'
        # change co_material from 233 to 3015
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
            "inlet_4_material": 5081,
            "inlet_4_clear_height": 160,
            "inlet_4_depth_m": 100,
            "verified": True,
        }

        # update
        self.update("import_vw_manhole", row, obj_id)

        # it should be in the view import_vw_manhole
        row = self.select("import_vw_manhole", obj_id)
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
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure\
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
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNotNone(row)

        row = {"inlet_okay": "true"}

        # update
        self.update("import_manhole_quarantine", row, obj_id, schema="tww_od")

        # it shouldn't be anymore in the quarantine import_manhole_quarantine
        row = self.select("import_manhole_quarantine", obj_id, schema="tww_od")
        self.assertIsNone(row)

    # - general test
    # @unittest.skip("This test needs the demo data to work")
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
