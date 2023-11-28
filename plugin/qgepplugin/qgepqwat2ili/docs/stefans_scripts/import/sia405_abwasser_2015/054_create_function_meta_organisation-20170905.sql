-- Function: abwa_2015neu_3122.meta_organisation(bez text, objid text)
-- 3.6.2017 Stefan Burckhardt / extended with subclass 5.9.2017

-- Adds organisations that do not exist yet (e.g. because they are used as dataowner/datenherr or provider/datenlieferant) in class organisation
-- e.g. SELECT abwa_2015neu_3122.meta_organisation('VSA', 'ch080qwzOG000098', 'privat');
-- new parameter subclass - if

-- DROP FUNCTION abwa_2015neu_3122.meta_organisation(bez text, objid text)

CREATE OR REPLACE FUNCTION abwa_2015neu_3122.meta_organisation(bez text, objid text, subclass text)
  RETURNS integer AS
$BODY$
DECLARE
  datenherr_bezeichnung text;
  newtid integer;
  -- myrec_prefix record;
  -- myrec_shortcut record;
  -- myrec_seq record;
BEGIN
  --get sequence for table
  -- SELECT nextval('qgep.seq_' || table_name || '_oid') AS seqval INTO myrec_seq;
  -- SELECT nextval('abwa_2015neu_3122.seq_' || table_name || '_tid') AS seqval INTO myrec_seq;
  -- 23.12.2015 SELECT t_lastuniqueid FROM abwa_2015neu_3122.t_key_object AS nexttid;
  SELECT bezeichnung INTO datenherr_bezeichnung FROM abwa_2015neu_3122.organisation WHERE organisation.bezeichnung = bez;

  IF NOT FOUND THEN
      -- 13.2.2016 / 9.3.2016 improved error message
      -- RAISE EXCEPTION 'tid_ref for table % not found', table_name;
        RAISE NOTICE '[meta_organisation]: no organisation found with % ->',bez;
        RAISE NOTICE 'Creating new data in organisation ...';
        --- RAISE EXCEPTION 'Missing t_id in table baseclass';
	newtid = abwa_2015neu_3122.tid_generate('Organisation', objid);
	INSERT INTO abwa_2015neu_3122.baseclass (t_id, t_type) VALUES(newtid, 'Organisation');
        INSERT INTO abwa_2015neu_3122.sia405_baseclass (t_id, obj_id) VALUES(newtid, objid);
	INSERT INTO abwa_2015neu_3122.organisation (t_id, bezeichnung) VALUES(newtid, bez);

    RAISE NOTICE 'subclass = %', subclass;

    IF subclass = 'privat' THEN
        INSERT INTO abwa_2015neu_3122.privat (t_id, art) VALUES(newtid, 'Datenherr/Datenlieferant');
    ELSE
        IF subclass = 'kanton' THEN
            INSERT INTO abwa_2015neu_3122.kanton (t_id) VALUES(newtid);
        ELSE
            IF subclass = 'abwasserverband' THEN
                INSERT INTO abwa_2015neu_3122.abwasserverband (t_id) VALUES(newtid);
            ELSE
                IF subclass = 'amt' THEN
                    INSERT INTO abwa_2015neu_3122.amt (t_id) VALUES(newtid);
                ELSE
                    IF subclass = 'abwasserreinigungsanlage' THEN
                        INSERT INTO abwa_2015neu_3122.abwasserreinigungsanlage (t_id) VALUES(newtid);
                    ELSE
                        IF subclass = 'gemeinde' THEN
                            INSERT INTO abwa_2015neu_3122.gemeinde (t_id) VALUES(newtid);
                        ELSE
                            IF subclass = 'genossenschaft_korporation' THEN
                                INSERT INTO abwa_2015neu_3122.genossenschaft_korporation (t_id) VALUES(newtid);
                            ELSE
                                RAISE NOTICE 'no valid subclass( %) selected, added to subclass privat', subclass;
                                INSERT INTO abwa_2015neu_3122.privat (t_id, art) VALUES(newtid, 'Datenherr/Datenlieferant');
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    RAISE NOTICE 'New data in Organisation added with obj_id %', objid;

	UPDATE abwa_2015neu_3122.metaattribute SET datenherr = objid WHERE datenherr = bez;

	RAISE NOTICE 'Table Metaattribute: Datenherr updated with obj_id %', objid;

	UPDATE abwa_2015neu_3122.metaattribute SET datenlieferant = objid WHERE datenlieferant = bez;

	RAISE NOTICE 'Table Metaattribute: Datenlieferant updated with obj_id %', objid;

      ELSE
         -- 12.1.2016
         -- 13.2.2016 comment out to speed up
         -- 9.3.2016 Hineis ergänzt mit OBJ_ID
         -- 8.8.2017
         -- RAISE EXCEPTION '[meta_organisation]: Organisation already exists with %',bez;
         RAISE NOTICE '[meta_organisation]: Organisation already exists with %',bez;
         --- RAISE NOTICE 'tid_ref is %', tid_ref;
         --- 8.8.2017
            UPDATE abwa_2015neu_3122.metaattribute SET datenherr = objid WHERE datenherr = bez;
            RAISE NOTICE 'Table Metaattribute: Datenherr updated with obj_id %', objid;
            UPDATE abwa_2015neu_3122.metaattribute SET datenlieferant = objid WHERE datenlieferant = bez;
            RAISE NOTICE 'Table Metaattribute: Datenlieferant updated with obj_id %', objid;
      END IF;
RETURN newtid;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION abwa_2015neu_3122.meta_organisation(text, text, text)
  OWNER TO postgres;
