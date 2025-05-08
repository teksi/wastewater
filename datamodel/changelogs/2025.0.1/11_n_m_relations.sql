-------
CREATE INDEX in_re_me_ws__fk_ws ON tww_od.re_maintenance_event_wastewater_structure USING btree (fk_wastewater_structure ASC);
CREATE INDEX in_re_me_ws__fk_me ON tww_od.re_maintenance_event_wastewater_structure USING btree (fk_maintenance_event ASC);
