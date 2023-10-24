-- table wastewater_structure is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_structure/cover symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_structures only at larger scales)
-- _orientation is necessary for certain symbols (e.g. oil separator)

-- TABLE wastewater_structure

ALTER TABLE tww_od.wastewater_structure ADD COLUMN _usage_current integer;
COMMENT ON COLUMN tww_od.wastewater_structure._usage_current IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _function_hierarchic integer;
COMMENT ON COLUMN tww_od.wastewater_structure._function_hierarchic IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
ALTER TABLE tww_od.manhole ADD COLUMN _orientation numeric;
COMMENT ON COLUMN tww_od.manhole._orientation IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _label text;
COMMENT ON COLUMN tww_od.wastewater_structure._label IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _cover_label text;
COMMENT ON COLUMN tww_od.wastewater_structure._cover_label IS 'stores the cover altitude to be used for labelling, not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _input_label text;
COMMENT ON COLUMN tww_od.wastewater_structure._input_label IS 'stores the list of input altitudes to be used for labelling, not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _output_label text;
COMMENT ON COLUMN tww_od.wastewater_structure._output_label IS 'stores the list of output altitudes to be used for labelling, not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN _bottom_label text;
COMMENT ON COLUMN tww_od.wastewater_structure._bottom_label IS 'stores the bottom altitude to be used for labelling, not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';


-- this column is an extension to the VSA data model and puts the _function_hierarchic in order
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN order_fct_hierarchic smallint;
-- integrate and adapt Alter order_fct_hierarchic in tww_vl.channel_function_hierarchic #224 https://github.com/QGEP/datamodel/pull/224
-- this column is an extension to the VSA data model and puts the _usage_current in order
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN order_usage_current smallint;
UPDATE tww_vl.channel_function_hierarchic 
SET order_fct_hierarchic=
 array_position(
	 ARRAY[
		 5068 --pwwf.water_bodies
  	     ,5070 --pwwf.main_drain_regional
		 ,5069 --pwwf.main_drain
		 ,5071 --pwwf.collector_sewer
		 ,5062 --pwwf.renovation_conduction
		 ,5064 --pwwf.residential_drainage		 
		 ,5072 --pwwf.road_drainage
		 ,5066 --pwwf.other
		 ,5074 --pwwf.unknown
		 ,5063 --swwf.renovation_conduction
		 ,5065 --swwf.residential_drainage
		 ,5073 --swwf.road_drainage
		 ,5067 --swwf.other
		 ,5075 --swwf.unknown
		 ]
	 ,code); 

-- table wastewater_node is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_node symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_nodes only at larger scales)

-- TABLE wastewater_node
ALTER TABLE tww_od.wastewater_node ADD COLUMN _usage_current integer;
COMMENT ON COLUMN tww_od.wastewater_node._usage_current IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
ALTER TABLE tww_od.wastewater_node ADD COLUMN _function_hierarchic integer;
COMMENT ON COLUMN tww_od.wastewater_node._function_hierarchic IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
ALTER TABLE tww_od.wastewater_node ADD COLUMN _status integer;
COMMENT ON COLUMN tww_od.wastewater_node._status IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';


-- Modifications applied for link with SWMM
-------------------------------------------

-- Add attributes
ALTER TABLE tww_od.reach ADD COLUMN swmm_default_coefficient_of_friction  smallint ;
COMMENT ON COLUMN tww_od.reach.swmm_default_coefficient_of_friction IS '1 / N_Manning, value between 0 and 999. Value exported in SWMM if coefficient_of_friction and wall_roughness are not set. ';
ALTER TABLE tww_od.reach ADD COLUMN dss2020_hydraulic_load_current smallint ;
COMMENT ON COLUMN tww_od.reach.dss2020_hydraulic_load_current IS 'Dimensioning of the discharge divided by the normal discharge capacity of the reach [%]. / Dimensionierungsabfluss geteilt durch Normalabflusskapazität der Leitung [%]. / Débit de dimensionnement divisé par la capacité d''écoulement normale de la conduite [%].';

-- Add table for defaults coefficients of friction
CREATE SCHEMA IF NOT EXISTS tww_app.swmm;
CREATE TABLE tww_app.swmm.reach_coefficient_of_friction (fk_material integer, coefficient_of_friction smallint);
ALTER TABLE tww_app.swmm.reach_coefficient_of_friction ADD CONSTRAINT pkey_tww_vl_reach_coefficient_of_friction_id PRIMARY KEY (fk_material);
INSERT INTO tww_app.swmm.reach_coefficient_of_friction(fk_material) SELECT vsacode FROM tww_vl.reach_material;
UPDATE tww_app.swmm.reach_coefficient_of_friction SET coefficient_of_friction = (CASE WHEN fk_material IN (5381,5081,3016) THEN 100
                                                                                    WHEN fk_material IN (2754,3638,3639,3640,3641,3256,147,148,3648,5079,5080,153,2762) THEN 83
                                                                                    WHEN fk_material IN (2755) THEN 67
                                                                                    WHEN fk_material IN (5076,5077,5078,5382) THEN 111
                                                                                    WHEN fk_material IN (3654) THEN 91
                                                                                    WHEN fk_material IN (154,2761) THEN 71
                                                                                    ELSE 100 END);
