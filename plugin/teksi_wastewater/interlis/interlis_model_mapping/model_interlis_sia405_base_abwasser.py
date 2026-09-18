from .model_interlis_base import ModelInterlisBase


class ModelInterlisSia405BaseAbwasser(ModelInterlisBase):
    def __init__(self, schema):
        super().__init__(schema)

        class sia405_baseclass(self.baseclass):
            __tablename__ = "sia405_baseclass"
            __table_args__ = {"schema": self.schema}

        self.sia405_baseclass = sia405_baseclass

        class organisation(sia405_baseclass):
            __tablename__ = "organisation"
            __table_args__ = {"schema": self.schema}

        self.organisation = organisation

        # TEXTS

        class sia405_textpos(self.textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": self.schema}

        self.sia405_textpos = sia405_textpos

        # SymbolPos

        class sia405_symbolpos(self.symbolpos):
            __tablename__ = "sia405_symbolpos"
            __table_args__ = {"schema": self.schema}

        self.sia405_symbolpos = sia405_symbolpos
