-- table wastewater_structure is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_structure/cover symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_structures only at larger scales)
-- _orientation is necessary for certain symbols (e.g. oil separator)

-- TABLE wastewater_structure

ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _usage_current integer;
COMMENT ON COLUMN qgep_od.wastewater_structure._usage_current IS 'not part of the VSA-DSS data model
added solely for QGEP
has to be updated by triggers';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _function_hierarchic integer;
COMMENT ON COLUMN qgep_od.wastewater_structure._function_hierarchic IS 'not part of the VSA-DSS data model
added solely for QGEP
has to be updated by triggers';
ALTER TABLE qgep_od.manhole ADD COLUMN _orientation numeric;
COMMENT ON COLUMN qgep_od.manhole._orientation IS 'not part of the VSA-DSS data model
added solely for QGEP';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _label text;
COMMENT ON COLUMN qgep_od.wastewater_structure._label IS 'not part of the VSA-DSS data model
added solely for QGEP';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _cover_label text;
COMMENT ON COLUMN qgep_od.wastewater_structure._cover_label IS 'stores the cover altitude to be used for labelling, not part of the VSA-DSS data model
added solely for QGEP';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _input_label text;
COMMENT ON COLUMN qgep_od.wastewater_structure._input_label IS 'stores the list of input altitudes to be used for labelling, not part of the VSA-DSS data model
added solely for QGEP';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _output_label text;
COMMENT ON COLUMN qgep_od.wastewater_structure._output_label IS 'stores the list of output altitudes to be used for labelling, not part of the VSA-DSS data model
added solely for QGEP';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _bottom_label text;
COMMENT ON COLUMN qgep_od.wastewater_structure._bottom_label IS 'stores the bottom altitude to be used for labelling, not part of the VSA-DSS data model
added solely for QGEP';


-- this column is an extension to the VSA data model and puts the _function_hierarchic in order
ALTER TABLE qgep_vl.channel_function_hierarchic ADD COLUMN order_fct_hierarchic smallint;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=5 WHERE code=5062;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=7 WHERE code=5063;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=6 WHERE code=5064;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=8 WHERE code=5065;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=10 WHERE code=5066;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=13 WHERE code=5067;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=1 WHERE code=5068;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=3 WHERE code=5069;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=2 WHERE code=5070;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=4 WHERE code=5071;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=9 WHERE code=5072;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=12 WHERE code=5073;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=11 WHERE code=5074;
UPDATE qgep_vl.channel_function_hierarchic SET order_fct_hierarchic=14 WHERE code=5075;

-- this column is an extension to the VSA data model and puts the _usage_current in order
ALTER TABLE qgep_vl.channel_usage_current ADD COLUMN order_usage_current smallint;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=5 WHERE code = 4514;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=3 WHERE code = 4516;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=7 WHERE code = 4518;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=6 WHERE code = 4520;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=2 WHERE code = 4522;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=4 WHERE code = 4524;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=1 WHERE code = 4526;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=8 WHERE code = 4571;
UPDATE qgep_vl.channel_usage_current SET order_usage_current=9 WHERE code = 5322;


-- table wastewater_node is extended to hold additional attributes necessary for symbology reasons
-- extended attributes are started with an underscore
-- _usage_current is necessary for coloring the wastewater_node symbols
-- _function_hierarchic is necessary for scale-based filtering (display minor wastewater_nodes only at larger scales)

-- TABLE wastewater_node
ALTER TABLE qgep_od.wastewater_node ADD COLUMN _usage_current integer;
COMMENT ON COLUMN qgep_od.wastewater_node._usage_current IS 'not part of the VSA-DSS data model
added solely for QGEP
has to be updated by triggers';
ALTER TABLE qgep_od.wastewater_node ADD COLUMN _function_hierarchic integer;
COMMENT ON COLUMN qgep_od.wastewater_node._function_hierarchic IS 'not part of the VSA-DSS data model
added solely for QGEP
has to be updated by triggers';
ALTER TABLE qgep_od.wastewater_node ADD COLUMN _status integer;
COMMENT ON COLUMN qgep_od.wastewater_node._status IS 'not part of the VSA-DSS data model
added solely for QGEP
has to be updated by triggers';


-- Modifications applied for link with SWMM
-------------------------------------------

-- Add attributes
ALTER TABLE qgep_od.reach ADD COLUMN swmm_default_coefficient_of_friction  smallint ;
COMMENT ON COLUMN qgep_od.reach.swmm_default_coefficient_of_friction IS '1 / N_Manning, value between 0 and 999. Value exported in SWMM if coefficient_of_friction and wall_roughness are not set. ';
ALTER TABLE qgep_od.reach ADD COLUMN dss2020_hydraulic_load_current smallint ;
COMMENT ON COLUMN qgep_od.reach.dss2020_hydraulic_load_current IS 'Dimensioning of the discharge divided by the normal discharge capacity of the reach [%]. / Dimensionierungsabfluss geteilt durch Normalabflusskapazität der Leitung [%]. / Débit de dimensionnement divisé par la capacité d''écoulement normale de la conduite [%].';

-- Add table for defaults coefficients of friction
CREATE SCHEMA IF NOT EXISTS qgep_swmm;
CREATE TABLE qgep_swmm.reach_coefficient_of_friction (fk_material integer, coefficient_of_friction smallint);
ALTER TABLE qgep_swmm.reach_coefficient_of_friction ADD CONSTRAINT pkey_qgep_vl_reach_coefficient_of_friction_id PRIMARY KEY (fk_material);
INSERT INTO qgep_swmm.reach_coefficient_of_friction(fk_material) SELECT vsacode FROM qgep_vl.reach_material;
UPDATE qgep_swmm.reach_coefficient_of_friction SET coefficient_of_friction = (CASE WHEN fk_material IN (5381,5081,3016) THEN 100
                                                                                    WHEN fk_material IN (2754,3638,3639,3640,3641,3256,147,148,3648,5079,5080,153,2762) THEN 83
                                                                                    WHEN fk_material IN (2755) THEN 67
                                                                                    WHEN fk_material IN (5076,5077,5078,5382) THEN 111
                                                                                    WHEN fk_material IN (3654) THEN 91
                                                                                    WHEN fk_material IN (154,2761) THEN 71
                                                                                    ELSE 100 END);
