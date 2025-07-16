Customization of the data model
===============================

This chapter describes the possible customization to the data model.

Alterations to ordinary data
---------------

Introduction
^^^^^^^^^^^^^

The data model is versioned and updates are achieved using Postgres Updates Manager (aka `PUM <https://github.com/opengisch/pum>`_).
The views required to edit the data are automatically generated using `Pirogue <https://github.com/opengisch/pirogue>`_ library.

The combination of both allows to introduce small customizations of the data model such as adding fields to existing base tables or extending views by joining additional tables.

Before going further, we strongly recommend to ask the community if you have any doubts about how to store any information in the database. TWW complies with `SIA 405 <http://www.sia.ch/405>`_ Waste Water and `VSA-DSS <https://www.vsa.ch/models/>`_ datamodel.

If the TWW data model is not yet able to hold some data, please let us know what kind and how it should be handled.
The TWW data model is a standard proof adaptative model and could follow your needs.

If a customization is still required, the following explanations and rules explain how to adapt TWW data model to your specific needs.

Altering symbology and labelling behaviour
^^^^^^^^^^^^^

Symbology and labelling behaviour depends on the value lists `` tww_vl.channel_usage_current`` and `` tww_vl.channel_function_hierarchic``  These two value list tables have an additional column ``tww_symbology_order``, which is used to define the hierarchy of the symbology.

For labelling, one can use the column `` tww_vl.channel_function_hierarchic.tww_use_in_labels`` to define which functions_hierarchic are taken into account when creating a wastewater structure's label.

Creation of custom tables
^^^^^^^^^^^^^

It is possible to add custom tables with ordinary data. They must be stored in ``tww_od``. In order to version them, use the Postgres Updates Manager (aka `PUM <https://github.com/opengisch/pum>`_).

Adding fields to base tables
^^^^^^^^^^^^^

Instead of adding additional fields to base tables, it is advised to create a new table with a foreign key linking it to the base table using `PUM <https://github.com/opengisch/pum>`_.

Datamodel updates
^^^^^^^^^^^^
.. attention:: The process of updating the database is currenty being overhauled. The following information can therefore change before the next release


Adding fields and tables
""""""""""""""""""""""""

In order to allow upgrades of the data model, one should provide a script to create them and one to delete them.
These scripts (SQL or Python) should be placed in a specific path and name them as pre-all.{py,sql} and post-all.{py,sql}.
This path shall be given as argument to PUM when upgrading the data model as a delta directory (see PUM `documentation <https://github.com/opengisch/pum>`_).

If one wants to have these views automatically updated when fields are added the data model, Pirogue can be used to dynamically generate the views. You can take example of the creation of the views in the data model.

.. attention:: It is discouraged to add additional fields to base tables that are defined by TEKSI Wastewater, as they can interfere with datamodel updates.
If it is necessary to add custom fields, create a separate table with a foreign key pointing to the TEKSI base table and join it to the base views.


Modification Framework for application schema
---------------

In order to add app modifications to TEKSI in a standardised way, TEKSI wastewater set into place an modification framework.

There are two types of modification:

* Official TEKSI Wastewater modification
* custom modification

The modification framework allows the following actions:

* Adding additional views using sql
* Adding additional triggers using sql
* Activating/deactivating value list items
* Joining additional tables to views

.. attention:: The modification framework is not intended for alterations on the schema ``tww_od``. Use PUM functionalities instead

Creation and loading of modifications
^^^^^^^^^^^^^
All modification parameters are handles in a yaml that is passed to PUM `documentation <https://github.com/opengisch/pum>`_ on update.
The the default yaml is

.. literalinclude:: ../../../../datamodel/app/app_modification.template.yaml
  :language: YAML

The yaml handles the following parameters:


Base Configurations
"""""""""""""""""""

Base Configurations handle variables that are handled over the entire project. Those parameters are exposed in TMMT as well, but when passing a yaml definition, they are overridden

.. list-table:: Base Configurations
   :widths: 25 75
   :header-rows: 1

   * - Parameter
     - Description
   * - ``lang_code``
     - Specifies the language code used for web-optimised views. Expected value is a language code string. Defaults to "en".
   * - ``SRID``
     - Specifies the Spatial Reference System Identifier. Expected value is an integer representing the SRID,  Defaults to 2056.

