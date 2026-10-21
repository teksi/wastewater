Caching and Runtime State
=========================

Caching is used to avoid repeated structural work within a workflow.

Caches are not authoritative data.

Canonical model caches
----------------------

The canonical model adapter may cache:

* reflected ORM classes;
* canonical metadata;
* foreign-key descriptions;
* FK lookup indexes.

These caches are release-structural and may remain valid across source imports
while the canonical release is unchanged.

Relation-context caches
-----------------------

A relation-context provider may cache:

* complete relation contexts;
* explicit mapping lookups;
* implicit mapping lookups;
* inherited explicit mappings;
* referenced relation mappings;
* source attribute names;
* ORM inheritance hierarchies.

A provider is scoped to:

* one reflected quarantine ORM;
* one effective mapping;
* one canonical model;
* one projection mode.

It must not switch projection mode after building cached contexts.

Import identity caches
----------------------

The effect projector may cache source ``t_id`` to object-identity mappings.

These caches are tied to populated quarantine data.

They are invalid when:

* the schema is recreated;
* a new XTF is imported into the same schema name;
* identity-owner tables change.

The cache key must distinguish the identity owner where different model
families use different inheritance roots.

Persistence across runs
-----------------------

Do not serialize:

* SQLAlchemy mapper objects;
* ORM classes;
* relation contexts;
* database cursors;
* import-specific identity caches.

Cross-run optimization should use a normalized release manifest.

Release manifests
-----------------

A release manifest may persist stable canonical structure:

* classes;
* attributes;
* datatypes;
* geometry;
* inheritance;
* foreign keys;
* identity fields;
* release version.

The manifest should be generated and validated during release preparation.

Performance measurement
-----------------------

Measure before introducing additional persistence.

Useful timing scopes include:

* canonical model preparation;
* quarantine ORM reflection;
* effective mapping resolution;
* relation-context creation;
* effect projection;
* identity-cache loading;
* change construction;
* rights classification;
* review generation;
* diff persistence.

Logging itself may become a measurable cost. Avoid per-row diagnostic logging
at ``INFO``.