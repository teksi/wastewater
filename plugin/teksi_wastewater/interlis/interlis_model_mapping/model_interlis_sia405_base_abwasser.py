from .model_interlis_base import ModelInterlisBase


class ModelInterlisSia405BaseAbwasser(ModelInterlisBase):
    def __init__(self, schema):
        super().__init__(schema)

        class sia405_baseclass(ModelInterlisBase.baseclass):
            __tablename__ = "sia405_baseclass"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.sia405_baseclass = sia405_baseclass

        class organisation(sia405_baseclass):
            __tablename__ = "organisation"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.organisation = organisation

        # TEXTS

        class textpos(ModelInterlisBase.baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.textpos = textpos

        class sia405_textpos(textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.sia405_textpos = sia405_textpos

        # SymbolPos

        class symbolpos(ModelInterlisBase.baseclass):
            __tablename__ = "symbolpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.symbolpos = symbolpos

        class sia405_symbolpos(symbolpos):
            __tablename__ = "sia405_symbolpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405BaseAbwasser.sia405_symbolpos = sia405_symbolpos
