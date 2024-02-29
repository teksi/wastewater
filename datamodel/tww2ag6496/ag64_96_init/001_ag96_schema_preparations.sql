CREATE SCHEMA IF NOT EXISTS {ext_schema};

GRANT ALL ON SCHEMA {ext_schema} TO postgres;

GRANT ALL ON SCHEMA {ext_schema} TO tww_user;

GRANT USAGE ON SCHEMA {ext_schema} TO tww_viewer;


ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA {ext_schema}
GRANT ALL ON TABLES TO tww_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA {ext_schema}
GRANT SELECT, TRIGGER, REFERENCES ON TABLES TO tww_viewer;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA {ext_schema}
GRANT ALL ON SEQUENCES TO tww_user;

-- Ist_Schnittstelle
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag96_is_gateway () INHERITS (tww_vl.value_list_base); --Werteliste
ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag96_is_gateway CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag96_is_gateway PRIMARY KEY (code);

-- Ist_Schnittstelle
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag64_function () INHERITS (tww_vl.value_list_base); --Werteliste
ALTER TABLE tww_vl.wastewater_node_ag64_function DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag64_function CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag64_function ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag64_function PRIMARY KEY (code);

ALTER TABLE tww_od.wastewater_node ADD COLUMN IF NOT EXISTS ag96_is_gateway bigint;
COMMENT ON COLUMN tww_od.wastewater_node.ag96_is_gateway IS 'xxx_en/ Erweiterung aus AG-96, IstSchnittstelle /xxx_fr';
ALTER TABLE tww_od.wastewater_node ADD COLUMN IF NOT EXISTS ag64_function bigint;
COMMENT ON COLUMN tww_od.wastewater_node.ag64_function IS 'xxx_en/ Erweiterung aus AG-96 zur Erfassung der Funktionag Anschluss /xxx_fr';

ALTER TABLE tww_od.wastewater_node DROP CONSTRAINT IF EXISTS fkey_vl_wastewater_node_ag96_is_gateway CASCADE;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.wastewater_node DROP CONSTRAINT IF EXISTS fkey_vl_wastewater_node_ag64_function CASCADE;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag64_function FOREIGN KEY (ag64_function) REFERENCES tww_vl.wastewater_node_ag64_function MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

ALTER TABLE tww_od.wastewater_structure ADD COLUMN IF NOT EXISTS ag96_fk_measure varchar(16); 
-- Topologische Verknüpfung Massnahme/Abwasserbauwerk
ALTER TABLE tww_od.wastewater_structure DROP CONSTRAINT IF EXISTS ag96_rel_wastewater_structure_measure;
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ag96_rel_wastewater_structure_measure FOREIGN KEY (ag96_fk_measure) REFERENCES tww_od.measure(obj_id) ON DELETE SET NULL; 
COMMENT ON COLUMN tww_od.wastewater_structure.ag96_fk_measure IS 'xxx_en/ Erweiterung aus AG-96, 1:n-Beziehung /xxx_fr';


-- Topologische Verknüpfung Haltung Ist und Soll
ALTER TABLE tww_od.reach ADD COLUMN IF NOT EXISTS ag96_clear_height_planned integer; 
ALTER TABLE tww_od.reach ADD COLUMN IF NOT EXISTS ag96_clear_width_planned integer; 
COMMENT ON COLUMN tww_od.reach.ag96_clear_height_planned IS 'xxx_en/ Erweiterung aus AG-96 /xxx_fr';
COMMENT ON COLUMN tww_od.reach.ag96_clear_width_planned IS 'xxx_en/ Erweiterung aus AG-96 /xxx_fr';

-- SBW_Einzugsgebiet.Fremdwasseranfall_geplant
ALTER TABLE tww_od.catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_sewer_infiltration_water_dim  decimal(9,3); 
COMMENT ON COLUMN tww_od.catchment_area_totals.ag96_sewer_infiltration_water_dim IS 'xxx_en/ Erweiterung aus AG-96 /xxx_fr';

ALTER TABLE tww_od.catchment_area_totals ADD COLUMN IF NOT EXISTS ag96_waste_water_production_dim  decimal(9,3); 
COMMENT ON COLUMN tww_od.catchment_area_totals.ag96_waste_water_production_dim IS 'xxx_en/ Erweiterung aus AG-96 /xxx_fr';


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
, ADD COLUMN IF NOT EXISTS ag96_population bigint
;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_ag96_disposal_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_ag96_disposal_type DROP CONSTRAINT IF EXISTS pkey_tww_vl_building_group_ag96_disposal_type CASCADE;
ALTER TABLE tww_vl.building_group_ag96_disposal_type ADD CONSTRAINT pkey_tww_vl_building_group_ag96_disposal_type PRIMARY KEY (code);

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


-- Value list mapping für Rückwärtsimport. Keine inheritance, da sonst pkey in value_list_base nicht eindeutig ist

