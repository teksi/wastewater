from sqlalchemy import select
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from teksi_wastewater.interlis import config
from teksi_wastewater.interlis.utils import tww_sqlalchemy

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

    def __init__(self):
        self.session = Session(tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False)

        self.get_classes()

    def get_classes(self):
        if not self._prepared:
            tww_sqlalchemy.prepare_automap_base(self.Base, SCHEMA)
            self._prepared = True
        return self.Base.classes

    def get_organisation_organisation_type_code(self, value_de):
        stmt = select(self.organisation_organisation_type).where(
            self.organisation_organisation_type.value_de == value_de
        )
        return self.session.scalars(stmt).one().code

    def get_organisation_status_code(self, value_de):
        stmt = select(self.organisation_status).where(
            self.organisation_status.value_de == value_de
        )
        return self.session.scalars(stmt).one().code
