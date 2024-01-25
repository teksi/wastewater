Importing data
==============

It is quite easy to import data (geometry and attributes) from an external software.
Here is a general description and a specific example.

General
-------

* You have to add the data you want to import as (vector) layer into the TWW project.
* The field names of the attributes have to be the same as the field names of the TWW Layer.
  Therefore it is normally not a good idea the use shp-files, because of the 10 letters limitation of the dbf-format (Alias field names do not work).
* If you have a translated project, be sure to take the English field names (not the translated name that you find as Alias of the field).
* If there is a field with value list, you have to use the code, not the plain text.
* If your fields are prepared as described above, then just copy and paste in the TWW-layer.

Example Importing manholes from a TXT-File:
-------------------------------------------

* Change the field names to identifier, x, y, co_level

.. figure:: images/importdata_txtfile.jpg

* Open the txt-file with :menuselection:`Layer --> Add Layer --> Add Delimited Text Layer...`.

.. figure:: images/importdata_opentxtfile.jpg

* You have now a vector-layer with your points in the TWW-project
* Select the points of the new layer

.. figure:: images/importdata_selectpoints.jpg

* Choose :menuselection:`Edit --> Copy Features`.
* Select the vw_tww_wastewater_structure layer and set it editable
* Choose :menuselection:`Edit --> Paste Features`.

.. figure:: images/importdata_5newpoints.jpg

.. figure:: images/importdata_5newpointstable.jpg

.. note:: The ws_type is set as default to manhole. The identifier is used not only for the wastewater_structure, but also as cover_identifier and as wastewaternode_identifier.

Example Importing manholes with attributes:
-------------------------------------------

* Example to add additional attributes

.. figure:: images/importdata_txtfile2.jpg

* The field ws_type is an exception. Possible values are manhole, special_structure, infiltration_installation, discharge_point.
* For other fields with value lists you have to use the code.
* In the example above, the values for ma_function in the row discharge_point or special_structure has no effect.
