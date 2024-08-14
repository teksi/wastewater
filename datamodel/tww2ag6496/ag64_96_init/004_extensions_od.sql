-- Abwasserknoten
ALTER TABLE tww_od.wastewater_node ADD COLUMN IF NOT EXISTS ag96_is_gateway bigint;
COMMENT ON COLUMN tww_od.wastewater_node.ag96_is_gateway IS 'Extension for AG-96/ Erweiterung aus AG-96, IstSchnittstelle /xxx_fr';
ALTER TABLE tww_od.wastewater_node ADD COLUMN IF NOT EXISTS ag64_function bigint;
COMMENT ON COLUMN tww_od.wastewater_node.ag64_function IS 'Extension for AG-96/ Erweiterung aus AG-96 zur Erfassung der Funktionag Anschluss /xxx_fr';

ALTER TABLE tww_od.wastewater_node DROP CONSTRAINT IF EXISTS fkey_vl_wastewater_node_ag96_is_gateway CASCADE;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.wastewater_node DROP CONSTRAINT IF EXISTS fkey_vl_wastewater_node_ag64_function CASCADE;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag64_function FOREIGN KEY (ag64_function) REFERENCES tww_vl.wastewater_node_ag64_function MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

ALTER TABLE tww_od.wastewater_structure ADD COLUMN IF NOT EXISTS ag96_fk_measure varchar(16); 
-- Topologische Verknüpfung Massnahme/Abwasserbauwerk
ALTER TABLE tww_od.wastewater_structure DROP CONSTRAINT IF EXISTS ag96_rel_wastewater_structure_measure;
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ag96_rel_wastewater_structure_measure FOREIGN KEY (ag96_fk_measure) REFERENCES tww_od.measure(obj_id) ON DELETE SET NULL; 
COMMENT ON COLUMN tww_od.wastewater_structure.ag96_fk_measure IS 'Extension for AG-96/ Erweiterung aus AG-96, 1:n-Beziehung /xxx_fr';

-- Topologische Verknüpfung Haltung Ist und Soll
ALTER TABLE tww_od.reach ADD COLUMN IF NOT EXISTS ag96_clear_height_planned integer; 
ALTER TABLE tww_od.reach ADD COLUMN IF NOT EXISTS ag96_clear_width_planned integer; 
COMMENT ON COLUMN tww_od.reach.ag96_clear_height_planned IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.reach.ag96_clear_width_planned IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

-- SBW_Einzugsgebiet.Fremdwasseranfall_geplant
ALTER TABLE tww_od.catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_sewer_infiltration_water_dim  decimal(9,3); 
COMMENT ON COLUMN tww_od.catchment_area_totals.ag96_sewer_infiltration_water_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_waste_water_production_dim  decimal(9,3); 
COMMENT ON COLUMN tww_od.catchment_area_totals.ag96_waste_water_production_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_perimeter_geometry  geometry(MultiSurface,2056); 
COMMENT ON COLUMN tww_od.catchment_area_totals.ag96_waste_water_production_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

-- Bauten Ausserhalb Baugebiet
ALTER TABLE tww_od.building_group
  ADD COLUMN IF NOT EXISTS ag96_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_GEP in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag96_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag96_remark varchar(80)
, ADD COLUMN IF NOT EXISTS ag96_owner_address varchar(80)
, ADD COLUMN IF NOT EXISTS ag96_owner_name varchar(40)
, ADD COLUMN IF NOT EXISTS ag96_label_number integer
, ADD COLUMN IF NOT EXISTS ag96_disposal_wastewater bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_industrial_wastewater bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_square_water bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_roof_water bigint
, ADD COLUMN IF NOT EXISTS ag96_population bigint;

