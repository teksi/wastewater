import decimal
import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestTriggers(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg2.connect(f"service={pgservice}")

    def test_last_modified(self):
        row = {
            "identifier": "CO123",
            "level": decimal.Decimal("100.000"),
            "situation3d_geometry": self.execute(
                "ST_SetSrid(ST_MakePoint(3000000, 1500000, 100), 2056)"
            ),
        }

        obj_id = self.insert_check("vw_cover", row)

        row = self.select("structure_part", obj_id, schema="tww_od")

        last_mod = row["last_modification"]
        assert last_mod is not None, "Last modification not set on insert"

        row = {
            "identifier": "CO1234",
        }

        self.update_check("structure_part", row, obj_id, schema="tww_od")

        row = self.select("structure_part", obj_id, schema="tww_od")
        assert (
            last_mod != row["last_modification"]
        ), "Last modification not set on update (still {})".format(row["last_modification"])

        last_mod = row["last_modification"]

        row = {"level": decimal.Decimal("300.000")}

        self.update_check("cover", row, obj_id, schema="tww_od")

        row = self.select("structure_part", obj_id, schema="tww_od")
        assert (
            last_mod != row["last_modification"]
        ), "Last modification not set on update of child table (still {})".format(
            row["last_modification"]
        )

    def test_identifier(self):
        row = {
            "co_level": decimal.Decimal("100.000"),
            "ws_type": "manhole",
            "situation3d_geometry": self.execute(
                "ST_SetSrid(ST_MakePoint(3000000, 1500000), 2056)"
            ),
        }

        obj_id = self.insert_check("vw_tww_wastewater_structure", row)

        row = self.select("vw_tww_wastewater_structure", obj_id)

        for r in row:
            print(r)

        row = self.select("structure_part", row["co_obj_id"], schema="tww_od")

        for r in row:
            print(r)

        identifier = row["identifier"]
        assert identifier, f"Identifier not set on insert: {repr(identifier)}"

    def test_labels(self):
        strct_id = None

        def check_values(expected_values_for_field):
            row = self.select("vw_tww_wastewater_structure", strct_id)
            for field, expected_value in expected_values_for_field.items():
                assert (
                    row[field] == expected_value
                ), "Field {} is incorrect: {} instead of {}".format(
                    field, repr(row[field]), repr(expected_value)
                )

        # Test label generation on insert

        row_strct = {
            "identifier": "A",
            "situation3d_geometry": self.execute(
                "ST_SetSrid(ST_MakePoint(3000000, 1500000), 2056)"
            ),
            "ws_type": "manhole",
            "co_level": decimal.Decimal("100.000"),
        }
        strct_id = self.insert("vw_tww_wastewater_structure", row_strct)
        strct_row = self.select("vw_tww_wastewater_structure", strct_id)

        expected = {
            "_label": "A",
            "_cover_label": "\nC=100.00",
            "_bottom_label": "",
            "_input_label": "",
            "_output_label": "",
        }

        check_values(expected)

        # Test label generation on update

        row_strct = {
            "identifier": "B",
            "co_level": decimal.Decimal("98.000"),
            "wn_bottom_level": decimal.Decimal("90.1234567"),
        }
        self.update("vw_tww_wastewater_structure", row_strct, strct_id)

        expected.update(
            {
                "_label": "B",
                "_cover_label": "\nC=98.00",
                "_bottom_label": "\nB=90.12",
            }
        )
        check_values(expected)

        # Test label generation on reach insert

        row_reach_a = {
            "identifier": "R1",
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000001, 1500001, 100), ST_MakePoint(3000000, 1500000, 100)), 2056))"
            ),
            "ch_function_hierarchic": 5062,
            "rp_to_fk_wastewater_networkelement": strct_row["wn_obj_id"],
            "rp_to_level": 95,
        }
        reach_a_id = self.insert("vw_tww_reach", row_reach_a)

        expected.update(
            {
                "_input_label": "\nI=95.00",
            }
        )
        check_values(expected)

        row_reach_b = {
            "identifier": "R2",
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 92), ST_MakePoint(3000000, 1500001, 90)), 2056))"
            ),
            "ch_function_hierarchic": 5062,
            "rp_from_fk_wastewater_networkelement": strct_row["wn_obj_id"],
            "rp_from_level": 92,
        }
        reach_b_id = self.insert("vw_tww_reach", row_reach_b)

        expected.update(
            {
                "_output_label": "\nO=92.00",
            }
        )
        check_values(expected)

        row_reach_c = {
            "identifier": "R3",
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 93), ST_MakePoint(3000001, 1500000, 90)), 2056))"
            ),
            "ch_function_hierarchic": 5062,
            "rp_from_fk_wastewater_networkelement": strct_row["wn_obj_id"],
            "rp_from_level": 93,
        }
        reach_c_id = self.insert("vw_tww_reach", row_reach_c)

        expected.update(
            {
                "_output_label": "\nO1=92.00\nO2=93.00",
            }
        )
        check_values(expected)

        # Test label generation on reach update (change level)

        row_reach_a = {"rp_to_level": 94}
        self.update("vw_tww_reach", row_reach_a, reach_a_id)

        expected.update(
            {
                "_input_label": "\nI=94.00",
            }
        )
        check_values(expected)

        # Test label generation on reach update (change azimuth)

        row_reach_b = {
            "progression3d_geometry": self.execute(
                "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000000, 1500000, 92), ST_MakePoint(3000000, 1499999, 90)), 2056))"
            ),
        }
        self.update("vw_tww_reach", row_reach_b, reach_b_id)

        expected.update(
            {
                "_output_label": "\nO1=93.00\nO2=92.00",
            }
        )
        check_values(expected)

        # Test label generation on reach update (level to null)

        row_reach_c = {"rp_from_level": None}
        self.update("vw_tww_reach", row_reach_c, reach_c_id)

        expected.update(
            {
                "_output_label": "\nO1=?\nO2=92.00",
            }
        )
        check_values(expected)

        # TODO : reenable this (currently, deleting reaches doesn't trigger update on labels)
        # Test label generation on reach delete
        #
        # self.delete('vw_tww_reach', reach_a_id)
        # self.delete('vw_tww_reach', reach_c_id)
        #
        # expected.update({
        #     '_input_label': '',
        #     '_output_label': '\nO1=92.00',
        # })
        # check_values(expected)

    def test_symbology(self):
        """tests updating of _function_hierarchic and _usage_current on wastewater_node and wastewater_structure"""

        def check_values(table, obj_id, expected_values_for_field):
            row = self.select(table, obj_id)
            for field, expected_value in expected_values_for_field.items():
                assert (
                    field in row
                ), "Field {} not present in results ! Available fields are {}".format(
                    field, ", ".join(row.keys())
                )
                assert (
                    row[field] == expected_value
                ), "Field {} is incorrect: {} instead of {}".format(
                    field, repr(row[field]), repr(expected_value)
                )

        strct_from_id = self.insert(
            "vw_tww_wastewater_structure",
            {
                "identifier": "A",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000000, 1500000), 2056)"
                ),
                "ws_type": "manhole",
                "co_level": decimal.Decimal("100.000"),
            },
        )
        strct_from_row = self.select("vw_tww_wastewater_structure", strct_from_id)

        strct_to_id = self.insert(
            "vw_tww_wastewater_structure",
            {
                "identifier": "B",
                "situation3d_geometry": self.execute(
                    "ST_SetSrid(ST_MakePoint(3000001, 1500001), 2056)"
                ),
                "ws_type": "manhole",
                "co_level": decimal.Decimal("100.000"),
            },
        )
        strct_to_row = self.select("vw_tww_wastewater_structure", strct_to_id)

        reach_id = self.insert(
            "vw_tww_reach",
            {
                "identifier": "R1",
                "progression3d_geometry": self.execute(
                    "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(3000001, 1500001, 100), ST_MakePoint(3000000, 1500000, 100)), 2056))"
                ),
                "ch_function_hierarchic": 5062,
                "rp_from_fk_wastewater_networkelement": strct_from_row["wn_obj_id"],
                "rp_to_fk_wastewater_networkelement": strct_to_row["wn_obj_id"],
            },
        )

        check_values(
            "vw_tww_wastewater_structure",
            strct_from_id,
            {
                "_channel_function_hierarchic": 5062,
            },
        )
        check_values(
            "vw_tww_wastewater_structure",
            strct_to_id,
            {
                "_channel_function_hierarchic": 5062,
            },
        )

        check_values(
            "vw_wastewater_node",
            strct_from_row["wn_obj_id"],
            {
                "_function_hierarchic": 5062,
            },
        )
        check_values(
            "vw_wastewater_node",
            strct_to_row["wn_obj_id"],
            {
                "_function_hierarchic": 5062,
            },
        )

        # We change _function hierarchic on the reach
        self.update("vw_tww_reach", {"ch_function_hierarchic": 5063}, reach_id)

        check_values(
            "vw_tww_wastewater_structure",
            strct_from_id,
            {
                "_channel_function_hierarchic": 5063,
            },
        )
        check_values(
            "vw_tww_wastewater_structure",
            strct_to_id,
            {
                "_channel_function_hierarchic": 5063,
            },
        )

        check_values(
            "vw_wastewater_node",
            strct_from_row["wn_obj_id"],
            {
                "_function_hierarchic": 5063,
            },
        )
        check_values(
            "vw_wastewater_node",
            strct_to_row["wn_obj_id"],
            {
                "_function_hierarchic": 5063,
            },
        )


if __name__ == "__main__":
    unittest.main()
