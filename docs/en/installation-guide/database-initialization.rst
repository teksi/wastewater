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

   If the Restore is failed and the detail reads something like "pg_restore: [archiver] unsupported version (1.13) in file header" try updating your PostgreSQL, see https://stackoverflow.com/questions/49064209/getting-archiver-unsupported-version-1-13-in-file-header-when-running-pg-r

  * Close the Restoring-Window

* Right click the database and click `Refresh`

.. figure:: images/demodata-refresh.jpg

* Propably you want to rename the database: Right click the database, click `Properties...` and rename the database.

There are now 6 `schemas <https://teksi.github.io/wastewater/en/user-guide/layerexplanations/namingconventions.html#schemas-in-the-tww-database>`_ in the database

+ public
+ tww_app
+ tww_cfg
+ tww_od
+ tww_sys
+ tww_vl


Create minimal roles and access
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
There are four default roles in TEKSI databases

- Viewer: Can consult tables and views.
- User: Can edit data.
- Manager: Can edit data and value lists.
- Admin: Database administrator.

.. note:: The TWW roles are defined in the python script https://github.com/TWW/datamodel/blob/master/manage_roles.py. The script requires the pgserviceparser package from OpenGIS https://github.com/opengisch/pgserviceparser/.

You can call the script from the command line in three modes:

* manage_roles.py create_roles --pg_service ${PGSERVICE} --modulename tww --database_specific_roles
* manage_roles.py grant --pg_service ${PGSERVICE} --modulename tww --database_specific_roles --extension_schema foobar
* manage_roles.py revoke --pg_service ${PGSERVICE} --modulename tww --database_specific_roles --extension_schema foobar

The flags are defined as follows:

* ´-m´ or ´--modelname´: Abbreviation of the datamodel (here: tww)
* ´-p´ or ´--pg_service´: Name of the pg_service
* ´-d´ or ´--database_specific_roles´: Optional flag to add database specific roles instead of cluster specific roles.
* ´-x´ or ´--extension_schema´: Optional flag to define the name of the extension schema. Not needed when using create_roles

The database specific group roles are defined as  **tww_viewer_[db_identifier]** etc. , where ``db_identifier`` is defined as ``regexp_replace(databasename, "tww_|teksi_", "")`` .


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

    psql -U postgres -h localhost -p %port% -d %db% -c "REFRESH MATERIALIZED VIEW tww_od.vw_network_node WITH DATA"
    psql -U postgres -h localhost -p %port% -d %db% -c "REFRESH MATERIALIZED VIEW tww_od.vw_network_segment WITH DATA"

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

If you want to use a different SRID, alter the SRID definition.
If you want to alter the role grants, see  `here <https://tww.github.io/docs/installation-guide/database-initialization.html#create-minimal-roles-and-access>`_
