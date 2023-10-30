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
        self.assert_count("vw_aquifers", "qgep_swmm", 0)

    def test_count_vw_conduits(self):
        self.assert_count("vw_conduits", "qgep_swmm", 5095)

    def test_count_vw_coordinates(self):
        self.assert_count("vw_coordinates", "qgep_swmm", 8044)

    def test_count_vw_coverages(self):
        self.assert_count("vw_coverages", "qgep_swmm", 0)

    def test_count_vw_dividers(self):
        self.assert_count("vw_dividers", "qgep_swmm", 45)

    def test_count_vw_dwf(self):
        self.assert_count("vw_dwf", "qgep_swmm", 2035)

    def test_count_vw_infiltration(self):
        self.assert_count("vw_infiltration", "qgep_swmm", 1352)

    def test_count_vw_junctions(self):
        self.assert_count("vw_junctions", "qgep_swmm", 5864)

    def test_count_vw_landuses(self):
        self.assert_count("vw_landuses", "qgep_swmm", 6)

    def test_count_vw_losses(self):
        self.assert_count("vw_losses", "qgep_swmm", 5095)

    def test_count_vw_outfalls(self):
        self.assert_count("vw_outfalls", "qgep_swmm", 54)

    def test_count_vw_polygons(self):
        self.assert_count("vw_polygons", "qgep_swmm", 27405)

    def test_count_vw_pumps(self):
        self.assert_count("vw_pumps", "qgep_swmm", 0)

    def test_count_vw_raingages(self):
        self.assert_count("vw_raingages", "qgep_swmm", 2035)

    def test_count_vw_storages(self):
        self.assert_count("vw_storages", "qgep_swmm", 46)

    def test_count_vw_subareas(self):
        self.assert_count("vw_subareas", "qgep_swmm", 2035)

    def test_count_vw_subcatchments(self):
        self.assert_count("vw_subcatchments", "qgep_swmm", 2035)

    def test_count_vw_tags(self):
        self.assert_count("vw_tags", "qgep_swmm", 13094)

    def test_count_vw_vertices(self):
        self.assert_count("vw_vertices", "qgep_swmm", 2854)

    def test_count_vw_xsections(self):
        self.assert_count("vw_xsections", "qgep_swmm", 5095)


if __name__ == "__main__":
    unittest.main()
