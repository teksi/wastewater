import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestViews(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def insert_manholes(self, manholes):
        for manhole in manholes:
            coords = manholes[manhole]["coords"]
            row = {
                "identifier": manhole,
                "ws_type": "manhole",
                "situation3d_geometry": self.execute(
                    "ST_SetSRID(ST_GeomFromText('POINT({x} {y})'), 2056)".format(
                        x=coords[0], y=coords[1]
                    )
                ),
            }
            manholes[manhole]["obj_id"] = self.insert("vw_tww_wastewater_structure", row)
            manholes[manhole]["wn_obj_id"] = self.select(
                "vw_tww_wastewater_structure", manholes[manhole]["obj_id"]
            )["wn_obj_id"]

    def insert_reaches(self, reaches, manholes):
        for way, reaches in reaches.items():
            for reach in reaches:
                if way == "input":
                    start_point = manholes[reach["mh_id"]]
                    end_point = manholes["main"]
                else:
                    start_point = manholes["main"]
                    end_point = manholes[reach["mh_id"]]

                points = [start_point["coords"]]
                if "mid_point" in reach:
                    points.append(reach["mid_point"])
                points.append(end_point["coords"])

                geom = self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ARRAY[{points}]), 2056))".format(
                        points=", ".join(
                            [f"ST_MakePoint({pt[0]}, {pt[1]}, 'NaN')" for pt in points]
                        )
                    )
                )

                row = {
                    "clear_height": 100,
                    "coefficient_of_friction": 10,
                    "ws_identifier": reach["mh_id"],
                    "ch_function_hierarchic": 5062,
                    "rp_from_level": reach.get("rp_from_level", 1020.0),
                    "rp_to_level": reach.get("rp_to_level", 1000.0),
                    "ch_usage_current": 4514,
                    "progression3d_geometry": geom,
                }
                obj_id = self.insert("vw_tww_reach", row)
                self.connect_reach(
                    obj_id, from_id=start_point["wn_obj_id"], to_id=end_point["wn_obj_id"]
                )

    def connect_reach(self, reach_id, from_id=None, to_id=None):
        """
        Helper function to connect reach from/to wastewater network elements
        """
        data = {}
        if from_id is not None:
            data["rp_from_fk_wastewater_networkelement"] = from_id
        if to_id is not None:
            data["rp_to_fk_wastewater_networkelement"] = to_id
        self.update("vw_tww_reach", data, reach_id)

    def test_simpe_labels(self):
        manholes = {
            "main": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1200000]},
            "N": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1200001]},
            "NE": {"obj_id": None, "wn_obj_id": None, "coords": [2600001, 1200001]},
            "E": {"obj_id": None, "wn_obj_id": None, "coords": [2600001, 1200000]},
            "SE": {"obj_id": None, "wn_obj_id": None, "coords": [2600001, 1199999]},
            "S": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1199999]},
            "SW": {"obj_id": None, "wn_obj_id": None, "coords": [2599999, 1199999]},
            "W": {"obj_id": None, "wn_obj_id": None, "coords": [2599999, 1200000]},
            "NW": {"obj_id": None, "wn_obj_id": None, "coords": [2599999, 1200001]},
        }
        self.insert_manholes(manholes)
        reaches = {
            "input": [
                {"mh_id": "NE", "rp_to_level": 1011},
                {"mh_id": "SE", "rp_to_level": 1012},
                {"mh_id": "SW", "rp_to_level": 1013},
                {"mh_id": "NW", "rp_to_level": 1014},
            ],
            "output": [
                {"mh_id": "N", "rp_from_level": 1001},
                {"mh_id": "E", "rp_from_level": 1002},
                {"mh_id": "S", "rp_from_level": 1003},
                {"mh_id": "W", "rp_from_level": 1004},
            ],
        }
        self.insert_reaches(reaches, manholes)
        self.assertEqual(
            self.select("vw_tww_wastewater_structure", manholes["main"]["obj_id"])["_input_label"],
            "\nI1=1011.00\nI2=1012.00\nI3=1013.00\nI4=1014.00",
        )
        self.assertEqual(
            self.select("vw_tww_wastewater_structure", manholes["main"]["obj_id"])[
                "_output_label"
            ],
            "\nO1=1001.00\nO2=1002.00\nO3=1003.00\nO4=1004.00",
        )

    def test_crossing_circular_reaches(self):
        manholes = {
            "main": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1200000]},
            "N": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1200001]},
            "S": {"obj_id": None, "wn_obj_id": None, "coords": [2600000, 1199999]},
        }
        self.insert_manholes(manholes)
        reaches = {
            "input": [
                {"mh_id": "N", "rp_to_level": 1011, "mid_point": [2600000.5, 1199999.5]},
                {"mh_id": "S", "rp_to_level": 1012, "mid_point": [2600000.5, 1200000.5]},
            ]
        }
        self.insert_reaches(reaches, manholes)
        self.assertEqual(
            self.select("vw_tww_wastewater_structure", manholes["main"]["obj_id"])["_input_label"],
            "\nI1=1012.00\nI2=1011.00",
        )


if __name__ == "__main__":
    unittest.main()
