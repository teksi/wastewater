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

* Create a new database with UTF8 encoding

E.g. `tww_demo`, avoid spaces, dots, uppercases and special characters
As proposed in https://stackoverflow.com/questions/2878248/postgresql-naming-conventions


Create  minimal roles and access
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TWW can be installed per database cluster using the new TEKSI Module Management Tool. They only have to be installed once!

See the current `TMMT Documentation for a step by step help <https://github.com/teksi/TMMT/discussions/34>`_


.. note::

It is highly recommended to use these when using TWW in a production environment.

.. _install-datamodel-demodata:

Install data model with or without demodata
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. info:: Demodata is available as an option during the setup process with TMMT. You can select to add demodata or leave this.

See the current `TMMT Documentation for a step by step help <https://github.com/teksi/TMMT/discussions/34>`_

After you have setup successfully the database with or without demodata, you can check the schemata via pgAdmin

There will be 6 `schemas <https://teksi.github.io/wastewater/en/user-guide/layerexplanations/namingconventions.html#schemas-in-the-tww-database>`_ in the database

+ public
+ tww_app
+ tww_od
+ tww_sys
+ tww_vl
+ pg2ili_abwasser


- Viewer: Can consult tables and views.
- User: Can edit data.
- Manager: Can edit data and value lists.
- Admin: Database administrator.
