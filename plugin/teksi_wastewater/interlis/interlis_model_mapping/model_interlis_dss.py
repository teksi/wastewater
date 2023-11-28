from .. import config
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisDss(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class abwasserreinigungsanlage(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "abwasserreinigungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.abwasserreinigungsanlage = abwasserreinigungsanlage

        class arabauwerk(ModelInterlisSia405Abwasser.abwasserbauwerk):
            __tablename__ = "arabauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.arabauwerk = arabauwerk
