from sqlalchemy.ext.automap import automap_base

from .. import config, utils

SCHEMA = config.WASSER_SCHEMA

Base = automap_base()


class baseclass(Base):
    __tablename__ = "baseclass"
    __table_args__ = {"schema": SCHEMA}


class sia405_baseclass(baseclass):
    __tablename__ = "sia405_baseclass"
    __table_args__ = {"schema": SCHEMA}


class hydraulischer_knoten(sia405_baseclass):  # noeud_hydraulique
    __tablename__ = "hydraulischer_knoten"
    __table_args__ = {"schema": SCHEMA}


class leitungsknoten(sia405_baseclass):  # neud_de_conduite
    __tablename__ = "leitungsknoten"
    __table_args__ = {"schema": SCHEMA}


class anlage(leitungsknoten):
    __tablename__ = "anlage"
    __table_args__ = {"schema": SCHEMA}


class hausanschluss(leitungsknoten):
    __tablename__ = "hausanschluss"
    __table_args__ = {"schema": SCHEMA}


class hydrant(leitungsknoten):  # hydrant
    __tablename__ = "hydrant"
    __table_args__ = {"schema": SCHEMA}


class wasserbehaelter(leitungsknoten):  # reservoir_d_eau
    __tablename__ = "wasserbehaelter"
    __table_args__ = {"schema": SCHEMA}


class foerderanlage(leitungsknoten):  # station_de_pompage
    __tablename__ = "foerderanlage"
    __table_args__ = {"schema": SCHEMA}


class absperrorgan(leitungsknoten):
    __tablename__ = "absperrorgan"
    __table_args__ = {"schema": SCHEMA}


class wassergewinnungsanlage(leitungsknoten):
    __tablename__ = "wassergewinnungsanlage"
    __table_args__ = {"schema": SCHEMA}


class rohrleitungsteil(leitungsknoten):
    __tablename__ = "rohrleitungsteil"
    __table_args__ = {"schema": SCHEMA}


class hydraulischer_strang(sia405_baseclass):  # troncon_hydraulique
    __tablename__ = "hydraulischer_strang"
    __table_args__ = {"schema": SCHEMA}


class leitung(sia405_baseclass):  # conduite
    __tablename__ = "leitung"
    __table_args__ = {"schema": SCHEMA}


class schadenstelle(sia405_baseclass):
    __tablename__ = "schadenstelle"
    __table_args__ = {"schema": SCHEMA}


class spezialbauwerk(sia405_baseclass):
    __tablename__ = "spezialbauwerk"
    __table_args__ = {"schema": SCHEMA}


_prepared = False


def get_wasser_model():
    global _prepared
    if not _prepared:
        utils.sqlalchemy.prepare_automap_base(Base, SCHEMA)
        _prepared = True
    return Base.classes
