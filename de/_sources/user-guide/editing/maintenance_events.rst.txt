.. _maintenance-events:

Adding or Editing of Maintenance Events
=========================================


This represents a guide on how to add or edit maintenance event data in TWW.

General
-------

* Maintenance events can be connected to one structure or to many.
  Therefore TWW uses a intermediary RE_table to model the n:m relationship (**re_maintenance_event_wastewater_structure**)


Adding a new Maintenance Event
-------------------------------------------------------------

* Enable the edit mode.
* With the **Identify Features** tool you can select **wastewater_structures** or **reaches** by selecting their corresponding layer (**vw_tww_wastewater_structure** or **vw_tww_reach**).
* The respective form will open. Change to the **Maintenance** tab.

* Create a new maintenance event with the **Add child feature** button.

 .. figure:: images/maintenance_add_child.jpg

 * Edit the new record in the vw_tww_maintenance form, then click **OK**

 .. figure:: images/maintenance_new_record.jpg

 .. figure:: images/maintenance_new_record_saved.jpg

Link an existing Maintenance Event
-------------------------------------------------------------

* Enable the edit mode.
* With the **Identify Features** tool you can select **wastewater_structures** or **reaches** by selecting their corresponding layer (**vw_tww_wastewater_structure** or **vw_tww_reach**).
* The respective form will open. Change to the **Maintenance** tab.

* Click the **Link existing child features** button.

 .. figure:: images/maintenance_link_child.jpg

 * Choose a maintenance event from the **Dialog** window by clicking in the box of the record. The box must by yellow. Then click **OK**

 * Close the windows with **OK** and turn of the edit mode to save changes


Unlink Maintenance Events
-------------------------------------------------------------

* Enable the edit mode.
* With the **Identify Features** tool you can select **wastewater_structures** or **reaches** by selecting their corresponding layer (**vw_tww_wastewater_structure** or **vw_tww_reach**).
* The respective form will open. Change to the **Maintenance** tab.

* Select a maintenance event by clicking in the box (box gets yellow), then click the **Delete child feature** button.

 .. figure:: images/maintenance_delete_link.jpg

 .. attention:: There is only the record in the RE-table deleted. The maintenance event record himself is not deleted and can by linked with other wastewater structures.


Editing
--------

 * Do as described in adding - but just edit existing maintenance events. Or edit the **vw_tww_maintenance** table (layer group **inspection**)


Multi Edit
-----------------------------------------------------------

Multi edit with linked tables is implemented in QGIS. It is possible to create or to link a maintenance event to a selection of reaches or wastewater structures im multiedit-mode.
