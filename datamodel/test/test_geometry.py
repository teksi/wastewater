import copy
import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase

X = 2556050.0
Y = 1114225.0


class TestGeometry(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_vw_tww_reach_geometry_insert(self):
        # 1. insert geometry with Z and no rp_from_level and no rp_to_level
        geom = f"COMPOUNDCURVEZ(({X + 1} {Y + 1} 1001,{X + 2} {Y + 2} 1002, {X + 3} {Y + 3} 1003))"
        row = {
            "progression3d_geometry": self.geom_from_text(geom),
            "rp_from_obj_id": "BBB 1337_0001",
            "rp_to_obj_id": "CCC 1337_0001",
        }
        geom = f"COMPOUNDCURVEZ(({X + 1} {Y + 1} NaN,{X + 2} {Y + 2} 1002, {X + 3} {Y + 3} NaN))"
        expected_row = {
            "progression3d_geometry": self.geom_from_text(geom),
            "rp_from_level": None,
            "rp_to_level": None,
        }
        self.insert_check("vw_tww_reach", row, expected_row)
        # reach_point has on rp_to as Z NaN: SELECT ST_SetSRID( ST_MakePoint(1,2,'NaN'), 2056)
        row = self.select("reach_point", "BBB 1337_0001", schema="tww_od")
        assert row["situation3d_geometry"] == self.execute(
            f"ST_SetSRID( ST_MakePoint({X + 1}, {Y + 1},'NaN'), 2056)"
        )
        # reach_point has on rp_from as Z NaN: SELECT ST_SetSRID( ST_MakePoint(7,8,'NaN'), 2056)
        row = self.select("reach_point", "CCC 1337_0001", schema="tww_od")
        assert row["situation3d_geometry"] == self.execute(
            f"ST_SetSRID( ST_MakePoint({X + 3}, {Y + 3},'NaN'), 2056)"
        )

        # 2. insert geometry with Z and no rp_from_level and 66 as rp_to_level
        # INSERT INTO tww_app.vw_tww_reach (obj_id, progression3d_geometry, rp_to_level, rp_from_obj_id, rp_to_obj_id) VALUES ('AAA 1337_0002', ST_SetSRID(ST_GeomFromText('COMPOUNDCURVE Z ((1 2 3,4 5 6,7 8 9))'), 2056), 66, 'BBB 1337_0002', 'CCC 1337_0002' );
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000000008400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000002240",
            "rp_to_level": "66",
            "rp_from_obj_id": "BBB 1337_0002",
            "rp_to_obj_id": "CCC 1337_0002",
        }
        expected_row = copy.deepcopy(row)
        # vw_tww_reach has the geometry but NaN as Z on start_point and 66 (rp_to_level) as Z on end_point: SELECT ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,'NaN'), ST_MakePoint(4,5,6), ST_MakePoint(7,8,66)])), 2056)
        expected_row["progression3d_geometry"] = (
            "01090000A00808000001000000010200008003000000000000000000F03F0000000000000040000000000000F87F0000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000805040"
        )
        # rp_from_level is NULL
        expected_row["rp_from_level"] = None
        # rp_to_level is 66.000
        expected_row["rp_to_level"] = "66.000"
        self.insert_check("vw_tww_reach", row, expected_row)
        # reach_point has on rp_from as Z NaN: SELECT ST_SetSRID( ST_MakePoint(1,2,'NaN'), 2056)
        row = self.select("reach_point", "BBB 1337_0002", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A008080000000000000000F03F0000000000000040000000000000F87F"
        )
        # reach_point has on rp_to as Z 66.000: SELECT ST_SetSRID( ST_MakePoint(7,8,66.000), 2056)
        row = self.select("reach_point", "CCC 1337_0002", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000000001C4000000000000020400000000000805040"
        )

        # 3. insert geometry with Z and 77 as rp_from_level and NULL as rp_to_level
        # INSERT INTO tww_app.vw_tww_reach (obj_id, progression3d_geometry, rp_from_level, rp_to_level, rp_from_obj_id, rp_to_obj_id) VALUES ('AAA 1337_0003', ST_SetSRID(ST_GeomFromText('COMPOUNDCURVE Z ((1 2 3,4 5 6,7 8 9))'), 2056), NULL, 77, 'BBB 1337_0003', 'CCC 1337_0003' );
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000000008400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000002240",
            "rp_from_level": "77.000",
            "rp_to_level": None,
            "rp_from_obj_id": "BBB 1337_0003",
            "rp_to_obj_id": "CCC 1337_0003",
        }
        expected_row = copy.deepcopy(row)
        # vw_tww_reach has the geometry but 77 (rp_from_level) as Z on start_point and NaN as Z on end_point: SELECT ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,77), ST_MakePoint(4,5,6), ST_MakePoint(7,8,'NaN')])), 2056)
        expected_row["progression3d_geometry"] = (
            "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000004053400000000000001040000000000000144000000000000018400000000000001C400000000000002040000000000000F87F"
        )
        # rp_from_level is 77.000
        expected_row["rp_from_level"] = "77.000"
        # rp_to_level is NULL
        expected_row["rp_to_level"] = None
        self.insert_check("vw_tww_reach", row, expected_row)
        # reach_point has on rp_from as Z 77.000: SELECT ST_SetSRID( ST_MakePoint(1,2,77.000), 2056)
        row = self.select("reach_point", "BBB 1337_0003", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A008080000000000000000F03F00000000000000400000000000405340"
        )
        # reach_point has on rp_to as Z 66.000: SELECT ST_SetSRID( ST_MakePoint(7,8,'NaN'), 2056)
        row = self.select("reach_point", "CCC 1337_0003", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000000001C400000000000002040000000000000F87F"
        )

    def test_vw_tww_reach_geometry_update(self):
        # first insert
        # no Z and no rp_from_level and no rp_to_level
        # INSERT INTO tww_app.vw_tww_reach (progression3d_geometry, rp_from_obj_id, rp_to_obj_id) VALUES (ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,'NaN'), ST_MakePoint(4,5,'NaN'), ST_MakePoint(7,8,'NaN')])), 2056), 'BBB 1337_1010', 'CCC 1337_1010' );
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F0000000000000040000000000000F87F00000000000010400000000000001440000000000000F87F0000000000001C400000000000002040000000000000F87F",
            "rp_from_obj_id": "BBB 1337_1010",
            "rp_to_obj_id": "CCC 1337_1010",
        }
        obj_id = self.insert("vw_tww_reach", row)

        # 1. change geometry including Z with startpoint Z 3 and endpoint Z 9, no change on rp_from_level, no change on rp_to_level
        # UPDATE INTO tww_app.vw_tww_reach SET progression3d_geometry=ST_SetSRID(ST_GeomFromText('COMPOUNDCURVE Z ((1 2 3,4 5 6,7 8 9))'), 2056) WHERE obj_id=obj_id'
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000000008400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000002240"
        }
        self.update("vw_tww_reach", row, obj_id)
        new_row = self.select("vw_tww_reach", obj_id)
        # vw_tww_reach has the geometry
        assert (
            new_row["progression3d_geometry"]
            == "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000000008400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000002240"
        )
        # rp_from_level is 3 (startpoint of geometry)
        assert new_row["rp_from_level"] == 3
        # rp_to_level is 9 (endpoint of geometry)
        assert new_row["rp_to_level"] == 9
        # reach_point has on rp_from as Z 3
        new_row = self.select("reach_point", "BBB 1337_1010", schema="tww_od")
        assert new_row["level"] == 3
        # reach_point has on rp_to as Z 9
        new_row = self.select("reach_point", "CCC 1337_1010", schema="tww_od")
        assert new_row["level"] == 9

        # 2. change geometry including Z with startpoint Z 33 and endpoint Z 99, no change on rp_from_level, but change on rp_to_level to NULL
        # UPDATE INTO tww_app.vw_tww_reach SET progression3d_geometry=ST_SetSRID(ST_GeomFromText('COMPOUNDCURVE Z ((1 2 33,4 5 6,7 8 99))'), 2056), rp_to_level=NULL WHERE obj_id=obj_id'
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000008040400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000C05840",
            "rp_to_level": None,
        }
        self.update("vw_tww_reach", row, obj_id)
        new_row = self.select("vw_tww_reach", obj_id)
        # vw_tww_reach has the geometry but as endpoint Z there is NaN: SELECT ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,33), ST_MakePoint(4,5,6), ST_MakePoint(7,8,'NaN')])), 2056)
        assert (
            new_row["progression3d_geometry"]
            == "01090000A00808000001000000010200008003000000000000000000F03F000000000000004000000000008040400000000000001040000000000000144000000000000018400000000000001C400000000000002040000000000000F87F"
        )
        # rp_from_level is 33 (startpoint of geometry)
        assert new_row["rp_from_level"] == 33
        # rp_to_level is None (endpoint of geometry) and rp_to_level
        assert new_row["rp_to_level"] is None
        # reach_point has on rp_from as Z 3
        new_row = self.select("reach_point", "BBB 1337_1010", schema="tww_od")
        assert new_row["level"] == 33
        # reach_point has on rp_to as Z None
        new_row = self.select("reach_point", "CCC 1337_1010", schema="tww_od")
        assert new_row["level"] is None

        # 3. change geometry including Z with startpoint Z 300 and endpoint Z 900, but change on rp_from_level to 333, and change on rp_to_level to 999
        # UPDATE INTO tww_app.vw_tww_reach SET progression3d_geometry=ST_SetSRID(ST_GeomFromText('COMPOUNDCURVE Z ((1 2 300,4 5 6,7 8 900))'), 2056), rp_to_level=NULL WHERE obj_id=obj_id'
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F00000000000000400000000000C072400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000208C40",
            "rp_from_level": "333.000",
            "rp_to_level": "999.000",
        }
        self.update("vw_tww_reach", row, obj_id)
        new_row = self.select("vw_tww_reach", obj_id)
        # vw_tww_reach has the geometry but as startpoint Z is 333 and on endpoint Z is 999: SELECT ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,333), ST_MakePoint(4,5,6), ST_MakePoint(7,8,'999)])), 2056)
        assert (
            new_row["progression3d_geometry"]
            == "01090000A00808000001000000010200008003000000000000000000F03F00000000000000400000000000D074400000000000001040000000000000144000000000000018400000000000001C4000000000000020400000000000388F40"
        )
        # rp_from_level is 333 (startpoint of geometry) and rp_from_level
        assert new_row["rp_from_level"] == 333
        # rp_to_level is 999 (endpoint of geometry) and rp_to_level
        assert new_row["rp_to_level"] == 999
        # reach_point has on rp_from as Z 333
        new_row = self.select("reach_point", "BBB 1337_1010", schema="tww_od")
        assert new_row["level"] == 333
        # reach_point has on rp_to as Z 999
        new_row = self.select("reach_point", "CCC 1337_1010", schema="tww_od")
        assert new_row["level"] == 999

        # 4. change geometry including Z with startpoint Z NaN and endpoint Z NaN, no change on rp_from_level, no change on rp_to_level
        # UPDATE INTO tww_app.vw_tww_reach SET progression3d_geometry=ST_SetSRID( ST_ForceCurve(ST_MakeLine(ARRAY[ST_MakePoint(1,2,'NaN'), ST_MakePoint(4,5,6), ST_MakePoint(7,8,'NaN')])), 2056) WHERE obj_id=obj_id'
        row = {
            "progression3d_geometry": "01090000A00808000001000000010200008003000000000000000000F03F0000000000000040000000000000F87F0000000000001040000000000000144000000000000018400000000000001C400000000000002040000000000000F87F"
        }
        self.update("vw_tww_reach", row, obj_id)
        new_row = self.select("vw_tww_reach", obj_id)
        # vw_tww_reach has the geometry
        assert (
            new_row["progression3d_geometry"]
            == "01090000A00808000001000000010200008003000000000000000000F03F0000000000000040000000000000F87F0000000000001040000000000000144000000000000018400000000000001C400000000000002040000000000000F87F"
        )
        # rp_from_level is NULL (startpoint of geometry)
        assert new_row["rp_from_level"] is None
        # rp_to_level is NULL (endpoint of geometry)
        assert new_row["rp_to_level"] is None
        # reach_point has on rp_from as Z NULL
        new_row = self.select("reach_point", "BBB 1337_1010", schema="tww_od")
        assert new_row["level"] is None
        # reach_point has on rp_to as Z NULL
        new_row = self.select("reach_point", "CCC 1337_1010", schema="tww_od")
        assert new_row["level"] is None

    def test_vw_tww_wastewater_structure_geometry_insert(self):
        # 1. insert geometry and no co_level and no wn_bottom_level
        # INSERT INTO tww_app.vw_tww_wastewater_structure (situation3d_geometry, wn_obj_id, co_obj_id) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056), '1337_1001', '1337_1001');
        row = {
            "situation3d_geometry": "0101000020080800000000000020D6434100000000804F3241",
            "wn_obj_id": "1337_1001",
            "co_obj_id": "1337_1001",
        }
        expected_row = copy.deepcopy(row)
        # wastewaterstructure has the geometry but NaN as Z because of no co_level (geometry of cover): ST_SetSRID(ST_Collect(ST_MakePoint(2600000, 1200000, 'NaN')), 2056)
        expected_row["situation3d_geometry"] = "0101000020080800000000000020D6434100000000804F3241"
        # co_level is NULL
        expected_row["co_level"] = None
        # wn_bottom_level NULL
        expected_row["wn_bottom_level"] = None
        self.insert_check("vw_tww_wastewater_structure", row, expected_row)
        # cover geometry has the geometry but NaN as Z: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        row = self.select("cover", "1337_1001", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        # wastewater_node has the geometry but not 3d: ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)
        row = self.select("wastewater_node", "1337_1001", schema="tww_od")
        assert row["situation3d_geometry"] == self.execute(
            "ST_SetSRID( ST_MakePoint(2600000, 1200000, 'NaN'), 2056)"
        )

        # 2. insert geometry with no co_level and WITH wn_bottom_level
        # INSERT INTO tww_app.vw_tww_wastewater_structure (situation3d_geometry, wn_obj_id, co_obj_id, wn_bottom_level) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056), '1337_1002', '1337_1002', 200.000);
        row = {
            "situation3d_geometry": "0101000020080800000000000020D6434100000000804F3241",
            "wn_obj_id": "1337_1002",
            "co_obj_id": "1337_1002",
            "wn_bottom_level": "200.000",
        }
        expected_row = copy.deepcopy(row)
        # wastewaterstructure has the 2D geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)
        expected_row["situation3d_geometry"] = "0101000020080800000000000020D6434100000000804F3241"
        # co_level is NULL
        expected_row["co_level"] = None
        # wn_bottom_level is new wn_bottom_level
        expected_row["wn_bottom_level"] = "200.000"
        self.insert_check("vw_tww_wastewater_structure", row, expected_row)
        # cover geometry has the geometry but NaN as Z: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        row = self.select("cover", "1337_1002", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        # wastewater_node has the geometry and  wn_buttom_level as Z: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        row = self.select("wastewater_node", "1337_1002", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )

        # 3. insert geometry with Z and WITH co_level and WITH wn_bottom_level
        # INSERT INTO tww_app.vw_tww_wastewater_structure (situation3d_geometry, wn_obj_id, co_obj_id, wn_bottom_level, co_level) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056), '1337_1003', '1337_1003', 200.000, 500.000);
        row = {
            "situation3d_geometry": "0101000020080800000000000020D6434100000000804F3241",
            "wn_obj_id": "1337_1003",
            "co_obj_id": "1337_1003",
            "wn_bottom_level": "200.000",
            "co_level": "500.000",
        }
        expected_row = copy.deepcopy(row)
        # wastewaterstructure has 2D geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)
        expected_row["situation3d_geometry"] = "0101000020080800000000000020D6434100000000804F3241"
        # co_level is new co_level
        expected_row["co_level"] = "500.000"
        # wn_bottom_level is new wn_bottom_level
        expected_row["wn_bottom_level"] = "200.000"
        self.insert_check("vw_tww_wastewater_structure", row, expected_row)
        # cover geometry has the geometry and co_level as Z: ST_SetSRID(ST_MakePoint(2600000, 1200000, 500), 2056)
        row = self.select("cover", "1337_1003", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000407F40"
        )
        # wastewater_node has the geometry and wn_buttom_level as Z: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        row = self.select("wastewater_node", "1337_1003", schema="tww_od")
        assert (
            row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )

    def test_vw_tww_wastewater_structure_geometry_update(self):
        # first insert
        # insert geometry with no co_level and no wn_bottom_level
        # INSERT INTO tww_app.vw_tww_wastewater_structure (situation3d_geometry, wn_obj_id, co_obj_id) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056), '1337_1010', '1337_1010');
        row = {
            "situation3d_geometry": "0101000020080800000000000020D6434100000000804F3241",
            "ws_type": "manhole",
            "wn_obj_id": "1337_1010",
            "co_obj_id": "1337_1010",
        }
        obj_id = self.insert("vw_tww_wastewater_structure", row)

        # 1. update no change on geometry with Z but WITH wn_bottom_level
        # UPDATE INTO tww_app.vw_wastewater_node SET wn_bottom_level=200.000 WHERE obj_id = obj_id
        row = {"wn_bottom_level": "200.000"}
        self.update("vw_tww_wastewater_structure", row, obj_id)
        new_row = self.select("vw_tww_wastewater_structure", obj_id)
        # no change on geometry of wastewaterstructure (because it's geometry of cover that does not change)
        self.assertEqual(
            new_row["situation3d_geometry"], "0101000020080800000000000020D6434100000000804F3241"
        )
        # no change on co_level
        self.assertIsNone(new_row["co_level"])
        # wn_bottom_level is new wn_bottom_level
        self.assertEqual(new_row["wn_bottom_level"], 200.000)
        # no change on cover geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        new_row = self.select("cover", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        # wastewater_node geometry has Z from new wn_bottom_level: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        new_row = self.select("wastewater_node", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )

        # 2. update change co_level
        # UPDATE INTO tww_app.vw_wastewater_node SET level=500.000 WHERE obj_id = obj_id
        row = {"co_level": "500.000"}
        self.update("vw_tww_wastewater_structure", row, obj_id)
        new_row = self.select("vw_tww_wastewater_structure", obj_id)
        # geometry of wastewaterstructure has 2D geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000, 500), 2056)
        assert (
            new_row["situation3d_geometry"] == "0101000020080800000000000020D6434100000000804F3241"
        )
        # co_level is new co_level
        assert new_row["co_level"] == 500.000
        # no change on wn_bottom_level
        assert new_row["wn_bottom_level"] == 200.000
        # cover geometry has Z from new co_level: ST_SetSRID(ST_MakePoint(2600000, 1200000, 500), 2056)
        new_row = self.select("cover", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000407F40"
        )
        # no change on wastewater_node geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        new_row = self.select("wastewater_node", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )

        # 3. update change WITH co_level and WITH wn_bottom_level
        # UPDATE INTO tww_app.vw_wastewater_node SET co_level=600.000, wn_bottom_level=300.000 WHERE obj_id = obj_id
        row = {"co_level": "600.000", "wn_bottom_level": "300.000"}
        self.update("vw_tww_wastewater_structure", row, obj_id)
        new_row = self.select("vw_tww_wastewater_structure", obj_id)
        # geometry of wastewaterstructure unchanged: ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)
        assert (
            new_row["situation3d_geometry"] == "0101000020080800000000000020D6434100000000804F3241"
        )
        # co_level is new co_level
        assert new_row["co_level"] == 600.000
        # wn_bottom_level is new wn_bottom_level
        assert new_row["wn_bottom_level"] == 300.000
        # cover geometry has Z from new co_level: ST_SetSRID(ST_MakePoint(2600000, 1200000, 600), 2056)
        new_row = self.select("cover", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000C08240"
        )
        # no change on wastewater_node geometry: ST_SetSRID(ST_MakePoint(2600000, 1200000, 300), 2056)
        new_row = self.select("wastewater_node", "1337_1010", schema="tww_od")
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000C07240"
        )

    def test_wastewater_node_geometry_sync_on_insert(self):
        # 1. bottom level 200 and no Z
        # INSERT INTO tww_app.vw_wastewater_node (bottom_level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) );
        row = {
            "bottom_level": "200.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        expected_row = copy.deepcopy(row)
        # bottom_level 200 overwrites Z (NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        expected_row["bottom_level"] = "200.000"
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        self.insert_check("vw_wastewater_node", row, expected_row)

        # 2. bottom level 200 and 555 Z
        # INSERT INTO tww_app.vw_wastewater_node (bottom_level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "bottom_level": "200.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # bottom_level 200 overwrites Z (555) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        expected_row["bottom_level"] = "200.000"
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        self.insert_check("vw_wastewater_node", row, expected_row)

        # 3. bottom level NULL and 555 Z
        # INSERT INTO tww_app.vw_wastewater_node (bottom_level, situation3d_geometry) VALUES (NULL, ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "bottom_level": None,
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # bottom_level NULL overwrites Z (555) (to NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        expected_row["bottom_level"] = None
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        self.insert_check("vw_wastewater_node", row, expected_row)

        # 4. no bottom level and 555 Z
        # INSERT INTO tww_app.vw_wastewater_node (situation3d_geometry) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # no bottom_level overwrites Z (555) (to NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        expected_row["bottom_level"] = None
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        self.insert_check("vw_wastewater_node", row, expected_row)

    def test_wastewater_node_geometry_sync_on_update(self):
        # first insert
        # no bottom level and no Z
        # INSERT INTO tww_app.vw_wastewater_node (bottom_level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) );
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        obj_id = self.insert("vw_wastewater_node", row)

        # 1. change Z to 555 (don't change bottom_level)
        # UPDATE INTO tww_app.vw_wastewater_node SET situation3d_geometry=ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) WHERE obj_id = obj_id;
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        self.update("vw_wastewater_node", row, obj_id)
        # Z (555) overwrites bottom_level results in: 555.000
        new_row = self.select("vw_wastewater_node", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000588140"
        )
        assert new_row["bottom_level"] == 555.000

        # 2. change bottom_level to 200 (don't change Z)
        # UPDATE INTO tww_app.vw_wastewater_node SET bottom_level=200 WHERE obj_id = obj_id;
        row = {"bottom_level": "200.000"}
        self.update("vw_wastewater_node", row, obj_id)
        # bottom_level 200 overwrites Z results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        new_row = self.select("vw_wastewater_node", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        assert new_row["bottom_level"] == 200.000

        # 3. change bottom_level to 555 and Z to 666
        # UPDATE INTO tww_app.vw_wastewater_node SET bottom_level=200 WHERE obj_id = obj_id;
        row = {
            "bottom_level": "555.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000D08440",
        }
        self.update("vw_wastewater_node", row, obj_id)
        # bottom_level 555 overwrites Z (666) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056)
        new_row = self.select("vw_wastewater_node", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000588140"
        )
        assert new_row["bottom_level"] == 555.000

        # 4. change Z to NaN (don't change bottom_level)
        # UPDATE INTO tww_app.vw_wastewater_node SET situation3d_geometry=ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) WHERE obj_id = obj_id;
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        self.update("vw_wastewater_node", row, obj_id)
        # Z (NaN) overwrites bottom_level results in: NULL
        new_row = self.select("vw_wastewater_node", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        assert new_row["bottom_level"] is None

    def test_cover_geometry_sync_on_insert(self):
        # 1. level 200 and no Z
        # INSERT INTO tww_app.vw_cover (level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) );
        row = {
            "level": "200.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        expected_row = copy.deepcopy(row)
        # level 200 overwrites Z (NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        expected_row["level"] = "200.000"
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        self.insert_check("vw_cover", row, expected_row)

        # 2. level 200 and 555 Z
        # INSERT INTO tww_app.vw_cover (level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "level": "200.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # level 200 overwrites Z (555) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        expected_row["level"] = "200.000"
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        self.insert_check("vw_cover", row, expected_row)

        # 3. level NULL and 555 Z
        # INSERT INTO tww_app.vw_cover (level, situation3d_geometry) VALUES (NULL, ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "level": None,
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # level NULL overwrites Z (555) (to NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        expected_row["level"] = None
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        self.insert_check("vw_cover", row, expected_row)

        # 4. no level and 555 Z
        # INSERT INTO tww_app.vw_cover (situation3d_geometry) VALUES (ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) );
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        expected_row = copy.deepcopy(row)
        # no level overwrites Z (555) (to NaN) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056)
        expected_row["level"] = None
        expected_row["situation3d_geometry"] = (
            "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        self.insert_check("vw_cover", row, expected_row)

    def test_cover_geometry_sync_on_update(self):
        # first insert
        # no level and no Z
        # INSERT INTO tww_app.vw_cover (level, situation3d_geometry) VALUES (200, ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) );
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        obj_id = self.insert("vw_cover", row)

        # 1. change Z to 555 (don't change level)
        # UPDATE INTO tww_app.vw_cover SET situation3d_geometry=ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056) WHERE obj_id = obj_id;
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000588140",
        }
        self.update("vw_cover", row, obj_id)
        # Z (555) overwrites level results in: 555.000
        new_row = self.select("vw_cover", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000588140"
        )
        assert new_row["level"] == 555.000

        # 2. change level to 200 (don't change Z)
        # UPDATE INTO tww_app.vw_cover SET level=200 WHERE obj_id = obj_id;
        row = {"level": "200.000"}
        self.update("vw_cover", row, obj_id)
        # level 200 overwrites Z results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 200), 2056)
        new_row = self.select("vw_cover", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000006940"
        )
        assert new_row["level"] == 200.000

        # 3. change level to 555 and Z to 666
        # UPDATE tww_od.cover_node SET level=200 WHERE obj_id = obj_id;
        row = {
            "level": "555.000",
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F32410000000000D08440",
        }
        self.update("vw_cover", row, obj_id)
        # level 555 overwrites Z (666) results in: ST_SetSRID(ST_MakePoint(2600000, 1200000, 555), 2056)
        new_row = self.select("vw_cover", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F32410000000000588140"
        )
        assert new_row["level"] == 555.000

        # 4. change Z to NaN (don't change level)
        # UPDATE INTO tww_app.vw_cover SET situation3d_geometry=ST_SetSRID(ST_MakePoint(2600000, 1200000, 'NaN'), 2056) WHERE obj_id = obj_id;
        row = {
            "situation3d_geometry": "01010000A0080800000000000020D6434100000000804F3241000000000000F87F",
        }
        self.update("vw_cover", row, obj_id)
        # Z (555) overwrites level results in: 555.000
        new_row = self.select("vw_cover", obj_id)
        assert (
            new_row["situation3d_geometry"]
            == "01010000A0080800000000000020D6434100000000804F3241000000000000F87F"
        )
        assert new_row["level"] is None


if __name__ == "__main__":
    unittest.main()
