rem bat and sql in the same directory
set PATH=%PATH%;C:\Program Files\PostgreSQL\9.3\bin
rem base: psql -h %localhost% -p 5432 -U %postgres% -d %qgep% -f 'xy.sql'
rem works for database "qgepe" on localhost


rem set variable to ili2pg*.jar, dbdatabase, dbpwd, ilipath, xtf path etc.

java -jar ili2pg.jar --export --trace --log vsa_dss_2015_2_d_391_exp.log --models DSS_2015 --noSmartMapping --dbhost localhost --dbport 5432 --dbdatabase postgres --dbschema vsa_dss_2015_2_d_391 --dbusr postgres --dbpwd yourpassword vsa_dss_2015_2_d_391_exp.xtf
pause
rem takes xx sec
