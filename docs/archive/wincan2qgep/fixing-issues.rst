.. _wincan2tww-fixing-issues:

Fixing issues
=============

Length issues
-------------

If the length of the channel is longer in the data than in the map, a warning will occur.
This should be fixed in the data or can be forced in the observation table by checking the corresponding column.

One channel in the inspection data corresponds to several channels in the TWW data
------------------------------------------------------------------------------------

It may happen that one channel in the inspection data corresponds to several channels in the TWW data.
To fix this, you can select up to 3 channels in the widgets.
Observation lengths will be accordingly shifted.

Several channels in the inspection data correspond to a single channel in the TWW data
----------------------------------------------------------------------------------------

It may happen that several channels in the inspection data correspond to a single channel in the TWW data.
To fix this, you can select "Reuse previous channel" checkbox.
Observation lengths will be accordingly shifted.
