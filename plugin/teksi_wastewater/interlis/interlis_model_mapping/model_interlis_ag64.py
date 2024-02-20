from .. import config
from .model_base import ModelBase


class ModelInterlisAG64(ModelBase):
    def __init__(self):
        super().__init__(config.AG64_SCHEMA)
        
        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.baseclass = baseclass

        class metainformation(baseclass):
            __tablename__ = "metainformation"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.metainformation = metainformation    
        
        class organisation(self.Base):
            __tablename__ = "organisation"
            __table_args__ = {"schema":config.AG64_SCHEMA}
        
        ModelInterlisAG64.organisation = organisation  

        class infrastrukturhaltung(metainformation):
            __tablename__ = "infrastrukturhaltung"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        # Nomenklatur .haltung, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG64.haltung = infrastrukturhaltung   

        class infrastrukturknoten(metainformation):
            __tablename__ = "infrastrukturknoten"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        # Nomenklatur .abwasserbauwerk, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG64.abwasserbauwerk = infrastrukturknoten 

        class ueberlauf_foerderaggregat(metainformation):
            __tablename__ = "ueberlauf_foerderaggregat"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat   

        # TEXTS


        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.textpos = textpos   

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.sia405_textpos = sia405_textpos   

        class infrastrukturhaltung_text(sia405_textpos):
            __tablename__ = "infrastrukturhaltung_text"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.infrastrukturhaltung_text = infrastrukturhaltung_text   

        class infrastrukturknoten_text(sia405_textpos):
            __tablename__ = "infrastrukturknoten_text"
            __table_args__ = {"schema":config.AG64_SCHEMA}

        ModelInterlisAG64.infrastrukturknoten_text = infrastrukturknoten_text   
        