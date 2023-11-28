/*
This fixes some invalid (according to SIA405) values in the QGEP demo data, so that
we ilivalidator validates the exports.

TODO this should probably be applied to the actual demo data if these are actual data errors.
*/

-- Error: line 17814: SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Normschacht: tid ch13p7mzMA009659: value 4500 is out of range in attribute Dimension1
UPDATE qgep_od.manhole SET dimension1=4000 WHERE dimension1>4000;
UPDATE qgep_od.manhole SET dimension2=4000 WHERE dimension2>4000;

-- Error: line 79976: SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Haltung: tid ch13p7mzRE005187: duplicate coord at (2748419.603, 1265870.794, NaN)
UPDATE qgep_od.reach SET progression_geometry=ST_RemoveRepeatedPoints(progression_geometry, 0.002) WHERE NOT ST_EQUALS(progression_geometry, ST_RemoveRepeatedPoints(progression_geometry, 0.001));

-- Error: line 84452: SIA405_ABWASSER_2015_LV95.SIA405_Abwasser.Haltung: tid ch13p7mzRE009663: duplicate coord at (2750088.164, 1263080.203, NaN)
-- degenerated geometry
DELETE FROM qgep_od.reach WHERE obj_id='ch13p7mzRE009663';
