-- Topology
CREATE INDEX in_reach_fk_reach_point_to ON tww_od.reach USING btree (fk_reach_point_to);
CREATE INDEX in_reach_fk_reach_point_from ON tww_od.reach USING btree (fk_reach_point_from);
CREATE INDEX in_reach_point_fk_wastewater_networkelement ON tww_od.reach_point USING btree (fk_wastewater_networkelement);

CREATE INDEX in_reach_fk_pipe_profile ON tww_od.reach USING btree (fk_pipe_profile);

-- wastewater structure
CREATE INDEX in_wastewater_structure_fk_main_wastewater_node ON tww_od.wastewater_structure USING btree (fk_main_wastewater_node);
CREATE INDEX in_wastewater_structure_fk_main_cover ON tww_od.wastewater_structure USING btree (fk_main_cover);
CREATE INDEX in_wastewater_structure_fk_owner ON tww_od.wastewater_structure USING btree (fk_owner);

DROP INDEX IF EXISTS in_channel_function_hierarchic_usage_current; -- ON tww_od.channel USING btree (function_hierarchic, usage_current)
CREATE INDEX in_channel_usage_current ON tww_od.channel USING btree (usage_current);
CREATE INDEX in_channel_function_hierarchic ON tww_od.channel USING btree (function_hierarchic);
