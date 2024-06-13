/*
Adding the urgency parameters and the structure condition parameters to the database
*/
-- this column is an extension to the VSA data model and assigns urgency weight to function hierarchic
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN tww_weight_urgency numeric(3,2);
UPDATE tww_vl.channel_function_hierarchic
SET tww_weight_urgency= (dict->>code::text)::numeric
FROM (
	SELECT
	jsonb_build_object(
    5068, 1,             -- pwwf.water_bodies
    5070, 0.9,           -- pwwf.main_drain_regional
    5069, 0.95,          -- pwwf.main_drain
    5071, 1,             -- pwwf.collector_sewer
    5062, 1,             -- pwwf.renovation_conduction
    5064, 1.1,           -- pwwf.residential_drainage
    5072, 1,             -- pwwf.road_drainage
    5066, 1,             -- pwwf.other
    5074, 1,             -- pwwf.unknown
    5063, 1,             -- swwf.renovation_conduction
    5065, 1,             -- swwf.residential_drainage
    5073, 1,             -- swwf.road_drainage
    5067, 1,             -- swwf.other
    5075, 1              -- swwf.unknown
) dict )as obj
;
COMMENT ON COLUMN tww_vl.channel_function_hierarchic.tww_weight_urgency IS 'this column is an extension to the VSA data model and assigns ugency weight
 according to the VSA guidelines';

 -- this column is an extension to the VSA data model and assigns urgency weight to function hierarchic
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN tww_weight_urgency numeric(3,2);
UPDATE tww_vl.channel_usage_current
SET tww_weight_urgency= (dict->>code::text)::numeric
FROM (
	SELECT jsonb_build_object(
               4526, .95,           -- wastewater
               4522, 1,             -- combined_wastewater
               4516, 1,             -- discharged_combined_wastewater
               4524, 0.9,           -- industrial_wastewater
               4514, 1.1,           -- clean_wastewater
               9023, 1.05,          -- surface_water
               4518, 1.1,           -- creek_water
               4571, 0.95,          -- other
               5322, 1              -- unknown
           ) dict )as obj
;

COMMENT ON COLUMN tww_vl.channel_usage_current.tww_weight_urgency IS 'this column is an extension to the VSA data model and assigns ugency weight
 according to the VSA guidelines';
