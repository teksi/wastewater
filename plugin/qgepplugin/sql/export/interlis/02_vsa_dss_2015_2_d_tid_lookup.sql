-- this file looks up the t_id for foreignkeys (OID) for the tables of the import/export schema with ili2pg.
-- questions regarding this function should be directed to Stefan Burckhardt stefan.burckhardt@sjib.ch
-- basis ist tid_lookup.sql
-- schema für export heisst vsa_dss_2015_2_d.
-- last update 18.11.2016 Stefan Burckhardt

-- function for looking up t_id
CREATE OR REPLACE FUNCTION vsa_dss_2015_2_d.tid_lookup(table_name text, obj_id_ref text)
  -- RETURNS text AS
  RETURNS integer AS
$BODY$
DECLARE
  tid_ref integer;
  -- newtid integer;
  -- myrec_prefix record;
  -- myrec_shortcut record;
  -- myrec_seq record;
BEGIN
  -- 9.3.2016 check whether obj_id_ref NOT IS NULL
  IF obj_id_ref IS NULL THEN
    tid_ref = NULL;
    RAISE NOTICE '[tid_lookup]: obj_id is NULL . tid_ref set NULL also';  -- Print newtid
  ELSE
      -- get tid_ref for foreignkey
      -- SELECT t_id INTO tid_ref FROM vsa_dss_2015_2_d.baseclass WHERE t_ili_tid = 'ch13p7mzOG000002';
      SELECT t_id INTO tid_ref FROM vsa_dss_2015_2_d.baseclass WHERE t_ili_tid = obj_id_ref;

      IF NOT FOUND THEN
      -- 13.2.2016 / 9.3.2016 improved error message
      -- RAISE EXCEPTION 'tid_ref for table % not found', table_name;
        RAISE NOTICE '[tid_lookup]: Corresponding to obj_id % ->',obj_id_ref;  -- Print newtid
        RAISE NOTICE 'tid_ref for table % not found', table_name;
        RAISE EXCEPTION 'Missing t_id in table baseclass';

      ELSE
         -- 12.1.2016
         -- 13.2.2016 comment out to speed up
         -- 9.3.2016 Hineis ergänzt mit OBJ_ID
         RAISE NOTICE '[tid_lookup]: Corresponding to obj_id % ->',obj_id_ref;  -- Print newtid
         RAISE NOTICE 'tid_ref is %', tid_ref;

      END IF;
  END IF;

  RETURN tid_ref;

END;
$BODY$
  -- 12.1.2016 geändert LANGUAGE plpgsql STABLE
  LANGUAGE plpgsql VOLATILE
  COST 100;
