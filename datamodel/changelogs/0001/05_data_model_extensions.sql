-- table wastewater_structure is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_structure/cover symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_structures only at larger scales)
-- _orientation is necessary for certain symbols (e.g. oil separator)

-- TABLE wastewater_structure

ALTER TABLE tww_od.manhole ADD COLUMN _orientation numeric;
COMMENT ON COLUMN tww_od.manhole._orientation IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP';


ALTER TABLE tww_od.organisation ADD COLUMN tww_active bool DEFAULT FALSE;
COMMENT ON COLUMN tww_od.organisation.tww_active IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
used to filter organisations';

ALTER TABLE tww_od.organisation ADD COLUMN tww_local_extension bool DEFAULT FALSE;
COMMENT ON COLUMN tww_od.organisation.tww_local_extension IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
used to map non-harmonized organisations to private on export';


-- table wastewater_node is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_node symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_nodes only at larger scales)

-- TABLE wastewater_node
CREATE TABLE IF NOT EXISTS tww_od.tww_wastewater_node_symbology
(
	fk_wastewater_node character varying(16),
    _usage_current integer,
	_function_hierarchic integer,
	_status integer,
	CONSTRAINT pkey_tww_od_tww_wastewater_node_symbology_fk_wastewater_node PRIMARY KEY (fk_wastewater_node),
	CONSTRAINT oorel_od_tww_wastewater_structure_label_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);


COMMENT ON COLUMN tww_od.tww_wastewater_node_symbology._usage_current IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
COMMENT ON COLUMN tww_od.tww_wastewater_node_symbology._function_hierarchic IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';
COMMENT ON COLUMN tww_od.tww_wastewater_node_symbology._status IS 'not part of the VSA-DSS data model
added solely for TEKSI Wastewater & GEP
has to be updated by triggers';

CREATE TABLE IF NOT EXISTS tww_od.tww_symbology_quarantine
(
	obj_id character varying(16),
	CONSTRAINT pkey_tww_od_tww_symbology_quarantine_obj_id PRIMARY KEY (obj_id),
	CONSTRAINT oorel_od_tww_symbology_quarantine_wastewater_networkelement FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_networkelement (obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS tww_od.tww_reach_point_label
(
	fk_reach_point character varying(16),
	fk_wastewater_structure character varying(16),
    label_text varchar(5),
	azimuth numeric(4,3), -- radians
	CONSTRAINT pkey_tww_od_tww_reach_point_label_fk_reach_point PRIMARY KEY (fk_reach_point),
	CONSTRAINT oorel_od_tww_reach_point_label_reach_point FOREIGN KEY (fk_reach_point) REFERENCES tww_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fkey_od_tww_reach_point_label_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE tww_od.tww_reach_point_label IS 'stores reach point labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';

COMMENT ON TABLE tww_od.tww_reach_point_label.azimuth IS 'azimuth of respective reach';

CREATE TABLE IF NOT EXISTS tww_od.tww_wastewater_structure_label
(
	fk_wastewater_structure character varying(16),
    label_text_c varchar(15),
	label_text_b varchar(15),
	label_text_rp varchar(15)
	CONSTRAINT pkey_tww_od_tww_wastewater_structure_label_fk_wastewater_structure PRIMARY KEY (fk_wastewater_structure),
	CONSTRAINT oorel_od_tww_wastewater_structure_label_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE tww_od.tww_wastewater_structure_label IS 'stores wastewater_structure labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';


---------------------------
-- Value List extensions --
---------------------------


-- this column is an extension to the VSA data model and puts the _function_hierarchic in order
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN tww_symbology_order smallint;
UPDATE tww_vl.channel_function_hierarchic
SET tww_symbology_order=
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

-- this column is an extension to the VSA data model defines which function_hierarchic to use in labels
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN tww_use_in_labels bool DEFAULT false;
UPDATE tww_vl.channel_function_hierarchic
SET tww_use_in_labels= true WHERE value_en like 'pwwf%';

-- this column is an extension to the VSA data model defines which status to use in labels
ALTER TABLE tww_vl.wastewater_structure_status ADD COLUMN tww_use_in_labels bool DEFAULT false;
UPDATE tww_vl.wastewater_structure_status
SET tww_use_in_labels= true WHERE code=ANY('{8493,6530,6533}');

-- this column is an extension to the VSA data model defines for which function_hierarchic the inflow is prioritized over the outflow
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN tww_symbology_inflow_prio bool DEFAULT false;
UPDATE tww_vl.channel_function_hierarchic
SET tww_symbology_inflow_prio= true WHERE code =4516;


-- integrate and adapt Alter order_fct_hierarchic in tww_vl.channel_function_hierarchic #224
-- https://github.com/QGEP/datamodel/pull/224 //skip-keyword-check
-- this column is an extension to the VSA data model and puts the _usage_current in order
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN tww_symbology_order smallint;

UPDATE tww_vl.channel_usage_current
SET tww_symbology_order=
 array_position(
	 ARRAY[
		  4526 --wastewater
  	     ,4522 --combined_wastewater
		 ,4516 --discharged_combined_wastewater
		 ,4524 --clean_wastewater
		 ,4514 --clean_wastewater
		 ,9023 --surface_water
		 ,4518 --creek_water
		 ,4571 --other
		 ,5322 --unknown
		 ]
	 ,code);

-- this column is an extension to the VSA data model and facilitates filtering out primary features
ALTER TABLE tww_vl.channel_function_hierarchic ADD COLUMN tww_is_primary bool DEFAULT FALSE;
UPDATE tww_vl.channel_function_hierarchic
SET tww_is_primary=true
WHERE left(value_en, 4)='pwwf';
UPDATE tww_vl.channel_function_hierarchic
SET tww_is_primary=false
WHERE left(value_en, 4)<>'pwwf';
COMMENT ON COLUMN tww_vl.channel_function_hierarchic.tww_is_primary IS 'True when part of the primary network. Facilitates exporting primary elements only.
Not part of the VSA-DSS data model, added solely for TEKSI Wastewater & GEP';
