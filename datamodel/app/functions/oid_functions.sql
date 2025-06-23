-- function for generating StandardOIDs

CREATE OR REPLACE FUNCTION tww_app.generate_oid(schema_name text, table_name text)
  RETURNS text AS
$BODY$
DECLARE
  myrec_prefix record;
  myrec_shortcut record;
  myrec_seq record;
BEGIN
  -- first we have to get the OID prefix
  BEGIN
    SELECT prefix::text INTO myrec_prefix FROM tww_sys.oid_prefixes WHERE active = TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE EXCEPTION 'no active record found in table tww_sys.oid_prefixes';
        WHEN TOO_MANY_ROWS THEN
	   RAISE EXCEPTION 'more than one active records found in table tww_sys.oid_prefixes';
  END;
  -- test if prefix is of correct length
  IF char_length(myrec_prefix.prefix) != 8 THEN
    RAISE EXCEPTION 'character length of prefix must be 8';
  END IF;
  --get table 2char shortcut
  BEGIN
    SELECT shortcut_en INTO STRICT myrec_shortcut FROM tww_sys.dictionary_od_table WHERE tablename = table_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EXCEPTION 'dictionary entry for table % not found', table_name;
        WHEN TOO_MANY_ROWS THEN
            RAISE EXCEPTION 'dictonary entry for table % not unique', table_name;
  END;
  --get sequence for table
  EXECUTE format('SELECT nextval(''%1$I.seq_%2$I_oid'') AS seqval', schema_name, table_name) INTO myrec_seq;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'sequence for table % not found', table_name;
  END IF;
  RETURN myrec_prefix.prefix || myrec_shortcut.shortcut_en || to_char(myrec_seq.seqval,'FM000000');
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;

CREATE OR REPLACE FUNCTION tww_app.reset_od_seqval()
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE

tbl_name text;
rgx text;
BEGIN
	BEGIN
	   FOR tbl_name,rgx IN (
			SELECT dot.tablename,pfx.prefix||dot.shortcut_en
			FROM information_schema.sequences seq
			LEFT JOIN tww_sys.dictionary_od_table dot ON seq.sequence_name = 'seq_'||dot.tablename||'_oid'
			LEFT JOIN (SELECT prefix  FROM tww_sys.oid_prefixes WHERE active) pfx on True
			WHERE seq.sequence_schema = 'tww_od' AND dot.tablename IS NOT NULL) LOOP
				EXECUTE FORMAT('SELECT SETVAL(''tww_od.seq_%1$I_oid'',(SELECT max(seqs) FROM(
		SELECT RIGHT(obj_id, 6)::int as seqs FROM tww_od.%1$I WHERE  regexp_match(obj_id, ''%2$s\d{{6}}$'') IS NOT NULL
		UNION
		SELECT last_value as seqs FROM tww_od.seq_%1$I_oid)foo));',tbl_name,rgx);
	   END LOOP;
	END;
END;
$BODY$;

CREATE OR REPLACE FUNCTION tww_app.tr_reset_od_seqval()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    PERFORM tww_app.reset_od_seqval();
    RETURN NULL;
END;
$BODY$;

CREATE TRIGGER update_od_seqval_from_prefixes
    AFTER UPDATE
    ON tww_sys.oid_prefixes
    FOR EACH STATEMENT
    EXECUTE FUNCTION tww_app.tr_reset_od_seqval();
