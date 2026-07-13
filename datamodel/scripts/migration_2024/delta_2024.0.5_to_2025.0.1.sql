-- Delta: TEKSI wastewater 2024.0.5 (release, pre-pum) -> 2025.0.1 (pum baseline)
--
-- This script aligns a database created from the 2024.0.5 release with the
-- state produced by the 2025.0.1 pum changelog (datamodel/changelogs/2025.0.1),
-- so that 'pum baseline -b 2025.0.1' followed by 'pum upgrade' is valid.
--
-- Prerequisites:
--   * the tww_app and tww_app_pg2ili schemas have been dropped
--     (they are recreated by pum after the upgrade)
--   * the tww_sys.pum_migrations table is created afterwards by
--     'pum baseline --create-table -b 2025.0.1'
--
-- This file is curated from the 'pum check' report produced by the
-- 'build-delta' command of the migration image (see entrypoint.sh) and
-- verified against a fresh 'pum install --max-version 2025.0.1'.
--
-- Note: the value list (tww_vl) *data* is synchronized separately by
-- sync_vl.py (structure comparison does not cover row contents).

BEGIN;

-- =========================================================================
-- Old auditing functions (moved to the recreatable tww_app schema)
-- Same drops as changelogs/2025.0.2/40_cleanup_changes_from_before_pum.sql,
-- which stays a no-op afterwards.
-- =========================================================================
DROP FUNCTION IF EXISTS tww_sys.if_modified_func() CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass, BOOLEAN, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_table(regclass, BOOLEAN, BOOLEAN, text[]) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.audit_view(regclass, BOOLEAN, text[], text[]) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.replay_event(integer) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.unaudit_table(regclass) CASCADE;
DROP FUNCTION IF EXISTS tww_sys.unaudit_view(regclass) CASCADE;

-- =========================================================================
-- Symbology inflow priority flag moved from channel_function_hierarchic
-- to channel_usage_current (revert of #538, cf. same cleanup changelog)
-- =========================================================================
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN IF NOT EXISTS tww_symbology_inflow_prio bool DEFAULT false;
UPDATE tww_vl.channel_usage_current SET tww_symbology_inflow_prio = true WHERE code = 4516;
ALTER TABLE tww_vl.channel_function_hierarchic DROP COLUMN IF EXISTS tww_symbology_inflow_prio;

-- =========================================================================
-- uuid defaults: uuid-ossp replaced by core gen_random_uuid()
-- =========================================================================
ALTER TABLE tww_od.re_maintenance_event_wastewater_structure ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE tww_od.re_building_group_disposal ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- =========================================================================
-- Main wastewater node FK is deferrable in 2025.0.1
-- =========================================================================
ALTER TABLE tww_od.wastewater_structure DROP CONSTRAINT rel_wastewater_structure_main_wastewater_node;
ALTER TABLE tww_od.wastewater_structure
    ADD CONSTRAINT rel_wastewater_structure_main_wastewater_node
    FOREIGN KEY (fk_main_wastewater_node) REFERENCES tww_od.wastewater_node (obj_id)
    ON UPDATE CASCADE ON DELETE SET NULL
    DEFERRABLE INITIALLY DEFERRED;

-- =========================================================================
-- Missing indexes on maintenance event relation table
-- =========================================================================
CREATE INDEX IF NOT EXISTS in_re_me_ws__fk_ws ON tww_od.re_maintenance_event_wastewater_structure USING btree (fk_wastewater_structure);
CREATE INDEX IF NOT EXISTS in_re_me_ws__fk_me ON tww_od.re_maintenance_event_wastewater_structure USING btree (fk_maintenance_event);

-- =========================================================================
-- Constraints of the baseline that may be missing in databases initialized
-- with releases older than 2024.0.5 (defensive: data is adapted first)
-- =========================================================================
DO $$
DECLARE
    truncated integer;
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'ws_remark_length_max_80'
          AND conrelid = 'tww_od.wastewater_structure'::regclass
    ) THEN
        UPDATE tww_od.wastewater_structure SET remark = left(remark, 80) WHERE char_length(remark) > 80;
        GET DIAGNOSTICS truncated = ROW_COUNT;
        IF truncated > 0 THEN
            RAISE WARNING 'ws_remark_length_max_80: truncated remark of % wastewater_structure row(s) to 80 characters', truncated;
        END IF;
        ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_remark_length_max_80 CHECK(char_length(remark) <= 80);
    END IF;
END
$$;

COMMIT;
