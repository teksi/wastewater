import os
import unittest

import psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestAppComplete(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_views_exist(self):
        cur = self.cursor()
        for view in [
            "vw_network_node",
            "vw_file",
        ]:
            cur.execute(
                "SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace "
                "WHERE n.nspname = 'tww_app' AND c.relname = %s AND c.relkind IN ('v','m')",
                (view,),
            )
            assert cur.fetchone() is not None, f"View tww_app.{view} does not exist"


if __name__ == "__main__":
    unittest.main()
