.. _TWW-SWMM-Correspondances:

TWW - SWMM correspondances
---------------------------


Title/Notes:
^^^^^^^^^^^^

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.


Options:
^^^^^^^^
No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.


Climatology:
^^^^^^^^^^^^
No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Hydrology:
^^^^^^^^^^
**Rain Gauges [Gages in SWMM]:**

TWW_SWMM creates one raingage for each subcatchment.

By default:

- Time serie: Each raingage is related to a default rain time serie called ``default_tww_raingage_timeserie``. The time serie must be created and the value Series Name updated accordingly.
- Other parameters have default SWMM values

See ``vw_swmm_raingages.sql`` for details.

**Aquifers:**

TWW_SWMM creates an aquifer for each TWW ``aquifer``.

By default:

- An aquifer is created for each TWW ``aquifer``
- The bottom elevation is set to the ``minimal_groundwater_level``
- The water table elevation is set to the ``average_groundwater_level``
- Other parameters have default SWMM values

See ``vw_swmm_aquifers.sql`` for details.

**Subcatchment:**

TWW_SWMM creates a subcatchment for each TWW catchment area.

By default:

- A subcatchment is created for each TWW ``wastewater_networkelement`` linked to the ``catchment area`` (max. 4: ``fk_wastewater_networkelement_rw_current``, ``fk_wastewater_networkelement_rw_planned``, ``fk_wastewater_networkelement_ww_current``, ``fk_wastewater_networkelement_ww_planned``)
- it is linked to a rain gage.
- The width is computed from the mean of the minimal / maximal distance between the outlet and the catchment area contour. If the outlet is unknown the centroid is used rather than the outlet.
- The coverages (attribute land uses) are computed from the intersection between the catchment area and the planning zone (see ``vw_swmm_coverages.sql``)

- SWMM Dry Weather Flow:

    -  are set to 0 for rain water subcatchments
    -  are set to ``waste_water_production[_current,_planned]`` if set
    -  else it computed from the subcatchement area and ``population_density[_current,_planned]``

- Other parameters have default SWMM values

The subcatchment can be linked to an aquifer via the groundwater attribute.

See ``vw_swmm_subcatchments.sql``, ``vw_swmm_subareas.sql``, ``vw_swmm_dwf.sql`` and ``vw_swmm_coverages.sql`` for details.

**Snow Packs**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

**Unit hydrographs**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

**LID Controls**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Hydraulics
^^^^^^^^^^

**Junctions**

- TWW_SWMM creates a junction for each TWW manhole, some kind of special structures and the wastewater nodes linking primary pipes without a wastewater structure.

See ``vw_swmm_junctions.sql`` for details.

**Outfalls**

- TWW_SWMM creates an outfall for each TWW discharge_point.

See ``vw_swmm_outfalls.sql`` for details.

**Dividers**

- TWW_SWMM creates a divider for the manholes and special structures having the function ``separating_structure``

- See ``vw_swmm_dividers.sql`` for details.

**Storage Units**

- TWW_SWMM creates a storage for some kind of TWW infiltration installations and some kind of TWW special structures.

- See ``vw_swmm_storages.sql`` for details.

**Conduits**

- TWW_SWMM creates a conduit for each TWW reach.
- Roughness is created from ``coefficient_of_friction``, ``wall_roughness`` or ``swmm_default_coefficient_of_friction`` (see: :ref:`Coefficient-Of-Friction`)
- TWW profile type are matched to SWMM profile type, dimensions are computed from ``reach.clear_height`` and ``pipe_profile.height_width_ratio``
- Custom pipe profile described by a curve are currently not exported

- See ``vw_swmm_conduits.sql`` and ``vw_swmm_xsections.sql`` for details.

**Pumps**

- TWW_SWMM creates a pump for each TWW pump. When a curve ``tww_od.hq_relation`` is liked to the pump it is exported as a SWMM curve.

- See ``vw_swmm_pumps.sql`` and ``vs_swmm_curves.sql`` for details.

**Orifices**

No correspondance in TWW. Orifices are not created from TWW objects. An empty table is created

- See ``vw_swmm_orifices.sql`` for details.

**Weirs**

- Are created from TWW prank weir (without H/Q relation) and leaping weir.

- See ``vw_swmm_weirs.sql`` for details.

**Outlets**

No correspondance in TWW. However, outlets are created to export TWW prank weir having a H/Q relation.

- See ``vw_swmm_outlets.sql`` for details.

**Transects**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

**Controls**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Quality
^^^^^^^

**Land uses**

- TWW_SWMM creates a SWMM land use kind for each TWW planning zone kind.

- See ``vw_swmm_landuses.sql``

**Pollutants**

No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Curves
^^^^^^
- Are created for pumps linked to a ``tww_od.hq_relation`` and for wastewater structures linked to a ``tww_od.hydr_geom_relation``

- See ``vw_swmm_curves.sql`` for details.

Time series
^^^^^^^^^^^
No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Time patterns
^^^^^^^^^^^^^
No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.

Labels
^^^^^^
No correspondance in TWW. This parameter must be set by the user in the template ``.inp`` file or before running the simulation.

- Copied from the template input file if exists.
