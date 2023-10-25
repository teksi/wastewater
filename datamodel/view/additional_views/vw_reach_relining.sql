-- View: qgep_od.vw_reach_relining

-- DROP VIEW qgep_od.vw_reach_relining;

CREATE OR REPLACE VIEW qgep_od.vw_reach_relining AS 
 SELECT re.obj_id,
    re.clear_height,
    re.inside_coating,
    re.length_effective,
    re.material,
    re.progression_geometry,
    re.reliner_material,
    re.reliner_nominal_size,
    re.relining_construction,
    re.relining_kind,
    re.ring_stiffness,
    re.wall_roughness,
    we.identifier,
    we.remark,
    we.last_modification,
    we.fk_wastewater_structure
   FROM qgep_od.reach re
     LEFT JOIN qgep_od.wastewater_networkelement we ON we.obj_id::text = re.obj_id::text
   Where re.relining_construction > 1 or re.material = 5078;

ALTER TABLE qgep_od.vw_reach_relining
  OWNER TO postgres;
GRANT ALL ON TABLE qgep_od.vw_reach_relining TO postgres;
GRANT ALL ON TABLE qgep_od.vw_reach_relining TO qgep;

