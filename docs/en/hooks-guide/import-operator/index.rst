Import Operations
=================

This section describes how to run source imports and create TWW diff review
jobs.

It is intended for operators who:

* import XTF source files;
* monitor workflow execution;
* inspect review results;
* rerun failed workflows;
* collect diagnostics for administrators or developers.

The import workflow does not write accepted changes directly into the live TWW
schema. It creates canonical changes and review artifacts. Applying accepted
changes is a separate workflow.

For mapping, rights and provider configuration, see
:doc:`../sysadmin/index`.

For implementation details, service boundaries and extension points, see
:doc:`../developer-notes/index`.

Workflow types
--------------

Two main workflows are supported.

Baseline-only workflow
   Imports one baseline source compatible to the VSA models and immediately 
   creates a pending review job.

Baseline and incremental workflow
   Imports and prepares a baseline source without creating the final review
   job. A later incremental source (i.e. a delivery of cantonal models)
   is projected and overlaid onto the prepared baseline. 
   The combined result becomes one pending review job.

Source roles
------------

Every imported source has one of two roles.

``base``
   Represents the baseline state used to construct canonical changes. 

``incremental``
   Only explicitly selected updates are applied on top of the prepared baseline source.

Projection behavior differs by source role.

A baseline uses full projection, including supported implicit and
explicit mappings. This is generally used for VSA-defined models.

An incremental source uses explicit-only projection. Only mappings
intended for incremental updates contribute effects. This is mainly
useful to only import the data necessary for a TWW database to conform to
an extension model. 

Review lifecycle
----------------

The workflow produces one of two outcomes.

Prepared source
   An unpersisted intermediate result retained for a later incremental import.

Pending review job
   A persisted diff job containing classified changes and review features.

A prepared source is not itself a final review job.

Contents
--------

.. toctree::
   :maxdepth: 2

   workflow-overview
   baseline-import
   incremental-import
   review-results
   operations-and-values
   recovery-and-reruns
   troubleshooting