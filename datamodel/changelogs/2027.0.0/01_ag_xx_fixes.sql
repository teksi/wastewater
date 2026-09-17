ALTER TABLE IF EXISTS tww_od.agxx_unconnected_node_bwrel
ADD COLUMN IF NOT EXISTS ag96_is_gateway bigint,
ADD CONSTRAINT agxx_unc_fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
