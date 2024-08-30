CREATE TABLE tww_od.default_values
(
    id serial,
	fieldname text,
    value_obj_id varchar(16),
    CONSTRAINT pkey_tww_sys_default_values_id PRIMARY KEY (id)
);

 CREATE UNIQUE INDEX in_od_default_values_fieldname ON tww_od.default_values USING btree (fieldname ASC NULLS LAST);


