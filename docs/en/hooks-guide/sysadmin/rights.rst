Rights Configuration
====================

Rights configuration defines which privileges are required to create, read,
update or delete canonical TWW objects and attributes.

Rights configuration does not assign privileges to providers. Provider
assignments are configured separately.

Canonical identifiers
---------------------

Rights classes and attributes must use canonical identifiers.

Correct:

.. code-block:: yaml

   classes:

     - id: infiltration_installation

Incorrect:

.. code-block:: yaml

   classes:

     - id: versickerungsanlage

The incorrect example uses a German source-model identifier. Rights evaluation
occurs after source data has been projected to canonical changes.

Overview
--------

The rights configuration pipeline contains four stages.

Parser
   Reads YAML and creates parsed declarations.

Resolver
   Applies defaults, inheritance and reusable rules.

Capability
   Provides lookup access to effective class and attribute rights.

Evaluator
   Applies the effective rights to one concrete change.

File structure
--------------

A rights file normally contains privilege names, settings, defaults and classes.

.. code-block:: yaml

    privileges:
    DBW_WI:
        labels:
        de: Datenbewirtschafter Werkinformation
        fr: Gestionnaire cadastral

   settings:
     allow_transitive_transitions: true

   defaults:
     create_rules:
       - ownership:
           attribute: fk_provider

   classes:

     - id: wastewater_structure
       create_rules:
         - privileges: [DBW_WI]

       update_rules:
         - inherit: create_rules

       delete_rules:
         - inherit: create_rules

Settings
--------

``allow_transitive_transitions``
   Controls whether transition checks may use a path containing more than one
   configured transition.

Defaults
--------

Defaults provide reusable rights declarations.

.. code-block:: yaml

   defaults:
     read_rules:
       - privileges: all

     attribute_defaults:
       ag64_*:
         update: [DBW_WI]
       ag96_*:
         update: [DBW_GEP]

Defaults are applied by the resolver, not by the parser.

Class definitions
-----------------

Each class entry describes rights for one canonical class.

Important keys include:

``id``
   Canonical class identifier.

``extends``
   Optional parent rights class.

``rights_from_subclass``
   Whether rights may be derived from subclass definitions.

``crud_rules``
   Shortcut applied to CRUD operations supported by the resolver.

``create_rules``
   Rules for object creation.

``read_rules``
   Rules for object reading.

``update_rules``
   Rules for object updates.

``delete_rules``
   Rules for object deletion.

``derive_rights_from``
   Related canonical classes from which rights may be derived.

``attributes``
   Attribute-specific rights, validations and transitions.

Privilege rules
---------------

A privilege rule grants access when the current provider has one of the
configured privileges for the relevant data owner.

.. code-block:: yaml

  - id: wastewater_networkelement
    rights_from_subclass: false
    create_rules:
      - privileges: [DBW_WI,DBW_GEP]
        when:
            local:
              attribute: fk_wastewater_structure
              is_null: true

    derive_rights_from:
      - class: wastewater_structure
        local_attribute: fk_wastewater_structure

  - id: wastewater_structure
    rights_from_subclass: false
    create_rules:
      - privileges: [DBW_GEP]
        when:
          local:
            attribute: status
            in:
              - other.planned
              - other.calculation_alternative

      - privileges: [DBW_WI]


Multiple privileges in one rule are alternatives.

Ownership rules
---------------

An ownership rule compares a configured canonical attribute with the current
provider.

.. code-block:: yaml

   update_rules:
     - ownership:
         attribute: fk_provider

For updates and deletes, ownership is evaluated against existing
values.

For creates, ownership is evaluated against proposed values.

Attribute rights
----------------

Attributes may define update privileges separately from class-level rules.

.. code-block:: yaml

   attributes:

     gross_costs:
       update: [DBW_GEP]

Transition rules
----------------

State attributes may restrict transitions.

.. code-block:: yaml

   attributes:

     status:
       update: [DBW_GEP, DBW_WI]
       transitions:

         - privileges: [DBW_WI]
           from: other.planned
           to: operational

         - privileges: [DBW_GEP]
           from: other.calculation_alternative
           to: other.planned
           bilateral: true

A transition from a value to ``NULL`` is still part of an object update. It is
not an object deletion.

Likewise, changing an attribute from ``NULL`` to a value is an update, not an
object insertion.

Derived rights
--------------

Some classes derive rights from related canonical classes.

.. code-block:: yaml

   - id: wastewater_networkelement
     derive_rights_from:

       - class: wastewater_structure
         relation: fk_wastewater_structure

Derived-rights resolution may read related objects from the live canonical
schema.

Every configured relation must therefore use canonical class and attribute
identifiers.

Rights context
--------------

The hook supplies workflow-level context containing:

* provider OID;
* dataowner OID;
* additional context values.

For each change, the classifier adds:

* operation;
* old values;
* new values.

Operations are row-level operations:

``insert``
   The canonical object did not exist and will exist.

``update``
   The canonical object existed and remains present with changed values.

``delete``
   The canonical object existed and will no longer exist.

Rights coverage
---------------

Every canonical class that may produce a change must have an effective rights
definition.

A missing rights definition should be treated as a configuration error or a
denial, according to the deployment policy.

Common causes include:

* spelling mistakes;
* use of a localized source identifier;
* editing the wrong configuration file;
* missing rights inheritance;
* selecting the wrong rights model;
* deploying a stale file.

For example, these identifiers are different:

.. code-block:: text

   infiltration_installation
   infiltration_instalation

Validate rights coverage before running production imports.
