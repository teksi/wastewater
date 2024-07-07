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

Often are symbols big or small or with different labels depending on attributs (primary or secondary network, owner of the wastewater_structures). Because there are also differences in the languages (pwwf / paa / oap ...), it's one way, to define in a variable, which value has big symbols. You can use this variable in rule based symboldefinitions or in the size definition of symbols or in value definition of labels etc. in differnet layers.

**4 Variables to define the scale, where the plansymbols change**

In VSA-DSS are 5 plan-types defined (pipeline_registry, network_plan, 3 overview maps). Every plan has other rules for labeling and symbols. Therefore you have to define scales, where to show which plan-type. And these scales are used in reach labeldefinition, in reach symboldefinition, in manhole labeldefinition and manholesymboldefinition (and with several styles in every layer). If you work with variables, you can easy change the scales.

Example of a symboldefinition: 

Styles/Project Colors
^^^^^^^^^^^^^^^^^^^^^

Map Themes
----------
