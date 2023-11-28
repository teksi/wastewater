-- View: sia405_abwasser_2015_2_d.vw_sia405_baseclass_metaattribute

-- DROP VIEW IF EXISTS sia405_abwasser_2015_2_d.vw_sia405_baseclass_metaattribute;

CREATE OR REPLACE VIEW sia405_abwasser_2015_2_d.vw_sia405_baseclass_metaattribute AS
 SELECT sia405_baseclass.t_id,
    sia405_baseclass.obj_id,
    metaattribute.datenherr,
    metaattribute.datenlieferant,
    metaattribute.letzte_aenderung
   FROM sia405_abwasser_2015_2_d.sia405_baseclass
     LEFT JOIN sia405_abwasser_2015_2_d.metaattribute ON sia405_baseclass.t_id = metaattribute.sia405_baseclass_metaattribute;

ALTER TABLE sia405_abwasser_2015_2_d.vw_sia405_baseclass_metaattribute
  OWNER TO postgres;
