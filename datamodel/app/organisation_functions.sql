CREATE OR REPLACE FUNCTION tww_app.synchronize_level_with_altitude_on_cover()
  RETURNS void AS
  $BODY$
  BEGIN
UPDATE tww_od.organisation
SET _active=TRUE
WHERE obj_id = ANY(
SELECT UNNEST(ARRAY[fk_provider,fk_dataowner])
FROM tww_od.wastewater_networkelement
UNION
SELECT UNNEST(ARRAY[fk_owner,fk_operator])
FROM tww_od.wastewater_structure
UNION
SELECT fk_operating_company
FROM tww_od.maintenance_event
UNION
SELECT UNNEST(ARRAY[fk_responsible_entity,fk_responsible_start,fk_provider,fk_dataowner])
FROM tww_od.measure
UNION
SELECT UNNEST(ARRAY[fk_agency,fk_location_municipality])
FROM tww_od.log_card
UNION
SELECT UNNEST(ARRAY[fk_agency,fk_location_municipality])
FROM tww_od.log_card
UNION
SELECT fk_operator
FROM tww_od.measuring_point
);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
