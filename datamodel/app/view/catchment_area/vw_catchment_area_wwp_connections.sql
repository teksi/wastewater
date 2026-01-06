-- View: tww_app.vw_catchment_area_wwp_connections

-- DROP VIEW tww_app.vw_catchment_area_wwp_connections;

CREATE OR REPLACE VIEW tww_app.vw_catchment_area_wwp_connections AS
 SELECT ca.obj_id,
    st_force2d(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_ww_planned.situation3d_geometry))::geometry(LineString, {SRID} ) AS connection_ww_planned_geometry,
    st_length(st_force2d(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_ww_planned.situation3d_geometry))::geometry(LineString, {SRID} )) AS length_ww_planned,
    wn_ww_planned.obj_id AS node_ww_planned_obj_id
   FROM tww_od.catchment_area ca
     LEFT JOIN tww_od.wastewater_node wn_ww_planned ON ca.fk_wastewater_networkelement_ww_planned::text = wn_ww_planned.obj_id::text;
