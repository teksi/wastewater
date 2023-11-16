-- View: tww_app.vw_catchment_area_wwc_connections

-- DROP VIEW tww_app.vw_catchment_area_wwc_connections;

CREATE OR REPLACE VIEW tww_app.vw_catchment_area_wwc_connections AS
 SELECT ca.obj_id,
    st_force2d(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_ww_current.situation3d_geometry))::geometry(LineString,2056) AS connection_ww_current_geometry,
    st_length(st_force2d(st_makeline(st_centroid(st_curvetoline(ca.perimeter_geometry)), wn_ww_current.situation3d_geometry))::geometry(LineString,2056)) AS length_ww_current,
    wn_ww_current.obj_id AS node_ww_current_obj_id
   FROM tww_od.catchment_area ca
     LEFT JOIN tww_od.wastewater_node wn_ww_current ON ca.fk_wastewater_networkelement_ww_current::text = wn_ww_current.obj_id::text;
