-- View: tww_app.vw_catchment_area_rwp_connections

-- DROP VIEW tww_app.vw_catchment_area_rwp_connections;

CREATE OR REPLACE VIEW tww_app.vw_catchment_area_rwp_connections AS
 SELECT ca.obj_id,
    ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_planned.situation3d_geometry))::geometry(LineString,2056) AS connection_rw_planned_geometry,
    ST_Length(ST_Force2D(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_rw_planned.situation3d_geometry))::geometry(LineString,2056)) AS Length_rw_planned,
    wn_rw_planned.obj_id AS node_rw_planned_obj_id
   FROM tww_od.catchment_area ca
     LEFT JOIN tww_od.wastewater_node wn_rw_planned ON ca.fk_wastewater_networkelement_rw_planned::text = wn_rw_planned.obj_id::text
