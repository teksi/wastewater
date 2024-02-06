import os

BASE = os.path.dirname(__file__)

PGSERVICE = None  # overriden by PG* settings below
PGHOST = os.getenv("PGHOST", None)
PGPORT = os.getenv("PGPORT", None)
PGDATABASE = os.getenv("PGDATABASE", None)
PGUSER = os.getenv("PGUSER", None)
PGPASS = os.getenv("PGPASS", None)

ILIVALIDATOR = os.path.join(BASE, "bin", "ilivalidator-1.11.9", "ilivalidator-1.11.9.jar")

TWW_DEFAULT_PGSERVICE = "pg_tww"
TWW_OD_SCHEMA = "tww_od"
TWW_VL_SCHEMA = "tww_vl"
ABWASSER_SCHEMA = "pg2ili_abwasser"
TWW_AG_SCHEMA = "tww_ag6496"
AG96_SCHEMA = "pg2ili_ag96"
AG64_SCHEMA = "pg2ili_ag64"
MODEL_NAME_AG96 = "Genereller_Entwaesserungsplan_AG"  
MODEL_NAME_AG64 = "Abwasserkataster_AG_V2_LV95"