CREATE TABLE IF NOT EXISTS {ext_schema}.vl_special_structure_function (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste
CREATE TABLE IF NOT EXISTS {ext_schema}.vl_manhole_function (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste
CREATE TABLE IF NOT EXISTS {ext_schema}.vl_infiltration_installation_kind (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste
CREATE TABLE IF NOT EXISTS {ext_schema}.vl_channel_usage_current (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste
CREATE TABLE IF NOT EXISTS {ext_schema}.vl_channel_usage_planned (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste
CREATE TABLE IF NOT EXISTS {ext_schema}.vl_building_group_function (code integer, value_agxx TEXT PRIMARY KEY); --Werteliste



-- 
CREATE TABLE IF NOT EXISTS {ext_schema}.vsadss_dataowner (
	onerow_id bool PRIMARY KEY DEFAULT true -- in Kombi mit Constraint verhindert der pkey, dass mehr als 1 Datenherr genutzt wird
	,obj_id varchar(16) NOT NULL
	, CONSTRAINT onerow_uni CHECK (onerow_id));

-- Funktion zum Mapping der Organisations-ID

CREATE OR REPLACE FUNCTION {ext_schema}.convert_organisationid_to_vsa(oid varchar)
RETURNS varchar(16)
AS 
$BODY$
BEGIN
	CASE 
	WHEN oid IS NULL THEN return oid;
	WHEN length(oid)=20 OR length(oid)=16 THEN
		return 'ch20p3q4'||right(oid,8);
	ELSE
		RAISE WARNING 'OID % has not the right length. Might cause errors downstream', oid;
		return 'ch20p3q4'||right(oid,8);
	END CASE;
END;
$BODY$
LANGUAGE plpgsql;


-- wird für Updates von letzte_aenderung_wi/gep genutzt
CREATE TABLE IF NOT EXISTS {ext_schema}.update_manager(
	username varchar(200) PRIMARY KEY
	, ag_update_type varchar(3) NOT NULL
	, CONSTRAINT ag_update_type_valid CHECK (ag_update_type = ANY(ARRAY['wi','gep'])));
	
	
-- Rückfallebene für Leitungsknoten ohne Topologie beim Import
CREATE TABLE IF NOT EXISTS {ext_schema}.od_unconnected_node_bwrel (
	obj_id character varying(16),
	baujahr integer,
	baulicherzustand varchar(100),
	bauwerkstatus varchar(100),
	deckelkote numeric(7,3),
    detailgeometrie2d geometry(CurvePolygon,2056),
	finanzierung varchar(100),
    funktionhierarchisch varchar(3),
    jahr_zustandserhebung integer,
    lagegenauigkeit varchar(100),
    sanierungsbedarf varchar(100),
    zugaenglichkeit varchar(100),
    betreiber varchar(20),
    eigentuemer varchar(20),
    gepmassnahmeref varchar(16),
	CONSTRAINT pkey_{ext_schema}_od_unconnected_node_bwrel_obj_id PRIMARY KEY (obj_id)); --Werteliste
	
CREATE INDEX IF NOT EXISTS in_{ext_schema}_od_unconnected_node_bwrel_detailgeometrie2d
    ON {ext_schema}.od_unconnected_node_bwrel USING gist
    (detailgeometrie2d)
    TABLESPACE pg_default;
	
ALTER TABLE tww_od.organisation DISABLE TRIGGER update_last_modified_organisation;

CREATE OR REPLACE FUNCTION {ext_schema}.generate_oid_prefix_and_schema(table_name text)
 RETURNS text AS
$BODY$
DECLARE
  myrec_prefix record;
  myrec_shortcut record;
BEGIN
  -- first we have to get the OID prefix
  BEGIN
    SELECT prefix::text INTO myrec_prefix FROM tww_sys.oid_prefixes WHERE active = TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE EXCEPTION 'no active record found in table tww_sys.oid_prefixes';
        WHEN TOO_MANY_ROWS THEN
	   RAISE EXCEPTION 'more than one active records found in table tww_sys.oid_prefixes';
  END;
  -- test if prefix is of correct length
  IF char_length(myrec_prefix.prefix) != 8 THEN
    RAISE EXCEPTION 'character length of prefix must be 8';
  END IF;
  --get table 2char shortcut
  BEGIN
    SELECT shortcut_en INTO STRICT myrec_shortcut FROM tww_sys.dictionary_od_table WHERE tablename = table_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EXCEPTION 'dictionary entry for table % not found', table_name;
        WHEN TOO_MANY_ROWS THEN
            RAISE EXCEPTION 'dictonary entry for table % not unique', table_name;
  END;
  RETURN myrec_prefix.prefix || myrec_shortcut.shortcut_en;
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;

-- Textcontainer für Import
CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_plantype (
    CONSTRAINT pkey_tww_vl_building_group_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_texthali (
    CONSTRAINT pkey_tww_vl_building_group_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_textvali (
    CONSTRAINT pkey_tww_vl_building_group_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_plantype (
    CONSTRAINT pkey_tww_vl_measure_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_texthali (
    CONSTRAINT pkey_tww_vl_measure_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_textvali (
    CONSTRAINT pkey_tww_vl_measure_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
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
