-- table wastewater_structure is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_structure/cover symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_structures only at larger scales)
-- _orientation is necessary for certain symbols (e.g. oil separator)

-- TABLE wastewater_structure

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
-- integrate and adapt Alter order_fct_hierarchic in tww_vl.channel_function_hierarchic #224
-- https://github.com/QGEP/datamodel/pull/224 //skip-keyword-check
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
