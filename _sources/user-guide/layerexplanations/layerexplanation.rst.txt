.. _layer-explanation:

Layers explanation
==================

Main layers
-----------

TWW is constructed around two main layers :

 * Wastewater structures ``tww_app.vw_tww_wastewater_structure``
 * Reaches ``tww_app.vw_tww_reach``

Wastewater structures ``tww_app.vw_tww_wastewater_structure``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Main layer for manholes, special structures, infiltration installations, discharge points (and wastewater treatment plant (wwtp) structure). Creating a new record in this layer always creates a new wastewater structure, a new cover and a new wastewater node. In the edit form, you have access to a lot of the related tables (e.g. structure parts, maintenance events).

.. figure:: images/schema_vw_tww_wastewater_structure.jpg

Even if there are several covers or wastewater nodes, there is just one point for every wastewater structure in this layer. By default, the position of the wastewater node created first is used as the point coordinate.

.. attention:: Do not export this point coordinates as covers. Use the layer vw_cover for this.

.. versionchanged:: 2025.0

A calculated field ``tww_is_primary`` is available for the user-defined definition of primary wastewater structures. It allows easier definitions of queries, symbologies and labels.


Reaches ``tww_app.vw_tww_reach``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Main layer for line-wastewater structures (channels). Creating a new record in this layer always creates a new reach and a new channel. In the edit form, you have access to a lot of the related tables (e.g. structure parts, maintenance events).

.. figure:: images/schema_vw_tww_reach.jpg

.. versionadded:: 2025.0

* A calculated field ``tww_is_primary`` is available for the user-defined definition of primary wastewater structures. It allows easier definitions of queries, symbologies and labels.

* Create flushing_nozzle on reaches as structure part of the channel.


Layergroup Wastewater Structures
--------------------------------


Wastewater Structures Details ``tww_app.wastewater_structure``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This layer shows and enables you to edit the detailed geometries of wastewater structures. You can add a new detailed geometry using the layer `vw_tww_wastewater_structure` action called digitize detailed geometry.

See `digitizing detailed geometries <../digitizing/digitizingdetailedgeometry.html>`_ for more information.

Additional Wastewater Structures  ``tww_app.vw_tww_additional_ws``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. versionadded:: 2025.0

A layer for the DSS-classes

* small_treatment_plant

* drainless_toilet

* wwtp_structure


Structure Parts ``tww_app.structure_part``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionchanged:: 2025.0

In version 2025.0 are all structure_parts configured in the TWW-project. Because there are many structure parts, they are grouped in layergroups Structure Parts Channel, Structure Parts Manhole and DSSMini Structure Parts.

Cover and flushing nozzle are the only structure parts with a point-geometry itself. All other structure parts are just linked to their wastewater structures and should by only edited by the main layers (`vw_tww_wastewater_structure` and `vw_tww_reach`).

Covers ``tww_app.vw_cover``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use this layer to change the situation of some specific cover (and not the whole wastewater structure) or to add a new cover to an existing wastewater structure. You can add an additional covers in the covers-tab of the `vw_tww_wastewater_structure` too. Additionally, use this layer to show the detailed position of the covers (e.g. in network_plan or pipeline_registry) or to export the cover positions `situation_geometry`.


Channels ``tww_app.mvw_tww_channel``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 2025.0

The channel-class has no geometry. Therefore, mvw_tww_channel is a materialized view that uses the reach line-geometries to work with e.g maintenace_events, that are not connected to reaches, but to channels.

The "old" ``vw_channel`` -layer without geometry still exits beside.

Measuring_point   ``tww_od.measuring_point``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. versionadded:: 2025.0

Just the layermeasuring_point (as part of the measuring subsystem) is added to be able to attribute the measuring_point-log-cards. Other tables of the measuring subsystem are available in the database, but are not configured.

Change Points ``tww_app.vw_change_points``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. versionadded:: 2025.0

A view to visualize the points (wastewater_nodes between to reaches of the same channel), where material or clear_heigth or slope changes.


Organisations ``tww_od.organisation``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

organisation contains the organisation that you can select in attributes like fk_dataowner, fk_operator, fk_provider, fk_owner, etc.

In order to use the organisations efficiently, one can flag an organisation as active using the flag ``tww_active``. This flag filters the organisations accessible from the QGIS project.

 .. figure:: images/od_organisation.jpg

This table is today a little bit hidden in the wastewater_structures group (but it is not only related to wastewater structures).


Layergroup Examination-Maintenance
----------------------------------
.. versionadded:: 2025.0

Visualized maintenance-events with the layers ``tww_app.vw_tww_channel_maintenance`` and ``tww_app.vw_tww_ws_maintenance`` that adds the geometry and the most important attributes of the connected wastewater_structures to the maintenance_event-records.
You can not create new maintenance-events with this views, but you can edit attributes, symbolize and export


Maintenance events ``tww_app.vw_tww_maintenance``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Maintenance events can be created through the view tww_od.vw_tww_maintenance.

These maintenance events are used in the maintenance tabs in the main tables. They can be linked to one or several wastewater structures.

See `editing maintenance events <../editing/maintenance_events.html>`_ for more information.


Bio_Ecol_Assessment ``tww_app.vw_bio_ecol_assessment``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. versionadded:: 2025.0

A subclass of Maintenance_event

Create the bio_ecol_assessments in the main tables (discharge points in vw_tww_wastewater_structure) and visualize it in vw_tww_ws_maintenance.


Documents
----------
.. versionchanged:: 2025.0

Documents have now there own layergroup (before in layergroup Wastewater Structures)


Hydraulic
---------

Wastewater nodes ``tww_app.vw_wastewater_node``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use this layer to change the situation of one selected wastewater node (and not the whole wastewater structure) or if you want to add a new wastewater node to an existing wastewater structure. You can add additional wastewater nodes in the wastewater nodes-tab of the `vw_tww_wastewater_structure` too.

Overflow tables ``tww_app.vw_tww_overflow``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use this layer to create and symbolize overflows.

Layergroups Connection Object, Measures, Log Card, Rural
---------------------------------------------------------
.. versionadded:: 2025.0

Since these layers where not available in DSS 2015, they have not been in the tww version 2024.

All DSS-tables are now configured in TWW.


Catchment ``tww_app.vw_tww_catchment_area``
----------------------------------------------

Main layer to digitize and edit the catchment_areas. Layers catchment_connection lines do just visualize the connections. They are not editable.

.. versionchanged:: 2025.0

The fk-fields to connect to the log cards are know configured.


Topology
--------

Nodes ``tww_app.vw_network_node`` and segments ``tww_app.vw_network_segment``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These two layers are used by the tww-extension for the network-following functionalities.
Use the vw_network_segment layer to show the flow direction, if you use a markerline (filled_arrowhead) as symbol.

See `connect wastewater network elements <../editing/connect_wastewater_network_elements.html>`_ for more information on how to create and maintain a good topology.


Value Lists ``tww_vl.*``
-------------------------

These value lists are defined in the VSA-datamodel. Do not change.

.. versionchanged:: 2025.0

In VL Channel channel_function_hierarchic are now special tww_fields (symbology_order, is_primary, use_in_labels) to configure labels and help the user to customize his project.
