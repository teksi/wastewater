------ This file generates the VSA-DSS database (Modul VSA-DSS 2015) table qgep_od._planning_zone_kind  in en on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 03.07.2017 21:26:28
BEGIN;

-------
CREATE TABLE qgep_od._planning_zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_planning_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_planning_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od._planning_zone ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','planning_zone');
COMMENT ON COLUMN qgep_od._planning_zone.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od._planning_zone ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od._planning_zone.kind IS 'Type of planning zone / Art der Bauzone / Genre de zones à bâtir';
ALTER TABLE qgep_od._planning_zone ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_planning_zone_perimeter_geometry ON qgep_od._planning_zone USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od._planning_zone.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_planning_zone
BEFORE UPDATE OR INSERT ON
 qgep_od._planning_zone
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------

ALTER TABLE qgep_od._planning_zone ADD CONSTRAINT oorel_od_planning_zone_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE qgep_vl._planning_zone_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl._planning_zone_kind ADD CONSTRAINT pkey_qgep_vl_planning_zone_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2990,2990,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (31,31,'commercial_zone','Gewerbezone','zone_artisanale', 'zzz_Gewerbezone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (32,32,'industrial_zone','Industriezone','zone_industrielle', 'zzz_Industriezone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (30,30,'agricultural_zone','Landwirtschaftszone','zone_agricole', 'zzz_Landwirtschaftszone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3077,3077,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl._planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (29,29,'residential_zone','Wohnzone','zone_d_habitations', 'zzz_Wohnzone', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od._planning_zone ADD CONSTRAINT fkey_vl_planning_zone_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl._planning_zone_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
 
 COMMIT;
