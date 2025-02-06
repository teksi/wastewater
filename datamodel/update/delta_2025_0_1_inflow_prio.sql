-- this column is an extension to the VSA data model defines which function_hierarchic to use in labels
ALTER TABLE tww_vl.channel_function_hierarchic DROP COLUMN tww_symbology_inflow_prio ;

-- this column is an extension to the VSA data model defines which inflow usage_current is prioritised over the outflow
ALTER TABLE tww_vl.channel_usage_current ADD COLUMN tww_symbology_inflow_prio bool DEFAULT false;
UPDATE tww_vl.channel_usage_current
SET tww_symbology_inflow_prio= true WHERE code =4516;