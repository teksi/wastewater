.. initialize-extensions:

Initialising Database extensions
=======================

TEKSI Wastewater maintains database extensions to serve the following models:

* AG-64 Abwasserkataster Version 2.1.0

* AG-96 Genereller_Entwaesserungsplan_AG Version 2.0.0


.. _empty-extension-model:

create an empty datamodel with an extension
^^^^^^^^^^^^^^^^^^^^^^

In order to use a database extension, we need to load them from the source code:

* Load a standard TWW Database
  * https://github.com/TWW/datamodel/releases/latest
  * download `tww_{version}_structure_with_value_lists.sql`

In the future, an adapted value list sql will be provided. For now, we will have to rely on the source code

* Download the source code
  * https://github.com/TWW/datamodel/releases/latest
  * download`Source Code(zip)`

* install pirogue if necessary: pip install pirogue

* if needed, temporarily alter your PGSYSCONFDIR environment variable

* create and run a batch file such as::

    @echo off

    set /p tww_dir="Set the directory your downloaded teksi wastewater to"

    if not exist %tww_dir% (
       echo "Path %tww_dir% does not exist. Please download the latest datamodel from https://github.com/TWW/datamodel/releases (structure_with_value_lists.sql) and adjust path in this batch file."
       PAUSE
       exit -1
    )

    pip install pirogue

    set /p myservice="Please enter the service name? (e.g. tww_community) "

	python %tww_dir%\extensions\extension_manager.py --pg_service %myservice% --srid 2056 --drop-schema --extension_name "agxx"
	python %tww_dir%\app\create_app.py --pg_service %myservice% --srid 2056 --drop-schema


    PAUSE



Generate the data model under Linux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also generate the data model extension under Linux.

* Download the data model::

   git clone https://github.com/TWW/datamodel
   cd datamodel

* Setup the ``pg_service.conf`` file and add the ``pg_tww`` service
  as in the :ref:`pg_service-linux` section.

* Create the database::

   psql -U postgres -c 'CREATE DATABASE tww;'

* Set the environment variables for the generation script::

   ./scripts/db_setup.sh

* Run the generation script::

   ./scripts/db_setup.sh
