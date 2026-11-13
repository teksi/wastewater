Configuration Overview
======================

The TWW hooks framework separates configuration into model mappings, rights
definitions and provider assignments. Model mappings are statically defined by
the plugin, while rights definitions and provider assignments can be overridden
depending on the SysAdmin needs.

Each configuration area answers a different question.

Model mapping
   How does a source-model element correspond to the canonical TWW model?

Rights
   Which privileges are required for an operation on a canonical class or
   attribute?

Provider assignments
   Which privileges does a provider hold for a particular data owner?

The three configuration areas are evaluated together during change
classification.

Configuration pipeline
----------------------

Configuration is processed in stages.

Parser
   Reads the source configuration and creates parsed data structures.

Resolver
   Applies defaults, inheritance and reusable declarations.

Capability
   Exposes the resolved configuration through read-only lookup operations.

Evaluator
   Uses the resolved configuration for rights decisions, conditions and
   validations.

An administrator normally edits the parser input, usually YAML. Runtime
behavior is based on the resolved configuration, not directly on the YAML
text.

This distinction matters when diagnosing inheritance, defaults and stale
deployed files.

Authoritative configuration
---------------------------

Every installation identifies one authoritative source location for each
configuration area.

The authoritative location must be:

* version controlled;
* reviewed with the corresponding plugin release;
* deployed through a repeatable process;
* distinguishable from generated or copied files.

Avoid editing configuration directly inside a deployed QGIS profile unless
the change is an emergency diagnostic change.

A typical installation may contain several copies:

.. code-block:: text

   Source repository
       Authoritative configuration edited by developers or administrators

   Build or release directory
       Packaged configuration produced from the source repository

   QGIS plugin profile
       Deployed configuration used at runtime

   Temporary test directory
       Configuration used by integration or workflow tests

After changing a configuration file, verify which copy is loaded at runtime.

Configuration inheritance
-------------------------

Model mappings and rights definitions support inheritance and defaults.

Inheritance is resolved before runtime lookup. The effective configuration may
therefore contain declarations from:

* the selected configuration;
* inherited parent configurations;
* model-level defaults;
* class-specific overrides.

Child declarations override inherited declarations with the same
identifier.

Mapping inheritance and rights inheritance are separate mechanisms. A class
inherited by a model mapping is not automatically inherited by the rights
configuration.

Canonical namespace
-------------------

Runtime effects, changes, rights and review artifacts use canonical
identifiers.

Localized source identifiers are valid only where the mapping schema expects a
source-side name.

For example:

.. code-block:: yaml

   relations:

     fk_provider:
       target:
         class: organisation
       localisations:
         de: datenbewirtschafterref

In this declaration:

``fk_provider``
   Canonical local attribute.

``organisation``
   Canonical referenced class.

``datenbewirtschafterref``
   German source attribute.
