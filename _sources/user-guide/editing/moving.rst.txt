.. _moving-covers-with-reaches-and-wastewater-nodes:

Moving Wastewater Structures with Reaches, Covers and Nodes
===========================================================

This represents a guide on how to move wastewater structures with reaches and wastewater nodes compared to just moving the cover in TWW.

General
------------

It's not unusual, that manholes are digitized the first time with low precision. Later the manholes are measured, and there is the need, to move the whole wastewater structure (means cover, node and reachpoints of all reaches) to the measured point.

.. note:: You need to turn on the advanced digitizing toolbar in your project to be able to select the **Move Feature** tool.

.. figure:: images/advanced_digitizing_tools.jpg


How to
------------

* Select the **vw_tww_wastewater_structure** layer
* Set the layer to edit mode
* Select the **Move Feature** tool (standard QGIS tool in the advanced digitizing toolbar)

.. figure:: images/moving_wws_before.jpg

* Left Click one the wastewater_structure you want to move and left click again at the new place.

In the figure below, there is the 'ZB1' manhole moved. Cover, node and all tree reachpoints are moved to the new place.

.. figure:: images/moving_wws_manhole1.jpg

.. note:: Reaches, that are connected to one of the moved reaches, are still connected with the foreign key, but did not move. You have to corrected manually if necessary.

* In the next figure, the special structure 'ZRAE' is also moved by clicking on the cover and clicking at the new place.

.. figure:: images/moving_wws_manhole2.jpg

.. note:: The 2 nodes of the special structure and the 3 connected reachpoints (reaches) are also move with the same distance and in the same direction as the cover is moved. The wastewater structure area (polygon) is not moved. You have to correct manually if necessary.

* If you want to move just the cover or a node of a wastewater structure, then select the **vw_cover** or **vw_wastewater_node** layer, set the layer to edit mode and move the cover / the node with the **Move Feature** tool.

See the figure below: just the cover of manhole 'ZRAM' is moved.

.. figure:: images/moving_wws_manhole3.jpg

.. attention:: You can also move the wastewater structure with the **Vertex Tool**. The vertex tool moves all layers, that have objects at the same place, where you click. You can move the manhole 'ZB1' with this tool as shown in the first example. But you can not move the nodes and reachpoints, because they are not at the same place. And you can not move only covers in vw_cover. If there are nodes or reachpoints at the same place, they will move to.


Video Tutorial
--------------

* See `this video tutorial (version QGIS 2) <https://vimeo.com/162978741>`_
