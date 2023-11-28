-- this file looks up the obj_id for foreignkeys (OID) for the tables of the import/export schema with ili2pg.
-- questions regarding this function should be directed to Stefan Burckhardt stefan.burckhardt@sjib.ch
-- basis ist tid_lookup.sql
-- schema für export heisst abwa_2015neu_3122.
-- last update 3.2.2017 / 9.10.2018 Stefan Burckhardt

-- function for looking up obj_id
CREATE OR REPLACE FUNCTION abwa_2015neu_3122.objid_lookup(table_name text, tid_ref integer)
  -- RETURNS text AS
  RETURNS text AS
$BODY$
DECLARE
  objid_ref text;

BEGIN
  -- 3.2.2017 check whether obj_id_ref NOT IS NULL
  IF tid_ref IS NULL THEN
    objid_ref = NULL;
    RAISE NOTICE '[objid_lookup]: tid is NULL . objid_ref set NULL also';  -- Print newtid
  ELSE
      -- get objid_ref for t_id
      -- SELECT t_id INTO tid_ref FROM abwa_2015neu_3122.baseclass WHERE t_ili_tid = 'ch13p7mzOG000002';
      SELECT obj_id INTO objid_ref FROM abwa_2015neu_3122.sia405_baseclass WHERE t_id = tid_ref;

      IF NOT FOUND THEN
        RAISE NOTICE '[objid_lookup]: Corresponding to t_id % ->',tid_ref;  -- Print newtid
        RAISE NOTICE 'tid_ref for table % not found', table_name;
        RAISE EXCEPTION 'Missing obj_id in table sia405_baseclass';

      ELSE
         -- 3.2.2017 comment out to speed up
         RAISE NOTICE '[tid_lookup]: Corresponding to t_id % ->',tid_ref;  -- Print newtid
         RAISE NOTICE 'obj_id is %', objid_ref;

      END IF;
  END IF;

  RETURN objid_ref;

END;
$BODY$
  -- 3.2.2017 geändert LANGUAGE plpgsql STABLE
  LANGUAGE plpgsql VOLATILE
  COST 100;
