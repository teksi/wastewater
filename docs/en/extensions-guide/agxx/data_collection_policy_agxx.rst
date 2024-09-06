.. _data_collection_policy_agxx:

Data collection policy
=======================

Mapping
-----------

The AG-64/AG-96 object-ids are mapped to the database as follows:

 * Infrastrukturknoten/GEPKnoten is mapped to ``tww_od.wastewater_node``
 * Infrastrukturhaltung/GEPHaltung is mapped to ``tww_od.reach``
 * Ueberlauf_Foerderaggregat is mapped to ``tww_od.overflow``
 * Einzugsgebiet is mapped to ``tww_od.catchment_area``
 * SBW_Einzugsgebiet is mapped to ``tww_od.catchment_area_totals``
 * GEPMassnahme is mapped to ``tww_od.measure``
 * VersickerungsbereichAG is mapped to ``tww_od.infiltration_zone``

Wherever possible, the value lists of VSA DSS are used. In cases where a 1:1 mapping is possible, there is no additional value list entry for AG-64/96. Instead, one can use the corresponding VSA-DSS value which is translated on export. These cases are listed below.

Almost all VSA-DSS values of the mentioned layers that do not exist in AG-64/96 are mapped to AG-64/96 using a backwards relation. Per default, the VSA-specific value list codes which are ambiguous in AG-64/96 are set to ``inactive``.

The AG-64/96 values are automatically mapped to VSA DSS where sensible, allowing to export both models.

Handling of organisations
^^^^^^^^^^^^^^^^^^^^^^^^^
In the models AG-64/AG-96, the organisations table differs from VSA. It has 20 characters and uses a different prefix. In order to maintain the VSA compatibility, TWW 2 AG-64/96 uses the VSA tables.

There is a set of private entities in the AG-64/AG-96 organisations dataset that were not ported to VSA DSS. For these organisations, we use a OID prefix that was generated solely for this purpose and the AG-64/AG-96 postfix. The corresponding data is imported on initialisation.

When exporting a dataset, the organisations are not exported from the TEKSI database. Instead, the AG-64/96 Organisation dataset is stored within the plugin and added to the export dataset.

Last Modification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
in AG-64/96, the last modification value of cadastre and general planning are separated. To keep track of them, they are managed on the database. There is a widget in the settings to alter the current value, `see here <./plugin_setup_agxx.html>`_ .


Infrastrukturknoten/GEPKnoten
------------------------------

The base OID for the Infrastrukturknoten/GEPKnoten is taken from ``tww_od.wastewater_node``.

The FunktionAG is mapped from

  * manhole
  * special_structure
  * infiltration_installation.kind
  * discharge_point.relevance

The FunktionAG ``Kontrollschacht`` is not included in the value list. Use ``manhole`` or ``combined_manhole`` instead, which are mapped using a backwards relation.

The following table explains the mapping of FunktionAG in detail. If there are multiple options for TWW class, the type is defined dependent on whether a detail geometry exists. The value_de is only listed if the AG-64/96 value is not eligible

.. list-table::
   :widths: 24 36 20 20
   :header-rows: 1

   * - Value in AG-64/AG-96
     - structure type
     - Comment
   * - abflussloseGrube
     - special_structure
     -
   * - Absturzbauwerk
     - special_structure / manhole
     -
   * - Abwasserfaulraum
     - special_structure
     -
   * - Abwasserreinigungsanlage
     - wwtp_structure
     - any kind
   * - andere
     - special_structure / manhole / wastewater_node.ag64_function
     - 
   * - Anschluss
     - wastewater_node.ag64_function
     -
   * - Be_Entlueftung
     - special_structure / manhole
     -
   * - Bodenablauf
     - manhole
     -
   * - Dachwasserschacht
     - manhole
     -
   * - Duekerkammer
     - special_structure
     -
   * - Duekeroberhaupt
     - special_structure
     -
   * - Einlaufschacht
     - manhole
     -
   * - Einleitstelle_gewaesserrelevant
     - discharge_point
     - gewaesserrelevant
   * - Einleitstelle_nicht_gewaesserrelevant
     - discharge_point
     - nicht_gewaesserrelevant
   * - Entwaesserungsrinne
     - manhole
     -
   * - Faulgrube
     - special_structure
     -
   * - Gelaendemulde
     - special_structure
     - 
   * - Geleiseschacht
     - manhole
     - 
   * - Geschiebefang
     - special_structure
     -
   * - Guellegrube
     - special_structure
     -
   * - Klaergrube
     - special_structure
     -
     -
   * - Kontrollschacht
     - special_structure / manhole
     - use Kontroll-Einstiegschacht or Kombischacht
   * - Leitungsknoten
     - no wastewater structure
     -
   * - Messstelle
     - measurement not in special construction
     - 
   * - Oelabscheider
     - special_structure / manhole
     -
   * - Oelrueckhaltebecken
     - special_structure
     - maps to Behandlungsanlage on DSS export
   * - Pumpwerk
     - special_structure / manhole
     -
   * - Regenbecken_Durchlaufbecken
     - special_structure
     -
   * - Regenbecken_Fangbecken
     - special_structure
     -
   * - Regenbecken_Fangkanal
     - special_structure
     -
   * - Regenbecken_Regenklaerbecken
     - special_structure
     -
   * - Regenbecken_Regenrueckhaltebecken
     - special_structure
     -
   * - Regenbecken_Regenrueckhaltekanal
     - special_structure
     -
   * - Regenbecken_Verbundbecken
     - special_structure
     -
   * - Regenueberlauf
     - special_structure / manhole
     -
   * - Regenwasserrechen
     - special_structure
     -
   * - Regenwassersieb
     - special_structure
     -
   * - Rohrbruecke
     - special_structure
     -
   * - Schlammfang
     - manhole
     - maps to Schlammsammler on DSS export
   * - Schlammsammler
     - manhole
     -
   * - Schwimmstoffabscheider
     - special_structure / manhole
     -
   * - seitlicherZugang
     - special_structure
     -
   * - Spuelschacht
     - special_structure / manhole
     -
   * - Strassenwasserbehandlungsanlage
     - special_structure
     - maps to Behandlungsanlage on DSS export
   * - Trennbauwerk
     - special_structure / manhole
     -
   * - unbekannt
     - special_structure / manhole
     -
   * - Versickerungsanlage.Versickerungsbecken
     - infiltration_installation
     - 
   * - Versickerungsanlage.Kieskoerper
     - infiltration_installation
     - 
   * - Versickerungsanlage.Versickerungsschacht
     - infiltration_installation
     - 
   * - Versickerungsanlage.Versickerungsstrang
     - infiltration_installation
     - use Versickerungsstrang_Galerie
   * - Versickerungsanlage.Versickerungsschacht_Strang
     - infiltration_installation
     -  use Kombination_Schacht_Strang
   * - Versickerungsanlage.Retentionsfilterbecken
     - infiltration_installation
     - maps to andere_mot_Bodenpassage on DSS export
   * - Versickerungsanlage.andere
     - infiltration_installation
     - maps to unbekannt on DSS expor
   * - Versickerungsanlage.unbekannt
     - infiltration_installation
     - 
   * - Vorbehandlung
     - special_structure
     - use Vorbehandlungsanlage
   * - Wirbelfallschacht
     - special_structure
     -

