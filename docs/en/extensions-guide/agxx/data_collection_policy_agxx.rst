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

Almost all VSA-DSS values of the mentioned layers that do not exist in AG-64/96 are mapped to AG-64/96 using a backwards relation. Per default, the VSA-specific value list codes which are ambiguous in AG-64/96 are set to ´´inactive´´.

The AG-64/96 values are automatically mapped to VSA DSS where sensible, allowing to export both models.

Handling of organisations
^^^^^^^^^^^^^^^^^^^^^^^^^
In the models AG-64/AG-96, the organisations table differs from VSA. It has 20 characters and uses a different prefix. In order to maintain the VSA compatibility, TWW 2 AG-64/96 uses the VSA tables and alters the OID only on export.

There is a set of private entities in the AG-64/AG-96 organisations dataset that were not ported to VSA DSS. For these organisations, we use a OID prefix that was generated solely for this purpose and the AG-64/AG-96 postfix. The corresponding data is imported on initialisation.


Last Modification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
in AG-64/96, the last modification value of cadastre and general planning are separated. To keep track of them, they are managed on the database. There is a widget in the settings to alter the current value, `see here <./plugin_setup_agxx.html>`_ .


Infrastrukturknoten/GEPKnoten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The base OID for the Infrastrukturknoten/GEPKnoten is taken from ``tww_od.wastewater_node``.

The FunktionAG is mapped from

  * manhole.function
  * special_structure.function
  * infiltration_installation.kind
  * discharge_point.relevance

The FunktionAG ´´Kontrollschacht´´ is not included in the value list. Use ´´manhole´´ or ´´combined_manhole´´ instead, which are mapped using a backwards relation.

The following table explains the mapping of FunktionAG in detail. If there are multiple options for TWW class, the type is defined dependent on whether a detail geometry exists. The value_de is only listed if the AG-64/96 value is not eligible

.. list-table:: Mapping of FunktionAG
   :widths: 40 40 20
   :header-rows: 1
   * - Value in AG-64/AG-96
     - Row in TWW
	 - value_de
   * - abflussloseGrube
     - special_structure.function
	 -
   * - Absturzbauwerk
     - special_structure.function / manhole.function
	 -
   * - Abwasserfaulraum
     - special_structure.function
	 -
   * - Abwasserreinigungsanlage
     - wwtp_structure.kind
	 - any value
   * - andere
     - special_structure.function / manhole.function
	 -
   * - Anschluss
     - wastewater_node.ag64_function
	 -
   * - Be_Entlueftung
     - special_structure.function / manhole.function
	 -
   * - Bodenablauf
     - manhole.function
	 -
   * - Dachwasserschacht
     - manhole.function
	 -
   * - Duekerkammer
     - special_structure.function
	 -
   * - Duekeroberhaupt
     - special_structure.function
	 -
   * - Einlaufschacht
     - manhole.function
	 -
   * - Einleitstelle_gewaesserrelevant
     - discharge_point.relevance
	 - gewaesserrelevant
   * - Einleitstelle_nicht_gewaesserrelevant
     - discharge_point.relevance
	 - nicht_gewaesserrelevant
   * - Entwaesserungsrinne
     - manhole.function
	 -
   * - Faulgrube
     - special_structure.function
	 -
   * - Gelaendemulde
     - special_structure.function
	 -
   * - Geleiseschacht
     - manhole.function
	 -
   * - Geschiebefang
     - special_structure.function
	 -
   * - Guellegrube
     - special_structure.function
	 -
   * - Klaergrube
     - special_structure.function
	 -
   * - Kontrollschacht
     - manhole.function
	 - Kontroll-Einstiegschacht or Kombischacht
   * - Leitungsknoten
     - no wastewater structure
	 -
   * - Messstelle
     - measurement not in special construction
	 -
   * - Oelabscheider
     - special_structure.function / manhole.function
	 -
   * - Oelrueckhaltebecken
     - special_structure.function
	 -
   * - Pumpwerk
     - special_structure.function / manhole.function
	 -
   * - Regenbecken_Durchlaufbecken
     - special_structure.function
	 -
   * - Regenbecken_Fangbecken
     - special_structure.function
	 -
   * - Regenbecken_Fangkanal
     - special_structure.function
	 -
   * - Regenbecken_Regenklaerbecken
     - special_structure.function
	 -
   * - Regenbecken_Regenrueckhaltebecken
     - special_structure.function
	 -
   * - Regenbecken_Regenrueckhaltekanal
     - special_structure.function
	 -
   * - Regenbecken_Verbundbecken
     - special_structure.function
	 -
   * - Regenueberlauf
     - special_structure.function / manhole.function
	 -
   * - Regenwasserrechen
     - special_structure.function
	 -
   * - Regenwassersieb
     - special_structure.function
	 -
   * - Rohrbruecke
     - special_structure.function
	 -
   * - Schlammfang
     - manhole.function
	 -
   * - Schlammsammler
     - manhole.function
	 -
   * - Schwimmstoffabscheider
     - special_structure.function / manhole.function
	 -
   * - seitlicherZugang
     - special_structure.function
	 -
   * - Spuelschacht
     - special_structure.function / manhole.function
	 -
   * - Strassenwasserbehandlungsanlage
     - special_structure.function
	 -
   * - Trennbauwerk
     - special_structure.function / manhole.function
	 -
   * - unbekannt
     - special_structure.function / manhole.function
	 -
   * - Versickerungsanlage.Versickerungsbecken
     - infiltration_installation.kind
	 - Versickerungsbecken
   * - Versickerungsanlage.Kieskoerper
     - infiltration_installation.kind
	 - Kieskoerper
   * - Versickerungsanlage.Versickerungsschacht
     - infiltration_installation.kind
	 - Versickerungsschacht
   * - Versickerungsanlage.Versickerungsstrang
     - infiltration_installation.kind
	 - Versickerungsstrang_Galerie
   * - Versickerungsanlage.Versickerungsschacht_Strang
     - infiltration_installation.kind
	 - Kombination_Schacht_Strang
   * - Versickerungsanlage.Retentionsfilterbecken
     - infiltration_installation.kind
	 - Retentionsfilterbecken
   * - Versickerungsanlage.andere
     - infiltration_installation.kind
	 - andere
   * - Versickerungsanlage.unbekannt
     - infiltration_installation.kind
	 - unbekannt
   * - Vorbehandlung
     - special_structure.function
	 - Vorbehandlungsanlage
   * - Wirbelfallschacht
     - special_structure.function
     -

