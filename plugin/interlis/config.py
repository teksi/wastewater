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
ABWASSER_ILI_MODEL_NAME_KEK = "VSA_KEK_2020_1_LV95"
ABWASSER_ILI_MODEL_NAME_SIA405 = "SIA405_ABWASSER_2020_1_LV95"
ABWASSER_ILI_MODEL_NAME_DSS = "DSS_2020_1_LV95"

TOPIC_ABWASSER_ADMINISTRATION = "SIA405_Base_Abwasser_1_LV95.Administration"
