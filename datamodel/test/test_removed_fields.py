import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
    import psycopg2.extras as psycopg_extras

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
        try:
            cur = self.conn.cursor(row_factory=psycopg.rows.dict_row)
        except AttributeError:
            # remove when dropping psycopg2 support
            cur = self.conn.cursor(cursor_factory=psycopg_extras.DictCursor)

        cur.execute("SELECT * FROM tww_od.wastewater_structure LIMIT 1")
        colnames = [desc[0] for desc in cur.description]

        self.assertNotIn("provider", colnames)
        self.assertNotIn("dataowner", colnames)


if __name__ == "__main__":
    unittest.main()
