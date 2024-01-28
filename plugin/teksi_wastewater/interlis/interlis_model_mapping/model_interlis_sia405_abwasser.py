from .. import config
from .model_base import ModelBase


class ModelInterlisSia405Abwasser(ModelBase):
    def __init__(self):
        super().__init__(config.ABWASSER_SCHEMA)

        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.baseclass = baseclass

        class sia405_baseclass(baseclass):
            __tablename__ = "sia405_baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.sia405_baseclass = sia405_baseclass

        class vsa_baseclass(sia405_baseclass):
            __tablename__ = "vsa_baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.vsa_baseclass = vsa_baseclass

        class organisation(sia405_baseclass):
            __tablename__ = "organisation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.organisation = organisation

        class abwasserbauwerk(vsa_baseclass):
            __tablename__ = "abwasserbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.abwasserbauwerk = abwasserbauwerk

        class kanal(abwasserbauwerk):
            __tablename__ = "kanal"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.kanal = kanal

        class normschacht(abwasserbauwerk):
            __tablename__ = "normschacht"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.normschacht = normschacht

        class einleitstelle(abwasserbauwerk):
            __tablename__ = "einleitstelle"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.einleitstelle = einleitstelle

        class spezialbauwerk(abwasserbauwerk):
            __tablename__ = "spezialbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.spezialbauwerk = spezialbauwerk

        class versickerungsanlage(abwasserbauwerk):
            __tablename__ = "versickerungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.versickerungsanlage = versickerungsanlage

        class rohrprofil(vsa_baseclass):
            __tablename__ = "rohrprofil"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.rohrprofil = rohrprofil

        class abwassernetzelement(vsa_baseclass):
            __tablename__ = "abwassernetzelement"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.abwassernetzelement = abwassernetzelement

        class haltungspunkt(vsa_baseclass):
            __tablename__ = "haltungspunkt"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.haltungspunkt = haltungspunkt

        class abwasserknoten(abwassernetzelement):
            __tablename__ = "abwasserknoten"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.abwasserknoten = abwasserknoten

        class haltung(abwassernetzelement):
            __tablename__ = "haltung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.haltung = haltung

        class bauwerksteil(vsa_baseclass):
            __tablename__ = "bauwerksteil"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.bauwerksteil = bauwerksteil

        class trockenwetterfallrohr(bauwerksteil):
            __tablename__ = "trockenwetterfallrohr"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.trockenwetterfallrohr = trockenwetterfallrohr

        class einstiegshilfe(bauwerksteil):
            __tablename__ = "einstiegshilfe"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.einstiegshilfe = einstiegshilfe

        class trockenwetterrinne(bauwerksteil):
            __tablename__ = "trockenwetterrinne"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.trockenwetterrinne = trockenwetterrinne

        class deckel(bauwerksteil):
            __tablename__ = "deckel"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.deckel = deckel

        class bankett(bauwerksteil):
            __tablename__ = "bankett"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.bankett = bankett

        class spuelstutzen(bauwerksteil):
            __tablename__ = "spuelstutzen"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.spuelstutzen = spuelstutzen

        # TEXTS

        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.textpos = textpos

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.sia405_textpos = sia405_textpos

        class haltung_text(sia405_textpos):
            __tablename__ = "haltung_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.haltung_text = haltung_text

        class abwasserbauwerk_text(sia405_textpos):
            __tablename__ = "abwasserbauwerk_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.abwasserbauwerk_text = abwasserbauwerk_text
