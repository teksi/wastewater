CREATE MATERIALIZED VIEW IF NOT EXISTS tww_app.mvw_web_catchment_area_totals
AS
 SELECT cat.obj_id,
    cat.identifier,
    cat.population_dim,
    cat.population,
    cat.surface_dim,
    cat.surface_area,
    cat.surface_imp_dim,
    cat.surface_imp,
    cat.surface_red_dim,
    cat.surface_red,
    cat.ag96_sewer_infiltration_water_dim,
    cat.sewer_infiltration_water,
    ca_agg.perimeter_geometry AS perimeter_current,
    cat.ag96_waste_water_production_dim,
    cat.waste_water_production,
    ws_dp.identifier AS _discharge_point_identifier,
    ne.identifier AS _special_building_identifier,
    hcd.remark
   FROM tww_od.catchment_area_totals cat
     LEFT JOIN tww_od.hydraulic_char_data hcd ON hcd.obj_id::text = cat.fk_hydraulic_char_data::text AND hcd.status = 6372
     LEFT JOIN tww_od.wastewater_node wn ON hcd.fk_wastewater_node::text = wn.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id::text = wn.obj_id::text
     LEFT JOIN tww_od.wastewater_structure ws_dp ON ws_dp.obj_id::text = cat.fk_discharge_point::text
     LEFT JOIN ( WITH ca AS (
                 SELECT catchment_area.fk_special_building_ww_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_ww_current IS NOT NULL
                UNION
                 SELECT catchment_area.fk_special_building_rw_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_rw_current IS NOT NULL
                ), collector AS (
                 SELECT main_lc.obj_id,
                    main_lc.fk_pwwf_wastewater_node,
                    ca.geom
                   FROM ca
                     LEFT JOIN tww_od.log_card lc ON ca.fk_log_card::text = lc.obj_id::text
                     LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id::text = lc.fk_main_structure::text
                )
         SELECT collector.obj_id,
            collector.fk_pwwf_wastewater_node,
            st_unaryunion(st_collect(collector.geom)) AS perimeter_geometry
           FROM collector
          GROUP BY collector.obj_id, collector.fk_pwwf_wastewater_node) ca_agg ON ca_agg.fk_pwwf_wastewater_node::text = wn.obj_id::text;