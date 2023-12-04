--View: abwa_2015neu_3122.vw_organisation
-- DROP VIEW IF EXISTS qgep.vw_organisation;
CREATE OR REPLACE VIEW abwa_2015neu_3122.vw_organisation AS
  SELECT vw_sia405_baseclass_metaattribute.obj_id,
    vw_sia405_baseclass_metaattribute.datenherr,
    vw_sia405_baseclass_metaattribute.datenlieferant,
    vw_sia405_baseclass_metaattribute.letzte_aenderung,
    organisation.*
  FROM abwa_2015neu_3122.organisation
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON organisation.t_id::text = vw_sia405_baseclass_metaattribute.t_id::text;

ALTER TABLE abwa_2015neu_3122.vw_organisation
OWNER TO postgres;
