Incremental Import Contract
===========================

Status
------

This document defines the expected behaviour of the trusted AG-XX
incremental import.

The contract is intentionally written before the implementation. It is the
basis for the mapping function, importer implementation, and integration
tests.

The words **MUST**, **MUST NOT**, **SHOULD**, and **MAY** are normative.

Scope
-----

The incremental import supplements an existing canonical DSS baseline with
AG-XX-specific values. It does not replace the regular DSS import and does
not re-import values already owned by DSS.

The import runs in trusted baseline mode and therefore does not perform
provider-rights evaluation. This exception applies only to the controlled
incremental baseline workflow. Normal provider deliveries continue to use
the review and rights workflow.

The importer MUST process only values explicitly covered by this contract.
All other ``GepKnoten`` attributes MUST be ignored.

Source and target
-----------------

The source object is an AG-XX ``GepKnoten`` row imported into the temporary
ili2pg schema.

The canonical target is selected using ``obj_id``. The identifier MUST refer
to an existing object in exactly one of these roles:

* ``tww_od.wastewater_node.obj_id``;
* ``tww_od.reach_point.obj_id``.

A matching ``wastewater_node`` represents a regular DSS node. A matching
``reach_point`` represents a node that is available through a reach point but
is not represented as a regular canonical wastewater node.

The importer MUST NOT create a new ``wastewater_node`` or ``reach_point`` in
incremental-only mode.

Identity resolution
-------------------

For every source row, the importer MUST resolve ``obj_id`` before importing
any other value.

The result is one of the following object kinds:

``wastewater_node``
    ``obj_id`` exists in ``tww_od.wastewater_node``. AG-XX extension values
    are attached to the existing wastewater node and its related extension
    objects.

``reach_point``
    ``obj_id`` exists in ``tww_od.reach_point``. Values explicitly marked as
    unconnected-node values are stored in
    ``tww_od.agxx_unconnected_node_bwrel`` and linked through the AG-XX reach
    point representation.

``missing``
    ``obj_id`` exists in neither supported target. The importer MUST fail the
    row. It MUST NOT silently create a canonical object.

``ambiguous``
    ``obj_id`` resolves to both supported target kinds. The importer MUST fail
    the row because its storage semantics are ambiguous.

Failure of one row MUST cause the incremental import transaction to roll
back.

Behaviour categories
--------------------

Every source attribute belongs to one of four categories.

``identity``
    Used to resolve the existing canonical object. The value is not imported
    as an ordinary attribute.

``import_1_to_1``
    Imported into the corresponding AG-XX extension attribute without
    changing its semantic value. Organization identifiers may be normalized
    to their canonical TWW organization identifiers as part of storage.

``unconnected_only``
    Ignored for a regular ``wastewater_node`` because DSS owns the canonical
    value. For a ``reach_point``, stored in
    ``tww_od.agxx_unconnected_node_bwrel`` so that a future AG-XX export can
    reproduce the submitted value.

``ignored``
    DSS owns the value or the value is outside the incremental contract. The
    importer MUST not modify any corresponding canonical or extension field.

Attribute contract for GepKnoten
--------------------------------

``obj_id``
    Category: ``identity``.


``ara_nr``
    Category: ``unconnected_only``.

``baujahr``
    Category: ``ignored``.


``baulicherzustand``
    Category: ``ignored``.

``bauwerkstatus``
    Category: ``ignored``.

``bemerkung_wi``
    Category: ``import_1_to_1``.

``bezeichnung``
    Category: ``ignored``.


``deckelkote``
    Category: ``ignored``.

``detailgeometrie``
    Category: ``ignored``.

``finanzierung``
    Category: ``ignored``.

``funktionag``
    Category: ``import_1_to_1`` with round-trip semantics.

    The importer MUST preserve enough information that a future export using
    the AG-XX export view produces the same AG-XX value.

    For a regular ``wastewater_node``, store the corresponding AG-64 function
    extension value according to the instead of insert trigger.

    Value-list translation is allowed only when it is lossless for the AG-XX
    export value.

    For a ``reach_point``, only the value ``Leitungsknoten`` is valid.


``funktionhierarchisch``
    Category: ``unconnected_only``.


``istschnittstelle``
    Category: ``import_1_to_1``.

    For a ``reach_point``, store in ``agxx_unconnected_node_bwrel``.

``jahr_zustandserhebung``
    Category: ``ignored``.


``lage``
    Category: ``unconnected_only``.


``letzte_aenderung_wi``
    Category: ``import_1_to_1``.

``lagegenauigkeit``
    Category: ``ignored``.

``maxrueckstauhoehe``
    Category: ``unconnected_only``.

``sanierungsbedarf``
    Category: ``ignored``.


``sohlenkote``
    Category: ``unconnected_only``.

``zugaenglichkeit``
    Category: ``ignored``.

``betreiber``
    Category: ``ignored``.


``datenbewirtschafter_wi``
    Category: ``import_1_to_1``.

    A missing or ambiguous organization mapping MUST fail the row.

``eigentuemer``
    Category: ``ignored``.


``gepmassnahmeref``
    Category: ``import_1_to_1``.


``datenbewirtschafter_gep``
    Category: ``import_1_to_1``.

    A missing or ambiguous organization mapping MUST fail the row.

