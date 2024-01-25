Digitizing Catchment Areas
===========================

General
-------

Catchments can be digitized with QGIS standard tools.

.. figure:: images/qgis_standard_tools.jpg

Catchment areas should not overlap and can have 4 connections to wastewater nodes.

Digitizing
----------
* Select the **Enable Snapping** button

.. figure:: images/enable_snapping_button.jpg

* Open the **Project Snapping Option Settings**, check the **od_catchment_area** layer and check the **avoid intersection** checkbox for the od_catchment_area layer

.. figure:: images/catchment_avoid_intersection2.jpg

.. note:: New digitized catchment areas will not overlap with existing areas with this settings.

* Set the layer ``od_catchment_area`` into the edit mode.
* Use the **Add Feature** tool to digitize a new area.

.. figure:: images/add_feature_tool.jpg

* Start digitizing with left click and continue with left click for every vertex of the polygon

.. figure:: images/catchment_area_digitizing1.jpg

* Stop digitizing with right click

.. note:: Keep in mind, that the finishing point of the polygon is the last point where you **left** clicked.

* The **od_catchment_area** form appears

.. figure:: images/catchment_area_digitizing2.jpg

* When finished editing attributes, click the **OK** button

.. note:: The new area does not overlap the old areas.

.. figure:: images/catchment_area_digitizing3.jpg

.. note:: To control the exact area of a selected polygon, see in the **Identify Results** window under **(Derived)**.

.. note:: To connect the area with wastewater nodes, see chapter :ref:`connect-wastewater-network-elements`.

Editing
-------

* You can edit existing areas with the **Identify features** tool.

.. figure:: images/identify_feature_tool.jpg

.. note:: There are ideas to have a menu in the feature attribute window, that allows you to copy all current-values to the planned-fields. Not realized yet.

Split Areas
-----------

* You can split existing areas with the **Split** tool.

.. figure:: images/split_tool.jpg

* There is no need to select the area first. Left clicks to define the splitting line. Right click after having defined the last point of the splitting line.

Merge Areas
-----------

You can merge existing areas with the **Merge selected Feature** tool.

.. figure:: images/merge_selected_feature_tool.jpg

* Selected the **od_catchment_area** layer an set it into the edit mode
* Select at least two areas you want to merge
* Click the ``Merge selected Feature`` tool. -> The **Merge Feature Attributes** windows appears.

.. figure:: images/merge_feature_attributes.jpg

* Choose which values will be taken from which old record and click **OK**.

.. attention:: If you select one of the records and click on the **Take attributes from the selected feature** button, then the **obj_id** field will be skipped by default and the database will not accept the changes. After using this button, you have to choose one of the values in the **obj_id** field manually.

Connect Catchment area to Wastewater Network Nodes
--------------------------------------------------

You connect catchment areas with the tool **Connect wastewater networkelements** (it's the same tool to connect reaches and nodes described in the chapter Editing in TWW).

.. figure:: images/connect_wastewater_network_elements_button.jpg

* It does not matter, which layer is selected
* The **catchment_area** layer has to be in edit mode
* Click the **Connect wastewater networkelements** button
* If you move the mouse over an catchment area near the border of the catchment area, it is marked: you can click to choose this record
* Move the mouse to the networkelement, to which the catchment area will by connected (again: selectable objects get marked) and click again

.. figure:: images/catchment_area_connect1.jpg

* A window appears, where you can choose, which connection(s) will be defined.

.. figure:: images/catchment_area_connect2.jpg

* If everything is ok, you will see a message in a blue bar on top of the map-window

.. figure:: images/catchment_area_connect3.jpg

.. note:: In the VSA-DSS-Datamodel, it is possible to connect catchment_areas to wastewater nodes or to reaches. Because a lot of hydraulic calculation do not support connections to reaches, this tool in tww connects only to wastewater nodes and not to reaches.

.. note:: The tool does not check, if your choosen wastewater node is a part of the pwwf-network (primary network). It's only the user who decides, if a node is ok or not. If you are not sure, please check the **VSA Wegleitung GEP-Daten**, part **Erfassungsgrundsätze**

You can not connect multiple areas with the tool to a wastewater node at once. If you want to do so, you have to select the catchment areas, open the attribute table and then start the multi edit mode. There you can choose the wastewater node from the list of all nodes.

Do delete a connection to a wastewater node, you can edit the area with the **Identify features** tool.
