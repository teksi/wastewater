from .model_interlis_base import ModelInterlisBase


class ModelInterlisSia405Base(ModelInterlisBase):
    def __init__(self, schema):
        super().__init__(schema)

        class sia405_baseclass(ModelInterlisBase.baseclass):
            __tablename__ = "sia405_baseclass"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Base.sia405_baseclass = sia405_baseclass

        # TEXTS
        class sia405_textpos(ModelInterlisBase.textpos):
            __tablename__ = "sia405_textpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Base.sia405_textpos = sia405_textpos

        # SymbolPos

        class sia405_symbolpos(ModelInterlisBase.symbolpos):
            __tablename__ = "sia405_symbolpos"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Base.sia405_symbolpos = sia405_symbolpos
