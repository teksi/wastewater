History viewer
==============

`PostgresSQL history viewer <https://github.com/qwat/pg-history-viewer>`_ plugin allows you to retrieve modification on the TWW database.

Install the plugin from the QGIS Plugin repository.

.. image:: img/history_viewer_plugin.jpg


Plugin configuration
--------------------

.. image:: img/history_viewer_menu.jpg

First, you have to configure the plugin for the session like this:

.. image:: img/pg_hv_configuration.png


Database configuration
----------------------

Then you need to enable logging on desired tables or views.

* For views::

   SELECT tww_sys.audit_view('tww_od.vw_tww_wastewater_structure', 'true'::boolean, '{}'::text[], '{obj_id}'::text[]);

* For tables::

   SELECT tww_sys.audit_table('tww_od.reach_point');

.. note::

 You can disable logging with::

   SELECT tww_sys.unaudit_view('tww_od.vw_tww_wastewater_structure');
   SELECT tww_sys.unaudit_table('tww_od.reach_point');

Usage
-----

The "logged events" window is composed of 4 parts.

.. image:: img/pg_hv_history.png

- 1. Part identifying the tools used to filter modifications in the database.
- 2. Logged events with the modification date, the table, the action type "Update/Delete/Insert", the application and the user who made the modification.
- 3. The view comparing the data before and after the change. The red lines are the ones modified.
- 4. If the geometry has been modified, a canvas will show the difference.

Replay function
---------------

If you have configured the replay option, you can replay actions. Example below:

Actual value:

.. image:: img/pg_hv_replay_before.png

Select the event you want to replay and its values will become the current ones. Example for the year that becomes 2004 again:

.. image:: img/pg_hv_replay_after.png
