from .model_interlis_sia405_base_abwasser import ModelInterlisSia405BaseAbwasser


class ModelInterlisSia405Abwasser(ModelInterlisSia405BaseAbwasser):
    def __init__(self, schema):
        super().__init__(schema)

        class vsa_baseclass(self.sia405_baseclass):
            __tablename__ = "vsa_baseclass"
            __table_args__ = {"schema": self.schema}

        self.vsa_baseclass = vsa_baseclass

        class abwasserbauwerk(vsa_baseclass):
            __tablename__ = "abwasserbauwerk"
            __table_args__ = {"schema": self.schema}

        self.abwasserbauwerk = abwasserbauwerk

        class kanal(abwasserbauwerk):
            __tablename__ = "kanal"
            __table_args__ = {"schema": self.schema}

        self.kanal = kanal

        class normschacht(abwasserbauwerk):
            __tablename__ = "normschacht"
            __table_args__ = {"schema": self.schema}

        self.normschacht = normschacht

        class einleitstelle(abwasserbauwerk):
            __tablename__ = "einleitstelle"
            __table_args__ = {"schema": self.schema}

        self.einleitstelle = einleitstelle

        class spezialbauwerk(abwasserbauwerk):
            __tablename__ = "spezialbauwerk"
            __table_args__ = {"schema": self.schema}

        self.spezialbauwerk = spezialbauwerk

        class versickerungsanlage(abwasserbauwerk):
            __tablename__ = "versickerungsanlage"
            __table_args__ = {"schema": self.schema}

        self.versickerungsanlage = versickerungsanlage

        class rohrprofil(vsa_baseclass):
            __tablename__ = "rohrprofil"
            __table_args__ = {"schema": self.schema}

        self.rohrprofil = rohrprofil

        class abwassernetzelement(vsa_baseclass):
            __tablename__ = "abwassernetzelement"
            __table_args__ = {"schema": self.schema}

        self.abwassernetzelement = abwassernetzelement

        class haltungspunkt(vsa_baseclass):
            __tablename__ = "haltungspunkt"
            __table_args__ = {"schema": self.schema}

        self.haltungspunkt = haltungspunkt

        class abwasserknoten(abwassernetzelement):
            __tablename__ = "abwasserknoten"
            __table_args__ = {"schema": self.schema}

        self.abwasserknoten = abwasserknoten

        class haltung(abwassernetzelement):
            __tablename__ = "haltung"
            __table_args__ = {"schema": self.schema}

        self.haltung = haltung

        class haltung_alternativverlauf(self.baseclass):
            __tablename__ = "haltung_alternativverlauf"
            __table_args__ = {"schema": self.schema}

        self.haltung_alternativverlauf = haltung_alternativverlauf

        class bauwerksteil(vsa_baseclass):
            __tablename__ = "bauwerksteil"
            __table_args__ = {"schema": self.schema}

        self.bauwerksteil = bauwerksteil

        class trockenwetterfallrohr(bauwerksteil):
            __tablename__ = "trockenwetterfallrohr"
            __table_args__ = {"schema": self.schema}

        self.trockenwetterfallrohr = trockenwetterfallrohr

        class einstiegshilfe(bauwerksteil):
            __tablename__ = "einstiegshilfe"
            __table_args__ = {"schema": self.schema}

        self.einstiegshilfe = einstiegshilfe

        class trockenwetterrinne(bauwerksteil):
            __tablename__ = "trockenwetterrinne"
            __table_args__ = {"schema": self.schema}

        self.trockenwetterrinne = trockenwetterrinne

        class deckel(bauwerksteil):
            __tablename__ = "deckel"
            __table_args__ = {"schema": self.schema}

        self.deckel = deckel

        class bankett(bauwerksteil):
            __tablename__ = "bankett"
            __table_args__ = {"schema": self.schema}

        self.bankett = bankett

        class spuelstutzen(bauwerksteil):
            __tablename__ = "spuelstutzen"
            __table_args__ = {"schema": self.schema}

        self.spuelstutzen = spuelstutzen

        # TEXTS

        class haltung_text(self.sia405_textpos):
            __tablename__ = "haltung_text"
            __table_args__ = {"schema": self.schema}

        self.haltung_text = haltung_text

        class abwasserbauwerk_text(self.sia405_textpos):
            __tablename__ = "abwasserbauwerk_text"
            __table_args__ = {"schema": self.schema}

        self.abwasserbauwerk_text = abwasserbauwerk_text

        # SymbolPos

        class abwasserbauwerk_symbol(self.sia405_symbolpos):
            __tablename__ = "abwasserbauwerk_symbol"
            __table_args__ = {"schema": self.schema}

        self.abwasserbauwerk_symbol = abwasserbauwerk_symbol