Extra Definitions
"""""""""""""""""

Extra definitions allow adding additional fields to custom views.
The parameter defines the path to the corresponding yaml definition.
The yaml is structured as follows:

.. code:: YAML

    joins:
      my_extra_join:
        table: tww_od.my_table
        alias: mt
        prefix: mt_
        skip_columns:
          - field_1
          - field_2
        remap_columns_select:
          field_3: my_renamed_field
        remap_columns:
          field_3: my_renamed_field
        join_on: mt.fk_ws = ws.obj_id
		read_only: false

``table`` and ``join_on`` are mandatory keys, all the others are optional.
``read_only`` defaults to true. ``remap_columns`` is used on insert and update, ``remap_columns_select`` on Select.
Entries that are in ``skip_columns`` but listed in ``remap_columns`` are not skipped on insert and update.
It is expected that mt.fk_ws has a ON DELETE CASCADE`` foreign key constraint.


Multiple Inheritances
"""""""""""""""""""""

Multiple Inheritances are used to aggregate all subtypes of a superclass into one view.
The parameter defines the path to the corresponding yaml definition.
The yaml is structured as follows:


.. code:: YAML

	table: tww_od.overflow
	view_name: vw_tww_overflow
	view_schema: tww_app
	allow_type_change: True
	allow_parent_only: false
	pkey_default_value: True

	additional_columns:
	  geometry: n1.situation3d_geometry
	  my_column: nt.foobar
	additional_joins: >
	  LEFT JOIN tww_od.wastewater_node n1 ON overflow.fk_wastewater_node::text = n1.obj_id::text
	  LEFT JOIN tww_od.my_table mt ON overflow.obj_id::text = mt.baz::text

	joins:
	  leapingweir:
		table: tww_od.leapingweir

	  prank_weir:
		table: tww_od.prank_weir

	  pump:
		table: tww_od.pump


Simple Joins YAML
"""""""""""""""""

The Simple Join YAML allows altering the path from which the join definition is loaded.
The parameter defines the path to the corresponding yaml definition.
The yaml is structured as follows:

.. code:: YAML

	view_name: vw_export_wastewater_structure
	view_schema: tww_app
	table: tww_app.vw_tww_wastewater_structure
	pkey: obj_id

	joins:
	  cover_shape:
		table: tww_vl.cover_cover_shape
		fkey: co_shape
		prefix: cover_shape_
	[...]


Modification Repositories
"""""""""""""""""""""""""

.. list-table:: Modification Repositories
   :widths: 25 75
   :header-rows: 1

   * - Parameter
     - Description
   * - ``id``
     - Unique identifier for the modification repository.
   * - ``active``
     - Boolean indicating if the modification repository should be activated.
   * - ``reset_vl``
     - Boolean indicating if the value list entries treated by reset_vl_files should be reset.
   * - ``template``
     - Path to the template configuration file.
   * - ``variables``
     - Dictionary of variables with their values and types. Overridden by ``template``
   * - ``sql_files``
     - List of SQL files to be executed. Overridden by ``template``
   * - ``reset_vl_files``
     - List of SQL files for activating/deactivating value list entries. Activates/deactivates based on the ``active`` setting. Overridden by ``template``

Modification Repository Templates
"""""""""""""""""""""""""

A modification repository template allows to predefine the values of the following repository flags:

* ``variables``
* ``sql_files``
* ``reset_vl_files``

Additionally, it allows setting values for Extra Definitions, MultipleInheritances and SimpleJoin YAML if the app_modification yaml does not define a value.


Limitations for sql scripts
^^^^^^^^^^^^^

The sql scripts must only be used for the following purposes:

* Adding additional views to the application schema
* Adding additional ``INSTEAD OF`` triggers to the application schema
* Adding additional triggers to populate od tables that are not part of the VSA-DSS datamodel
* Activating/deactivating items to value lists

Note that the sql must not be used to create new tables in ``tww_od``. Use `PUM <https://github.com/opengisch/pum>`_ for these cases.

Please note that these scripts are re-run on every datamodel update.
They must therefore be written in such a way that existing data does not interfere with them (i.e. using ``CREATE OR REPLACE VIEW`` or ``ON CONFLICT DO NOTHING``).
