from sqlalchemy import select
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

    # channel_bedding_encasement
    # channel_connection_type
    # channel_function_hierarchic
    # channel_function_hydraulic
    # channel_usage_current
    # channel_usage_planned
    # discharge_point_relevance
    # infiltration_installation_defects
    # infiltration_installation_emergency_overflow
    # infiltration_installation_kind
    # infiltration_installation_labeling
    # infiltration_installation_seepage_utilization
    # infiltration_installation_vehicle_access
    # infiltration_installation_watertightness
    # manhole_function
    # manhole_material
    # manhole_surface_inflow

    class organisation_organisation_type(Base):
        __tablename__ = "organisation_organisation_type"
        __table_args__ = {"schema": SCHEMA}

    class organisation_status(Base):
        __tablename__ = "organisation_status"
        __table_args__ = {"schema": SCHEMA}

    class special_structure_emergency_overflow(Base):
        __tablename__ = "special_structure_emergency_overflow"
        __table_args__ = {"schema": SCHEMA}

    class special_structure_function(Base):
        __tablename__ = "special_structure_function"
        __table_args__ = {"schema": SCHEMA}

    class special_structure_stormwater_tank_arrangement(Base):
        __tablename__ = "special_structure_stormwater_tank_arrangement"
        __table_args__ = {"schema": SCHEMA}

    # pipe_profile_profile_type

    # structure_part_renovation_demand

    # wastewater_structure_accessibility
    # wastewater_structure_financing
    # wastewater_structure_renovation_necessity
    # wastewater_structure_rv_construction_type
    # wastewater_structure_status
    # wastewater_structure_structure_condition

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
