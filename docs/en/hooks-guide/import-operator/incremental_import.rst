Incremental Import
==================

An incremental import applies explicitly selected changes on top of a prepared
baseline source.

It finalizes a baseline-and-incremental workflow and creates one pending review
job.

Prerequisites
-------------

An incremental import requires:

* an existing prepared baseline source;
* the same job identifier as the prepared baseline;
* a compatible incremental XTF;
* a supported incremental mapping;
* compatible provider and dataowner context;
* ``persist_job`` enabled.

An incremental source cannot currently be prepared without finalizing the
workflow.

Workflow
--------

The incremental processing sequence is:

.. code-block:: text

   prepared baseline effects
               |
               |
   incremental XTF
       -> import into quarantine
       -> validate quarantine
       -> explicit-only projection
               |
               v
       overlay incremental effects
       onto prepared baseline effects
               |
               v
       construct combined changes
               |
               v
       classify rights and validations
               |
               v
       create review features
               |
               v
       persist one pending review job
               |
               v
       clear prepared source

The final job retains metadata for both sources.

Explicit-only projection
------------------------

Incremental projection is intentionally narrower than baseline projection.

Only explicitly selected mappings contribute incremental effects.

This may include:

* explicit direct attributes;
* explicit class mappings;
* applicable explicit defaults;
* explicit function-backed mappings.

Implicit mapping may still provide structural information, including:

* canonical class resolution;
* primary identity resolution;
* referenced canonical class resolution.

Implicit attributes do not automatically become incremental updates.

Relation semantics and projection selection
-------------------------------------------

A source relation may need an explicit semantic mapping because several
canonical relationships reference the same class.

For example:

.. code-block:: text

   datenbewirtschafter_gep
       -> organisation

Possible canonical roles:
       fk_dataowner
       fk_provider

The mapping configuration may define that the source relation means
``fk_provider``.

However, relation discovery and incremental projection are separate concerns.

A relation declaration used only to resolve structural meaning should not
automatically overwrite the live canonical value unless the relation is also
selected for incremental projection.

This distinction prevents unintended updates from inherited or supporting
source attributes.

Effect overlay
--------------

Incremental effects are overlaid on the prepared baseline effect document.

Attribute-update effects are keyed by:

* canonical object identity;
* canonical attribute.

An incremental attribute effect replaces the matching prepared baseline
attribute effect.

Existence effects are keyed by canonical object identity.

The last existence constraint for an identity wins. This allows an
incremental source to replace:

* ``enforce_exists`` with ``enforce_not_exists``;
* ``enforce_not_exists`` with ``enforce_exists``.

Omitted and null values
-----------------------

Incremental projection distinguishes omission from explicit null values.

Source mapping omitted
   No incremental effect is generated. The prepared or live value is not
   changed by that source attribute.

Explicit update to ``NULL``
   An update effect is generated with a null value. The canonical attribute is
   set to null if the change is accepted.

Explicit non-null update
   An update effect is generated with the supplied canonical value.

This distinction is essential for partial incremental models.

Identity handling
-----------------

The incremental source must identify the canonical object affected by each
explicit mapping.

Primary objects commonly use:

.. code-block:: text

   source t_ili_tid
       -> canonical obj_id

Extension objects may use the source identity as a canonical relation:

.. code-block:: text

   source t_ili_tid
       -> extension fk_element

Secondary target identities must be declared by the mapping configuration
where they cannot be inferred safely.

Foreign-key values
------------------

An incremental source foreign key may be represented by an ili2pg integer
``t_id``.

Before it becomes a canonical effect value, the workflow resolves it to the
referenced source object's INTERLIS identity.

.. code-block:: text

   source t_id
       -> referenced source object
       -> referenced t_ili_tid
       -> canonical relation value

External or already canonical string identifiers may pass through unchanged.

Compatibility checks
--------------------

Before applying an incremental source, verify:

#. The prepared baseline exists.
#. The job identifier matches.
#. The incremental mapping is intended for the selected baseline.
#. The provider and dataowner context is compatible.
#. The canonical model release has not changed.
#. The rights configuration has not changed unexpectedly.
#. The prepared source has not already been finalized.
#. The incremental source uses explicit-only projection.
#. Required referenced canonical objects already exist or are created by the
   combined workflow.

Successful completion
---------------------

A successful incremental import should report:

* prepared baseline retrieved;
* incremental source imported;
* quarantine validation successful;
* explicit relation contexts prepared;
* incremental effects projected;
* baseline and incremental effects merged;
* combined changes created;
* rights and validations classified;
* review features exported;
* pending job persisted;
* prepared source cleared.

If the workflow fails before persistence, retain the prepared source unless the
recovery procedure explicitly requires clearing it.
