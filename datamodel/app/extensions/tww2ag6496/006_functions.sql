---------------------------------
-------- Metainformation --------
---------------------------------
CREATE OR REPLACE FUNCTION tww_app.modification_last_modified_agxx()
RETURNS trigger AS
$BODY$
  DECLARE
	update_type varchar(3);
  BEGIN
    BEGIN
	  SELECT
	   ag_update_type
	  INTO update_type
	  FROM tww_cfg.agxx_last_modification_updater
	  WHERE username=current_user;
	  CASE
	   WHEN update_type IN('wi','both') THEN NEW.ag64_last_modification=now();
	   ELSE NULL;
	   END CASE;
	    CASE
	   WHEN update_type IN('gep','both') THEN NEW.ag96_last_modification=now();
	   ELSE NULL;
	  END CASE;
	END;
	RETURN NEW;
  END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION tww_app.ft_agxx_update_catchment_area_totals_geoms
  (_obj_id varchar(16),_all boolean DEFAULT FALSE)
  RETURNS VOID AS
  $BODY$
  BEGIN
  UPDATE tww_od.catchment_area_totals cat
  SET ag96_perimeter_geometry =ca_agg.perimeter_geometry
  FROM
    ( WITH ca AS
      (
	    SELECT catchment_area.fk_special_building_ww_current AS fk_log_card,
          catchment_area.perimeter_geometry AS geom
        FROM tww_od.catchment_area
        WHERE catchment_area.fk_special_building_ww_current IS NOT NULL
      	UNION
        SELECT catchment_area.fk_special_building_rw_current AS fk_log_card,
          catchment_area.perimeter_geometry AS geom
        FROM tww_od.catchment_area
        WHERE catchment_area.fk_special_building_rw_current IS NOT NULL
      )
      SELECT ca_tot.obj_id,
        ST_Multi(ST_ForceCurve(ST_UnaryUnion(st_Collect(ca.geom)))) AS perimeter_geometry
      FROM ca
        LEFT JOIN tww_od.log_card lc ON ca.fk_log_card = lc.obj_id
        LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id = lc.fk_main_structure
		LEFT JOIN tww_od.wastewater_node wn ON main_lc.fk_pwwf_wastewater_node::text = wn.obj_id::text
		LEFT JOIN tww_od.hydraulic_char_data hcd ON hcd.fk_wastewater_node = wn.obj_id
		LEFT JOIN tww_od.catchment_area_totals ca_tot ON hcd.obj_id = ca_tot.fk_hydraulic_char_data
	 WHERE _all OR _obj_id=ca_tot.obj_id
	 GROUP BY ca_tot.obj_id
  ) ca_agg
  WHERE ca_agg.obj_id::text = cat.obj_id::text;
  END;
  $BODY$
  LANGUAGE plpgsql
  VOLATILE;
