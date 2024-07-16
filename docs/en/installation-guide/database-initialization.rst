.. _database-initialization:

Database initialization
=======================

You can use :ref:`pgAdmin` to access and manage the database server.

.. note::

 By clicking the link you can learn how to :ref:`install-pgAdmin`

Process
-------

In pgAdmin4

* Connect to the database server

* Create a new database with UTF8 encoding (e.g. `tww_prod`).

.. _restore-demomodel:

Restore demo datamodel
^^^^^^^^^^^^^^^^^^^^^^

Restore the latest data model that also includes demo data:

* Download demo data
  * https://github.com/teksi/wastewater/releases/latest
  * download `tww_vx.y.z_structure_and_demo_data.backup`

Back in pgAdmin :

* Right click the `tww_prod` database

  * Click `Restore`

  * Load your download of tww_vx.y.z_structure_and_demo_data.backup


  .. figure:: images/demodata-restore.jpg

  * Click the `Restore Options` Tab and check these options


  .. figure:: images/demodata-restore_options.jpg

  * Click `Restore`

  * Check whether in Message window `Restoring backup on the server` is successfully completed.

.. note::

   If the Restore is failed and the detail reads something like "pg_restore: [archiver] unsupported version (1.13) in file header" or in German "pg_restore: [Archivierer] nicht unterstützte Version (1.13) im Dateikopf" try updating your PostgreSQL, see https://stackoverflow.com/questions/49064209/getting-archiver-unsupported-version-1-13-in-file-header-when-running-pg-r

  * Close the Restoring-Window

* Right click the database and click `Refresh`

.. figure:: images/demodata-refresh.jpg

* Propably you want to rename the database: Right click the database, click `Properties...` and rename the database.

There are now 7 schemas in the database (public, tww_import, tww_network, tww_swmm, tww_od, tww_sys, tww_vl)

Create  minimal roles and access
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: The TWW roles are defined in the https://github.com/TWW/datamodel/blob/master/12_0_roles.sql (per cluster) and https://github.com/TWW/datamodel/blob/master/12_1_roles.sql (per database) files. It is recommended to use these when using TWW in a production environment.

Copy paste and run the two .sql one after the other in the query editor of pgAdmin4 (Tools > Query Tool).

Empty data model
^^^^^^^^^^^^^^^^

You also have the option to restore the latest empty data model (no demo data).

* Download the data model by going to https://github.com/teksi/wastewater/releases/latest
  and by downloading the latest `tww_vx.y.z_structure_with_value_lists.sql`.

.. note::

 If you run the sql in a :ref:`SQL-query` Window, you will get an error. You have to use a BAT-File.

* Use a BAT-File like that, to create the database, the extensions and the schemas with valuelist  (replace x.y.z with your version)::

    @echo off

    set filename="tww_vx.y.z_structure_with_value_lists.sql"

    if not exist %filename% (
       echo "File %filename% does not exist. Please download the latest datamodel from https://github.com/TWW/datamodel/releases (structure_with_value_lists.sql) and adjust filename in this batch file."
       PAUSE
       exit -1
    )

    set /p db="Please enter the database name? (e.g. tww_community) "
    set /p password="Please enter the password for user postgres? "

    set port=5432
    set PATH=%PATH%;C:\Program Files\PostgreSQL\12\bin
    set PGPASSWORD=%password%

    createdb -U postgres -p %port% %db%

    psql -U postgres -h localhost -p %port% -d %db% -f %filename%
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA public TO ""tww"""
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA tww_vl TO ""tww"""
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA tww_od TO ""tww"""
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA tww_import TO ""tww"""
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA tww_swmm TO ""tww"""
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON SCHEMA tww_sys TO ""tww"""

    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tww_od TO ""tww""";
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tww_swmm TO ""tww""";
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tww_import TO ""tww""";
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT ON ALL TABLES IN SCHEMA tww_vl TO ""tww""";
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT ON ALL TABLES IN SCHEMA tww_sys TO ""tww""";
    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO ""tww"""

    psql -U postgres -h localhost -p %port% -d %db% -c "GRANT USAGE ON ALL SEQUENCES IN SCHEMA tww_od TO ""tww"""

    psql -U postgres -h localhost -p %port% -d %db% -c "REFRESH MATERIALIZED VIEW tww_od.vw_network_node"
    psql -U postgres -h localhost -p %port% -d %db% -c "REFRESH MATERIALIZED VIEW tww_od.vw_network_segment"

    PAUSE


.. note::

 You are free to choose any database name.

* Update privileges for the tww_od, tww_sys, tww_vl, tww_network, tww_import, tww_swmm schema as described in the chapter `Create  minimal roles and access`.


Generate the data model under Linux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also generate the data model under Linux.

* Download the data model::

   git clone https://github.com/TWW/datamodel
   cd datamodel

* Setup the ``pg_service.conf`` file and add the ``pg_tww`` service
  as in the :ref:`pg_service-linux` section.

* Create the database::

   psql -U postgres -c 'CREATE DATABASE tww;'

* Run the generation script::

   ./scripts/db_setup.sh

If you want to use a different SRID you need to use the ``-s`` option.
For instance, run ``./scripts/db_setup.sh -s 2056`` for the **2056** SRID.

If you already have a data model and you want to force the regeneration
of the model you can also use the ``-f`` option: ``./scripts/db_setup.sh -f``.

You can use the ``-r`` option to add roles (``tww_viewer``, ``tww_user``, ``tww_manager``, ``tww_sysadmin``).

- Viewer: Can consult tables and views.
- User: Can edit data.
- Manager: Can edit data and value lists.
- Admin: Database administrator.
