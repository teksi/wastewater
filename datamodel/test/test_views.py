import copy
import decimal
import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
    import psycopg2.extras as psycopg_extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestViews(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_vw_reach(self):
        row = {
            "clear_height": 100,
            "coefficient_of_friction": 10,
            "identifier": "20",
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 100), ST_MakePoint(3000001, 1500001, 100)), 2056))"
            ),
        }

        obj_id = self.insert_check("vw_reach", row)

        row = {"clear_height": 200, "coefficient_of_friction": 20, "identifier": "10"}

        self.update_check("vw_reach", row, obj_id)

    def test_vw_prank_weir(self):
        row = {"identifier": "STAR20", "level_max": decimal.Decimal("300.123")}

        obj_id = self.insert_check("vw_prank_weir", row)

        row = {"identifier": "30", "level_max": decimal.Decimal("400.321")}

        self.update_check("vw_prank_weir", row, obj_id)

    def test_vw_tww_reach(self):
        row = {
            "clear_height": 100,
            "coefficient_of_friction": 10,
            "ws_identifier": "pra",
            "ch_usage_current": 4514,
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 'NaN'), ST_MakePoint(3000001, 1500001, 'NaN')), 2056))"
            ),
        }

        obj_id = self.insert_check("vw_tww_reach", row)

        row = {
            "clear_height": 200,
            "coefficient_of_friction": 20,
            "ws_identifier": "10",
            "ch_usage_current": 4516,
        }

        self.update_check("vw_tww_reach", row, obj_id)

    def test_vw_tww_wastewater_structure(self):
        row = {
            "identifier": "20",
            "ws_type": "manhole",
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600000 1200000)'), 2056)"
            ),
            #    'co_material': 5355,
            "wn_backflow_level_current": decimal.Decimal("100.000"),
        }

        expected_row = copy.deepcopy(row)
        expected_row["situation3d_geometry"] = self.execute(
            "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
        )

        obj_id = self.insert_check("vw_tww_wastewater_structure", row, expected_row)

        row = {
            "identifier": "10",
            "ws_type": "special_structure",
            "co_material": 233,
            "ss_upper_elevation": decimal.Decimal("405.000"),
        }

        self.update_check("vw_tww_wastewater_structure", row, obj_id)

        try:
            cur = self.cursor(row_factory=psycopg.rows.dict_row)
        except AttributeError:
            # remove when dropping psycopg2 support
            cur = self.cursor(cursor_factory=psycopg_extras.DictCursor)

        cur.execute(
            "SELECT * FROM tww_od.wastewater_networkelement NE LEFT JOIN tww_od.wastewater_node NO ON NO.obj_id = NE.obj_id WHERE fk_wastewater_structure='{obj_id}' ".format(
                obj_id=obj_id
            )
        )
        row = cur.fetchone()

        assert row["backflow_level_current"] == decimal.Decimal("100.000")

    def test_vw_tww_additional_ws(self):
        row = {
            "identifier": "201_created",
            "ws_type": "drainless_toilet",
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600000 1200000)'), 2056)"
            ),
            #    'co_material': 5355,
            "wn_backflow_level_current": decimal.Decimal("100.000"),
        }

        expected_row = copy.deepcopy(row)
        expected_row["situation3d_geometry"] = self.execute(
            "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
        )

        obj_id = self.insert_check("vw_tww_additional_ws", row, expected_row)

        row = {
            "identifier": "202_accepted",
            "ws_type": "wwtp_structure",
            "co_material": 233,
            "wt_kind": 331,
        }

        self.update_check("vw_tww_additional_ws", row, obj_id)

        try:
            cur = self.cursor(row_factory=psycopg.rows.dict_row)
        except AttributeError:
            # remove when dropping psycopg2 support
            cur = self.cursor(cursor_factory=psycopg_extras.DictCursor)

        cur.execute(
            "SELECT * FROM tww_od.wastewater_networkelement NE LEFT JOIN tww_od.wastewater_node NO ON NO.obj_id = NE.obj_id WHERE fk_wastewater_structure='{obj_id}' ".format(
                obj_id=obj_id
            )
        )
        row = cur.fetchone()

        assert row["backflow_level_current"] == decimal.Decimal("100.000")


if __name__ == "__main__":
    unittest.main()
