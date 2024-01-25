Using pgAdmin
==============

.. _SQL-query:

SQL query
---------

.. figure:: images/sql-query4.jpg

   **Running SQL commands in pgAdmin4**
   


.. note::

 * Clicking the highlighted icon at location *1* opens the SQL Window.
   The SQL icon is active only when you're connected to a database.
 * Clicking the icon at *2* runs the written SQL commands.

.. _Database dump:

Database dump
-------------

.. note::
 * Open pgAdmin4 and connect to the database
 * Right click the Schema that you want to backup (in the tree structure below "Schemas")
 * Enter the filename where the dump should be stored
 
  .. figure:: images/database-dump-general4.jpg
  
 * Click the option-tab and check the following options

 .. figure:: images/database-dump-options4.jpg

.. note::

 * After running the process, the window in the right bottom shows that everything went ok

 .. figure:: images/database-dump-complete4.jpg
