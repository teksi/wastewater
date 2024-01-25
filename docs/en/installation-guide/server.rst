Setup database server
=====================

If you expect to access the data from several different workstations, you can
install the database on a network accessible server. If it is just a single
desktop you are working on, this can be installed on the same machine.

Required Software
-----------------

Server installation
~~~~~~~~~~~~~~~~~~~

* Install PostgreSQL (>=9.6)

  * `Download page <http://www.postgresql.org/download>`_

* Install PostGIS (>=2.4)

  * E. g. by using the (Application) Stack Builder shipped with the EnterpriseDB version of posgreSQL on Windows and macOS
  
.. note::

 The following instructions are **optional**:
 
 In a single desktop environment (no network database server) you can setup
 your database to trust local connections.

 This way, the database won't ask for a password if you're connecting from your
 local workstation while no password is written  anywhere. You even can do
 with no database password at all.

 This can be done by editing the database access configuration file
 `pg_hba.conf <http://www.postgresql.org/docs/devel/static/auth-pg-hba-conf.html>`_
 and set the auth-options from ``md5`` to ``trust``. A database service reload
 is required to activate changes.

To optimise RAM size etc. of your machine postgreSQL is running on you can use `pgtune <http://www.pgtune.leopard.in.ua/#/>`_. Adapt your postgresql.conf file.
