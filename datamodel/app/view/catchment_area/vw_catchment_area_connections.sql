DROP VIEW IF EXISTS tww_app.vw_catchment_area_connections;

CREATE VIEW tww_app.vw_catchment_area_connections AS
SELECT

ca.obj_id,
ST_Force2D(ST_MakeLine(ST_Centroid(ST_CurveToLine(perimeter_geometry)),
wn_rw_current.situation3d_geometry))::geometry( LineString, %(SRID)s ) AS connection_rw_current_geometry,
ST_Force2D(ST_MakeLine(ST_Centroid(ST_CurveToLine(perimeter_geometry)),
wn_ww_current.situation3d_geometry))::geometry( LineString, %(SRID)s ) AS connection_ww_current_geometry

FROM tww_od.catchment_area ca
LEFT JOIN tww_od.wastewater_node wn_rw_current
ON ca.fk_wastewater_networkelement_rw_current = wn_rw_current.obj_id
LEFT JOIN tww_od.wastewater_node wn_ww_current
ON ca.fk_wastewater_networkelement_ww_current = wn_ww_current.obj_id;
