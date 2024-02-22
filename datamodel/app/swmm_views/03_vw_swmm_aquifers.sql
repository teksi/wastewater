--------
-- // skip-keyword-check View for the swmm module class aquifer (in  qgep wrongly named aquifier), in VSA-DSS 2020 not part of the datamodel anymore - therefore referenced on tww_od.dss15_aquifer
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_aquifers AS

SELECT
	aq.obj_id as Name,
	0.5 as Porosity,
	0.15 as WiltingPoint,
	0.30 as FieldCapacity,
	5.0 as Conductivity,
	10.0 as ConductivitySlope,
	15.0 as TensionSlope,
	0.35 as UpperEvapFraction,
	14.0 as LowerEvapDepth,
	0.002 as LowerGWLossRate,
	minimal_groundwater_level as BottomElevation,
	average_groundwater_level as WaterTableElevation,
	0.3 as UnsatZoneMoisture,
	null as UpperEvapPattern
FROM tww_od.dss15_aquifer as aq;
