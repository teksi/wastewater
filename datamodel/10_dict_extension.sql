DROP TABLE IF EXISTS tww_sys.dictionary_vw_field CASCADE;

CREATE TABLE tww_sys.dictionary_vw_field
(
  id serial NOT NULL,
  class_id integer,
  attribute_id integer,
  table_name character varying(80),
  field_name character varying(80),
  field_name_en character varying(80),
  field_name_de character varying(100),
  field_name_fr character varying(100),
  field_name_it character varying(100),
  field_name_ro character varying(100),
  field_description_en text,
  field_description_de text,
  field_description_fr text,
  field_description_it text,
  field_description_ro text,
  CONSTRAINT is_dictionary_vw_field_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

-- does not work - now role tww at this moment
-- ALTER TABLE tww_sys.dictionary_vw_field
--  OWNER TO tww;

-- Reach

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_reach',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
	field_name_ro,
    field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
      FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_reach'
    OR table_name = 'od_wastewater_networkelement'
  UNION SELECT
    class_id,
    attribute_id,
    'vw_reach',
    'rp_from_' || field_name,
    'rp_from_' || field_name_en,
    'hp_von_' || field_name_de,
    'tp_de_' || field_name_fr,
    field_name_it, -- TODO
	field_name_ro, -- TODO
    field_description_en, -- TODO
    field_description_de, -- TODO
    field_description_fr, -- TODO
    field_description_it, -- TODO
	field_description_ro -- TODO
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_reach_point'
  UNION SELECT
    class_id,
    attribute_id,
    'vw_reach',
    'rp_to_' || field_name,
    'rp_to_' || field_name_en,
    'hp_nach_' || field_name_de,
    'tp_a_' || field_name_fr,
    field_name_it, -- TODO
	field_name_ro, -- TODO
    field_description_en, -- TODO
    field_description_de, -- TODO
    field_description_fr, -- TODO
    field_description_it, -- TODO
	field_description_ro -- TODO
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_reach_point';

-- Manhole

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_manhole',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_manhole'
      OR table_name = 'od_wastewater_structure';


-- Special Structure

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_special_structure',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_special_structure'
      OR table_name = 'od_wastewater_structure';


-- Special Structure

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_channel',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_channel'
      OR table_name = 'od_wastewater_structure';

-- Discharge Point

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_discharge_point',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_discharge_point'
      OR table_name = 'od_wastewater_structure';


-- Wastewater Node

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_wastewater_node',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_wastewater_node'
      OR table_name = 'od_wastewater_networkelement';


-- Cover

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_cover',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
      WHERE table_name = 'od_cover'
      OR table_name = 'od_structure_part';


-- Access Aid

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_cover',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_access_aid'
      OR table_name = 'od_structure_part';


-- Benching

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_benching',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
    field_name_ro,
	field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
    WHERE table_name = 'od_benching'
      OR table_name = 'od_structure_part';


-- Dryweather Downspout

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_dryweather_downspout',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
	field_name_ro,
    field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
  WHERE table_name = 'od_dryweather_downspout'
  OR table_name = 'od_structure_part';


-- Dryweather Flume

INSERT INTO tww_sys.dictionary_vw_field (
  class_id,
  attribute_id,
  table_name,
  field_name,
  field_name_en,
  field_name_de,
  field_name_fr,
  field_name_it,
  field_name_ro,
  field_description_en,
  field_description_de,
  field_description_fr,
  field_description_it,
  field_description_ro
) SELECT
    class_id,
    attribute_id,
    'vw_dryweather_flume',
    field_name,
    field_name_en,
    field_name_de,
    field_name_fr,
    field_name_it,
	field_name_ro,
    field_description_en,
    field_description_de,
    field_description_fr,
    field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field
  WHERE table_name = 'od_dryweather_flume'
  OR table_name = 'od_structure_part';


CREATE VIEW tww_app.vw_dictionary_field AS
  SELECT *
    FROM tww_sys.dictionary_vw_field
  UNION SELECT
    id,
	class_id,
	attribute_id,
	table_name,
	field_name,
	field_name_en,
	field_name_de,
	field_name_fr,
	field_name_it,
	field_name_ro,
	field_description_en,
	field_description_de,
	field_description_fr,
	field_description_it,
	field_description_ro
    FROM tww_sys.dictionary_od_field;

-- does not work - now role tww at this moment
-- ALTER VIEW tww_app.vw_dictionary_field
--  OWNER TO tww;
