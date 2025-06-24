------------------
-- System tables
------------------
INSERT INTO tww_sys.dictionary_od_table (id, tablename, shortcut_en) VALUES
(2999998,'agxx_measure_text','MX'),
(2999999,'agxx_building_group_text','GX')
ON CONFLICT (id) DO UPDATE
SET tablename=EXCLUDED.tablename,
shortcut_en=EXCLUDED.shortcut_en;


-----------------------------
-- CREATE NEW EXTENSION VL --
-----------------------------
-- Ist_Schnittstelle
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag96_is_gateway
(CONSTRAINT pkey_tww_vl_wastewater_node_ag96_is_gateway PRIMARY KEY (code))
 INHERITS (tww_vl.value_list_base)
 TABLESPACE pg_default; --Werteliste

ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag96_is_gateway CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag96_is_gateway PRIMARY KEY (code);
INSERT INTO tww_vl.wastewater_node_ag96_is_gateway (code,vsacode,value_de,value_en,active) VALUES
(1999951,1999951,'Schnittstelle','gateway',true),
(1999950,1999950,'keine_Schnittstelle','no_gateway',true),
(1999949,1999949,'unbekannt','unknown',true)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-- FunktionAG Anschluss
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag64_function
(CONSTRAINT pkey_tww_vl_wastewater_node_ag64_function PRIMARY KEY (code))
INHERITS (tww_vl.value_list_base);

