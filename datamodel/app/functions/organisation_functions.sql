CREATE OR REPLACE FUNCTION tww_app.set_organisations_active()
  RETURNS void AS
  $BODY$
  BEGIN
UPDATE tww_od.organisation
SET tww_active=TRUE
WHERE obj_id = ANY(
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.dss15_aquifier
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.building_group
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.building_group_baugwr
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.catchment_area
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.catchment_area_totals
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.connection_object
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.control_center
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.damage
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.data_media
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.disposal
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.farm
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.file
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.hq_relation
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.hydr_geom_relation
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.hydr_geometry
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.hydraulic_char_data
UNION
SELECT UNNEST(ARRAY[fk_agency,fk_location_municipality,fk_provider,fk_dataowner])
FROM tww_od.log_card
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner,fk_operating_company])
FROM tww_od.maintenance_event
UNION
SELECT UNNEST(ARRAY[fk_responsible_entity,fk_responsible_start,fk_provider,fk_dataowner])
FROM tww_od.measure
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.measurement_result
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.measurement_series
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.measuring_device
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner,fk_operator])
FROM tww_od.measuring_point
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.mechanical_pretreatment
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.mutation
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.organisation
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.overflow
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.overflow_char
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.pipe_profile
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.profile_geometry
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.reach_point
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.retention_body
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.sludge_treatment
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.structure_part
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.surface_runoff_parameters
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.throttle_shut_off_unit
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.waste_water_treatment
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.waste_water_treatment_plant
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.wastewater_networkelement
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.wastewater_networkelement
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner,fk_owner,fk_operator])
FROM tww_od.wastewater_structure
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.wwtp_energy_use
UNION
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.zone

);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
