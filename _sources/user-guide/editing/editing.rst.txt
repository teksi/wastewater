.. _editing-data:

Editing of existing data
========================

This represents a guide on how to edit existing data in TWW.

Demo project
------------

* Make sure you have imported the demo project with pgAdminIII (see the :ref:`database-initialization` chapter)
* Open the demo project by going to the main menu and press **Project** --> **Open**  or by pressing ``CTRL``
  + ``O`` at the same time.

.. figure:: images/tww_demoproject_selection_tww_en_qgs.jpg
   :scale: 50 %

* Login to the database

.. figure:: images/tww_demoproject_login.jpg

* You should now have the demo project loaded

.. figure:: images/tww_demoproject_overview.jpg

* The project consists of different layers. Depending on your task what to edit or add you choose the layer.

Layers
------

* TWW has different predefined layers. For explanations, see the :ref:`layer-explanation` chapter.


Changing attributes of point elements (manholes / special structures)
---------------------------------------------------------------------

 * To change an attribute you first need to select the **vw_tww_wastewater_structure** layer.
 * Switch to the edit mode or start the **TWW Wizard** and click on **Start Data Entry**.
 * Then click on the **Identify features** button and click on the element you want to edit.

 .. figure:: images/identify_feature_tool.jpg

 * The **vw_tww_wastewater_structure** form will open.

 .. figure:: ../digitizing/images/wizard_wastewater_structure_manhole_form_data_ok3.jpg

 * On the first tab (General) you can change the most common attributes
 * To change attributes of related tables (e.g. cover) you need to select the correspondent tab. Depending on the
   kind of wastewater structure you can edit additional attributes in the respective tab (**special structure**, **manhole**).

 * In **Structure parts** tab you can add further parts such as **access aids**, **backflow prevention**, **dryweather flume** etc.

 .. figure:: images/form_vw_tww_wastewater_structure_structure_parts.jpg

 * The **covers** and **wastewater nodes** tab allows you to look to all nodes or covers of a wastewater structure and to add further elements. See the :ref:`Adding-additional-covers-and-nodes-to-an-existing-wastewater-structure` chapter below.


Changing attributes of linear elements (channels)
-------------------------------------------------

 * To change an attribute you first need to select the **vw_tww_reach**
 * Switch to the edit mode.
 * Then click on the **Identify features** button and click the reach you want to edit.
 * The **vw_tww_reach** form will open.

  .. figure:: images/form_vw_tww_reach.jpg

 * On the first tab (**General**) you can change the most common attributes.
 * To change attributes of related tables (e.g. **reach points**) select the correspondent tab.

  .. figure:: images/form_vw_tww_reach_reachpoints.jpg

Change reach direction
----------------------

.. note:: The definition in VSA-DSS is, that reaches have to be defined in the flow direction (the start node is where the water comes from, the end node is where the water flows).

TWW has a tool to change the reach direction. With this tool you can change all selected reaches at once.
Do not use the **Reverse line** button of QGIS, because this button do not change the reach points and their connection to wastewater network elements.

* To start you have to select all reaches that you want to change. There is no need to select the vw_tww_reach layer or to set this layer to the edit mode.

* Open the **Processing Toolbox**

.. figure:: images/toolbox.jpg

* Double click the **Change reach direction** tool

.. figure:: images/tww_toolbox.jpg

* In the tool window you have to choose the **vw_tww_reach** - Layer and then click on **Run**

* If you zoom in or out, you see, that the slope-arrow and the slope has changed. The reach points level have not changed.

* Refresh network topology.

* You can save now the change.


Snap reach geometry
-------------------
This tool snaps reaches graphically to the wastewater network element they are connected to. So they are not only logically, but also graphically connected.

* To start you have to select all reaches that you want to snap. There is no need to select the vw_tww_reach layer or to set this layer to the edit mode.

* Open the **Processing Toolbox**

.. figure:: images/toolbox.jpg

* Double click the **Snap reach geometry** tool

.. figure:: images/tww_toolbox.jpg

* In the tool window you have to choose the **vw_tww_reach** - layer and the **vw_wastewater_node** - layer, then click on **Run**

* If you zoom in or out, you see the changes.

* If the result is not what you expect, try with a greater snapping distance

If there are connections from reach to reach, the reach point moves at right angles to the other reach. If there is no way to do a right angle, it moves to the next end point of the reach.

.. attention:: If there is snapping from reach to reach, you will get not the expected result, if the first reach snaps to a second reach, and afterwards this second reach snaps to a node or a third reach, there will be no more graphical connection between reach 1 and reach 2. You have to rerun the command.

Working with codes of value list
--------------------------------

