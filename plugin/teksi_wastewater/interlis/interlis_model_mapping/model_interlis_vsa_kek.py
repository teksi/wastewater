from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisVsaKek(ModelInterlisSia405Abwasser):
    def __init__(self, schema):
        super().__init__(schema)

        class erhaltungsereignis(self.vsa_baseclass):
            __tablename__ = "erhaltungsereignis"
            __table_args__ = {"schema": self.schema}

        self.erhaltungsereignis = erhaltungsereignis

        class untersuchung(self.erhaltungsereignis):
            __tablename__ = "untersuchung"
            __table_args__ = {"schema": self.schema}

        self.untersuchung = untersuchung

        class schaden(self.vsa_baseclass):
            __tablename__ = "schaden"
            __table_args__ = {"schema": self.schema}

        self.schaden = schaden

        class normschachtschaden(schaden):
            __tablename__ = "normschachtschaden"
            __table_args__ = {"schema": self.schema}

        self.normschachtschaden = normschachtschaden

        class kanalschaden(schaden):
            __tablename__ = "kanalschaden"
            __table_args__ = {"schema": self.schema}

        self.kanalschaden = kanalschaden

        class datentraeger(self.vsa_baseclass):
            __tablename__ = "datentraeger"
            __table_args__ = {"schema": self.schema}

        self.datentraeger = datentraeger

        class datei(self.vsa_baseclass):
            __tablename__ = "datei"
            __table_args__ = {"schema": self.schema}

        self.datei = datei
