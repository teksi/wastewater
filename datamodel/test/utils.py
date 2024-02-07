import psycopg2
import psycopg2.extras

DEFAULT_PG_SERVICE = "pg_tww"


class DbTestBase:
    @classmethod
    def assert_count(cls, table, schema, expected):
        cur = cls.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(f"SELECT COUNT(*) FROM {schema}.{table}")
        count = cur.fetchone()[0]
        assert (
            count == expected
        ), f"Relation {schema}.{table} : expected {expected} rows, got {count} rows"

    @classmethod
    def geom_from_text(cls, wkt: str) -> str:
        return cls.execute(f"ST_SetSRID(ST_GeomFromText('{wkt}'), 2056)")

    @classmethod
    def geom_as_text(cls, wkb: str) -> str:
        return cls.execute(f"ST_GeomAsText('{wkb}')")

    @classmethod
    def select(cls, table, obj_id, schema="tww_app"):
        cur = cls.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(f"SELECT * FROM {schema}.{table} WHERE obj_id=%(obj_id)s", {"obj_id": obj_id})
        return cur.fetchone()

    @classmethod
    def execute(cls, sql: str, params=[]):
        cur = cls.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if not sql.startswith("SELECT"):
            sql = f"SELECT {sql}"
        cur.execute(sql, params)
        return cur.fetchone()[0]

    def check_empty(self, sql: str):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(sql)
        self.assertIsNone(cur.fetchone())

    @classmethod
    def cursor(cls):
        return cls.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    @classmethod
    def insert(cls, table, row, schema="tww_app"):
        cur = cls.conn.cursor()
        cols = ", ".join(row.keys())
        values = ", ".join([f"%({key})s" for key in row.keys()])
        print(53453)
        print(f"INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING obj_id")
        print("-----")
        print(row)
        cur.execute(
            f"INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING obj_id", row
        )
        return cur.fetchone()[0]

    @classmethod
    def update(cls, table, row, obj_id, schema="tww_app"):
        cur = cls.conn.cursor()
        cols = ",".join(["{key}=%({key})s".format(key=key) for key in row.keys()])
        row["obj_id"] = obj_id
        cur.execute(f"UPDATE {schema}.{table} SET {cols} WHERE obj_id=%(obj_id)s", row)

    @classmethod
    def delete(cls, table, obj_id, schema="tww_app"):
        cur = cls.conn.cursor()
        cur.execute(f"DELETE FROM {schema}.{table} WHERE obj_id=%s", [obj_id])

    def insert_check(self, table, row, expected_row=None, schema="tww_app"):
        obj_id = self.insert(table, row, schema)
        result = self.select(table, obj_id, schema)

        assert result, obj_id

        if expected_row:
            row = expected_row

        self.check_result(row, result, table, "insert", schema)

        return obj_id

    def update_check(self, table, row, obj_id, schema="tww_app"):
        self.update(table, row, obj_id, schema)
        result = self.select(table, obj_id, schema)
        self.check_result(row, result, table, "update", schema)

    def check_result(self, expected, result, table, test_name, schema="tww_app"):
        # TODO: don't convert to unicode, type inference for smallint is
        # currently broken, that's the reason at the moment.
        self.assertTrue(result, "No result set received.")

        for key, value in expected.items():
            self.assertEqual(
                str(result[key]),
                str(value),
                """
             ========================================================

             Data: {expected}

             ========================================================

             Failed {test_name} test on
             Table: "{table}"
             Schema: "{schema}"
             Field: "{key}"
               expected: {expected_value} ({expected_type})
               result: {result_value} ({result_type})

             ========================================================
            """.format(
                    expected=repr(expected),
                    test_name=test_name,
                    table=table,
                    schema=schema,
                    key=key,
                    expected_value=value,
                    result_value=result[key],
                    expected_type=type(value),
                    result_type=type(result[key]),
                ),
            )

    @classmethod
    def make_line(cls, x1, y1, z1, x2, y2, z2, srid=2056):
        """
        Helper to make 3D line geometries
        """
        return cls.execute(
            "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s, %s), ST_MakePoint(%s, %s, %s)), %s))",
            [x1, y1, z1, x2, y2, z2, srid],
        )

    @classmethod
    def make_line_2d(cls, x1, y1, x2, y2, srid=2056):
        """
        Helper to make 2D line geometries
        """
        return cls.execute(
            "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s), ST_MakePoint(%s, %s)), %s))",
            [x1, y1, x2, y2, srid],
        )

    @classmethod
    def make_point(cls, x, y, z, srid=2056):
        """
        Helper to make 3D point geometries
        """
        return cls.execute("ST_SetSrid(ST_MakePoint(%s, %s, %s), %s)", [x, y, z, srid])

    @classmethod
    def make_point_2d(cls, x, y, z=None, srid=2056):
        """
        Helper to make 2D point geometries
        """
        return cls.execute("ST_SetSrid(ST_MakePoint(%s, %s), %s)", [x, y, srid])
