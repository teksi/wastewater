from .. import config
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisDss(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class abwasserreinigungsanlage(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "abwasserreinigungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.abwasserreinigungsanlage = abwasserreinigungsanlage

        class araenergienutzung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "araenergienutzung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.araenergienutzung = araenergienutzung

        class abwasserbehandlung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "abwasserbehandlung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.abwasserbehandlung = abwasserbehandlung

        class schlammbehandlung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "schlammbehandlung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.schlammbehandlung = schlammbehandlung

        class arabauwerk(ModelInterlisSia405Abwasser.abwasserbauwerk):
            __tablename__ = "arabauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.arabauwerk = arabauwerk

        class steuerungszentrale(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "steuerungszentrale"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.steuerungszentrale = steuerungszentrale
