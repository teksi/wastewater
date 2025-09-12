.. _security:

User Roles
==========

TWW comes with a set of predefined roles for a multi user configuration.

The base installation of TWW defines the following group roles :

* **tww_viewer**: has the rights for project consultation, can select entities of TWW, view values lists.
* **tww_user**: main TWW user, can edit entities (`tww_od` schema), view values lists. On PostgreSQL < 17, materialized views in `tww_app` schema are owned by `tww_user` to allow updating them.
* **tww_manager**: user of TWW with extended privileges, can edit entities and values lists (`tww_vl` schema).
* **tww_sysadmin**: superuser of TWW database, can edit TWW system tables (`tww_sys` schema).

Data in TWW are stored in 3 schemas with default permissions for all of these users.

.. Note:: The SQL related to these roles is stored `here <https://github.com/teksi/wastewater/tree/main/datamodel/12_0_roles.sql>`_ and `here <https://github.com/teksi/wastewater/tree/main/datamodel/12_1_roles.sql>`_
