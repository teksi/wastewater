from .model_interlis_sia405_base import ModelInterlisSia405Base


class ModelInterlisSia405Schutzrohr(ModelInterlisSia405Base):
    def __init__(self, schema):
        super().__init__(schema)

        class schutzrohr(ModelInterlisSia405Base.sia405_baseclass):
            __tablename__ = "schutzrohr"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Schutzrohr.schutzrohr = schutzrohr

        class schutzrohr_text(ModelInterlisSia405Base.sia405_textpos):
            __tablename__ = "schutzrohr_text"
            __table_args__ = {"schema": self.schema}

        ModelInterlisSia405Schutzrohr.schutzrohr_textpos = schutzrohr_text
