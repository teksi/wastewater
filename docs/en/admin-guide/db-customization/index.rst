Customization of the data model
===============================

This chapter describes the possible customization to the data model.


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


Extension Framework
^^^^^^^^^^^^^

In order to add extensions to TEKSI in a standardised way, TEKSI wastewater set into place an extension framework. It allows the following actions:

# Adding additional views using sql or py
# Adding additional triggers using sql or py
# Adding additional items to value lists
# Joining additional tables to views

.. attention:: The extension framework is not intended for alterations on the schema ``tww_od``. Use PUM functionalities instead

Creation of custom extensions
"""""""""""""""""""""""""""""""
Extensions are handled in the ``extensions`` folder of the datamodel. In order to import a custom extension, the source code needs to be extended.

# download the datamodel source code
# in ``datamodel\app\extensions`` there is a yaml file ``config.yaml`` that allows setting three variables:
  # an extension id that is used to access the extension
  # a directory name in which all extension data lies
  # a variables dictionary

After adding an entry for your extension, it can be accessed in deployment. Inside the folder defined in the ``directory`` variable, there can be three types of files:

# python scripts
# sql scripts
# yaml files

Python scripts are run before sql scripts, while the yaml files are used to override or extend view definitions.


Deployment of custom extensions
"""""""""""""""""""""""""""""""

A predefined extension can be loaded using

``python -m .app.create_app.py --pg_service pg_tww --drop-schema --srid 2056 --extensions extension_id_1 foo bar``

On creation of the application schema, the order of creation of objects is as follows:

# TWW functions
# Extensions in the order inside the ``--extensions`` flag
  # python scripts
  # sql scripts
# Single Inheritances
# Multiple inheritances (can be overridden by extension yaml)
# Main views (can be extended by extension yaml)
# Simple join views (can be overridden by extension yaml)
# TWW sql scripts
# default values and triggers relating to app functions
# post-all sql scripts

Overriding yaml view definitions
""""""""""""""""""""""""""""""""
There two types of views that are defined over a yaml definition: MultipleInheritances and SimpleJoins.
The views currently defined in this way are found in the `multipleinheritance <https://github.com/teksi/wastewater/tree/main/datamodel/app/view/multipleinheritance>`_ and `simplejoins <https://github.com/teksi/wastewater/tree/main/datamodel/app/view/simplejoins>`_ folder.

For overriding the definition of a MultipleInheritance such as ``tww_app.vw_tww_overflow``, here is an example file ``tww_overflow.yaml``:

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

A SimpleJoin definition looks like this

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


Extending main views
""""""""""""""""""""

It is possible to join additional tables to the main views ( i.e. ``vw_tww_wastewater_structure`` and ``vw_tww_reach``).
This is done by using a YAML definition file for each view and defining a list of joined tables.
Note that fields of these tables will be joined as editable fields.
For joining a table to ``tww_app.vw_tww_wastewater_structure``, here is an example:

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
``read_only`` defaults to true. ``remap_columns`` is used on insert and update.
`It is expected that mt.fk_ws has a ON DELETE CASCADE`` foreign key constraint.
The yaml file needs to be called ``vw_tww_wastewater_structure.yaml``.


Creating custom views
"""""""""""""""""""""

It is possible to create custom views and add them to the data model.
Simply create an extension folder, place the sql or py script inside and add the ``--extensions`` flag
Please note that these scripts are re-run on every datamodel update.

Adding custom triggers
""""""""""""""""""""

It is possible to create custom views and add them to the data model.
Simply create an extension folder, place the sql or py script inside and add the ``--extensions`` flag
Please note that these scripts are re-run on every datamodel update.


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

Altering symbology and labelling behaviour
^^^^^^^^^^^^^

Symbology and labelling behaviour depends on the value lists `` tww_vl.channel_usage_current`` and `` tww_vl.channel_function_hierarchic``  These two value list tables have an additional column ``tww_symbology_order``, which is used to define the hierarchy of the symbology.

For labelling, one can use the column `` tww_vl.channel_function_hierarchic.tww_use_in_labels`` to define which functions_hierarchic are taken into account when creating a wastewater structure's label.



Adding fields
^^^^^^^^^^^^^






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


Creating custom views or triggers
"""""""""""""""""""""""""""""""""

It is possible to create custom views or triggers and add them to the data model.
Simply create an extension folder, place the sql or py script inside and add the ``--extensions`` flag to the ``create_app`` call

.. attention:: These scripts are re-run on every datamodel update.
