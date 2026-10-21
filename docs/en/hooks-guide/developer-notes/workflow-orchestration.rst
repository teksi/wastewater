Workflow Orchestration
======================

``TwwChangeCreationService`` orchestrates change creation from imported source
data.

The service does not own:

* XTF parsing;
* ili2pg execution details;
* mapping configuration parsing;
* ORM class definitions;
* rights configuration parsing;
* review approval decisions.

Collaborators
-------------

The service uses the following collaborators.

``DatabaseConnectionFactory``
   Creates database connections.

``TwwQuarantineRunner``
   Imports and validates XTF data in a quarantine schema.

``QuarantineEffectProjector``
   Converts quarantine rows to canonical effects.

``ChangeBuilder``
   Converts canonical effects and current live objects to row-level changes.

``RightsEvaluator``
   Evaluates create, update and delete permissions.

``ChangeObjectProviderFactory``
   Creates providers used for review-feature generation.

``TwwDiffSchemaService``
   Stores prepared sources and persisted review jobs.

``RelationLookupCapability``
   Retrieves current canonical objects.

Entry points
------------

The service exposes two main workflow entry points.

``create_diff_job_from_xtf``
   Imports an XTF source and delegates processing to the quarantine entry
   point.

``create_diff_job_from_quarantine``
   Processes an already-populated quarantine schema.

The quarantine entry point is useful for:

* QGIS workflows that import separately;
* integration tests;
* repeated processing of existing quarantine data;
* debugging projection independently from ili2pg.

Workflow metadata
-----------------

Workflow metadata controls orchestration behavior.

Relevant values include:

``source_role``
   ``base`` or ``incremental``.

``persist_job``
   Whether to persist a final review job.

``mapping_model_id``
   Effective mapping selection.

``source_model``
   Imported source model.

``import_schema``
   Quarantine schema.

``live_schema``
   Canonical source-of-truth schema.

``provider_oid``
   Current provider identity.

``dataowner_oid``
   Current dataowner identity.

Baseline workflow
-----------------

A persisting baseline follows this path:

.. code-block:: text

   project baseline
       -> build changes
       -> classify
       -> create review features
       -> persist pending job

A non-persisting baseline follows this path:

.. code-block:: text

   project baseline
       -> store PreparedSource
       -> return unpersisted result

Incremental workflow
--------------------

An incremental source requires a prepared baseline.

.. code-block:: text

   load PreparedSource
       -> project incremental source
       -> overlay incremental effects
       -> build combined changes
       -> classify
       -> create review features
       -> persist pending job
       -> clear PreparedSource

Effect overlay
--------------

Attribute effects are keyed by:

.. code-block:: text

   canonical object identity
   canonical attribute identifier

A later incremental attribute effect replaces the corresponding baseline
effect.

Existence constraints are keyed by canonical object identity.

The last existence constraint wins, including replacement between:

* ``EnforceExistsEffect``;
* ``EnforceNotExistsEffect``.

Transaction boundaries
----------------------

Each adapter owns the transaction behavior required by its operation.

Projection normally uses a read-only or non-autocommit connection scope.

Diff persistence should use an explicit transaction and expose a fully
persisted result only after successful completion.

A failed projection or classification must not update the live canonical
schema.

Workflow invariants
-------------------

The orchestration layer should enforce:

* an incremental source may not remain unpersisted;
* an incremental source requires a prepared baseline;
* one job identifier represents one logical workflow;
* prepared-source metadata contains baseline-specific fields;
* a successful incremental finalization clears its prepared source;
* unsupported job modes fail before expensive processing;
* required collaborators are present before import starts.