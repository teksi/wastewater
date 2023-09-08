-------
CREATE TABLE qgep_od.re_maintenance_event_wastewater_structure
(
  fk_wastewater_structure varchar (16) NOT NULL,
  fk_maintenance_event varchar (16) NOT NULL,
  CONSTRAINT rel_maintenance_event_wastewater_structure_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id),
  CONSTRAINT rel_maintenance_event_wastewater_structure_maintenance_event FOREIGN KEY (fk_maintenance_event) REFERENCES qgep_od.maintenance_event(obj_id),
  CONSTRAINT pkey_qgep_re_maintenance_event_wastewater_structure_obj_id PRIMARY KEY (fk_wastewater_structure, fk_maintenance_event)
)
WITH (
   OIDS = False
);

CREATE INDEX in_re_me_ws__fk_ws ON qgep_od.re_maintenance_event_wastewater_structure USING btree (fk_wastewater_structure ASC);
CREATE INDEX in_re_me_ws__fk_me ON qgep_od.re_maintenance_event_wastewater_structure USING btree (fk_maintenance_event ASC);
