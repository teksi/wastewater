Developer Troubleshooting
=========================

This page connects common failures to the architectural boundary responsible
for them.

Unknown canonical attribute
---------------------------

Example:

.. code-block:: text

   Unknown canonical attribute:
   'wastewater_structure_symbol'.'fk_wastewater_structure'

Responsible boundary:

* canonical metadata construction;
* canonical ORM discovery;
* mapping target validation.

Check whether the physical attribute exists but is absent from dictionary
metadata.

Ambiguous canonical relation
----------------------------

Example:

.. code-block:: text

   Canonical class 'catchment_area' has several foreign keys
   to 'organisation'.

Responsible boundary:

* relation-role resolution;
* projection mode;
* explicit mapping.

Do not select an arbitrary FK based only on the referenced class.

Missing secondary identity
--------------------------

Example:

.. code-block:: text

   Source attribute 'obj_id' is unavailable.
   Canonical identity attribute: 'fk_element'.

Responsible boundary:

* explicit identity mapping.

Distinguish:

.. code-block:: text

   source attribute:
       t_ili_tid

   canonical attribute:
       fk_element

OID compared with integer
-------------------------

Example:

.. code-block:: text

   operator does not exist:
   interlis_standardoid = integer

Responsible boundary:

* quarantine FK value projection.

An integer source ``t_id`` was not converted to the referenced source object's
canonical identity.

Rights base-context replacement failure
---------------------------------------

Example:

.. code-block:: text

   RightsEvaluationBaseContext.__init__()
   got an unexpected keyword argument 'operation'

Responsible boundary:

* change classifier context construction.

``dataclasses.replace`` preserves the runtime dataclass type. Construct a new
``RightsEvaluationContext`` explicitly.

Unknown rights class
--------------------

Example:

.. code-block:: text

   Unknown class: infiltration_installation

Responsible boundary:

* effective rights configuration;
* rights deployment;
* canonical namespace consistency.

Confirm that the effective runtime rights document contains the exact
canonical key.

Missing ``ClassifiedChanges.changes``
-------------------------------------

Example:

.. code-block:: text

   AttributeError:
   'ClassifiedChanges' object has no attribute 'changes'

Responsible boundary:

* result-model consumer.

Use the grouped collections exposed by ``ClassifiedChanges`` and read findings
from classification metadata.

Wrong configuration object inspected
------------------------------------

Symptom:

* every rights class appears unconfigured despite successful rights lookup for
  some classes.

Responsible boundary:

* diagnostic code.

Use the public capability API rather than assuming the structure of nested
capability wrappers.

Stale runtime behavior
----------------------

Check:

* active plugin profile;
* imported Python module path;
* installed wheel version;
* deployed YAML path;
* selected mapping and rights model;
* process restart;
* provider-local caches;
* quarantine schema recreation.
