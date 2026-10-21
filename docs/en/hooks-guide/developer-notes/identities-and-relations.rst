Identities and Relations
========================

Identity handling connects physical source rows with canonical objects.

Source and canonical identity
-----------------------------

``CanonicalIdentityMapping`` contains:

``source_attribute``
   Attribute read from the projected source row.

``canonical_attribute``
   Attribute identifying the canonical target object.

These belong to different namespaces.

Example:

.. code-block:: text

   source_attribute:
       t_ili_tid

   canonical_attribute:
       obj_id

Secondary target example:

.. code-block:: text

   source_attribute:
       t_ili_tid

   canonical_attribute:
       fk_element

Primary identities
------------------

The primary canonical target normally uses the imported INTERLIS identity.

In ili2pg schemas this is commonly exposed as ``t_ili_tid``.

An implicit mapping may initially describe the source identity as ``obj_id``.
For the primary target, the provider may localize that source attribute to
``t_ili_tid`` when:

* canonical identity is ``obj_id``;
* source ``obj_id`` is unavailable;
* source ``t_ili_tid`` is available.

Secondary identities
--------------------

Secondary canonical targets require explicit identity declarations where the
correct source value cannot be inferred safely.

Example:

.. code-block:: yaml

   identities:

     agxx_last_modification:
       source_attribute: t_ili_tid
       target_attribute: fk_element

Automatic primary identity fallback should not be generalized blindly to all
secondary targets.

ili2pg joined inheritance
-------------------------

The physical identity attribute may be stored on an inherited parent table.

DSS example:

.. code-block:: text

   concrete source class
       -> baseclass
           t_ili_tid

AG-XX example:

.. code-block:: text

   gepknoten
       -> metainformation
           t_ili_tid

``baseclass`` is not a universal identity root.

The ORM hierarchy must be followed to find inherited source attributes.

Source row queries
------------------

The projector builds inheritance-aware SQL queries.

It:

* obtains the mapper hierarchy;
* starts at the concrete leaf table;
* joins each direct parent using the mapper inheritance condition;
* selects mapper attribute names;
* retains inherited fields such as ``t_ili_tid``;
* avoids duplicate attribute names.

Relations
---------

A source FK first identifies a referenced source ORM relation.

The effective mapping then resolves that source relation to a canonical class.

Canonical metadata identifies candidate local canonical FK attributes.

Resolution outcomes are:

No candidate
   The relationship cannot be mapped implicitly.

One candidate
   The relationship can be inferred.

Several candidates
   The semantic role is ambiguous and must be declared explicitly.

Foreign-key values
------------------

An ili2pg FK may contain an integer ``t_id``.

Canonical relationships normally contain a canonical object identity.

The projector converts:

.. code-block:: text

   local source FK t_id
       -> referenced source object
       -> inherited t_ili_tid or configured identity
       -> canonical FK value

Non-integer values may already be external or canonical object identifiers and
can pass through unchanged.

Identity lookup caches
----------------------

Import-specific identity caches should be keyed by enough structural
information to distinguish identity owners.

A suitable key is:

.. code-block:: text

   quarantine schema
   identity-owner table
   identity attribute

Such caches are invalid after the quarantine schema is recreated or
repopulated.