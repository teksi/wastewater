-- Creates a default raingage for each subcatchment
CREATE OR REPLACE VIEW tww_app.swmm_vw_raingages AS
SELECT
  ('raingage@' , replace(ca.obj_id, ' ', '_'), '_', ca.state)::varchar as Name,
  'INTENSITY'::varchar as Format, -- Format in which the rain data are supplied: INTENSITY: each rainfall value is an average rate in inches/hour (or mm/hour) over the recording interval. VOLUME: each rainfall value is the volume of rain that fell in the recording interval (in inches or millimeters). CUMULATIVE: each rainfall value represents the cumulative rainfall that has occurred since the start of the last series of non-zero values (in inches or millimeters).
  '0:15'::varchar as Interval, -- Recording time interval between gage readings in decimal hours or hours:minutes format.
  '1.0'::varchar as SCF,  -- Snow Catch Factor Factor that corrects gage readings for snowfall.
  'TIMESERIES default_tww_raingage_timeserie'::varchar as Source, -- Source of rainfall data; either TIMESERIES for user-defined time series data or FILE for an external data file. see Rain Gage Properties of SWMM Documentation for furhter information.
  st_centroid(perimeter_geometry)::geometry(Point, {SRID}) as geom,
  state,
  CASE
		WHEN _function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
  wn_obj_id as obj_id
FROM
(
SELECT ca.*,'current' as state, wn.obj_id as wn_obj_id, cfhi.vsacode AS _function_hierarchic
FROM tww_od.catchment_area as ca
LEFT JOIN tww_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_current
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE fk_wastewater_networkelement_rw_current IS NOT NULL -- to avoid unconnected catchments
UNION
SELECT ca.*,'planned' as state, wn.obj_id as wn_obj_id, cfhi.vsacode AS _function_hierarchic
FROM tww_od.catchment_area as ca
LEFT JOIN tww_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_planned
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE fk_wastewater_networkelement_rw_planned IS NOT NULL -- to avoid unconnected catchments
UNION
SELECT ca.*,'current' as state, wn.obj_id as wn_obj_id, cfhi.vsacode AS _function_hierarchic
FROM tww_od.catchment_area as ca
LEFT JOIN tww_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_current
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE fk_wastewater_networkelement_ww_current IS NOT NULL -- to avoid unconnected catchments
UNION
SELECT ca.*,'planned' as state, wn.obj_id as wn_obj_id, cfhi.vsacode AS _function_hierarchic
FROM tww_od.catchment_area as ca
LEFT JOIN tww_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_planned
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE fk_wastewater_networkelement_ww_planned IS NOT NULL -- to avoid unconnected catchments
) as ca;