COMMENT ON COLUMN tww_od.building_group.ag96_fk_provider IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_last_modification IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_remark IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_owner_address IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_owner_name IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_label_number IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_disposal_wastewater IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_disposal_industrial_wastewater IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_disposal_square_water IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_disposal_roof_water IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.building_group.ag96_population IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.building_group DROP CONSTRAINT IF EXISTS fkey_vl_building_group_ag96_disposal_wastewater CASCADE;
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_wastewater FOREIGN KEY (ag96_disposal_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group DROP CONSTRAINT IF EXISTS fkey_vl_building_group_ag96_disposal_industrial_wastewater CASCADE;
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_industrial_wastewater FOREIGN KEY (ag96_disposal_industrial_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group DROP CONSTRAINT IF EXISTS fkey_vl_building_group_ag96_disposal_square_water CASCADE;
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_square_water FOREIGN KEY (ag96_disposal_square_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group DROP CONSTRAINT IF EXISTS fkey_vl_building_group_ag96_disposal_roof_water CASCADE;
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_roof_water FOREIGN KEY (ag96_disposal_roof_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

 
ALTER TABLE tww_od.wastewater_networkelement
  ADD COLUMN IF NOT EXISTS ag96_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_GEP in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag96_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag96_remark varchar(80)
, ADD COLUMN IF NOT EXISTS ag64_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_wi in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag64_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag64_remark varchar(80);

ALTER TABLE tww_od.wastewater_networkelement DROP CONSTRAINT IF EXISTS ag96_rel_wastewater_networkelement_provider CASCADE;
ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT ag96_rel_wastewater_networkelement_provider FOREIGN KEY (ag96_fk_provider) REFERENCES tww_od.organisation(obj_id); 
ALTER TABLE tww_od.wastewater_networkelement DROP CONSTRAINT IF EXISTS ag64_rel_wastewater_networkelement_provider CASCADE;
ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT ag64_rel_wastewater_networkelement_provider FOREIGN KEY (ag64_fk_provider) REFERENCES tww_od.organisation(obj_id); 


ALTER TABLE tww_od.overflow
  ADD COLUMN IF NOT EXISTS ag96_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_GEP in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag96_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag96_remark varchar(80)
, ADD COLUMN IF NOT EXISTS ag64_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_wi in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag64_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag64_remark varchar(80);

ALTER TABLE tww_od.overflow DROP CONSTRAINT IF EXISTS ag64_rel_overflow_provider CASCADE;
ALTER TABLE tww_od.overflow ADD CONSTRAINT ag64_rel_overflow_provider FOREIGN KEY (ag64_fk_provider) REFERENCES tww_od.organisation(obj_id); 
ALTER TABLE tww_od.overflow DROP CONSTRAINT IF EXISTS ag96_rel_overflow_provider CASCADE;
ALTER TABLE tww_od.overflow ADD CONSTRAINT ag96_rel_overflow_provider FOREIGN KEY (ag96_fk_provider) REFERENCES tww_od.organisation(obj_id); 


ALTER TABLE tww_od.infiltration_zone
  ADD COLUMN IF NOT EXISTS ag96_permeability varchar(50) 	-- Durchlässigkeit
, ADD COLUMN IF NOT EXISTS ag96_limitation varchar(100) 	-- Einschränkung
, ADD COLUMN IF NOT EXISTS ag96_thickness varchar(50)		-- Mächtigkeit
, ADD COLUMN IF NOT EXISTS ag96_q_check character varying(50);
	
-- Rückfallebene für Knoten ohne Topologische Verknüpfung beim Import
CREATE TABLE IF NOT EXISTS tww_od.agxx_unconnected_node_bwrel (
	obj_id character varying(16),
	year_of_construction integer,
	structure_condition bigint,
	status bigint,
	co_level numeric(7,3),
    detail_geometry3d_geometry geometry(CurvePolygonZ,2056),
	financing bigint,
    ch_function_hierarchic bigint,
    status_survey_year integer,
    co_positional_accuracy bigint,
    renovation_necessity bigint,
    accessibility bigint,
    fk_operator varchar(16),
    fk_owner varchar(16),
    ag96_fk_measure varchar(16),
	CONSTRAINT pkey_od_agxx_unconnected_node_bwrel_obj_id PRIMARY KEY (obj_id));  
	
CREATE INDEX IF NOT EXISTS in_od_agxx_unconnected_node_bwrel_detail_geometry3d_geometry
    ON tww_od.agxx_unconnected_node_bwrel USING gist
    (detail_geometry3d_geometry)
    TABLESPACE pg_default;
	
CREATE TABLE IF NOT EXISTS tww_od.measure_text
(
    obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL DEFAULT tww_sys.generate_oid('tww_od'::text, 'measure_text'::text),
    classname text COLLATE pg_catalog."default",
    plantype integer,
    remark text COLLATE pg_catalog."default",
    text text COLLATE pg_catalog."default",
    texthali smallint,
    textori numeric(4,1),
    textpos_geometry geometry(Point,2056),
    textvali smallint,
    last_modification timestamp without time zone DEFAULT now(),
    fk_measure character varying(16) COLLATE pg_catalog."default",
    CONSTRAINT pkey_tww_od_measure_text_obj_id PRIMARY KEY (obj_id),
    CONSTRAINT fkey_vl_measure_text_plantype FOREIGN KEY (plantype)
        REFERENCES tww_vl.measure_text_plantype (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT fkey_vl_measure_text_texthali FOREIGN KEY (texthali)
        REFERENCES tww_vl.measure_text_texthali (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT fkey_vl_measure_text_textvali FOREIGN KEY (textvali)
        REFERENCES tww_vl.measure_text_textvali (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT rel_measure_text_measure FOREIGN KEY (fk_measure)
        REFERENCES tww_od.measure (obj_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT mx_classname_length_max_50 CHECK (char_length(classname) <= 50),
    CONSTRAINT mx_remark_length_max_80 CHECK (char_length(remark) <= 80)
)

TABLESPACE pg_default;
COMMENT ON TABLE tww_od.measure_text IS 'Extension for AG-96/ Erweiterung für AG-96 / Extension pour AG-96';


CREATE TABLE IF NOT EXISTS tww_od.building_group_text
(
    obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL DEFAULT tww_sys.generate_oid('tww_od'::text, 'building_group_text'::text),
    classname text COLLATE pg_catalog."default",
    plantype integer,
    remark text COLLATE pg_catalog."default",
    text text COLLATE pg_catalog."default",
    texthali smallint,
    textori numeric(4,1),
    textpos_geometry geometry(Point,2056),
    textvali smallint,
    last_modification timestamp without time zone DEFAULT now(),
    fk_building_group character varying(16) COLLATE pg_catalog."default",
    CONSTRAINT pkey_tww_od_building_group_text_obj_id PRIMARY KEY (obj_id),
    CONSTRAINT fkey_vl_building_group_text_plantype FOREIGN KEY (plantype)
        REFERENCES tww_vl.building_group_text_plantype (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT fkey_vl_building_group_text_texthali FOREIGN KEY (texthali)
        REFERENCES tww_vl.building_group_text_texthali (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT fkey_vl_building_group_text_textvali FOREIGN KEY (textvali)
        REFERENCES tww_vl.building_group_text_textvali (code) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT rel_building_group_text_building_group FOREIGN KEY (fk_building_group)
        REFERENCES tww_od.building_group (obj_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT gx_classname_length_max_50 CHECK (char_length(classname) <= 50),
    CONSTRAINT gx_remark_length_max_80 CHECK (char_length(remark) <= 80)
)

TABLESPACE pg_default;
COMMENT ON TABLE tww_od.building_group_text IS 'Extension for AG-96/ Erweiterung für AG-96 / Extension pour AG-96';

------------------
-- Organisation extension
------------------

-- 05.03.2024: Neuer OID-Prefix für Mapping durch Waldburger bestellt: ch24eax1

INSERT INTO tww_od.organisation(
	obj_id, identifier, remark, uid, last_modification, fk_dataowner, fk_provider,organisation_type,status,_local_extension)
	VALUES 
	('ch24eax100000000',  'AfU Aargau',  'bei Import AG-64/AG-96 generiert','CHE114809310', now(), 'ch24eax100000000','ch24eax100000000',8605,9047,TRUE),
	('ch24eax100000154', 'Gemeinde Wettingen', NULL, 'CHE115075438', '2016-02-05', 'ch24eax100000000', 'ch24eax100000000',8604,9047,TRUE),
	('ch24eax100000315', 'Avia Tanklager Beteiligungs AG, Mellingen', NULL, 'CHE102501414', '2017-09-29', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000333', 'Kernkraftwerk Leibstadt AG', 'für_AraKKW_Leibstadt', 'CHE101719293', '2017-10-30', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000335', 'Axpo Power AG', 'u.a. für Ara Beznau', 'CHE105781196', '2017-10-30', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000343', 'Recyclingcenter Freiamt AG', NULL, 'CHE102501414', '2018-11-28', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000348', 'PDAG-Fonds-Verein', 'Areal Königsfelden', 'CHE116398921', '2020-07-02', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE)
	ON CONFLICT DO NOTHING;
