from .. import config
from .model_base import ModelBase


class ModelInterlisSia405BaseAbwasser(ModelBase):
    def __init__(self):
        super().__init__(config.ABWASSER_SCHEMA)

        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.baseclass = baseclass

        class sia405_baseclass(baseclass):
            __tablename__ = "sia405_baseclass"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.sia405_baseclass = sia405_baseclass



        class organisation(sia405_baseclass):
            __tablename__ = "organisation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.organisation = organisation

        # TEXTS

        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.textpos = textpos

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.sia405_textpos = sia405_textpos


        # SymbolPos

        class symbolpos(baseclass):
            __tablename__ = "symbolpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.symbolpos = symbolpos

        class sia405_symbolpos(symbolpos):
            __tablename__ = "sia405_symbolpos"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisSia405BaseAbwasser.sia405_symbolpos = sia405_symbolpos