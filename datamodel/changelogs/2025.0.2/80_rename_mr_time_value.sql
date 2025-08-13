ALTER TABLE tww_od.measurement_result RENAME COLUMN "time" TO time_point; --renamed 20250812 as time is a reserved SQL:2023 keyword
ALTER TABLE tww_od.measurement_result RENAME COLUMN "value" TO measurement_value; -- #renamed 20250812 as value is a reserved SQL:2023 keyword
