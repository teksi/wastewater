--------
-- View for the swmm module class conduits
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_conduits AS

SELECT
	re.obj_id as Name,
	coalesce(from_wn.obj_id, concat('from_node@',re.obj_id)) as FromNode,
	coalesce(to_wn.obj_id, concat('to_node@',re.obj_id)) as ToNode,
	CASE
		WHEN re.length_effective <= 0.01 AND st_length(progression3d_geometry) <= 0.01 THEN 0.01
		WHEN re.length_effective <= 0.01 AND st_length(progression3d_geometry) >= 0.01 THEN st_length(progression3d_geometry)
		WHEN re.length_effective IS NULL AND st_length(progression3d_geometry) <= 0.01 THEN 0.01
		WHEN re.length_effective IS NULL AND st_length(progression3d_geometry) >= 0.01 THEN st_length(progression3d_geometry)
		ELSE re.length_effective
	END as Length,
	-- Roughness export prioriy: 1. coefficient_of_friction, 2. wall_roughness, 3. swmm_default_coefficient_of_friction, 4. 0.01
	CASE
		WHEN re.coefficient_of_friction IS NOT NULL THEN (1 / re.coefficient_of_friction::double precision)
		WHEN re.coefficient_of_friction IS NULL AND re.wall_roughness IS NOT NULL THEN
			CASE
				/* WHEN re.clear_height IS NOT NULL THEN (1 / (4 * SQRT(9.81) * POWER((32 / re.clear_height::double precision / 1000),(1 / 6::double precision))*LOG(((3.71 * re.clear_height::double precision / 1000) / (re.wall_roughness / 1000)))))::numeric(7,4) */
				WHEN re.clear_height IS NOT NULL THEN 1./((4. * SQRT(9.81) * POWER((32. / (re.clear_height::double precision / 1000.)),(1. / 6.::double precision)))*LOG(((3.71 * (re.clear_height::double precision / 1000.)) / (re.wall_roughness / 1000.))))::numeric(7,4)
				WHEN re.clear_height IS NULL AND re.swmm_default_coefficient_of_friction IS NOT NULL THEN (1 / re.swmm_default_coefficient_of_friction::double precision)
				ELSE 0.01
			END
		WHEN re.coefficient_of_friction IS NULL AND re.wall_roughness IS NULL THEN
			CASE
				WHEN re.swmm_default_coefficient_of_friction IS NOT NULL THEN (1 / re.swmm_default_coefficient_of_friction::double precision)
				ELSE 0.01
			END
		ELSE 0.01
	END AS roughness,
	coalesce((rp_from.level-from_wn.bottom_level),0) as InletOffset,
	coalesce((rp_to.level-to_wn.bottom_level),0) as OutletOffset,
	0 as InitFlow,
	0 as MaxFlow,
	concat_ws(';',
	ws.identifier,
	CASE
		/* WHEN re.coefficient_of_friction IS NOT NULL THEN '1 / K_Strickler is used as roughness' */
		WHEN re.coefficient_of_friction IS NOT NULL THEN '1 / K_Strickler, 1/re.coefficient_of_friction is used as roughness'
		WHEN re.coefficient_of_friction IS NULL AND re.wall_roughness IS NOT NULL THEN
			CASE
				/* WHEN re.clear_height IS NOT NULL THEN 'The approximation of 1 / K_Strickler is computed using K_Colebrook to determined the roughness as roughness' */
				WHEN re.clear_height IS NOT NULL THEN 'The approximation of 1 / K_Strickler is computed from re.wall_roughness using an approximation formula.'
				WHEN re.clear_height IS NULL AND re.swmm_default_coefficient_of_friction IS NOT NULL THEN 'The default value stored in reach.swmm_default_coefficient_of_friction is used'
				ELSE 'Default value 0.01 is used as roughness'
			END
		WHEN re.coefficient_of_friction IS NULL AND re.wall_roughness IS NULL THEN
			CASE
				WHEN re.swmm_default_coefficient_of_friction IS NOT NULL THEN concat('The default value stored in reach.swmm_default_coefficient_of_friction is used')
				ELSE 'Default value 0.01 is used as roughness'
			END
		ELSE 'Default value 0.01 is used as roughness'
	END,
	CASE
		WHEN vl_pp.vsacode = 3350 THEN
			CASE
				WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': circular profile with default value of 0.1m as clear_height')
				ELSE NULL
			END
		WHEN vl_pp.vsacode = 3351 THEN
			CASE
				WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': egg profile with default value of 0.1m as clear_height')
				ELSE NULL
			END
		WHEN vl_pp.vsacode = 3352 THEN
			CASE
				WHEN pp.height_width_ratio IS NOT NULL THEN
					CASE
						WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': arch profile with known height_width_ratio value and with default value of 0.1m as clear_height')
						ELSE NULL
					END
				WHEN pp.height_width_ratio IS NULL THEN
					CASE
						WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': arch profile with default value of 1 as height_width_ratio and with default value of 0.1m as clear_height')
						ELSE concat('Reach', re.obj_id,': arch profile with default value of 1 as height_width_ratio and with known clear_height value')
					END
			END
		WHEN vl_pp.vsacode = 3353 THEN
			CASE
				WHEN pp.height_width_ratio IS NOT NULL THEN
					CASE
						WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': rectangular profile with known height_width_ratio value and with default value of 0.1m as clear_height')
						ELSE NULL
					END
				WHEN pp.height_width_ratio IS NULL THEN
				CASE
					WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': rectangular profile with default value of 1 as height_width_ratio and with default value of 0.1m as clear_height')
					ELSE concat('Reach', re.obj_id,': rectangular profile with default value of 1 as height_width_ratio and with known clear_height value')
				END
			END
		WHEN vl_pp.vsacode = 3354 THEN
			CASE
				WHEN pp.height_width_ratio IS NOT NULL THEN
					CASE
						WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': parabolic profile with known height_width_ratio value, default value of 0.1m as clear_height and no code value')
						ELSE NULL
					END
				WHEN pp.height_width_ratio IS NULL THEN
					CASE
						WHEN re.clear_height = 0 OR re.clear_height IS NULL THEN concat('Reach', re.obj_id,': parabolic profile with default value of 1 as height_width_ratio, with default value of 0.1m as clear_height and no code value')
						ELSE concat('Reach', re.obj_id,': parabolic profile with default value of 1 as height_width_ratio, with known clear_height value and no code value')
					END
			END
		WHEN vl_pp.vsacode = 3355 THEN concat('Reach', re.obj_id,': custom profile to be defined in SWMM')
	END,
	CASE
		WHEN to_wn.obj_id IS NULL THEN 'Blind connection, the destination node must be edited'
		WHEN from_wn.obj_id IS NULL AND to_wn.obj_id IS NOT NULL THEN 'No from node, a junction was automatically created for the export.'
		ELSE NULL
	END
	) as description,
	cfhy.value_en as tag,
	ST_CurveToLine(st_force3d(progression3d_geometry))::geometry(LineStringZ, {SRID}) as geom,
	CASE
		WHEN status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
  CASE
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	re.obj_id as obj_id
FROM tww_od.reach as re
LEFT JOIN tww_od.pipe_profile pp on pp.obj_id = re.fk_pipe_profile
LEFT JOIN tww_vl.pipe_profile_profile_type vl_pp on pp.profile_type = vl_pp.code
LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
LEFT JOIN tww_od.wastewater_node from_wn on from_wn.obj_id = rp_from.fk_wastewater_networkelement
LEFT JOIN tww_od.wastewater_node to_wn on to_wn.obj_id = rp_to.fk_wastewater_networkelement
LEFT JOIN tww_od.channel ch on ch.obj_id::text = ws.obj_id::text
LEFT JOIN tww_vl.channel_function_hierarchic cfhi on cfhi.code = ch.function_hierarchic
LEFT JOIN tww_vl.channel_function_hydraulic cfhy on cfhy.code = ch.function_hydraulic
-- select only operationals and "planned"
WHERE status IN (6530, 6533, 8493, 6529, 6526, 7959);
-- 6526	"other.calculation_alternative"
-- 6529	"other.project"
-- 7959	"other.planned"
-- 6530	"operational.tentative"
-- 6533	"operational.will_be_suspended"
-- 8493	"operational"

-- 6532	"abanndoned.filled"
-- 3027	"unknown"
-- 3633	"inoperative"
-- 6523	"abanndoned.suspended_not_filled"
-- 6524	"abanndoned.suspended_unknown"
