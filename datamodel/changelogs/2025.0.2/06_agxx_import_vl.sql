
-----------------
-- Forward relations for import
-----------------

CREATE TABLE IF NOT EXISTS tww_vl.value_list_agxx_import_rel_base
(
    code integer NOT NULL,
    value_de character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT pkey_tww_value_list_agxx_import_rel_code PRIMARY KEY (code)
)
TABLESPACE pg_default;


CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_planned_import_rel_agxx
(CONSTRAINT pkey_catchment_area_drainage_system_planned_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.catchment_area_drainage_system_planned_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.catchment_area_drainage_system_planned
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_current_import_rel_agxx
(CONSTRAINT pkey_catchment_area_drainage_system_current_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.catchment_area_drainage_system_current_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.catchment_area_drainage_system_current
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.manhole_function_import_rel_agxx
(CONSTRAINT pkey_manhole_function_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.manhole_function_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.manhole_function
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.manhole_function_import_rel_agxx (code,value_de) VALUES
(8736,'Kontrollschacht'),
(8703,'Vorbehandlung')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.special_structure_function_import_rel_agxx
(CONSTRAINT pkey_special_structure_function_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.special_structure_function_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.special_structure_function
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.special_structure_function_import_rel_agxx (code,value_de) VALUES
(8739,'Kontrollschacht'),
(9089,'Vorbehandlung')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.infiltration_installation_kind_import_rel_agxx
(CONSTRAINT pkey_infiltration_installation_kind_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.infiltration_installation_kind_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.infiltration_installation_kind
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.infiltration_installation_kind_import_rel_agxx (code,value_de) VALUES
(276,'Versickerungsanlage.Versickerungsbecken'),
(277,'Versickerungsanlage.Kieskoerper'),
(278,'Versickerungsanlage.Versickerungsschacht'),
(3283,'Versickerungsanlage.Versickerungsstrang'),
(3284,'Versickerungsanlage.Versickerungsschacht_Strang'),
(1999965,'Versickerungsanlage.Retentionsfilterbecken'),
(1999966,'Versickerungsanlage.andere'),
(3087,'Versickerungsanlage.unbekannt')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.discharge_point_relevance_import_rel_agxx
(CONSTRAINT pkey_discharge_point_relevance_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;


-- alter 1:1 updated value_de
INSERT INTO tww_vl.discharge_point_relevance_import_rel_agxx (code,value_de) VALUES
(5080,'Einleitstelle.gewaesserrelevant'),
(5081,'Einleitstelle.nicht_gewaesserrelevant')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


-- bauwerkstatus
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_structure_status_import_rel_agxx
(CONSTRAINT pkey_wastewater_structure_status_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.wastewater_structure_status_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.wastewater_structure_status
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.wastewater_structure_status_import_rel_agxx (code,value_de) VALUES
(8493,'in_Betrieb.in_Betrieb')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_planned_import_rel_agxx
(CONSTRAINT pkey_channel_usage_planned_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.channel_usage_planned_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.channel_usage_planned
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.channel_usage_planned_import_rel_agxx (code,value_de) VALUES
(4523,'Mischwasser'),
(4515,'Fremdwasser'),
(9022,'Sauberwasser'),
(4519,'Gewaesser'),
(4517,'Entlastetes_Mischwasser'),
(4527,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_current_import_rel_agxx
(CONSTRAINT pkey_channel_usage_current_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.channel_usage_current_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.channel_usage_current
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.channel_usage_current_import_rel_agxx (code,value_de) VALUES
(4522,'Mischwasser'),
(4514,'Fremdwasser'),
(9023,'Sauberwasser'),
(4518,'Gewaesser'),
(4516,'Entlastetes_Mischwasser'),
(4526,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.measure_category_import_rel_agxx
(CONSTRAINT pkey_measure_category_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.measure_category_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.measure_category
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.measure_category_import_rel_agxx (code,value_de) VALUES
(8648,'Reinigung'),
(8649,'Retention'),
(8705,'Sonderbauwerk.Neubau')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.building_group_function_import_rel_agxx
(CONSTRAINT pkey_building_group_function_import_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_import_rel_base)
TABLESPACE pg_default;

-- Copy the base
INSERT INTO tww_vl.building_group_function_import_rel_agxx (code,value_de)
SELECT code,value_de FROM tww_vl.building_group_function
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- alter 1:1 updated value_de
INSERT INTO tww_vl.building_group_function_import_rel_agxx (code,value_de) VALUES
(4823,'andere'),
(4820,'Ferienhaus'),
(4821,'Gewerbegebiet'),
(4822,'Landwirtschaftsgebiet'),
(4819,'Wohnhaus')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;
