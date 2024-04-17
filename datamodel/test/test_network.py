import os
import unittest

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg
    import psycopg2.extras as psycopg_extras

from .utils import DEFAULT_PG_SERVICE, DbTestBase


class TestNetwork(unittest.TestCase, DbTestBase):
    """
    Tests for network generation logic.

    Legend for diagrams :
    Nodes
        * :     reachpoint
        o :     blind junction
        MH :    manhole
    Segments
        ---> :  reach segment
        ⇐ :     rp's fk_wastewater_networkelement junction
    """

    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice = os.environ.get("PGSERVICE") or DEFAULT_PG_SERVICE
        cls.conn = psycopg.connect(f"service={pgservice}")

    def make_reach(self, identifier, x1, y1, x2, y2):
        """
        Helper function that makes a reach, returns obj_id, reachpoint_start_id, reachpoint_end_id
        """
        reach = {
            "identifier": identifier,
            "progression3d_geometry": self.make_line(x1, y1, 100, x2, y2, 100),
        }
        reach_id = self.insert("vw_tww_reach", reach)
        reach = self.select("reach", reach_id, schema="tww_od")
        return reach_id, reach["fk_reach_point_from"], reach["fk_reach_point_to"]

    def make_manhole(self, identifier, x, y):
        """
        Helper function that makes a manhole, returns (obj_id, wn_obj_id)
        """
        manhole = {"identifier": identifier, "situation3d_geometry": self.make_point_2d(x, y)}
        manhole_id = self.insert("vw_tww_wastewater_structure", manhole)
        manhole_wn_id = self.select("vw_tww_wastewater_structure", manhole_id)["wn_obj_id"]
        return manhole_id, manhole_wn_id

    def connect_reach(self, reach_id, from_id=None, to_id=None):
        """
        Helper function to connect reach from/to wastewater network elements
        """
        data = {}
        if from_id is not None:
            data["rp_from_fk_wastewater_networkelement"] = from_id
        if to_id is not None:
            data["rp_to_fk_wastewater_networkelement"] = to_id
        self.update("vw_tww_reach", data, reach_id)

    def refresh_graph(self):
        self.execute("tww_app.network_refresh_network_simple()")

    def downstream_nodes_depths(self, node_id):
        """returns a dict with all downstream nodes depths by id
        (includes self, depth is negative for downstream)"""

        query = """
        WITH RECURSIVE node_with_parent AS (
            SELECT n.obj_id, s.from_obj_id AS parent_id
            FROM tww_app.vw_network_node n
            LEFT JOIN tww_app.vw_network_segment s ON s.to_obj_id = n.obj_id
        ),
        downstream AS (
            SELECT obj_id, parent_id, 0 AS depth
            FROM node_with_parent
            WHERE obj_id = %s

            UNION ALL

            SELECT n.obj_id, n.parent_id, downstream.depth + 1
            FROM node_with_parent n
            INNER JOIN downstream ON downstream.obj_id = n.parent_id
        )
        SELECT obj_id, depth
        FROM downstream;
        """
        try:
            cur = self.cursor(row_factory=psycopg.rows.dict_row)
        except AttributeError:
            # remove when dropping psycopg2 support
            cur = self.cursor(cursor_factory=psycopg_extras.DictCursor)
        cur.execute(query, (node_id,))
        return {row["obj_id"]: row["depth"] for row in cur.fetchall()}

    def upstream_nodes_depths(self, node_id):
        """returns a dict with all upstream nodes depths by id
        (includes self, depth is negative for upstream)"""

        query = """
        WITH RECURSIVE node_with_child AS (
            SELECT n.obj_id, s.to_obj_id AS child_id FROM tww_app.vw_network_node n
            LEFT JOIN tww_app.vw_network_segment s ON s.from_obj_id = n.obj_id
        ),
        upstream AS (
            SELECT obj_id, child_id, 0 AS depth
            FROM node_with_child
            WHERE obj_id = %s

            UNION ALL

            SELECT n.obj_id, n.child_id, upstream.depth - 1
            FROM node_with_child n
            INNER JOIN upstream ON upstream.obj_id = n.child_id
        )
        SELECT obj_id, depth
        FROM upstream
        """
        try:
            cur = self.cursor(row_factory=psycopg.rows.dict_row)
        except AttributeError:
            # remove when dropping psycopg2 support
            cur = self.cursor(cursor_factory=psycopg_extras.DictCursor)
        cur.execute(query, (node_id,))
        return {row["obj_id"]: row["depth"] for row in cur.fetchall()}

    def test_network_basic(self):
        """
          *
          |
          | second
          |
          v
          *
          ⇓
         MH ⇐ *----------------->*
                     first

        first is connected FROM the manhole, second is connected TO manhole
        """

        manhole_id, manhole_wn_id = self.make_manhole("manhole", 0, 0)
        reach_1_id, rp_1a_id, rp_1b_id = self.make_reach("first", 0, 0, 10, 0)
        reach_2_id, rp_2a_id, rp_2b_id = self.make_reach("second", 0, 10, 0, 0)

        self.connect_reach(reach_1_id, from_id=manhole_wn_id)
        self.connect_reach(reach_2_id, to_id=manhole_wn_id)

        self.refresh_graph()

        # test network from manhole
        down_depths = self.downstream_nodes_depths(manhole_wn_id)
        up_depths = self.upstream_nodes_depths(manhole_wn_id)

        self.assertEqual(len(up_depths), 3)
        self.assertEqual(up_depths[rp_2a_id], -2)
        self.assertEqual(up_depths[rp_2b_id], -1)
        self.assertEqual(len(down_depths), 3)
        self.assertEqual(down_depths[rp_1a_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 2)

        # test network from reach 2 start
        down_depths = self.downstream_nodes_depths(rp_2a_id)
        up_depths = self.upstream_nodes_depths(rp_2a_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 5)
        self.assertEqual(down_depths[rp_2b_id], 1)
        self.assertEqual(down_depths[manhole_wn_id], 2)
        self.assertEqual(down_depths[rp_1a_id], 3)
        self.assertEqual(down_depths[rp_1b_id], 4)

        # test network from reach 1 end
        down_depths = self.downstream_nodes_depths(rp_1b_id)
        up_depths = self.upstream_nodes_depths(rp_1b_id)

        self.assertEqual(len(up_depths), 5)
        self.assertEqual(up_depths[rp_1a_id], -1)
        self.assertEqual(up_depths[manhole_wn_id], -2)
        self.assertEqual(up_depths[rp_2b_id], -3)
        self.assertEqual(up_depths[rp_2a_id], -4)
        self.assertEqual(len(down_depths), 1)

    def test_network_blind_connection(self):
        """
                    *
                    |
                    | second
                    |
                    v
                    *
                    ⇓
         MH ⇐ *-----o------------>*
                     first
        first is connected FROM manhole, second is connected TO first directly (blind connection)
        """

        manhole_id, manhole_wn_id = self.make_manhole("manhole", 0, 0)
        reach_1_id, rp_1a_id, rp_1b_id = self.make_reach("first", 0, 0, 10, 0)
        reach_2_id, rp_2a_id, rp_2b_id = self.make_reach("second", 5, 10, 5, 0)

        self.connect_reach(reach_1_id, from_id=manhole_wn_id)
        self.connect_reach(reach_2_id, to_id=reach_1_id)

        self.refresh_graph()

        # test network from manhole
        down_depths = self.downstream_nodes_depths(manhole_wn_id)
        up_depths = self.upstream_nodes_depths(manhole_wn_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 4)
        self.assertEqual(down_depths[rp_1a_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 3)

        # test network from reach 2 start
        down_depths = self.downstream_nodes_depths(rp_2a_id)
        up_depths = self.upstream_nodes_depths(rp_2a_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 4)
        self.assertEqual(down_depths[rp_2b_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 3)

        # test network from reach 1 end
        down_depths = self.downstream_nodes_depths(rp_1b_id)
        up_depths = self.upstream_nodes_depths(rp_1b_id)

        self.assertEqual(len(up_depths), 6)
        self.assertEqual(up_depths[rp_1a_id], -2)
        self.assertEqual(up_depths[manhole_wn_id], -3)
        self.assertEqual(up_depths[rp_2b_id], -2)
        self.assertEqual(up_depths[rp_2a_id], -3)
        self.assertEqual(len(down_depths), 1)

    def test_network_blind_connection_overlaid(self):
        """
          *
          |
          | second
          |
          v
          *   ⤵
         MH ⇐ *----------------->*
                     first
        first is connected FROM manhole, second is connected TO first directly (blind connection)
        but at the same position than the node
        """

        manhole_id, manhole_wn_id = self.make_manhole("manhole", 0, 0)
        reach_1_id, rp_1a_id, rp_1b_id = self.make_reach("first", 0, 0, 10, 0)
        reach_2_id, rp_2a_id, rp_2b_id = self.make_reach("second", 0, 10, 0, 0)

        self.connect_reach(reach_1_id, from_id=manhole_wn_id)
        self.connect_reach(reach_2_id, to_id=reach_1_id)

        self.refresh_graph()

        # test network from manhole
        down_depths = self.downstream_nodes_depths(manhole_wn_id)
        up_depths = self.upstream_nodes_depths(manhole_wn_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 3)
        self.assertEqual(down_depths[rp_1a_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 2)

        # test network from reach 2 start
        down_depths = self.downstream_nodes_depths(rp_2a_id)
        up_depths = self.upstream_nodes_depths(rp_2a_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 4)
        self.assertEqual(down_depths[rp_2b_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 3)

        # test network from reach 1 end
        down_depths = self.downstream_nodes_depths(rp_1b_id)
        up_depths = self.upstream_nodes_depths(rp_1b_id)

        self.assertEqual(len(up_depths), 5)
        self.assertEqual(up_depths[rp_1a_id], -1)
        self.assertEqual(up_depths[manhole_wn_id], -2)
        self.assertEqual(up_depths[rp_2b_id], -2)
        self.assertEqual(up_depths[rp_2a_id], -3)
        self.assertEqual(len(down_depths), 1)

    def test_network_two_blind_connection(self):
        """
                     *     *
                     |     |
              second |     | third
                     |     |
                     v     v
                     *     *
                     ⇓     ⇓
         MH ⇐ *------o-----o------>*
                     first
        first is connected FROM manhole, second and third are connected TO first directly (blind connection)
        """

        manhole_id, manhole_wn_id = self.make_manhole("manhole", 0, 0)
        reach_1_id, rp_1a_id, rp_1b_id = self.make_reach("first", 0, 0, 10, 0)
        reach_2_id, rp_2a_id, rp_2b_id = self.make_reach("second", 3, 10, 3, 0)
        reach_3_id, rp_3a_id, rp_3b_id = self.make_reach("third", 6, 10, 6, 0)

        self.connect_reach(reach_1_id, from_id=manhole_wn_id)
        self.connect_reach(reach_2_id, to_id=reach_1_id)
        self.connect_reach(reach_3_id, to_id=reach_1_id)

        self.refresh_graph()

        # test network from manhole
        down_depths = self.downstream_nodes_depths(manhole_wn_id)
        up_depths = self.upstream_nodes_depths(manhole_wn_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 5)
        self.assertEqual(down_depths[rp_1a_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 4)

        # test network from reach 2 start
        down_depths = self.downstream_nodes_depths(rp_2a_id)
        up_depths = self.upstream_nodes_depths(rp_2a_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 5)
        self.assertEqual(down_depths[rp_2b_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 4)

        # test network from reach 1 end
        down_depths = self.downstream_nodes_depths(rp_1b_id)
        up_depths = self.upstream_nodes_depths(rp_1b_id)

        self.assertEqual(len(up_depths), 9)
        self.assertEqual(up_depths[rp_1a_id], -3)
        self.assertEqual(up_depths[manhole_wn_id], -4)
        self.assertEqual(up_depths[rp_2b_id], -3)
        self.assertEqual(up_depths[rp_2a_id], -4)
        self.assertEqual(len(down_depths), 1)

    def test_network_two_opposing_blind_connection(self):
        """
                       *
                       |
                second |
                       |
                       v
                       *
                       ⇓  first
         MH ⇐ *--------o--------->*
                       ⇑
                       *
                       |
                 third |
                       |
                       *
        first is connected FROM manhole, second and third are connected TO first directly (blind connection)
        but arrive at the exact same point
        """

        manhole_id, manhole_wn_id = self.make_manhole("manhole", 0, 0)
        reach_1_id, rp_1a_id, rp_1b_id = self.make_reach("first", 0, 0, 10, 0)
        reach_2_id, rp_2a_id, rp_2b_id = self.make_reach("second", 5, 10, 5, 0)
        reach_3_id, rp_3a_id, rp_3b_id = self.make_reach("third", 5, -10, 5, 0)

        self.connect_reach(reach_1_id, from_id=manhole_wn_id)
        self.connect_reach(reach_2_id, to_id=reach_1_id)
        self.connect_reach(reach_3_id, to_id=reach_1_id)

        self.refresh_graph()

        # test network from manhole
        down_depths = self.downstream_nodes_depths(manhole_wn_id)
        up_depths = self.upstream_nodes_depths(manhole_wn_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 4)
        self.assertEqual(down_depths[rp_1a_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 3)

        # test network from reach 2 start
        down_depths = self.downstream_nodes_depths(rp_2a_id)
        up_depths = self.upstream_nodes_depths(rp_2a_id)

        self.assertEqual(len(up_depths), 1)
        self.assertEqual(len(down_depths), 4)
        self.assertEqual(down_depths[rp_2b_id], 1)
        self.assertEqual(down_depths[rp_1b_id], 3)

        # test network from reach 1 end
        down_depths = self.downstream_nodes_depths(rp_1b_id)
        up_depths = self.upstream_nodes_depths(rp_1b_id)

        self.assertEqual(len(up_depths), 8)
        self.assertEqual(up_depths[rp_1a_id], -2)
        self.assertEqual(up_depths[manhole_wn_id], -3)
        self.assertEqual(up_depths[rp_2b_id], -2)
        self.assertEqual(up_depths[rp_2a_id], -3)
        self.assertEqual(len(down_depths), 1)


if __name__ == "__main__":
    unittest.main()
