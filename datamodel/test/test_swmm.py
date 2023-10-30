import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestSwmm(unittest.TestCase, DbTestBase):
    """Test cases to test the SWMM view

    This is supposed to run against the demo data."""

    @classmethod
    def tearDown(cls):
        cls.conn.rollback()

    @classmethod
    def setUp(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg2.connect(f"service={pgservice}")

    def test_count_vw_aquifers(self):
        self.assert_count("vw_swmm_aquifers", "tww_app", 0)

    def test_count_vw_conduits(self):
        self.assert_count("vw_swmm_conduits", "tww_app", 5095)

    def test_count_vw_coordinates(self):
        self.assert_count("vw_swmm_coordinates", "tww_app", 8044)

    def test_count_vw_coverages(self):
        self.assert_count("vw_swmm_coverages", "tww_app", 0)

    def test_count_vw_dividers(self):
        self.assert_count("vw_swmm_dividers", "tww_app", 45)

    def test_count_vw_dwf(self):
        self.assert_count("vw_swmm_dwf", "tww_app", 2035)

    def test_count_vw_infiltration(self):
        self.assert_count("vw_swmm_infiltration", "tww_app", 1352)

    def test_count_vw_junctions(self):
        self.assert_count("vw_swmm_junctions", "tww_app", 5864)

    def test_count_vw_landuses(self):
        self.assert_count("vw_swmm_landuses", "tww_app", 6)

    def test_count_vw_losses(self):
        self.assert_count("vw_swmm_losses", "tww_app", 5095)

    def test_count_vw_outfalls(self):
        self.assert_count("vw_swmm_outfalls", "tww_app", 54)

    def test_count_vw_polygons(self):
        self.assert_count("vw_swmm_polygons", "tww_app", 27405)

    def test_count_vw_pumps(self):
        self.assert_count("vw_swmm_pumps", "tww_app", 0)

    def test_count_vw_raingages(self):
        self.assert_count("vw_swmm_raingages", "tww_app", 2035)

    def test_count_vw_storages(self):
        self.assert_count("vw_swmm_storages", "tww_app", 46)

    def test_count_vw_subareas(self):
        self.assert_count("vw_swmm_subareas", "tww_app", 2035)

    def test_count_vw_subcatchments(self):
        self.assert_count("vw_swmm_subcatchments", "tww_app", 2035)

    def test_count_vw_tags(self):
        self.assert_count("vw_swmm_tags", "tww_app", 13094)

    def test_count_vw_vertices(self):
        self.assert_count("vw_swmm_vertices", "tww_app", 2854)

    def test_count_vw_xsections(self):
        self.assert_count("vw_swmm_xsections", "tww_app", 5095)


if __name__ == "__main__":
    unittest.main()