Handling of building connections
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Building connections are defined in the datamodel as Infrastrukturknoten/GEPKnoten with funktionag "Anschluss". As these are no wastewater structures, the function is attributed to the wastewater node (``wastewater_node.ag64_function``).

Handling of covers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The AG-64/AG-96 data collection guidelines state the following:

  * The main wastewater node of a manhole or special structure must be mapped to the location of the main cover.
  * Secondary covers are mapped as Infrastrukturknoten/GEPKnoten with funktionag "andere".

As topological relations to a node of funktionag "andere" are technically possible, we need to link all covers to a wastewater node using ``tww_od.cover.ag64_fk_wastewater_node``.
In order to follow these limitations, there is an additional foreign key on ``tww_od.cover`` pointing to ``tww_od.wastewater_node``. A wastewater node's situation geometry is only overruled if it is referenced from a cover.
Additionally, the attribute ``wastewater_node.ag64_function`` can be set to "andere".

Handling of the attribute "IstSchnittstelle"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
AG-96 has an attribute ``IstSchnittstelle`` which is not present in VSA DSS 2020.1. The value is stored in ``tww_od.wastewater_node.ag96_isgateway``.

Infrastrukturhaltung/GEPHaltung
----------------------------------

Apart from street water and square water, the NutzungsartAG are not modelled as a value list extensions. Use the backwards relation instead.


Ueberlauf_Foerderaggregat
---------------------------------

The layer Ueberlauf_Foerderaggregat is mapped to `tww_od.overflow` and its specialisations

GEPMassnahme
----------------

GEPMassnahme is mapped to `tww_od.measure`. The following categories can be mapped 1:1 onto a VSA DSS value and therefore have no separate value list entrance.

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Value in AG-64/AG-96
     - value_de in TWW
   * - Reinigung
     - Erhaltung_Reinigung
   * - Retention
     - Abflussvermeidung_Retention_Versickerung
   * - Sonderbauwerk.Neubau
     - Sonderbauwerk_Neubau


Bautenausserhalbbaugebiet
-----------------------------

Bautenausserhalbbaugebiet is mapped to `tww_od.building_group`. There is no backwards mapping from VSA-DSS `Gebaeudegruppe.Sanierungsbedarf` to AG-96 `Bautenausserhalbbaugebiet.Sanierungsbedarf` because the value `unbekannt` cannot be mapped.

SBW_Einzugsgebiet
---------------------

SBW_Einzugsgebiet is mapped to `tww_od.catchment_area_totals`. The perimeter geometry is stored as an extension geometry attribute (``ag_96_perimeter_geometry``). In order to alter it, one needs to manually import the layer into the qgs project.

There exists a function to calculate the perimeter geometry by aggregating the catchment areas via catchment_area->log_card->main_log_card->hydraulic_char_data->catchment_area_totals.
The perimeter geometry is a MultiSurface, while the INTERLIS model requires a CurvePolygon. According to the official data collection policy of the Canton, one should violate the datamodel and export a MultiPart. As the underlying export mechanism ili2pg does not allow to export a wrong geometry type, only the biggest Singlepart is exported.

VersickerungsbereichAG
------------------------

VersickerungsbereichAG is mapped to `tww_od.infiltration_zone`.
