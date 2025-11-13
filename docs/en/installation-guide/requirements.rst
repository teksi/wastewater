.. _requirements:

Requirements
=======================

Provider Side
----------------

In order to install the TEKSI Wastewater module, you will need to install :

* A PostgreSQL instance with PostGIS extension (check the `roadmap <https://github.com/teksi/Home/wiki/TEKSI-modules-releases-and-roadmap>`_ for supported versions)

.. note::
    TEKSI Wastewater uses a PostgreSQL with postgis Extension database, you need to install these on your server :
    Recommended is to use the `EnterpriseDB <https://www.enterprisedb.com/downloads/postgres-postgresql-downloads>`_ to make sure your
    postgreSQL version matches your postgis version and is installed at the right place.

* Python 3.12+ (installed via OSGEO4W or using `python.org <https://www.python.org/downloads/>`_)
* QGIS installed with the latest LTR version
    Recommanded is to install it with the OSGEO4W installer directly with all python packages listed.
* A working pg_service file and a connexion secured to your database server (hosted or local)
* TEKSI Module Management Tool (`TMMT <https://plugins.qgis.org/plugins/teksi_module_management_tool>`_) plugin installed from the QGIS plugin repository

The following Python packages (installed via OSGEO4W or using `pip <https://pypi.org/project/pip/>`_) are required:

* `Psycopg <https://www.psycopg.org/>`_ as database adapter
* `Pydantic <https://pydantic.dev/>`_ for data validation
* `Pirogue <https://github.com/opengisch/pirogue>`_ for model generation and upgrades

.. note::
    PUM python package is automatically installed with the TMMT plugin.

Client Side
----------------

For each client (workstation), you will need :

* QGIS installed with the latest LTR version
    Recommanded is to intall it with the OSGEO4W installer directly with all python packages listed.
* A working pg_service file and a connexion secured to your database server (hosted or local)
* TEKSI Wastewater `plugin <https://github.com/teksi/wastewater/releases/latest/>`_ (.zip file)
* TEKSI Wastewater `project <https://github.com/teksi/wastewater/releases/latest/>`_ (.qgs file)

The following Python packages (installed via OSGEO4W or using `pip <https://pypi.org/project/pip/>`_) are required:

* `Psycopg <https://www.psycopg.org/>`_ as database adapter
* `sqlalchemy <https://github.com/sqlalchemy/sqlalchemy>`_ for INTERLIS imports and exports
* `geoalchemy2 <https://github.com/geoalchemy/geoalchemy2>`_ for INTERLIS imports and exports

PostgreSQL Server side :
-------------------

Allow the connexion of your clients through the `postgresql.conf` file and make sure your client
is allowed to reach the server postgresql port (default is 5432).

TEKSI Wastewater requires PostGIS functions that did not function properly in a set of releases:

* Versions before PostGIS 3.2 are not affected
* When using PostGIS 3.2, the bug is fixed in Version 3.2.7
* When using PostGIS 3.3, the bug is fixed in Version 3.3.6
* When using PostGIS 3.4, the bug is fixed in Version 3.4.2
* Versions of PostGIS 3.5 or later are not affected
