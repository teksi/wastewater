.. _productionreadiness:

Prepare database for production
==========

OID Prefix Settings
-----

To prepare the database to be production ready change the active prefix in the tww_sys.oid_prefixes table to your project. If needed add your project prefix to that table first. Make sure only one prefix is set to active.

.. figure:: images/tww_sys.oid_prefixes.png

Else the new 'Database production ready check' will throw a CRITICAL error.


Setting Default Values
-----

See :ref:`settingdefaultvalues` in the User Guide - How to Chapter