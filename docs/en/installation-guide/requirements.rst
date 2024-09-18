.. _requirements:

Requirements
=======================

The following Python packages (installed using `pip <https://pypi.org/project/pip/>`_) are required:

* `Psycopg <https://www.psycopg.org/>`_ as database adapter
* `Pirogue <https://github.com/opengisch/pirogue>`_ for model generation and upgrades
* `sqlalchemy <https://github.com/sqlalchemy/sqlalchemy>`_ for INTERLIS imports and exports
* `geoalchemy2 <https://github.com/geoalchemy/geoalchemy2>`_ for INTERLIS imports and exports

TEKSI Wastewater requires PostGIS functions that did not function properly in a set of releases:

* Versions before PostGIS 3.2 are not affected
* When using PostGIS 3.2, the bug is fixed in Version 3.2.7
* When using PostGIS 3.3, the bug is fixed in Version 3.3.6
* When using PostGIS 3.4, the bug is fixed in Version 3.4.2
* Versions of PostGIS 3.6 or later are not affected

If you need support installing TEKSI Wastewater, contact one of our `certified service providers <https://www.teksi.ch/modules/#prestataires>`_
