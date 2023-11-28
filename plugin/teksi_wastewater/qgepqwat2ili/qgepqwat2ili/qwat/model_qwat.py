from sqlalchemy.ext.automap import automap_base

from .. import config, utils

###############################################
# QWAT datamodel
# All tables will be loaded from the QWAT schema as a SqlAlchemy ORM class.
# Only table specific relationships (e.g. inheritance) need to be manually
# defined here. Other attributes will be loaded automatically.
###############################################

Base = automap_base()

SCHEMA = config.QWAT_SCHEMA


class node(Base):
    __tablename__ = "node"
    __table_args__ = {"schema": SCHEMA}


class network_element(node):
    __tablename__ = "network_element"
    __table_args__ = {"schema": SCHEMA}


class part(network_element):
    __tablename__ = "part"
    __table_args__ = {"schema": SCHEMA}


class hydrant(network_element):
    __tablename__ = "hydrant"
    __table_args__ = {"schema": SCHEMA}


class subscriber(network_element):
    __tablename__ = "subscriber"
    __table_args__ = {"schema": SCHEMA}


class installation(network_element):
    __tablename__ = "installation"
    __table_args__ = {"schema": SCHEMA}


class tank(installation):
    __tablename__ = "tank"
    __table_args__ = {"schema": SCHEMA}


class treatment(installation):
    __tablename__ = "treatment"
    __table_args__ = {"schema": SCHEMA}


class pump(installation):
    __tablename__ = "pump"
    __table_args__ = {"schema": SCHEMA}


class chamber(installation):
    __tablename__ = "chamber"
    __table_args__ = {"schema": SCHEMA}


class source(installation):
    __tablename__ = "source"
    __table_args__ = {"schema": SCHEMA}


class pressurecontrol(installation):
    __tablename__ = "pressurecontrol"
    __table_args__ = {"schema": SCHEMA}


class pipe(Base):
    __tablename__ = "pipe"
    __table_args__ = {"schema": SCHEMA}


_prepared = False


def get_qwat_model():
    global _prepared
    if not _prepared:
        utils.sqlalchemy.prepare_automap_base(Base, SCHEMA)
        _prepared = True
    return Base.classes
