import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestSys(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_sys_table(self):
        list_tables = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'tww_od' AND table_type != 'VIEW'"
        cur = self.cursor()
        cur.execute(list_tables)
        list_tables = []
        for record in cur.fetchall():
            list_tables.append(record[0])

        sys_tables = "SELECT tablename FROM tww_sys.dictionary_od_table"
        cur = self.cursor()
        cur.execute(sys_tables)
        sys_tables = []
        for record in cur.fetchall():
            sys_tables.append(record[0])

        missing_sys_tables = []
        for lt in list_tables:
            if lt not in sys_tables:
                missing_sys_tables.append(lt)

        extra_sys_tables = []
        for st in sys_tables:
            if st not in list_tables:
                extra_sys_tables.append(st)

        self.assertEqual(missing_sys_tables, [])
        self.assertEqual(extra_sys_tables, [])


if __name__ == "__main__":
    unittest.main()
