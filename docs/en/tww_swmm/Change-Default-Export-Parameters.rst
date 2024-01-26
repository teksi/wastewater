
.. _Change-Default-Export-Parameters:

Change default export parameters
--------------------------------
As mentionned earlier, most of the simulation parameters are copied from the template ``.inp`` file.

Remaining default parameters are currently hard coded in the views within the database ``tww_swmm`` schema.
The defaults parameters can be edited directly in the view (with PgAdmin).

.. note::

    The default parameters modified in the views and modified views in general will be overwritten during a datamodel update.