``bemerkung_gep``
    Category: ``import_1_to_1``.


``letzte_aenderung_gep``
    Category: ``import_1_to_1``.

    Store as the AG-96/GEP last-modification value. The importer MUST preserve
    the submitted timestamp and MUST NOT replace it with the current time.


Storage expectations
--------------------

Committing
~~~~~~~~~~
Committing is only allowed if there are no ``ValidationFinding`` of ``Severity`` Error.

Regular wastewater node
~~~~~~~~~~~~~~~~~~~~~~~

For a source ``obj_id`` resolving to ``tww_od.wastewater_node``, the importer
MAY create missing rows in extension tables required to store explicitly
imported AG-XX values. It MUST NOT create or replace the canonical
``wastewater_node``, ``wastewater_networkelement``, ``wastewater_structure``,
``cover``, or structure subtype.
Missing canonical entries must raise a ``ValidationFinding`` of ``Severity`` Error.

Expected extension targets include:

* ``tww_od.agxx_wastewater_node``;
* ``tww_od.agxx_wastewater_networkelement``;
* ``tww_od.agxx_last_modification``;
* ``tww_od.agxx_wastewater_structure`` where a structure relation exists.

Extension writes SHOULD use upsert semantics keyed by the corresponding
foreign key.

Reach point and unconnected node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For a source ``obj_id`` resolving to ``tww_od.reach_point``, the importer MAY
create or update:

* ``tww_od.agxx_unconnected_node_bwrel``;
* ``tww_od.agxx_reach_point``.

The unconnected-node row is keyed by the submitted ``obj_id``. The AG-XX
reach-point relation links the existing reach point to that unconnected-node
representation.

The importer MUST NOT update the existing canonical ``reach_point`` with
values classified as ``unconnected_only``.

Null handling
-------------

For trusted baseline imports, source nulls have the following semantics:

* a null ``identity`` value is invalid and MUST fail the row;
* a null ``ignored`` value remains ignored;
* a null ``import_1_to_1`` or ``unconnected_only`` remains ignored, but raises a ``ValidationFinding`` of ``Severity`` Warning;
* absence of a source attribute MUST NOT clear an existing target value.

The implementation therefore MUST distinguish an absent attribute from an
attribute explicitly supplied with a null value.

Idempotency
-----------

Importing the same incremental ``GepKnoten`` delivery more than once MUST
produce the same final extension state.

The importer SHOULD use ``INSERT ... ON CONFLICT ... DO UPDATE`` or equivalent
upsert logic for extension tables. It MUST NOT create duplicate extension
rows.

The import MUST NOT alter DSS-owned values on repeated execution.

Round-trip contract
-------------------

After a successful incremental import, a future AG-XX export based on the
canonical export view SHOULD reproduce every imported value classified as
``import_1_to_1`` or ``unconnected_only``.

At minimum, round-trip tests MUST cover:

* ``funktionag``;
* ``istschnittstelle`` where supported by the resolved object kind;
* ``bemerkung_wi``;
* ``datenbewirtschafter_wi``;
* ``letzte_aenderung_wi``;
* ``gepmassnahmeref``;
* ``datenbewirtschafter_gep``;
* ``bemerkung_gep``;
* ``letzte_aenderung_gep``;
* the unconnected-node values stored for a reach-point match.

DSS-owned ignored values are not subject to incremental round-trip guarantees.
The export continues to derive them from the canonical DSS state.

Prohibited side effects
-----------------------

Incremental-only ``GepKnoten`` import MUST NOT:

* create a new canonical wastewater node or reach point;
* create covers, wastewater structures, or structure subtypes;
* change canonical status, owner, operator, financing, geometry, survey year,
  condition, accessibility, or designation;
* delete canonical or extension objects;
* invoke the legacy writable ``vw_agxx_gepknoten`` insert or update triggers;
* update ``last_modification`` fields to the current timestamp merely because
  the import ran;
* apply values belonging to attributes outside this contract.

Validation and diagnostics
--------------------------

The importer MUST fail with a diagnostic containing the source ``obj_id``
when:

* the target object cannot be found;
* the target object kind is ambiguous;
* a required organization mapping cannot be resolved;
* an imported value-list value cannot be mapped losslessly;
* the required extension relation cannot be established.

Ignored DSS-owned values SHOULD NOT produce warnings during normal imports.
They are intentionally ignored by contract.

Unknown source attributes SHOULD be logged at debug level. A strict diagnostic
mode MAY promote them to warnings for schema-development and CI checks.

Acceptance tests
----------------

The implementation is complete when integration tests prove all of the
following:

#. A regular wastewater node receives only the explicitly imported AG-XX
   extension values.
#. DSS-owned canonical fields remain unchanged even when the AG-XX row
   contains different values.
#. A reach-point match stores the designated values in
   ``agxx_unconnected_node_bwrel`` without modifying the canonical reach
   point.
#. Missing and ambiguous identities roll back the import.
#. Organization identifiers are mapped deterministically.
#. Repeating an import is idempotent.
#. A future export reproduces the round-trip values.
#. No legacy ``vw_agxx_gepknoten`` persistence trigger is invoked.
