from .model_base import ModelBase


class ModelInterlisBase(ModelBase):
    def __init__(self, schema):
        super().__init__(schema)

        class baseclass(self.Base):
            __tablename__ = "baseclass"
            __table_args__ = {"schema": self.schema}

        self.baseclass = baseclass

        # TEXTS

        class textpos(baseclass):
            __tablename__ = "textpos"
            __table_args__ = {"schema": self.schema}

        self.textpos = textpos

        # SymbolPos

        class symbolpos(baseclass):
            __tablename__ = "symbolpos"
            __table_args__ = {"schema": self.schema}

        self.symbolpos = symbolpos
