.. _initialize-extensions:

Initialising Database extensions
==============================================

TEKSI Wastewater maintains database extensions to serve the following models:

* AG-64 Abwasserkataster Version 2.1.0

* AG-96 Genereller_Entwaesserungsplan_AG Version 2.0.0

The database is automatically loaded with the necessary tables and attributes for the extension.

In order to be able to use an extension, activate the corresponding app modification :ref:`modification-framework`

For official models, the corresponding app modification can be triggered via TMMT using the corresponding flags on db update (i.e. ``modification_agxx`` for AG64/96 support) .

