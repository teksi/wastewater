# NO SMART MAPPING (remove usless params)
java -jar 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili2pg-4.4.2\ili2pg-4.4.2.jar' --schemaimport --dbhost 127.0.0.1 --dbusr postgres --dbpwd postgres --dbdatabase ili2pgtest --dbschema ili2pg_nosmart --setupPgExt --createGeomIdx --createFk --createFkIdx --createTidCol --noSmartMapping --defaultSrsCode 2056 --log debug-create.txt --nameLang de 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili\SIA405_Abwasser_2015_2_d-20180417.ili'

# IMPORT VSA_KEK SCHEMA
java -jar 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili2pg-4.4.2\ili2pg-4.4.2.jar' --schemaimport --dbhost 127.0.0.1 --dbusr postgres --dbpwd postgres --dbdatabase ili2pgtest --dbschema ili2pg_vsakek3 --setupPgExt --createGeomIdx --createFk --createFkIdx --createTidCol --importTid --noSmartMapping --defaultSrsCode 2056 --log debug-create.txt --nameLang de 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili\VSA_KEK_2019_2_d_LV95-20210120.ili'

# IMPORT VSA_KEK DATA (fails with NullPointerException)
java -jar 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili2pg-4.4.2\ili2pg-4.4.2.jar' --import --deleteData --dbhost 127.0.0.1 --dbusr postgres --dbpwd postgres --dbdatabase ili2pgtest --dbschema ili2pg_vsakek3 --disableValidation --defaultSrsCode 2056 --createTidCol --trace --modeldir C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\data\testdata_vsa_kek_2019_channel_damage_8486.xtf'

# IMPORT VSA_KEK DATA (data fixed by Matthias)
java -jar 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili2pg-4.4.2\ili2pg-4.4.2.jar' --import --deleteData --dbhost 127.0.0.1 --dbusr postgres --dbpwd postgres --dbdatabase ili2pgtest --dbschema ili2pg_vsakek3 --disableValidation --defaultSrsCode 2056 --createTidCol --trace --modeldir C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\ili 'C:\Users\Olivier\Code\QGEP\qgepplugin\qgepplugin\interlis\data\test_without_abwasserbauwerkref.xtf'
