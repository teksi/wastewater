CREATE TABLE tww_od.import_ws_quarantine(
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  ws_obj_id character varying(16),
  ws_type text,
  ws_accessibility integer,
  ws_identifier character varying(20),
  ws_remark character varying(80),
  ws_status integer,
  ws__depth numeric(6,3),
  wn_obj_id character varying(16),
  wn_bottom_level numeric(7,3),
  _function_hierarchic integer,
  _usage_current integer,
  co_obj_id character varying(16),
  co_situation3d_geometry geometry(POINTZ, {SRID}),
  co_shape integer,
  co_diameter smallint,
  co_material integer,
  co_positional_accuracy integer,
  co_level numeric(7,3),
  co_renovation_demand integer,
  co_sludge_bucket integer,
  co_remark text,
  _channel_usage_current integer,
  ma_dimension1 smallint,
  ma_dimension2 smallint,
  ma_function integer,
  ma_material integer,
  ss_function integer,
  ss_upper_elevation numeric(7,3),
  ss__upper_elevation_depth numeric(7,3),
  aa_obj_id character varying(16),
  aa_renovation_demand integer,
  aa_remark text,
  aa_kind integer,
  be_obj_id character varying(16),
  be_kind integer,
  be_renovation_demand integer,
  be_remark text,
  df_obj_id character varying(16),
  df_material smallint,
  df_renovation_demand integer,
  df_remark text,
  dd_obj_id character varying(16),
  dd_diameter smallint,
  dd_renovation_demand integer,
  dd_remark text,
  tww_is_okay boolean DEFAULT false,
  tww_deleted boolean DEFAULT false,
  tww_level_measurement_kind smallint
)
;

COMMENT ON COLUMN tww_od.import_ws_quarantine.tww_level_measurement_kind
    IS 'TEKSI Wastewater extension, type of depth measurement. 1 = depth from main cover, 2 = level measurement from sea level /
    Erweiterung TEKSI Wastewater, Art der Höhenermittlung. 1 = Abstich vom Hauptdeckel,  2 = Kotenmessung (Meereshöhe) /
    zzz_TEKSI Wastewater extension, type of depth measurement. 1 = depth from main cover, 2 = level measurement from sea level';

CREATE TABLE  tww_od.import_picture_quarantine
(
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  obj_id character varying(16),
  identifier text,
  fk_import_ex_quarantine uuid, --instead of object reference
  fk_data_media character varying(16),
  path_relative text,
  remark text
);


CREATE TABLE tww_od.import_examination_quarantine (
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  obj_id character varying(16),
  operator text,
  result text,
  status integer,
  time_point timestamp without time zone,
  fk_import_ws_quarantine uuid,
  fk_wastewater_structure character varying(16),
  tww_is_okay boolean DEFAULT false
  )
;


CREATE TABLE tww_od.import_damage_ws_quarantine (
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  dm_obj_id character varying(16),
  da_fk_examination character varying(16),
  da_comments text,
  da_single_damage_class integer,
  dm_shaft_area integer,
  dm_damage_code integer,
  fk_import_examination_quarantine uuid,
  fk_examination character varying(16)
  )
;

CREATE TABLE tww_od.import_reach_point_quarantine
(
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  obj_id character varying(16) ,
  elevation_accuracy integer,
  identifier text,
  level numeric(7,3),
  outlet_shape integer,
  pipe_closure integer,
  position_of_connection smallint,
  remark text,
  fk_import_ws_quarantine uuid,
  co_depth numeric(7,3),
  ss_upper_elevation_depth numeric(7,3),
  ws_status integer,
  re_material integer,
  re_clear_height integer,
  tww_is_inflow bool default true,
  tww_position_in_structure smallint,
  tww_level_measurement_kind smallint,
  tww_is_okay boolean DEFAULT false
);

COMMENT ON COLUMN tww_od.import_reach_point_quarantine.tww_level_measurement_kind
    IS 'TEKSI Wastewater extension, type of depth measurement. 1 = depth from main cover, 2 = depth from upper elevation, 3 = level measurement from sea level /
    Erweiterung TEKSI Wastewater, Art der Höhenermittlung. 1 = Abstich vom Hauptdeckel,  2 = Abstich von Decke, 3 = Kotenmessung (Meereshöhe) /
    zzz_TEKSI Wastewater extension, type of depth measurement. 1 = depth from main cover, 2 = depth from upper elevation, 3 = level measurement from sea level';
COMMENT ON COLUMN tww_od.import_reach_point_quarantine.tww_is_inflow
    IS 'TEKSI Wastewater extension, true if inflow / Erweiterung TEKSI Wastewater, Wahr wenn Einlauf / Extension TEKSI Wastewater, vrai pour des entrées dans la chambre';
COMMENT ON COLUMN tww_od.import_reach_point_quarantine.tww_position_in_structure
    IS 'TEKSI Wastewater extension, Location of the connection (12 = main outlet) /
    Erweiterung TEKSI Wastewater, Lage des Anschlusses (12 = Hauptauslauf) /
    Extension TEKSI Wastewater, Emplacement du raccord (12 = sortie principale)';


CREATE TABLE tww_od.import_reach_quarantine
(
  uuidoid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  obj_id character varying(16),
  clear_height integer,
  elevation_determination integer,
  horizontal_positioning integer,
  inside_coating integer,
  leak_protection integer,
  material integer,
  progression3d_geometry geometry(COMPOUNDCURVEZ, {SRID}),
  tww_delta_measurement numeric(7,3),
  remark text,
  ch_pipe_length integer,
  ch_seepage integer,
  ch_usage_current integer,
  ws_status integer,
  fk_import_rp_quarantine_from uuid,
  fk_import_rp_quarantine_to uuid,
  fk_reach_point_from character varying(16),
  fk_reach_point_to character varying(16),
  tww_is_okay boolean DEFAULT false,
  tww_deleted boolean DEFAULT false
);

COMMENT ON COLUMN tww_od.import_reach_quarantine.tww_delta_measurement
    IS 'TEKSI Wastewater extension, delta between measured elevation and reach bottom level /
    Erweiterung TEKSI Wastewater, Delta zwischen gemessener Höhe und Sohlenkote der Leitung /
    Extension TEKSI Wastewater, Différence entre la hauteur mesurée et la cote radier du tronçon';
