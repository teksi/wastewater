Provider Rights
===============

Provider rights define which provider has which privileges for which data
owner.

Example
-------

.. code-block:: yaml

   providers:

     - name: Muster Ingenieure AG
       organisation_oid: ch000000geping01

       permissions:
         - dataowner_oid: ch000000awgde001
           privileges:
             - DBW_WI
             - DBW_GEP

     - name: Gemeinde Musterlingen
       organisation_oid: ch000000awgde002

       permissions:
         - dataowner_oid: ch000000awgde002
           privileges: []

Empty privilege lists are valid. They are interpreted as no effective permission.
