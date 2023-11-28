from sqlalchemy.ext.automap import automap_base

from .. import config, utils

SCHEMA = config.ABWASSER_SCHEMA

Base = automap_base()


class baseclass(Base):
    __tablename__ = "baseclass"
    __table_args__ = {"schema": SCHEMA}


class sia405_baseclass(baseclass):
    __tablename__ = "sia405_baseclass"
    __table_args__ = {"schema": SCHEMA}


class organisation(sia405_baseclass):
    __tablename__ = "organisation"
    __table_args__ = {"schema": SCHEMA}


class abwasserbauwerk(sia405_baseclass):
    __tablename__ = "abwasserbauwerk"
    __table_args__ = {"schema": SCHEMA}


class kanal(abwasserbauwerk):
    __tablename__ = "kanal"
    __table_args__ = {"schema": SCHEMA}


class normschacht(abwasserbauwerk):
    __tablename__ = "normschacht"
    __table_args__ = {"schema": SCHEMA}


class einleitstelle(abwasserbauwerk):
    __tablename__ = "einleitstelle"
    __table_args__ = {"schema": SCHEMA}


class spezialbauwerk(abwasserbauwerk):
    __tablename__ = "spezialbauwerk"
    __table_args__ = {"schema": SCHEMA}


class versickerungsanlage(abwasserbauwerk):
    __tablename__ = "versickerungsanlage"
    __table_args__ = {"schema": SCHEMA}


class rohrprofil(sia405_baseclass):
    __tablename__ = "rohrprofil"
    __table_args__ = {"schema": SCHEMA}


class abwassernetzelement(sia405_baseclass):
    __tablename__ = "abwassernetzelement"
    __table_args__ = {"schema": SCHEMA}


class haltungspunkt(sia405_baseclass):
    __tablename__ = "haltungspunkt"
    __table_args__ = {"schema": SCHEMA}


class abwasserknoten(abwassernetzelement):
    __tablename__ = "abwasserknoten"
    __table_args__ = {"schema": SCHEMA}


class haltung(abwassernetzelement):
    __tablename__ = "haltung"
    __table_args__ = {"schema": SCHEMA}


class bauwerksteil(sia405_baseclass):
    __tablename__ = "bauwerksteil"
    __table_args__ = {"schema": SCHEMA}


class trockenwetterfallrohr(bauwerksteil):
    __tablename__ = "trockenwetterfallrohr"
    __table_args__ = {"schema": SCHEMA}


class einstiegshilfe(bauwerksteil):
    __tablename__ = "einstiegshilfe"
    __table_args__ = {"schema": SCHEMA}


class trockenwetterrinne(bauwerksteil):
    __tablename__ = "trockenwetterrinne"
    __table_args__ = {"schema": SCHEMA}


class deckel(bauwerksteil):
    __tablename__ = "deckel"
    __table_args__ = {"schema": SCHEMA}


class bankett(bauwerksteil):
    __tablename__ = "bankett"
    __table_args__ = {"schema": SCHEMA}


# VSA_KEK


class erhaltungsereignis(sia405_baseclass):
    __tablename__ = "erhaltungsereignis"
    __table_args__ = {"schema": SCHEMA}


class untersuchung(erhaltungsereignis):
    __tablename__ = "untersuchung"
    __table_args__ = {"schema": SCHEMA}


class schaden(sia405_baseclass):
    __tablename__ = "schaden"
    __table_args__ = {"schema": SCHEMA}


class normschachtschaden(schaden):
    __tablename__ = "normschachtschaden"
    __table_args__ = {"schema": SCHEMA}


class kanalschaden(schaden):
    __tablename__ = "kanalschaden"
    __table_args__ = {"schema": SCHEMA}


class datentraeger(sia405_baseclass):
    __tablename__ = "datentraeger"
    __table_args__ = {"schema": SCHEMA}


class datei(sia405_baseclass):
    __tablename__ = "datei"
    __table_args__ = {"schema": SCHEMA}


# STRUCTS


class metaattribute(Base):
    __tablename__ = "metaattribute"
    __table_args__ = {"schema": SCHEMA}


# TEXTS


class textpos(baseclass):
    __tablename__ = "textpos"
    __table_args__ = {"schema": SCHEMA}


class sia405_textpos(textpos):
    __tablename__ = "sia405_textpos"
    __table_args__ = {"schema": SCHEMA}


class haltung_text(sia405_textpos):
    __tablename__ = "haltung_text"
    __table_args__ = {"schema": SCHEMA}


class abwasserbauwerk_text(sia405_textpos):
    __tablename__ = "abwasserbauwerk_text"
    __table_args__ = {"schema": SCHEMA}


_prepared = False


def get_abwasser_model():
    global _prepared
    if not _prepared:
        utils.sqlalchemy.prepare_automap_base(Base, SCHEMA)
        _prepared = True
    return Base.classes
