from .. import config
from .model_interlis_dss import ModelInterlisDss
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisDss3D(ModelInterlisDss):
    def __init__(self):
        super().__init__()

        class abflusslosetoilette3d(ModelInterlisDss.abflusslose_toilette):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_abflusslose_toilette"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.abflusslosetoilette3d = abflusslosetoilette3d

        class arabauwerk3d(ModelInterlisDss.arabauwerk):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_arabauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.arabauwerk3d = arabauwerk3d

        class klara3d(ModelInterlisDss.klara):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_klara"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.klara3d = klara3d

        # SIA 405 3D Extends
        class deckel3d(ModelInterlisSia405Abwasser.deckel):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_deckel"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.deckel3d = deckel3d

        class einleitstelle3d(ModelInterlisSia405Abwasser.einleitstelle):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_einleitstelle"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.einleitstelle3d = einleitstelle3d

        class haltung3d(ModelInterlisSia405Abwasser.haltung):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_haltung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.haltung3d = haltung3d

        class kanal3d(ModelInterlisSia405Abwasser.kanal):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_kanal"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.kanal3d = kanal3d

        class normschacht3d(ModelInterlisSia405Abwasser.normschacht):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_normschacht"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.normschacht3d = normschacht3d

        class spezialbauwerk3d(ModelInterlisSia405Abwasser.spezialbauwerk):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_spezialbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.spezialbauwerk3d = spezialbauwerk3d

        class versickerungsanlage3d(ModelInterlisSia405Abwasser.versickerungsanlage):
            __tablename__ = "dss_3d__1_lv95siedlngswssrng_3d_versickerungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss3D.versickerungsanlage3d = versickerungsanlage3d
