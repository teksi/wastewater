Deleting objects
================

You can delete point or line objects (with all associated objects) through the **vw_tww_(wastewater_structure/reach)** layers.
You can also pick and delete only a specific object (e.g. cover).

Delete Reaches
--------------

* Select **vw_tww_reach** and change to edit mode.

* Select the reach(es) you want to delete. You can click on an object or draw an area.

.. figure:: images/select_tool.jpg

* Use the top menu **Edit** --> **Delete Selected** to delete.

.. figure:: images/delete_reach.jpg

.. note:: The easiest way is to simply press the **Delete** key on your keyboard.
  Another way is to press the **Delete** button located in the **Digitizing toolbar**.

  .. figure:: images/delete_button.jpg

  Depending on how you customized QGIS the **Digitizing toolbar** may be hidden or located
  elsewhere.

* Deselect the edit mode and confirm changes to layer. All changes will be saved to database.

.. figure:: images/delete_reach_confirm.jpg

.. note:: Delete reaches deletes also all connected structure parts. The connected channel is only deleted if there is no other wastewater networkelement is connected. If there are two reaches connected to one channel, the channel is only deleted if both reaches are deleted.

Delete Manholes and other Wastewater Structures
------------------------------------------------

* Select **vw_tww_wastewater_structure** and change to edit mode
* Select the objects (**manholes**, **special structures** etc.) you want to delete
* Use **Edit** --> **Delete Selected** to delete.
* Stop the editing mode and confirm changes to layer. All changes will be saved to database.

.. note:: Delete wastewater structures deletes also all connected structure parts and all connected wastewater nodes.

Delete Covers
-------------

* Select **vw_tww_wastewater_structure** and change to edit mode
* Select the object (**manholes**, **special structures** etc.) from which you want the cover deleted
* Use the **Identify Features** tool to open the form
* Switch to the covers tab
* Select the cover(s) you want to delete
* Click the red x button to delete the covers

.. figure:: images/delete_covers.jpg

* Click save on the form
* Deselect the edit mode and confirm changes to layer. All changes will be saved to database.

* Second way to delete a cover: select the **vw_cover** layer and change to edit mode, select the cover, use **Edit** --> **Delete Selected**, stop the editing mode

Delete Structure parts
----------------------

* Select **vw_tww_wastewater_structure** and change to edit mode
* Select the object (**manholes**, **special structures** etc.) from which you want to delete a structure part
* Use the **Identify Features** tool to open the form
* Switch to the structure parts tab
* Select the structure part you want to delete
* Click the red x button to delete the structure parts
* Click save on the form
* Stop the editing mode and confirm changes to layer. All changes will be saved to database.

Delete detailed geometries
--------------------------

.. attention:: Deleting features directly from **wastewater_structure** will remove the complete wastewater structure from the database and not only the geometry of the wastewater structure!

* Select **wastewater_structure** and change to edit mode
* Activate the **Remove part** tool from the Advanced digitizing toolbar
* Click on the parts you want to delete
* Stop the editing mode and confirm changes to layer. All changes will be saved to database.
