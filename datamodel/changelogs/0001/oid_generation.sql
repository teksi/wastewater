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
