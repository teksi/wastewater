INSERT INTO tww_sys.pum_info(
	version,
	description,
	type,
	script,
	checksum,
	installed_by,
	--installed_on,
	execution_time,
	success
	)
VALUES (
	'1.0.0',
	'baseline',
	'0',
	'pum_info_set_baseline_entry.sql',
	'0',
	'postgres',
	--now(),
	1,
	true
	);