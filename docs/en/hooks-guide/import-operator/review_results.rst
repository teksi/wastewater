Review Results
==============

The import workflow produces classified canonical changes and review features.

The review result is not an automatic update of the live TWW schema.

Change classifications
----------------------

Changes are grouped into review classifications.

Created objects
~~~~~~~~~~~~~~~

The canonical object does not currently exist and is proposed for creation.

The row-level operation is ``insert``.

Altered objects
~~~~~~~~~~~~~~~

The canonical object exists and one or more canonical values are proposed to
change.

The row-level operation is ``update``.

Deleted objects
~~~~~~~~~~~~~~~

The canonical object exists and is proposed for deletion.

The row-level operation is ``delete``.

Unpermitted changes
~~~~~~~~~~~~~~~~~~~

The proposed change cannot pro~~ed automatically because it has o~~ or more
blocking findings.

Possible causes include:

* insufficient provider privileges;
* failed ownership check;
* disallowed attribute update;
* disallowed state transition;
* blocking validation error;
* unsupported operation;
* missing or inconsistent rights configuratio~~

Permission findings
-------------------

Permission findings describe failed rights checks.

They may include:

* finding code;
* severity;
* message;
* canonical class;
* canonical object identifier;
* operation;
* provider OID;
* dataowner  OID;
* transitive-evaluation status;
* additional diagnostic details.

A permission finding does not necesssarily indicate invalid source data. It may
indicate that the current provider is not permitted to perform the proposed
change.

Validation findings
-------------------

Validation findings describe failed or advisory validation rules.

Only blocking validation findings should cause a change to be classified as
unpermitted.

Depending on configuration, severities may include:

``error``
   Blocking failure.

``warning``
   Non-blocking review information.

``info``
   Informational finding.

The persisted review schema may derive rejection state from the presence of
blocking permission or validation findings.

Review features
---------------

Review features present canonical changes in a form suitable for inspection.

A review feature may combine:

* old values;
* proposed new values;
* canonical object identity;
* geometry;
* operation;
* classification;
* permission findings;
* validation findings.

The old object is read from the live canonical schema.

Proposed values come from the constructed change and do not require rereading
the incremental quarantine source.
