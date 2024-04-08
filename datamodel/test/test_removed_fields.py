import os
import unittest

import psycopg
import psycopg.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestRemovedFields(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_dataowner(self):
        cur = self.conn.cursor(cursor_factory=psycopg.extras.DictCursor)

        cur.execute("SELECT * FROM tww_od.wastewater_structure LIMIT 1")
        colnames = [desc[0] for desc in cur.description]

        self.assertNotIn("provider", colnames)
        self.assertNotIn("dataowner", colnames)


if __name__ == "__main__":
    unittest.main()
