rem pause
rem --defaultSrsAuth EPSG --defaultSrsCode 2056 ergänzt 12.7.2019


rem set variable to ili2pg*.jar, dbdatabase, dbpwd, ilipath, xtf path etc.

java -jar ../ili2pg-3.12.2.jar --createEnumTxtCol --import --deleteData --importTid --sqlEnableNull --createEnumTabs --createFk  --noSmartMapping --defaultSrsAuth EPSG --defaultSrsCode 2056 --dbhost localhost --dbport 5432 --dbdatabase qgep_gruner --dbschema abwa_2015neu_3122 --dbusr postgres --dbpwd sjib  --log importdaten_hof_3122.log --trace SIA405_Abwasser_2015_GemeindeHofstettenFlueh.xtf
pause


rem SIA405_Abwasser_2015_ALT_GemeindeBuesserach_LV95.xtf
