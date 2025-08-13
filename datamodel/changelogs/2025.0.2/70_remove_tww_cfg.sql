ALTER TABLE tww_cfg.reach_coefficient_of_friction
    SET SCHEMA tww_od;
ALTER TABLE IF EXISTS tww_cfg.agxx_last_modification_updater
    SET SCHEMA tww_od;
DROP SCHEMA tww_cfg CASCADE;
