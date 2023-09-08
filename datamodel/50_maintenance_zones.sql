ALTER TABLE qgep_od.maintenance_event ADD COLUMN active_zone VARCHAR(1);
COMMENT ON COLUMN qgep_od.maintenance_event.active_zone IS 'ID of the active zone, for visualization purpose (use A, B, C, D, E, F, G and H)';

