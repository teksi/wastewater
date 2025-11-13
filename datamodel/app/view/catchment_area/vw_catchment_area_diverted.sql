CREATE OR REPLACE VIEW tww_app.vw_catchment_area_diverted
AS
 SELECT
    row_number() over() as _id,
	agg.*
	FROM( SELECT
	fk_special_building_ww_current AS fk_log_card_current,
	fk_special_building_ww_planned AS fk_log_card_planned,
	'ww' as _type,
	st_unaryunion(st_collect(perimeter_geometry)) AS geom
	FROM tww_od.catchment_area
	WHERE fk_special_building_ww_current != fk_special_building_ww_planned
	GROUP BY fk_special_building_ww_current, fk_special_building_ww_planned
	UNION ALL
	SELECT
	fk_special_building_rw_current AS fk_log_card_current,
	fk_special_building_rw_planned AS fk_log_card_planned,
	'rw' as _type,
	st_unaryunion(st_collect(perimeter_geometry)) AS geom
	FROM tww_od.catchment_area
	WHERE fk_special_building_rw_current != fk_special_building_rw_planned
	GROUP BY fk_special_building_rw_current, fk_special_building_rw_planned
	) agg
	;
