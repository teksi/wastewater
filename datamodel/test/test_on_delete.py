import decimal
import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestTriggers(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.commit()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg2.connect(f"service={pgservice}")

    def test_delete_wastewater_structure(self):
        # Create a new cover(structure part) with manhole(wastewater structure)
        row = {
            "identifier": "CO698",
            "co_level": decimal.Decimal("100.000"),
            "ws_type": "manhole",
            "situation_geometry": "0101000020080800000000000060E346410000000060E33641",  # ST_SetSRID(ST_MakePoint(3000000, 1500000), 2056)
        }

        obj_id = self.insert_check("vw_qgep_wastewater_structure", row)

        # Get the new cover
        row = self.select("vw_qgep_wastewater_structure", obj_id)
        row = self.select("vw_cover", row["co_obj_id"])

        self.delete("wastewater_structure", row["fk_wastewater_structure"])

        # Just to be sure the structure really was deleted
        self.assertIsNone(self.select("manhole", row["fk_wastewater_structure"]))
        self.assertIsNone(self.select("wastewater_structure", row["fk_wastewater_structure"]))
        # The cover should be delted as well. If not, the foreign key constraint action does not work properly
        self.assertIsNone(self.select("vw_cover", obj_id))

    def test_delete_reach(self):
        # Create a new reach and reachpoints
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation_geometry": "01010000A0080800000000000060E346410000000060E336410000000000005940",
            },
        )  # ST_MakePoint(3000000, 1500000, 100)
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                "situation_geometry": "01010000A0080800000000008060E346410000000061E336410000000000005940",
            },
        )  # ST_MakePoint(3000001, 1500001, 100)
        wn001_obj_id = self.insert_check("wastewater_networkelement", {"identifier": "WN001"})

        row = {
            "obj_id": wn001_obj_id,
            "fk_reach_point_from": rp001_obj_id,
            "fk_reach_point_to": rp002_obj_id,
            "progression_geometry": "01090000A008080000010000000102000080020000000000000060E346410000000060E3364100000000000059400000008060E346410000000061E336410000000000005940",  # SELECT ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056));
        }
        re001_obj_id = self.insert_check("reach", row)

        self.assertIsNotNone(self.select("reach", re001_obj_id))
        self.assertIsNotNone(self.select("reach_point", rp001_obj_id))
        self.assertIsNotNone(self.select("reach_point", rp002_obj_id))
        self.assertIsNotNone(self.select("wastewater_networkelement", wn001_obj_id))

        self.delete("reach", re001_obj_id)

        self.assertIsNone(self.select("reach", re001_obj_id))
        self.assertIsNone(self.select("reach_point", rp001_obj_id))
        self.assertIsNone(self.select("reach_point", rp002_obj_id))
        self.assertIsNone(self.select("wastewater_networkelement", wn001_obj_id))

        # The same but over the view vw_qgep_reach
        # Create a new reach and reach points
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000000, 1500000, 100), 2056)"
                ),
            },
        )
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                "situation_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000001, 1500001, 100), 2056)"
                ),
            },
        )
        wn001_obj_id = self.insert_check("wastewater_networkelement", {"identifier": "WN001"})

        row = {
            "obj_id": wn001_obj_id,
            "fk_reach_point_from": rp001_obj_id,
            "fk_reach_point_to": rp002_obj_id,
            "progression_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056))"
            ),
        }
        re001_obj_id = self.insert_check("reach", row)

        self.assertIsNotNone(self.select("vw_qgep_reach", re001_obj_id))
        self.assertIsNotNone(self.select("reach_point", rp001_obj_id))
        self.assertIsNotNone(self.select("reach_point", rp002_obj_id))
        self.assertIsNotNone(self.select("wastewater_networkelement", wn001_obj_id))

        self.delete("vw_qgep_reach", re001_obj_id)

        self.assertIsNone(self.select("vw_qgep_reach", re001_obj_id))
        self.assertIsNone(self.select("reach_point", rp001_obj_id))
        self.assertIsNone(self.select("reach_point", rp002_obj_id))
        self.assertIsNone(self.select("wastewater_networkelement", wn001_obj_id))

        # control that channel is delete if no reach left
        ws001_obj_id = self.insert_check("wastewater_structure", {"obj_id": "CH001"})
        ch001_obj_id = self.insert_check("channel", {"obj_id": "CH001"})
        rp001_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP001",
                "situation_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000000, 1500000, 100), 2056)"
                ),
            },
        )
        rp002_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP002",
                # ST_SetSrid(ST_MakePoint(3000001, 1500001, 100), 2056)
                "situation_geometry": "01010000A0080800000000008060E346410000000061E336410000000000005940",
            },
        )
        wn001_obj_id = self.insert_check(
            "wastewater_networkelement",
            {"identifier": "WN001", "fk_wastewater_structure": ch001_obj_id},
        )
        re001_obj_id = self.insert_check(
            "reach",
            {
                "obj_id": wn001_obj_id,
                "fk_reach_point_from": rp001_obj_id,
                "fk_reach_point_to": rp002_obj_id,
                "progression_geometry": self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056))"
                ),
            },
        )
        rp011_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP011",
                "situation_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000002, 1500002, 100), 2056)"
                ),
            },
        )
        rp012_obj_id = self.insert_check(
            "reach_point",
            {
                "identifier": "RP012",
                "situation_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000003, 1500003, 100), 2056)"
                ),
            },
        )
        wn011_obj_id = self.insert_check(
            "wastewater_networkelement",
            {"identifier": "WN011", "fk_wastewater_structure": ch001_obj_id},
        )
        re011_obj_id = self.insert_check(
            "reach",
            {
                "obj_id": wn011_obj_id,
                "fk_reach_point_from": rp011_obj_id,
                "fk_reach_point_to": rp012_obj_id,
                "progression_geometry": self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000002, 1500002, 100), ST_MakePoint(3000003, 1500003, 100)), 2056))"
                ),
            },
        )

        self.assertEqual(ch001_obj_id, ws001_obj_id)
        self.delete("reach", re001_obj_id)
        self.assertIsNotNone(self.select("channel", ch001_obj_id))
        self.delete("reach", re011_obj_id)
        self.assertIsNone(self.select("channel", ch001_obj_id))


if __name__ == "__main__":
    unittest.main()
