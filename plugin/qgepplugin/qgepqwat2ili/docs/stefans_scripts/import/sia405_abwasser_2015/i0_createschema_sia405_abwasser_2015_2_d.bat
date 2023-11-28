rem pause
rem --defaultSrsAuth EPSG --defaultSrsCode 2056 ergänzt 12.7.2019


rem set variable to ili2pg*.jar, dbdatabase, dbpwd, ilipath, xtf path etc.

java -jar ../ili2pg-3.12.2.jar --createEnumTxtCol --schemaimport --importTid --sqlEnableNull --createEnumTabs --createFk  --noSmartMapping --defaultSrsAuth EPSG --defaultSrsCode 2056 --dbhost localhost --dbport 5432 --dbdatabase qgep_gruner --dbschema abwa_2015neu_3122 --dbusr postgres --dbpwd sjib  --log createschema_sia405_abwasser_2015_2.log --trace SIA405_Abwasser_2015_2_d-20180417.ili
pause
