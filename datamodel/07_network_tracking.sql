-- Views for network following with the Python NetworkX module and the QGEP Python plugins

/*
This generates a graph representing the network.
It also provides backwards-compatible views for the plugin.
*/

CREATE TABLE qgep_network.node (
  id SERIAL PRIMARY KEY,
  node_type TEXT, -- one of wastewater_node, reachpoint or blind_connection
  ne_id TEXT NULL REFERENCES qgep_od.wastewater_networkelement(obj_id) ON DELETE CASCADE, -- reference to the network element (this will reference the reach object for reachpoints)
  rp_id TEXT NULL REFERENCES qgep_od.reach_point(obj_id) ON DELETE CASCADE, -- will only be set for reachpoints
  geom geometry('POINT', :SRID)
);

CREATE TABLE qgep_network.segment (
  id SERIAL PRIMARY KEY,
  segment_type TEXT, -- either reach (if it's a reach segment) or junction (if it represents junction from/to a reachpoint)
  from_node INT REFERENCES qgep_network.node(id) ON DELETE CASCADE,
  to_node INT REFERENCES qgep_network.node(id) ON DELETE CASCADE,
  ne_id TEXT NULL REFERENCES qgep_od.wastewater_networkelement(obj_id) ON DELETE CASCADE, -- reference to the network element (will only be set for segments corresponding to reaches)
  geom geometry('LINESTRING', :SRID)
);

CREATE OR REPLACE FUNCTION qgep_network.refresh_network_simple() RETURNS void SECURITY DEFINER AS $body$
BEGIN

  TRUNCATE qgep_network.segment CASCADE;
  TRUNCATE qgep_network.node CASCADE;

  -- Insert wastewater nodes
  INSERT INTO qgep_network.node(node_type, ne_id, geom)
  SELECT
    'wastewater_node',
    n.obj_id,
    ST_Force2D(n.situation_geometry)
  FROM qgep_od.wastewater_node n;

  -- Insert reachpoints
  INSERT INTO qgep_network.node(node_type, ne_id, rp_id, geom)
  SELECT
    'reach_point',
    r.obj_id, -- the reachpoint also keeps a reference to it's reach, as it can be used by blind connections that happen exactly on start/end points
    rp.obj_id,
    ST_Force2D(rp.situation_geometry)
  FROM qgep_od.reach_point rp
  JOIN qgep_od.reach r ON rp.obj_id = r.fk_reach_point_from OR rp.obj_id = r.fk_reach_point_to;

  -- Insert virtual nodes for blind connections
  INSERT INTO qgep_network.node(node_type, ne_id, geom)
  SELECT DISTINCT
    'blind_connection',
    r.obj_id,
    ST_ClosestPoint(r.progression_geometry, rp.situation_geometry)
  FROM qgep_od.reach r
  INNER JOIN qgep_od.reach_point rp ON rp.fk_wastewater_networkelement = r.obj_id
  WHERE ST_LineLocatePoint(ST_CurveToLine(r.progression_geometry), rp.situation_geometry) NOT IN (0.0, 1.0); -- if exactly at start or at end, we don't need a virtualnode as we have the reachpoint

  -- Insert reaches, subdivided according to blind reaches
  INSERT INTO qgep_network.segment (segment_type, from_node, to_node, ne_id, geom)
  SELECT 'reach',
         sub2.node_id_1,
         sub2.node_id_2,
         obj_id,
         ST_LineSubstring(
           ST_CurveToLine(ST_Force2D(progression_geometry)), ratio_1, ratio_2
         )
  FROM (
    -- This subquery uses LAG to combine a node with the next on a reach.
    SELECT LAG(sub1.node_id) OVER (PARTITION BY sub1.obj_id ORDER BY sub1.ratio) as node_id_1,
           sub1.node_id as node_id_2,
           sub1.progression_geometry,
           LAG(sub1.ratio) OVER (PARTITION BY sub1.obj_id ORDER BY sub1.ratio) as ratio_1,
           sub1.ratio as ratio_2,
           obj_id
    FROM (
        -- This subquery joins blind node to reach, with "ratio" being the position of the node along the reach
        SELECT r.obj_id,
               r.progression_geometry,
               n.id as node_id,
               ST_LineLocatePoint(ST_CurveToLine(r.progression_geometry), n.geom) AS ratio
        FROM qgep_od.reach r
        JOIN qgep_network.node n ON n.ne_id = r.obj_id
    ) AS sub1
  ) AS sub2
  WHERE ratio_1 IS NOT NULL AND ratio_1 <> ratio_2;

  -- Insert edge between reachpoint (from) to the closest node belonging to the wasterwater network element
  INSERT INTO qgep_network.segment (segment_type, from_node, to_node, geom)
  SELECT DISTINCT ON(n1.id)
         'special_structure',
         n2.id,
         n1.id,
         ST_MakeLine(n2.geom, n1.geom)
  FROM (

    SELECT
      rp.obj_id as rp_obj_id,
      rp.fk_wastewater_networkelement as wwne_id
    FROM qgep_od.reach_point rp
    JOIN qgep_od.reach r ON rp.obj_id = r.fk_reach_point_from
    WHERE rp.fk_wastewater_networkelement IS NOT NULL

  ) AS sub1
  JOIN qgep_network.node as n1 ON n1.rp_id = rp_obj_id
  JOIN qgep_network.node as n2 ON n2.ne_id = wwne_id
  ORDER BY n1.id, ST_Distance(n1.geom, n2.geom);

  -- Insert edge between reachpoint (to) to the closest node belonging to the wasterwater network element
  INSERT INTO qgep_network.segment (segment_type, from_node, to_node, geom)
  SELECT DISTINCT ON(n1.id)
         'special_structure',
         n1.id,
         n2.id,
         ST_MakeLine(n1.geom, n2.geom)
  FROM (

    SELECT
      rp.obj_id as rp_obj_id,
      rp.fk_wastewater_networkelement as wwne_id
    FROM qgep_od.reach_point rp
    JOIN qgep_od.reach r ON rp.obj_id = r.fk_reach_point_to
    WHERE rp.fk_wastewater_networkelement IS NOT NULL

  ) AS sub1
  JOIN qgep_network.node as n1 ON n1.rp_id = rp_obj_id
  JOIN qgep_network.node as n2 ON n2.ne_id = wwne_id
  ORDER BY n1.id, ST_Distance(n1.geom, n2.geom);

  REFRESH MATERIALIZED VIEW qgep_od.vw_network_node;
  REFRESH MATERIALIZED VIEW qgep_od.vw_network_segment;

END;
$body$
LANGUAGE plpgsql;

