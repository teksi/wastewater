.. _Import-Results:

SWMM Import Results
-------------------

Measurement tables
^^^^^^^^^^^^^^^^^^

If you want to store the results in TWW and use the dedicated view for the mapping then use SWMM Import Results.
It parses the report file of SWMM.
The results are imported in the measurements tables in the ``tww_od`` schema:

- ``measuring_point``: there is one *measuring point* for each *wastewater structure* and simulation,

.. figure:: images/tww_od_measuring_point.jpg

    Measuring point: the name of the simulation appears in the remark

- ``measuring_device`` : there is one *measuring device* for each *measuring point*,

.. figure:: images/tww_od_measuring_device.jpg

    Measuring device

- ``measurement_series``: there is several *measurement series* for each *measuring point*, one for each measured parameter (i.e average depth, maximum depth, maximum hgl ...),

.. figure:: images/tww_od_measurement_series.jpg

    Measurement series

- ``measurement_result``: there is one or several *measurement result* for each *measurement series*. There is one value if the summary only is imported and many values if the full time series are imported.

.. figure:: images/tww_od_measurement_result.jpg

    Measurement result


and they populate a view dedicated for the mapping (see :ref:`mapping-imported`).


Launch import
^^^^^^^^^^^^^

Launch ``SWMM Import results``:

- ``SWMM report file``: the ``.rpt`` file generated during the previous step
- ``Database``: The name of the PostgreSQL service hosting the TWW database.
- ``Simulation name``: The name that you want to give to this simulation (it will appear in ``tww_od.measuring_point.remark``).
- ``Import summary``: Only the summary is imported.
- ``Import full results``: The full time series will be imported. Attention, if the report step is small, the import can take a long time.
- ``Import Max HGL in tww_od.wastewater_node.backflow_level``
- ``Import Max/Full Flow in tww_od.reach.dss2020_hydraulic_load_current``

.. warning::
    Attention, a report file created from the SWMM GUI don't contain the full time series but only the summary.
