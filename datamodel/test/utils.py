import psycopg2
import psycopg2.extras

DEFAULT_PG_SERVICE = "pg_teksi_wastewater"


class DbTestBase:
    def assert_count(self, table, schema, expected):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(f"SELECT COUNT(*) FROM {schema}.{table}")
        count = cur.fetchone()[0]
        assert count == expected, "Relation {}.{} : expected {} rows, got {} rows".format(
            schema, table, expected, count
        )

    def select(self, table, obj_id, schema="qgep_od"):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(
            "SELECT * FROM {schema}.{table} WHERE obj_id=%(obj_id)s".format(
                table=table, schema=schema
            ),
            {"obj_id": obj_id},
        )
        return cur.fetchone()

    def execute(self, sql: str, params=[]):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(f"SELECT {sql}", params)
        return cur.fetchone()[0]

    def cursor(self):
        return self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def insert(self, table, row, schema="qgep_od"):
        cur = self.conn.cursor()
        cols = ", ".join(row.keys())
        values = ", ".join([f"%({key})s" for key in row.keys()])
        cur.execute(
            "INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING obj_id".format(
                table=table, schema=schema, cols=cols, values=values
            ),
            row,
        )
        return cur.fetchone()[0]

    def update(self, table, row, obj_id, schema="qgep_od"):
        cur = self.conn.cursor()
        cols = ",".join(["{key}=%({key})s".format(key=key) for key in row.keys()])
        row["obj_id"] = obj_id
        cur.execute(
            "UPDATE {schema}.{table} SET {cols} WHERE obj_id=%(obj_id)s".format(
                table=table, schema=schema, cols=cols
            ),
            row,
        )

    def delete(self, table, obj_id, schema="qgep_od"):
        cur = self.conn.cursor()
        cur.execute(
            f"DELETE FROM {schema}.{table} WHERE obj_id=%s",
            [obj_id],
        )

    def insert_check(self, table, row, expected_row=None, schema="qgep_od"):
        obj_id = self.insert(table, row, schema)
        result = self.select(table, obj_id, schema)

        assert result, obj_id

        if expected_row:
            row = expected_row

        self.check_result(row, result, table, "insert", schema)

        return obj_id

    def update_check(self, table, row, obj_id, schema="qgep_od"):
        self.update(table, row, obj_id, schema)
        result = self.select(table, obj_id, schema)
        self.check_result(row, result, table, "update", schema)

    def check_result(self, expected, result, table, test_name, schema="qgep_od"):
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

    def make_line(self, x1, y1, z1, x2, y2, z2, srid=2056):
        """
        Helper to make 3D line geometries
        """
        return self.execute(
            "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s, %s), ST_MakePoint(%s, %s, %s)), %s))",
            [x1, y1, z1, x2, y2, z2, srid],
        )

    def make_line_2d(self, x1, y1, x2, y2, srid=2056):
        """
        Helper to make 2D line geometries
        """
        return self.execute(
            "ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s), ST_MakePoint(%s, %s)), %s))",
            [x1, y1, x2, y2, srid],
        )

    def make_point(self, x, y, z, srid=2056):
        """
        Helper to make 3D point geometries
        """
        return self.execute("ST_SetSrid(ST_MakePoint(%s, %s, %s), %s)", [x, y, z, srid])

    def make_point_2d(self, x, y, z=None, srid=2056):
        """
        Helper to make 2D point geometries
        """
        return self.execute("ST_SetSrid(ST_MakePoint(%s, %s), %s)", [x, y, srid])
