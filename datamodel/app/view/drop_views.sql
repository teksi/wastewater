
-- tww_app.swmm views
DROP VIEW IF EXISTS tww_app.swmm_vw_aquifers CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_conduits CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_coordinates CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_coverages CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_dividers CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_dwf CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_infiltration CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_junctions CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_landuses CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_losses CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_outfalls CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_polygons CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_pumps CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_raingages CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_storages CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_subareas CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_subcatchments CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_tags CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_vertices CASCADE;
DROP VIEW IF EXISTS tww_app.swmm_vw_xsections CASCADE;

-- network views
DROP MATERIALIZED VIEW IF EXISTS tww_app.vw_network_segment;
DROP MATERIALIZED VIEW IF EXISTS tww_app.vw_network_node;

-- export views
DROP VIEW IF EXISTS tww_app.vw_export_reach;
DROP VIEW IF EXISTS tww_app.vw_export_wastewater_structure;

-- import
DROP VIEW IF EXISTS tww_import.vw_manhole;
DROP TRIGGER IF EXISTS after_update_try_structure_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_insert_try_structure_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_update_try_inlet_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_insert_try_inlet_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_update_try_outlet_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_insert_try_outlet_update ON tww_import.manhole_quarantine;
DROP TRIGGER IF EXISTS after_mutation_delete_when_okay ON tww_import.manhole_quarantine;
DROP FUNCTION IF EXISTS tww_import.manhole_quarantine_try_structure_update();
DROP FUNCTION IF EXISTS tww_import.manhole_quarantine_try_let_update();
DROP FUNCTION IF EXISTS tww_import.manhole_quarantine_delete_entry();


-- big views
DROP VIEW IF EXISTS tww_app.vw_tww_wastewater_structure;
DROP VIEW IF EXISTS tww_app.vw_tww_maintenance;
DROP VIEW IF EXISTS tww_app.vw_tww_damage;
DROP VIEW IF EXISTS tww_app.vw_tww_overflow;
DROP VIEW IF EXISTS tww_app.vw_tww_reach;

-- structure_part
DROP VIEW IF EXISTS tww_app.vw_access_aid;
DROP FUNCTION IF EXISTS tww_app.vw_access_aid_insert();

DROP VIEW IF EXISTS tww_app.vw_backflow_prevention;
DROP FUNCTION IF EXISTS tww_app.vw_backflow_prevention_insert();

DROP VIEW IF EXISTS tww_app.vw_benching;
DROP FUNCTION IF EXISTS tww_app.vw_benching_insert();

DROP VIEW IF EXISTS tww_app.vw_cover;
DROP FUNCTION IF EXISTS tww_app.vw_cover();

DROP VIEW IF EXISTS tww_app.vw_dryweather_downspout;
DROP FUNCTION IF EXISTS tww_app.vw_dryweather_downspout_insert();

DROP VIEW IF EXISTS tww_app.vw_dryweather_flume;
DROP FUNCTION IF EXISTS tww_app.vw_dryweather_flume_insert();


-- wastewater_structure
DROP VIEW IF EXISTS tww_app.vw_channel;
DROP FUNCTION IF EXISTS tww_app.vw_channel_insert();

DROP VIEW IF EXISTS tww_app.vw_manhole;
DROP FUNCTION IF EXISTS tww_app.vw_manhole_insert();

DROP VIEW IF EXISTS tww_app.vw_discharge_point;
DROP FUNCTION IF EXISTS tww_app.vw_discharge_point_insert();

DROP VIEW IF EXISTS tww_app.vw_special_structure;
DROP FUNCTION IF EXISTS tww_app.vw_special_structure_insert();

DROP VIEW IF EXISTS tww_app.vw_infiltration_installation;
DROP FUNCTION IF EXISTS tww_app.vw_infiltration_installation_insert();

DROP VIEW IF EXISTS tww_app.vw_wwtp_structure;
DROP FUNCTION IF EXISTS tww_app.vw_wwtp_structure_insert();


-- property_drainage
DROP VIEW IF EXISTS tww_app.vw_building;
DROP FUNCTION IF EXISTS tww_app.vw_building_insert();

DROP VIEW IF EXISTS tww_app.vw_reservoir;
DROP FUNCTION IF EXISTS tww_app.vw_reservoir_insert();

DROP VIEW IF EXISTS tww_app.vw_fountain;
DROP FUNCTION IF EXISTS tww_app.vw_fountain_insert();


-- wastewater_networkelement
DROP VIEW IF EXISTS tww_app.vw_reach;
DROP FUNCTION IF EXISTS tww_app.vw_reach_insert();

DROP VIEW IF EXISTS tww_app.vw_wastewater_node;
DROP FUNCTION IF EXISTS tww_app.vw_wastewater_node_insert();

-- organisation
DROP VIEW IF EXISTS tww_app.vw_organisation;
-- subclasse of organisation do not exist anymore in VSA-DSS 2020
--DROP VIEW IF EXISTS tww_app.vw_administrative_office;
--DROP VIEW IF EXISTS tww_app.vw_canton;
--DROP VIEW IF EXISTS tww_app.vw_cooperative;
--DROP VIEW IF EXISTS tww_app.vw_municipality;
--DROP VIEW IF EXISTS tww_app.vw_private;
--DROP VIEW IF EXISTS tww_app.vw_waste_water_treatment_plant;
--DROP VIEW IF EXISTS tww_app.vw_waste_water_association;

-- overflows
DROP VIEW IF EXISTS tww_app.vw_leapingweir;
DROP VIEW IF EXISTS tww_app.vw_prank_weir;
DROP VIEW IF EXISTS tww_app.vw_pump;

-- others
DROP VIEW IF EXISTS tww_app.vw_individual_surface;

-- manual views
DROP VIEW IF EXISTS tww_app.vw_file;
DROP VIEW IF EXISTS tww_app.vw_change_points;
DROP VIEW IF EXISTS tww_app.vw_catchment_area_connections;

-- tww_sys views
DROP VIEW IF EXISTS tww_sys.dictionary_value_list;
