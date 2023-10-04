--
-- Name: pum_info; Type: TABLE; Schema: tww_sys; Owner: -
--

CREATE TABLE tww_sys.pum_info (
    id integer NOT NULL,
    version character varying(50) NOT NULL,
    description character varying(200) NOT NULL,
    type integer NOT NULL,
    script character varying(1000) NOT NULL,
    checksum character varying(32) NOT NULL,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: pum_info_id_seq; Type: SEQUENCE; Schema: tww_sys; Owner: -
--

CREATE SEQUENCE tww_sys.pum_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pum_info_id_seq; Type: SEQUENCE OWNED BY; Schema: tww_sys; Owner: -
--

ALTER SEQUENCE tww_sys.pum_info_id_seq OWNED BY tww_sys.pum_info.id;

------


--
-- Name: pum_info id; Type: DEFAULT; Schema: tww_sys; Owner: -
--

ALTER TABLE ONLY tww_sys.pum_info ALTER COLUMN id SET DEFAULT nextval('tww_sys.pum_info_id_seq'::regclass);


--
-- Name: pum_info pum_info_pkey; Type: CONSTRAINT; Schema: tww_sys; Owner: -
--

ALTER TABLE ONLY tww_sys.pum_info
    ADD CONSTRAINT pum_info_pkey PRIMARY KEY (id);


--
-- Name: pum_info pum_info_version_excl; Type: CONSTRAINT; Schema: tww_sys; Owner: -
--

-------------------------------



ALTER TABLE ONLY tww_sys.pum_info
    ADD CONSTRAINT pum_info_version_excl EXCLUDE USING btree (version WITH =) WHERE ((type = 0));
