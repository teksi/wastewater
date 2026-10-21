Projection Modes
================

Projection mode controls which available mapping knowledge becomes canonical
effects.

The mode is immutable for the lifetime of a relation-context provider.

Modes
-----

``full``
   Used for full-state baseline projection.

``explicit_only``
   Used for incremental projection where only declared content should update
   canonical state.

Composition boundary
--------------------

The mode is selected where the effective mapping and relation-context provider
are assembled.

Conceptually:

.. code-block:: python

   projection_mode = (
       MappingProjectionMode.EXPLICIT_ONLY
       if is_incremental
       else MappingProjectionMode.FULL
   )

A distinct provider instance is created for each source and projection mode.

The effect projector does not decide the mode. It consumes the already-scoped
relation contexts.

Full projection
---------------

Full projection may select a relation when:

* an implicit mapping exists;
* an explicit mapping exists;
* an inherited explicit mapping exists.

It may include:

* implicit attributes;
* explicit defaults;
* explicit class attributes;
* explicit localized relations;
* inferred unambiguous foreign keys;
* function-backed mappings.

Explicit-only projection
------------------------

Explicit-only projection selects content through explicit intent.

It may include:

* explicit class attributes;
* applicable explicit defaults;
* explicitly selected direct mappings;
* function-backed mappings.

Implicit mapping may provide structural support:

* canonical class resolution;
* primary identity resolution;
* referenced canonical class resolution;
* canonical lookup support.

It must not add implicit attributes to the incremental projection.

Foreign-key automapping is disabled.

Relations and selection
-----------------------

Relation semantics and projection selection are separate concerns.

A relation declaration may explain that a source FK represents
``fk_provider`` rather than ``fk_dataowner``.

That semantic declaration does not necessarily mean that the relation should
be emitted by every incremental projection.

A future mapping schema may represent this distinction explicitly through:

* relation-role declarations;
* projection-selection declarations.

Until then, explicit-only mapping logic must avoid assuming that every
structurally necessary relation is an incremental update.

Caching
-------

A cached provider must not switch projection modes.

Use separate provider instances:

.. code-block:: text

   baseline provider
       full
       own cache

   incremental provider
       explicit_only
       own cache