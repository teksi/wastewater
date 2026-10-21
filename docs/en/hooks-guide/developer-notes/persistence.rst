Persistence
===========

Persistence is divided into prepared-source storage and final diff-job
storage.

Prepared sources
----------------

A ``PreparedSource`` stores an intermediate baseline workflow.

It contains:

* source model;
* created model list;
* effect document;
* workflow metadata.

A prepared source is not a review job.

Its purpose is to support a later incremental overlay.

Pending review jobs
-------------------

A pending job stores:

* review features;
* job metadata;
* classification results;
* validation status;
* workflow status.

The live canonical schema is not changed by pending-job creation.

Metadata
--------

Final metadata should distinguish baseline and incremental source inputs.

Recommended fields include:

* ``base_source_model``;
* ``base_import_schema``;
* ``base_mapping_model_id``;
* ``base_created_models``;
* ``incremental_source_model``;
* ``incremental_import_schema``;
* ``incremental_mapping_model_id``;
* ``incremental_created_models``.

Configuration fingerprints should also be stored where available.

Prepared-source cleanup
-----------------------

A prepared source is cleared only after successful incremental persistence.

If incremental projection, classification or persistence fails, the prepared
source should remain unless recovery policy explicitly invalidates it.

Job modes
---------

Supported job modes should be validated before expensive work begins.

Unimplemented modes must fail explicitly.

Partial persistence
-------------------

Persistence adapters should use explicit transactions.

A failure must not leave a result that appears complete.

Where partial rows may exist, the adapter must expose cleanup or replacement
semantics.