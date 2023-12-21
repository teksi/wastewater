import os


class Model:
    def __init__(self, name, filename, location):
        self.name = name
        self.filename = filename
        self.location = location


BASE = os.path.dirname(__file__)

PGSERVICE = None  # overriden by PG* settings below
PGHOST = os.getenv("PGHOST", None)
PGPORT = os.getenv("PGPORT", None)
PGDATABASE = os.getenv("PGDATABASE", None)
PGUSER = os.getenv("PGUSER", None)
PGPASS = os.getenv("PGPASS", None)
JAVA = r"java"
ILI2PG = os.path.join(BASE, "bin", "ili2pg-4.5.0-bindist", "ili2pg-4.5.0.jar")
ILIVALIDATOR = os.path.join(BASE, "bin", "ilivalidator-1.11.9", "ilivalidator-1.11.9.jar")
ILI_FOLDER = os.path.join(BASE, "ili")
DATA_FOLDER = os.path.join(BASE, "data")

TWW_DEFAULT_PGSERVICE = "pg_tww"
TWW_SCHEMA = "tww_od"
ABWASSER_SCHEMA = "pg2ili_abwasser"
ABWASSER_ILI_MODEL_NAME = "VSA_KEK_2020_1_LV95"
ABWASSER_ILI_MODEL_NAME_SIA405 = "SIA405_ABWASSER_2020_1_LV95"
ABWASSER_ILI_MODEL_NAME_DSS = "DSS_2020_1_LV95"
