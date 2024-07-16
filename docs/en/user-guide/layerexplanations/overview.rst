.. figure:: images/teksiabwasser.png

Introduction and Overview
=========================

**TWW** is a selection of tools and a database implementation to work with the data in the data structure for wastewater and GEP, short VSA-DSS.

.. note:: The Data Structure for urban drainage systems of the Swiss Waste Water Association (in German Verband Schweizer Abwasser- und Gewässerschutzfachleute (VSA)), referenced to usually as VSA-DSS was published 1999 and is since then the valid standard for data covering General Water Drainage Planning (in German Generelle Entwässerungsplanung (GEP). When applying VSA-DSS you also comply to SIA405 Abwasser, the subset for sewer networks as described in `Norm SIA405 (Merkblatt 2015 / 2016) <http://www.sia.ch/de/dienstleistungen/sia-norm/geodaten/>`_. More information about datamanagement in urban drainage you can find on the homepage of the `VSA https://vsa.ch/fachbereiche-cc/siedlungsentwaesserung/generelle-entwaesserungsplanung/datenmanagement/`_

.. note:: The current database implementation in PostgreSQL is for the Version 2020.1 of the VSA-DSS datamodel, including the extension for sewer TV inspections called VSA-KEK (2020).

.. note:: We recommend you to get an access licence for the VSA-Wiki by purchasing it in the `VSA Shop <https://vsashop.ch/de/A~21_1100~1/Datenstruktur-Siedlungsentw%C3%A4sserung-VSA-DSS-Lizenz/Mitglied>`_. You will get answers and access to all model related questions, like the datamodel in INTERLIS, object catalogues and additional description and introduction and transfer datasets, the Wegleitung Daten der Siedlungsentwässerung and information about changes and updates as well as the right to test and convert unlimited INTERLIS dataset for one year with the `VSA Checker <https://vsa.ch/fachbereiche-cc/siedlungsentwaesserung/generelle-entwaesserungsplanung/datenmanagement/#GEP-Datachecker>`_. Some cantons offer this access for free for engineering companies and communities - please check with your Environmental office.

To work with TWW-tools, it is important to know also the following norm: **Wegleitung Daten der Siedlungsentwässerung** which is a practitioners guide to modelling reality into GIS and hydraulic datamodel of the VSA and there specially the annex "**Erfassungsrichtlinien**" (data acquisition policy) and "**Erfassungsbeispiele**". The VSA offers it as a full package on the `VSA-Wiki <https://vsa.ch/Mediathek/gep-datachecker-jahresgebuehr/>`_ which also includes acces to the VSA-Checker (a tool to check INTERLIS files)

This is important because with VSA-DSS you do not only describe the manholes and channels (wastewater structures as constructive part), but with the nodes and reaches you do create the hydraulic model of the sewer network (network elements) also.

It is important to know the difference between **primary and secondary wastewater facilities** (pwwf / swwf). There are not the same rules for placing wastewater nodes in pwwf and swwf-networks. Catchment areas should be connected only to pwwf-network.
Reaches are always created in flow-direction (flow direction in case of normal-flow).

To support the digitizing, TWW uses two main-views: **vw_tww_wastewater_structure** and **vw_tww_reach**. To edit these main views, there is a special wizard and the preconfigured feature attribute windows of these views.
The idea is, to support with the wizard the digitizing, so that 95% of the manholes and channels can be collected on the general-tab of the feature attribute-window, that means with as few mouse clicks as possible.

Before starting with digitizing, think about the obj_id of the records you will create. A VSA-DSS record must have a OID composed of prefix and postfix. The postfix is created by TWW-database. The prefix has to be defined in tww_sys.oid_prefixes before starting digitizing (look chapter 'Setup workstation' in 'TWW Installation Guide').

**TWW wizard**

To use the wizard (:ref:`digitizing-wastewater-structures`) is recommended for digitizing reaches because it supports snapping and connecting to the nodes preferred to the reaches. If you use the QGIS - Add line feature - tool you can not select and pick the nodes as easy.
