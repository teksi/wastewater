from sqlalchemy.ext.automap import automap_base

from .. import config, utils

###############################################
# QGEP datamodel
# All tables will be loaded from the QGEP schema as a SqlAlchemy ORM class.
# Only table specific relationships (e.g. inheritance) need to be manually
# defined here. Other attributes will be loaded automatically.
###############################################

Base = automap_base()

SCHEMA = config.QGEP_SCHEMA


class organisation(Base):
    __tablename__ = "organisation"
    __table_args__ = {"schema": SCHEMA}


class wastewater_structure(Base):
    __tablename__ = "wastewater_structure"
    __table_args__ = {"schema": SCHEMA}


class channel(wastewater_structure):
    __tablename__ = "channel"
    __table_args__ = {"schema": SCHEMA}


class manhole(wastewater_structure):
    __tablename__ = "manhole"
    __table_args__ = {"schema": SCHEMA}


class discharge_point(wastewater_structure):
    __tablename__ = "discharge_point"
    __table_args__ = {"schema": SCHEMA}


class special_structure(wastewater_structure):
    __tablename__ = "special_structure"
    __table_args__ = {"schema": SCHEMA}


class infiltration_installation(wastewater_structure):
    __tablename__ = "infiltration_installation"
    __table_args__ = {"schema": SCHEMA}


class pipe_profile(Base):
    __tablename__ = "pipe_profile"
    __table_args__ = {"schema": SCHEMA}


class wastewater_networkelement(Base):
    __tablename__ = "wastewater_networkelement"
    __table_args__ = {"schema": SCHEMA}


class reach_point(Base):
    __tablename__ = "reach_point"
    __table_args__ = {"schema": SCHEMA}


class wastewater_node(wastewater_networkelement):
    __tablename__ = "wastewater_node"
    __table_args__ = {"schema": SCHEMA}


class reach(wastewater_networkelement):
    __tablename__ = "reach"
    __table_args__ = {"schema": SCHEMA}


class structure_part(Base):
    __tablename__ = "structure_part"
    __table_args__ = {"schema": SCHEMA}


class dryweather_downspout(structure_part):
    __tablename__ = "dryweather_downspout"
    __table_args__ = {"schema": SCHEMA}


class access_aid(structure_part):
    __tablename__ = "access_aid"
    __table_args__ = {"schema": SCHEMA}


class dryweather_flume(structure_part):
    __tablename__ = "dryweather_flume"
    __table_args__ = {"schema": SCHEMA}


class cover(structure_part):
    __tablename__ = "cover"
    __table_args__ = {"schema": SCHEMA}


class benching(structure_part):
    __tablename__ = "benching"
    __table_args__ = {"schema": SCHEMA}


# VSA_KEK


class maintenance_event(Base):
    __tablename__ = "maintenance_event"
    __table_args__ = {"schema": SCHEMA}


class examination(maintenance_event):
    __tablename__ = "examination"
    __table_args__ = {"schema": SCHEMA}


class damage(Base):
    __tablename__ = "damage"
    __table_args__ = {"schema": SCHEMA}


class damage_manhole(damage):
    __tablename__ = "damage_manhole"
    __table_args__ = {"schema": SCHEMA}


class damage_channel(damage):
    __tablename__ = "damage_channel"
    __table_args__ = {"schema": SCHEMA}


class data_media(Base):
    __tablename__ = "data_media"
    __table_args__ = {"schema": SCHEMA}


class file(Base):
    __tablename__ = "file"
    __table_args__ = {"schema": SCHEMA}


_prepared = False


def get_qgep_model():
    global _prepared
    if not _prepared:
        utils.sqlalchemy.prepare_automap_base(Base, SCHEMA)
        _prepared = True
    return Base.classes
