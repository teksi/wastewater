Effects and Changes
===================

Effects and changes represent different stages of the workflow.

Effects
-------

An effect describes a canonical intent independently of current database state.

Supported effect kinds include:

``UpdateAttributeEffect``
   Proposes a canonical attribute value.

``EnforceExistsEffect``
   Requires a canonical object to exist.

``EnforceNotExistsEffect``
   Requires a canonical object not to exist.

An effect contains a canonical object identity.

Attribute effects additionally contain:

* canonical attribute ID;
* proposed value.

Effect documents
----------------

An ``EffectDocument`` contains:

* source metadata;
* creation time;
* version;
* ordered effects.

Effect documents support prepared baseline storage and incremental overlay.

Attribute effects are keyed by identity and attribute during overlay.

Existence effects are keyed by identity.

Function-backed effects
-----------------------

A function mapping returns a JSONB-compatible effect document.

The canonical effect payload uses:

.. code-block:: json

   {
     "kind": "update_attribute",
     "identity": {
       "class_id": "agxx_wastewater_node",
       "attributes": {
         "fk_wastewater_node": "ch..."
       }
     },
     "attribute_id": "ag64_function",
     "value": 1234
   }

``attribute_id`` is the preferred canonical field name.

Compatibility aliases should be documented explicitly if retained.

Missing and null effects
------------------------

No effect
   Leave the corresponding value unchanged by this projection.

Attribute effect with null value
   Explicitly propose setting the canonical attribute to null.

These are not equivalent.

Changes
-------

``ChangeBuilder`` converts effects into row-level changes by comparing them
with current live canonical objects.

A change contains:

* table or canonical class name;
* canonical object ID;
* operation;
* old values;
* new values.

Operations
----------

``INSERT``
   Object absent before, present after.

``UPDATE``
   Object present before and after.

``DELETE``
   Object present before, absent after.

Attribute nullness does not define the operation.

.. code-block:: text

   value -> NULL
       UPDATE

   NULL -> value
       UPDATE

   absent object -> present object
       INSERT

   present object -> absent object
       DELETE

Classification
--------------

``ChangeClassifier`` enriches a change with:

* review classification;
* permission status;
* severity;
* permission findings;
* blocking validation findings.

The classifier does not infer a workflow-wide operation. It uses the
operation contained in each ``Change``.