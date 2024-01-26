How To
======

This represents a guide on different themes about configuring in TWW.

Manual Label-positioning for different scales
---------------------------------------------

QGIS label definition can handle different labels for different scales. This works very well if you work on the screen.
If you have to print plans with labels or if you have to export labels for data exchange (e.g. exchange with RegioGIS-platform), it will often be necessary to determine the label positions manually.
If a label is positioned manually in QGIS, this fixed position applies to every scale. And that's not always a good result.

Solution

* Extend the Auxiliary Storage File with new fields for different labelpositions

* Use Rule-based labeling, then you can define different labelpositions for every rule

In the example below, we want to label the wastewater-structures with a detailed label for network_plan (1:500) and for overviewmap (1:2000).
In the Auxiliary Storage we use the standard fields PositionX and PositionY for the  network_plan labels. For the overviewmap labels we add two new fields.
We name this fields posx2000 and posy2000.

.. figure:: images/man_labeling_newfields.jpg

Define now rule-based labeling with two rules. In the example the first rule is called WP-Labels (WP = Werkplan = network_plan).
You have not the change something in the placement, because this rule uses the standard positioning-fields.

.. figure:: images/man_labeling_rules.jpg

The second rule is called UP-Labels (UP = Uebersichtsplan = overviewmap). In this rule, you have to change the coordinate fields in the placement-tab.

.. figure:: images/man_labeling_edit_rules.jpg

.. figure:: images/man_labeling_coordinatefield.jpg

Click on Coordinate X menutool and choose in the field type-menu the auxiliary_storage_user_custom_posx2000 field. Then the similar for Y.

.. attention:: Do not use the **Edit...** menu for defining the coordinate-field. If you use a formula or choose the field via the Edit... menu, QGIS will overwrite the definition everytime you do a manual positioning.

Now you can move or fix your labels for every rule with different positions with the QGIS **Moves a Label or Diagram**-Tool.

.. figure:: images/man_labeling_labeltools.jpg

.. attention:: Your changes are only saved if you save the QGIS-project!


How to import existing label-positions
--------------------------------------

Good label-positions can be hard work. So you don't want to loose it.

* Export your label-positions from your old system in the form obj_id, coordinateX (east), coordinateY (north).

* Add the **.qgd**-file of your project with **Add Vector Layer...** to your project and open the attribute table.

.. figure:: images/man_labeling_auxtable.jpg

If you can not find a .qgd-file, then you have probably not moved or rotated a label before.

* Change the field-names in your export-data to the field-names in the qgd-file. In the example the obj_id-field must have the name **ASPK**, the coordinate-fields must have the names **labeling_positionx** and **labeling_positiony**.

* Open the export-file in the QGIS-project and copy the rows you want to the table of the qgd-file (this file must be editable).

* Save the qgd-file and remove it from your project, before you remove labels, because QGIS can not save manual label-positions, if the qgd-file is a layer in the project.

* If necessary define the horizontal/vertical alignment of your label-coordinates in the placement of the label definition.

How to translate a label prefix
-------------------------------

TWW automatically creates labels for wastewater-structures and reaches:

.. figure:: images/tww_labels.png

To easily translate label prefixes a series of QGIS project variables have been added. If you want to change the prefixes for cover level, bottom level and entry and exit levels, change the following project settings:

.. figure:: images/tww_label_prefix_settings.png


How to run symbology functions manually
---------------------------------------

Sometimes the labels such as bottom, cover or entry/exit levels are not correctly displayed, even if the corresponding attribut is filled in. This happens for example when you import data by INTERLIS Import or another way. May be you also decativated the triggers to speed up the import process.

* Activate / Deactivate symbology triggers::

   SELECT tww_sys.create_symbology_triggers()
   SELECT tww_sys.drop_symbology_triggers()

* Run **label function** for all entities (_label, _cover_label, _bottom_label, _input_label and _output_label)::
   SELECT tww_od.update_wastewater_structure_label(NULL, true)

.. figure:: images/tww_label_attributes.png

* Run depth calculation for all entities (wastewater_structure._depth)::
   SELECT tww_od.update_depth(NULL, true);

.. figure:: images/tww_system_attributes_depth.png

For symbolizing point elements (manholes, special structures etc. and  wastewater_nodes)  with _function_hierarchic and _usage_current the following two functions calculate the two tww attributes from the connected reach(es).

