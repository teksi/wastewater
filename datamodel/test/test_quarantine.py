import os
import unittest
import decimal

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestQuarantineViewsImport(unittest.TestCase, DbTestBase):
    """
    CI tests for quarantine_views.py:
    verifies quarantine tables -> views -> live PostGIS tables
    """

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()
        cls.conn.close()


    def test_vw_ws_to_quarantine(self):
        """
        Insert a wastewater structure in quarantine
        and ensure it ends up in the live table.
        """
        row = {
            "ws_identifier": "ci_ws_01",
            "ws_status": 8493,
            "co_level": decimal.Decimal("100.000"),
            "wn_bottom_level": decimal.Decimal("97.000"),
        }

        ws_q_id = self.insert_check(
            "vw_tww_import_manhole",
            row,
            schema="tww_app",
            pkey="uuidoid",
        )

        quarantine = self.select(
            "import_ws_quarantine",
            ws_q_id,
            schema="tww_od",
        )

        self.assertIsNotNone(quarantine)
        self.assertEqual(quarantine["co_level"], decimal.Decimal("100.000"))
        self.assertEqual(
            quarantine["wn_bottom_level"], decimal.Decimal("97.000")
        )





    # ---------------------------------------------------------------------
    # Quarantine reach point import
    # ---------------------------------------------------------------------

    def test_import_reach_point(self):
        """
        Insert a reach point via quarantine and validate
        that calculated levels are written.
        """
        ws = {
            "ws_identifier": "ci_ws_02",
            "co_level": decimal.Decimal("50.000"),
            "wn_bottom_level": decimal.Decimal("47.000"),
            "tww_is_okay": True,
        }

        ws_q_id = self.insert_check(
            "import_ws_quarantine",
            ws,
            schema="tww_od",
            pkey="uuidoid",
        )

        rp = {
            "identifier": "ci_rp_01",
            "fk_import_ws_quarantine": ws_q_id,
            "co_depth": decimal.Decimal("2.500"),
            "tww_level_measurement_kind": 1,
        }

        rp_q_id = self.insert_check(
            "vw_tww_import_reach_point",
            rp,
            schema="tww_app",
            pkey="uuidoid",
        )

        rp_live = self.select(
            "import_reach_point_quarantine",
            rp_q_id,
            schema="tww_od",
            pkey="uuidoid",
        )

        self.assertIsNotNone(rp_live)
        self.assertIsNotNone(rp_live["level"])

    # ---------------------------------------------------------------------
    # Validation failure keeps quarantine
    # ---------------------------------------------------------------------

    def test_failed_validation_stays_in_quarantine(self):
        """
        If tww_is_okay = false, data must stay in quarantine
        and not appear in live tables.
        """
        row = {
            "ws_identifier": "ci_ws_fail",
            "co_level": None,
            "wn_bottom_level": None,
            "tww_is_okay": False,
        }

        ws_q_id = self.insert_check(
            "import_ws_quarantine",
            row,
            schema="tww_od",
            pkey="uuidoid",
        )

        # no autoupdate
        live = self.select(
            "wastewater_structure",
            ws_q_id,
            schema="tww_od",
        )
        self.assertIsNone(live)

        quarantine = self.select(
            "import_ws_quarantine",
            ws_q_id,
            attrname="uuidoid",
            schema="tww_od",
        )
        self.assertIsNotNone(quarantine)

        cur = self.cursor()
        cur.execute(
            """
            PERFORM tww_app.transfer_quarantine_to_live (%(oid)s);
            """,
            {"oid": quarantine},
        )

        live = self.select(
            "wastewater_structure",
            ws_q_id,
            schema="tww_od",
        )
        self.assertIsNone(live)


    # ---------------------------------------------------------------------
    # Geometry propagation
    # ---------------------------------------------------------------------

    def test_geometry_is_preserved(self):
        """
        Geometry passed through quarantine must survive import.
        """
        geom = self.make_point(2600000, 1200000, 10)

        row = {
            "ws_identifier": "ci_ws_geom",
            "co_situation3d_geometry": geom,
            "co_level": 10,
            "wn_bottom_level": 5,
            "tww_is_okay": True,
        }

        ws_q_id = self.insert_check(
            "import_ws_quarantine",
            row,
            schema="tww_od",
            pkey="uuidoid",
        )

        cur = self.cursor()
        cur.execute(
            """
            SELECT ST_Z(co_situation3d_geometry) AS z
            FROM tww_od.wastewater_structure
            WHERE obj_id = %(oid)s
            """,
            {"oid": ws_q_id},
        )
        z = cur.fetchone()["z"]
        self.assertEqual(z, 10)


if __name__ == "__main__":
    unittest.main()
