Digitizing Detailed Geometry as Drainage Channel
================================================

General
-------------------------

You can add a polygon to a wastewater structure just with drawing a simple line. The function creates a rectangle from the line with a width of 20cm. This is specially useful for manholes with function drainage channel.

Digitizing tool
-------------------------

* Select the **vw_tww_wastewater_structure** layer
* Use the **Identify features** tool on the object to which you want to add a drainage channel geometry
* In the Feature Attributes window:go to the **Action** menu and choose **Digitize Drainage Channel**

.. figure:: images/digitize_actionmenu.jpg

or

* Right click the object and select the **vw_tww_wastewater_structure** layer and the record
* Choose **Digitize Drainage Channel**

.. figure:: images/digitize_detail_geom_select1.jpg

* You can now start digitizing: draw a simple line with two clicks.
* The polygon is created in the **wastewater_structure** layer (layergroup Wastewater Structures)
