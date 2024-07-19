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
  CONSTRAINT pkey_tww_is_oid_prefixes_id PRIMARY KEY (id ),
  CONSTRAINT chk_prefix_length CHECK (char_length(prefix) = 8)
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE tww_sys.oid_prefixes
  IS 'This table contains OID prefixes for different communities or organizations.';

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
  (id);

CREATE TABLE tww_od.oid_manager
(
  id serial NOT NULL,
  usr_name text NOT NULL,
  t_basket int NOT NULL
  CONSTRAINT pkey_tww_od_oid_manager_id PRIMARY KEY (id),
  CONSTRAINT uniq_tww_od_oid_manager_usr_name UNIQUE (usr_name),
  CONSTRAINT fkey_od_oid_manager_t_basket FOREIGN KEY (t_basket)
        REFERENCES tww_sys.oid_prefixes (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL;
);
COMMENT ON TABLE tww_sys.oid_prefixes
  IS 'This table contains OID prefixes for different communities or organizations.';

CREATE UNIQUE INDEX in_tww_oid_manager_usr_name
  ON tww_od.oid_manager
  USING btree
  (usr_name);

CREATE OR REPLACE FUNCTION tww_sys.generate_oid(schema_name text, table_name text)
  RETURNS text AS
$BODY$
DECLARE
  myrec_prefix record;
  myrec_shortcut record;
  myrec_seq record;
  basket int;
BEGIN
  
  SELECT t_basket INTO basket FROM tww_od.oid_manager WHERE usr_name=current_user;
  IF NOT FOUND THEN 
	SELECT id INTO STRICT basket FROM tww_sys.oid_prefixes WHERE active;

	INSERT INTO tww_od.oid_manager(usr_name,t_basket) VALUES (current_user,basket)
  END IF;
  
  -- first get the OID prefix
  BEGIN
      SELECT prefix::text INTO myrec_prefix FROM tww_sys.oid_prefixes WHERE id = basket;
  END;
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
