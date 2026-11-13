UPDATE tww_vl.discharge_point_relevance_import_rel_agxx
SET value_de=replace(value_de,'.','_');

ALTER TABLE IF EXISTS tww_od.agxx_unconnected_node_bwrel
ADD COLUMN IF NOT EXISTS ag96_is_gateway bigint,
ADD CONSTRAINT agxx_unc_fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;


INSERT INTO tww_vl.wastewater_node_ag64_function (code,vsacode,value_de,active) VALUES
(1999948,1999948,'Anschluss',true),
(1999933,1999933,'andere',true), -- für Zweitdeckel
(1999932,1999932,'Messstelle',true),
(1999931,1999931,'Abwasserreinigungsanlage',true),
(1999930,1999930,'Regenwasserrechen',true),
(1999929,1999929,'Regenwassersieb',true),
(1999928,1999928,'Rohrbruecke',true)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, active = EXCLUDED.active
;

CREATE TABLE IF NOT EXISTS tww_vl.agxx_import_rel_mapping_gepknoten_funktionag
(
    code integer NOT NULL,
    value_de character varying(100) COLLATE pg_catalog."default" NOT NULL,
	target_class character varying(100) COLLATE pg_catalog."default" NOT NULL,
	target_attribute character varying(100) COLLATE pg_catalog."default" NOT NULL,
	 CONSTRAINT pkey_tww_agxx_import_rel_code PRIMARY KEY (code)
);

CREATE INDEX IF NOT EXISTS
    idx_agxx_import_rel_mapping_gepknoten_funktionag_value_de
ON
    tww_vl.agxx_import_rel_mapping_gepknoten_funktionag(value_de);

INSERT INTO tww_vl.agxx_import_rel_mapping_gepknoten_funktionag (code,value_de,target_class,target_attribute) VALUES
(1999948,'Anschluss','tww_od.agxx_wastewater_node','ag64_function'),
(1999933,'andere','tww_od.agxx_wastewater_node','ag64_function'), -- für Zweitdeckel
(1999932,'Messstelle','tww_od.agxx_wastewater_node','ag64_function'),
(1999931,'Abwasserreinigungsanlage','tww_od.agxx_wastewater_node','ag64_function'),
(1999930,'Regenwasserrechen','tww_od.agxx_wastewater_node','ag64_function'),
(1999929,'Regenwassersieb','tww_od.agxx_wastewater_node','ag64_function'),
(1999928,'Rohrbruecke','tww_od.agxx_wastewater_node','ag64_function')
ON CONFLICT (code) DO NOTHING;

INSERT INTO
tww_vl.agxx_import_rel_mapping_gepknoten_funktionag
(code,value_de,target_class,target_attribute)
SELECT code, value_de, 'tww_od.manhole', 'function'
FROM
tww_vl.manhole_function_import_rel_agxx;

INSERT INTO
tww_vl.agxx_import_rel_mapping_gepknoten_funktionag
(code,value_de,target_class,target_attribute)
SELECT code, value_de, 'tww_od.special_structure', 'function'
FROM
tww_vl.special_structure_function_import_rel_agxx;

INSERT INTO
tww_vl.agxx_import_rel_mapping_gepknoten_funktionag
(code,value_de,target_class,target_attribute)
SELECT code, value_de, 'tww_od.discharge_point', 'relevance'
FROM
tww_vl.discharge_point_relevance_import_rel_agxx;

INSERT INTO
tww_vl.agxx_import_rel_mapping_gepknoten_funktionag
(code,value_de,target_class,target_attribute)
SELECT code, value_de, 'tww_od.infiltration_installation', 'kind'
FROM
tww_vl.infiltration_installation_kind_import_rel_agxx;
