from sqlalchemy.ext.automap import automap_base

from .. import config, utils
from ...interlis import config
from .model_base import ModelBase


class ModelTwwOd(ModelBase):
    def __init__(self):
        super().__init__(config.TWW_AG_SCHEMA)

        class organisation(Base):
            __tablename__ = "organisation"
            __table_args__ = {"schema": SCHEMA}
            

        class gepknoten(Base):
            __tablename__ = "gepknoten"
            __table_args__ = {"schema": SCHEMA}


        class gephaltung(Base):
            __tablename__ = "gephaltung"
            __table_args__ = {"schema": SCHEMA}


        class gepmassnahme(Base):
            __tablename__ = "gepmassnahme"
            __table_args__ = {"schema": SCHEMA}


        class bautenausserhalbbaugebiet(Base):
            __tablename__ = "bautenausserhalbbaugebiet"
            __table_args__ = {"schema": SCHEMA}


        class ueberlauf_foerderaggregat(Base):
            __tablename__ = "ueberlauf_foerderaggregat"
            __table_args__ = {"schema": SCHEMA}

        class sbw_einzugsgebiet(Base):
            __tablename__ = "sbw_einzugsgebiet"
            __table_args__ = {"schema": SCHEMA}
            
        class versickerungsbereichag(Base):
            __tablename__ = "versickerungsbereichag"
            __table_args__ = {"schema": SCHEMA}   
