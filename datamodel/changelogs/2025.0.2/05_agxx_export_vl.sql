-----------------
-- Backward relations for ag-xx export
-----------------

CREATE TABLE IF NOT EXISTS tww_vl.value_list_agxx_export_rel_base
(
    code integer NOT NULL,
    value_de character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT pkey_tww_value_list_agxx_export_rel_code PRIMARY KEY (code)
)
TABLESPACE pg_default;


CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_planned_export_rel_agxx
(CONSTRAINT pkey_catchment_area_drainage_system_planned_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.catchment_area_drainage_system_planned_export_rel_agxx (code,value_de) VALUES
(5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser'),
(8692,'Trennsystem'),
(9067,'unbekannt')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_current_export_rel_agxx
(CONSTRAINT pkey_catchment_area_drainage_system_current_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;;

INSERT INTO tww_vl.catchment_area_drainage_system_current_export_rel_agxx (code,value_de) VALUES
(5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser'),
(8693,'Trennsystem'),
(9068,'unbekannt')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;
  
  
CREATE TABLE IF NOT EXISTS tww_vl.manhole_function_export_rel_agxx
(CONSTRAINT pkey_manhole_function_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.manhole_function_export_rel_agxx (code,value_de) VALUES
(8828,'Entwaesserungsrinne'),
(8601,'Schwimmstoffabscheider'),
(8654,'Kontrollschacht'),
(8702,'Vorbehandlung'),
(8736,'Kontrollschacht'),
(8703,'Vorbehandlung')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.special_structure_function_export_rel_agxx
(CONSTRAINT pkey_special_structure_function_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.special_structure_function_export_rel_agxx (code,value_de) VALUES
(8704,'Strassenwasserbehandlungsanlage'), -- Behandlungsanlage
(8600,'andere'),  -- Fettabscheider
(8657,'andere'), --Havariebecken
(9302,'Kontrollschacht'), --Kombischacht
(8739,'Kontrollschacht'), -- Kontroll-Einstiegschacht
(9089,'Vorbehandlung') -- Vorbehandlungsanlage
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.infiltration_installation_kind_export_rel_agxx
(CONSTRAINT pkey_infiltration_installation_kind_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.infiltration_installation_kind_export_rel_agxx (code,value_de) VALUES
(3279,'andere'),
(3280,'andere'),
(3281,'andere'),
(3282,'andere'),
--(3283,'Versickerungsstrang'),
--(3284,'Versickerungsschacht_Strang'),
(3285,'andere')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;



CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_current_export_rel_agxx
(CONSTRAINT pkey_channel_usage_current_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.channel_usage_current_export_rel_agxx (code,value_de) VALUES
(4522,'Mischwasser'),
(4514,'Fremdwasser'),
(9023,'Sauberwasser'),
(4518,'Gewaesser'),
(4516,'Entlastetes_Mischwasser'),
(4526,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

-- DSS-Nutzungsarten werden nur rückwärts gematcht, damit die Visualisierungen übernommen werden können
CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_planned_export_rel_agxx
(CONSTRAINT pkey_channel_usage_planned_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.channel_usage_planned_export_rel_agxx (code,value_de) VALUES
(4523,'Mischwasser'),
(4515,'Fremdwasser'),
(9022,'Sauberwasser'),
(4519,'Gewaesser'),
(4517,'Entlastetes_Mischwasser'),
(4527,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.measure_category_export_rel_agxx
(CONSTRAINT pkey_measure_category_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.measure_category_export_rel_agxx (code,value_de) VALUES
(9144,'andere'),
(8706,'andere'),
(8648,'Reinigung'),
(8646,'Renovierung'),
(8647,'andere'),
(4662,'Untersuchung.unbekannt'),
(8639,'Bachsanierung'),
(8649,'Retention'),
(8707,'Sonderbauwerk.Anpassung_hydraulisch'),
(8705,'Sonderbauwerk.Neubau')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

CREATE TABLE IF NOT EXISTS tww_vl.measure_priority_export_rel_agxx
(CONSTRAINT pkey_measure_priority_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.measure_priority_export_rel_agxx (code,value_de) VALUES
(4763,'unbekannt')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


CREATE TABLE IF NOT EXISTS tww_vl.infiltration_zone_infiltration_capacity_export_rel_agxx
(CONSTRAINT pkey_infiltration_zone_infiltration_capacity_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.infiltration_zone_infiltration_capacity_export_rel_agxx (code,value_de) VALUES
(371,'gut.Anlagenwahl_nicht_eingeschraenkt'),
(372,'mittel.Anlagenwahl_nicht_eingeschraenkt')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

/*
Bautenausserhalbbaugebiet für Export nicht 100% matchbar
CREATE TABLE IF NOT EXISTS tww_vl.building_group_renovation_necessity_export_rel_agxx
(CONSTRAINT pkey_building_group_renovation_necessity_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.building_group_renovation_necessity_export_rel_agxx (code,value_de) VALUES
  (8799,NULL) -- unbekannt, kann nicht auf Ja oder Nein gemappt werden
ON CONFLICT DO NOTHING;*/



CREATE TABLE IF NOT EXISTS tww_vl.building_group_function_export_rel_agxx
(CONSTRAINT pkey_building_group_function_export_rel_agxx_code PRIMARY KEY (code))
INHERITS (tww_vl.value_list_agxx_export_rel_base)
TABLESPACE pg_default;

INSERT INTO tww_vl.building_group_function_export_rel_agxx (code,value_de) VALUES
(4823,'andere'),
(4820,'Ferienhaus'),
(4821,'Gewerbegebiet'),
(4822,'Landwirtschaftsgebiet'),
(4818,'andere'),
(4819,'Wohnhaus')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;


