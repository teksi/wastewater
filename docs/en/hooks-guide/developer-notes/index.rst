Developer Notes
===============

This section documents the internal architecture of the TWW hooks framework
and the TEKSI wastewater integration.

It is intended for developers who:

* maintain ``teksi_hooks``;
* maintain TWW-specific hook logic;
* integrate hooks into the TEKSI wastewater QGIS plugin;
* implement source-model mappings;
* extend rights evaluation;
* implement review and persistence adapters;
* diagnose mapping, projection and workflow failures.

The developer documentation focuses on runtime behavior, component boundaries
and extension points.

For configuration administration, see :doc:`../sysadmin/index`.

The import-review user documentation will describe how proposed imports are
assessed, accepted or rejected.

Package responsibilities
------------------------

The implementation is split across three conceptual layers.

``teksi_hooks``
   Generic models, protocols, capabilities, evaluators and workflow services.

``tww_hooks``
   TWW-specific parsed and resolved configuration, rights definitions,
   provider declarations and mapping logic.

``teksi_wastewater``
   QGIS integration, ili2pg orchestration, PostgreSQL adapters, ORM discovery,
   quarantine projection and diff persistence.

Core processing model
---------------------

The runtime processing model is:

.. code-block:: text

   source XTF
       |
       v
   ili2pg quarantine schema
       |
       v
   source ORM reflection
       |
       v
   effective model mapping
       |
       v
   relation contexts
       |
       v
   canonical effects
       |
       v
   row-level changes
       |
       v
   rights and validation classification
       |
       v
   review features
       |
       v
   prepared source or persisted diff job

Contents
--------

.. toctree::
   :maxdepth: 2

   architecture
   workflow-orchestration
   canonical-model
   model-mapping
   jsonb-mapping
   projection-modes
   identities-and-relations
   effects-and-changes
   rights-evaluation
   review-generation
   persistence
   caching
   extension-points
   testing
   troubleshooting
