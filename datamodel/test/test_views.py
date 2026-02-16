import copy
import decimal
import os
import unittest

import psycopg

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

        cur = self.cursor(row_factory=psycopg.rows.dict_row)
        cur.execute(
            "SELECT * FROM tww_od.wastewater_networkelement NE LEFT JOIN tww_od.wastewater_node NO ON NO.obj_id = NE.obj_id WHERE fk_wastewater_structure='{obj_id}' ".format(
                obj_id=obj_id
            )
        )
        row = cur.fetchone()

        assert row["backflow_level_current"] == decimal.Decimal("100.000")

    def test_vw_tww_wastewater_structure_identifier_synchronization(self):
        base_row = {
            "ws_type": "manhole",
            "situation3d_geometry": self.execute(
                "ST_SetSRID(ST_GeomFromText('POINT(2600000 1200000)'), 2056)"
            ),
            "co_material": 233,
        }

        # -------
        # test that wn_identifier is correctly on insert and no cover is created (if no cover fields are set)
        row = copy.deepcopy(base_row)
        row["identifier"] = "ws_000"
        row["co_material"] = None

        expected_row = copy.deepcopy(row)
        expected_row["wn_identifier"] = "ws_000"
        expected_row["co_identifier"] = None

        obj_id = self.insert_check(
            "vw_tww_wastewater_structure", row=row, expected_row=expected_row
        )

        # -------
        # test that wn_identifier and co_identifier are set correctly on insert when cover fields are set
        row = copy.deepcopy(base_row)
        row["identifier"] = "ws_001"

        expected_row = copy.deepcopy(row)
        expected_row["wn_identifier"] = "ws_001"
        expected_row["co_identifier"] = "ws_001"

        obj_id = self.insert_check(
            "vw_tww_wastewater_structure", row=row, expected_row=expected_row
        )

        # -------
        # test that wn_identifier and co_identifier are synchronized correctly on update
        row = copy.deepcopy(expected_row)
        row["identifier"] = "ws_002"

        expected_row = copy.deepcopy(row)
        expected_row["wn_identifier"] = "ws_002"
        expected_row["co_identifier"] = "ws_002"

        self.update_check(
            "vw_tww_wastewater_structure",
            row={"identifier": "ws_002"},
            obj_id=obj_id,
            expected_row=expected_row,
        )

        # -------
        # test that differentiating identifiers on update works
        row = copy.deepcopy(expected_row)
        row["identifier"] = "ws_003"
        row["co_identifier"] = "cover_003"
        row["wn_identifier"] = "wn_003"
        expected_row = copy.deepcopy(row)
        expected_row["wn_identifier"] = "ws_003"
        expected_row["co_identifier"] = "cover_003"
        expected_row["wn_identifier"] = "wn_003"
        self.update_check(
            "vw_tww_wastewater_structure",
            row=row,
            obj_id=obj_id,
            expected_row=expected_row,
        )

        # -------
        # test former existing cover prevents new cover creation on insert
        row = copy.deepcopy(base_row)
        row["identifier"] = "ws_004"
        row["co_identifier"] = "cover_003"  # cover_003 already exists
        expected_row = copy.deepcopy(row)
        expected_row["co_identifier"] = (
            None  # co_identifier is set to null because cover creation is prevented
        )
        expected_row["co_material"] = None
        obj_id = self.insert_check(
            "vw_tww_wastewater_structure",
            row=row,
            expected_row=expected_row,
        )

        # -------
        # test former existing cover prevents new cover creation on update
        row = copy.deepcopy(base_row)
        row["identifier"] = "ws_005"
        row["co_material"] = None
        expected_row = copy.deepcopy(row)
        expected_row["co_identifier"] = None
        obj_id = self.insert_check(
            "vw_tww_wastewater_structure",
            row=row,
            expected_row=expected_row,
        )
        row = copy.deepcopy(base_row)
        row["identifier"] = "ws_005_updated"
        row["co_identifier"] = "cover_003"  # cover_003 already exists
        expected_row = copy.deepcopy(row)
        expected_row["co_identifier"] = (
            None  # co_identifier is null because cover creation is prevented
        )
        expected_row["co_material"] = None
        self.update_check(
            "vw_tww_wastewater_structure",
            row=row,
            obj_id=obj_id,
            expected_row=expected_row,
        )

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

        cur = self.cursor(row_factory=psycopg.rows.dict_row)

        cur.execute(
            "SELECT * FROM tww_od.wastewater_networkelement NE LEFT JOIN tww_od.wastewater_node NO ON NO.obj_id = NE.obj_id WHERE fk_wastewater_structure='{obj_id}' ".format(
                obj_id=obj_id
            )
        )
        row = cur.fetchone()

        assert row["backflow_level_current"] == decimal.Decimal("100.000")


if __name__ == "__main__":
    unittest.main()
