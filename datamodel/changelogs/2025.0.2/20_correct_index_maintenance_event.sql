-- Existing index is wrong and only considers identifier and fk_dataowner
DROP INDEX IF EXISTS in_od_maintenance_event_identifier;
-- New index that fits intended INTERLIS definition which includes time_point
CREATE UNIQUE INDEX in_od_maintenance_event_identifier_time_point ON tww_od.maintenance_event USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST, time_point ASC NULLS LAST);
