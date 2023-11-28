# Interlis / QGEP oddities

## QGEP

- `qgep_od.file.fk_data_media` doesn't have a FK constraint to `qgep_od.data_media.obj_id`

## SIA405_Abwasser

- `Deckel.Fabrikat` looks like a typo, shouldn't it be `Deckel.Fabrikant` ? (comment is `Name der Herstellerfirma`)

## QGEP-SIA405 differences

- `qgep_od.maintenance_event` has a N-M relation to `qgep_od.wastewater_structure`, making fields like `inspection.inspected_length` or `damage.distance` ambigous. Corresponding SIA405_Abwasser classes have a N-1 relation instead, which looks like a better fit.

- In SIA405, some common fields from the concrete `normschachtschaden` and `kanalschaden` could be moved to the abstract `schaden` class (e.g. `distanz`, `quantifizierung1`, `quantifizierung2`...). This would match QGEP's implementation where it's like this already.

- `qgep_od.maintenance_event.active_zone` has no equivalent in the interlis model.

- `reach.elevation_determination` has no equivalent in the interlis model
