from sqlalchemy.ext.automap import automap_base

from ..utils import tww_sqlalchemy


class ModelBase:
    """
    Base class for datamodels
    All tables will be loaded from the respective schemas (pg2ili, tww_od, tww_vl) as a SqlAlchemy ORM class.
    Only table specific relationships (e.g. inheritance) need to be manually
    defined here. Other attributes will be loaded automatically.
    """
    inheritance_key: str | None = None

    def __init__(self, schema):
        self.Base = automap_base()
        self.schema = schema

    def classes(self):
        tww_sqlalchemy.prepare_automap_base(self.Base, self.schema,inheritance_key=self.inheritance_key,)
        return self.Base.classes
