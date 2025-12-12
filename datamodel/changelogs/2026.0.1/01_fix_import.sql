-- create quarantine table

/*
Note: triggers and functions related to this were moved to view/vw_tww_od.import_sql
and are to be initialized like the rest of the views with create_views.py
*/

ALTER TABLE tww_od.import_manhole_quarantine
ADD COLUMN co_obj_id character varying(16),
ADD COLUMN wn_obj_id character varying(16);
