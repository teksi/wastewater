.. _Run-SWMM-Simulation:

Run SWMM Simulation
===================

Run a simulation from SWMM interface
------------------------------------
You can open the ``.inp`` file with SWMM and run the simulation from the interface.


Run a simulation with command line
----------------------------------

.. code::

    {EXEPATH}\swmm5.exe {INPUTPATH}\{INPUTFILENAME}.inp {OUTPUTPATH}\{REPORTFILENAME}.rpt {OUTPUTPATH}\{OUTPUTFILENAME}.out


Run a simulation with TWW-SWMM
-------------------------------

The path to the SWMM executable must be set in the Processsing tools options. The plugin will launch the command line in the background.

Launch ``SWMM Execute``:

- ``INP file``: the ``.inp`` file generated during the previous step
- ``RPT file``: the output report file ``.rpt`` containing the results (summary and full time serie)


Common running errors
---------------------
The list of errors can be found `here <https://swmm5.org/2016/09/05/swmm-5-1-and-infoswmm-error-and-warning-messages/>`_

- ``ERROR 211: invalid number -XXX at line XXX of [JUNC] section:``: A negative number is provided for the depth. Change the value in TWW or in the ``.inp`` file.
