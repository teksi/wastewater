Review Generation
=================

Review generation converts classified changes into reviewable feature
representations.

Object providers
----------------

``ChangeObjectProvider`` supplies object values used during review export.

A TWW implementation normally reads old values from the live canonical schema.

Proposed values already exist in ``Change.new_values``.

A second lookup against the quarantine schema is therefore not required for
normal proposed-value generation.

Factory protocol
----------------

``ChangeObjectProviderFactory`` creates a provider for one workflow.

Its generic method receives:

* live schema;
* import schema;
* canonical metadata.

A concrete TWW factory may require a database connection factory.

The concrete dependency should be injected into the factory constructor rather
than added to the generic protocol method.

Composition example:

.. code-block:: text

   HookContext
       -> DatabaseConnectionFactory

   DiffCreatorHook
       -> TwwChangeObjectProviderFactory(
              connection_factory=...
          )

   TwwChangeCreationService
       -> ChangeObjectProviderFactory protocol

This keeps the generic protocol independent of TWW infrastructure.

Review export
-------------

``ChangeReviewExportService`` combines:

* classified changes;
* old live objects;
* proposed values;
* geometry metadata;
* findings;
* classification.

Geometry metadata
-----------------

Geometry attributes are obtained from canonical model metadata through
``CanonicalGeometryCapability``.

The review exporter should not infer geometry solely from source-model
columns.

Validation findings
-------------------

Validation findings are stored inside classification metadata.

When collecting them across ``ClassifiedChanges``, consumers must iterate the
actual grouped collections exposed by the model, such as:

* created objects;
* altered objects;
* deleted objects;
* unpermitted changes.

The code must not assume a nonexistent flat ``changes`` property.