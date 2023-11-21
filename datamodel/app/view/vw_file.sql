-- ******************************************************************************
-- Open/view files in tww
-- ******************************************************************************
--1. ADD fk_data_media :
-- ******************************************************************************

-- Modification of table od_file --> insert fk_data_media

-- done in 04_vsa_kek_extension instead
--ALTER TABLE tww_od.file ADD COLUMN fk_data_media character varying(16);

-- ******************************************************************************
-- 2. tww_app.vw_file :
-- ******************************************************************************

-- View: tww_app.vw_file

CREATE OR REPLACE VIEW tww_app.vw_file AS
  SELECT f.obj_id,
    f.identifier,
    f.kind,
    f.object,
    f.class,
    -- dm.path,
    COALESCE(dm.path::text || f.path_relative::text, f.path_relative::text) AS _url,
    f.fk_dataowner as dataowner,
    f.fk_provider as provider,
    f.remark
   FROM tww_od.file f
     LEFT JOIN tww_od.data_media dm ON dm.obj_id::text = f.fk_data_media::text;

ALTER VIEW tww_app.vw_file ALTER obj_id SET DEFAULT tww_sys.generate_oid('tww_od','file');

-- ******************************************************************************
-- 3. FUNCTIONS :
-- ******************************************************************************

-- Function: tww_app.vw_file_delete()
-- DROP FUNCTION tww_app.vw_file_delete();

CREATE OR REPLACE FUNCTION tww_app.vw_file_delete()
  RETURNS trigger AS
$BODY$
  BEGIN
    DELETE FROM tww_od.file WHERE obj_id = OLD.obj_id;
    RETURN OLD;
  END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


-- ******************************************************************************
-- Function: tww_app.vw_file_insert()
-- DROP FUNCTION tww_app.vw_file_insert();
CREATE OR REPLACE FUNCTION tww_app.vw_file_insert()
  RETURNS trigger AS
$BODY$

  BEGIN

    NEW._url = replace(NEW._url, '\', '/');

    INSERT INTO tww_od.file(
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
    FROM tww_od.data_media
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
-- Function: tww_app.vw_file_update()
-- DROP FUNCTION tww_app.vw_file_update();

CREATE OR REPLACE FUNCTION tww_app.vw_file_update()
  RETURNS trigger AS
$BODY$
BEGIN

NEW._url = replace(NEW._url, '\', '/');

  UPDATE  tww_od.file
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
	FROM tww_od.data_media
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
-- Trigger: vw_file_delete on tww_app.vw_file
-- DROP TRIGGER vw_file_delete ON tww_app.vw_file;

CREATE TRIGGER vw_file_delete
  INSTEAD OF DELETE
  ON tww_app.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.vw_file_delete();

-- Trigger: vw_file_insert on tww_app.vw_file
-- DROP TRIGGER vw_file_insert ON tww_app.vw_file;

CREATE TRIGGER vw_file_insert
  INSTEAD OF INSERT
  ON tww_app.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.vw_file_insert();

-- Trigger: vw_file_update on tww_app.vw_file
-- DROP TRIGGER vw_file_update ON tww_app.vw_file;

CREATE TRIGGER vw_file_update
  INSTEAD OF UPDATE
  ON tww_app.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.vw_file_update();
-- ******************************************************************************
