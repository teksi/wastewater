Extension Points
================

The architecture exposes protocols and capabilities for replacement or
extension.

Connection factory
------------------

``DatabaseConnectionFactory`` creates database connections for adapters.

Concrete factories are supplied through hook context capabilities.

Relation lookup
---------------

``RelationLookupCapability`` retrieves canonical objects by identity.

Implementations may use PostgreSQL, fixtures or in-memory data.

Effect projector
----------------

``QuarantineEffectProjector`` converts a source quarantine schema into an
``EffectDocument``.

Alternative implementations may support:

* another database;
* another source model;
* precomputed source data;
* test fixtures.

Relation-context provider
-------------------------

``RelationContextProvider`` supplies source ORM relations and their effective
class mappings.

A concrete implementation controls:

* source class selection;
* mapping inheritance;
* identity localization;
* projection mode;
* relation inference;
* canonical validation.

Change object provider
----------------------

``ChangeObjectProvider`` supplies old and proposed objects for review
generation.

``ChangeObjectProviderFactory`` creates a provider for one workflow.

Concrete implementation dependencies should be constructor-injected.

Rights evaluator
----------------

``RightsEvaluator`` consumes resolved rights, provider privileges, conditions
and relation lookup.

Specialized evaluators should retain the generic per-change context contract.

Function mappings
-----------------

SQL function mappings are an extension point for complex projections.

A projection function must return a supported canonical effect document.

Functions should not bypass canonical identity, attribute and effect
validation.

Canonical metadata
------------------

Alternative canonical metadata adapters may load:

* database dictionary tables;
* ORM reflection;
* release manifests;
* test fixtures.

All implementations must provide stable canonical IDs.