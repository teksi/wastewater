from .. import config
from .model_base import ModelBase


class ModelInterlisAG64(ModelBase):
    def __init__(self):
        super().__init__(config.ABWASSER_SCHEMA)

        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.baseclass = baseclass

        class organisation(self.Base):
            __tablename__ = "organisation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.organisation = organisation

        class haltung(self.Base):
            __tablename__ = "infrastrukturhaltung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        # Nomenklatur .haltung, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG64.haltung = haltung

        class abwasserbauwerk(self.Base):
            __tablename__ = "infrastrukturknoten"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        # Nomenklatur .abwasserbauwerk, damit es für den Label-Export mit VSA-DSS übereinstimmt
        ModelInterlisAG64.abwasserbauwerk = abwasserbauwerk

        class ueberlauf_foerderaggregat(self.Base):
            __tablename__ = "ueberlauf_foerderaggregat"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat

        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.textpos = textpos

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.sia405_textpos = sia405_textpos

        class haltung_text(sia405_textpos):
            __tablename__ = "infrastrukturhaltung_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.haltung_text = haltung_text

        class abwasserbauwerk_text(sia405_textpos):
            __tablename__ = "infrastrukturknoten_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisAG64.abwasserbauwerk_text = abwasserbauwerk_text
