Important to know on the TWW-project
====================================

Project Properties
------------------
There are several important properties in a TWW-project:

.. figure:: images/project_properties.jpg

Data Sources
^^^^^^^^^^^^
Important Settings:

* Transaction mode has to be **Automatic Transaction Gropus**

* **Evaluate default values on provider side** has to be checked

.. figure:: images/properties_datasources.jpg

Relations
^^^^^^^^^^^^

Variables
^^^^^^^^^^
The TWW-project uses project variables to simplify some of QGIS-functionalities. These approaches are not TWW specific and can be used also in other QGIS-projects.

In the project used variables have names that start with "tww".

.. figure:: images/properties_variables.jpg

**4 Variables for label translations**

TWW uses 4 variables to translate the labeling of manholes into the desired language. Without changing the variables, the levels are labeled with "english" letters: "C" for cover level, "I" for Input level, "O" for Output level, "B" for Bottom level. In a german project, you will change these variables to "D" (Deckel), "E" (Einlauf), "A" (Auslauf) and "S" (Sohle) to get the expected labels.

Background: the database uses always the "english" letters to write the _*_label fields in vw_tww_wastewater_structure. In the label-definition of vw_tww_wastewater_structure is a "replace" formula, that change the "english" letter to the letter defined in the project variables 'concat(_label, replace(_cover_label,'C',@tww_cover_prefix), replace(_bottom_label,'B',@tww_bottom_prefix), replace(_input_label,'I',@tww_input_prefix), replace(_output_label,'O',@tww_output_prefix))'

**2 Variables to define big or small symboles**



**4 Variables to define the scale, where the plansymbols change**

Styles/Project Colors
^^^^^^^^^^^^^^^^^^^^^

Map Themes
----------
