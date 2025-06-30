from sqlalchemy import Column, Integer

from .. import config
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisVsaKek(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class erhaltungsereignis(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "erhaltungsereignis"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_erhaltungsereignis = Column("t_basket", Integer)

        ModelInterlisVsaKek.erhaltungsereignis = erhaltungsereignis

        class untersuchung(ModelInterlisVsaKek.erhaltungsereignis):
            __tablename__ = "untersuchung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_untersuchung = Column("t_basket", Integer)

        ModelInterlisVsaKek.untersuchung = untersuchung

        class schaden(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "schaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_schaden = Column("t_basket", Integer)

        ModelInterlisVsaKek.schaden = schaden

        class normschachtschaden(schaden):
            __tablename__ = "normschachtschaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_normschachtschaden = Column("t_basket", Integer)

        ModelInterlisVsaKek.normschachtschaden = normschachtschaden

        class kanalschaden(schaden):
            __tablename__ = "kanalschaden"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_kanalschaden = Column("t_basket", Integer)

        ModelInterlisVsaKek.kanalschaden = kanalschaden

        class datentraeger(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "datentraeger"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_datentraeger = Column("t_basket", Integer)

        ModelInterlisVsaKek.datentraeger = datentraeger

        class datei(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "datei"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_datei = Column("t_basket", Integer)

        ModelInterlisVsaKek.datei = datei
