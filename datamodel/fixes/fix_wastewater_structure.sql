ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_main_cover varchar(16);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_cover FOREIGN KEY (fk_main_cover) REFERENCES qgep_od.cover(obj_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_main_wastewater_node varchar(16);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_main_wastewater_node FOREIGN KEY (fk_main_wastewater_node) REFERENCES qgep_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE SET NULL;
