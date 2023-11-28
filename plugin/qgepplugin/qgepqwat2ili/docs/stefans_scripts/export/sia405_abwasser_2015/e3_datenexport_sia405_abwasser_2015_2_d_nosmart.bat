rem bat and sql in the same directory
rem set PATH=%PATH%;C:\Program Files\PostgreSQL\9.6\bin
rem base: psql -h %localhost% -p 5432 -U %postgres% -d %qgep% -f 'xy.sql'
rem works for database "qgepe" on localhost

rem add variables dbport, dbdatabase, output file name dbpwd, models

java -jar ../ili2pg-3.12.2.jar --export --trace --log sia_405_abwasser_2015_2_d_exp.log --models SIA405_ABWASSER_2015_LV95 --noSmartMapping --defaultSrsAuth EPSG --defaultSrsCode 2056 --dbhost localhost --dbport 5434 --dbdatabase qgep_prod --dbschema sia405_abwasser_2015_2_d --dbusr postgres --dbpwd sjib sia_405_abwasser_2015_2_d_flue.xtf
pause
rem takes xx sec
