Baseline Import
===============

A baseline import creates the canonical starting point for a review workflow.

A baseline may either:

* be prepared for a later incremental import; or
* immediately create a pending review job.

Baseline input
--------------

A baseline workflow requires:

* an XTF source file;
* a job identifier;
* a supported source model;
* the source language;
* the baseline mapping model;
* a provider identity;
* a dataowner identity;
* an import schema;
* a live canonical schema;
* a persistence decision.

The selected mapping must match the actual model contained in the XTF.

Baseline-only workflow
----------------------

Use a baseline-only workflow when no separate incremental source will be
applied.

The source metadata is conceptually:

.. code-block:: text

   source_role = base
   persist_job = true

The processing sequence is:

.. code-block:: text

   baseline XTF
       -> import into quarantine
       -> validate quarantine
       -> full canonical projection
       -> compare with live TWW
       -> classify changes
       -> create review features
       -> persist pending review job

The job can then proceed through the normal review process.

Prepared baseline workflow
--------------------------

Use a prepared baseline when a later incremental source must be applied.

The source metadata is conceptually:

.. code-block:: text

   source_role = base
   persist_job = false

The processing sequence is:

.. code-block:: text

   baseline XTF
       -> import into quarantine
       -> validate quarantine
       -> full canonical projection
       -> store prepared source
       -> do not persist final review job

The prepared source contains:

* projected baseline effects;
* baseline source model;
* mapping model identifier;
* import schema;
* created model list;
* source metadata;
* workflow metadata required by the incremental phase.

The prepared source is an intermediate workflow artifact.

Full projection behavior
------------------------

Baseline imports normally use full projection.

This allows the baseline source to describe the complete supported canonical
state.

Full projection may include inferred mappings where the semantic target is
unambiguous.

Ambiguous source relationships still require explicit mapping configuration.

Preflight checks
----------------

Before starting a baseline import, verify:

#. The XTF file exists and is readable.
#. The source model is supported.
#. The selected model language matches the XTF.
#. The mapping model is compatible with the source model.
#. The import schema may be safely created or replaced.
#. The live schema points to the intended TWW installation.
#. Provider and dataowner identities are correct.
#. The rights and mapping configurations are the deployed versions intended
   for the workflow.
#. The job identifier is not already used by an incompatible prepared source
   or pending job.

Successful completion
---------------------

A successful prepared baseline should report:

* successful XTF import;
* successful quarantine validation;
* number of projected relation contexts;
* number of projected effects;
* number of constructed changes;
* rights and validation summary;
* prepared source identifier;
* no final diff-schema result.

A successful baseline-only import should additionally report:

* classified change counts;
* review-feature counts;
* pending job identifier;
* persisted diff-schema result.

Failure behavior
----------------

If a baseline import fails before preparing or persisting a result:

* no accepted change is applied to the live schema;
* the quarantine schema may remain for inspection;
* partial logs should be retained;
* the job should be rerun only after resolving the reported cause.

If a previous prepared source exists for the same job identifier, determine
whether it must be cleared before rerunning.