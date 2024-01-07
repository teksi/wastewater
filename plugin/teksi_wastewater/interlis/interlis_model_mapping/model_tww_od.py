from ...interlis import config
from .model_base import ModelBase


class ModelTwwOd(ModelBase):
    def __init__(self):
        super().__init__(config.TWW_OD_SCHEMA)

        class wastewater_structure(self.Base):
            __tablename__ = "wastewater_structure"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.wastewater_structure = wastewater_structure

        class channel(wastewater_structure):
            __tablename__ = "channel"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.channel = channel

        class manhole(wastewater_structure):
            __tablename__ = "manhole"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.manhole = manhole

        class discharge_point(wastewater_structure):
            __tablename__ = "discharge_point"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.discharge_point = discharge_point

        class special_structure(wastewater_structure):
            __tablename__ = "special_structure"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.special_structure = special_structure

        class infiltration_installation(wastewater_structure):
            __tablename__ = "infiltration_installation"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.infiltration_installation = infiltration_installation

        class wastewater_networkelement(self.Base):
            __tablename__ = "wastewater_networkelement"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.wastewater_networkelement = wastewater_networkelement

        class reach_point(self.Base):
            __tablename__ = "reach_point"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.reach_point = reach_point

        class wastewater_node(wastewater_networkelement):
            __tablename__ = "wastewater_node"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.wastewater_node = wastewater_node

        class reach(wastewater_networkelement):
            __tablename__ = "reach"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.reach = reach

        # class structure_part(wastewater_structure):
        class structure_part(self.Base):
            __tablename__ = "structure_part"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.structure_part = structure_part

        class dryweather_downspout(structure_part):
            __tablename__ = "dryweather_downspout"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.dryweather_downspout = dryweather_downspout

        class access_aid(structure_part):
            __tablename__ = "access_aid"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.access_aid = access_aid

        class dryweather_flume(structure_part):
            __tablename__ = "dryweather_flume"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.dryweather_flume = dryweather_flume

        class cover(structure_part):
            __tablename__ = "cover"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.cover = cover

        class benching(structure_part):
            __tablename__ = "benching"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.benching = benching

        class wwtp_structure(wastewater_structure):
            __tablename__ = "wwtp_structure"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.wwtp_structure = wwtp_structure

        # VSA_KEK

        class maintenance_event(self.Base):
            __tablename__ = "maintenance_event"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.maintenance_event = maintenance_event

        class examination(maintenance_event):
            __tablename__ = "examination"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.examination = examination

        class damage(self.Base):
            __tablename__ = "damage"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.damage = damage

        class damage_manhole(damage):
            __tablename__ = "damage_manhole"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.damage_manhole = damage_manhole

        class damage_channel(damage):
            __tablename__ = "damage_channel"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.damage_channel = damage_channel
