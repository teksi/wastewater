CREATE OR REPLACE FUNCTION tww_app.update_catchment_area_totals(_obj_id text, _all boolean default false)
  RETURNS VOID
  SECURITY DEFINER
  AS
  $BODY$
BEGIN

REFRESH MATERIALIZED VIEW tww_app.vw_catchment_area_totals_aggregated WITH DATA;

WITH ca AS (
	SELECT obj_id
			, fk_special_building_ww_current AS fk_log_card
			, surface_area AS f_current
			, discharge_coefficient_ww_current/100*surface_area AS fred_current
			, seal_factor_ww_current/100*surface_area AS fimp_current
			, population_density_current*surface_area AS pop_current
--			, sewer_infiltration_water_production_current AS q_inf_current
--			, waste_water_production_current AS q_ww_current

			, NULL::numeric AS f_dim
			, NULL::numeric AS fred_dim
			, NULL::numeric AS fimp_dim
			, NULL::numeric AS pop_dim
--			, NULL::numeric AS q_inf_dim
--			, NULL::numeric AS q_ww_dim
		FROM tww_od.catchment_area
		WHERE catchment_area.fk_special_building_ww_current IS NOT NULL
	UNION
		SELECT obj_id
			, fk_special_building_rw_current AS fk_log_card
			, CASE
				WHEN fk_special_building_ww_current = fk_special_building_rw_current
				THEN 0
				else surface_area
			  END AS f_current
			, discharge_coefficient_rw_current/100*surface_area AS fred_current
			, seal_factor_rw_current/100*surface_area AS fimp_current
			, NULL::numeric AS pop_current
--			, NULL::numeric AS q_inf_current
--			, NULL::numeric AS q_ww_current

			, NULL::numeric AS f_dim
			, NULL::numeric AS fred_dim
			, NULL::numeric AS fimp_dim
			, NULL::numeric AS pop_dim
--			, NULL::numeric AS q_inf_dim
--			, NULL::numeric AS q_ww_dim
		FROM tww_od.catchment_area
		WHERE catchment_area.fk_special_building_rw_current IS NOT NULL
	UNION
		SELECT obj_id
			, fk_special_building_ww_planned AS fk_log_card
			, NULL::numeric AS f_current
			, NULL::numeric AS fred_current
			, NULL::numeric AS fimp_current
			, NULL::numeric AS pop_current
--			, NULL::numeric AS q_inf_current
--			, NULL::numeric AS q_ww_current

			, surface_area AS f_dim
			, discharge_coefficient_ww_planned/100*surface_area AS fred_dim
			, seal_factor_ww_planned/100*surface_area AS fimp_dim
			, population_density_planned*surface_area AS pop_dim
--			, sewer_infiltration_water_production_planned AS q_inf_dim
--			, waste_water_production_planned AS q_ww_dim
		FROM tww_od.catchment_area
		WHERE catchment_area.fk_special_building_ww_planned IS NOT NULL
	UNION
		SELECT obj_id
			, fk_special_building_rw_planned AS fk_log_card
			, NULL::numeric AS f_current
			, NULL::numeric AS fred_current
			, NULL::numeric AS fimp_current
			, NULL::numeric AS pop_current
--			, NULL::numeric AS q_inf_current
--			, NULL::numeric AS q_ww_current

			, CASE
				WHEN fk_special_building_ww_planned = fk_special_building_rw_planned
				THEN 0
				else surface_area
			  END AS f_dim
			, discharge_coefficient_rw_planned/100*surface_area AS fred_dim
			, seal_factor_rw_current/100*surface_area AS fimp_dim
			, NULL::numeric AS pop_dim
--			, NULL::numeric AS q_inf_dim
--			, NULL::numeric AS q_ww_dim
		FROM tww_od.catchment_area
		WHERE catchment_area.fk_special_building_rw_planned IS NOT NULL
    )
UPDATE tww_od.catchment_area_totals cat
SET

	  population = ca_agg.pop_current
	, population_dim = ca_agg.pop_dim
	, sewer_infiltration_water = ca_agg.q_inf_current
	, surface_area = ca_agg.f_current
	, surface_dim = ca_agg.f_dim
	, surface_red = ca_agg.fred_current
	, surface_red_dim = ca_agg.fred_dim
	, surface_imp = ca_agg.fimp_current
	, surface_imp_dim = ca_agg.fimp_dim
	, waste_water_production = ca_agg.q_ww_current
	--, ag96_sewer_infiltration_water_dim = ca_agg.q_inf_dim
	--, ag96_waste_water_production_dim = ca_agg.q_ww_dim
FROM
( SELECT cat.obj_id
	, SUM(f_current) as f_current
	, SUM(fred_current) as fred_current
	, SUM(fimp_current) as fimp_current
	, SUM(pop_current) as pop_current
	, aggr.sewer_infiltration_water as q_inf_current
	, aggr.waste_water_production as  q_ww_current

	, SUM(f_dim) as f_dim
	, SUM(fred_dim) as fred_dim
	, SUM(fimp_dim) as fimp_dim
	, SUM(pop_dim) as pop_dim
	, aggr.sewer_infiltration_water_dim as q_inf_dim
	, aggr.waste_water_production_dim as q_ww_dim
   FROM ca
	 LEFT JOIN tww_od.log_card lc_1 ON ca.fk_log_card::text = lc_1.obj_id::text
	 LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id::text = lc_1.fk_main_structure::text
     LEFT JOIN tww_od.wastewater_node wn ON main_lc.fk_pwwf_wastewater_node::text = wn.obj_id::text
     LEFT JOIN tww_od.hydraulic_char_data hcd ON hcd.fk_wastewater_node::text = wn.obj_id::text AND hcd.status = 6372
	LEFT JOIN tww_od.catchment_area_totals cat ON hcd.obj_id::text = cat.fk_hydraulic_char_data::text
	LEFT JOIN tww_app.vw_catchment_area_totals_aggregated aggr ON aggr.obj_id = cat.obj_id
  GROUP BY cat.obj_id
  , aggr.sewer_infiltration_water
  , aggr.waste_water_production
  , aggr.sewer_infiltration_water_dim
  , aggr.waste_water_production_dim)ca_agg
WHERE cat.obj_id=ca_agg.obj_id
;

END
$BODY$
LANGUAGE plpgsql
VOLATILE;
