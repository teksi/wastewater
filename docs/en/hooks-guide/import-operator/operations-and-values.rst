Change Values
=============


Old and new values
------------------

Every constructed change may contain:

``old_values``
   Current values read from the live canonical object.

``new_values``
   Proposed values after applying projected effects.

Rights evaluation may use both old and new values.

Examples include:

* ownership checked against the existing provider;
* create rights checked against a proposed provider;
* transition rights checked from old state to new state;
* attribute permissions checked only for changed values.

Foreign-key values
------------------

Canonical foreign keys normally contain canonical object identities.

A physical quarantine FK may instead contain an ili2pg integer ``t_id``.

The workflow resolves internal references before constructing canonical
changes.

.. code-block:: text

   Quarantine:
       fk value = 114095

   Source identity lookup:
       114095 -> ch080qwz...

   Canonical change:
       fk value = ch080qwz...

If an integer ``t_id`` reaches a canonical field using an OID datatype, the
workflow has failed to perform identity conversion.

Value-list values
-----------------
Value-list fields use integer source codes from ``tww_vl``.

Only attributes declared as foreign keys are resolved through source object
identity lookup.

Ordinary mapped values are processed through the configured value mapping.
