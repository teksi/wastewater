from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session

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

    class organisation_organisation_type(Base):
        __tablename__ = "organisation_organisation_type"
        __table_args__ = {"schema": SCHEMA}

    class organisation_status(Base):
        __tablename__ = "organisation_status"
        __table_args__ = {"schema": SCHEMA}

    class special_structure_emergency_overflow(Base):
        __tablename__ = "special_structure_emergency_overflow"
        __table_args__ = {"schema": SCHEMA}

    def __init__(self):
        self.session = Session(tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False)

        self.get_classes()

    def get_classes(self):
        if not self._prepared:
            tww_sqlalchemy.prepare_automap_base(self.Base, SCHEMA)
            self._prepared = True
        return self.Base.classes
