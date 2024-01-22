CREATE TABLE IF NOT EXISTS tww_app.tww_labels
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
	obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    label_type character varying(10),
	label_text text COLLATE pg_catalog."default"
	CONSTRAINT pkey_tww_od_labels_id PRIMARY KEY (id)
	, CONSTRAINT unique_tww_od_labels UNIQUE (obj_id,label_type)
);

COMMENT ON TABLE tww_app.tww_labels IS 'stores all labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';
