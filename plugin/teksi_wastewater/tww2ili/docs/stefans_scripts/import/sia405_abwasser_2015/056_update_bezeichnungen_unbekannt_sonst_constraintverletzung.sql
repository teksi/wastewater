-- 12.7.2019 testing - nicht brauchbar bis jetzt
-- allgemein
-- UPDATE table
-- SET column1 = value1,
--    column2 = value2 ,...
-- WHERE
--   condition;


SELECT bezeichnung, t_id FROM abwa_2015neu_3122.abwasserbauwerk WHERE bezeichnung = 'unbekannt';

UPDATE abwa_2015neu_3122.abwasserbauwerk
SET bezeichnung = obj_id
WHERE
   bezeichnung = 'unbekannt';
