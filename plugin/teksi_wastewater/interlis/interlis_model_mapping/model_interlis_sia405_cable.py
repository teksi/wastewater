from .. import config
from .model_interlis_sia405_base import ModelInterlisSia405Base


class ModelInterlisSia405Fernwirkkabel(ModelInterlisSia405Base):
    def __init__(self, schema):
        super().__init__(schema)


        class kabel(ModelInterlisSia405Base.sia405_baseclass):
            __tablename__ = "kabel"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Fernwirkkabel.kabel = kabel

        class kabelpunkt(ModelInterlisSia405Base.sia405_baseclass):
            __tablename__ = "kabelpunkt"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Fernwirkkabel.kabelpunkt = kabelpunkt

        class kabel_text(ModelInterlisSia405Base.sia405_textpos):
            __tablename__ = "kabel_text"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Fernwirkkabel.kabel_text = kabel_text