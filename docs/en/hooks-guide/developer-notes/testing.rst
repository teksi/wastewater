Testing
=======

Testing is divided into pure unit tests, ORM-structural tests, PostgreSQL
integration tests and full workflow tests.

Pure unit tests
---------------

Pure tests should cover:

* YAML parsing;
* mapping resolution;
* rights resolution;
* mapping precedence;
* projection-mode behavior;
* class selection;
* explicit-only attribute selection;
* relation ambiguity;
* identity localization;
* change classification;
* effect overlay;
* grouped validation-finding collection.

These tests should not require QGIS or PostgreSQL.

ORM-structural tests
--------------------

ORM tests should cover:

* physical table name versus declared class name;
* mapper inheritance traversal;
* inherited column attributes;
* joined-table inheritance conditions;
* DSS identity inheritance through ``baseclass``;
* AG-XX identity inheritance through ``metainformation``;
* source FK target discovery;
* canonical FK discovery;
* association-class exclusion;
* ili2db metadata exclusion.

PostgreSQL integration tests
----------------------------

Database tests should cover:

* ili2pg-generated quarantine schemas;
* inheritance-aware row queries;
* integer ``t_id`` to ``t_ili_tid`` conversion;
* external string identity passthrough;
* dictionary and ORM canonical metadata merge;
* geometry metadata;
* function-backed JSONB mappings;
* source-identity cache invalidation;
* prepared-source storage;
* diff persistence.

Workflow tests
--------------

End-to-end tests should cover:

Baseline only
   Full projection and pending-job persistence.

Prepared baseline
   Baseline projection without final persistence.

Baseline plus AG-XX incremental
   Full baseline projection, explicit-only incremental projection, effect
   overlay and final persistence.

Failure cases
~~~~~~~~~~~~~

Include:

* missing canonical class;
* missing canonical attribute;
* missing rights class;
* rights spelling mismatch;
* ambiguous relation;
* missing secondary identity;
* unresolved internal FK;
* null attribute update;
* insertion;
* deletion;
* stale prepared source;
* duplicate job identifier;
* failed review generation.

Regression tests
----------------

Every production traceback that reveals an architectural edge case should
produce a regression test.

Recent examples include:

* replacing a base rights context with per-change fields;
* accessing a nonexistent flat ``ClassifiedChanges.changes`` property;
* assuming ``baseclass`` is the universal identity root;
* projecting integer ``t_id`` values into canonical OID columns;
* allowing full FK inference during explicit-only incremental projection.

Test fixtures
-------------

Fixtures should distinguish:

* source-language identifiers;
* canonical identifiers;
* physical ili2pg keys;
* INTERLIS identities;
* canonical foreign keys;
* rights classes.

Avoid fixtures where all identifiers are identical, because they hide
namespace defects.
