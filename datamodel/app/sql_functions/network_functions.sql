CREATE OR REPLACE FUNCTION tww_app.network_refresh_network_simple() RETURNS void SECURITY DEFINER AS $body$
BEGIN

  TRUNCATE tww_od.network_segment CASCADE;
  TRUNCATE tww_od.network_node CASCADE;

  -- Insert wastewater nodes
  INSERT INTO tww_od.network_node(node_type, ne_id, geom)
  SELECT
    'wastewater_node',
    n.obj_id,
    ST_Force2D(n.situation3d_geometry)
  FROM tww_od.wastewater_node n;

-- Insert reachpoints
  INSERT INTO tww_od.network_node(node_type, ne_id, rp_id, geom)
  SELECT
    'reach_point',
    coalesce(r_t.obj_id, r_f.obj_id), -- the reachpoint also keeps a reference to it's reach, as it can be used by blind connections that happen exactly on start/end points
    rp.obj_id,
    ST_Force2D(coalesce(rp.situation3d_geometry,ST_EndPoint(r_t.progression3d_geometry),ST_StartPoint(r_f.progression3d_geometry)))
  FROM tww_od.reach_point rp
  LEFT JOIN tww_od.reach r_f ON rp.obj_id = r_f.fk_reach_point_from
  LEFT JOIN tww_od.reach r_t ON rp.obj_id = r_t.fk_reach_point_to;

  -- Insert virtual nodes for blind connections
  INSERT INTO tww_od.network_node(node_type, ne_id, geom)
  SELECT DISTINCT
    'blind_connection',
    r.obj_id,
    ST_ClosestPoint(r.progression3d_geometry, coalesce(rp.situation3d_geometry,ST_EndPoint(r_t.progression3d_geometry),ST_StartPoint(r_f.progression3d_geometry)))
  FROM tww_od.reach r
  INNER JOIN tww_od.reach_point rp ON rp.fk_wastewater_networkelement = r.obj_id
  LEFT JOIN tww_od.reach r_f ON rp.obj_id = r_f.fk_reach_point_from
  LEFT JOIN tww_od.reach r_t ON rp.obj_id = r_t.fk_reach_point_to
  WHERE ST_LineLocatePoint(ST_CurveToLine(r.progression3d_geometry),
    coalesce(rp.situation3d_geometry,
	  ST_EndPoint(r_t.progression3d_geometry),
	  ST_StartPoint(r_f.progression3d_geometry)))
	NOT IN (0.0, 1.0); -- if exactly at start or at end, we don't need a virtualnode as we have the reachpoint

  -- Insert reaches, subdivided according to blind reaches
  INSERT INTO tww_od.network_segment (segment_type, from_node, to_node, ne_id, geom)
  SELECT 'reach',
         sub2.node_id_1,
         sub2.node_id_2,
         obj_id,
         ST_LineSubstring(
           ST_CurveToLine(ST_Force2D(progression3d_geometry)), ratio_1, ratio_2
         )
  FROM (
    -- This subquery uses LAG to combine a node with the next on a reach.
    SELECT LAG(sub1.node_id) OVER (PARTITION BY sub1.obj_id ORDER BY sub1.ratio) as node_id_1,
           sub1.node_id as node_id_2,
           sub1.progression3d_geometry,
           LAG(sub1.ratio) OVER (PARTITION BY sub1.obj_id ORDER BY sub1.ratio) as ratio_1,
           sub1.ratio as ratio_2,
           obj_id
    FROM (
        -- This subquery joins blind node to reach, with "ratio" being the position of the node along the reach
        SELECT r.obj_id,
               r.progression3d_geometry,
               n.id as node_id,
               ST_LineLocatePoint(ST_CurveToLine(r.progression3d_geometry), n.geom) AS ratio
        FROM tww_od.reach r
        JOIN tww_od.network_node n ON n.ne_id = r.obj_id
    ) AS sub1
  ) AS sub2
  WHERE ratio_1 IS NOT NULL AND ratio_1 <> ratio_2;

  -- Insert edge between reachpoint (from) to the closest node belonging to the wasterwater network element
  INSERT INTO tww_od.network_segment (segment_type, from_node, to_node, geom)
  SELECT DISTINCT ON(n1.id)
         'special_structure',
         n2.id,
         n1.id,
         ST_MakeLine(n2.geom, n1.geom)
  FROM (

    SELECT
      rp.obj_id as rp_obj_id,
      rp.fk_wastewater_networkelement as wwne_id
    FROM tww_od.reach_point rp
    JOIN tww_od.reach r ON rp.obj_id = r.fk_reach_point_from
    WHERE rp.fk_wastewater_networkelement IS NOT NULL

  ) AS sub1
  JOIN tww_od.network_node as n1 ON n1.rp_id = rp_obj_id
  JOIN tww_od.network_node as n2 ON n2.ne_id = wwne_id
  ORDER BY n1.id, ST_Distance(n1.geom, n2.geom);

  -- Insert edge between reachpoint (to) to the closest node belonging to the wasterwater network element
  INSERT INTO tww_od.network_segment (segment_type, from_node, to_node, geom)
  SELECT DISTINCT ON(n1.id)
         'special_structure',
         n1.id,
         n2.id,
         ST_MakeLine(n1.geom, n2.geom)
  FROM (

    SELECT
      rp.obj_id as rp_obj_id,
      rp.fk_wastewater_networkelement as wwne_id
    FROM tww_od.reach_point rp
    JOIN tww_od.reach r ON rp.obj_id = r.fk_reach_point_to
    WHERE rp.fk_wastewater_networkelement IS NOT NULL

  ) AS sub1
  JOIN tww_od.network_node as n1 ON n1.rp_id = rp_obj_id
  JOIN tww_od.network_node as n2 ON n2.ne_id = wwne_id
  ORDER BY n1.id, ST_Distance(n1.geom, n2.geom);

  PERFORM tww_app.refresh_materialized_views('tww_app',NULL,True);

END;
$body$
LANGUAGE plpgsql;
