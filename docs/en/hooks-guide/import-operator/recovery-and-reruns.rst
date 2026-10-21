Recovery and Reruns
===================

A failed import should be rerun only after determining which workflow artifacts
were created.

The recovery action depends on the stage at which the workflow failed.

Failure before XTF import
-------------------------

No quarantine source was created.

Correct the input or configuration and rerun the workflow.

Failure during ili2pg import
----------------------------

The quarantine schema may be incomplete.

Recommended actions:

#. retain the ili2pg log;
#. inspect the source-model and schema errors;
#. drop or recreate the incomplete quarantine schema;
#. rerun the import.

Failure during quarantine validation
------------------------------------

The quarantine schema contains imported data but failed INTERLIS validation.

Do not proceed to canonical projection.

Retain:

* validation log;
* XTF source;
* source model;
* import schema;
* ili2pg version.

Correct the source or validation configuration before rerunning.

Failure during mapping or projection
------------------------------------

The quarantine import may be valid, but the model mapping could not produce
valid canonical effects.

Common causes include:

* missing source attribute;
* unknown canonical target;
* ambiguous relation;
* missing secondary identity;
* invalid function-mapping payload;
* unresolved foreign-key identity.

Retain the quarantine schema if detailed inspection is needed.

After correcting the mapping configuration, restart the process if mappings are
cached and rerun the workflow.

Failure during rights classification
------------------------------------

Canonical changes were created, but rights evaluation failed.

Common causes include:

* missing rights class;
* incorrect canonical spelling;
* wrong rights file;
* stale deployed configuration;
* missing provider assignment;
* invalid derived-rights relation.

Correct the active rights or provider configuration and rerun classification
through the normal workflow.

Failure during review generation
--------------------------------

Changes were classified but could not be converted into review features.

Possible causes include:

* missing canonical object provider;
* wrong live schema;
* unsupported geometry metadata;
* missing canonical class metadata;
* connection failure.

No change should be applied to the live schema.

Failure during diff persistence
-------------------------------

Review features were created but the pending job could not be written.

Before rerunning, determine whether a partial job exists.

Do not create a second job with the same identifier until the partial result
has been cleared or intentionally replaced.

Prepared-source recovery
------------------------

A prepared baseline should normally remain available if the incremental phase
fails before final persistence.

Do not clear it automatically unless:

* it is known to be invalid;
* its mapping or canonical release is no longer compatible;
* the baseline source must be replaced;
* workflow policy explicitly requires a fresh baseline.

If the incremental phase succeeds, the prepared source is cleared after the
pending job is persisted.

Reusing job identifiers
-----------------------

A job identifier should identify one logical workflow.

Before reusing an identifier, check for:

* existing prepared source;
* existing pending job;
* existing accepted or rejected job;
* source-role mismatch;
* mapping-version mismatch.

Use replace semantics only when the workflow explicitly supports replacement.

Schema recreation and caches
-----------------------------

Quarantine schemas may be recreated under the same schema name.

Import-specific caches must not survive schema recreation.

The runtime should clear cached source identity mappings and rebuild mappings
for the new import.

Restarting the workflow process is the safest recovery when cache state is
uncertain.

Evidence to retain
------------------

For failed workflows, retain:

* complete log;
* final traceback;
* XTF filename and checksum;
* job identifier;
* source role;
* persistence flag;
* source model;
* mapping model identifier;
* provider OID;
* dataowner OID;
* import schema;
* live schema;
* configuration fingerprints;
* plugin and TEKSI Hooks versions;
* ili2pg version;
* validation log;
* generated review job identifier, if any.
