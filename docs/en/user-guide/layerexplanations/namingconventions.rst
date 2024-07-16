Naming conventions
==================

Schemas in the TWW-Database
----------------------------
Schema in TEKSI-Databases will follow all the same rules. To destinguish, every infrastructre has his own shortcut (3 letters). TWW (TEKSI wastewater) is the shortcut for module wastewater network management.
The TWW-Database has five tww-schemas:

* tww_od: in this schema you find the tables, that correspond to the VSA-DSS-datamodel (cover, wastewater_node, channel, etc.) Also for sequences of these tables. Because of the new update-management, the views are no more in the *_od-schema, but in the *_app-schema.

* tww_vl: is the schema for value lists. There is a table for every value list of the VSA-DSS. As a TWW-user you can not edit these tables.

* tww_app: schema for all module-specific views, materialized views, functions, triggers, etc. Also for views and function of additional plugins (SWMM, QField). In case of an update of the database, this schema will overwriten.

* tww_sys: special tables for administration of the database. As a TWW-User you can not edit these tables.

* tww_cfg: to do: good explanantion

If INTERLIS-import or -export is used, then there will be additional schema like "pg2ili_abwasser". The are recreated with every import or export. Do not add these schema to the tww-project.


Layer names
-----------

* Layer names without prefix

This shows you, that you find the table in the tww_od-schema or (if the are in the layer-group "Value Lists", you find them in schema tww_vl).
If you are not sure in which schema to look for the table: place the mouse over the layer and look in the yellow popup-box for 'table="tww_*'.

* Layer Names that begin with vw_

Two or more VSA-DSS tables are joined in a view (vw). The layer has the name of the main-table. Example: vw_tww_reach: the main layer is the table reach (not the table channel).
It is important to know the main-table to be sure , that you use the correct attributes.


Attribute names
---------------

* Prefixes in attribute names

In a view, you find fields from different tables. In easier cases, there are only a subclass and a superclass included. In the tww-mainlayers there are several sub- und superclasses.
With the prefix of the attribute name, you know to which table an attribute belongs. The prefix are two letters that belong to a table of the VSA-DSS datamodel. Example: co = cover, ws = wastewater structure.
The convention is: attributes of the main table have no prefix, all other attributes have a prefix that points to the table they are from. In case of sub- and superclass, the two tables are taken together.
Example in layer vw_tww_reach: identifier is the attribute of the table wastewater_networkelement (the superclass of maintable reach) and therefore has no prefix. Material is in table reach, has no prefix because its the maintable. ch_usage_current is an attribute of the table channel. ws_remark is the attribute remark of the table wastewater_structure.

* fk_ fields

fk_ is not a shortcut for a special table. It stands for foreign key.

* _ fields

Attributes that start with _ (underscore) are calculated fields. You can not find them in the schemas. Examples: _slope_per_mill in vw_tww_reach.
_channel_usage_current in vw_qgwp_wastewater_structure is calculated from the field usage_current of the channel, that is connected with the foreign key of the wastewater_networkelement as outlet to a manhole or special structure.
