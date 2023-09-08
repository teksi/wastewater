-- View: qgep_od.vw_catchment_area_rwc_connections

-- DROP VIEW qgep_od.vw_catchment_area_rwc_connections;

CREATE OR REPLACE VIEW qgep_od.vw_catchment_area_rwc_connections AS 
 SELECT ca.obj_id,
    ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_current.situation_geometry))::geometry(LineString,2056) AS connection_rw_current_geometry,
    ST_Length(ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_current.situation_geometry))::geometry(LineString,2056)) AS Length_rw_current,
    wn_rw_current.obj_id AS node_rw_current_obj_id,
   FROM qgep_od.catchment_area ca
     LEFT JOIN qgep_od.wastewater_node wn_rw_current ON ca.fk_wastewater_networkelement_rw_current::text = wn_rw_current.obj_id::text
