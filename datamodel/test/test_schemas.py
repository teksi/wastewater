import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestGeometry(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg2.connect(f"service={pgservice}")

    def test_app_schema(self):
        list_tables = "SELECT * FROM information_schema.tables WHERE table_schema = 'tww_app' AND table_type != 'VIEW'"
        self.check_empty(list_tables)

    def test_data_schemas(self):
        list_views = (
            "SELECT * FROM information_schema.tables WHERE table_type = 'VIEW' "
            "AND table_schema NOT IN ('public', 'pg_catalog', 'information_schema', 'tww_app')"
        )
        self.check_empty(list_views)

        list_functions = (
            "SELECT routine_name, routine_schema FROM information_schema.routines "
            "WHERE routine_type = 'FUNCTION' "
            "AND routine_schema NOT IN ('public', 'information_schema', 'pg_catalog', 'tww_app');"
        )
        self.check_empty(list_functions)


if __name__ == "__main__":
    unittest.main()
