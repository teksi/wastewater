set db=qgep_gruner
set port=5432
rem set PATH=%PATH%;C:\Program Files\PostgreSQL\9.6\bin
set PATH=%PATH%;C:\Program Files\PostgreSQL\12\bin

rem db erzeugen
rem createdb -U postgres -p %port% %db%
psql -U postgres -h localhost -p %port% -d %db% -f 01_abwa_2015neu_3122_tid_generate.sql> 01_tid_generate.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 02_abwa_2015neu_3122_identifier_lookup.sql> 02_identifier_lookup.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 02_abwa_2015neu_3122_objid_lookup.sql> 02_objid_lookup.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 02_abwa_2015neu_3122_tid_lookup.sql> 02_tid_lookup.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 046_abwa_2015neu_3122_t_key_object_insert_metadata.sql> 046_t_key_object_insert_metadata.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 050_abwa_2015neu_3122_import_vw_sia405_baseclass_metattribute.sql> 050_vw_sia405_baseclass_metattribute.log 2>&1
PAUSE

-- rem neu 12.7.2019
psql -U postgres -h localhost -p %port% -d %db% -f abwa_2015neu_3122.vw_organisation.sql> abwa_2015neu_3122.vw_organisation.log 2>&1
PAUSE


psql -U postgres -h localhost -p %port% -d %db% -f 053_create_key_object_seq.sql> 053_create_key_object_seq.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 054_create_function_meta_organisation_ohne_subclass_20190711.sql> 054_create_function_meta_organisation_ohne_subclass_20190711.log 2>&1
PAUSE

psql -U postgres -h localhost -p %port% -d %db% -f 055_select_meta_organisation_bezeichnung_obj_id_flue.sql> 055_select_meta_organisation_bezeichnung_obj_id.log 2>&1
