-- neu 26.11.2016 Stefan Burckhardt / 4.7.2017 corrected
-- Updates data in vsa_dss_2015_2_d.t_ili2db_import_basket with last tid from t_key_object

-- Function: vsa_dss_2015_2_d.basket_update()

-- DROP FUNCTION vsa_dss_2015_2_d.basket_update();

CREATE OR REPLACE FUNCTION vsa_dss_2015_2_d.basket_update()
  RETURNS integer AS
$BODY$
DECLARE
  lasttid integer;
BEGIN
  --get sequence for table
  -- SELECT nextval('qgep.seq_' || table_name || '_oid') AS seqval INTO myrec_seq;
  -- SELECT nextval('sia405_abwasser_2015_2_d_301.seq_' || table_name || '_tid') AS seqval INTO myrec_seq;

  SELECT t_lastuniqueid INTO lasttid FROM vsa_dss_2015_2_d.t_key_object;


  -- 25.11.2016
  RAISE NOTICE '[basket_update]: lasttid is %', lasttid;  -- Print lasttid


  -- adapt t_lastuniqueid in t_key_object
  UPDATE vsa_dss_2015_2_d.t_ili2db_import_basket
    SET t_id = lasttid + 1
        , end_t_id = lasttid
        , objectcount = lasttid - 2
  WHERE import = 2;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'sequence for table basket_update not found - first data will be inserte';
	INSERT INTO vsa_dss_2015_d_391.t_ili2db_import_basket (t_id, import, basket,  objectcount, start_t_id, end_t_id) VALUES (lasttid + 1, 2, 3, lasttid - 2, 3, lasttid);

  ELSE
     RAISE NOTICE 't_ili2db_import_basket updated %', lasttid;
     -- SELECT setval (sia405_abwasser_2015_2_d_340.t_ili2db_seq, lasttid + 1);
  END IF;
  -- RETURN myrec_prefix.prefix || myrec_shortcut.shortcut_en || to_char(myrec_seq.seqval,'FM000000');
  -- RETURN myrec_prefix.prefix || to_char(myrec_seq.seqval,'FM000000');
  RETURN lasttid;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vsa_dss_2015_2_d.basket_update()
  OWNER TO postgres;
