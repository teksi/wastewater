.. _Create-Input:

SWMM Create Input
-----------------

- By default, the plugin extracts the entire primary wastewater structures. If you check *Export only selected network*, then both the selected primary and secondary network will be exported.

- The ``.inp`` file is the input file format for SWMM. It contains the wastewater network AND simulation parameters. The network can be extracted from the TWW data, but the simulation parameters must be set according to your study.

- The simulation parameters are copied from a provided template ``.inp`` file. A default file is provided in the plugin folder in ``src\swmm_templates\default_tww_swmm_parameters.inp``, but you can create and use your own template file.

- By default, the export supposes that you use an *Horton Infiltration method*. If another method is set in the template ``.inp``, you might need to adapt the generated ``.inp``. See the linked `issue <https://github.com/TWW/TWW/issues/644/>`_

TWW plugin
^^^^^^^^^^^^
Launch ``SWMM Create Input``:

- ``Database``: the name of the service used to connect to the database
- ``State``: Current or Planned: extract the wastewater structure according to the status
- ``Template INP file``: a ``.inp`` from which simulation parameters will be copied
- ``Destination INP file``: the ``.inp`` generated from TWW data
- ``Export only selected network``: Export primary and secondary selected network


Selection
---------
Usually you will select a subnetwork to be exported with the TWW button ``Upstream`` and then ``Select current path``.
If you want to remove from this selection secondary structures:

- Open ``Selection by expression``  on the layer ``vw_tww_reach``
- Expression:  ``"ch_function_hierarchic"  in (5066, 5068, 5069, 5070, 5064, 5071, 5062, 5072, 5074)``
- Choose: ``filter current selection``

- Open ``Selection by expression``  on the layer ``vw_tww_wastewater_structure``
- Expression:  ``"_channel_function_hierarchic" in (5066, 5068, 5069, 5070, 5064, 5071, 5062, 5072, 5074)``
- Choose: ``filter current selection``
