rem choose your database name
set db=qgep_prod
rem adapt port of your database
set port=5434
rem adapt postgres path to your system
set PATH=%PATH%;C:\Program Files\PostgreSQL\9.6\bin

rem db erzeugen
rem createdb -U postgres -p %port% %db%
psql -U postgres -h localhost -p %port% -d %db% -f 01_vsa_dss_2015_2_d_tid_generate.sql> 01_tid_generate.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 02_vsa_dss_2015_2_d_tid_lookup.sql> 02_tid_lookup.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 046_vsa_dss_2015_2_d_t_key_object_insert_metadata.sql> 046_t_key_object_insert_metadata.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 050_vsa_dss_2015_2.vw_sia405_baseclass_metattribute.sql> 050_vw_sia405_baseclass_metattribute.log 2>&1
PAUSE

-- rem neu 12.7.2019
psql -U postgres -h localhost -p %port% -d %db% -f vsa_dss_2015_2_d.vw_organisation.sql> vsa_dss_2015_2_d.vw_organisation.log 2>&1
PAUSE

rem neu 15.8.2019
psql -U postgres -h localhost -p %port% -d %db% -f 022_vsa_dss_2015_2_d_basket_update.sql > 022_vsa_dss_2015_2_d_basket_update.log 2>&1
PAUSE
