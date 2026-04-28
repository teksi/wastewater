import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestInterpolation(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def test_vw_tww_reach_interpolate_z_vertices_local(self):
        """
        Local interpolation replaces missing intermediate Z using nearest neighbours.
        Geometry remains a COMPOUNDCURVEZ.
        """

        wkt = """
        COMPOUNDCURVEZ(
        (1 1 100, 2 2 90, 3 3 NaN, 4 4 70, 5 5 40)
        )
        """

        row = {
            "progression3d_geometry": self.geom_from_text(wkt),
            "rp_from_level": 100,
            "rp_to_level": 40,
            "rp_from_obj_id": "ch999999RP900001",
            "rp_to_obj_id": "ch999999RP900002",
        }

        obj_id = self.insert("vw_tww_reach", row)

        # Act
        self.execute(f"""
            SELECT tww_app.interpolate_reach_z_vertices(
                ARRAY['{obj_id}'],
                'local'
            );
            """)

        new_row = self.select("vw_tww_reach", obj_id)

        # Geometry type must still be a curve
        assert (
            self.execute("GeometryType(%s)", [new_row["progression3d_geometry"]])
            == "COMPOUNDCURVE"
        )

        # No NaN Z values must remain
        wkt = self.execute("ST_AsText(%s)", [new_row["progression3d_geometry"]])
        assert "NaN" not in wkt

        # Interpolated Z values from neighbouring indices
        z = self.execute(
            "ST_Z(ST_PointN(%s, 3))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z - 80) < 1e-9
        # Do not Interpolate Z values for existing indices with z value
        z = self.execute(
            "ST_Z(ST_PointN(%s, 2))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z - 90) < 1e-9
        z = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z - 70) < 1e-9

        # Levels unchanged
        assert new_row["rp_from_level"] == 100
        assert new_row["rp_to_level"] == 40

    def test_vw_tww_reach_interpolate_z_vertices_global(self):
        """
        Local interpolation replaces missing intermediate Z using nearest neighbours.
        Geometry remains a COMPOUNDCURVEZ.
        """

        wkt = """
        COMPOUNDCURVEZ(
        (1 1 100, 2 2 90, 3 3 NaN, 4 4 70, 5 5 40)
        )
        """

        row = {
            "progression3d_geometry": self.geom_from_text(wkt),
            "rp_from_level": 100,
            "rp_to_level": 40,
            "rp_from_obj_id": "ch999999RP900003",
            "rp_to_obj_id": "ch999999RP900004",
        }

        obj_id = self.insert("vw_tww_reach", row)

        # Act
        self.execute(f"""
            SELECT tww_app.interpolate_reach_z_vertices(
                ARRAY['{obj_id}'],
                'global'
            );
            """)

        new_row = self.select("vw_tww_reach", obj_id)

        # Geometry type must still be a curve
        assert (
            self.execute("GeometryType(%s)", [new_row["progression3d_geometry"]])
            == "COMPOUNDCURVE"
        )

        # No NaN Z values must remain
        wkt = self.execute("ST_AsText(%s)", [new_row["progression3d_geometry"]])
        assert "NaN" not in wkt

        # Interpolated Z values from start and end point indices
        z = self.execute(
            "ST_Z(ST_PointN(%s, 3))",
            [new_row["progression3d_geometry"]],
        )
        assert z == 70

        # All Z values are re-computed from start/end only (global mode)
        z = self.execute(
            "ST_Z(ST_PointN(%s, 2))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z - 85) < 1e-9
        z = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z - 55) < 1e-9

        # Levels unchanged
        assert new_row["rp_from_level"] == 100
        assert new_row["rp_to_level"] == 40

    def test_vw_tww_reach_interpolate_z_vertices_global_unequal_spacing(self):
        """
        Global interpolation must be distance-based (not index-based)
        for unevenly spaced vertices. Z=0 must never be used.
        """

        # Uneven spacing along X axis: distances 0, 1, 6, 10
        # Start Z = 100, End Z = 20
        wkt = """
        COMPOUNDCURVEZ(
        (0 0 100,
        1 0 NaN,
        6 0 NaN,
        10 0 20)
        )
        """

        row = {
            "progression3d_geometry": self.geom_from_text(wkt),
            "rp_from_level": 100,
            "rp_to_level": 20,
            "rp_from_obj_id": "ch999999RP900010",
            "rp_to_obj_id": "ch999999RP900011",
        }

        obj_id = self.insert("vw_tww_reach", row)

        # Act: global interpolation
        self.execute(f"""
            SELECT tww_app.interpolate_reach_z_vertices(
                ARRAY['{obj_id}'],
                'global'
            );
            """)

        new_row = self.select("vw_tww_reach", obj_id)

        # Geometry must remain a curve
        assert (
            self.execute("GeometryType(%s)", [new_row["progression3d_geometry"]])
            == "COMPOUNDCURVE"
        )

        # Vertex 2: distance = 1 → fraction = 0.1 → Z = 92
        z2 = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z2 - 92) < 1e-9

        z3 = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z3 - 52) < 1e-9

        # Endpoints unchanged
        assert new_row["rp_from_level"] == 100
        assert new_row["rp_to_level"] == 20

    def test_vw_tww_reach_interpolate_z_vertices_local_unequal_spacing(self):
        """
        Local interpolation must be based on nearest valid neighbours
        and use distance-based fractions for unevenly spaced vertices.
        """

        wkt = """
        COMPOUNDCURVEZ(
        (0 0 100,
        1 0 80,
        6 0 NaN,
        10 0 35)
        )
        """

        row = {
            "progression3d_geometry": self.geom_from_text(wkt),
            "rp_from_level": 100,
            "rp_to_level": 35,
            "rp_from_obj_id": "ch999999RP900020",
            "rp_to_obj_id": "ch999999RP900021",
        }

        obj_id = self.insert("vw_tww_reach", row)

        # Act: local interpolation
        self.execute(f"""
            SELECT tww_app.interpolate_reach_z_vertices(
                ARRAY['{obj_id}'],
                'local'
            );
            """)

        new_row = self.select("vw_tww_reach", obj_id)

        # Geometry must remain a curve
        assert (
            self.execute("GeometryType(%s)", [new_row["progression3d_geometry"]])
            == "COMPOUNDCURVE"
        )

        # Vertex 3: interpolate locally between Z=80 and Z=35
        z3 = self.execute(
            "ST_Z(ST_PointN(%s, 3))",
            [new_row["progression3d_geometry"]],
        )

        assert abs(z3 - 55) < 1e-9  # allow for numeric imprecision

        # Ensure existing neighbour Z values are preserved
        z2 = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z2 - 80) < 1e-9

        z4 = self.execute(
            "ST_Z(ST_PointN(%s, 4))",
            [new_row["progression3d_geometry"]],
        )
        assert abs(z4 - 35) < 1e-9

        # Endpoint levels unchanged
        assert new_row["rp_from_level"] == 100
        assert new_row["rp_to_level"] == 35