* The values of fields with value list are stored in the database with codes.

 .. note:: The codes are unique, also if there is the same text in different value lists. E.g. the code for "rain_wastewater" in the vl_channel_usage_current and in the vl_channel_usage_planned is different.

* In a tww project with correct configuration you see in the table view or the form view the values in your language and not the codes.
* But if you want to define a selection by expression or if you want to define a rule-based symbology for your layer, you have to know the codes or you use the following expression: **represent_value("field")**


Examples for using **represent_value**

* Search all primary wastewater facility reaches (function_hierarchic starts with pwwf)

 .. figure:: images/represent_value1.jpg

* Search all reaches, that have not the same usage_planned as usage_current

 .. figure:: images/represent_value2.jpg

.. note:: The expression `"ch_usage_current" <> "ch_usage planned"` does not work because of the unique codes!

.. note:: In the demo-project is no use of represent_value for rule-based symbols, because the rules will otherwise only work for one language.


An other way to choose an object
--------------------------------

* With the **Identify feature** tool activated, right clicking an element outputs a selection of all existing objects at this place.

 .. figure:: images/tww_info_button_rightclick.jpg

 * You can select then the object you want. This will get you to the correspondent form to see the details.

.. _Adding-additional-covers-and-nodes-to-an-existing-wastewater-structure:

Adding additional covers and nodes to an existing wastewater structure
----------------------------------------------------------------------

.. note:: The following description is for an additional cover. It works similar for additional wastewater nodes.

* Be sure to have the relation between vw_cover (field fk_wastewater_structure) and vw_tww_wastewater_structure (field obj_id) in your project properties / relations.
* Define in layer vw_cover / Properties / **Attribute Forms** the field **fk_wastewater_structure** as value relation

.. figure:: images/vw_cover_properties_fields.jpg

* With QGIS 3.16 there is a new way: select layer vw_tww_wastewater_structure, set it editable, click the manhole you want to add a cover with the **Identify feature** tool. Go to tab **covers** and click the new child point-button. Now you can digitize a new cover for the wastewater structure.

.. figure:: images/new_cover_childpoint.jpg

* The other way (before QGIS 3.16)
* Start editing vw_cover and add the new cover
* In the form you find behind the field fk_wastewater_structure a button to connect the new cover to an existing wastewater structure
* After clicking this button, you get blue hint in the qgis-window. You can move the vw_cover - form-window and click on the wastewater_structure, that will be associated to the cover.

.. figure:: images/new_cover_connect_to_wws.jpg

Adding a wastewater node to an existing reach
---------------------------------------------

In some cases, you need to add a wastewater node between two or more reaches, although there is no manhole at this place.

.. note:: This cases are mainly in pwwf_channels (primary wastewater facilities) if there is e.g. a change of slope or a change of the material or if there is a connection of two channels without manhole (in German: Blindanschluss).

In the data model, you can connect a node between reaches to a channel (because also a channel is a wastewater structure). There is in the moment a discussion, if it is necessary or optional or even forbidden to define a connection to a wastewater structure.

In TWW, there is in the moment no tool, that helps you to connect a wastewater node to a channel. So you just connect the reach points to the node.

.. note:: If you really want to connect the node to a channel, then type the obj_id of the channel manually in the fk_wasterwater_structure field of the node.


Multiedit
---------
If you want to edit attributes for multiple objects of the same class you can use the `multiedit Tool of QGIS <https://docs.qgis.org/latest/en/docs/user_manual/working_with_vector/attribute_table.html#multi-edit-fields>`_.


Saving changes
--------------

* Click **Save** and then deactivate the edit mode or click on **Stop data entry** if you have worked with the **TWW Data Entry** wizard.


Changing Wastewater Structure Type
----------------------------------

In the vw_tww_wastewater_structure form, you can change the subclass of the wastewater structure (e.g. from manhole to special structure or to infiltration installation). The old subclass-record will be deleted and you must enter those attributes, that are subclass specific. But all connections (they are defined to the class wastewater_structure and not to the subclass) or the obj_id or the identifier will not change.

.. note:: You can not change a point - wastewater structure (e.g. manhole) to a line wastewater structure (channel) or vice versa.


Split a reach (channel) into different reaches
-----------------------------------------------

This is a quite complex function and not jet implemented in TWW. There exists a QGIS-Tool to split objects, but if you use this tool with vw_tww_reach - layer, you will get a database error, because the obj_id of the split (= duplicated) records are no more unique.

Temporary solution: Change the existing reach and draw the second reach manually. Control the connections.

There will be later a tool in TWW to split reaches. The user has to decide, if splitting concerns only class reach or also the class channel, if there a new wastewater node shall be added and connected. The tool shall be able to calculate the new reachpoint - levels and should change the existing network-element-connections if necessary.
