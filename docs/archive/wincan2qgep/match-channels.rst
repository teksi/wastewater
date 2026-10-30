Match channels
===============

To import the inspection data, the inspected channels have to be matched with the TWW channels.
This process can be done semi-automatically or manually.
As long as channels are not matched to existing data, they will be highlighted in red in the main table.

Automatic matching
-------------------

An automatic matching can be performed by looking for a pattern in manhole identifiers.
Enter a channel identifier in the corresponding field, and the plugin will search
for the channels connecting the manhole as follows: ``{channel_id} - {manhole_id}``
(the manhole id being taken from the inspection data).

Manual matching
---------------

Manual matching can be performed as follows:

1. Select the desired channel in the table
2. In the first channel widget, click on the ``Select on map`` button

.. figure:: images/match-channel-1.png

3. Find and click on the corresponding channel on the map.
4. The channel ID is now listed and the line in the table is not highlighted anymore.

.. figure:: images/match-channel-2.png

Skipping channels or observations
---------------------------------

If you want to skip some of the inspected channels, they simply need to be unchecked in the channel table and similarly for observations.

.. figure:: images/skip-data.png
