.. _labelcustomisation:

Customisation of labeling and symbology behaviour
==========

Relevant fields
-----

The symbology and labeling behaviour of ``tww_app.vw_tww_wastewater_structure`` depends on the following fields:

* ``_channel_function_hierarchic``
* ``_channel_usage_current``

These two values are stored in ``tww_od.wastewater_node`` and updated by triggers. These triggers are defined so that the database sysadmin can influence how the labelling is executed. 

Labelling
-----
Per default, we only label inflows from primary reaches, but all outflows regardless of hierarchy. 
If you want to include secondary inflows in the labels, this can be achieved by setting the field ``tww_vl.channel_function_hierarchic.tww_include_in_labels`` to ``true`` for all entries. 


Symbology
-----
The relevant fields are taken from the primary wastewater node of a wastewater structure. The corresponding channel values are defined by triggers that use the following priorisation scheme

#. incoming channels where ``tww_vl.channel_usage_current.tww_symbology_inflow_prio`` are ``true``
#. outgoing channels by ``tww_vl.channel_function_hierarchic.tww_symbology_order``
#. incoming channels by ``tww_vl.channel_function_hierarchic.tww_symbology_order``
#. outgoing channels by ``tww_vl.channel_usage_current.tww_symbology_order``
#. incoming channels by ``tww_vl.channel_usage_current.tww_symbology_order``

By altering the corresponding field in ``tww_vl``, the trigger logic's behaviour can be influenced.