ALTER TABLE tww_vl.wastewater_node_ag64_function DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag64_function CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag64_function ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag64_function PRIMARY KEY (code);
INSERT INTO tww_vl.wastewater_node_ag64_function (code,vsacode,value_de,active) VALUES
(1999948,1999948,'Anschluss',true),
(1999933,1999933,'andere',true) -- für Zweitdeckel
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_ag96_disposal_type (CONSTRAINT pkey_tww_vl_building_group_ag96_disposal_type PRIMARY KEY (code)) INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_ag96_disposal_type DROP CONSTRAINT IF EXISTS pkey_tww_vl_building_group_ag96_disposal_type CASCADE;
ALTER TABLE tww_vl.building_group_ag96_disposal_type ADD CONSTRAINT pkey_tww_vl_building_group_ag96_disposal_type PRIMARY KEY (code);
INSERT INTO tww_vl.building_group_ag96_disposal_type (code,vsacode,value_de,value_en,active) VALUES
(1999964,1999964,'Ableitung_Verwertung','drainage',true),  -- kein VSA mapping
(1999963,1999963,'Klaereinrichtung_Speicherung','clearing_storing',true),  -- kein VSA mapping
(1999962,1999962,'keinBedarf','noDemand',true),  -- kein VSA mapping
(1999961,1999961,'pendent','pending',true)  -- kein VSA mapping
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_plantype (
    CONSTRAINT pkey_tww_vl_building_group_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_plantype
SELECT * FROM tww_vl.wastewater_structure_text_plantype
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_texthali (
    CONSTRAINT pkey_tww_vl_building_group_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_texthali
SELECT * FROM tww_vl.wastewater_structure_text_texthali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_textvali (
    CONSTRAINT pkey_tww_vl_building_group_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_textvali
SELECT * FROM tww_vl.wastewater_structure_text_textvali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_plantype (
    CONSTRAINT pkey_tww_vl_measure_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_plantype
SELECT * FROM tww_vl.wastewater_structure_text_plantype
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_texthali (
    CONSTRAINT pkey_tww_vl_measure_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_texthali
SELECT * FROM tww_vl.wastewater_structure_text_texthali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_textvali (
    CONSTRAINT pkey_tww_vl_measure_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_textvali
SELECT * FROM tww_vl.wastewater_structure_text_textvali
ON CONFLICT DO NOTHING;

-----------------------------
-- CREATE NEW EXTENSION OD --
-----------------------------

-- GEPKnoten
CREATE TABLE tww_od.agxx_wastewater_node
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_wastewater_node varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_wastewater_node_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_wastewater_node ADD COLUMN IF NOT EXISTS ag96_is_gateway bigint;
COMMENT ON COLUMN tww_od.agxx_wastewater_node.ag96_is_gateway IS 'Extension for AG-96/ Erweiterung aus AG-96, IstSchnittstelle /xxx_fr';
ALTER TABLE tww_od.agxx_wastewater_node ADD COLUMN IF NOT EXISTS ag64_function bigint;
COMMENT ON COLUMN tww_od.agxx_wastewater_node.ag64_function IS 'Extension for AG-96/ Erweiterung aus AG-96 zur Erfassung der Funktionag Anschluss /xxx_fr';

ALTER TABLE tww_od.agxx_wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.agxx_wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag64_function FOREIGN KEY (ag64_function) REFERENCES tww_vl.wastewater_node_ag64_function MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Link cover to GEPKnoten
CREATE TABLE tww_od.agxx_cover
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_cover varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_cover_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_cover FOREIGN KEY (fk_cover) REFERENCES tww_od.cover(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_cover ADD COLUMN IF NOT EXISTS ag64_fk_wastewater_node varchar(16);
ALTER TABLE tww_od.agxx_cover ADD CONSTRAINT rel_cover_wastewater_node FOREIGN KEY (ag64_fk_wastewater_node) REFERENCES tww_od.wastewater_node MATCH SIMPLE ON UPDATE CASCADE ON DELETE SET NULL;

-- 1:1 relation GEPMassnahme/GEPKnoten
CREATE TABLE tww_od.agxx_wastewater_structure
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_wastewater_structure varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_wastewater_structure_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_wastewater_structure ADD COLUMN IF NOT EXISTS ag96_fk_measure varchar(16);
ALTER TABLE tww_od.agxx_wastewater_structure ADD CONSTRAINT ag96_rel_wastewater_structure_measure FOREIGN KEY (ag96_fk_measure) REFERENCES tww_od.measure(obj_id) ON DELETE SET NULL;
COMMENT ON COLUMN tww_od.agxx_wastewater_structure.ag96_fk_measure IS 'Extension for AG-96/ Erweiterung aus AG-96, 1:n-Beziehung /xxx_fr';

-- GEPHaltung
CREATE TABLE tww_od.agxx_reach
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_reach varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_reach_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_reach FOREIGN KEY (fk_reach) REFERENCES tww_od.reach(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_reach ADD COLUMN IF NOT EXISTS ag96_clear_height_planned integer;
ALTER TABLE tww_od.agxx_reach ADD COLUMN IF NOT EXISTS ag96_clear_width_planned integer;

-- SBW_Einzugsgebiet
CREATE TABLE tww_od.agxx_catchment_area_totals
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_catchment_area_totals varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_catchment_area_totals_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_catchment_area_totals FOREIGN KEY (fk_catchment_area_totals) REFERENCES tww_od.catchment_area_totals(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_sewer_infiltration_water_dim  decimal(9,3);
COMMENT ON COLUMN tww_od.agxx_catchment_area_totals.ag96_sewer_infiltration_water_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.agxx_catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_waste_water_production_dim  decimal(9,3);
COMMENT ON COLUMN tww_od.agxx_catchment_area_totals.ag96_waste_water_production_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.agxx_catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_perimeter_geometry  geometry(MultiSurface,2056);
COMMENT ON COLUMN tww_od.agxx_catchment_area_totals.ag96_waste_water_production_dim IS 'Extension for AG-96/ Erweiterung aus AG-96 /xxx_fr';

-- Bauten Ausserhalb Baugebiet
CREATE TABLE tww_od.agxx_building_group
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_building_group varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_building_group_uuid PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_building_group FOREIGN KEY (fk_building_group) REFERENCES tww_od.building_group(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE tww_od.agxx_building_group
  ADD COLUMN IF NOT EXISTS ag96_owner_address varchar(80)
, ADD COLUMN IF NOT EXISTS ag96_owner_name varchar(40)
, ADD COLUMN IF NOT EXISTS ag96_label_number integer
, ADD COLUMN IF NOT EXISTS ag96_disposal_wastewater bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_industrial_wastewater bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_square_water bigint
, ADD COLUMN IF NOT EXISTS ag96_disposal_roof_water bigint
, ADD COLUMN IF NOT EXISTS ag96_population bigint;


ALTER TABLE tww_od.agxx_building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_wastewater FOREIGN KEY (ag96_disposal_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.agxx_building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_industrial_wastewater FOREIGN KEY (ag96_disposal_industrial_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.agxx_building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_square_water FOREIGN KEY (ag96_disposal_square_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.agxx_building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_roof_water FOREIGN KEY (ag96_disposal_roof_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

CREATE TABLE tww_od.agxx_wastewater_networkelement
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_wastewater_networkelement varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_wastewater_networkelement PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES tww_od.wastewater_networkelement(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_wastewater_networkelement
  ADD COLUMN IF NOT EXISTS ag96_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_GEP in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag96_remark varchar(80)
, ADD COLUMN IF NOT EXISTS ag64_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_wi in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag64_remark varchar(80);

ALTER TABLE tww_od.agxx_wastewater_networkelement ADD CONSTRAINT ag96_rel_wastewater_networkelement_provider FOREIGN KEY (ag96_fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.agxx_wastewater_networkelement ADD CONSTRAINT ag64_rel_wastewater_networkelement_provider FOREIGN KEY (ag64_fk_provider) REFERENCES tww_od.organisation(obj_id);

CREATE TABLE tww_od.agxx_overflow
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_overflow varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_overflow PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_overflow FOREIGN KEY (fk_overflow) REFERENCES tww_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_overflow
  ADD COLUMN IF NOT EXISTS ag96_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_GEP in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag96_remark varchar(80)
, ADD COLUMN IF NOT EXISTS ag64_fk_provider varchar(16) -- Verweis auf Datenbewirtschafter_wi in Organisationstabelle
, ADD COLUMN IF NOT EXISTS ag64_remark varchar(80);

ALTER TABLE tww_od.agxx_overflow ADD CONSTRAINT ag64_rel_overflow_provider FOREIGN KEY (ag64_fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.agxx_overflow ADD CONSTRAINT ag96_rel_overflow_provider FOREIGN KEY (ag96_fk_provider) REFERENCES tww_od.organisation(obj_id);

CREATE TABLE tww_od.agxx_infiltration_zone
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_infiltration_zone varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_infiltration_zone PRIMARY KEY (uuid),
   CONSTRAINT oorel_od_agxx_infiltration_zone FOREIGN KEY (fk_infiltration_zone) REFERENCES tww_od.infiltration_zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE tww_od.agxx_infiltration_zone
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

-- for existing AG-xx databases
ALTER TABLE IF EXISTS tww_od.measure_text
  RENAME TO agxx_measure_text;

CREATE TABLE IF NOT EXISTS tww_od.agxx_measure_text
(
    obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
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
COMMENT ON TABLE tww_od.agxx_measure_text IS 'Extension for AG-96/ Erweiterung für AG-96 / Extension pour AG-96';

-- for existing AG-xx databases
ALTER TABLE IF EXISTS tww_od.building_group_text
  RENAME TO agxx_building_group_text;

CREATE TABLE IF NOT EXISTS tww_od.agxx_building_group_text
(
    obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
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
COMMENT ON TABLE tww_od.agxx_building_group_text IS 'Extension for AG-96/ Erweiterung für AG-96 / Extension pour AG-96';

-- Move schema to keep existing data
ALTER TABLE IF EXISTS tww_cfg.agxx_last_modification_updater
SET SCHEMA tww_od;

-- For defining letzte_aenderung_wi/gep
CREATE TABLE IF NOT EXISTS tww_od.agxx_last_modification_updater(
	username varchar(200) PRIMARY KEY
	, ag_update_type varchar(4) NOT NULL
	, CONSTRAINT ag_update_type_valid CHECK (ag_update_type = ANY(ARRAY['None','WI','GEP','Both'])));

CREATE TABLE IF NOT EXISTS tww_od.agxx_last_modification
(
   uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
   fk_element varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_agxx_last_modification PRIMARY KEY (uuid)
  );
  -- No Constraint as it references both overflow and wastewater_networkelement
ALTER TABLE tww_od.agxx_last_modification
  ADD COLUMN IF NOT EXISTS ag96_last_modification TIMESTAMP without time zone DEFAULT now()
, ADD COLUMN IF NOT EXISTS ag64_last_modification TIMESTAMP without time zone DEFAULT now()

------------------
-- Organisation extensions
------------------

-- 05.03.2024: new OID-Prefix for Mapping: ch24eax1 (ordered by Waldburger Ingenieure AG)
-- 16.01.2025: New Dataset in Plugin to load additional Organisations
