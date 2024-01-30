.. _Coefficient-Of-Friction:

Coefficient of friction
-----------------------

- The plugin will export the roughness according to these priorities:

    - If ``reach.coefficient_of_friction`` is set then it is converted (``1/coefficient_of_friction``) and exported to SWMM
    - Else if ``reach.wall_roughness`` and ``reach.clear_height`` are set, it is converted (``(1/(4 * SQRT(9.81)*POWER((32/re.clear_height/1000),(1/6))*LOG(((3.71*re.clear_height/1000)/(re.wall_roughness/1000)))))``) and exported.
    - Else if ``reach.swmm_default_coefficient_of_friction`` is set then it is used
    - Else a default value of ``0.01`` is set
    - See ``vw_swmm_conduites.sql`` for details



..  note::
    The formula to convert from Strickler to Coolebrook is documented in `*ATV-DVWK STANDARD ATV-DVWK-A 110E, Hydraulic Dimensioning and Performance Verification of Sewers and Drains September 2001* <https://pdfslide.net/documents/atv-dvwk-a-110-e-55846635d4eef.html>`_


Populate default coefficient of friction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The table ``tww_swmm.reach_coefficient_of_friction`` contains default coefficient of Strickler for the reach materials.
The file ``../project/qml/reach_coefficient_of_friction.qml`` is the layer definition, that you can import in your QGIS project.
If the default values don't match your needs you can edit them.
The function ``SWMM Set default coefficient of friction`` will put in ``tww_od.reach.swmm_default_coefficient_of_friction`` these default values.
You can choose if you want to overwrite or not the values existing in this attribute.

Launch ``SWMM Set default coefficient of friction``:

- ``Overwrite existing default values``: If checked the values stored in ``swmm_default_coefficient_of_friction`` will be overwrited with new values.
