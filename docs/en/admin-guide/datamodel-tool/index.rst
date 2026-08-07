TEKSI Module Management Tool
============================

.. attention::
    This replaces the Data model tool that has been part of QGEP

The TEKSI Module Management Tool plugin is an advanced tool capable of initializing and upgrading a TWW database,
as well as initializing the demo data, roles, business plugin and demo project.

It uses many previously existing tools
 * The `PostgreSQL Upgrade Manager (PUM) tool <https://opengisch.github.io/pum/>`_ for managing database installation and upgrades,
 * The `PG service parser library <https://opengisch.github.io/pgserviceparser/>`_ for parsing the pg_service.conf file and managing database connections,
 * The `Pirogue library <https://opengisch.github.io/pirogue/>`_ for managing editable views and inheritance in PostgreSQL.

The tool is based on the `oQtopus <https://opengisch.github.io/oqtopus/>`_ plugin which is a able to deploy and manage non-TEKSI QGIS projects.

It is aimed at system administrators and power users, and should not be used by end users, as it
could lead to data loss if not used properly.

.. attention::
    Make sure to fulfill the prerequisites before installing and using the tool, as it may not work properly otherwise.

Documentation
-------------
See the current `TMMT Documentation for a step by step help <https://github.com/teksi/TMMT/discussions/34>`_


Troubleshooting
^^^^^^^^^^^^^^^

In case you encounter issues or errors when using TMMT, make sure to look at the
logs, as it may contain useful information (including errors returned by underlying tools).

Make sure to include this information if `submitting a bug report <https://github.com/teksi/TMMT/issues>`_ or `asking for support <https://www.teksi.ch/modules/#prestataires>`_.
