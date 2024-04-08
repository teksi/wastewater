import os
import unittest

import psycopg3
import psycopg3.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestViews(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg3.connect(f"service={pgservice}")

    def test_create_drop_triggers(self):
        self.execute("tww_sys.disable_symbology_triggers()")
        self.execute("tww_sys.enable_symbology_triggers()")


if __name__ == "__main__":
    unittest.main()
