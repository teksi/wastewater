from .. import config
from .model_base import ModelBase


class ModelInterlisAG96(ModelBase):
    def __init__(self):
        super().__init__(config.ABWASSER_SCHEMA)

        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG96.baseclass = baseclass

        class metainformation(self.Base):
            __tablename__ = "metainformation"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.metainformation = metainformation
        
        class organisation(self.Base):
            __tablename__ = "organisation"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}
        
        ModelInterlisAG96.organisation = organisation  

        class bautenausserhalbbaugebiet(metainformation):
            __tablename__ = "bautenausserhalbbaugebiet"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}
        
        ModelInterlisAG96.bautenausserhalbbaugebiet = bautenausserhalbbaugebiet 
        
        class einzugsgebiet(metainformation):
            __tablename__ = "einzugsgebiet"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}
        
        ModelInterlisAG96.einzugsgebiet = einzugsgebiet   

        class haltung(metainformation):
            __tablename__ = "gephaltung"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}
        # Nomenklatur .haltung, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG96.haltung = haltung   

        class abwasserbauwerk(metainformation):
            __tablename__ = "gepknoten"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}
        # Nomenklatur .abwasserbauwerk, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG96.abwasserbauwerk = abwasserbauwerk

        class gepmassnahme(metainformation):
            __tablename__ = "gepmassnahme"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.gepmassnahme = gepmassnahme   

        class sbw_einzugsgebiet(metainformation):
            __tablename__ = "sbw_einzugsgebiet"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.sbw_einzugsgebiet = sbw_einzugsgebiet   

        class ueberlauf_foerderaggregat(metainformation):
            __tablename__ = "ueberlauf_foerderaggregat"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat   

        class versickerungsbereichag(metainformation):
            __tablename__ = "versickerungsbereichag"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.versickerungsbereichag = versickerungsbereichag   

        # TEXTS
        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.textpos = textpos   

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.sia405_textpos = sia405_textpos   

        class gephaltung_text(sia405_textpos):
            __tablename__ = "gephaltung_text"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.gephaltung_text = gephaltung_text   

        class gepknoten_text(sia405_textpos):
            __tablename__ = "gepknoten_text"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}

        ModelInterlisAG96.gepknoten_text = gepknoten_text   
            
        class bautenausserhalbbaugebiet_text(sia405_textpos):
            __tablename__ = "bautenausserhalbbaugebiet_text"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}    

        ModelInterlisAG96.bautenausserhalbbaugebiet_text = bautenausserhalbbaugebiet_text   
                
        class einzugsgebiet_text(sia405_textpos):
            __tablename__ = "einzugsgebiet_text"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA}    

        ModelInterlisAG96.einzugsgebiet_text = einzugsgebiet_text   

        class gepmassnahme_text(sia405_textpos):
            __tablename__ = "gepmassnahme_text"
            __table_args__ = {"schema":config.ABWASSER_SCHEMA} 

        ModelInterlisAG96.gepmassnahme_text = gepmassnahme_text   
