
-- DROP MATERIALIZED VIEW IF EXISTS qgep_od.vw_network_node;

CREATE MATERIALIZED VIEW qgep_od.vw_network_node AS
WITH cover_levels_per_network_element AS (
  SELECT ne.obj_id,
         MAX(level) as level
  FROM qgep_od.cover co
  JOIN qgep_od.structure_part sp ON co.obj_id = sp.obj_id
  JOIN qgep_od.wastewater_structure ws ON sp.fk_wastewater_structure = ws.obj_id
  JOIN qgep_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
  GROUP BY ne.obj_id
)
SELECT n.id as gid,
       CASE
         WHEN n.node_type = 'reach_point' THEN n.rp_id
         WHEN n.node_type = 'wastewater_node' THEN n.ne_id
         ELSE n.ne_id || '-BLIND-' || row_number() OVER (PARTITION BY n.node_type, n.ne_id ORDER BY ST_X(n.geom))
       END AS obj_id,
       n.node_type as type,
       CASE
         WHEN n.node_type = 'reach_point' THEN 'reach_point'
         WHEN mh.obj_id IS NOT NULL THEN 'manhole'
         WHEN ws.obj_id IS NOT NULL THEN 'special_structure'
         ELSE 'other'
       END AS node_type,
       CASE
         WHEN n.node_type = 'reach_point' THEN rp.level
         WHEN n.node_type = 'wastewater_node' THEN nd.bottom_level
         ELSE NULL
       END as level,
       NULL::text AS usage_current,
       co.level as cover_level,
       NULL::float AS backflow_level,
       CASE
         WHEN n.node_type = 'reach_point' THEN rp.identifier
         WHEN n.node_type = 'wastewater_node' THEN ne.identifier
         ELSE ne.identifier || '-BLIND-' || row_number() OVER (PARTITION BY n.node_type, n.ne_id ORDER BY ST_X(n.geom))
       END AS description,
       n.geom AS situation_geometry,
       n.geom AS detail_geometry
FROM qgep_network.node n
LEFT JOIN qgep_od.reach_point rp ON rp_id = rp.obj_id
LEFT JOIN qgep_od.wastewater_networkelement ne ON n.ne_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_node nd ON n.ne_id = nd.obj_id
LEFT JOIN cover_levels_per_network_element co ON n.ne_id = co.obj_id AND n.node_type = 'wastewater_node'
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN qgep_od.manhole mh ON mh.obj_id = ws.obj_id;

CREATE INDEX in_qgep_od_vw_network_node_situation_geometry ON qgep_od.vw_network_node USING gist (situation_geometry);