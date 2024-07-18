from sqlalchemy import Column, Integer

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
            t_basket_sia405_baseclass = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.sia405_baseclass = sia405_baseclass

        class vsa_baseclass(sia405_baseclass):
            __tablename__ = "vsa_baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_vsa_baseclass = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.vsa_baseclass = vsa_baseclass

        class organisation(sia405_baseclass):
            __tablename__ = "organisation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_organisation = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.organisation = organisation

        class abwasserbauwerk(vsa_baseclass):
            __tablename__ = "abwasserbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwasserbauwerk = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.abwasserbauwerk = abwasserbauwerk

        class kanal(abwasserbauwerk):
            __tablename__ = "kanal"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_kanal = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.kanal = kanal

        class normschacht(abwasserbauwerk):
            __tablename__ = "normschacht"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_normschacht = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.normschacht = normschacht

        class einleitstelle(abwasserbauwerk):
            __tablename__ = "einleitstelle"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_einleitstelle = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.einleitstelle = einleitstelle

        class spezialbauwerk(abwasserbauwerk):
            __tablename__ = "spezialbauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_spezialbauwerk = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.spezialbauwerk = spezialbauwerk

        class versickerungsanlage(abwasserbauwerk):
            __tablename__ = "versickerungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_versickerungsanlage = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.versickerungsanlage = versickerungsanlage

        class rohrprofil(vsa_baseclass):
            __tablename__ = "rohrprofil"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_rohrprofil = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.rohrprofil = rohrprofil

        class abwassernetzelement(vsa_baseclass):
            __tablename__ = "abwassernetzelement"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwassernetzelement = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.abwassernetzelement = abwassernetzelement

        class haltungspunkt(vsa_baseclass):
            __tablename__ = "haltungspunkt"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_haltungspunkt = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.haltungspunkt = haltungspunkt

        class abwasserknoten(abwassernetzelement):
            __tablename__ = "abwasserknoten"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwasserknoten = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.abwasserknoten = abwasserknoten

        class haltung(abwassernetzelement):
            __tablename__ = "haltung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_haltung = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.haltung = haltung

        class haltung_alternativverlauf(baseclass):
            __tablename__ = "haltung_alternativverlauf"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_haltung_alternativverlauf = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.haltung_alternativverlauf = haltung_alternativverlauf

        class bauwerksteil(vsa_baseclass):
            __tablename__ = "bauwerksteil"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_bauwerksteil = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.bauwerksteil = bauwerksteil

        class trockenwetterfallrohr(bauwerksteil):
            __tablename__ = "trockenwetterfallrohr"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_trockenwetterfallrohr = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.trockenwetterfallrohr = trockenwetterfallrohr

        class einstiegshilfe(bauwerksteil):
            __tablename__ = "einstiegshilfe"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_einstiegshilfe = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.einstiegshilfe = einstiegshilfe

        class trockenwetterrinne(bauwerksteil):
            __tablename__ = "trockenwetterrinne"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_trockenwetterrinne = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.trockenwetterrinne = trockenwetterrinne

        class deckel(bauwerksteil):
            __tablename__ = "deckel"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_deckel = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.deckel = deckel

        class bankett(bauwerksteil):
            __tablename__ = "bankett"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_bankett = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.bankett = bankett

        class spuelstutzen(bauwerksteil):
            __tablename__ = "spuelstutzen"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_spuelstutzen = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.spuelstutzen = spuelstutzen

        # TEXTS

        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_textpos = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.textpos = textpos

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_sia405_textpos = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.sia405_textpos = sia405_textpos

        class haltung_text(sia405_textpos):
            __tablename__ = "haltung_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_haltung_text = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.haltung_text = haltung_text

        class abwasserbauwerk_text(sia405_textpos):
            __tablename__ = "abwasserbauwerk_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwasserbauwerk_text = Column("t_basket", Integer)

        ModelInterlisSia405Abwasser.abwasserbauwerk_text = abwasserbauwerk_text

        # SymbolPos

        class symbolpos(baseclass):
            __tablename__ = "symbolpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.symbolpos = symbolpos

        class sia405_symbolpos(symbolpos):
            __tablename__ = "sia405_symbolpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.sia405_symbolpos = sia405_symbolpos

        class abwasserbauwerk_symbol(sia405_symbolpos):
            __tablename__ = "abwasserbauwerk_symbol"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405Abwasser.abwasserbauwerk_symbol = abwasserbauwerk_symbol
