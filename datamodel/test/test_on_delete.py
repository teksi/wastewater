import decimal
import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestOnDelete(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.commit()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_delete_wastewater_structure(self):
        # Create a new cover(structure part) with manhole(wastewater structure)
        row = {
            "identifier": "CO698",
            "co_level": decimal.Decimal("100.000"),
            "ws_type": "manhole",
            "situation3d_geometry": "0101000020080800000000000060E346410000000060E33641",  # ST_SetSRID(ST_MakePoint(3000000, 1500000), 2056)
        }

        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        # Get the new cover
        row = self.select("vw_tww_wastewater_structure", obj_id)
        row = self.select("vw_cover", row["co_obj_id"])

        self.delete("wastewater_structure", row["fk_wastewater_structure"], schema="tww_od")

        # Just to be sure the structure really was deleted
        self.assertIsNone(self.select("manhole", row["fk_wastewater_structure"], schema="tww_od"))
        self.assertIsNone(
            self.select("wastewater_structure", row["fk_wastewater_structure"], schema="tww_od")
        )
        # The cover should be delted as well. If not, the foreign key constraint action does not work properly
        self.assertIsNone(self.select("vw_cover", obj_id))

    def test_delete_reach(self):
        # Create a new reach and reachpoints
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation3d_geometry": "01010000A0080800000000000060E346410000000060E336410000000000005940",
            },
            schema="tww_od",
        )  # ST_MakePoint(3000000, 1500000, 100)
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                "situation3d_geometry": "01010000A0080800000000008060E346410000000061E336410000000000005940",
            },
            schema="tww_od",
        )  # ST_MakePoint(3000001, 1500001, 100)
        wn001_obj_id = self.insert_check(
            "wastewater_networkelement", {"identifier": "WN001"}, schema="tww_od"
        )

        row = {
            "obj_id": wn001_obj_id,
            "fk_reach_point_from": rp001_obj_id,
            "fk_reach_point_to": rp002_obj_id,
            "progression3d_geometry": "01090000A008080000010000000102000080020000000000000060E346410000000060E3364100000000000059400000008060E346410000000061E336410000000000005940",  # SELECT ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056));
        }
        re001_obj_id = self.insert_check("reach", row, schema="tww_od")

        self.assertIsNotNone(self.select("reach", re001_obj_id, schema="tww_od"))
        self.assertIsNotNone(self.select("reach_point", rp001_obj_id, schema="tww_od"))
        self.assertIsNotNone(self.select("reach_point", rp002_obj_id, schema="tww_od"))
        self.assertIsNotNone(
            self.select("wastewater_networkelement", wn001_obj_id, schema="tww_od")
        )

        self.delete("reach", re001_obj_id, schema="tww_od")

        self.assertIsNone(self.select("reach", re001_obj_id, schema="tww_od"))
        self.assertIsNone(self.select("reach_point", rp001_obj_id, schema="tww_od"))
        self.assertIsNone(self.select("reach_point", rp002_obj_id, schema="tww_od"))
        self.assertIsNone(self.select("wastewater_networkelement", wn001_obj_id, schema="tww_od"))

        # The same but over the view vw_tww_reach
        # Create a new reach and reach points
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000000, 1500000, 100), 2056)"
                ),
            },
            schema="tww_od",
        )
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000001, 1500001, 100), 2056)"
                ),
            },
            schema="tww_od",
        )
        wn001_obj_id = self.insert_check(
            "wastewater_networkelement", {"identifier": "WN001"}, schema="tww_od"
        )

        row = {
            "obj_id": wn001_obj_id,
            "fk_reach_point_from": rp001_obj_id,
            "fk_reach_point_to": rp002_obj_id,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056))"
            ),
        }
        re001_obj_id = self.insert_check("reach", row, schema="tww_od")

        self.assertIsNotNone(self.select("vw_tww_reach", re001_obj_id))
        self.assertIsNotNone(self.select("reach_point", rp001_obj_id, schema="tww_od"))
        self.assertIsNotNone(self.select("reach_point", rp002_obj_id, schema="tww_od"))
        self.assertIsNotNone(
            self.select("wastewater_networkelement", wn001_obj_id, schema="tww_od")
        )

        self.delete("vw_tww_reach", re001_obj_id)

        self.assertIsNone(self.select("vw_tww_reach", re001_obj_id))
        self.assertIsNone(self.select("reach_point", rp001_obj_id, schema="tww_od"))
        self.assertIsNone(self.select("reach_point", rp002_obj_id, schema="tww_od"))
        self.assertIsNone(self.select("wastewater_networkelement", wn001_obj_id, schema="tww_od"))

        # control that channel is delete if no reach left
        ws001_obj_id = self.insert_check(
            "wastewater_structure", {"obj_id": "CH001"}, schema="tww_od"
        )
        ch001_obj_id = self.insert_check("channel", {"obj_id": "CH001"}, schema="tww_od")
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000000, 1500000, 100), 2056)"
                ),
            },
            schema="tww_od",
        )
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                # ST_SetSrid(ST_MakePoint(3000001, 1500001, 100), 2056)
                "situation3d_geometry": "01010000A0080800000000008060E346410000000061E336410000000000005940",
            },
            schema="tww_od",
        )
        wn001_obj_id = self.insert_check(
            "wastewater_networkelement",
            {"identifier": "WN001", "fk_wastewater_structure": ch001_obj_id},
            schema="tww_od",
        )
        re001_obj_id = self.insert_check(
            "reach",
            {
                "obj_id": wn001_obj_id,
                "fk_reach_point_from": rp001_obj_id,
                "fk_reach_point_to": rp002_obj_id,
                "progression3d_geometry": self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056))"
                ),
            },
            schema="tww_od",
        )
        rp011_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP011",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000002, 1500002, 100), 2056)"
                ),
            },
            schema="tww_od",
        )
        rp012_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP012",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000003, 1500003, 100), 2056)"
                ),
            },
            schema="tww_od",
        )
        wn011_obj_id = self.insert_check(
            "wastewater_networkelement",
            {"identifier": "WN011", "fk_wastewater_structure": ch001_obj_id},
            schema="tww_od",
        )
        re011_obj_id = self.insert_check(
            "reach",
            {
                "obj_id": wn011_obj_id,
                "fk_reach_point_from": rp011_obj_id,
                "fk_reach_point_to": rp012_obj_id,
                "progression3d_geometry": self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000002, 1500002, 100), ST_MakePoint(3000003, 1500003, 100)), 2056))"
                ),
            },
            schema="tww_od",
        )

        self.assertEqual(ch001_obj_id, ws001_obj_id)
        self.delete("reach", re001_obj_id, schema="tww_od")
        self.assertIsNotNone(self.select("channel", ch001_obj_id, schema="tww_od"))
        self.delete("reach", re011_obj_id, schema="tww_od")
        self.assertIsNone(self.select("channel", ch001_obj_id, schema="tww_od"))


if __name__ == "__main__":
    unittest.main()
