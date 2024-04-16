------ This file generates the VSA-DSS database (Modul VSA-DSS 2015) table dss15_aquifer (as it does not exist anymore in VSA-DSS 2020)  in en on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 22.02.2024 17:22:28
BEGIN;
------ CREATE SCHEMA tww;

-------
CREATE TABLE tww_od.dss15_aquifer
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_dss15_aquifer_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_dss15_aquifer_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.dss15_aquifer ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','dss15_aquifer');
COMMENT ON COLUMN tww_od.dss15_aquifer.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN average_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.dss15_aquifer.average_groundwater_level IS 'Average level of groundwater table / Höhe des mittleren Grundwasserspiegels / Niveau moyen de la nappe';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN tww_od.dss15_aquifer.identifier IS '';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN maximal_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.dss15_aquifer.maximal_groundwater_level IS 'Maximal level of ground water table / Maximale Lage des Grundwasserspiegels / Niveau maximal de la nappe';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN minimal_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.dss15_aquifer.minimal_groundwater_level IS 'Minimal level of groundwater table / Minimale Lage des Grundwasserspiegels / Niveau minimal de la nappe';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_od_dss15_aquifer_perimeter_geometry ON tww_od.dss15_aquifer USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.dss15_aquifer.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN tww_od.dss15_aquifer.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.dss15_aquifer.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.dss15_aquifer.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE tww_od.dss15_aquifer ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN tww_od.dss15_aquifer.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_dss15_aquifer
BEFORE UPDATE OR INSERT ON
 tww_od.dss15_aquifer
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------

/* ALTER TABLE tww_od.water_catchment ADD COLUMN fk_dss15_aquifer varchar (16);
ALTER TABLE tww_od.water_catchment ADD CONSTRAINT rel_water_catchment_dss15_aquifer FOREIGN KEY (fk_dss15_aquifer) REFERENCES tww_od.dss15_aquifer(obj_id) ON UPDATE CASCADE ON DELETE set null; */


ALTER TABLE tww_od.infiltration_installation ADD COLUMN fk_dss15_aquifer varchar (16);
ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT rel_infiltration_installation_dss15_aquifer FOREIGN KEY (fk_dss15_aquifer) REFERENCES tww_od.dss15_aquifer(obj_id) ON UPDATE CASCADE ON DELETE set null;


ALTER TABLE tww_od.dss15_aquifer ADD CONSTRAINT rel_od_dss15_aquifer_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.dss15_aquifer ADD CONSTRAINT rel_od_dss15_aquifer_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);


------ Indexes on identifiers

CREATE UNIQUE INDEX in_od_dss15_aquifer_identifier ON tww_od.dss15_aquifer USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);


COMMIT;
