from .. import config
from .model_base import ModelBase


class ModelTwwAG6496(ModelBase):
    def __init__(self):
        super().__init__(config.TWW_AG_SCHEMA)

        class organisation(self.Base):
            __tablename__ = "organisation"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.organisation = organisation  

        class gepknoten(self.Base):
            __tablename__ = "gepknoten"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepknoten = gepknoten

        class gephaltung(self.Base):
            __tablename__ = "gephaltung"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gephaltung = gephaltung

        class gepmassnahme(self.Base):
            __tablename__ = "gepmassnahme"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepmassnahme = gepmassnahme

        class bautenausserhalbbaugebiet(self.Base):
            __tablename__ = "bautenausserhalbbaugebiet"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.bautenausserhalbbaugebiet = bautenausserhalbbaugebiet

        class ueberlauf_foerderaggregat(self.Base):
            __tablename__ = "ueberlauf_foerderaggregat"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat

        class sbw_einzugsgebiet(self.Base):
            __tablename__ = "sbw_einzugsgebiet"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}
            
        ModelTwwAG6496.sbw_einzugsgebiet = sbw_einzugsgebiet

        class versickerungsbereichag(self.Base):
            __tablename__ = "versickerungsbereichag"
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}   
        
        ModelTwwAG6496.versickerungsbereichag = versickerungsbereichag