* Run **symbology function** for all entites (calculates function_hierarchic and usage_current from connected reach(es) and adds result to  wastewater_structure._function_hierarchic and _usage_current)::

   SELECT tww_od.update_wastewater_structure_symbology(NULL,true)

* Run **wastewater node symbology** for all entities (calculates function_hierarchic and usage_current from connected reaches and adds result to  wastewater_node._function_hierarchic and   _usage_current)::

   SELECT tww_od.update_wastewater_node_symbology(NULL, true);


Collecting a hydr_geometry (corresponds to a basin geometry in MikeUrban)
-------------------------------------------------------------------------

Note:

* Wastewater structures with a hydr_geometry have to be defined as special structures (and not as standard manholes).

* The detail geometry can be graphically drawn with the **Digitize action**.

Action:

1. Select the wastewater structure with the i-button

2. Select the wastewater nodes tab in the Feature Attributes window

3. Select a hydr_geometry in the fk_hydr_geometry field or use the + button to create a new hydr_geometry.

.. figure:: images/hydr_geometry1.jpg

4. Enter a description in the hydr_geometry - Feature Attributes window. This name is also the name of the table in MikeUrban.

5. Before you can create a hydr: geom_relation, the new record hydr_geometry must be saved: -> click OK

6. Go back to the hydr_geometry you just created with the button **switch to form view** in the field fk_hydr_geometry .

.. figure:: images/hydr_geometry2.jpg

7. With the **Add child object** button, you can now generate the records with which the hydr_geometry is defined analogously to the basin geometry of MikeUrban (H, As surface, Ac cross-sectional area).

.. figure:: images/hydr_geometry3.jpg

Note:

* The water depth is the value above the bottom level or the outlet. A hydr_geometry can thus be used for several wastewater structure if they are built similar.

* In the table view, the overview of the values is easier.


Hydraulic modeling of an overflow (prank weir / leapingweir / pump)
--------------------------------------------------------------------

Action:

In the case of weirs, a second sewage junction has to be created in the wastewater structure.
A second outlet has already been created (green = discharged combined wastewater) and has not yet been linked to any wastewater node in the overflow structure.

1. Select the wastewater structure with the i-button

2. Select the wastewater nodes tab in the Feature Attributes window

3. Create a second wastewater node with the **Add point child object** button. The light blue note at the top of the map tells you what to do!

.. figure:: images/overflow1.jpg

4. Click next to outlet 2 to place the second wastewater node.

5. The Feature Attributes window for this wastewater node appears. Enter a meaningful identifier (e.g. BSP001-WN2 for wastewater node 2 of the BSP001 special structure). This designation also appears in MikeUrban. The new wastewater node is saved with OK.

.. figure:: images/overflow2.jpg

In the next picture, the 2nd node is marked in yellow on the map and in the Feature Attributes window.

.. figure:: images/overflow3.jpg

We define now a prank weir:

6. Choose prank weir in the overflow tabs

7. Create a weir with the **Add child object** button

The prank weir Feature Attributes window opens. The attributes in the upper hydraulic section must be filled in, they will be transferred to MikeUrban.
The field fk_overflow_to must be filled manually. The Obj_ID of the previously created second wastewater node can be seen in the rear window.

.. figure:: images/overflow4.jpg

This information is sufficient for the calculation in MikeUrban with the weir formula.

Now only the 2nd outlet has to be linked to the 2nd wastewater node:

Close all open Feature Attributes window.

1. Select the TWW tool **Connect wastewater networkelements**.

2. Click on the reach near to the outlet

3. Click on the wastewater node

4. Confirm that the connection is created for the **from reach point**.

.. figure:: images/connect_2_node.jpg

Overflow characteristic
-----------------------

In the case of a leaping weir, a pump or under special conditions, an overflow characteristic can be defined for the overflow:

You can select an existing characteristic in the field fk_overflow_char or you creat a new one characteristic with the green + button.

The Feature Attributes window for the overflow characteristic appears:

.. figure:: images/overflow_char1.jpg

1. Here too, the identifer is later adopted in MikeUrban as a table name for a QH relationship, which is used, for example, in a local controller.

2. Because the new record overflow characteristic has not yet been saved, it must first be saved with OK before the records of the HQ relation can be created.

3. Go back in the field fk_overflow characteristic of the just created overflow characteristic with the button **switch to form view** and define the necessary HQ or QQ values with the **add child object** button.

Further informations
--------------------

Further Q & A's you can find in the
`TWW Discussion section <https://github.com/TWW/TWW/discussions/categories/q-a>`_
