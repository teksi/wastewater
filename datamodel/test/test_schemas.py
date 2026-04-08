import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase

TWW_SCHEMAS = ("tww_sys", "tww_vl", "tww_od")
APP_SCHEMAS = ("tww_app", "tww_app_pg2ili")
PG_SCHEMAS = ("pg_toast", "information_schema", "pg_catalog", "public")

ALL_SCHEMAS = TWW_SCHEMAS + PG_SCHEMAS + APP_SCHEMAS


def schemas_as_str(schemas):
    return ", ".join([f"'{schema}'" for schema in schemas])


class TestSchemas(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_list_schemas(self):
        list_schemas = f"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ({schemas_as_str(ALL_SCHEMAS)});"
        self.check_empty(list_schemas)

    def test_app_schema(self):
        list_tables = f"SELECT * FROM information_schema.tables WHERE table_schema IN ({schemas_as_str(APP_SCHEMAS)}) AND table_type != 'VIEW'"
        self.check_empty(list_tables)

    def test_data_schemas(self):
        list_views = (
            "SELECT * FROM information_schema.tables WHERE table_type = 'VIEW' "
            f"AND table_schema IN ({schemas_as_str(TWW_SCHEMAS)})"
        )
        self.check_empty(list_views)

        list_functions = (
            "SELECT routine_name, routine_schema FROM information_schema.routines "
            "WHERE routine_type = 'FUNCTION' "
            "AND routine_name NOT IN ('update_last_modified', 'update_last_modified_parent', 'generate_oid') "
            f"AND routine_schema NOT IN ({schemas_as_str(PG_SCHEMAS + APP_SCHEMAS)})"
        )
        self.check_empty(list_functions)


if __name__ == "__main__":
    unittest.main()
