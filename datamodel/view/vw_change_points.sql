CREATE VIEW qgep_od.vw_change_points AS
SELECT
  rp_to.obj_id,
  rp_to.situation_geometry::geometry(POINTZ, %(SRID)s) AS geom,
  re.material <> re_next.material AS change_in_material,
  re.clear_height <> re_next.clear_height AS change_in_clear_height,
  (rp_from.level - rp_to.level) / re.length_effective - (rp_next_from.level - rp_next_to.level) / re_next.length_effective AS change_in_slope
FROM qgep_od.reach re
LEFT JOIN qgep_od.reach_point rp_to ON rp_to.obj_id = re.fk_reach_point_to
LEFT JOIN qgep_od.reach_point rp_from ON rp_from.obj_id = re.fk_reach_point_from
LEFT JOIN qgep_od.reach re_next ON rp_to.fk_wastewater_networkelement = re_next.obj_id
LEFT JOIN qgep_od.reach_point rp_next_to ON rp_next_to.obj_id = re_next.fk_reach_point_to
LEFT JOIN qgep_od.reach_point rp_next_from ON rp_next_from.obj_id = re_next.fk_reach_point_from
LEFT JOIN qgep_od.wastewater_networkelement ne ON re.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_networkelement ne_next ON re_next.obj_id = ne_next.obj_id
WHERE ne_next.fk_wastewater_structure = ne.fk_wastewater_structure
