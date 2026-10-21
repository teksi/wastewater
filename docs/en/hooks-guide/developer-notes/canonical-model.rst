Canonical Model Metadata
========================

Canonical model metadata describes the target classes and attributes accepted
by effects, changes, rights evaluation and review persistence.

The canonical model is not the source INTERLIS model and is not the quarantine
schema.

Adapter
-------

``TwwCanonicalModelAdapter`` builds ``CanonicalModelMetadata``.

The adapter combines:

* semantic dictionary metadata from ``tww_sys``;
* structural metadata from the TWW ORM;
* physical attributes absent from the dictionary;
* inherited ORM attributes;
* canonical foreign-key structure;
* extension classes such as AG-XX classes.

Metadata precedence
-------------------

Dictionary metadata remains authoritative where an entry exists.

ORM reflection supplements missing structural entries.

.. code-block:: text

   dictionary entry exists
       -> preserve dictionary metadata

   physical ORM entry exists but dictionary entry is missing
       -> create reflected metadata

The adapter must not overwrite semantic localization or datatype information
from the dictionary with less-specific reflected values.

Classes
-------

Canonical classes are keyed by stable canonical identifiers, normally physical
TWW table names.

Examples:

* ``wastewater_structure``;
* ``catchment_area``;
* ``infiltration_installation``;
* ``agxx_last_modification``.

Attributes
----------

Canonical attributes are keyed by:

.. code-block:: text

   canonical class identifier
   canonical attribute identifier

Example:

.. code-block:: text

   wastewater_structure_symbol
   fk_wastewater_structure

Reflected attributes include mapper-level inherited attributes where relevant.

Foreign keys
------------

Canonical foreign-key metadata records:

* local canonical class;
* local canonical attribute;
* referenced canonical class;
* referenced canonical attribute.

This information supports structural relation inference.

For example:

.. code-block:: text

   wastewater_structure_symbol.fk_wastewater_structure
       -> wastewater_structure.obj_id

A unique canonical FK to a referenced class may be inferred.

Several canonical FKs to the same referenced class require an explicit
semantic relation role.

Deterministic reflected identifiers
-----------------------------------

Reflected metadata without a dictionary source ID uses a deterministic
fallback source identifier.

The fallback ID is metadata provenance. Semantic identity remains the
canonical class or attribute identifier.

Caching
-------

The adapter may cache:

* resolved automap classes;
* canonical metadata;
* foreign-key descriptions;
* foreign-key lookup indexes.

The cache is valid only while the canonical ORM and release structures remain
unchanged.

Release manifests
-----------------

Canonical model structure is a candidate for release-versioned persistence.

A normalized manifest may contain:

* classes;
* attributes;
* datatypes;
* geometry attributes;
* inheritance;
* foreign keys;
* identity fields;
* schema release.

The manifest must not contain SQLAlchemy mapped classes or mapper instances.

A development verification mode may compare the packaged manifest with ORM
reflection to detect release mismatches.