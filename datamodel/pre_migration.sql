-- Auditing functions moved to app
DROP FUNCTION IF EXISTS tww_sys.if_modified_func() CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass, BOOLEAN, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass, BOOLEAN, BOOLEAN, text[]) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_view(regclass, BOOLEAN, text[], text[]) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.replay_event(integer) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.unaudit_table(regclass) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.unaudit_view(regclass) CASCADE;

-- revert #538
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN IF NOT EXISTS tww_symbology_inflow_prio bool DEFAULT false;
UPDATE tww_vl.channel_usage_current
SET tww_symbology_inflow_prio= true WHERE code =4516;

ALTER TABLE tww_vl.channel_function_hierarchic DROP COLUMN IF NOT EXISTS tww_symbology_inflow_prio;


-- Finally: Drop tww_app
DROP SCHEMA IF EXISTS tww_app CASCADE;