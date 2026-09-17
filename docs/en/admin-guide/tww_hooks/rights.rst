Rights Configuration
====================

The TWW hooks framework uses rights configuration files to describe which
providers may create, update or delete TWW objects and attributes.

Rights are intentionally separated from provider assignments:

* the rights configuration defines which privileges are required;
* the provider rights configuration defines which provider has which
  privileges for which data owner.

This separation allows the same rights model to be reused with different
provider configurations.

Overview
--------

The rights workflow consists of four steps:

Parser
   Reads YAML files and creates parsed rights dataclasses.

Resolver
   Applies defaults, expands inherited rule references and creates runtime
   rights definitions.

Capability
   Provides lookup functions for resolved rights.

Evaluator
   Checks whether a provider may perform a requested operation.

The main classes involved are:

``RightsParser``
   Parses the full rights YAML structure.


``RightsResolver``
   Converts parsed rights definitions into resolved runtime structures.

``RightsCapability``
   Provides read-only access to resolved class and attribute rights.

``RightsEvaluator``
   Evaluates provider privileges, ownership rules and conditions.

Rights YAML Structure
---------------------

A rights file contains global settings and class definitions.

Example:

.. code-block:: yaml

   settings:
     allow_transitive_transitions: true

   defaults:
     create_rules:
       - ownership:
         attribute: fk_provider

     validation_rules:
       last_modification:
         rules:
           - id: newer_than_existing
             level: info

     wildcard_attributes:
       ag64_*:
         update: [DBW_WI]
       ag96_*:
         update: [DBW_GEP]

   classes:

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

       update_rules:
         - inherit: create_rules

       delete_rules:
         - inherit: create_rules

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

         gross_costs:
           update: [DBW_GEP]

Settings and Defaults
---------------------

``settings.allow_transitive_transitions``
   Controls whether state transition checks may consider transitive
   transitions.

``defaults.create_rules``
   Defines reusable create rules. These are parsed as lightweight
   declarations and interpreted by rules creation logic later.

``defaults.validation_rules``
   Defines reusable validation rules. These are parsed as lightweight
   validation declarations and interpreted by validation logic later.

``defaults.wildcard_attributes``
   Defines reusable attribute name wildcards. These are parsed as lightweight
   declarations and interpreted by validation logic later.

Defaults
-------------

Defaults are defined below ``defaults``.

Example:

.. code-block:: yaml

   defaults:
     create_rules:
       - ownership:
           attribute: fk_provider

This example means that classes without explicit create rules inherit a
default ownership rule based on ``fk_provider``.

Defaults are applied by the resolver, not by the parser.

Class Definitions
-----------------

Each class entry describes rights for one canonical TWW class.

Example:

.. code-block:: yaml

   classes:

     - id: wastewater_structure
       create_rules:
         - privileges: [DBW_WI]

The most important class-level keys are:

``id``
   Identifier of the class.

``extends``
   Optional superclass identifier.

``rights_from_subclass``
   Indicates whether rights may be derived from subclass definitions.

``crud_rules``
   Shortcut rule set applied to create, read, update and delete operations.

``create_rules``
   Rules required to create objects of this class.

``read_rules``
   Rules required to read objects of this class.

``update_rules``
   Rules required to update objects of this class.

``delete_rules``
   Rules required to delete objects of this class.

``derive_rights_from``
   Describes relation-based rights derivation from another class.

``attributes``
   Attribute-level rights and validations.

CRUD Rules Shortcut
-------------------

The ``crud_rules`` shortcut applies the same rules to all CRUD operations.

Example:

.. code-block:: yaml

   - id: pipe_profile
     crud_rules:
       - privileges: [DBW_WI, DBW_GEP]

This is interpreted as if the same rule was defined for:

* ``create_rules``
* ``read_rules``
* ``update_rules``
* ``delete_rules``

Rule Types
----------

Privilege Rule
~~~~~~~~~~~~~~

A privilege rule grants access to providers that have at least one of the
listed privileges for the relevant data owner.

Example:

.. code-block:: yaml

   create_rules:
     - privileges: [DBW_GEP]

The provider must have ``DBW_GEP`` for the affected data owner.

Multiple privileges are interpreted as alternatives.

Example:

.. code-block:: yaml

   update_rules:
     - privileges: [DBW_WI, DBW_GEP]

The provider may update if it has either ``DBW_WI`` or ``DBW_GEP``.

Ownership Rule
~~~~~~~~~~~~~~

An ownership rule checks whether the current provider owns the object through
a configured attribute.

Example:

.. code-block:: yaml

   update_rules:
     - ownership:
         attribute: fk_provider

The evaluator compares the configured attribute with the current provider.

For update and delete operations, ownership is normally checked against the
existing object values. For create operations, ownership is checked against the
new object values.

Inherit Rule
~~~~~~~~~~~~

An inherit rule copies another rule set from the same class.

