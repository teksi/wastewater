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
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	ws_obj_id character varying(16),
	wn_obj_id character varying(16),
	CONSTRAINT unq_tww_symbology_quarantine_ws_obj_id UNIQUE (ws_obj_id),
	CONSTRAINT unq_tww_symbology_quarantine_wn_obj_id UNIQUE (wn_obj_id)
);

CREATE TABLE IF NOT EXISTS tww_od.tww_reach_point_label
(
	fk_reach_point character varying(16),
	fk_wastewater_structure character varying(16),
    label_text text,
	azimuth numeric(4,3), -- radians
	CONSTRAINT pkey_tww_od_tww_reach_point_label_fk_reach_point PRIMARY KEY (fk_reach_point),
	CONSTRAINT oorel_od_tww_reach_point_label_reach_point FOREIGN KEY (fk_reach_point) REFERENCES tww_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fkey_od_tww_reach_point_label_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE tww_od.tww_reach_point_label IS 'stores reach point labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';

COMMENT ON COLUMN tww_od.tww_reach_point_label.azimuth IS 'azimuth of respective reach';

CREATE TABLE IF NOT EXISTS tww_od.tww_wastewater_structure_label
(
	fk_wastewater_structure character varying(16),
    label_text_c text,
	label_text_b text,
	label_text_rp text,
	CONSTRAINT pkey_tww_od_tww_wastewater_structure_label_fk_wastewater_structure PRIMARY KEY (fk_wastewater_structure),
	CONSTRAINT oorel_od_tww_wastewater_structure_label_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE tww_od.tww_wastewater_structure_label IS 'stores wastewater_structure labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';

ALTER TABLE tww_od.wastewater_node DROP COLUMN IF EXISTS _usage_current;
ALTER TABLE tww_od.wastewater_node DROP COLUMN IF EXISTS _function_hierarchic;
ALTER TABLE tww_od.wastewater_node DROP COLUMN IF EXISTS _status;

ALTER TABLE tww_od.wastewater_structure DROP COLUMN IF EXISTS _label;
ALTER TABLE tww_od.wastewater_structure DROP COLUMN IF EXISTS _cover_label;
ALTER TABLE tww_od.wastewater_structure DROP COLUMN IF EXISTS _input_label;
ALTER TABLE tww_od.wastewater_structure DROP COLUMN IF EXISTS _output_label;
ALTER TABLE tww_od.wastewater_structure DROP COLUMN IF EXISTS _bottom_label;
