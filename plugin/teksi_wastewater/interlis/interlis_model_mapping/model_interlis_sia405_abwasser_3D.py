from .. import config
from .model_interlis_dss import ModelInterlisDss
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisSia405Abwasser3D(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class deckel3d(ModelInterlisSia405Abwasser.deckel):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_deckel"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.deckel3d = deckel3d

        class einleitstelle3d(ModelInterlisSia405Abwasser.einleitstelle):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_einleitstelle"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.einleitstelle3d = einleitstelle3d

        class haltung3d(ModelInterlisSia405Abwasser.haltung):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_haltung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.haltung3d = haltung3d

        class kanal3d(ModelInterlisSia405Abwasser.kanal):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_kanal"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.kanal3d = kanal3d

        class normschacht3d(ModelInterlisSia405Abwasser.normschacht):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_normschacht"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.normschacht3d = normschacht3d

        class spezialbauwerk3d(ModelInterlisSia405Abwasser.spezialbauwerk):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_spezialbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.spezialbauwerk3d = spezialbauwerk3d

        class versickerungsanlage3d(ModelInterlisSia405Abwasser.versickerungsanlage):
            __tablename__ = "sia405__1_lv95sia405_abwassr_3d_versickerungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser3D.versickerungsanlage3d = versickerungsanlage3d
