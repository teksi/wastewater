-- already exists in 03_tww_db_dss.sql
/* ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_main_cover varchar(16);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_cover FOREIGN KEY (fk_main_cover) REFERENCES tww_od.cover(obj_id) ON UPDATE CASCADE ON DELETE SET NULL; */

ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_main_wastewater_node varchar(16);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_main_wastewater_node FOREIGN KEY (fk_main_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;
