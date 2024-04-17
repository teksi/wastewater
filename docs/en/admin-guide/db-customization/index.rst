Customization of the data model
===============================

This chapter describes the possible customization to the data model.


Introduction
^^^^^^^^^^^^^

The data model is versioned and updates are achieved using Postgres Updates Manager (aka `PUM <https://github.com/opengisch/pum>`_).
The views required to edit the data are automatically generated using `Pirogue <https://github.com/opengisch/pirogue>`_ library.

The combination of both allows to introduce small customizations of the data model such as adding fields to existing base tables or extending views by joining additional tables.

Before going further, we strongly recommend to ask the community if you have any doubts about how to store any information in the database. TWW complies with `SIA 405 <http://www.sia.ch/405>`_ Waste Water and `VSA-DSS <http://dss.vsa.ch>`_ datamodel.


If TWW data model is not able yet to hold some data, please let us know what kind and how it should be handled. TWW data model is a standard proof adaptative model and could follow your needs.

If a customization is still required, the following explanations and rules explain how to adapt TWW data model to your specific needs.


Adding fields
^^^^^^^^^^^^^

It is allowed to add additional fields to tables by naming them as ``usr_…``.

If added in base tables, these additional fields will be automatically added to the views, being an editable field. The views can be re-generated any time using the following command:

``./view/create_views.py --pg_service pg_tww --srid 2056``

.. note:: When running data model upgrades using PUM, it will be required to use the additional option ``--exclude-field-pattern 'usr_%'``




Joining additional tables
^^^^^^^^^^^^^^^^^^^^^^^^^

It is possible to join additional tables to the two main views (``vw_tww_wastewater_structure`` and ``vw_tww_reach``).
This is done by using a YAML definition file for each view and defining a list of joined tables.
Fields of these tables will be joined as read-only fields as they are discarded in edit triggers.
For joining a table to ``tww_od.wastewater_structure``, here is an example:

.. code:: YAML

    joins:
      my_extra_join:
        table: tww_od.my_table
        alias: mt
        prefix: mt_
        skip_columns:
          - field_1
          - field_2
        remap_columns:
          field_3: my_renamed_field
        join_on: mt.fk_ws = ws.obj_id

``table`` and ``join_on`` are mandatory keys, all the others are optional.

This YAML file should be given as a file path when running the script:

``./view/create_views.py --pg_service pg_tww --srid 2056 --tww_wastewater_structure_extra /path_to/extra_ws.yaml``

And similarly for ``vw_tww_reach`` view, by specifying ``tww_reach_extra`` variable to the corresponding YAML file path.

Creating custom views
^^^^^^^^^^^^^^^^^^^^^

It is possible to create custom views and add them to the data model.

In order to allow upgrades of the data model, one should provide a script to create them and one to delete them.
These scripts (SQL or Python) should be placed in a specific path and name them as pre-all.{py,sql} and post-all.{py,sql}.
This path shall be given as argument to PUM when upgrading the data model as a delta directory (see PUM `documentation <https://github.com/opengisch/pum>`_).

If one wants to have these views automatically updated when fields are added the data model, Pirogue can be used to dynamically generate the views. You can take example of the creation of the views in the data model.
