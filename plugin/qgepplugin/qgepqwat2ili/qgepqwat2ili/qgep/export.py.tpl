from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_Transform, ST_Force2D

from .. import utils

from .model_qgep import get_qgep_model
from .model_abwasser import get_abwasser_model


def qgep_export():

    QGEP = get_qgep_model()
    ABWASSER = get_abwasser_model()

    qgep_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    abwasser_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    tid_maker = utils.ili2db.TidMaker(id_attribute='obj_id')

    def create_metaattributes(row, session):
        metaattribute = ABWASSER.metaattribute(
            # FIELDS TO MAP TO ABWASSER.metaattribute
            # --- metaattribute ---
            # datenherr=row.REPLACE_ME,
            # datenlieferant=row.REPLACE_ME,
            # letzte_aenderung=row.REPLACE_ME,
            # sia405_baseclass_metaattribute=row.REPLACE_ME,
            # t_id=row.REPLACE_ME
            # t_seq=row.REPLACE_ME,
        )
        session.add(metaattribute)

    print("Exporting QGEP.organisation -> ABWASSER.organisation, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.organisation):

        # organisation --- organisation.fk_dataowner, organisation.fk_provider, organisation.identifier, organisation.last_modification, organisation.obj_id, organisation.remark, organisation.uid
        # _bwrel_ --- organisation.accident__BWREL_fk_dataowner, organisation.accident__BWREL_fk_provider, organisation.administrative_office__BWREL_obj_id, organisation.aquifier__BWREL_fk_dataowner, organisation.aquifier__BWREL_fk_provider, organisation.bathing_area__BWREL_fk_dataowner, organisation.bathing_area__BWREL_fk_provider, organisation.canton__BWREL_obj_id, organisation.catchment_area__BWREL_fk_dataowner, organisation.catchment_area__BWREL_fk_provider, organisation.connection_object__BWREL_fk_dataowner, organisation.connection_object__BWREL_fk_operator, organisation.connection_object__BWREL_fk_owner, organisation.connection_object__BWREL_fk_provider, organisation.control_center__BWREL_fk_dataowner, organisation.control_center__BWREL_fk_provider, organisation.cooperative__BWREL_obj_id, organisation.damage__BWREL_fk_dataowner, organisation.damage__BWREL_fk_provider, organisation.data_media__BWREL_fk_dataowner, organisation.data_media__BWREL_fk_provider, organisation.file__BWREL_fk_dataowner, organisation.file__BWREL_fk_provider, organisation.fish_pass__BWREL_fk_dataowner, organisation.fish_pass__BWREL_fk_provider, organisation.hazard_source__BWREL_fk_dataowner, organisation.hazard_source__BWREL_fk_owner, organisation.hazard_source__BWREL_fk_provider, organisation.hq_relation__BWREL_fk_dataowner, organisation.hq_relation__BWREL_fk_provider, organisation.hydr_geom_relation__BWREL_fk_dataowner, organisation.hydr_geom_relation__BWREL_fk_provider, organisation.hydr_geometry__BWREL_fk_dataowner, organisation.hydr_geometry__BWREL_fk_provider, organisation.hydraulic_char_data__BWREL_fk_dataowner, organisation.hydraulic_char_data__BWREL_fk_provider, organisation.maintenance_event__BWREL_fk_dataowner, organisation.maintenance_event__BWREL_fk_operating_company, organisation.maintenance_event__BWREL_fk_provider, organisation.measurement_result__BWREL_fk_dataowner, organisation.measurement_result__BWREL_fk_provider, organisation.measurement_series__BWREL_fk_dataowner, organisation.measurement_series__BWREL_fk_provider, organisation.measuring_device__BWREL_fk_dataowner, organisation.measuring_device__BWREL_fk_provider, organisation.measuring_point__BWREL_fk_dataowner, organisation.measuring_point__BWREL_fk_operator, organisation.measuring_point__BWREL_fk_provider, organisation.mechanical_pretreatment__BWREL_fk_dataowner, organisation.mechanical_pretreatment__BWREL_fk_provider, organisation.municipality__BWREL_obj_id, organisation.mutation__BWREL_fk_dataowner, organisation.mutation__BWREL_fk_provider, organisation.organisation__BWREL_fk_dataowner, organisation.organisation__BWREL_fk_provider, organisation.overflow__BWREL_fk_dataowner, organisation.overflow__BWREL_fk_provider, organisation.overflow_char__BWREL_fk_dataowner, organisation.overflow_char__BWREL_fk_provider, organisation.pipe_profile__BWREL_fk_dataowner, organisation.pipe_profile__BWREL_fk_provider, organisation.private__BWREL_obj_id, organisation.profile_geometry__BWREL_fk_dataowner, organisation.profile_geometry__BWREL_fk_provider, organisation.reach_point__BWREL_fk_dataowner, organisation.reach_point__BWREL_fk_provider, organisation.retention_body__BWREL_fk_dataowner, organisation.retention_body__BWREL_fk_provider, organisation.river_bank__BWREL_fk_dataowner, organisation.river_bank__BWREL_fk_provider, organisation.river_bed__BWREL_fk_dataowner, organisation.river_bed__BWREL_fk_provider, organisation.sector_water_body__BWREL_fk_dataowner, organisation.sector_water_body__BWREL_fk_provider, organisation.sludge_treatment__BWREL_fk_dataowner, organisation.sludge_treatment__BWREL_fk_provider, organisation.structure_part__BWREL_fk_dataowner, organisation.structure_part__BWREL_fk_provider, organisation.substance__BWREL_fk_dataowner, organisation.substance__BWREL_fk_provider, organisation.surface_runoff_parameters__BWREL_fk_dataowner, organisation.surface_runoff_parameters__BWREL_fk_provider, organisation.surface_water_bodies__BWREL_fk_dataowner, organisation.surface_water_bodies__BWREL_fk_provider, organisation.throttle_shut_off_unit__BWREL_fk_dataowner, organisation.throttle_shut_off_unit__BWREL_fk_provider, organisation.txt_symbol__BWREL_fk_dataowner, organisation.txt_symbol__BWREL_fk_provider, organisation.waste_water_association__BWREL_obj_id, organisation.waste_water_treatment__BWREL_fk_dataowner, organisation.waste_water_treatment__BWREL_fk_provider, organisation.waste_water_treatment_plant__BWREL_obj_id, organisation.wastewater_networkelement__BWREL_fk_dataowner, organisation.wastewater_networkelement__BWREL_fk_provider, organisation.wastewater_structure__BWREL_fk_dataowner, organisation.wastewater_structure__BWREL_fk_operator, organisation.wastewater_structure__BWREL_fk_owner, organisation.wastewater_structure__BWREL_fk_provider, organisation.wastewater_structure_symbol__BWREL_fk_dataowner, organisation.wastewater_structure_symbol__BWREL_fk_provider, organisation.water_catchment__BWREL_fk_dataowner, organisation.water_catchment__BWREL_fk_provider, organisation.water_control_structure__BWREL_fk_dataowner, organisation.water_control_structure__BWREL_fk_provider, organisation.water_course_segment__BWREL_fk_dataowner, organisation.water_course_segment__BWREL_fk_provider, organisation.wwtp_energy_use__BWREL_fk_dataowner, organisation.wwtp_energy_use__BWREL_fk_provider, organisation.zone__BWREL_fk_dataowner, organisation.zone__BWREL_fk_provider
        # _rel_ --- organisation.fk_dataowner__REL, organisation.fk_provider__REL

        organisation = ABWASSER.organisation(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- organisation ---
            # auid=row.REPLACE_ME,  # VARCHAR(12)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(80)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(organisation)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.channel -> ABWASSER.kanal, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.channel):

        # wastewater_structure --- channel._bottom_label, channel._cover_label, channel._depth, channel._function_hierarchic, channel._input_label, channel._label, channel._output_label, channel._usage_current, channel.accessibility, channel.contract_section, channel.detail_geometry_geometry, channel.financing, channel.fk_dataowner, channel.fk_main_cover, channel.fk_main_wastewater_node, channel.fk_operator, channel.fk_owner, channel.fk_provider, channel.gross_costs, channel.identifier, channel.inspection_interval, channel.last_modification, channel.location_name, channel.records, channel.remark, channel.renovation_necessity, channel.replacement_value, channel.rv_base_year, channel.rv_construction_type, channel.status, channel.structure_condition, channel.subsidies, channel.year_of_construction, channel.year_of_replacement
        # channel --- channel.bedding_encasement, channel.connection_type, channel.function_hierarchic, channel.function_hydraulic, channel.jetting_interval, channel.obj_id, channel.pipe_length, channel.usage_current, channel.usage_planned
        # _bwrel_ --- channel.measuring_point__BWREL_fk_wastewater_structure, channel.mechanical_pretreatment__BWREL_fk_wastewater_structure, channel.re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, channel.structure_part__BWREL_fk_wastewater_structure, channel.txt_symbol__BWREL_fk_wastewater_structure, channel.txt_text__BWREL_fk_wastewater_structure, channel.wastewater_networkelement__BWREL_fk_wastewater_structure, channel.wastewater_structure_symbol__BWREL_fk_wastewater_structure, channel.wastewater_structure_text__BWREL_fk_wastewater_structure, channel.wwtp_structure_kind__BWREL_obj_id
        # _rel_ --- channel.accessibility__REL, channel.bedding_encasement__REL, channel.connection_type__REL, channel.financing__REL, channel.fk_dataowner__REL, channel.fk_main_cover__REL, channel.fk_main_wastewater_node__REL, channel.fk_operator__REL, channel.fk_owner__REL, channel.fk_provider__REL, channel.function_hierarchic__REL, channel.function_hydraulic__REL, channel.renovation_necessity__REL, channel.rv_construction_type__REL, channel.status__REL, channel.structure_condition__REL, channel.usage_current__REL, channel.usage_planned__REL

        kanal = ABWASSER.kanal(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwasserbauwerk ---
            # akten=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # baulicherzustand=row.REPLACE_ME,  # VARCHAR(255)
            # baulos=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiberref=row.REPLACE_ME,  # BIGINT
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # bruttokosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # detailgeometrie=row.REPLACE_ME,  # geometry(CURVEPOLYGON,2056)
            # eigentuemerref=row.REPLACE_ME,  # BIGINT
            # ersatzjahr=row.REPLACE_ME,  # INTEGER
            # finanzierung=row.REPLACE_ME,  # VARCHAR(255)
            # inspektionsintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # sanierungsbedarf=row.REPLACE_ME,  # VARCHAR(255)
            # standortname=row.REPLACE_ME,  # VARCHAR(50)
            # subventionen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # wbw_basisjahr=row.REPLACE_ME,  # INTEGER
            # wbw_bauart=row.REPLACE_ME,  # VARCHAR(255)
            # wiederbeschaffungswert=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zugaenglichkeit=row.REPLACE_ME,  # VARCHAR(255)

            # --- kanal ---
            # bettung_umhuellung=row.REPLACE_ME,  # VARCHAR(255)
            # funktionhierarchisch=row.REPLACE_ME,  # VARCHAR(255)
            # funktionhydraulisch=row.REPLACE_ME,  # VARCHAR(255)
            # nutzungsart_geplant=row.REPLACE_ME,  # VARCHAR(255)
            # nutzungsart_ist=row.REPLACE_ME,  # VARCHAR(255)
            # rohrlaenge=row.REPLACE_ME,  # NUMERIC(7, 2)
            # spuelintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # t_id=row.REPLACE_ME,  # BIGINT
            # verbindungsart=row.REPLACE_ME,  # VARCHAR(255)
        )
        abwasser_session.add(kanal)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.manhole -> ABWASSER.normschacht, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.manhole):

        # wastewater_structure --- manhole._bottom_label, manhole._cover_label, manhole._depth, manhole._function_hierarchic, manhole._input_label, manhole._label, manhole._output_label, manhole._usage_current, manhole.accessibility, manhole.contract_section, manhole.detail_geometry_geometry, manhole.financing, manhole.fk_dataowner, manhole.fk_main_cover, manhole.fk_main_wastewater_node, manhole.fk_operator, manhole.fk_owner, manhole.fk_provider, manhole.gross_costs, manhole.identifier, manhole.inspection_interval, manhole.last_modification, manhole.location_name, manhole.records, manhole.remark, manhole.renovation_necessity, manhole.replacement_value, manhole.rv_base_year, manhole.rv_construction_type, manhole.status, manhole.structure_condition, manhole.subsidies, manhole.year_of_construction, manhole.year_of_replacement
        # manhole --- manhole._orientation, manhole.dimension1, manhole.dimension2, manhole.function, manhole.material, manhole.obj_id, manhole.surface_inflow
        # _bwrel_ --- manhole.measuring_point__BWREL_fk_wastewater_structure, manhole.mechanical_pretreatment__BWREL_fk_wastewater_structure, manhole.re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, manhole.structure_part__BWREL_fk_wastewater_structure, manhole.txt_symbol__BWREL_fk_wastewater_structure, manhole.txt_text__BWREL_fk_wastewater_structure, manhole.wastewater_networkelement__BWREL_fk_wastewater_structure, manhole.wastewater_structure_symbol__BWREL_fk_wastewater_structure, manhole.wastewater_structure_text__BWREL_fk_wastewater_structure, manhole.wwtp_structure_kind__BWREL_obj_id
        # _rel_ --- manhole.accessibility__REL, manhole.financing__REL, manhole.fk_dataowner__REL, manhole.fk_main_cover__REL, manhole.fk_main_wastewater_node__REL, manhole.fk_operator__REL, manhole.fk_owner__REL, manhole.fk_provider__REL, manhole.function__REL, manhole.material__REL, manhole.renovation_necessity__REL, manhole.rv_construction_type__REL, manhole.status__REL, manhole.structure_condition__REL, manhole.surface_inflow__REL

        normschacht = ABWASSER.normschacht(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwasserbauwerk ---
            # akten=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # baulicherzustand=row.REPLACE_ME,  # VARCHAR(255)
            # baulos=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiberref=row.REPLACE_ME,  # BIGINT
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # bruttokosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # detailgeometrie=row.REPLACE_ME,  # geometry(CURVEPOLYGON,2056)
            # eigentuemerref=row.REPLACE_ME,  # BIGINT
            # ersatzjahr=row.REPLACE_ME,  # INTEGER
            # finanzierung=row.REPLACE_ME,  # VARCHAR(255)
            # inspektionsintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # sanierungsbedarf=row.REPLACE_ME,  # VARCHAR(255)
            # standortname=row.REPLACE_ME,  # VARCHAR(50)
            # subventionen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # wbw_basisjahr=row.REPLACE_ME,  # INTEGER
            # wbw_bauart=row.REPLACE_ME,  # VARCHAR(255)
            # wiederbeschaffungswert=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zugaenglichkeit=row.REPLACE_ME,  # VARCHAR(255)

            # --- normschacht ---
            # dimension1=row.REPLACE_ME,  # INTEGER
            # dimension2=row.REPLACE_ME,  # INTEGER
            # funktion=row.REPLACE_ME,  # VARCHAR(255)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # oberflaechenzulauf=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(normschacht)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.discharge_point -> ABWASSER.einleitstelle, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.discharge_point):

        # wastewater_structure --- discharge_point._bottom_label, discharge_point._cover_label, discharge_point._depth, discharge_point._function_hierarchic, discharge_point._input_label, discharge_point._label, discharge_point._output_label, discharge_point._usage_current, discharge_point.accessibility, discharge_point.contract_section, discharge_point.detail_geometry_geometry, discharge_point.financing, discharge_point.fk_dataowner, discharge_point.fk_main_cover, discharge_point.fk_main_wastewater_node, discharge_point.fk_operator, discharge_point.fk_owner, discharge_point.fk_provider, discharge_point.gross_costs, discharge_point.identifier, discharge_point.inspection_interval, discharge_point.last_modification, discharge_point.location_name, discharge_point.records, discharge_point.remark, discharge_point.renovation_necessity, discharge_point.replacement_value, discharge_point.rv_base_year, discharge_point.rv_construction_type, discharge_point.status, discharge_point.structure_condition, discharge_point.subsidies, discharge_point.year_of_construction, discharge_point.year_of_replacement
        # discharge_point --- discharge_point.fk_sector_water_body, discharge_point.highwater_level, discharge_point.obj_id, discharge_point.relevance, discharge_point.terrain_level, discharge_point.upper_elevation, discharge_point.waterlevel_hydraulic
        # _bwrel_ --- discharge_point.measuring_point__BWREL_fk_wastewater_structure, discharge_point.mechanical_pretreatment__BWREL_fk_wastewater_structure, discharge_point.re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, discharge_point.structure_part__BWREL_fk_wastewater_structure, discharge_point.txt_symbol__BWREL_fk_wastewater_structure, discharge_point.txt_text__BWREL_fk_wastewater_structure, discharge_point.wastewater_networkelement__BWREL_fk_wastewater_structure, discharge_point.wastewater_structure_symbol__BWREL_fk_wastewater_structure, discharge_point.wastewater_structure_text__BWREL_fk_wastewater_structure, discharge_point.wwtp_structure_kind__BWREL_obj_id
        # _rel_ --- discharge_point.accessibility__REL, discharge_point.financing__REL, discharge_point.fk_dataowner__REL, discharge_point.fk_main_cover__REL, discharge_point.fk_main_wastewater_node__REL, discharge_point.fk_operator__REL, discharge_point.fk_owner__REL, discharge_point.fk_provider__REL, discharge_point.fk_sector_water_body__REL, discharge_point.relevance__REL, discharge_point.renovation_necessity__REL, discharge_point.rv_construction_type__REL, discharge_point.status__REL, discharge_point.structure_condition__REL

        einleitstelle = ABWASSER.einleitstelle(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwasserbauwerk ---
            # akten=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # baulicherzustand=row.REPLACE_ME,  # VARCHAR(255)
            # baulos=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiberref=row.REPLACE_ME,  # BIGINT
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # bruttokosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # detailgeometrie=row.REPLACE_ME,  # geometry(CURVEPOLYGON,2056)
            # eigentuemerref=row.REPLACE_ME,  # BIGINT
            # ersatzjahr=row.REPLACE_ME,  # INTEGER
            # finanzierung=row.REPLACE_ME,  # VARCHAR(255)
            # inspektionsintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # sanierungsbedarf=row.REPLACE_ME,  # VARCHAR(255)
            # standortname=row.REPLACE_ME,  # VARCHAR(50)
            # subventionen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # wbw_basisjahr=row.REPLACE_ME,  # INTEGER
            # wbw_bauart=row.REPLACE_ME,  # VARCHAR(255)
            # wiederbeschaffungswert=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zugaenglichkeit=row.REPLACE_ME,  # VARCHAR(255)

            # --- einleitstelle ---
            # hochwasserkote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # relevanz=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
            # terrainkote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # wasserspiegel_hydraulik=row.REPLACE_ME,  # NUMERIC(7, 3)
        )
        abwasser_session.add(einleitstelle)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.special_structure -> ABWASSER.spezialbauwerk, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.special_structure):

        # wastewater_structure --- special_structure._bottom_label, special_structure._cover_label, special_structure._depth, special_structure._function_hierarchic, special_structure._input_label, special_structure._label, special_structure._output_label, special_structure._usage_current, special_structure.accessibility, special_structure.contract_section, special_structure.detail_geometry_geometry, special_structure.financing, special_structure.fk_dataowner, special_structure.fk_main_cover, special_structure.fk_main_wastewater_node, special_structure.fk_operator, special_structure.fk_owner, special_structure.fk_provider, special_structure.gross_costs, special_structure.identifier, special_structure.inspection_interval, special_structure.last_modification, special_structure.location_name, special_structure.records, special_structure.remark, special_structure.renovation_necessity, special_structure.replacement_value, special_structure.rv_base_year, special_structure.rv_construction_type, special_structure.status, special_structure.structure_condition, special_structure.subsidies, special_structure.year_of_construction, special_structure.year_of_replacement
        # special_structure --- special_structure.bypass, special_structure.emergency_spillway, special_structure.function, special_structure.obj_id, special_structure.stormwater_tank_arrangement, special_structure.upper_elevation
        # _bwrel_ --- special_structure.measuring_point__BWREL_fk_wastewater_structure, special_structure.mechanical_pretreatment__BWREL_fk_wastewater_structure, special_structure.re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, special_structure.structure_part__BWREL_fk_wastewater_structure, special_structure.txt_symbol__BWREL_fk_wastewater_structure, special_structure.txt_text__BWREL_fk_wastewater_structure, special_structure.wastewater_networkelement__BWREL_fk_wastewater_structure, special_structure.wastewater_structure_symbol__BWREL_fk_wastewater_structure, special_structure.wastewater_structure_text__BWREL_fk_wastewater_structure, special_structure.wwtp_structure_kind__BWREL_obj_id
        # _rel_ --- special_structure.accessibility__REL, special_structure.bypass__REL, special_structure.emergency_spillway__REL, special_structure.financing__REL, special_structure.fk_dataowner__REL, special_structure.fk_main_cover__REL, special_structure.fk_main_wastewater_node__REL, special_structure.fk_operator__REL, special_structure.fk_owner__REL, special_structure.fk_provider__REL, special_structure.function__REL, special_structure.renovation_necessity__REL, special_structure.rv_construction_type__REL, special_structure.status__REL, special_structure.stormwater_tank_arrangement__REL, special_structure.structure_condition__REL

        spezialbauwerk = ABWASSER.spezialbauwerk(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwasserbauwerk ---
            # akten=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # baulicherzustand=row.REPLACE_ME,  # VARCHAR(255)
            # baulos=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiberref=row.REPLACE_ME,  # BIGINT
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # bruttokosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # detailgeometrie=row.REPLACE_ME,  # geometry(CURVEPOLYGON,2056)
            # eigentuemerref=row.REPLACE_ME,  # BIGINT
            # ersatzjahr=row.REPLACE_ME,  # INTEGER
            # finanzierung=row.REPLACE_ME,  # VARCHAR(255)
            # inspektionsintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # sanierungsbedarf=row.REPLACE_ME,  # VARCHAR(255)
            # standortname=row.REPLACE_ME,  # VARCHAR(50)
            # subventionen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # wbw_basisjahr=row.REPLACE_ME,  # INTEGER
            # wbw_bauart=row.REPLACE_ME,  # VARCHAR(255)
            # wiederbeschaffungswert=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zugaenglichkeit=row.REPLACE_ME,  # VARCHAR(255)

            # --- spezialbauwerk ---
            # bypass=row.REPLACE_ME,  # VARCHAR(255)
            # funktion=row.REPLACE_ME,  # VARCHAR(255)
            # notueberlauf=row.REPLACE_ME,  # VARCHAR(255)
            # regenbecken_anordnung=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(spezialbauwerk)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.infiltration_installation -> ABWASSER.versickerungsanlage, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.infiltration_installation):

        # wastewater_structure --- infiltration_installation._bottom_label, infiltration_installation._cover_label, infiltration_installation._depth, infiltration_installation._function_hierarchic, infiltration_installation._input_label, infiltration_installation._label, infiltration_installation._output_label, infiltration_installation._usage_current, infiltration_installation.accessibility, infiltration_installation.contract_section, infiltration_installation.detail_geometry_geometry, infiltration_installation.financing, infiltration_installation.fk_dataowner, infiltration_installation.fk_main_cover, infiltration_installation.fk_main_wastewater_node, infiltration_installation.fk_operator, infiltration_installation.fk_owner, infiltration_installation.fk_provider, infiltration_installation.gross_costs, infiltration_installation.identifier, infiltration_installation.inspection_interval, infiltration_installation.last_modification, infiltration_installation.location_name, infiltration_installation.records, infiltration_installation.remark, infiltration_installation.renovation_necessity, infiltration_installation.replacement_value, infiltration_installation.rv_base_year, infiltration_installation.rv_construction_type, infiltration_installation.status, infiltration_installation.structure_condition, infiltration_installation.subsidies, infiltration_installation.year_of_construction, infiltration_installation.year_of_replacement
        # infiltration_installation --- infiltration_installation.absorption_capacity, infiltration_installation.defects, infiltration_installation.dimension1, infiltration_installation.dimension2, infiltration_installation.distance_to_aquifer, infiltration_installation.effective_area, infiltration_installation.emergency_spillway, infiltration_installation.fk_aquifier, infiltration_installation.kind, infiltration_installation.labeling, infiltration_installation.obj_id, infiltration_installation.seepage_utilization, infiltration_installation.upper_elevation, infiltration_installation.vehicle_access, infiltration_installation.watertightness
        # _bwrel_ --- infiltration_installation.measuring_point__BWREL_fk_wastewater_structure, infiltration_installation.mechanical_pretreatment__BWREL_fk_infiltration_installation, infiltration_installation.mechanical_pretreatment__BWREL_fk_wastewater_structure, infiltration_installation.re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, infiltration_installation.retention_body__BWREL_fk_infiltration_installation, infiltration_installation.structure_part__BWREL_fk_wastewater_structure, infiltration_installation.txt_symbol__BWREL_fk_wastewater_structure, infiltration_installation.txt_text__BWREL_fk_wastewater_structure, infiltration_installation.wastewater_networkelement__BWREL_fk_wastewater_structure, infiltration_installation.wastewater_structure_symbol__BWREL_fk_wastewater_structure, infiltration_installation.wastewater_structure_text__BWREL_fk_wastewater_structure, infiltration_installation.wwtp_structure_kind__BWREL_obj_id
        # _rel_ --- infiltration_installation.accessibility__REL, infiltration_installation.defects__REL, infiltration_installation.emergency_spillway__REL, infiltration_installation.financing__REL, infiltration_installation.fk_aquifier__REL, infiltration_installation.fk_dataowner__REL, infiltration_installation.fk_main_cover__REL, infiltration_installation.fk_main_wastewater_node__REL, infiltration_installation.fk_operator__REL, infiltration_installation.fk_owner__REL, infiltration_installation.fk_provider__REL, infiltration_installation.kind__REL, infiltration_installation.labeling__REL, infiltration_installation.renovation_necessity__REL, infiltration_installation.rv_construction_type__REL, infiltration_installation.seepage_utilization__REL, infiltration_installation.status__REL, infiltration_installation.structure_condition__REL, infiltration_installation.vehicle_access__REL, infiltration_installation.watertightness__REL

        versickerungsanlage = ABWASSER.versickerungsanlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwasserbauwerk ---
            # akten=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # baulicherzustand=row.REPLACE_ME,  # VARCHAR(255)
            # baulos=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiberref=row.REPLACE_ME,  # BIGINT
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # bruttokosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # detailgeometrie=row.REPLACE_ME,  # geometry(CURVEPOLYGON,2056)
            # eigentuemerref=row.REPLACE_ME,  # BIGINT
            # ersatzjahr=row.REPLACE_ME,  # INTEGER
            # finanzierung=row.REPLACE_ME,  # VARCHAR(255)
            # inspektionsintervall=row.REPLACE_ME,  # NUMERIC(4, 2)
            # sanierungsbedarf=row.REPLACE_ME,  # VARCHAR(255)
            # standortname=row.REPLACE_ME,  # VARCHAR(50)
            # subventionen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # wbw_basisjahr=row.REPLACE_ME,  # INTEGER
            # wbw_bauart=row.REPLACE_ME,  # VARCHAR(255)
            # wiederbeschaffungswert=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zugaenglichkeit=row.REPLACE_ME,  # VARCHAR(255)

            # --- versickerungsanlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # beschriftung=row.REPLACE_ME,  # VARCHAR(255)
            # dimension1=row.REPLACE_ME,  # INTEGER
            # dimension2=row.REPLACE_ME,  # INTEGER
            # gwdistanz=row.REPLACE_ME,  # NUMERIC(7, 2)
            # maengel=row.REPLACE_ME,  # VARCHAR(255)
            # notueberlauf=row.REPLACE_ME,  # VARCHAR(255)
            # saugwagen=row.REPLACE_ME,  # VARCHAR(255)
            # schluckvermoegen=row.REPLACE_ME,  # NUMERIC(9, 3)
            # t_id=row.REPLACE_ME,  # BIGINT
            # versickerungswasser=row.REPLACE_ME,  # VARCHAR(255)
            # wasserdichtheit=row.REPLACE_ME,  # VARCHAR(255)
            # wirksameflaeche=row.REPLACE_ME,  # NUMERIC(8, 2)
        )
        abwasser_session.add(versickerungsanlage)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.pipe_profile -> ABWASSER.rohrprofil, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.pipe_profile):

        # pipe_profile --- pipe_profile.fk_dataowner, pipe_profile.fk_provider, pipe_profile.height_width_ratio, pipe_profile.identifier, pipe_profile.last_modification, pipe_profile.obj_id, pipe_profile.profile_type, pipe_profile.remark
        # _bwrel_ --- pipe_profile.profile_geometry__BWREL_fk_pipe_profile, pipe_profile.reach__BWREL_fk_pipe_profile
        # _rel_ --- pipe_profile.fk_dataowner__REL, pipe_profile.fk_provider__REL, pipe_profile.profile_type__REL

        rohrprofil = ABWASSER.rohrprofil(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- rohrprofil ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # hoehenbreitenverhaeltnis=row.REPLACE_ME,  # NUMERIC(5, 2)
            # profiltyp=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(rohrprofil)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.reach_point -> ABWASSER.haltungspunkt, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.reach_point):

        # reach_point --- reach_point.elevation_accuracy, reach_point.fk_dataowner, reach_point.fk_provider, reach_point.fk_wastewater_networkelement, reach_point.identifier, reach_point.last_modification, reach_point.level, reach_point.obj_id, reach_point.outlet_shape, reach_point.position_of_connection, reach_point.remark, reach_point.situation_geometry
        # _bwrel_ --- reach_point.examination__BWREL_fk_reach_point, reach_point.reach__BWREL_fk_reach_point_from, reach_point.reach__BWREL_fk_reach_point_to
        # _rel_ --- reach_point.elevation_accuracy__REL, reach_point.fk_dataowner__REL, reach_point.fk_provider__REL, reach_point.fk_wastewater_networkelement__REL, reach_point.outlet_shape__REL

        haltungspunkt = ABWASSER.haltungspunkt(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- haltungspunkt ---
            # abwassernetzelementref=row.REPLACE_ME,  # BIGINT
            # auslaufform=row.REPLACE_ME,  # VARCHAR(255)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # hoehengenauigkeit=row.REPLACE_ME,  # VARCHAR(255)
            # kote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # lage=row.REPLACE_ME,  # geometry(POINT,2056)
            # lage_anschluss=row.REPLACE_ME,  # INTEGER
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(haltungspunkt)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.wastewater_node -> ABWASSER.abwasserknoten, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.wastewater_node):

        # wastewater_networkelement --- wastewater_node.fk_dataowner, wastewater_node.fk_provider, wastewater_node.fk_wastewater_structure, wastewater_node.identifier, wastewater_node.last_modification, wastewater_node.remark
        # wastewater_node --- wastewater_node.backflow_level, wastewater_node.bottom_level, wastewater_node.fk_hydr_geometry, wastewater_node.obj_id, wastewater_node.situation_geometry
        # _bwrel_ --- wastewater_node.catchment_area__BWREL_fk_wastewater_networkelement_rw_current, wastewater_node.catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, wastewater_node.catchment_area__BWREL_fk_wastewater_networkelement_ww_current, wastewater_node.catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, wastewater_node.connection_object__BWREL_fk_wastewater_networkelement, wastewater_node.hydraulic_char_data__BWREL_fk_wastewater_node, wastewater_node.overflow__BWREL_fk_overflow_to, wastewater_node.overflow__BWREL_fk_wastewater_node, wastewater_node.reach_point__BWREL_fk_wastewater_networkelement, wastewater_node.throttle_shut_off_unit__BWREL_fk_wastewater_node, wastewater_node.wastewater_structure__BWREL_fk_main_wastewater_node
        # _rel_ --- wastewater_node.fk_dataowner__REL, wastewater_node.fk_hydr_geometry__REL, wastewater_node.fk_provider__REL, wastewater_node.fk_wastewater_structure__REL

        abwasserknoten = ABWASSER.abwasserknoten(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwassernetzelement ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)

            # --- abwasserknoten ---
            # lage=row.REPLACE_ME,  # geometry(POINT,2056)
            # rueckstaukote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # sohlenkote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(abwasserknoten)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.reach -> ABWASSER.haltung, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.reach):

        # wastewater_networkelement --- reach.fk_dataowner, reach.fk_provider, reach.fk_wastewater_structure, reach.identifier, reach.last_modification, reach.remark
        # reach --- reach.clear_height, reach.coefficient_of_friction, reach.elevation_determination, reach.fk_pipe_profile, reach.fk_reach_point_from, reach.fk_reach_point_to, reach.horizontal_positioning, reach.inside_coating, reach.length_effective, reach.material, reach.obj_id, reach.progression_geometry, reach.reliner_material, reach.reliner_nominal_size, reach.relining_construction, reach.relining_kind, reach.ring_stiffness, reach.slope_building_plan, reach.wall_roughness
        # _bwrel_ --- reach.catchment_area__BWREL_fk_wastewater_networkelement_rw_current, reach.catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, reach.catchment_area__BWREL_fk_wastewater_networkelement_ww_current, reach.catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, reach.connection_object__BWREL_fk_wastewater_networkelement, reach.reach_point__BWREL_fk_wastewater_networkelement, reach.reach_text__BWREL_fk_reach, reach.txt_text__BWREL_fk_reach
        # _rel_ --- reach.elevation_determination__REL, reach.fk_dataowner__REL, reach.fk_pipe_profile__REL, reach.fk_provider__REL, reach.fk_reach_point_from__REL, reach.fk_reach_point_to__REL, reach.fk_wastewater_structure__REL, reach.horizontal_positioning__REL, reach.inside_coating__REL, reach.material__REL, reach.reliner_material__REL, reach.relining_construction__REL, reach.relining_kind__REL

        haltung = ABWASSER.haltung(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- abwassernetzelement ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)

            # --- haltung ---
            # innenschutz=row.REPLACE_ME,  # VARCHAR(255)
            # laengeeffektiv=row.REPLACE_ME,  # NUMERIC(7, 2)
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # lichte_hoehe=row.REPLACE_ME,  # INTEGER
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # nachhaltungspunktref=row.REPLACE_ME,  # BIGINT
            # plangefaelle=row.REPLACE_ME,  # INTEGER
            # reibungsbeiwert=row.REPLACE_ME,  # INTEGER
            # reliner_art=row.REPLACE_ME,  # VARCHAR(255)
            # reliner_bautechnik=row.REPLACE_ME,  # VARCHAR(255)
            # reliner_material=row.REPLACE_ME,  # VARCHAR(255)
            # reliner_nennweite=row.REPLACE_ME,  # INTEGER
            # ringsteifigkeit=row.REPLACE_ME,  # INTEGER
            # rohrprofilref=row.REPLACE_ME,  # BIGINT
            # t_id=row.REPLACE_ME,  # BIGINT
            # verlauf=row.REPLACE_ME,  # geometry(COMPOUNDCURVE,2056)
            # vonhaltungspunktref=row.REPLACE_ME,  # BIGINT
            # wandrauhigkeit=row.REPLACE_ME,  # NUMERIC(5, 2)
        )
        abwasser_session.add(haltung)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.dryweather_downspout -> ABWASSER.trockenwetterfallrohr, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.dryweather_downspout):

        # structure_part --- dryweather_downspout.fk_dataowner, dryweather_downspout.fk_provider, dryweather_downspout.fk_wastewater_structure, dryweather_downspout.identifier, dryweather_downspout.last_modification, dryweather_downspout.remark, dryweather_downspout.renovation_demand
        # dryweather_downspout --- dryweather_downspout.diameter, dryweather_downspout.obj_id
        # _bwrel_ --- dryweather_downspout.access_aid_kind__BWREL_obj_id, dryweather_downspout.backflow_prevention__BWREL_obj_id, dryweather_downspout.benching_kind__BWREL_obj_id, dryweather_downspout.dryweather_flume_material__BWREL_obj_id, dryweather_downspout.electric_equipment__BWREL_obj_id, dryweather_downspout.electromechanical_equipment__BWREL_obj_id, dryweather_downspout.solids_retention__BWREL_obj_id, dryweather_downspout.tank_cleaning__BWREL_obj_id, dryweather_downspout.tank_emptying__BWREL_obj_id
        # _rel_ --- dryweather_downspout.fk_dataowner__REL, dryweather_downspout.fk_provider__REL, dryweather_downspout.fk_wastewater_structure__REL, dryweather_downspout.renovation_demand__REL

        trockenwetterfallrohr = ABWASSER.trockenwetterfallrohr(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- bauwerksteil ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # instandstellung=row.REPLACE_ME,  # VARCHAR(255)

            # --- trockenwetterfallrohr ---
            # durchmesser=row.REPLACE_ME,  # INTEGER
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(trockenwetterfallrohr)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.access_aid -> ABWASSER.einstiegshilfe, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.access_aid):

        # structure_part --- access_aid.fk_dataowner, access_aid.fk_provider, access_aid.fk_wastewater_structure, access_aid.identifier, access_aid.last_modification, access_aid.remark, access_aid.renovation_demand
        # access_aid --- access_aid.kind, access_aid.obj_id
        # _bwrel_ --- access_aid.access_aid_kind__BWREL_obj_id, access_aid.backflow_prevention__BWREL_obj_id, access_aid.benching_kind__BWREL_obj_id, access_aid.dryweather_flume_material__BWREL_obj_id, access_aid.electric_equipment__BWREL_obj_id, access_aid.electromechanical_equipment__BWREL_obj_id, access_aid.solids_retention__BWREL_obj_id, access_aid.tank_cleaning__BWREL_obj_id, access_aid.tank_emptying__BWREL_obj_id
        # _rel_ --- access_aid.fk_dataowner__REL, access_aid.fk_provider__REL, access_aid.fk_wastewater_structure__REL, access_aid.kind__REL, access_aid.renovation_demand__REL

        einstiegshilfe = ABWASSER.einstiegshilfe(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- bauwerksteil ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # instandstellung=row.REPLACE_ME,  # VARCHAR(255)

            # --- einstiegshilfe ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(einstiegshilfe)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.dryweather_flume -> ABWASSER.trockenwetterrinne, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.dryweather_flume):

        # structure_part --- dryweather_flume.fk_dataowner, dryweather_flume.fk_provider, dryweather_flume.fk_wastewater_structure, dryweather_flume.identifier, dryweather_flume.last_modification, dryweather_flume.remark, dryweather_flume.renovation_demand
        # dryweather_flume --- dryweather_flume.material, dryweather_flume.obj_id
        # _bwrel_ --- dryweather_flume.access_aid_kind__BWREL_obj_id, dryweather_flume.backflow_prevention__BWREL_obj_id, dryweather_flume.benching_kind__BWREL_obj_id, dryweather_flume.dryweather_flume_material__BWREL_obj_id, dryweather_flume.electric_equipment__BWREL_obj_id, dryweather_flume.electromechanical_equipment__BWREL_obj_id, dryweather_flume.solids_retention__BWREL_obj_id, dryweather_flume.tank_cleaning__BWREL_obj_id, dryweather_flume.tank_emptying__BWREL_obj_id
        # _rel_ --- dryweather_flume.fk_dataowner__REL, dryweather_flume.fk_provider__REL, dryweather_flume.fk_wastewater_structure__REL, dryweather_flume.material__REL, dryweather_flume.renovation_demand__REL

        trockenwetterrinne = ABWASSER.trockenwetterrinne(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- bauwerksteil ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # instandstellung=row.REPLACE_ME,  # VARCHAR(255)

            # --- trockenwetterrinne ---
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(trockenwetterrinne)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.cover -> ABWASSER.deckel, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.cover):

        # structure_part --- cover.fk_dataowner, cover.fk_provider, cover.fk_wastewater_structure, cover.identifier, cover.last_modification, cover.remark, cover.renovation_demand
        # cover --- cover.brand, cover.cover_shape, cover.diameter, cover.fastening, cover.level, cover.material, cover.obj_id, cover.positional_accuracy, cover.situation_geometry, cover.sludge_bucket, cover.venting
        # _bwrel_ --- cover.access_aid_kind__BWREL_obj_id, cover.backflow_prevention__BWREL_obj_id, cover.benching_kind__BWREL_obj_id, cover.dryweather_flume_material__BWREL_obj_id, cover.electric_equipment__BWREL_obj_id, cover.electromechanical_equipment__BWREL_obj_id, cover.solids_retention__BWREL_obj_id, cover.tank_cleaning__BWREL_obj_id, cover.tank_emptying__BWREL_obj_id, cover.wastewater_structure__BWREL_fk_main_cover
        # _rel_ --- cover.cover_shape__REL, cover.fastening__REL, cover.fk_dataowner__REL, cover.fk_provider__REL, cover.fk_wastewater_structure__REL, cover.material__REL, cover.positional_accuracy__REL, cover.renovation_demand__REL, cover.sludge_bucket__REL, cover.venting__REL

        deckel = ABWASSER.deckel(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- bauwerksteil ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # instandstellung=row.REPLACE_ME,  # VARCHAR(255)

            # --- deckel ---
            # deckelform=row.REPLACE_ME,  # VARCHAR(255)
            # durchmesser=row.REPLACE_ME,  # INTEGER
            # entlueftung=row.REPLACE_ME,  # VARCHAR(255)
            # fabrikat=row.REPLACE_ME,  # VARCHAR(50)
            # kote=row.REPLACE_ME,  # NUMERIC(7, 3)
            # lage=row.REPLACE_ME,  # geometry(POINT,2056)
            # lagegenauigkeit=row.REPLACE_ME,  # VARCHAR(255)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # schlammeimer=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
            # verschluss=row.REPLACE_ME,  # VARCHAR(255)
        )
        abwasser_session.add(deckel)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.benching -> ABWASSER.bankett, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.benching):

        # structure_part --- benching.fk_dataowner, benching.fk_provider, benching.fk_wastewater_structure, benching.identifier, benching.last_modification, benching.remark, benching.renovation_demand
        # benching --- benching.kind, benching.obj_id
        # _bwrel_ --- benching.access_aid_kind__BWREL_obj_id, benching.backflow_prevention__BWREL_obj_id, benching.benching_kind__BWREL_obj_id, benching.dryweather_flume_material__BWREL_obj_id, benching.electric_equipment__BWREL_obj_id, benching.electromechanical_equipment__BWREL_obj_id, benching.solids_retention__BWREL_obj_id, benching.tank_cleaning__BWREL_obj_id, benching.tank_emptying__BWREL_obj_id
        # _rel_ --- benching.fk_dataowner__REL, benching.fk_provider__REL, benching.fk_wastewater_structure__REL, benching.kind__REL, benching.renovation_demand__REL

        bankett = ABWASSER.bankett(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- bauwerksteil ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # instandstellung=row.REPLACE_ME,  # VARCHAR(255)

            # --- bankett ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(bankett)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.examination -> ABWASSER.untersuchung, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.examination):

        # maintenance_event --- examination.active_zone, examination.base_data, examination.cost, examination.data_details, examination.duration, examination.fk_dataowner, examination.fk_operating_company, examination.fk_provider, examination.identifier, examination.kind, examination.last_modification, examination.operator, examination.reason, examination.remark, examination.result, examination.status, examination.time_point
        # examination --- examination.equipment, examination.fk_reach_point, examination.from_point_identifier, examination.inspected_length, examination.obj_id, examination.recording_type, examination.to_point_identifier, examination.vehicle, examination.videonumber, examination.weather
        # _bwrel_ --- examination.damage__BWREL_fk_examination, examination.re_maintenance_event_wastewater_structure__BWREL_fk_maintenance_event
        # _rel_ --- examination.fk_dataowner__REL, examination.fk_operating_company__REL, examination.fk_provider__REL, examination.fk_reach_point__REL, examination.kind__REL, examination.recording_type__REL, examination.status__REL, examination.weather__REL

        untersuchung = ABWASSER.untersuchung(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- erhaltungsereignis ---
            # abwasserbauwerkref=row.REPLACE_ME,  # BIGINT
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # ausfuehrende_firmaref=row.REPLACE_ME,  # BIGINT
            # ausfuehrender=row.REPLACE_ME,  # VARCHAR(50)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # datengrundlage=row.REPLACE_ME,  # VARCHAR(50)
            # dauer=row.REPLACE_ME,  # INTEGER
            # detaildaten=row.REPLACE_ME,  # VARCHAR(50)
            # ergebnis=row.REPLACE_ME,  # VARCHAR(50)
            # grund=row.REPLACE_ME,  # VARCHAR(50)
            # kosten=row.REPLACE_ME,  # NUMERIC(10, 2)
            # zeitpunkt=row.REPLACE_ME,  # DATE

            # --- untersuchung ---
            # bispunktbezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # erfassungsart=row.REPLACE_ME,  # VARCHAR(255)
            # fahrzeug=row.REPLACE_ME,  # VARCHAR(50)
            # geraet=row.REPLACE_ME,  # VARCHAR(50)
            # haltungspunktref=row.REPLACE_ME,  # BIGINT
            # inspizierte_laenge=row.REPLACE_ME,  # NUMERIC(7, 2)
            # t_id=row.REPLACE_ME,  # BIGINT
            # videonummer=row.REPLACE_ME,  # VARCHAR(20)
            # vonpunktbezeichnung=row.REPLACE_ME,  # VARCHAR(20)
            # witterung=row.REPLACE_ME,  # VARCHAR(255)
        )
        abwasser_session.add(untersuchung)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.damage_manhole -> ABWASSER.normschachtschaden, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.damage_manhole):

        # damage --- damage_manhole.comments, damage_manhole.connection, damage_manhole.damage_begin, damage_manhole.damage_end, damage_manhole.damage_reach, damage_manhole.distance, damage_manhole.fk_dataowner, damage_manhole.fk_examination, damage_manhole.fk_provider, damage_manhole.last_modification, damage_manhole.quantification1, damage_manhole.quantification2, damage_manhole.single_damage_class, damage_manhole.video_counter, damage_manhole.view_parameters
        # damage_manhole --- damage_manhole.manhole_damage_code, damage_manhole.manhole_shaft_area, damage_manhole.obj_id
        # _bwrel_ --- damage_manhole.damage_channel_channel_damage_code__BWREL_obj_id
        # _rel_ --- damage_manhole.connection__REL, damage_manhole.fk_dataowner__REL, damage_manhole.fk_examination__REL, damage_manhole.fk_provider__REL, damage_manhole.manhole_damage_code__REL, damage_manhole.manhole_shaft_area__REL, damage_manhole.single_damage_class__REL

        normschachtschaden = ABWASSER.normschachtschaden(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- schaden ---
            # anmerkung=row.REPLACE_ME,  # VARCHAR(100)
            # ansichtsparameter=row.REPLACE_ME,  # VARCHAR(200)
            # einzelschadenklasse=row.REPLACE_ME,  # VARCHAR(255)
            # streckenschaden=row.REPLACE_ME,  # VARCHAR(3)
            # untersuchungref=row.REPLACE_ME,  # BIGINT
            # verbindung=row.REPLACE_ME,  # VARCHAR(255)
            # videozaehlerstand=row.REPLACE_ME,  # VARCHAR(255)

            # --- normschachtschaden ---
            # distanz=row.REPLACE_ME,  # NUMERIC(7, 2)
            # quantifizierung1=row.REPLACE_ME,  # VARCHAR(20)
            # quantifizierung2=row.REPLACE_ME,  # VARCHAR(20)
            # schachtbereich=row.REPLACE_ME,  # VARCHAR(255)
            # schachtschadencode=row.REPLACE_ME,  # VARCHAR(255)
            # schadenlageanfang=row.REPLACE_ME,  # INTEGER
            # schadenlageende=row.REPLACE_ME,  # INTEGER
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(normschachtschaden)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.damage_channel -> ABWASSER.kanalschaden, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.damage_channel):

        # damage --- damage_channel.comments, damage_channel.connection, damage_channel.damage_begin, damage_channel.damage_end, damage_channel.damage_reach, damage_channel.distance, damage_channel.fk_dataowner, damage_channel.fk_examination, damage_channel.fk_provider, damage_channel.last_modification, damage_channel.quantification1, damage_channel.quantification2, damage_channel.single_damage_class, damage_channel.video_counter, damage_channel.view_parameters
        # damage_channel --- damage_channel.channel_damage_code, damage_channel.obj_id
        # _bwrel_ --- damage_channel.damage_channel_channel_damage_code__BWREL_obj_id
        # _rel_ --- damage_channel.channel_damage_code__REL, damage_channel.connection__REL, damage_channel.fk_dataowner__REL, damage_channel.fk_examination__REL, damage_channel.fk_provider__REL, damage_channel.single_damage_class__REL

        kanalschaden = ABWASSER.kanalschaden(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- schaden ---
            # anmerkung=row.REPLACE_ME,  # VARCHAR(100)
            # ansichtsparameter=row.REPLACE_ME,  # VARCHAR(200)
            # einzelschadenklasse=row.REPLACE_ME,  # VARCHAR(255)
            # streckenschaden=row.REPLACE_ME,  # VARCHAR(3)
            # untersuchungref=row.REPLACE_ME,  # BIGINT
            # verbindung=row.REPLACE_ME,  # VARCHAR(255)
            # videozaehlerstand=row.REPLACE_ME,  # VARCHAR(255)

            # --- kanalschaden ---
            # distanz=row.REPLACE_ME,  # NUMERIC(7, 2)
            # kanalschadencode=row.REPLACE_ME,  # VARCHAR(255)
            # quantifizierung1=row.REPLACE_ME,  # INTEGER
            # quantifizierung2=row.REPLACE_ME,  # INTEGER
            # schadenlageanfang=row.REPLACE_ME,  # INTEGER
            # schadenlageende=row.REPLACE_ME,  # INTEGER
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(kanalschaden)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.data_media -> ABWASSER.datentraeger, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.data_media):

        # data_media --- data_media.fk_dataowner, data_media.fk_provider, data_media.identifier, data_media.kind, data_media.last_modification, data_media.location, data_media.obj_id, data_media.path, data_media.remark
        # _rel_ --- data_media.fk_dataowner__REL, data_media.fk_provider__REL, data_media.kind__REL

        datentraeger = ABWASSER.datentraeger(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- datentraeger ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(60)
            # pfad=row.REPLACE_ME,  # VARCHAR(100)
            # standort=row.REPLACE_ME,  # VARCHAR(50)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(datentraeger)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    print("Exporting QGEP.file -> ABWASSER.datei, ABWASSER.metaattribute")
    for row in qgep_session.query(QGEP.file):

        # file --- file.class, file.fk_data_media, file.fk_dataowner, file.fk_provider, file.identifier, file.kind, file.last_modification, file.obj_id, file.object, file.path_relative, file.remark
        # _rel_ --- file.class__REL, file.fk_dataowner__REL, file.fk_provider__REL, file.kind__REL

        datei = ABWASSER.datei(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- datei ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bezeichnung=row.REPLACE_ME,  # VARCHAR(60)
            # datentraegerref=row.REPLACE_ME,  # BIGINT
            # klasse=row.REPLACE_ME,  # VARCHAR(255)
            # objekt=row.REPLACE_ME,  # VARCHAR(16)
            # relativpfad=row.REPLACE_ME,  # VARCHAR(200)
            # t_id=row.REPLACE_ME,  # BIGINT
        )
        abwasser_session.add(datei)
        create_metaattributes(row, session)
        print(".", end="")
    print("done")

    abwasser_session.commit()

    qgep_session.close()
    abwasser_session.close()
