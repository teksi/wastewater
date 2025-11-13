------ This file generates the delta file for adding description and display attributes to all value list tables for VSA-DSS database in en for QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 07.07.2025 18:10:38

ALTER TABLE tww_vl.value_list_base
ADD COLUMN IF NOT EXISTS description_en text,
ADD COLUMN IF NOT EXISTS description_de text,
ADD COLUMN IF NOT EXISTS description_fr text,
ADD COLUMN IF NOT EXISTS description_it text,
ADD COLUMN IF NOT EXISTS description_ro text,
ADD COLUMN IF NOT EXISTS display_en character varying(100),
ADD COLUMN IF NOT EXISTS display_de character varying(100),
ADD COLUMN IF NOT EXISTS display_fr character varying(100),
ADD COLUMN IF NOT EXISTS display_it character varying(100),
ADD COLUMN IF NOT EXISTS display_ro character varying(100);
