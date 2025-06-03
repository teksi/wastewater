try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

import unittest

from .utils import DEFAULT_PG_SERVICE


class TestExtensions(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    def test_views_in_tww_od(self):
        with self.conn.cursor() as cursor:
            cursor.execute(
                "SELECT table_name FROM information_schema.views WHERE table_schema = 'tww_od';"
            )
            views = cursor.fetchall()
            self.assertGreater(len(views), 0, "No views found in tww_od schema")


if __name__ == "__main__":
    unittest.main()
