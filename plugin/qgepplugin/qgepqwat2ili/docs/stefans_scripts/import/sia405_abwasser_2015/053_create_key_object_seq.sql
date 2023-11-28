-- Function: abwa_2015neu_3122.t_key_object_seq()
-- 3.6.2017 Stefan Burckhardt

-- DROP FUNCTION abwa_2015neu_3122.abwa_2015neu_3122.t_key_object_seq()

CREATE OR REPLACE FUNCTION abwa_2015neu_3122.t_key_object_seq()
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
  newtid =  nextval('abwa_2015neu_3122.t_ili2db_seq');
  -- 23.12.2015 SELECT t_lastuniqueid FROM abwa_2015neu_3122.t_key_object AS nexttid;
  -- SELECT t_lastuniqueid INTO nexttid FROM abwa_2015neu_3122.t_key_object;
  --- nexttid = (newtid - 1);

  -- 12.1.2016
  RAISE NOTICE 'newtid is %', newtid;  -- Print newtid
  ---RAISE NOTICE 'nexttid is %', nexttid;  -- Print nexttid

  -- adapt t_lastuniqueid in t_key_object
  UPDATE abwa_2015neu_3122.t_key_object
    SET t_lastuniqueid = newtid
        , t_user = current_user
        , t_createdate = current_timestamp
        , t_lastchange = current_timestamp
  WHERE t_lastuniqueid = 0;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'sequence for table could not be added - set t_key_object.t_last_uniqueid = 0';
  ELSE
     RAISE NOTICE 't_key_object updated to latest sequence %', newtid;
  END IF;
  -- RETURN myrec_prefix.prefix || myrec_shortcut.shortcut_en || to_char(myrec_seq.seqval,'FM000000');
  -- RETURN myrec_prefix.prefix || to_char(myrec_seq.seqval,'FM000000');
  RETURN newtid;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION abwa_2015neu_3122.t_key_object_seq()
  OWNER TO postgres;
