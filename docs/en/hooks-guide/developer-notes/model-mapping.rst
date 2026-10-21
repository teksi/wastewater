Model Mapping Resolution
========================

Model mappings connect source ORM structures to the canonical model.

Effective mapping
-----------------

``EffectiveModelMappingCapability`` exposes:

* explicit mapping capability;
* implicit mapping capability.

Both capabilities remain available in full and explicit-only projection modes.

Projection mode determines which mappings may expand the projected content.

Implicit mapping
----------------

Implicit mapping provides structural and dictionary-derived knowledge.

Typical contributions include:

* source class to canonical class;
* source attribute to canonical attribute;
* value mappings;
* primary identities.

Explicit mapping
----------------

Explicit mapping provides semantic declarations that cannot be determined
safely from structure.

Typical contributions include:

* function-backed class mappings;
* class overrides;
* explicit attribute mappings;
* secondary canonical identities;
* relation roles;
* localized source attributes;
* model-level defaults.

Class resolution
----------------

The concrete relation's implicit canonical class remains authoritative.

An inherited explicit parent declaration contributes attributes, relations and
identities but must not replace the concrete child's canonical class.

Resolution pipeline
-------------------

For an attribute-backed class, the provider performs:

#. implicit class lookup;
#. explicit hierarchy traversal;
#. parent-to-child explicit merge;
#. canonical class resolution;
#. applicability checking for explicit defaults;
#. explicit relation localization;
#. attribute merge;
#. identity resolution;
#. identity localization;
#. optional FK inference;
#. validation against canonical metadata.

Attribute precedence
--------------------

The effective attribute dictionary is assembled in this order for full
projection:

#. implicit attributes;
#. applicable explicit default attributes;
#. localized explicit relations;
#. explicit class attributes;
#. inferred foreign keys for still-unmapped source attributes.

Later mappings override earlier mappings for the same source attribute.

Explicit-only projection excludes implicit attributes and inferred foreign
keys from this assembly.

Explicit inheritance
--------------------

Source ORM inheritance is traversed from root to concrete child.

For each hierarchy class, explicit mappings may be looked up by:

* physical table name;
* declared ORM class name;
* canonical class ID from the implicit mapping.

Parent identities, attributes and relations are merged into child
declarations.

Child entries override parent entries with the same key.

Function mappings are not inherited as partial projections. A function mapping
represents a complete row-level projection.

Source identifiers
------------------

A source ORM relation may expose two useful identifiers.

Physical table name
   Usually used by implicit mappings.

Declared Python class name
   May be used by explicit conceptual mappings.

The physical name is checked first, followed by the declared class name.

Validation
----------

The final mapping is checked for:

* available source attributes;
* known canonical target classes;
* known canonical target attributes;
* identity coverage for every target class;
* supported function or attribute mapping structure.