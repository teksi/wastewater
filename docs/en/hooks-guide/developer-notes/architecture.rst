Architecture
============

The hooks architecture separates generic workflow concepts from
TWW-specific configuration and database integration.

Layers
------

Generic hook framework
~~~~~~~~~~~~~~~~~~~~~~

``teksi_hooks`` defines reusable workflow contracts and models.

Its responsibilities include:

* hook execution;
* capability lookup;
* canonical object models;
* canonical effects;
* row-level changes;
* change classification;
* rights-evaluation protocols;
* relation lookup protocols;
* review-feature generation protocols;
* persistence-facing workflow interfaces.

The generic framework must not depend on:

* QGIS;
* TEKSI wastewater database schemas;
* ili2pg table names;
* AG-XX source classes;
* TWW-specific PostgreSQL adapters.

TWW domain configuration
~~~~~~~~~~~~~~~~~~~~~~~~

The TWW-specific configuration layer defines:

* model mappings;
* rights declarations;
* provider assignments;
* value mappings;
* mapping inheritance;
* rights inheritance;
* AG-XX mapping declarations.

Configuration generally passes through four stages.

Parser
   Converts YAML into parsed dataclasses.

Resolver
   Applies defaults, inheritance and normalization.

Capability
   Exposes resolved data through read-only lookup operations.

Evaluator
   Applies resolved declarations to runtime entities.

TEKSI wastewater integration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The TEKSI wastewater plugin layer implements:

* QGIS hook entry points;
* XTF import through ili2pg;
* quarantine-schema lifecycle;
* source ORM generation;
* canonical ORM discovery;
* source relation-context resolution;
* effect projection;
* live-object lookup;
* review-object providers;
* diff-schema persistence.

Dependency direction
--------------------

Dependencies should generally point inward toward generic protocols.

.. code-block:: text

   teksi_wastewater adapters
       -> tww_hooks capabilities
       -> teksi_hooks protocols and models

``teksi_hooks`` must not import concrete TEKSI wastewater adapters.

Concrete dependencies are assembled at the hook boundary.

Composition root
----------------

The hook acts as the workflow composition root.

It resolves externally provided capabilities, constructs TWW-specific
collaborators and injects them into services.

Example dependency flow:

.. code-block:: text

   HookContext
       |
       +-> DatabaseConnectionFactory
       |
       +-> mapping and rights capabilities
       |
       v
   DiffCreatorHook
       |
       +-> TwwCanonicalModelAdapter
       +-> TwwRelationContextProvider
       +-> TwwQuarantineEffectProjector
       +-> TwwChangeObjectProviderFactory
       +-> TwwDiffSchemaService
       |
       v
   TwwChangeCreationService

Generic protocols remain visible at service boundaries. Concrete TWW classes
remain in the composition layer and adapters.

Runtime data categories
-----------------------

The implementation works with several distinct data categories.

Configuration declarations
   Parsed YAML declarations such as mapping and rights rules.

Resolved configuration
   Immutable runtime mapping and rights structures.

Structural metadata
   ORM and canonical model structure, including tables, columns, inheritance
   and foreign keys.

Import data
   Rows imported into a quarantine schema.

Canonical effects
   Model-independent statements describing intended canonical outcomes.

Changes
   Row-level insert, update and delete operations derived from effects.

Classified changes
   Changes enriched with rights and validation findings.

Review features
   Old and proposed objects transformed for human review.

Persistence artifacts
   Prepared sources and diff-schema review jobs.

These categories should remain separate. In particular, ORM objects and
runtime relation contexts should not be treated as persistent configuration.