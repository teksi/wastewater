-- neu 22.11.2016 fehlt mit --createscript in schema

-- Schema: vsa_dss_2015_2_d.

-- DROP SCHEMA vsa_dss_2015_2_304 CASCADE;

CREATE SEQUENCE vsa_dss_2015_2_d.t_ili2db_seq
increment 1
minValue 1
maxValue 9223372036854775807
start 1
cache 1;


ALTER TABLE vsa_dss_2015_2_d.t_ili2db_seq
  OWNER TO postgres;
