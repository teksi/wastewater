.. _security:

User Roles
==========

TWW comes with a set of predefined roles for a multi user configuration.

The base installation of TWW defines the following group roles over the entire database cluster:

* **tww_viewer**: has the rights for project consultation, can select entities of TWW, view values lists.
* **tww_user**: main TWW user, can edit entities (`tww_od` schema), view values lists.
* **tww_manager**: user of TWW with extended privileges, can edit entities and values lists (`tww_vl` schema).
* **tww_sysadmin**: superuser of TWW database, can edit TWW system tables (`tww_sys` schema).

There is an option to create database specific group roles **tww_viewer_[db_identifier]** etc. , where  ``db_identifier`` is defined as ``regexp_replace(databasename, "tww_|teksi_", "")`` .

In order to create them, run the `create_roles script <https://github.com/TWW/datamodel/blob/master/create_roles.py>` from the shell or a batch file using the "--database_specific_roles" flag.

If you have set up a database extension schema, using the "--extension_schema myschema" flag on the create roles script creates the same grant on the extension schema as on ´tww_od´.