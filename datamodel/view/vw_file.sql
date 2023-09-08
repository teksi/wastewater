-- ******************************************************************************
-- Open/view files in qgep
-- ******************************************************************************
--1. ADD fk_data_media :
-- ******************************************************************************

-- Modification of table od_file --> insert fk_data_media

-- done in 04_vsa_kek_extension instead
--ALTER TABLE qgep_od.file ADD COLUMN fk_data_media character varying(16);

-- ******************************************************************************
-- 2. qgep_od.vw_file :
-- ******************************************************************************

-- View: qgep_od.vw_file

CREATE OR REPLACE VIEW qgep_od.vw_file AS
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
   FROM qgep_od.file f
     LEFT JOIN qgep_od.data_media dm ON dm.obj_id::text = f.fk_data_media::text;
     
ALTER VIEW qgep_od.vw_file ALTER obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','file');

-- ******************************************************************************
-- 3. FUNCTIONS :
-- ******************************************************************************

-- Function: qgep_od.vw_file_delete()
-- DROP FUNCTION qgep_od.vw_file_delete();

CREATE OR REPLACE FUNCTION qgep_od.vw_file_delete()
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
-- Function: qgep_od.vw_file_insert()
-- DROP FUNCTION qgep_od.vw_file_insert();
CREATE OR REPLACE FUNCTION qgep_od.vw_file_insert()
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
-- Function: qgep_od.vw_file_update()
-- DROP FUNCTION qgep_od.vw_file_update();

CREATE OR REPLACE FUNCTION qgep_od.vw_file_update()
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
-- Trigger: vw_file_delete on qgep_od.vw_file
-- DROP TRIGGER vw_file_delete ON qgep_od.vw_file;

CREATE TRIGGER vw_file_delete
  INSTEAD OF DELETE
  ON qgep_od.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_file_delete();

-- Trigger: vw_file_insert on qgep_od.vw_file
-- DROP TRIGGER vw_file_insert ON qgep_od.vw_file;

CREATE TRIGGER vw_file_insert
  INSTEAD OF INSERT
  ON qgep_od.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_file_insert();

-- Trigger: vw_file_update on qgep_od.vw_file
-- DROP TRIGGER vw_file_update ON qgep_od.vw_file;

CREATE TRIGGER vw_file_update
  INSTEAD OF UPDATE
  ON qgep_od.vw_file
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.vw_file_update();
-- ******************************************************************************
