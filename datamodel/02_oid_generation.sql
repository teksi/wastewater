-- this file generates a new SQL function to create StandardOIDs for all the qgep_od.* tables.
-- you need to add entries for your organizations into the table qgep_sys.oid_prefixes
-- questions regarding this function should be directed to Andreas Neumann, Stadt Uster

CREATE TABLE qgep_sys.oid_prefixes
(
  id serial NOT NULL,
  prefix character(8),
  organization text,
  active boolean,
  CONSTRAINT pkey_qgep_is_oid_prefixes_id PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE qgep_sys.oid_prefixes
  IS 'This table contains OID prefixes for different communities or organizations. The application or administrator changing this table has to make sure that only one record is set to active.';

-- sample entry for Invalid - you need to adapt this entry later for your own organization
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('00000000','Invalid',TRUE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch11h8mw','Stadt Uster',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch15z36d','SIGE',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch13p7mz','Arbon',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch176dc9','Sigip',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch17f516','Prilly',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch17nq5g','Triform',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch2003p6','Vevey',FALSE);
INSERT INTO qgep_sys.oid_prefixes (prefix,organization,active) VALUES ('ch238z74','La Tour-de-Peilz',FALSE);

CREATE INDEX in_qgep_is_oid_prefixes_active
  ON qgep_sys.oid_prefixes
  USING btree
  (active );

CREATE UNIQUE INDEX in_qgep_is_oid_prefixes_id
  ON qgep_sys.oid_prefixes
  USING btree
  (id );

-- function for generating StandardOIDs

CREATE OR REPLACE FUNCTION qgep_sys.generate_oid(schema_name text, table_name text)
  RETURNS text AS
$BODY$
DECLARE
  myrec_prefix record;
  myrec_shortcut record;
  myrec_seq record;
BEGIN
  -- first we have to get the OID prefix
  BEGIN
    SELECT prefix::text INTO myrec_prefix FROM qgep_sys.oid_prefixes WHERE active = TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE EXCEPTION 'no active record found in table qgep_sys.oid_prefixes';
        WHEN TOO_MANY_ROWS THEN
	   RAISE EXCEPTION 'more than one active records found in table qgep_sys.oid_prefixes';
  END;
  -- test if prefix is of correct length
  IF char_length(myrec_prefix.prefix) != 8 THEN
    RAISE EXCEPTION 'character length of prefix must be 8';
  END IF;
  --get table 2char shortcut
  BEGIN
    SELECT shortcut_en INTO STRICT myrec_shortcut FROM qgep_sys.dictionary_od_table WHERE tablename = table_name;
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
