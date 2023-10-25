
-- DROP MATERIALIZED VIEW IF EXISTS qgep_od.vw_network_segment;

CREATE MATERIALIZED VIEW qgep_od.vw_network_segment AS
SELECT s.id as gid,
       COALESCE(
         s.ne_id, 
         CASE
           WHEN n1.type = 'wastewater_node' THEN n1.obj_id
           WHEN n2.type = 'wastewater_node' THEN n2.obj_id
           ELSE ''
         END
       ) AS obj_id,
       s.segment_type AS type,
       r.clear_height AS clear_height,
       ST_Length(geom) AS length_calc,
       ST_Length(r.progression_geometry) AS length_full,
       n1.obj_id AS from_obj_id,
       n2.obj_id AS to_obj_id,
       n1.obj_id AS from_obj_id_interpolate,
       n2.obj_id AS to_obj_id_interpolate,
       0 AS from_pos,
       1 AS to_pos,
       CASE
         WHEN s.segment_type = 'reach' THEN NULL
         WHEN n1.level IS NOT NULL AND n2.level IS NOT NULL THEN Greatest(n1.level, n2.level)
         ELSE COALESCE(n1.level, n2.level)
       END AS bottom_level,
       ch.usage_current AS usage_current,
       mat.abbr_de AS material,
       s.geom AS progression_geometry,
       s.geom AS detail_geometry
FROM qgep_network.segment s
JOIN qgep_od.vw_network_node n1 ON n1.gid = s.from_node
JOIN qgep_od.vw_network_node n2 ON n2.gid = s.to_node
LEFT JOIN qgep_od.reach r ON r.obj_id = s.ne_id
LEFT JOIN qgep_vl.reach_material mat ON r.material = mat.code
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id = s.ne_id
LEFT JOIN qgep_od.channel ch ON ch.obj_id = ne.fk_wastewater_structure;

CREATE INDEX in_qgep_od_vw_network_segment_progression_geometry ON qgep_od.vw_network_segment USING gist (progression_geometry);