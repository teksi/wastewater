import json

from geoalchemy2.functions import ST_Force2D, ST_GeomFromGeoJSON
from sqlalchemy import or_
from sqlalchemy.orm import Session

from .. import utils
from ..utils.various import logger
from .model_abwasser import get_abwasser_model
from .model_tww_od import get_tww_od_model


class InterlisExporterToIntermediateSchema:
    def __init__(self, selection=None, labels_file=None):
        """
        Export data from the TWW model into the ili2pg model.

        Args:
            selection:      if provided, limits the export to networkelements that are provided in the selection
        """

        # Filtering
        self.filtered = selection is not None
        self.subset_ids = selection if selection is not None else []

        self.labels_file = labels_file

        self.TWW = get_tww_od_model()
        self.ABWASSER = get_abwasser_model()

        # Logging disabled (very slow)
        self.tww_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.abwasser_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.tid_maker = utils.ili2db.TidMaker(id_attribute="obj_id")

        self.t_ili2db_basket_administration = None

    def tww_export(self):
        try:
            self._tww_export()
        except Exception as exception:
            self.close_sessions()
            raise exception

    def _tww_export(self):
        # Create export baskets
        self.create_baskets()

        # ADAPTED FROM 052a_sia405_abwasser_2015_2_d_interlisexport2.sql
        logger.info("Exporting TWW.organisation -> ABWASSER.organisation, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.organisation)
        for row in query:
            organisation = self.ABWASSER.organisation(
                # FIELDS TO MAP TO ABWASSER.organisation
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "organisation"),
                t_basket=self.t_ili2db_basket_administration.t_id,
                # --- organisation ---
                auid=row.uid,
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                organisationstyp=self.get_vl(row.organisation_type__REL),
                astatus=self.get_vl(row.status__REL),
            )

            self.create_metaattributes(row, organisation)
            self.abwasser_session.add(organisation)

            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.channel -> ABWASSER.kanal, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.channel)
        if self.filtered:
            query = query.join(self.TWW.wastewater_networkelement).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN self.TWW.channel

            # --- wastewater_structure ---
            # _bottom_label, _cover_label, _depth, _function_hierarchic, _input_label, _label, _output_label, _usage_current, accessibility, contract_section, detail_geometry_geometry, financing, fk_dataowner, fk_main_cover, fk_main_wastewater_node, fk_operator, fk_owner, fk_provider, gross_costs, identifier, inspection_interval, last_modification, location_name, records, remark, renovation_necessity, replacement_value, rv_base_year, rv_construction_type, status, structure_condition, subsidies, year_of_construction, year_of_replacement

            # --- _bwrel_ ---
            # measuring_point__BWREL_fk_wastewater_structure, mechanical_pretreatment__BWREL_fk_wastewater_structure, re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, structure_part__BWREL_fk_wastewater_structure, txt_symbol__BWREL_fk_wastewater_structure, txt_text__BWREL_fk_wastewater_structure, wastewater_networkelement__BWREL_fk_wastewater_structure, wastewater_structure_symbol__BWREL_fk_wastewater_structure, wastewater_structure_text__BWREL_fk_wastewater_structure, wwtp_structure_kind__BWREL_obj_id

            # --- _rel_ ---
            # accessibility__REL, bedding_encasement__REL, connection_type__REL, financing__REL, fk_dataowner__REL, fk_main_cover__REL, fk_main_wastewater_node__REL, fk_operator__REL, fk_owner__REL, fk_provider__REL, function_hierarchic__REL, function_hydraulic__REL, renovation_necessity__REL, rv_construction_type__REL, status__REL, structure_condition__REL, usage_current__REL, usage_planned__REL

            kanal = self.ABWASSER.kanal(
                # FIELDS TO MAP TO ABWASSER.kanal
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "kanal"),
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row),
                # --- kanal ---
                bettung_umhuellung=self.get_vl(row.bedding_encasement__REL),
                funktionhierarchisch=self.get_vl(row.function_hierarchic__REL),
                funktionhydraulisch=self.get_vl(row.function_hydraulic__REL),
                nutzungsart_geplant=self.get_vl(row.usage_planned__REL),
                nutzungsart_ist=self.get_vl(row.usage_current__REL),
                rohrlaenge=row.pipe_length,
                spuelintervall=row.jetting_interval,
                verbindungsart=self.get_vl(row.connection_type__REL),
            )
            self.abwasser_session.add(kanal)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.manhole -> ABWASSER.normschacht, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.manhole)
        if self.filtered:
            query = query.join(self.TWW.wastewater_networkelement).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            normschacht = self.ABWASSER.normschacht(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "normschacht"),
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row),
                # --- normschacht ---
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                funktion=self.get_vl(row.function__REL),
                material=self.get_vl(row.material__REL),
                oberflaechenzulauf=self.get_vl(row.surface_inflow__REL),
            )
            self.abwasser_session.add(normschacht)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.discharge_point -> ABWASSER.einleitstelle, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.discharge_point)
        if self.filtered:
            query = query.join(self.TWW.wastewater_networkelement).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            einleitstelle = self.ABWASSER.einleitstelle(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "einleitstelle"),
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row),
                # --- einleitstelle ---
                hochwasserkote=row.highwater_level,
                relevanz=self.get_vl(row.relevance__REL),
                terrainkote=row.terrain_level,
                wasserspiegel_hydraulik=row.waterlevel_hydraulic,
            )
            self.abwasser_session.add(einleitstelle)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.special_structure -> ABWASSER.spezialbauwerk, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.special_structure)
        if self.filtered:
            query = query.join(self.TWW.wastewater_networkelement).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.special_structure

            # --- wastewater_structure ---
            # _bottom_label, _cover_label, _depth, _function_hierarchic, _input_label, _label, _output_label, _usage_current, accessibility, contract_section, detail_geometry_geometry, financing, fk_dataowner, fk_main_cover, fk_main_wastewater_node, fk_operator, fk_owner, fk_provider, gross_costs, identifier, inspection_interval, last_modification, location_name, records, remark, renovation_necessity, replacement_value, rv_base_year, rv_construction_type, status, structure_condition, subsidies, year_of_construction, year_of_replacement

            # --- special_structure ---
            # bypass, emergency_spillway, function, obj_id, stormwater_tank_arrangement, upper_elevation

            # --- _bwrel_ ---
            # measuring_point__BWREL_fk_wastewater_structure, mechanical_pretreatment__BWREL_fk_wastewater_structure, re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, structure_part__BWREL_fk_wastewater_structure, txt_symbol__BWREL_fk_wastewater_structure, txt_text__BWREL_fk_wastewater_structure, wastewater_networkelement__BWREL_fk_wastewater_structure, wastewater_structure_symbol__BWREL_fk_wastewater_structure, wastewater_structure_text__BWREL_fk_wastewater_structure, wwtp_structure_kind__BWREL_obj_id

            # --- _rel_ ---
            # accessibility__REL, bypass__REL, emergency_spillway__REL, financing__REL, fk_dataowner__REL, fk_main_cover__REL, fk_main_wastewater_node__REL, fk_operator__REL, fk_owner__REL, fk_provider__REL, function__REL, renovation_necessity__REL, rv_construction_type__REL, status__REL, stormwater_tank_arrangement__REL, structure_condition__REL
            logger.warning(
                "TWW field special_structure.upper_elevation has no equivalent in the interlis model. It will be ignored."
            )
            spezialbauwerk = self.ABWASSER.spezialbauwerk(
                # FIELDS TO MAP TO ABWASSER.spezialbauwerk
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "spezialbauwerk"),
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row),
                # --- spezialbauwerk ---
                # TODO : WARNING : upper_elevation is not mapped
                bypass=self.get_vl(row.bypass__REL),
                funktion=self.get_vl(row.function__REL),
                notueberlauf=self.get_vl(row.emergency_spillway__REL),
                regenbecken_anordnung=self.get_vl(row.stormwater_tank_arrangement__REL),
            )
            self.abwasser_session.add(spezialbauwerk)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.infiltration_installation -> ABWASSER.versickerungsanlage, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.infiltration_installation)
        if self.filtered:
            query = query.join(self.TWW.wastewater_networkelement).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.infiltration_installation

            # --- wastewater_structure ---
            # _bottom_label, _cover_label, _depth, _function_hierarchic, _input_label, _label, _output_label, _usage_current, accessibility, contract_section, detail_geometry_geometry, financing, fk_dataowner, fk_main_cover, fk_main_wastewater_node, fk_operator, fk_owner, fk_provider, gross_costs, identifier, inspection_interval, last_modification, location_name, records, remark, renovation_necessity, replacement_value, rv_base_year, rv_construction_type, status, structure_condition, subsidies, year_of_construction, year_of_replacement

            # --- infiltration_installation ---
            # absorption_capacity, defects, dimension1, dimension2, distance_to_aquifer, effective_area, emergency_spillway, fk_aquifier, kind, labeling, obj_id, seepage_utilization, upper_elevation, vehicle_access, watertightness

            # --- _bwrel_ ---
            # measuring_point__BWREL_fk_wastewater_structure, mechanical_pretreatment__BWREL_fk_infiltration_installation, mechanical_pretreatment__BWREL_fk_wastewater_structure, re_maintenance_event_wastewater_structure__BWREL_fk_wastewater_structure, retention_body__BWREL_fk_infiltration_installation, structure_part__BWREL_fk_wastewater_structure, txt_symbol__BWREL_fk_wastewater_structure, txt_text__BWREL_fk_wastewater_structure, wastewater_networkelement__BWREL_fk_wastewater_structure, wastewater_structure_symbol__BWREL_fk_wastewater_structure, wastewater_structure_text__BWREL_fk_wastewater_structure, wwtp_structure_kind__BWREL_obj_id

            # --- _rel_ ---
            # accessibility__REL, defects__REL, emergency_spillway__REL, financing__REL, fk_aquifier__REL, fk_dataowner__REL, fk_main_cover__REL, fk_main_wastewater_node__REL, fk_operator__REL, fk_owner__REL, fk_provider__REL, kind__REL, labeling__REL, renovation_necessity__REL, rv_construction_type__REL, seepage_utilization__REL, status__REL, structure_condition__REL, vehicle_access__REL, watertightness__REL

            logger.warning(
                "TWW field infiltration_installation.upper_elevation has no equivalent in the interlis model. It will be ignored."
            )
            versickerungsanlage = self.ABWASSER.versickerungsanlage(
                # FIELDS TO MAP TO ABWASSER.versickerungsanlage
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "versickerungsanlage"),
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row),
                # --- versickerungsanlage ---
                # TODO : NOT MAPPED : upper_elevation
                art=self.get_vl(row.kind__REL),
                beschriftung=self.get_vl(row.labeling__REL),
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                gwdistanz=row.distance_to_aquifer,
                maengel=self.get_vl(row.defects__REL),
                notueberlauf=self.get_vl(row.emergency_spillway__REL),
                saugwagen=self.get_vl(row.vehicle_access__REL),
                schluckvermoegen=row.absorption_capacity,
                versickerungswasser=self.get_vl(row.seepage_utilization__REL),
                wasserdichtheit=self.get_vl(row.watertightness__REL),
                wirksameflaeche=row.effective_area,
            )
            self.abwasser_session.add(versickerungsanlage)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.pipe_profile -> ABWASSER.rohrprofil, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.pipe_profile)
        if self.filtered:
            query = query.join(self.TWW.reach).filter(
                self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.pipe_profile

            # --- pipe_profile ---
            # fk_dataowner, fk_provider, height_width_ratio, identifier, last_modification, obj_id, profile_type, remark

            # --- _bwrel_ ---
            # profile_geometry__BWREL_fk_pipe_profile, reach__BWREL_fk_pipe_profile

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, profile_type__REL

            rohrprofil = self.ABWASSER.rohrprofil(
                # FIELDS TO MAP TO ABWASSER.rohrprofil
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "rohrprofil"),
                # --- rohrprofil ---
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                hoehenbreitenverhaeltnis=row.height_width_ratio,
                profiltyp=self.get_vl(row.profile_type__REL),
            )
            self.abwasser_session.add(rohrprofil)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.reach_point -> ABWASSER.haltungspunkt, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.reach_point)
        if self.filtered:
            query = query.join(
                self.TWW.reach,
                or_(
                    self.TWW.reach_point.obj_id == self.TWW.reach.fk_reach_point_from,
                    self.TWW.reach_point.obj_id == self.TWW.reach.fk_reach_point_to,
                ),
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.reach_point

            # --- reach_point ---
            # elevation_accuracy, fk_dataowner, fk_provider, fk_wastewater_networkelement, identifier, last_modification, level, obj_id, outlet_shape, position_of_connection, remark, situation_geometry

            # --- _bwrel_ ---
            # examination__BWREL_fk_reach_point, reach__BWREL_fk_reach_point_from, reach__BWREL_fk_reach_point_to

            # --- _rel_ ---
            # elevation_accuracy__REL, fk_dataowner__REL, fk_provider__REL, fk_wastewater_networkelement__REL, outlet_shape__REL

            haltungspunkt = self.ABWASSER.haltungspunkt(
                # FIELDS TO MAP TO ABWASSER.haltungspunkt
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "haltungspunkt"),
                # --- haltungspunkt ---
                abwassernetzelementref=self.get_tid(row.fk_wastewater_networkelement__REL),
                auslaufform=self.get_vl(row.outlet_shape__REL),
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                hoehengenauigkeit=self.get_vl(row.elevation_accuracy__REL),
                kote=row.level,
                lage=ST_Force2D(row.situation_geometry),
                lage_anschluss=row.position_of_connection,
            )
            self.abwasser_session.add(haltungspunkt)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.wastewater_node -> ABWASSER.abwasserknoten, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.wastewater_node)
        if self.filtered:
            query = query.filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.wastewater_node

            # --- wastewater_networkelement ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark

            # --- wastewater_node ---

            # --- _bwrel_ ---
            # catchment_area__BWREL_fk_wastewater_networkelement_rw_current, catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, catchment_area__BWREL_fk_wastewater_networkelement_ww_current, catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, connection_object__BWREL_fk_wastewater_networkelement, hydraulic_char_data__BWREL_fk_wastewater_node, overflow__BWREL_fk_overflow_to, overflow__BWREL_fk_wastewater_node, reach_point__BWREL_fk_wastewater_networkelement, throttle_shut_off_unit__BWREL_fk_wastewater_node, wastewater_structure__BWREL_fk_main_wastewater_node

            # --- _rel_ ---
            # fk_dataowner__REL, fk_hydr_geometry__REL, fk_provider__REL, fk_wastewater_structure__REL

            logger.warning(
                "TWW field wastewater_node.fk_hydr_geometry has no equivalent in the interlis model. It will be ignored."
            )
            abwasserknoten = self.ABWASSER.abwasserknoten(
                # FIELDS TO MAP TO ABWASSER.abwasserknoten
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "abwasserknoten"),
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row),
                # --- abwasserknoten ---
                # TODO : WARNING : fk_hydr_geometry is not mapped
                lage=ST_Force2D(row.situation_geometry),
                rueckstaukote=row.backflow_level,
                sohlenkote=row.bottom_level,
            )
            self.abwasser_session.add(abwasserknoten)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.reach -> ABWASSER.haltung, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.reach)
        if self.filtered:
            query = query.filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.reach

            # --- wastewater_networkelement ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark

            # --- reach ---
            # clear_height, coefficient_of_friction, elevation_determination, fk_pipe_profile, fk_reach_point_from, fk_reach_point_to, horizontal_positioning, inside_coating, length_effective, material, obj_id, progression_geometry, reliner_material, reliner_nominal_size, relining_construction, relining_kind, ring_stiffness, slope_building_plan, wall_roughness

            # --- _bwrel_ ---
            # catchment_area__BWREL_fk_wastewater_networkelement_rw_current, catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, catchment_area__BWREL_fk_wastewater_networkelement_ww_current, catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, connection_object__BWREL_fk_wastewater_networkelement, reach_point__BWREL_fk_wastewater_networkelement, reach_text__BWREL_fk_reach, txt_text__BWREL_fk_reach

            # --- _rel_ ---
            # elevation_determination__REL, fk_dataowner__REL, fk_pipe_profile__REL, fk_provider__REL, fk_reach_point_from__REL, fk_reach_point_to__REL, fk_wastewater_structure__REL, horizontal_positioning__REL, inside_coating__REL, material__REL, reliner_material__REL, relining_construction__REL, relining_kind__REL

            logger.warning(
                "TWW field reach.elevation_determination has no equivalent in the interlis model. It will be ignored."
            )
            haltung = self.ABWASSER.haltung(
                # FIELDS TO MAP TO ABWASSER.haltung
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "haltung"),
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row),
                # --- haltung ---
                # NOT MAPPED : elevation_determination
                innenschutz=self.get_vl(row.inside_coating__REL),
                laengeeffektiv=row.length_effective,
                lagebestimmung=self.get_vl(row.horizontal_positioning__REL),
                lichte_hoehe=row.clear_height,
                material=self.get_vl(row.material__REL),
                nachhaltungspunktref=self.get_tid(row.fk_reach_point_to__REL),
                plangefaelle=row.slope_building_plan,  # TODO : check, does this need conversion ?
                reibungsbeiwert=row.coefficient_of_friction,
                reliner_art=self.get_vl(row.relining_kind__REL),
                reliner_bautechnik=self.get_vl(row.relining_construction__REL),
                reliner_material=self.get_vl(row.reliner_material__REL),
                reliner_nennweite=row.reliner_nominal_size,
                ringsteifigkeit=row.ring_stiffness,
                rohrprofilref=self.get_tid(row.fk_pipe_profile__REL),
                verlauf=ST_Force2D(row.progression_geometry),
                vonhaltungspunktref=self.get_tid(row.fk_reach_point_from__REL),
                wandrauhigkeit=row.wall_roughness,
            )
            self.abwasser_session.add(haltung)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.dryweather_downspout -> ABWASSER.trockenwetterfallrohr, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.dryweather_downspout)
        if self.filtered:
            query = query.join(
                self.TWW.wastewater_structure, self.TWW.wastewater_networkelement
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.dryweather_downspout

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- dryweather_downspout ---
            # diameter, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, renovation_demand__REL

            trockenwetterfallrohr = self.ABWASSER.trockenwetterfallrohr(
                # FIELDS TO MAP TO ABWASSER.trockenwetterfallrohr
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "trockenwetterfallrohr"),
                # --- bauwerksteil ---
                **self.structure_part_common(row),
                # --- trockenwetterfallrohr ---
                durchmesser=row.diameter,
            )
            self.abwasser_session.add(trockenwetterfallrohr)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.access_aid -> ABWASSER.einstiegshilfe, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.access_aid)
        if self.filtered:
            query = query.join(
                self.TWW.wastewater_structure, self.TWW.wastewater_networkelement
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.access_aid

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- access_aid ---
            # kind, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, kind__REL, renovation_demand__REL

            einstiegshilfe = self.ABWASSER.einstiegshilfe(
                # FIELDS TO MAP TO ABWASSER.einstiegshilfe
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "einstiegshilfe"),
                # --- bauwerksteil ---
                **self.structure_part_common(row),
                # --- einstiegshilfe ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(einstiegshilfe)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.dryweather_flume -> ABWASSER.trockenwetterrinne, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.dryweather_flume)
        if self.filtered:
            query = query.join(
                self.TWW.wastewater_structure, self.TWW.wastewater_networkelement
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.dryweather_flume

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- dryweather_flume ---
            # material, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, material__REL, renovation_demand__REL

            trockenwetterrinne = self.ABWASSER.trockenwetterrinne(
                # FIELDS TO MAP TO ABWASSER.trockenwetterrinne
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "trockenwetterrinne"),
                # --- bauwerksteil ---
                **self.structure_part_common(row),
                # --- trockenwetterrinne ---
                material=self.get_vl(row.material__REL),
            )
            self.abwasser_session.add(trockenwetterrinne)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.cover -> ABWASSER.deckel, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.cover)
        if self.filtered:
            query = query.join(
                self.TWW.wastewater_structure, self.TWW.wastewater_networkelement
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.cover

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- cover ---
            # brand, cover_shape, diameter, fastening, level, material, obj_id, positional_accuracy, situation_geometry, sludge_bucket, venting

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id, wastewater_structure__BWREL_fk_main_cover

            # --- _rel_ ---
            # cover_shape__REL, fastening__REL, fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, material__REL, positional_accuracy__REL, renovation_demand__REL, sludge_bucket__REL, venting__REL

            deckel = self.ABWASSER.deckel(
                # FIELDS TO MAP TO ABWASSER.deckel
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "deckel"),
                # --- bauwerksteil ---
                **self.structure_part_common(row),
                # --- deckel ---
                deckelform=self.get_vl(row.cover_shape__REL),
                durchmesser=row.diameter,
                entlueftung=self.get_vl(row.venting__REL),
                fabrikat=row.brand,
                kote=row.level,
                lage=ST_Force2D(row.situation_geometry),
                lagegenauigkeit=self.get_vl(row.positional_accuracy__REL),
                material=self.get_vl(row.material__REL),
                schlammeimer=self.get_vl(row.sludge_bucket__REL),
                verschluss=self.get_vl(row.fastening__REL),
            )
            self.abwasser_session.add(deckel)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.benching -> ABWASSER.bankett, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.benching)
        if self.filtered:
            query = query.join(
                self.TWW.wastewater_structure, self.TWW.wastewater_networkelement
            ).filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
        for row in query:
            # AVAILABLE FIELDS IN TWW.benching

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- benching ---
            # kind, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, kind__REL, renovation_demand__REL

            bankett = self.ABWASSER.bankett(
                # FIELDS TO MAP TO ABWASSER.bankett
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "bankett"),
                # --- bauwerksteil ---
                **self.structure_part_common(row),
                # --- bankett ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(bankett)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.examination -> ABWASSER.untersuchung, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.examination)
        if self.filtered:
            query = (
                query.join(self.TWW.re_maintenance_event_wastewater_structure)
                .join(self.TWW.wastewater_structure)
                .join(self.TWW.wastewater_networkelement)
                .filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
            )

        for row in query:
            # AVAILABLE FIELDS IN TWW.examination

            # --- maintenance_event ---
            # --- examination ---
            # equipment, fk_reach_point, from_point_identifier, inspected_length, obj_id, recording_type, to_point_identifier, vehicle, videonumber, weather

            # --- _bwrel_ ---
            # damage__BWREL_fk_examination, re_maintenance_event_wastewater_structure__BWREL_fk_maintenance_event

            # --- _rel_ ---
            # fk_dataowner__REL, fk_operating_company__REL, fk_provider__REL, fk_reach_point__REL, kind__REL, recording_type__REL, status__REL, weather__REL
            logger.warning(
                "TWW field maintenance_event.active_zone has no equivalent in the interlis model. It will be ignored."
            )

            untersuchung = self.ABWASSER.untersuchung(
                # FIELDS TO MAP TO ABWASSER.untersuchung
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "untersuchung"),
                # --- erhaltungsereignis ---
                # abwasserbauwerkref=row.REPLACE_ME,  # TODO : convert this to M2N relation through re_maintenance_event_wastewater_structure
                art=self.get_vl(row.kind__REL),
                astatus=self.get_vl(row.status__REL),
                ausfuehrende_firmaref=self.get_tid(row.fk_operating_company__REL),
                ausfuehrender=row.operator,
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                datengrundlage=row.base_data,
                dauer=row.duration,
                detaildaten=row.data_details,
                ergebnis=row.result,
                grund=row.reason,
                kosten=row.cost,
                zeitpunkt=row.time_point,
                # --- untersuchung ---
                bispunktbezeichnung=row.to_point_identifier,
                erfassungsart=self.get_vl(row.recording_type__REL),
                fahrzeug=row.vehicle,
                geraet=row.equipment,
                haltungspunktref=self.get_tid(row.fk_reach_point__REL),
                inspizierte_laenge=row.inspected_length,
                videonummer=row.videonumber,
                vonpunktbezeichnung=row.from_point_identifier,
                witterung=self.get_vl(row.weather__REL),
            )
            self.abwasser_session.add(untersuchung)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.damage_manhole -> ABWASSER.normschachtschaden, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.damage_manhole)
        if self.filtered:
            query = (
                query.join(self.TWW.examination)
                .join(self.TWW.re_maintenance_event_wastewater_structure)
                .join(self.TWW.wastewater_structure)
                .join(self.TWW.wastewater_networkelement)
                .filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.damage_manhole

            # --- damage ---

            # --- damage_manhole ---
            # manhole_damage_code, manhole_shaft_area, obj_id

            # --- _bwrel_ ---
            # damage_channel_channel_damage_code__BWREL_obj_id

            # --- _rel_ ---
            # connection__REL, fk_dataowner__REL, fk_examination__REL, fk_provider__REL, manhole_damage_code__REL, manhole_shaft_area__REL, single_damage_class__REL

            normschachtschaden = self.ABWASSER.normschachtschaden(
                # FIELDS TO MAP TO ABWASSER.normschachtschaden
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "normschachtschaden"),
                # --- schaden ---
                anmerkung=row.comments,
                ansichtsparameter=row.view_parameters,
                einzelschadenklasse=self.get_vl(row.single_damage_class__REL),
                streckenschaden=row.damage_reach,
                untersuchungref=self.get_tid(row.fk_examination__REL),
                verbindung=self.get_vl(row.connection__REL),
                videozaehlerstand=row.video_counter,
                # --- normschachtschaden ---
                distanz=row.distance,
                quantifizierung1=row.quantification1,
                quantifizierung2=row.quantification2,
                schachtbereich=self.get_vl(row.manhole_shaft_area__REL),
                schachtschadencode=self.get_vl(row.manhole_damage_code__REL),
                schadenlageanfang=row.damage_begin,
                schadenlageende=row.damage_end,
            )
            self.abwasser_session.add(normschachtschaden)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info(
            "Exporting TWW.damage_channel -> ABWASSER.kanalschaden, ABWASSER.metaattribute"
        )
        query = self.tww_session.query(self.TWW.damage_channel)
        if self.filtered:
            query = (
                query.join(self.TWW.examination)
                .join(self.TWW.re_maintenance_event_wastewater_structure)
                .join(self.TWW.wastewater_structure)
                .join(self.TWW.wastewater_networkelement)
                .filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.damage_channel

            # --- damage ---
            # comments, connection, damage_begin, damage_end, damage_reach, distance, fk_dataowner, fk_examination, fk_provider, last_modification, quantification1, quantification2, single_damage_class, video_counter, view_parameters

            # --- damage_channel ---
            # , obj_id

            # --- _bwrel_ ---
            # damage_channel_channel_damage_code__BWREL_obj_id

            # --- _rel_ ---
            # channel_damage_code__REL, connection__REL, fk_dataowner__REL, fk_examination__REL, fk_provider__REL, single_damage_class__REL

            kanalschaden = self.ABWASSER.kanalschaden(
                # FIELDS TO MAP TO ABWASSER.kanalschaden
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "kanalschaden"),
                # --- schaden ---
                anmerkung=row.comments,
                ansichtsparameter=row.view_parameters,
                einzelschadenklasse=self.get_vl(row.single_damage_class__REL),
                streckenschaden=row.damage_reach,
                untersuchungref=self.get_tid(row.fk_examination__REL),
                verbindung=self.get_vl(row.connection__REL),
                videozaehlerstand=row.video_counter,
                # --- kanalschaden ---
                distanz=row.distance,
                kanalschadencode=self.get_vl(row.channel_damage_code__REL),
                quantifizierung1=row.quantification1,
                quantifizierung2=row.quantification2,
                schadenlageanfang=row.damage_begin,
                schadenlageende=row.damage_end,
            )
            self.abwasser_session.add(kanalschaden)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.data_media -> ABWASSER.datentraeger, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.data_media)
        for row in query:
            # AVAILABLE FIELDS IN TWW.data_media

            # --- data_media ---
            # fk_dataowner, fk_provider, identifier, kind, last_modification, location, obj_id, path, remark

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, kind__REL

            datentraeger = self.ABWASSER.datentraeger(
                # FIELDS TO MAP TO ABWASSER.datentraeger
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "datentraeger"),
                # --- datentraeger ---
                art=self.get_vl(row.kind__REL),
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                pfad=row.path,
                standort=row.location,
            )
            self.abwasser_session.add(datentraeger)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        logger.info("Exporting TWW.file -> ABWASSER.datei, ABWASSER.metaattribute")
        query = self.tww_session.query(self.TWW.file)
        if self.filtered:
            query = (
                query.outerjoin(self.TWW.damage, self.TWW.file.object == self.TWW.damage.obj_id)
                .join(
                    self.TWW.examination,
                    or_(
                        self.TWW.file.object == self.TWW.damage.obj_id,
                        self.TWW.file.object == self.TWW.examination.obj_id,
                    ),
                )
                .join(self.TWW.re_maintenance_event_wastewater_structure)
                .join(self.TWW.wastewater_structure)
                .join(self.TWW.wastewater_networkelement)
                .filter(self.TWW.wastewater_networkelement.obj_id.in_(self.subset_ids))
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.file

            # --- file ---
            # class, fk_data_media, fk_dataowner, fk_provider, identifier, kind, last_modification, obj_id, object, path_relative, remark

            # --- _rel_ ---
            # class__REL, fk_dataowner__REL, fk_provider__REL, kind__REL

            datei = self.ABWASSER.datei(
                # FIELDS TO MAP TO ABWASSER.datei
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.base_common(row, "datei"),
                # --- datei ---
                art=self.get_vl(row.kind__REL) or "andere",
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                datentraegerref=self.get_tid(row.fk_data_media__REL),
                klasse=self.get_vl(row.class__REL),
                objekt=self.null_to_emptystr(row.object),
                relativpfad=row.path_relative,
            )
            self.abwasser_session.add(datei)
            self.create_metaattributes(row)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

        # Labels
        # Note: these are extracted from the optional labels file (not exported from the TWW database)
        if self.labels_file:
            logger.info(f"Exporting label positions from {self.labels_file}")

            # Get t_id by obj_name to create the reference on the labels below
            tid_for_obj_id = {
                "haltung": {},
                "abwasserbauwerk": {},
            }
            for row in self.abwasser_session.query(self.ABWASSER.haltung):
                tid_for_obj_id["haltung"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.ABWASSER.abwasserbauwerk):
                tid_for_obj_id["abwasserbauwerk"][row.obj_id] = row.t_id

            with open(self.labels_file) as labels_file_handle:
                labels = json.load(labels_file_handle)

            geojson_crs_def = labels["crs"]

            for label in labels["features"]:
                layer_name = label["properties"]["Layer"]
                obj_id = label["properties"]["tww_obj_id"]

                if layer_name == "vw_tww_reach":
                    if obj_id not in tid_for_obj_id["haltung"]:
                        logger.warning(
                            f"Label for haltung `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.ABWASSER.haltung_text(
                        **self.textpos_common(label, "haltung_text", geojson_crs_def),
                        haltungref=tid_for_obj_id["haltung"][obj_id],
                    )

                elif layer_name == "vw_tww_wastewater_structure":
                    if obj_id not in tid_for_obj_id["abwasserbauwerk"]:
                        logger.warning(
                            f"Label for abwasserbauwerk `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.ABWASSER.abwasserbauwerk_text(
                        **self.textpos_common(label, "abwasserbauwerk_text", geojson_crs_def),
                        abwasserbauwerkref=tid_for_obj_id["abwasserbauwerk"][obj_id],
                    )

                else:
                    logger.warning(
                        f"Unknown layer for label `{layer_name}`. Label will be ignored",
                    )
                    continue

                self.abwasser_session.add(ili_label)
                print(".", end="")
            logger.info("done")
            self.abwasser_session.flush()

        self.abwasser_session.commit()

        self.close_sessions()

    def get_tid(self, relation):
        """
        Makes a tid for a relation
        """
        if relation is None:
            return None
        return self.tid_maker.tid_for_row(relation)

    def get_vl(self, relation):
        """
        Gets a literal value from a value list relation
        """
        if relation is None:
            return None
        return relation.value_de

    def null_to_emptystr(self, val):
        """
        Converts nulls to blank strings and raises a warning
        """
        if val is None:
            logger.warning(
                "A mandatory value was null. It will be cast to a blank string, and probably cause validation errors",
            )
            val = ""
        return val

    def emptystr_to_null(self, val):
        """
        Converts blank strings to nulls and raises a warning

        This is needed as is seems ili2pg 4.4.6 crashes with emptystrings under certain circumstances (see https://github.com/TWW/tww2ili/issues/33)
        """
        if val == "":
            logger.warning(
                "An empty string was converted to NULL, to workaround ili2pg issue. This should have no impact on output.",
            )
            val = None
        return val

    def truncate(self, val, max_length):
        """
        Raises a warning if values gets truncated
        """
        if val is None:
            return None
        if len(val) > max_length:
            logger.warning(f"Value '{val}' exceeds expected length ({max_length})", stacklevel=2)
        return val[0:max_length]

    def modulo_angle(self, val):
        """
        Returns an angle between 0 and 359.9 (for Orientierung in Base_d-20181005.ili)
        """
        if val is None:
            return None
        val = val % 360.0
        if val > 359.9:
            val = 0
        return val

    def create_metaattributes(self, row, abwasser_row):
        abwasser_row.datenherr = (
            getattr(row.fk_dataowner__REL, "name", "unknown"),
        )  # TODO : is unknown ok ?
        abwasser_row.datenlieferant = (
            getattr(row.fk_provider__REL, "name", "unknown"),
        )  # TODO : is unknown ok ?
        abwasser_row.letzte_aenderung = (row.last_modification,)
        abwasser_row.sia405_baseclass_metaattribute = (self.get_tid(row),)
        # OD : is this OK ? Don't we need a different t_id from what inserted above in organisation ? if so, consider adding a "for_class" arg to tid_for_row
        abwasser_row.t_id = (self.get_tid(row),)
        abwasser_row.t_seq = (0,)

    def base_common(self, row, type_name):
        """
        Returns common attributes for base
        """
        return {
            "t_ili_tid": row.obj_id,
            "t_type": type_name,
            "t_id": self.get_tid(row),
        }

    def wastewater_structure_common(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        logger.warning(
            "Mapping of wastewater_structure->abwasserbauwerk is not fully implemented."
        )
        return {
            # --- abwasserbauwerk ---
            "akten": row.records,
            "astatus": self.get_vl(row.status__REL),
            "baujahr": row.year_of_construction,
            "baulicherzustand": self.get_vl(row.structure_condition__REL),
            "baulos": row.contract_section,
            "bemerkung": self.truncate(self.emptystr_to_null(row.remark), 80),
            "betreiberref": self.get_tid(row.fk_operator__REL),
            "bezeichnung": self.null_to_emptystr(row.identifier),
            "bruttokosten": row.gross_costs,
            "detailgeometrie": ST_Force2D(row.detail_geometry_geometry),
            "eigentuemerref": self.get_tid(row.fk_owner__REL),
            "ersatzjahr": row.year_of_replacement,
            "finanzierung": self.get_vl(row.financing__REL),
            "inspektionsintervall": row.inspection_interval,
            "sanierungsbedarf": self.get_vl(row.renovation_necessity__REL),
            "standortname": row.location_name,
            "subventionen": row.subsidies,
            "wbw_basisjahr": row.rv_base_year,
            "wbw_bauart": self.get_vl(row.rv_construction_type__REL),
            "wiederbeschaffungswert": row.replacement_value,
            "zugaenglichkeit": self.get_vl(row.accessibility__REL),
        }

    def wastewater_networkelement_common(self, row):
        """
        Returns common attributes for network_element
        """

        return {
            "abwasserbauwerkref": self.get_tid(row.fk_wastewater_structure__REL),
            "bemerkung": self.truncate(self.emptystr_to_null(row.remark), 80),
            "bezeichnung": self.null_to_emptystr(row.identifier),
        }

    def structure_part_common(self, row):
        """
        Returns common attributes for structure_part
        """
        return {
            "abwasserbauwerkref": self.get_tid(row.fk_wastewater_structure__REL),
            "bemerkung": self.truncate(self.emptystr_to_null(row.remark), 80),
            "bezeichnung": self.null_to_emptystr(row.identifier),
            "instandstellung": self.get_vl(row.renovation_demand__REL),
        }

    def textpos_common(self, row, t_type, geojson_crs_def):
        """
        Returns common attributes for textpos
        """
        t_id = self.tid_maker.next_tid()
        return {
            "t_id": t_id,
            "t_type": t_type,
            "t_ili_tid": t_id,
            "t_basket": 1,
            # --- TextPos ---
            "textpos": ST_GeomFromGeoJSON(
                json.dumps(
                    {
                        "type": "Point",
                        "coordinates": row["geometry"]["coordinates"],
                        "crs": geojson_crs_def,
                    }
                )
            ),
            "textori": self.modulo_angle(row["properties"]["LabelRotation"]),
            "texthali": "Left",  # can be Left/Center/Right
            "textvali": "Top",  # can be Top,Cap,Half,Base,Bottom
            # --- SIA405_TextPos ---
            "plantyp": row["properties"]["scale"],
            "textinhalt": row["properties"]["LabelText"],
            "bemerkung": None,
        }

    def create_baskets(self):
        self.t_ili2db_basket_administration = self.ABWASSER.t_ili2db_basket(
            t_id=self.tid_maker.next_tid(),
            topic="SIA405_Base_Abwasser_1_LV95.Administration",
            attachmentkey="teksi_wastewater",
        )
        self.abwasser_session.add(self.t_ili2db_basket_administration)
        self.abwasser_session.flush()

    def close_sessions(self):
        self.tww_session.close()
        self.abwasser_session.close()
