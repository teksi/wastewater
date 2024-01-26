.. _TWW-SWMM-data-requirements:

TWW-SWMM data requirements
===========================

To run a sucessful simulation in SWMM the following minimal data has to be filled in to be matched to the swmm objects

JUNCTIONS and COORDINATES
^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table:: JUNCTIONS and COORDINATES
   :header: "SWMM attribute", "Description", "TWW equivalent"
   :widths: 30, 50, 30

   "Name", "User-assigned junction name.", "wastewater_node.obj_id"
   "X-Coordinate / Y-Coordinate", "Coordinate of node [COORDINATES]", "wastewater_node.situation_geometry"
   "Description", "Description of node", "wastewater_structure.identifier"
   "Tag", "Optional label used to categorize or classify the junction.", "manhole.obj_id"
   "Invert El.", "Invert elevation of the junction", "wastewater_node.bottom_level"
   "Max. Depth", "Maximum depth at the junction (i.e., the distance from the invert to the ground surface) (feet or meters). If zero, then the distance from the invert to the top of the highest connecting link will be used.", "Difference of cover.level minus wastewater_node.bottom_level"

CONDUITS
^^^^^^^^

.. csv-table:: CONDUITS
   :header: "SWMM attribute", "Description", "TWW equivalent"
   :widths: 30, 50, 30

   "Name", "User-assigned conduit name.", "wastewater_node.obj_id"
   "Inlet Node", "Name of node on the inlet end of the conduit (which is normally the end at higher elevation).", "from wastewater_node.obj_id"
   "Outlet Node", "Name of node on the outlet end of the conduit (which is normally the end at lower elevation).", "from wastewater_node.obj_id"
   "Description", "Description of conduit", "wastewater_networkelement.identifier"
   "Tag", "Optional label used to categorize or classify the conduit.", "wastewater_networkelement.fk_wastewater_structure"
   "Max. Depth", "Maximum depth of the conduit's cross section", "Difference of Cover.level minus Wastewater_node.bottom_level"
   "Length", "Conduit length", "reach.length_effective or calculated from reach.progression_geometry if length_effective is empty"
   "Roughness", "Manning's roughness coefficient.", "reach.wall_roughness"
   "InletOffset", "Depth or elevation of the conduit invert above the node invert at the inlet end of the conduit", "reach_point_from.level minus from_wastewater_node.bottom_level"
    "OutletOffset", "Depth or elevation of the conduit invert above the node invert at the outlet end of the conduit ", "reach_point_to.level minus to_wastewater_node.bottom_level"

XSECTIONS
^^^^^^^^^

.. csv-table:: XSECTIONS
   :header: "SWMM attribute", "Description", "TWW equivalent"
   :widths: 30, 50, 30

   "Shape", "geometric properties of the conduit's cross section e.g. CIRCULAR.", "pipe_profile.profile_type"
   "Geom1", "Maximum height of conduit", "reach.clear_height/1000 [m] to [mm]"
