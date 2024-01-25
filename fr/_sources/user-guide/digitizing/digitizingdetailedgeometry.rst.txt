Digitizing detailed geometry
============================

General
-------

You can add a detailed geometry to waste water structures.

This is recommended for:

* Special structures and discharge points, because they are not normed structures like manholes,
  where you can define **dimension1** and **dimension2** to describe the extension.
* Infiltration installations where **dimension1** and **dimension2** are not enough to describe the geometry

.. attention:: Detailed geometry is usually not used for manholes or channels!


Digitizing tool
---------------

* Select the **vw_tww_wastewater_structure** layer
* Select the object where you want to add a detailed geometry with the info tool
* Right click the object
* if there are several objects: select the **vw_tww_wastewater_structure** layer
* Choose **Digitize**

.. figure:: images/digitizing_detailedgeometry1.jpg

* You can now start digitizing the polygon.

.. figure:: images/digitizing_detailedgeometry2.jpg

.. figure:: images/digitizing_detailedgeometry3.jpg

* Right click to stop.

.. figure:: images/digitizing_detailedgeometry4.jpg

An other way is to open the **vw_tww_wastewater_structure** form with the info tool and then choose **Digitize** in the **Actions** menu of the form.

.. note:: If the geometry disappears after digitizing or if you get an message (like 'Add part'), you have probably tried to digitize over a catchment area (or an other polygon theme) and the layer has set the avoid overlap option in the snapping settings. Do change the avoid overlap settings.
