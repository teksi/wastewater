-- this file generates a new SQL function to create INTERLIS STANDARDOID's for all the tww_od.* tables.
-- you need to add entries for your organizations into the table tww_sys.oid_prefixes
-- questions regarding this function should be directed to Arnaud Poncet, Pully
-- Adapted for TEKSI VSA-DSS 2020 Stefan Burckhardt

CREATE TABLE tww_sys.oid_prefixes
(
  id serial NOT NULL,
  prefix character(8),
  organization text,
  active boolean,
  CONSTRAINT pkey_tww_is_oid_prefixes_id PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE tww_sys.oid_prefixes
  IS 'This table contains OID prefixes for different communities or organizations. The application or administrator changing this table has to make sure that only one record is set to active.';

-- sample entry for Invalid - you need to adapt this entry later for your own organization
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch000000','Invalid',TRUE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch11h8mw','Stadt Uster',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch15z36d','SIGE',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch13p7mz','Arbon',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch176dc9','Sigip',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch17f516','Prilly',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch17nq5g','Triform',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch2003p6','Vevey',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch238z74','La Tour-de-Peilz',FALSE);
INSERT INTO tww_sys.oid_prefixes (prefix,organization,active) VALUES ('ch234hqx','BTI',FALSE);

CREATE INDEX in_tww_is_oid_prefixes_active
  ON tww_sys.oid_prefixes
  USING btree
  (active );

CREATE UNIQUE INDEX in_tww_is_oid_prefixes_id
  ON tww_sys.oid_prefixes
  USING btree
  (id );

-- function for generating StandardOIDs

CREATE OR REPLACE FUNCTION tww_sys.generate_oid(schema_name text, table_name text)
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

CREATE OR REPLACE FUNCTION tww_sys.reset_od_seqval()
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
		SELECT RIGHT(obj_id, 6)::int as seqs FROM tww_od.%1$I WHERE  regexp_match(obj_id, ''%2$s\d{6}$'') IS NOT NULL
		UNION
		SELECT last_value as seqs FROM tww_od.seq_%1$I_oid)foo));',tbl_name,rgx);
	   END LOOP;
	END; 
END;
$BODY$;

CREATE OR REPLACE FUNCTION tww_sys.tr_reset_od_seqval()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    PERFORM tww_sys.reset_od_seqval();
    RETURN NULL;
END;
$BODY$;

CREATE TRIGGER update_od_seqval_from_prefixes
    AFTER UPDATE 
    ON tww_sys.oid_prefixes
    FOR EACH STATEMENT
    EXECUTE FUNCTION tww_sys.tr_reset_od_seqval();