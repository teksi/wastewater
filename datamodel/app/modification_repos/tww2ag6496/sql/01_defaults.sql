ALTER TABLE IF NOT EXISTS tww_od.agxx_measure_text ALTER COLUMN obj_id SET DEFAULT tww_app.generate_oid('tww_od'::text, 'agxx_measure_text'::text);
ALTER TABLE IF NOT EXISTS tww_od.agxx_building_group_text ALTER COLUMN obj_id SET DEFAULT tww_app.generate_oid('tww_od'::text, 'agxx_building_group_text'::text);
