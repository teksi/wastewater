
Troubleshooting Imports
=======================


Unknown canonical rights class
------------------------------

Example:

.. code-block:: text

   KeyError: Unknown class: infiltration_installation

Meaning:

* projection produced a canonical change;
* the effective rights configuration does not contain that canonical class.

Operator actions:

#. record the canonical class name;
#. confirm which rights file and rights model were loaded;
#. provide the log to the system administrator;
#. do not rename the source model to work around the error;
#. rerun only after the active rights configuration is corrected.

Ambiguous relation
------------------

Example:

.. code-block:: text

   Cannot infer the canonical role of source foreign key
   'einzugsgebiet'.'datenbewirtschafter_gep'.

Meaning:

* the source FK references a known canonical class;
* several canonical relations can reference that class;
* the mapping does not state which semantic role applies.

Operator actions:

#. confirm whether the source is baseline or incremental;
#. confirm that the intended projection mode was used;
#. report the source class and attribute to the mapping administrator;
#. do not add an arbitrary relation mapping merely to suppress the error.

For incremental imports, an undeclared relation may need to be excluded rather
than projected.

Missing source identity
-----------------------

Example:

.. code-block:: text

   Could not localize canonical identity.
   Source attribute 'obj_id' is unavailable.

Meaning:

* the mapping expects a source identity that the imported row does not expose;
* a secondary canonical target may require an explicit identity mapping.

Operator actions:

#. record the source class;
#. record the canonical target class;
#. record the listed available source attributes;
#. provide the information to the mapping administrator.

OID compared with integer
-------------------------

Example:

.. code-block:: text

   operator does not exist:
   interlis_standardoid = integer

Meaning:

* an ili2pg physical ``t_id`` reached a canonical OID lookup;
* source foreign-key identity conversion did not occur.

Operator actions:

#. retain the complete traceback;
#. identify the source class and source attribute from preceding logs;
#. report whether the source was baseline or incremental;
#. do not cast database values manually.

Validation failure
------------------

If ili2pg or quarantine validation fails, the source has not reached canonical
projection.

Inspect the validation log first.

Typical causes include:

* invalid INTERLIS structure;
* missing mandatory value;
* invalid reference;
* unsupported model version;
* wrong source model selection.

Wrong number of changes
-----------------------

Unexpectedly many changes may indicate:

* the wrong live schema was selected;
* a baseline was treated as incremental or vice versa;
* full projection was used for an incremental model;
* a stale prepared baseline was used;
* the source model or language was selected incorrectly.

Unexpectedly few changes may indicate:

* explicit-only projection omitted required mappings;
* function mappings were not selected;
* an incremental source contained no supported explicit values;
* source values already matched the live state.

Prepared source not found
-------------------------

Meaning:

* the incremental workflow cannot find the prepared baseline for the job ID.

Check:

* job identifier;
* prepared-source storage;
* baseline persistence flag;
* whether the prepared source was cleared;
* whether another workflow or cleanup process removed it.

Prepared source incompatible
----------------------------

A prepared baseline may be unsuitable when:

* mapping version changed;
* canonical release changed;
* source model changed;
* provider or dataowner context changed;
* baseline schema was recreated;
* prepared metadata is incomplete.

Prepare a new baseline if compatibility cannot be established.

Pending job already exists
--------------------------

The job identifier is already associated with a persisted review job.

Determine whether the workflow should:

* stop;
* replace the existing job;
* use a new identifier;
* clear an incomplete job.

Do not overwrite an existing review job outside the supported job mode.

Large logs
----------

Normal operational logs should contain summaries rather than one message per
attribute.

Useful ``INFO`` messages include:

* workflow start and completion;
* source role;
* model selection;
* import and validation result;
* relation-context count;
* effect count;
* change counts;
* missing rights coverage;
* review-feature counts;
* timings;
* prepared or pending job identifier.

Detailed SQL, mapping resolution and per-value identity conversion should
normally use ``DEBUG``.

When requesting support, redirect both output streams to one file.

On Windows ``cmd.exe``:

.. code-block:: bat

   run_diff_import_workflow.cmd > "C:\path\workflow.log" 2>&1

Use ``>>`` instead of ``>`` to append rather than overwrite.

Stale deployed files
--------------------

If behavior does not reflect a recent change:

#. verify the active QGIS profile;
#. verify the deployed plugin path;
#. verify the active YAML path;
#. verify the installed TEKSI Hooks wheel;
#. restart QGIS and command-line processes;
#. rerun with configuration-path logging enabled.

Successful baseline but failed incremental
------------------------------------------

This usually means that:

* the baseline mapping and canonical metadata are valid;
* the incremental mapping, identities or explicit projection scope still
  contain a problem.

Focus diagnostics on:

* incremental mapping model;
* explicit-only projection;
* secondary identities;
* AG-XX inheritance;
* explicit function mappings;
* incremental relation selection;
* prepared-source compatibility.

Suggested movement of existing content

The existing documentation can be redistributed as follows:

Keep YAML authoring under sysadmin.
Move baseline and incremental workflow semantics into import-operator/workflow-overview.rst.
Move row-level INSERT, UPDATE, DELETE, null handling, and omission into import-operator/operations-and-values.rst.
Move effect internals and JSONB payload details into developer-notes.
Keep only operator-visible effect behavior in the workflow pages.
Move runtime exception explanations into import-operator/troubleshooting.rst, with links to the relevant SysAdmin configuration pages.
Main documentation improvements

This structure gives operators a workflow-oriented guide. It explains what happens to a source file, how baseline and incremental imports differ, what a prepared source represents, how changes are classified, and how to recover safely when a phase fails.
