-- Alteration of changelog 2025.0.1/03_tww_db_dss.sql
ALTER TABLE tww_od.re_building_group_disposal
ALTER COLUMN id SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.re_maintenance_event_wastewater_structure
ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- Alteration of changelog 2025.0.2/07_tww_db_dss.sql
ALTER TABLE tww_od.agxx_wastewater_node
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_cover
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_wastewater_structure
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_reach
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_catchment_area_totals
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_wastewater_networkelement
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_overflow
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_infiltration_zone
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_reach_point
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

ALTER TABLE tww_od.agxx_last_modification
ALTER COLUMN uuid SET DEFAULT gen_random_uuid();

-- Remove extension / Alteration of changelog 2025.0.1/00_db_extensions.sql
-- DROP EXTENSION IF EXISTS "uuid-ossp";
/* This has been commented since it affects the whole DB
   With this delta, system will run on both pg 14+ version
   and pg<=13 with the extension uuid-ossp
   Users can still remove the extension manually if they want
*/