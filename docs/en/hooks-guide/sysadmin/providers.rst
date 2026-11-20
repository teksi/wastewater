Provider Assignments
====================

Provider assignments define which privileges a provider holds for a particular
data owner.

They are separate from rights configuration.

Rights configuration
   Defines which privileges an operation requires.

Provider assignments
   Define whether the current provider has those privileges for the affected
   data owner.

Example
-------

.. code-block:: yaml

   providers:

     - name: Muster Ingenieure AG
       organisation_oid: ch000000geping01

       permissions:

         - dataowner_oid: ch000000awgde001
           privileges:
             - DBW_WI
             - DBW_GEP

     - name: Gemeinde Musterlingen
       organisation_oid: ch000000awgde002

       permissions:

         - dataowner_oid: ch000000awgde002
           privileges: []

Empty privilege lists
---------------------

An empty privilege list is valid.

.. code-block:: yaml

   privileges: []

It means that the provider has no effective privileges for the specified data
owner.

Provider identity
-----------------

``organisation_oid`` identifies the provider organisation.

The value must use the canonical organisation identity format expected by the
TWW installation.

Data-owner identity
-------------------

``dataowner_oid`` identifies the organisation whose data is affected.

Privileges are evaluated in the context of a provider and a data owner.

The same provider may therefore have different privileges for different data
owners.

Evaluation
----------

At runtime, the framework combines:

* the required privileges from rights configuration;
* the provider's assigned privileges for the relevant data owner;
* ownership rules;
* local conditions;
* the change operation;
* old and new object values.

Provider assignments do not alter model mappings and do not determine which
attributes are projected.

Validation
----------

Provider configuration should be validated for:

* duplicate provider OIDs;
* duplicate data-owner assignments;
* unknown privilege identifiers;
* malformed OIDs;
* empty or missing organisation identifiers;
* unintended empty privilege lists.

Empty lists should remain valid but should be reported clearly during
configuration review.
