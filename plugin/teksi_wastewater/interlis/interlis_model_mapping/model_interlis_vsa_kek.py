from .. import config
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisVsaKek(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class erhaltungsereignis(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "erhaltungsereignis"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.erhaltungsereignis = erhaltungsereignis

        class untersuchung(ModelInterlisVsaKek.erhaltungsereignis):
            __tablename__ = "untersuchung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.untersuchung = untersuchung

        class schaden(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "schaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.schaden = schaden

        class normschachtschaden(schaden):
            __tablename__ = "normschachtschaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.normschachtschaden = normschachtschaden

        class kanalschaden(schaden):
            __tablename__ = "kanalschaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.kanalschaden = kanalschaden

        class datentraeger(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "datentraeger"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.datentraeger = datentraeger

        class datei(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "datei"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisVsaKek.datei = datei
