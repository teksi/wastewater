.. _TWW-SWMM-workflow:

TWW-SWMM workflow
==================

Workflow
--------

.. figure:: images/workflow.png

Each step of the workflow is explained in details in next chapters.

Prepare and check the data
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- The function ``SWMM Set default coefficient of friction`` can be used to fill automatically default reach friction.

Generate a SWMM Export
^^^^^^^^^^^^^^^^^^^^^^

Run ``SWMM Create Input``. It:

- reads simulation parameters from a template ``.inp`` file,
- reads data from the TWW views (schema ``tww_swmm``),
- generates an input file for SWMM (``.inp``).

Check the Export
^^^^^^^^^^^^^^^^
Check generated ``.inp`` file.

Its likely that the ``.inp`` file generated in the previous step contains errors or needs some parameters to be tuned.
We recommend to first open the ``.inp`` file with the SWMM Graphical User Interface (GUI).
Error summarized at the SWMM startup might highlight error in TWW. Other errors can be solved directly in SWMM.

If you need to tune the simulation parameters, you have to edit the ``.inp`` file with SWMM GUI.

Run the simulation
^^^^^^^^^^^^^^^^^^
Run ``SWMM Execute``, it launches SWMM. Run it on a tested ``.inp`` file.
It generates a report file ``.rpt`` which contains the summary and the full time series.
Errors can also occur during the running time.

Alternatively, you can run the simulation from the SWMM interface or with command line.

Stores and map the Results
^^^^^^^^^^^^^^^^^^^^^^^^^^

 - **If you dont want to store the result in TWW database**: Run ``SWMM Extract Results``. It parses the report file and generates three QGIS table layers from the summary. The user has to join the computed values with the geometries and map them.
 - **If you want to store the results in TWW and use the dedicated view for the mapping**: .Run ``SWMM Import Results``. It parses the report file. The results are imported in the measurements table, they populate a view dedicated for the mapping.


GEP project
-----------
**WORK IN PROGRESS: This section must be completed with end users**

Usually, a GEP analysis has at least three steps:

1. The current state of the network is analysed
2. The planned state is analysed.
3. Several variants are tested and analysed

**Minimal parameters to be set**

``Time series``: Create a time serie for the rain. The time series have to be linked to the raingages ``Hydrology > Rain Gages`` (which are linked to the subcatchments)

``Hydrology > Subcatchment``: Set percent of of impervious area and infiltration parameters

**Optional parameters**

``Climatology > Evaporation``

**Run planned state simulation**

- In the function ``SWMM Create Input`` choose the state planned. It extract the planned wastewater structures.

**Run variants (network is modified)**

New links and new nodes are created directly in SWMM GUI
