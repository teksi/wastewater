from sqlalchemy.ext.automap import automap_base

from ...interlis import config
from ...interlis.utils import tww_sqlalchemy

###############################################
# TEKSI Wastewater datamodel
# All tables will be loaded from the TWW schema as a SqlAlchemy ORM class.
# Only table specific relationships (e.g. inheritance) need to be manually
# defined here. Other attributes will be loaded automatically.
###############################################

SCHEMA = config.TWW_VL_SCHEMA


class ModelTwwVl:
    Base = automap_base()

    _prepared = False

    @classmethod
    def classes(cls):
        if not cls._prepared:
            tww_sqlalchemy.prepare_automap_base(cls.Base, SCHEMA)
            cls._prepared = True
        return cls.Base.classes
