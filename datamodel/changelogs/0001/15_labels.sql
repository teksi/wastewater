CREATE TABLE IF NOT EXISTS tww_od.tww_labels
(
	fk_parent_obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    label_def jsonb,
	CONSTRAINT pkey_tww_od_labels_fk_parent_obj_id PRIMARY KEY (fk_parent_obj_id)
);

COMMENT ON TABLE tww_od.tww_labels IS 'stores all labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';
