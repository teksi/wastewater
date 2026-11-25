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
    f.classname,
    COALESCE(regexp_replace(dm.path, '[\\/]+$', '')||'/','')
      || regexp_replace(COALESCE(f.path_relative::text,''), '[\\/]+$', '')
      || '/' || f.identifier AS _url,
    f.fk_dataowner as dataowner,
    f.fk_provider as provider,
    f.remark,
    f.tww_outdated
   FROM tww_od.file f
     LEFT JOIN tww_od.data_media dm ON dm.obj_id::text = f.fk_data_media::text;

ALTER VIEW tww_app.vw_file ALTER obj_id SET DEFAULT tww_app.generate_oid('tww_od','file');

-- ******************************************************************************
-- 3. FUNCTIONS :
-- ******************************************************************************


CREATE OR REPLACE FUNCTION tww_app.ft_dissect_url(
  IN  p_url         text,
  IN  p_identifier  text,
  IN  p_dataowner   varchar,
  IN  p_provider    varchar,
  IN  p_create_dm   boolean,
  OUT o_dm_oid      varchar,
  OUT o_dm_path     text,
  OUT o_rel_path    text)
  RETURNS record AS
$BODY$
DECLARE
  v_ident_len integer;
BEGIN
  p_url := replace(p_url, '\', '/');

  -- longest matching data_media path wins
  SELECT obj_id, "path" INTO o_dm_oid, o_dm_path
  FROM tww_od.data_media
  WHERE "path" = SUBSTRING(p_url FROM 1 FOR LENGTH("path"))
  ORDER BY LENGTH("path") DESC
  LIMIT 1;

  IF NOT FOUND AND p_create_dm THEN
    o_dm_path :=
      CASE
        WHEN p_url ~* '^https?://' THEN
          regexp_replace(p_url,'^((https?://[^/]+/[^/]+)).*$','\1')

        WHEN p_url ~ '^//[^/]+/' THEN
          regexp_replace(p_url,'^((//[^/]+/[^/]+)).*$','\1')

        WHEN p_url ~ '^[A-Za-z]:/' THEN
          regexp_replace(p_url,'^(([A-Za-z]:)).*$','\1')

        ELSE
          regexp_replace(p_url,'^((/[^/]+)).*$','\1')
      END;

    INSERT INTO tww_od.data_media("path", kind, fk_dataowner, fk_provider) VALUES
      (
        o_dm_path,
        CASE
          WHEN p_url ~* '^https?://' THEN 9318 -- webserver
          WHEN p_url ~ '^//' THEN 3789         -- server
          ELSE 3788                            -- harddisc
        END,
        p_dataowner,
        p_provider)
      RETURNING obj_id INTO o_dm_oid;
  END IF;

  IF o_dm_oid IS NULL THEN
    RAISE EXCEPTION 'vw_file: no tww_od.data_media matching _url %', p_url;
  END IF;

  -- everything after the data_media path, without leading separators
  o_rel_path := ltrim(substring(p_url from length(o_dm_path) + 1), '/');

  -- strip the trailing filename (= identifier) from the remaining path
  v_ident_len := COALESCE(char_length(p_identifier), 0);
  IF v_ident_len > 0
     AND o_rel_path IS NOT NULL
     AND char_length(o_rel_path) > v_ident_len
     AND right(o_rel_path, v_ident_len) = p_identifier THEN
    o_rel_path := substring(o_rel_path, 1,
      char_length(o_rel_path) - v_ident_len - 1);
  END IF;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


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
DECLARE
  v_dm_oid  varchar;
  v_dm_path text;
  v_rel     text;
BEGIN
  NEW._url := replace(NEW._url, '\', '/');

  SELECT o_dm_oid, o_dm_path, o_rel_path
    INTO v_dm_oid, v_dm_path, v_rel
  FROM tww_app.ft_dissect_url(
         NEW._url, NEW.identifier, NEW.dataowner, NEW.provider, TRUE);

  INSERT INTO tww_od.file(
    classname,
    identifier,
    kind,
    object,
    path_relative,
    fk_dataowner,
    fk_provider,
    fk_data_media,
    remark,
    tww_outdated)
  VALUES(
    NEW.classname,
    NEW.identifier,
    NEW.kind,
    NEW.object,
    v_rel,
    NEW.dataowner,
    NEW.provider,
    v_dm_oid,
    NEW.remark,
    NEW.tww_outdated);

  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- ******************************************************************************
-- Function: tww_app.vw_file_update()
-- DROP FUNCTION tww_app.vw_file_update();

CREATE OR REPLACE FUNCTION tww_app.vw_file_update()
  RETURNS trigger AS
$BODY$
DECLARE
  v_dm_oid  varchar;
  v_dm_path text;
  v_rel     text;
BEGIN
  NEW._url := replace(NEW._url, '\', '/');

  SELECT o_dm_oid, o_dm_path, o_rel_path
    INTO v_dm_oid, v_dm_path, v_rel
  FROM tww_app.ft_dissect_url(
         NEW._url, NEW.identifier, NEW.dataowner, NEW.provider, FALSE);

  UPDATE tww_od.file
    SET
    classname     = NEW.classname,
    identifier    = NEW.identifier,
    kind          = NEW.kind,
    object        = NEW.object,
    path_relative = v_rel,
    fk_dataowner  = NEW.dataowner,
    fk_provider   = NEW.provider,
    fk_data_media = v_dm_oid,
    remark        = NEW.remark,
    tww_outdated  = NEW.tww_outdated
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
