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
        self.assert_count("swmm_vw_aquifers", "tww_app", 0)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_conduits(self):
        self.assert_count("swmm_vw_conduits", "tww_app", 5095)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_coordinates(self):
        self.assert_count("swmm_vw_coordinates", "tww_app", 8044)

    def test_count_vw_coverages(self):
        self.assert_count("swmm_vw_coverages", "tww_app", 0)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_dividers(self):
        self.assert_count("swmm_vw_dividers", "tww_app", 45)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_dwf(self):
        self.assert_count("swmm_vw_dwf", "tww_app", 2035)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_infiltration(self):
        self.assert_count("swmm_vw_infiltration", "tww_app", 1352)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_junctions(self):
        self.assert_count("swmm_vw_junctions", "tww_app", 5864)

    def test_count_vw_landuses(self):
        self.assert_count("swmm_vw_landuses", "tww_app", 6)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_losses(self):
        self.assert_count("swmm_vw_losses", "tww_app", 5095)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_outfalls(self):
        self.assert_count("swmm_vw_outfalls", "tww_app", 54)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_polygons(self):
        self.assert_count("swmm_vw_polygons", "tww_app", 27405)

    def test_count_vw_pumps(self):
        self.assert_count("swmm_vw_pumps", "tww_app", 0)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_raingages(self):
        self.assert_count("swmm_vw_raingages", "tww_app", 2035)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_storages(self):
        self.assert_count("swmm_vw_storages", "tww_app", 46)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_subareas(self):
        self.assert_count("swmm_vw_subareas", "tww_app", 2035)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_subcatchments(self):
        self.assert_count("swmm_vw_subcatchments", "tww_app", 2035)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_tags(self):
        self.assert_count("swmm_vw_tags", "tww_app", 13094)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_vertices(self):
        self.assert_count("swmm_vw_vertices", "tww_app", 2854)

    @unittest.skip("This test needs the demo data to work")
    def test_count_vw_xsections(self):
        self.assert_count("swmm_vw_xsections", "tww_app", 5095)


if __name__ == "__main__":
    unittest.main()
