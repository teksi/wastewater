-- View: tww_app.vw_catchment_area_rwc_connections

-- DROP VIEW tww_app.vw_catchment_area_rwc_connections;

CREATE OR REPLACE VIEW tww_app.vw_catchment_area_rwc_connections AS
 SELECT ca.obj_id,
    ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_current.situation3d_geometry))::geometry(LineString, {SRID} ) AS connection_rw_current_geometry,
    ST_Length(ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_current.situation3d_geometry))::geometry(LineString, {SRID} )) AS Length_rw_current,
    wn_rw_current.obj_id AS node_rw_current_obj_id
   FROM tww_od.catchment_area ca
     LEFT JOIN tww_od.wastewater_node wn_rw_current ON ca.fk_wastewater_networkelement_rw_current::text = wn_rw_current.obj_id::text
