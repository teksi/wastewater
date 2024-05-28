CREATE MATERIALIZED VIEW tww_app.vw_tww_catchment_area_totals
 AS
 SELECT cat.*,
	lc.obj_id as fk_log_card,
    ca_agg.perimeter_geometry,
    wn.situation3d_geometry,
    wn.obj_id AS wn_obj_id
   FROM tww_od.catchment_area_totals cat
     LEFT JOIN tww_od.hydraulic_char_data hcd ON hcd.obj_id::text = cat.fk_hydraulic_char_data::text AND hcd.status = 6372
     LEFT JOIN tww_od.wastewater_node wn ON hcd.fk_wastewater_node::text = wn.obj_id::text
     LEFT JOIN tww_od.log_card lc ON lc.fk_pwwf_wastewater_node::text = wn.obj_id::text
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
                    ca.geom
                   FROM ca
                     LEFT JOIN tww_od.log_card lc ON ca.fk_log_card::text = lc.obj_id::text
                     LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id::text = lc.fk_main_structure::text
                )
         SELECT collector.obj_id,
            st_unaryunion(st_collect(collector.geom)) AS perimeter_geometry
           FROM collector
          GROUP BY collector.obj_id) ca_agg ON ca_agg.obj_id::text = lc.obj_id::text
WITH DATA;
