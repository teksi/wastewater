---------------------------------
-------- Metainformation --------
---------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.update_last_ag_modification()
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

DROP TRIGGER IF EXISTS before_networkelement_change ON tww_od.wastewater_networkelement;		
CREATE TRIGGER before_networkelement_change
    BEFORE INSERT OR UPDATE 
    ON tww_od.wastewater_networkelement
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.update_last_ag_modification();

DROP TRIGGER IF EXISTS before_overflow_change ON tww_od.overflow;		
CREATE TRIGGER before_overflow_change
    BEFORE INSERT OR UPDATE 
    ON tww_od.overflow
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.update_last_ag_modification();