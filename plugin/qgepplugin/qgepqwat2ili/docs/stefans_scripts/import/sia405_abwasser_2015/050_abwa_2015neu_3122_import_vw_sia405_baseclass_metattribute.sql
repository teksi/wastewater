-- View: abwa_2015neu_3122.vw_sia405_baseclass_metaattribute

-- DROP VIEW abwa_2015neu_3122.vw_sia405_baseclass_metaattribute;

CREATE OR REPLACE VIEW abwa_2015neu_3122.vw_sia405_baseclass_metaattribute AS
 SELECT sia405_baseclass.t_id,
    sia405_baseclass.obj_id,
    metaattribute.datenherr,
    metaattribute.datenlieferant,
    metaattribute.letzte_aenderung
   FROM abwa_2015neu_3122.sia405_baseclass
     LEFT JOIN abwa_2015neu_3122.metaattribute ON sia405_baseclass.t_id = metaattribute.sia405_baseclass_metaattribute;

ALTER TABLE abwa_2015neu_3122.vw_sia405_baseclass_metaattribute
  OWNER TO postgres;
