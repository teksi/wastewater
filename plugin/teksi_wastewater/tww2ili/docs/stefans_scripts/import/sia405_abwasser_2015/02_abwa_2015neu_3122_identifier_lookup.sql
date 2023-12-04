-- this file looks up the obj_id for identifiers of table organisation in schema with ili2pg. Can be used to replace datenherr, datenlieferant from INTERLIS that are text of identifier to be replace by obj_id of that organisation e.g datenherr = 'VSA'. Needs entries of organisations of datenherr / datenlieferant in table organisation to get a valid lookup of identifer -> obj_id.

-- questions regarding this function should be directed to Stefan Burckhardt stefan.burckhardt@sjib.ch
-- schema für export heisst abwa_2015neu_3122.
-- last update 3.3.2019 Stefan Burckhardt
-- -- select abwa_2015neu_3122.obj_id_identifer_organisation_lookup('unbekannt');


-- function for looking up obj_id
CREATE OR REPLACE FUNCTION abwa_2015neu_3122.obj_id_identifer_organisation_lookup(identifier_ref text)
  -- RETURNS text AS
  RETURNS text AS
$BODY$
DECLARE
  objid_ref text;

BEGIN

  -- 3.2.2017 check whether obj_id_ref NOT IS NULL
  IF identifier_ref IS NULL THEN
    objid_ref = NULL;
    RAISE NOTICE '[obj_id_identifer_organisation_lookup]: identifier is NULL . objid_ref set NULL also';  -- Print identifier
  -- to do option check ob identifier eine obj_id ist
  ELSE
      -- RAISE NOTICE '[obj_id_identifer_organisation_lookup]: identifier % ->',identifier_ref;  -- Print identifier
      -- get objid_ref for t_id
      -- needs vw_organisation as
      -- SELECT obj_id, bezeichnung, bemerkung, uid, Letzte_Aenderung, Datenherr, datenlieferant FROM abwa_2015neu_3122.organisation     LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.organisation.t_id = vw_sia405_baseclass_metaattribute.t_id ;
      SELECT obj_id INTO objid_ref FROM abwa_2015neu_3122.vw_organisation WHERE bezeichnung = identifier_ref;


      IF NOT FOUND THEN
        RAISE NOTICE '[obj_id_identifer_organisation_lookup]: Corresponding to identifier %',identifier_ref;  -- Print identifier
        RAISE NOTICE 'obj_id_ref for organisation not found. Keeping identifier as is!';
        -- RAISE EXCEPTION 'Missing obj_id in table organisation';
        objid_ref = identifier_ref;
      ELSE
         -- 3.2.2017 comment out to speed up
         RAISE NOTICE '[obj_id_identifer_organisation_lookup]: 2Corresponding to identifier %',identifier_ref;  -- Print identifier
         RAISE NOTICE 'obj_id is %', objid_ref;

      END IF;
  END IF;

  RETURN objid_ref;

END;
$BODY$
  -- 3.2.2017 geändert LANGUAGE plpgsql STABLE
  LANGUAGE plpgsql VOLATILE
  COST 100;
