Model Mapping
=============

Model mappings describe how source-model classes and attributes are projected
onto the canonical TWW model.

In this documentation, the **canonical model** means the internal TEKSI
wastewater object model, usually represented by classes and attributes in
``tww_od`` and related extension tables. Examples are:

* ``wastewater_structure.status``
* ``channel.usage_current``
* ``infiltration_zone.infiltration_capacity``
* ``agxx_wastewater_node.ag64_function``
* ``agxx_infiltration_zone.ag96_q_check``

The source model can be AGXX, DSS or another import/export representation. The
mapping always points from the source representation to the canonical TWW
target.

A class mapping may define either a row-level function or direct attribute
mappings.

A mixed structure is rejected.


ili2pg DSS and the Canonical Model
----------------------------------

When DSS data is imported with ili2pg, the resulting database schema follows
the INTERLIS/DSS model structure. This schema is not treated as the canonical
model by the hooks framework.

The canonical model for rights evaluation and change comparison is the
internal TEKSI wastewater model, mainly represented by ``tww_od`` classes and
their extension tables. A DSS source attribute is therefore mapped to the
canonical TWW class and attribute that represents the same semantic value.

For simple DSS mappings, this can be expressed as a direct
attribute-backed mapping, as shown below. The key below ``classes`` refers to
the source model class. In this example, ``kanal`` is the German DSS source
class, while the target ``channel`` refers to the canonical TWW model in ``tww_od``:

.. code-block:: yaml

   classes:

     kanal:
       attributes:
         nutzungsart:
           targets:
             - class: channel
               attribute: usage_current



Function-backed class
---------------------

For complex cases, where a source row affects several canonical objects or
where the target depends on context, a row-level function mapping should
be used instead.


The function must return a canonical JSONB mapping document. For the expected
JSONB structure and supported effect kinds, see :doc:`jsonb-mapping`.

.. code-block:: yaml

   classes:

     GepKnoten:
       function:
         schema: tww_app
         name: fct_agxx_gepknoten_mapping_jsonb
         parameters:
           row: $row


Attribute-backed class
----------------------

Attribute-backed mappings are used when a source class can be mapped by direct
attribute-to-attribute rules. This is suitable for simple mappings where no
row-level SQL projection function is needed.

AGXX extension target example:

.. code-block:: yaml

   classes:

     VersickerungsbereichAG:
       attributes:
         q_check:
           targets:
             - class: agxx_infiltration_zone
               attribute: ag96_q_check

Canonical TWW target example:

.. code-block:: yaml

   classes:

     VersickerungsbereichAG:
       attributes:
         versickerungsmoeglichkeitag:
           targets:
             - class: infiltration_zone
               attribute: infiltration_capacity
