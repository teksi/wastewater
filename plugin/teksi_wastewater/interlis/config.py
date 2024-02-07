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
MODEL_NAME_VSA_KEK = "VSA_KEK_2020_1_LV95"
MODEL_NAME_SIA405_ABWASSER = "SIA405_ABWASSER_2020_1_LV95"
MODEL_NAME_SIA405_BASE_ABWASSER = "SIA405_Base_Abwasser_1_LV95"
MODEL_NAME_DSS = "DSS_2020_1_LV95"

TOPIC_NAME_SIA405_ADMINISTRATION = "SIA405_Base_Abwasser_1_LV95.Administration"
TOPIC_NAME_SIA405_ABWASSER = "SIA405_ABWASSER_2020_1_LV95.SIA405_Abwasser"
TOPIC_NAME_DSS = "DSS_2020_1_LV95.Siedlungsentwaesserung"
TOPIC_NAME_KEK = "VSA_KEK_2020_1_LV95.KEK"
