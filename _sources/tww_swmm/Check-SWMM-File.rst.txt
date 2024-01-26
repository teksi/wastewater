.. _Check-SWMM-File:

Check SWMM File
================

The generated ``.inp`` file can be imported in SWMM GUI. It is likely that some errors will be raised. You will have to solve them (see hereunder a list of common errors)

You have to solve the errors in the order in which they appear in the report. Some errors are interrelated (i.e. a node in a conduit is not defined => the conduit is not imported => Undefined link error)

To fix an error you can search in the corresponding TWW layers in the QGIS project:

- vw_wastewater_node for undefined nodes
- catchment_area for subcatchment errors
- compare if the number of exported nodes (in vw_junctions) are what you expect it to be.
- Check if the function (manhole / special_structure) of wastewater_structure are all filled in
- etc.



.. _Common-Import-Errors:

Common import errors
-----------------------------------------

Missing status or _function_hierarchic (wn_function_hierarchic)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The catchment area is linked to node which is not exported or a reach cannot be drawn because of a missing node:

-  because of its status (abandonned etc.) or status is not defined (is Null)
-  the node is not connected (correctly) to a conduit
-  the node is secondary (the linked reach are secondary)

and therefore not export in the vw_junctions.

Check your data manually before the export if wastwater_structure.status is not empty. Check whether wastwater_structure._function_hierachic is filled in on Primary network nodes (PAA nodes).

`For more details see related Github issue <https://github.com/TWW/TWW/issues/613>`_

Catchment area connected to secondary wastewater structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

  Undefined Node (CHamtKnv00002706) referenced at line 20997:
  [DWF]
  CHamtKnv00002706	FLOW	0.0204074074074074	dailyPatternDWF


The catchment area is linked to a secondary wastewater structure

Missing discharge coefficients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

  Too few items at line 104:
  [SUBCATCHMENT]
  ch19ar68CA008855_ww_current	raingage@ch19ar68CA008855	CHamtKnv00001992	0.0276		19.4322613668305


The subcatchement discharge coefficients are not filled in.
You can find them using sql:

.. code::

  select obj_id, fk_wastewater_networkelement_rw_current, discharge_coefficient_rw_current
  from tww_od.catchment_area
  where fk_wastewater_networkelement_rw_current is not null and discharge_coefficient_rw_current is null;

  select obj_id, fk_wastewater_networkelement_rw_planned, discharge_coefficient_rw_planned
  from tww_od.catchment_area
  where fk_wastewater_networkelement_rw_planned is not null and discharge_coefficient_rw_planned is null;

  select obj_id, fk_wastewater_networkelement_ww_current, discharge_coefficient_ww_current
  from tww_od.catchment_area
  where fk_wastewater_networkelement_ww_current is not null and discharge_coefficient_ww_current is null

  select obj_id, fk_wastewater_networkelement_ww_planned, discharge_coefficient_ww_planned
  from tww_od.catchment_area
  where fk_wastewater_networkelement_ww_planned is not null and discharge_coefficient_ww_planned is null;


Missing population densities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

  ERROR 211: invalid number dailyPatternDWF at line 4288 of [DWF] section:
  00000000WN006032 FLOW             dailyPatternDWF


``tww_od.catchment_area.population_density_current`` or ``tww_od.catchment_area.population_density_planned`` are not filled.


Subcatchments and rain Gauges
-----------------------------
If you want to attach every subcatchments to a single rain gauge, edit the file with SWMM interface:

- Edit > Select All
- Edit > Group Deletion > All Rain Gages
- Create a new raingage
- Edit > Select All
- Edit > Group Edit

  - For objects of type: Subcatchment
	- Edit the property: Rain Gage
  - By replacing it with: Name of the new rain gage

To edit the rain serie:

- Click on Time Series
- Double click default_tww_raingage_timeserie
- Edit the serie
