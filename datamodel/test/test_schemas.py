import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase

TWW_SCHEMAS = ("tww_sys", "tww_vl", "tww_od", "tww_cfg", "tww_app")
PG_SCHEMAS = ("pg_toast", "information_schema", "pg_catalog", "public")


class TestSchemas(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg2.connect(f"service={pgservice}")

    def test_list_schemas(self):
        schemas = ", ".join([f"'{schema}'" for schema in TWW_SCHEMAS + PG_SCHEMAS])
        list_schemas = f"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ({schemas});"
        self.check_empty(list_schemas)

    def test_app_schema(self):
        list_tables = "SELECT * FROM information_schema.tables WHERE table_schema = 'tww_app' AND table_type != 'VIEW'"
        self.check_empty(list_tables)

    def test_data_schemas(self):
        pg_schemas = ", ".join([f"'{schema}'" for schema in TWW_SCHEMAS + PG_SCHEMAS])
        list_views = (
            "SELECT * FROM information_schema.tables WHERE table_type = 'VIEW' "
            f"AND table_schema NOT IN ('tww_app', {pg_schemas})"
        )
        self.check_empty(list_views)

        list_functions = (
            "SELECT routine_name, routine_schema FROM information_schema.routines "
            "WHERE routine_type = 'FUNCTION' "
            "AND routine_name NOT IN ('update_last_modified', 'update_last_modified_parent', 'generate_oid') "
            f"AND routine_schema NOT IN ('tww_app', {pg_schemas})"
        )
        self.check_empty(list_functions)


if __name__ == "__main__":
    unittest.main()
