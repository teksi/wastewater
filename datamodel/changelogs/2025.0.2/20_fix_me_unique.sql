DROP INDEX IF EXISTS tww_od.in_od_maintenance_event_identifier;

CREATE UNIQUE INDEX in_od_maintenance_event_identifier ON tww_od.maintenance_event USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST, time_point ASC NULLS LAST);
