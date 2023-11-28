/*
This fixes some invalid (according to SIA405) values in the QWAT demo data, so that
we ilivalidator validates the exports.

TODO this should probably be applied to the actual demo data if these are actual data errors.
*/

--Error: line 15893: SIA405_WASSER_2015_LV95.SIA405_Wasser.Leitung: tid ch00000000009672: duplicate coord at (2516459.261, 1158273.716, NaN)

-- degenerated geometry
DELETE FROM qwat_od.pipe WHERE id=33743;
