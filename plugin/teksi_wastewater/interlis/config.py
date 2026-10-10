from __future__ import annotations

from pathlib import Path

BASE = Path(
    __file__,
).parent

ILIVALIDATOR = BASE / "bin" / "ilivalidator-1.15.0.jar"

TWW_DEFAULT_PGSERVICE = "pg_tww"

TWW_OD_SCHEMA = "tww_od"
TWW_VL_SCHEMA = "tww_vl"
TWW_SYS_SCHEMA = "tww_sys"
TWW_APP_SCHEMA = "tww_app"

EXPORT_SCHEMA = "tww_app_pg2xtf"
IMPORT_SCHEMA = "tww_app_xtf2pg"
IMPORT_SCHEMA_INCR = "tww_app_xtf2pg_incr"

DEFAULT_INTERLIS_LANGUAGE = "de"

VSA_ORG_URL = "https://vsa.ch/models/organisation/" "vsa_organisationen_2020_1.xtf"
