System Administration
=====================

This section describes how to configure and deploy the TWW hooks framework.

It is intended for administrators who maintain:

* model-mapping configuration;
* rights configuration;
* provider assignments;
* deployed configuration files;
* configuration compatibility across TWW releases.

The SysAdmin documentation focuses on configuration and deployment. It does
not describe how to run individual imports or how the Python implementation
works internally.

For import execution, review workflows and operational recovery, see
:doc:`../import-operator/index`.

For implementation details, service boundaries and extension points, see
:doc:`../developer-notes/index`.

Configuration areas
-------------------

The framework uses two main configuration areas.

Rights
   Defines which privileges are required to create, update or delete
   canonical TWW objects and attributes.

Provider assignments
   Defines which provider has which privileges for a particular data owner.

These configuration areas are intentionally independent.

A model mapping describes semantic correspondence. It does not grant access.

A rights definition describes required privileges. It does not assign those
privileges to an organisation.

A provider assignment grants privileges to a provider for a specific data
owner.

Configuration templates
-----------------------

For System administrators handling entities with different rights structures,
it is possible to define sets of rights and provider assignments in a central
rights profile yaml.


.. code-block:: yaml

   # Example profile for one hosted entity/provider.
   community_a:
     description: Rights profile for Community A imports.
     provider_rights: profiles/community_a/provider_rights.yaml
     rights_definition: profiles/community_a/provider_privilege.yaml

   # Example profile for another hosted entity/provider.
   #
   association_b:
     description: Rights profile for Association B imports.
     provider_rights: profiles/association_b/provider_rights.yaml
     rights_definition: profiles/association_b/provider_privilege.yaml


Canonical identifiers
---------------------

Mappings and rights use canonical TWW identifiers.

Examples include:

* ``wastewater_structure``;
* ``infiltration_installation``;
* ``fk_provider``;
* ``status``;
* ``agxx_last_modification``.

Localized source identifiers, such as German or French INTERLIS attributes,
are used only on the source side of model mappings.

For example:

.. code-block:: text

   Source class:
       versickerungsanlage

   Canonical class:
       infiltration_installation

   Source attribute:
       datenbewirtschafter_gep

   Canonical attribute:
       fk_provider

Rights configuration must use the canonical identifiers and not the 
localized source identifier. Correct:

.. code-block:: yaml

   classes:

     - id: infiltration_installation

Incorrect:

.. code-block:: yaml

   classes:

     - id: versickerungsanlage

Configuration lifecycle
-----------------------

The recommended configuration lifecycle is:

#. Edit configuration in the authoritative source repository.
#. Validate the configuration against the intended TWW release.
#. Review the effective mapping and rights definitions.
#. Deploy the configuration with the plugin or release package.
#. Restart processes that cache parsed configuration.
#. Run configuration preflight checks.
#. Record the configuration version or fingerprint in generated jobs.

Editing a file in a source checkout does not necessarily update the file used
by a deployed QGIS profile. Always verify the active configuration path after
deployment.

Contents
--------

.. toctree::
   :maxdepth: 2

   configuration-overview
   model-mapping
   rights
   providers
   