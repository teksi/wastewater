Rights Evaluation
=================

Rights evaluation applies resolved rights to one row-level change.

Context types
-------------

The workflow distinguishes base and per-change rights contexts.

``RightsEvaluationBaseContext``
   Contains workflow-level values:

   * provider OID;
   * dataowner OID;
   * context values.

``RightsEvaluationContext``
   Contains complete per-change values:

   * provider OID;
   * dataowner OID;
   * operation;
   * old values;
   * new values;
   * context values.

The hook creates the base context.

The classifier constructs a complete context for every change.

Context promotion
-----------------

A base dataclass must not be converted with ``dataclasses.replace`` when the
target is a different dataclass type.

The classifier explicitly constructs ``RightsEvaluationContext``.

Conceptually:

.. code-block:: python

   RightsEvaluationContext(
       provider_oid=base_context.provider_oid,
       dataowner_oid=base_context.dataowner_oid,
       operation=change.operation,
       old_values=change.old_values,
       new_values=change.new_values,
       context_values=base_context.context_values,
   )

Operation dispatch
------------------

Rights evaluation dispatches according to the change operation.

.. code-block:: text

   INSERT
       -> can_create

   UPDATE
       -> can_update

   DELETE
       -> can_delete

The context operation and change operation must agree.

Rights capability
-----------------

The evaluator uses a rights capability for effective class and attribute
lookup.

Rights configuration uses canonical identifiers.

Unknown classes should be detected through preflight validation or represented
as denied changes according to the configured policy.

Derived rights
--------------

Derived rights follow canonical relationships to related live objects.

The evaluator may call ``RelationLookupCapability`` to retrieve referenced
canonical objects.

Canonical FK values must therefore already use canonical object identities.
A physical ili2pg integer ``t_id`` must not reach this stage.

Findings
--------

Permission failures produce ``PermissionFinding`` values.

Blocking validation errors remain separate validation findings.

A classified change stores findings in its classification metadata.

``ClassifiedChanges`` may group values by classification rather than exposing
one flat ``changes`` collection. Consumers must use the current grouped model
API.
