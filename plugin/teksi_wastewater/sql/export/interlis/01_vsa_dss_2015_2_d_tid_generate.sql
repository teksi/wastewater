-- this file generates a new SQL function to create TIDs for all the tables of the import/export schema with ili2pg.
-- you need to set the current maxvalue of the TID into the schema.table.field vsa_dss_2015_2_d.t_key_object.t_lastuniqueid
-- questions regarding this function should be directed to Stefan Burckhardt stefan.burckhardt@sjib.ch
-- basis ist tid_generate.sql
-- schema für export heisst vsa_dss_2015_2_304


-- function for generating TIDs
CREATE OR REPLACE FUNCTION vsa_dss_2015_2_d.tid_generate(table_name text, obj_id_table text)
  -- RETURNS text AS
  RETURNS integer AS
$BODY$
DECLARE
  nexttid integer;
  newtid integer;
  -- myrec_prefix record;
  -- myrec_shortcut record;
  -- myrec_seq record;
BEGIN
  --get sequence for table
  -- SELECT nextval('qgep.seq_' || table_name || '_oid') AS seqval INTO myrec_seq;
  -- SELECT nextval('vsa_dss_2015_2_d.seq_' || table_name || '_tid') AS seqval INTO myrec_seq;
  -- 23.12.2015 SELECT t_lastuniqueid FROM vsa_dss_2015_2_d.t_key_object AS nexttid;
  SELECT t_lastuniqueid INTO nexttid FROM vsa_dss_2015_2_d.t_key_object;
  newtid = (nexttid + 1);

  -- 12.1.2016
  RAISE NOTICE 'newtid is %', newtid;  -- Print newtid
  RAISE NOTICE 'nexttid is %', nexttid;  -- Print nexttid

  -- adapt t_lastuniqueid in t_key_object
  UPDATE vsa_dss_2015_2_d.t_key_object
    SET t_lastuniqueid = newtid
        , t_user = current_user
        , t_createdate = current_timestamp
  WHERE t_lastuniqueid = nexttid;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'sequence for table % not found', table_name;
  ELSE
     RAISE NOTICE 't_key_object updated';
  END IF;
  -- RETURN myrec_prefix.prefix || myrec_shortcut.shortcut_en || to_char(myrec_seq.seqval,'FM000000');
  -- RETURN myrec_prefix.prefix || to_char(myrec_seq.seqval,'FM000000');
  RETURN newtid;



END;
$BODY$
  -- 12.1.2016 geändert LANGUAGE plpgsql STABLE
  LANGUAGE plpgsql VOLATILE
  COST 100;
