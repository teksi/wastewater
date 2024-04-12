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

        class reach_progression_alternative(self.Base):
            __tablename__ = "reach_progression_alternative"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.reach_progression_alternative = reach_progression_alternative

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

        class flushing_nozzle(structure_part):
            __tablename__ = "flushing_nozzle"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.flushing_nozzle = flushing_nozzle

        class drainless_toilet(wastewater_structure):
            __tablename__ = "drainless_toilet"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.drainless_toilet = drainless_toilet

        class tank_emptying(structure_part):
            __tablename__ = "tank_emptying"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.tank_emptying = tank_emptying

        class tank_cleaning(structure_part):
            __tablename__ = "tank_cleaning"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.tank_cleaning = tank_cleaning

        class bio_ecol_assessment(maintenance_event):
            __tablename__ = "bio_ecol_assessment"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.bio_ecol_assessment = bio_ecol_assessment

        class maintenance(maintenance_event):
            __tablename__ = "maintenance"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.maintenance = maintenance

        class connection_object(wastewater_networkelement):
            __tablename__ = "connection_object"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.connection_object = connection_object

        class fountain(connection_object):
            __tablename__ = "fountain"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.fountain = fountain

        class reservoir(connection_object):
            __tablename__ = "reservoir"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.reservoir = reservoir

        class building(connection_object):
            __tablename__ = "building"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.building = building

        class individual_surface(connection_object):
            __tablename__ = "individual_surface"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.individual_surface = individual_surface

        class catchment_area(self.Base):
            __tablename__ = "catchment_area"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.catchment_area = catchment_area

        class surface_runoff_parameters(self.Base):
            __tablename__ = "surface_runoff_parameters"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.surface_runoff_parameters = surface_runoff_parameters

        class param_ca_general(surface_runoff_parameters):
            __tablename__ = "param_ca_general"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.param_ca_general = param_ca_general

        class param_ca_mouse1(surface_runoff_parameters):
            __tablename__ = "param_ca_mouse1"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.param_ca_mouse1 = param_ca_mouse1

        class electric_equipment(structure_part):
            __tablename__ = "electric_equipment"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.electric_equipment = electric_equipment

        class electromechanical_equipment(structure_part):
            __tablename__ = "electromechanical_equipment"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.electromechanical_equipment = electromechanical_equipment

        class zone(self.Base):
            __tablename__ = "zone"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.zone = zone

        class drainage_system(zone):
            __tablename__ = "drainage_system"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.drainage_system = drainage_system

        class infiltration_zone(zone):
            __tablename__ = "infiltration_zone"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.infiltration_zone = infiltration_zone

        class solids_retention(structure_part):
            __tablename__ = "solids_retention"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.solids_retention = solids_retention

        class overflow(self.Base):
            __tablename__ = "overflow"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.overflow = overflow

        class pump(overflow):
            __tablename__ = "pump"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.pump = pump

        class leapingweir(overflow):
            __tablename__ = "leapingweir"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.leapingweir = leapingweir

        class prank_weir(overflow):
            __tablename__ = "prank_weir"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.prank_weir = prank_weir

        class small_treatment_plant(wastewater_structure):
            __tablename__ = "small_treatment_plant"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.small_treatment_plant = small_treatment_plant

        class backflow_prevention(structure_part):
            __tablename__ = "backflow_prevention"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.backflow_prevention = backflow_prevention

        class file(self.Base):
            __tablename__ = "file"
            __table_args__ = {"schema": config.TWW_OD_SCHEMA}

        ModelTwwOd.file = file
