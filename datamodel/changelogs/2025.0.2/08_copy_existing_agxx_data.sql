-- Check if the column 'ag96_is_gateway' exists in the table 'wastewater_node'
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'tww_od'
        AND table_name = 'wastewater_node'
        AND column_name = 'ag96_is_gateway'
    ) THEN

        -- Insert data into agxx tables and drop columns
        INSERT INTO tww_od.agxx_wastewater_node(obj_id, ag96_is_gateway, ag64_function)
        SELECT obj_id, ag96_is_gateway, ag64_function
        FROM tww_od.wastewater_node;

        ALTER TABLE tww_od.wastewater_node DROP COLUMN ag96_is_gateway CASCADE;
        ALTER TABLE tww_od.wastewater_node DROP COLUMN ag64_function CASCADE;

        INSERT INTO tww_od.agxx_cover(obj_id, ag64_fk_wastewater_node)
        SELECT obj_id, ag64_fk_wastewater_node
        FROM tww_od.cover;

        ALTER TABLE tww_od.cover DROP COLUMN ag64_fk_wastewater_node CASCADE;

        INSERT INTO tww_od.agxx_wastewater_structure(obj_id, ag96_fk_measure)
        SELECT obj_id, ag96_fk_measure
        FROM tww_od.wastewater_structure;

        ALTER TABLE tww_od.wastewater_structure DROP COLUMN ag96_fk_measure CASCADE;

        INSERT INTO tww_od.agxx_reach(obj_id, ag96_clear_height_planned, ag96_clear_width_planned)
        SELECT obj_id, ag96_clear_height_planned, ag96_clear_width_planned
        FROM tww_od.reach;

        ALTER TABLE tww_od.reach DROP COLUMN ag96_clear_height_planned CASCADE;
        ALTER TABLE tww_od.reach DROP COLUMN ag96_clear_width_planned CASCADE;

        INSERT INTO tww_od.agxx_catchment_area_totals(obj_id, ag96_sewer_infiltration_water_dim, ag96_waste_water_production_dim, ag96_perimeter_geometry)
        SELECT obj_id, ag96_sewer_infiltration_water_dim, ag96_waste_water_production_dim, ag96_perimeter_geometry
        FROM tww_od.catchment_area_totals;

        ALTER TABLE tww_od.catchment_area_totals DROP COLUMN ag96_sewer_infiltration_water_dim CASCADE;
        ALTER TABLE tww_od.catchment_area_totals DROP COLUMN ag96_waste_water_production_dim CASCADE;
        ALTER TABLE tww_od.catchment_area_totals DROP COLUMN ag96_perimeter_geometry CASCADE;

        INSERT INTO tww_od.agxx_building_group(obj_id, ag96_owner_address, ag96_owner_name, ag96_label_number, ag96_disposal_wastewater, ag96_disposal_industrial_wastewater, ag96_disposal_square_water, ag96_disposal_roof_water, ag96_population)
        SELECT obj_id, ag96_owner_address, ag96_owner_name, ag96_label_number, ag96_disposal_wastewater, ag96_disposal_industrial_wastewater, ag96_disposal_square_water, ag96_disposal_roof_water, ag96_population
        FROM tww_od.building_group;

        ALTER TABLE tww_od.building_group DROP COLUMN ag96_owner_address CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_owner_name CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_label_number CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_disposal_wastewater CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_disposal_industrial_wastewater CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_disposal_square_water CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_disposal_roof_water CASCADE;
        ALTER TABLE tww_od.building_group DROP COLUMN ag96_population CASCADE;

        INSERT INTO tww_od.agxx_wastewater_networkelement(obj_id, ag96_fk_provider, ag96_remark, ag64_fk_provider, ag64_remark)
        SELECT obj_id, ag96_fk_provider, ag96_remark, ag64_fk_provider, ag64_remark
        FROM tww_od.wastewater_networkelement;

        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag96_fk_provider CASCADE;
        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag96_remark CASCADE;
        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag64_fk_provider CASCADE;
        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag64_remark CASCADE;

        INSERT INTO tww_od.agxx_overflow(obj_id, ag96_fk_provider, ag96_remark, ag64_fk_provider, ag64_remark)
        SELECT obj_id, ag96_fk_provider, ag96_remark, ag64_fk_provider, ag64_remark
        FROM tww_od.overflow;

        ALTER TABLE tww_od.overflow DROP COLUMN ag96_fk_provider CASCADE;
        ALTER TABLE tww_od.overflow DROP COLUMN ag96_remark CASCADE;
        ALTER TABLE tww_od.overflow DROP COLUMN ag64_fk_provider CASCADE;
        ALTER TABLE tww_od.overflow DROP COLUMN ag64_remark CASCADE;

        INSERT INTO tww_od.agxx_infiltration_zone(obj_id, ag96_permeability, ag96_limitation, ag96_thickness, ag96_q_check)
        SELECT obj_id, ag96_permeability, ag96_limitation, ag96_thickness, ag96_q_check
        FROM tww_od.infiltration_zone;

        ALTER TABLE tww_od.infiltration_zone DROP COLUMN ag96_permeability CASCADE;
        ALTER TABLE tww_od.infiltration_zone DROP COLUMN ag96_limitation CASCADE;
        ALTER TABLE tww_od.infiltration_zone DROP COLUMN ag96_thickness CASCADE;
        ALTER TABLE tww_od.infiltration_zone DROP COLUMN ag96_q_check CASCADE;

        -- Insert data into agxx_last_modification and drop columns for modification_defs
        INSERT INTO tww_od.agxx_last_modification(obj_id, ag64_last_modification, ag96_last_modification)
        SELECT obj_id, ag64_last_modification, ag96_last_modification
        FROM tww_od.wastewater_networkelement;

        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag64_last_modification CASCADE;
        ALTER TABLE tww_od.wastewater_networkelement DROP COLUMN ag96_last_modification CASCADE;

        INSERT INTO tww_od.agxx_last_modification(obj_id, ag64_last_modification, ag96_last_modification)
        SELECT obj_id, ag64_last_modification, ag96_last_modification
        FROM tww_od.overflow;

        ALTER TABLE tww_od.overflow DROP COLUMN ag64_last_modification CASCADE;
        ALTER TABLE tww_od.overflow DROP COLUMN ag96_last_modification CASCADE;
    END IF;
END $$;
