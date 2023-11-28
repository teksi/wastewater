rem pause
rem --defaultSrsAuth EPSG --defaultSrsCode 2056 ergänzt 12.7.2019
rem -- Korrekturen Organisation schon im xtf: abwa_2015neumod.xtf

rem set variable to ili2pg*.jar, dbdatabase, dbpwd, ilipath etc.

java -jar ../ili2pg-3.12.2.jar --createEnumTxtCol --schemaimport --importTid --sqlEnableNull --createEnumTabs --createFk  --noSmartMapping --defaultSrsAuth EPSG --defaultSrsCode 2056 --dbhost localhost --dbport 5434 --dbdatabase qgep_prod --dbschema sia405_abwasser_2015_2 --dbusr postgres --dbpwd sjib  --log createschema_sia405_abwasser_2015_2.log --trace SIA405_ABWASSER_2015.ili
pause
