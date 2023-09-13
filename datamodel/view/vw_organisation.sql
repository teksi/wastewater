-- ******************************************************************************
-- Open/view files in TEKSI wastwater
-- ******************************************************************************

-- ******************************************************************************
-- 1. qgep_od.vw_organisation :
-- ******************************************************************************

-- View: qgep_od.vw_organisation

CREATE OR REPLACE VIEW qgep_od.vw_organisation AS
  SELECT *
   FROM qgep_od.organisation;
     
ALTER VIEW qgep_od.vw_organisation ALTER obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','organisation');

/* to do define later if still needed - organisation should not be created anymore on its own - use VSA_organisation import intstead.


-- ******************************************************************************
-- 3. FUNCTIONS :
-- ******************************************************************************

-- Function: qgep_od.vw_organisation_delete()
-- DROP FUNCTION qgep_od.vw_organisation_delete();

CREATE OR REPLACE FUNCTION qgep_od.vw_organisation_delete()
  RETURNS trigger AS
$BODY$
  BEGIN
    DELETE FROM qgep_od.file WHERE obj_id = OLD.obj_id;
    RETURN OLD;
  END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


-- ******************************************************************************
-- Function: qgep_od.vw_organisation_insert()
-- DROP FUNCTION qgep_od.vw_organisation_insert();
CREATE OR REPLACE FUNCTION qgep_od.vw_organisation_insert()
  RETURNS trigger AS
$BODY$

  BEGIN

    NEW._url = replace(NEW._url, '\', '/');

    INSERT INTO qgep_od.file(
      class,
      identifier,
      kind,
      object,
      path_relative,
      fk_dataowner,
      fk_provider,
      fk_data_media,
      remark)

    SELECT
      NEW.class,
      NEW.identifier,
      NEW.kind,
      NEW.object,
      SUBSTRING(NEW._url, LENGTH("path")+1, LENGTH(NEW._url)), -- path_relative,
      NEW.dataowner, -- fk_dataowner,
      NEW.provider, -- fk_provider,
      obj_id, -- fk_data_media
      NEW.remark
    FROM qgep_od.data_media
    WHERE "path" = SUBSTRING(NEW._url FROM 1 FOR LENGTH("path"))
    ORDER BY LENGTH("path") DESC
    LIMIT 1;

    -- FOUND is a special variable which is always FALSE at the beginning of a PL/pgsql function and will be set by
    -- e.g. INSERT to TRUE if at least one row is affected.
    IF NOT FOUND THEN
      RAISE WARNING 'Could not insert. File not in repository set in od_data_media!';
    END IF;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- ******************************************************************************
-- Function: qgep_od.vw_organisation_update()
-- DROP FUNCTION qgep_od.vw_organisation_update();

CREATE OR REPLACE FUNCTION qgep_od.vw_organisation_update()
  RETURNS trigger AS
$BODY$
BEGIN

NEW._url = replace(NEW._url, '\', '/');

  UPDATE  qgep_od.file
    SET
    class = NEW.class,
    identifier = NEW.identifier,
    kind = NEW.kind,
    object = NEW.object,
    path_relative = SUBSTRING(NEW._url, LENGTH(dm.path)+1, LENGTH(NEW._url)),
    fk_dataowner = NEW.dataowner,
    fk_provider = NEW.provider,
    fk_data_media = dm.id,
    remark = NEW.remark

FROM (
  SELECT obj_id as id,
	path
	FROM qgep_od.data_media
	WHERE path = SUBSTRING(NEW._url FROM 1 FOR LENGTH(path))
	ORDER BY LENGTH(path) DESC
	LIMIT 1)  dm

WHERE obj_id = OLD.obj_id;


  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


-- TRIGGERS :
-- ******************************************************************************
-- Trigger: vw_organisation_delete on qgep_od.vw_organisation
-- DROP TRIGGER vw_organisation_delete ON qgep_od.vw_organisation;

CREATE TRIGGER vw_organisation_delete
  INSTEAD OF DELETE
  ON qgep_od.vw_organisation
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_organisation_delete();

-- Trigger: vw_organisation_insert on qgep_od.vw_organisation
-- DROP TRIGGER vw_organisation_insert ON qgep_od.vw_organisation;

CREATE TRIGGER vw_organisation_insert
  INSTEAD OF INSERT
  ON qgep_od.vw_organisation
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_organisation_insert();

-- Trigger: vw_organisation_update on qgep_od.vw_organisation
-- DROP TRIGGER vw_organisation_update ON qgep_od.vw_organisation;

CREATE TRIGGER vw_organisation_update
  INSTEAD OF UPDATE
  ON qgep_od.vw_organisation
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_organisation_update();
-- ******************************************************************************
 */