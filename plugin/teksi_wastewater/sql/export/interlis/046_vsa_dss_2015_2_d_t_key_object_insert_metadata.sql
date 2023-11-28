-- 24.11.2016 auch create statement nötig, Tabelle fehlt in --createscript (an Eisenhut gemeldet)
-- Stefan Burckhardt

-- Table: vsadss2015_2_d_391.t_key_object

-- DROP TABLE vsadss2015_2_d_391.t_key_object;

CREATE TABLE vsa_dss_2015_2_d.t_key_object
(
  t_key character varying(30) NOT NULL,
  t_lastuniqueid integer NOT NULL,
  t_lastchange timestamp without time zone NOT NULL,
  t_createdate timestamp without time zone NOT NULL,
  t_user character varying(40) NOT NULL,
  CONSTRAINT t_key_object_pkey PRIMARY KEY (t_key)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE vsa_dss_2015_2_d.t_key_object
  OWNER TO postgres;

-- erster Eintrag in t_key_object

INSERT INTO vsa_dss_2015_2_d.t_key_object (t_key, t_lastuniqueid, t_lastchange,  t_createdate, t_user) VALUES ( 't_id',   0, current_timestamp, current_timestamp,  'postgres');
