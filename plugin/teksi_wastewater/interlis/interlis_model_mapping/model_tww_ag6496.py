from .. import config
from .model_base import ModelBase
from sqlalchemy import Column, String


class ModelTwwAG6496(ModelBase):
    def __init__(self):
        super().__init__(config.TWW_AG_SCHEMA)

        class organisation(self.Base):
            __tablename__ = "organisation"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.organisation = organisation  

        class gepknoten(self.Base):
            __tablename__ = "gepknoten"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepknoten = gepknoten

        class gephaltung(self.Base):
            __tablename__ = "gephaltung"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gephaltung = gephaltung

        class gepmassnahme(self.Base):
            __tablename__ = "gepmassnahme"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepmassnahme = gepmassnahme

        class bautenausserhalbbaugebiet(self.Base):
            __tablename__ = "bautenausserhalbbaugebiet"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.bautenausserhalbbaugebiet = bautenausserhalbbaugebiet

        class ueberlauf_foerderaggregat(self.Base):
            __tablename__ = "ueberlauf_foerderaggregat"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat

        class sbw_einzugsgebiet(self.Base):
            __tablename__ = "sbw_einzugsgebiet"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}
            
        ModelTwwAG6496.sbw_einzugsgebiet = sbw_einzugsgebiet

        class versickerungsbereichag(self.Base):
            __tablename__ = "versickerungsbereichag"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}   
        
        ModelTwwAG6496.versickerungsbereichag = versickerungsbereichag
