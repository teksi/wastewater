Model Mapping
=============

Model mappings define how source-model classes and attributes correspond to
the canonical TWW model. 

The canonical model is the internal TEKSI wastewater model represented by
``tww_od`` and supported extension tables.

Source and canonical identifiers
--------------------------------

A mapping always points from a source representation to a canonical target.

Example:

.. code-block:: text

   Source:
       versickerungsanlage

   Canonical:
       infiltration_installation

Example attributes:

.. code-block:: text

   Source:
       datenbewirtschafterref

   Canonical:
       fk_provider

For INTERLIS models that are no translations (i.e. VSA DSS 2020.1), the source 
attribute names always correspond to the lowercase equivalent of the INTERLIS model.
For translated models, they correspond to the model language they are a TRANSLATION OF.
Canonical identifiers do not change with source language.

Mapping types
-------------

A class may use one of two projection styles.

Attribute-backed mapping
   Maps source attributes directly to canonical attributes.

Function-backed mapping
   Passes a source row to a SQL projection function that returns canonical
   effects. These are mainly intended for model extensions with more complex
   semantic transformations.

A single class must not mix a function-backed projection with direct
attribute projection unless the mapping schema explicitly supports that
combination.

Attribute-backed mapping
------------------------

Use an attribute-backed mapping where a source value corresponds directly to a
canonical attribute.

.. code-block:: yaml

   classes:

     kanal:
       attributes:

         nutzungsart:
           targets:
             - class: channel
               attribute: usage_current

The source class and attribute use identifiers from the imported source model.

The target class and attribute use canonical identifiers.

Function-backed mapping
-----------------------

Use a function-backed mapping where:

* one source row affects several canonical objects;
* the canonical target depends on source context;
* several effects must be created;
* direct attribute mapping is insufficient.

.. code-block:: yaml

   classes:

     GepKnoten:
       function:
         schema: tww_app
         name: fct_agxx_gepknoten_mapping_jsonb
         parameters:
           row: $row

The SQL function returns a canonical effect document.

For the effect format, see the JSONB mapping documentation in the developer
section.

Explicit and implicit mappings
------------------------------

The framework may combine two sources of mapping information.

Implicit mapping
   Supplies mappings obtained from dictionary metadata or model structure.

Explicit mapping
   Supplies administrator-defined declarations, overrides and semantic roles.

Explicit mappings are required where structural discovery cannot determine the
intended meaning.

Examples include:

* one source class mapping to several canonical targets;
* several foreign keys referencing the same canonical class;
* language-specific source names;
* secondary canonical identities;
* function-backed projections.

Mapping inheritance
-------------------

Explicit class declarations may be inherited through the source ORM class
hierarchy.

For example:

.. code-block:: text

   ueberlauf
       -> overflow

   foerderaggregat
       -> pump
       inherits from ueberlauf

An explicit relation role declared for ``overflow`` may be inherited while
resolving ``pump``.

The child retains its own primary canonical class. Parent declarations do not
replace the child's implicit canonical class.

Mapping precedence
------------------

For attribute-backed mappings, the effective mapping is resolved in this
general order:

#. implicit class mapping;
#. inherited explicit class declarations;
#. applicable explicit model defaults;
#. explicit localized relation declarations;
#. explicit class attributes;
#. identity localization;
#. optional foreign-key inference;
#. validation against canonical metadata.

Later explicit declarations override earlier general declarations where they
address the same source attribute.

Projection modes
----------------

The framework distinguishes mapping knowledge from projection intent.

Full projection
~~~~~~~~~~~~~~~

Full projection is normally used for imports of the standard VSA models.

It may include:

* implicitly mapped classes;
* implicit attributes;
* explicit defaults;
* explicit class attributes;
* explicit relation roles;
* unambiguous foreign-key inference;
* function-backed mappings.

Explicit-only projection
~~~~~~~~~~~~~~~~~~~~~~~~

Explicit-only projection is normally used for supported model extensions.
For these, the goal is to only map the data that is not already processed
through a delivery of standard VSA model data or that is necessary for the
semantic transformation on import.

It includes:

* explicitly selected classes;
* explicit attributes;
* applicable explicit defaults;
* function-backed mappings.

Implicit mappings may still provide structural information, including:

* the canonical class identifier;
* primary identity information;
* referenced canonical class resolution.

Implicit mappings do not expand the projected attribute set in explicit-only
mode.

Relation declarations used only to resolve structural ambiguity do not
automatically need to become incrementally projected values. The mapping
configuration distinguishes relation semantics from projection
selection.

Relations
---------

A relation declaration identifies the semantic role of a source foreign key.

.. code-block:: yaml

   relations:

     fk_provider:
       target:
         class: organisation
       localisations:
         de: datenbewirtschafter_gep

This means:

.. code-block:: text

   Source attribute:
       datenbewirtschafter_gep

   Canonical local attribute:
       fk_provider

   Canonical referenced class:
       organisation

A relation should be declared explicitly when more than one canonical
attribute can reference the same canonical class.

For example, a class that contains both:

* ``fk_dataowner``;
* ``fk_provider``.

Both reference ``organisation``. The referenced class alone is therefore
insufficient to determine the relation role.

Identities
----------

An identity mapping contains two different identifiers.

``source_attribute``
   Attribute read from the quarantine source row.

``target_attribute``
   Canonical attribute used to identify the target object.

Primary example:

.. code-block:: text

   Source:
       t_ili_tid

   Canonical:
       obj_id

Secondary extension example:

.. code-block:: yaml

   identities:

     agxx_last_modification:
       source_attribute: t_ili_tid
       target_attribute: fk_element

The same source identity may identify both:

* the primary canonical object through ``obj_id``;
* an extension object through a canonical relation such as ``fk_element``.

Secondary target identities should be configured explicitly. Do not assume
that a missing source ``obj_id`` can always be replaced with the current row's
``t_ili_tid``.

Foreign-key values
------------------

ili2pg may represent an internal source relation as an integer ``t_id``.

Canonical TWW relations normally use an INTERLIS object identity.

The projection process therefore converts:

.. code-block:: text

   source integer t_id
       -> referenced source object
       -> referenced t_ili_tid
       -> canonical object identifier

String object identifiers that are already canonical or externally supplied
may pass through unchanged.

Ordinary integer values, such as value-list codes, are not foreign keys and
must not be processed as identities.

Validation
----------

The effective mapping is validated against canonical metadata before
effects are produced.

Validation detects:

* unknown canonical classes;
* unknown canonical attributes;
* missing source attributes;
* missing identities;
* ambiguous relation roles;
* incompatible function and attribute mappings;
* foreign keys without a canonical target.