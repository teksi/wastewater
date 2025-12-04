ALTER TABLE tww_od.examination ADD COLUMN tww_outdated BOOL DEFAULT FALSE;

COMMENT ON COLUMN tww_od.examination.tww_outdated IS 'Not part of VSA DSS / Nicht Teil von VSA DSS / Pas part de VSA SDEE';

ALTER TABLE tww_od.file ADD COLUMN tww_outdated BOOL DEFAULT FALSE;

COMMENT ON COLUMN tww_od.file.tww_outdated IS 'Not part of VSA DSS / Nicht Teil von VSA DSS / Pas part de VSA SDEE';