Example:

.. code-block:: yaml

   update_rules:
     - inherit: create_rules

The parser stores the inherit rule. The resolver expands it into the actual
rules from ``create_rules``.

This keeps YAML files compact while still producing explicit runtime rules.

Conditions
----------

Rules may be conditional.

Example:

.. code-block:: yaml

   create_rules:
     - privileges: [DBW_GEP]
       when:
         local:
           attribute: status
           in:
             - other.planned
             - other.calculation_alternative

This rule applies only when the local ``status`` value is one of the listed
values.

Supported local condition operators include:

``equals``
   The local value must equal the configured value.

``in``
   The local value must be contained in a configured list.

``is_null``
   The local value must be null or not null, depending on the configured
   boolean value.

Conditions are evaluated by ``ConditionsCapability`` and used by
``RightsEvaluator``.

Attribute Rights
----------------

Attributes may define update privileges independently of class-level rules.

Example:

.. code-block:: yaml

   attributes:
     gross_costs:
       update: [DBW_GEP]

This means that ``gross_costs`` may only be updated by providers with
``DBW_GEP`` for the relevant data owner.

Another example:

.. code-block:: yaml

   attributes:
     status:
       update: [DBW_GEP, DBW_WI]

This means ``status`` may be updated by providers with either ``DBW_GEP`` or
``DBW_WI``.

Attribute Validations
---------------------

Attributes may also define validation rules.

Example:

.. code-block:: yaml

   attributes:
     structure_condition:
       update: [FI_BU]
       rules:
         - id: newer_than_existing
           level: warning

The parser stores the validation id and severity. The actual implementation of
the validation is handled by validation logic.

Transition Rules
----------------

State-like attributes may define allowed transitions.

Example:

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

Each transition defines:

``privileges``
   Privileges allowed to perform the transition.

``from``
   Source state.

``to``
   Target state.

``bilateral``
   If true, the transition is allowed in both directions.

The global setting ``allow_transitive_transitions`` controls whether transition
validation may consider transitive paths.

Derived Rights
--------------

Some classes derive rights from related classes.

Example:

.. code-block:: yaml

   - id: wastewater_networkelement
     derive_rights_from:
       - class: wastewater_structure
         relation: fk_wastewater_structure

This means that rights for a wastewater network element may be derived from
the related wastewater structure through ``fk_wastewater_structure``.

Derived rights are part of the runtime rights model and are interpreted by
evaluation logic that has access to relation context.

Wildcard Rights
---------------

Some rights files use wildcard defaults instead of full class-level rules.

Example:

.. code-block:: yaml

   defaults:

     ag64_*:
       update: [DBW_WI]

     ag96_*:
       update: [DBW_GEP]

   classes:

     - id: agxx_wastewater_node

This compact format is parsed by ``WildcardRightsParser``.

Wildcard defaults describe attribute-name patterns. The parser stores these
patterns, while the resolver or later runtime logic expands them when concrete
attributes are known.

The examples above mean:

* attributes matching ``ag64_*`` require ``DBW_WI``;
* attributes matching ``ag96_*`` require ``DBW_GEP``.

Parser and Resolver Responsibilities
------------------------------------

The parser is intentionally lightweight.

The parser:

* reads YAML;
* creates dataclass instances;
* preserves rule declarations;
* does not apply defaults;
* does not expand inherited rule references;
* does not evaluate conditions.

The resolver:

* applies default rule sets;
* expands ``inherit`` rules;
* resolves CRUD shortcut rules;
* creates immutable runtime rule structures.

The evaluator:

* checks provider privileges;
* checks ownership;
* evaluates conditions;
* evaluates attribute update rights;
* evaluates class-level create, update and delete rights.

Provider Rights Interaction
---------------------------

Rights configuration does not list providers directly.

Instead, rights configuration defines required privileges:

.. code-block:: yaml

   attributes:
     gross_costs:
       update: [DBW_GEP]

Provider configuration assigns privileges to providers for data owners:

.. code-block:: yaml

   providers:

     - name: Muster Ingenieure AG
       organisation_oid: ch000000geping01

       permissions:
         - dataowner_oid: ch000000awgde001
           privileges:
             - DBW_GEP

At runtime, the evaluator combines both:

* the rights capability says that ``gross_costs`` requires ``DBW_GEP``;
* the provider capability says whether the current provider has
  ``DBW_GEP`` for the affected data owner.

Testing
-------

Rights parsing, resolving, capability lookup and evaluation are covered by
pure Python unit tests.

Relevant test areas include:

* rights parser tests;
* wildcard rights parser tests;
* rights resolver tests;
* rights capability tests;
* condition capability tests;
* rights evaluator tests.

These tests do not require PostgreSQL, QGIS or Docker.

DB-backed tests for dictionary metadata, value-list mapping and JSONB
persistence belong to a separate integration test layer.
