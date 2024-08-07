CREATE OR REPLACE VIEW tww_app.vw_change_points
AS
SELECT ne_node.obj_id,
node.situation3d_geometry AS geom,
re.material <> re_next.material AS change_in_material,
re.clear_height <> re_next.clear_height AS change_in_clear_height,
(rp_from.level - rp_to.level) / re.length_effective - (rp_next_from.level - rp_next_to.level) / re_next.length_effective AS change_in_slope
FROM tww_od.reach re
LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
LEFT JOIN tww_od.wastewater_networkelement ne_node ON ne_node.obj_id::text = rp_to.fk_wastewater_networkelement::text
LEFT JOIN tww_od.wastewater_node node ON node.obj_id::text = ne_node.obj_id::text
LEFT JOIN tww_od.reach_point rp_next_from ON rp_next_from.fk_wastewater_networkelement::text = ne_node.obj_id::text
LEFT JOIN tww_od.reach re_next ON rp_next_from.obj_id::text = re_next.fk_reach_point_from::text
LEFT JOIN tww_od.reach_point rp_next_to ON rp_next_to.obj_id::text = re_next.fk_reach_point_to::text
LEFT JOIN tww_od.wastewater_networkelement ne ON re.obj_id::text = ne.obj_id::text
LEFT JOIN tww_od.wastewater_networkelement ne_next ON re_next.obj_id::text = ne_next.obj_id::text
WHERE ne_next.fk_wastewater_structure::text = ne.fk_wastewater_structure::text;
