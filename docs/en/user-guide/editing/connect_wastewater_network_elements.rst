.. _connect-wastewater-network-elements:

Connect Wastewater Network Elements
===============================================

This represents a guide on how to connect wastewater network elements in TWW.

General
------------

* TWW has a tool to connect wastewater network elements

.. figure:: images/connect_wastewater_network_elements_button.jpg

How to connect reaches to nodes or reaches to reaches
-----------------------------------------------------

* It does not matter, which layer is selected
* The **vw_tww_reach** layer has to be in edit mode
* Click the **Connect wastewater network elements** button
* If you move the mouse over an reach, that can be connected, it is marked: you can click
* Move the mouse to the network element, to which the first object will be connected (again: selectable objects get marked) and click again

.. figure:: images/connecting_1.jpg

* A window appears, where you can choose, which connection will be defined. If you connect a reach, the window looks like this:

.. figure:: images/connecting_2.jpg

* If everything is ok, you will see a message in a blue bar on top of the map-window

.. figure:: images/connecting_3.jpg

Video Tutorial
--------------

* See `this video tutorial (QGIS version 2): <https://vimeo.com/171536774>`_


How to delete a connection
--------------------------

There is no special tool in the moment to delete a connection between network elements.

* Select the **vw_tww_reach** layer and set it to edit mode
* Click on the **Identify Features** button and select the reach to modify by double clicking
* Delete the value in the **rp_..._fk_wastewater_networkelement** field to delete the connection

.. figure:: images/connecting_delete_connection.jpg

.. note:: Be aware of the 'VSA Erfassungsgrundsätze': A reach point from (rp_from_fk_wastewater_networkelement) should never be connected to another reach.

For example, when you have a reach discharging directly into another one without a structure between the two, the upstream reach should be connected to the downstream reach (rp_from_fk_wastewater_networkelement = downstream reach).
But inversely, the downstream reach shouldn't be connected to the upstream one. This rule is for swwf-channels (secondary network). In pwwf-network, there must be always a node between to reaches.