Infrastrukturhaltung/GEPHaltung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Apart from street water and square water, the NutzungsartAG are not modelled as a value list extensions. Use the backwards relation instead.


Ueberlauf_Foerderaggregat
^^^^^^^^^^^^^^^^^^^^^^^^^

The layer Ueberlauf_Foerderaggregat is mapped to ´tww_od.overflow´ and its specialisations

GEPMassnahme
^^^^^^^^^^^^^^^^^^^^^^^^^

GEPMassnahme is mapped to ´tww_od.measure´. The following categories can be mapped 1:1 onto a VSA DSS value and are therefore

.. list-table:: Mapping of Kategorie
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
^^^^^^^^^^^^^^^^^^^^^^^^^

Bautenausserhalbbaugebiet is mapped to ´tww_od.building_group´. There is no backwards mapping from VSA-DSS ´Gebaeudegruppe.Sanierungsbedarf´ to AG-96 ´Bautenausserhalbbaugebiet.Sanierungsbedarf´ because the value ´unbekannt´ cannot be mapped.

SBW_Einzugsgebiet
^^^^^^^^^^^^^^^^^

SBW_Einzugsgebiet is mapped to ´tww_od.catchment_area_totals´. The perimeter geometry is not mapped in the qgs project and needs to be loaded manually. There exists a function to calculate the perimeter geometry by aggregating the catchment areas via catchment_area->log_card->main_log_card->hydraulic_char_data->catchment_area_totals.
The perimeter geometry is a MultiSurface, while the INTERLIS model requires a CompoundCurve. According to the official data collection policy of the Canton, one should violate the datamodel and export a MultiPart. As the underlying export mechanism ili2pg does not allow to export a wrong geometry type, only the biggest Singlepart is exported.

VersickerungsbereichAG
^^^^^^^^^^^^^^^^^^^^^^

VersickerungsbereichAG is mapped to ´tww_od.infiltration_zone´.
