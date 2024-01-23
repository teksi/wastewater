import json

from geoalchemy2.functions import ST_Force2D, ST_GeomFromGeoJSON
from sqlalchemy import or_
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from .. import config, utils
from ..utils.various import logger


class InterlisExporterToIntermediateSchemaError(Exception):
    pass


class InterlisExporterToIntermediateSchema:
    def __init__(
        self,
        model,
        model_classes_interlis,
        model_classes_tww_od,
        model_classes_tww_vl,
        selection=None,
        labels_file=None,
        basket_enabled=False,
        callback_progress_done=None,
    ):
        """
        Export data from the TWW model into the ili2pg model.

        Args:
            selection:      if provided, limits the export to networkelements that are provided in the selection
        """
        self.model = model
        self.callback_progress_done = callback_progress_done

        # Filtering
        self.filtered = selection is not None
        self.subset_ids = selection if selection is not None else []

        self.labels_file = labels_file

        self.basket_enabled = basket_enabled

        self.model_classes_interlis = model_classes_interlis
        self.model_classes_tww_od = model_classes_tww_od
        self.model_classes_tww_vl = model_classes_tww_vl

        self.tww_session = None
        self.abwasser_session = None
        self.tid_maker = utils.ili2db.TidMaker(id_attribute="obj_id")

    def tww_export(self):
        # Logging disabled (very slow)
        self.tww_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.abwasser_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )

        try:
            self._export()
            self.abwasser_session.commit()
            self.close_sessions()
        except Exception as exception:
            self.close_sessions()
            raise exception

    def _export(self):
        # Allow to insert rows with cyclic dependencies at once
        self.abwasser_session.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        if self.basket_enabled:
            self.close_sessions()
            raise InterlisExporterToIntermediateSchemaError(
                "Export with baskets is not implemented (KEK export)"
            )

        self._export_sia405_abwasser()

        if self.model == config.MODEL_NAME_DSS:
            self._export_dss()

        if self.model == config.MODEL_NAME_VSA_KEK:
            self._export_vsa_kek()

        # Labels
        # Note: these are extracted from the optional labels file (not exported from the TWW database)
        if self.labels_file:
            logger.info(f"Exporting label positions from {self.labels_file}")
            self._export_label_positions()

    def _export_sia405_abwasser(self):
        logger.info("Exporting TWW.organisation -> ABWASSER.organisation")
        self._export_organisation()
        self._check_for_stop()

        logger.info("Exporting TWW.channel -> ABWASSER.kanal")
        self._export_channel()
        self._check_for_stop()

        logger.info("Exporting TWW.manhole -> ABWASSER.normschacht")
        self._export_manhole()
        self._check_for_stop()

        logger.info("Exporting TWW.discharge_point -> ABWASSER.einleitstelle")
        self._export_discharge_point()
        self._check_for_stop()

        logger.info("Exporting TWW.special_structure -> ABWASSER.spezialbauwerk")
        self._export_special_structure()
        self._check_for_stop()

        logger.info("Exporting TWW.infiltration_installation -> ABWASSER.versickerungsanlage")
        self._export_infiltration_installation()
        self._check_for_stop()

        logger.info("Exporting TWW.pipe_profile -> ABWASSER.rohrprofil")
        self._export_pipe_profile()
        self._check_for_stop()

        logger.info("Exporting TWW.reach_point -> ABWASSER.haltungspunkt")
        self._export_reach_point()
        self._check_for_stop()

        logger.info("Exporting TWW.wastewater_node -> ABWASSER.abwasserknoten")
        self._export_wastewater_node()
        self._check_for_stop()

        logger.info("Exporting TWW.reach -> ABWASSER.haltung")
        self._export_reach()
        self._check_for_stop()

        logger.info("Exporting TWW.dryweather_downspout -> ABWASSER.trockenwetterfallrohr")
        self._export_dryweather_downspout()
        self._check_for_stop()

        logger.info("Exporting TWW.access_aid -> ABWASSER.einstiegshilfe")
        self._export_access_aid()
        self._check_for_stop()

        logger.info("Exporting TWW.dryweather_flume -> ABWASSER.trockenwetterrinne")
        self._export_dryweather_flume()
        self._check_for_stop()

        logger.info("Exporting TWW.cover -> ABWASSER.deckel")
        self._export_cover()
        self._check_for_stop()

        logger.info("Exporting TWW.benching -> ABWASSER.bankett")
        self._export_benching()
        self._check_for_stop()

    def _export_dss(self):
        logger.info(
            "Exporting TWW.waste_water_treatment_plant -> ABWASSER.abwasserreinigungsanlage"
        )
        self._export_waste_water_treatment_plant()
        self._check_for_stop()

        logger.info("Exporting TWW.wwtp_energy_use -> ABWASSER.araenergienutzung")
        self._export_wwtp_energy_use()
        self._check_for_stop()

        logger.info("Exporting TWW.waste_water_treatment -> ABWASSER.abwasserbehandlung")
        self._export_waste_water_treatment()
        self._check_for_stop()

        logger.info("Exporting TWW.sludge_treatment -> ABWASSER.schlammbehandlung")
        self._export_sludge_treatment()
        self._check_for_stop()

        logger.info("Exporting TWW.wwtp_structure -> ABWASSER.arabauwerk")
        self._export_wwtp_structure()
        self._check_for_stop()

        logger.info("Exporting TWW.control_center -> ABWASSER.steuerungszentrale")
        self._export_control_center()
        self._check_for_stop()

    def _export_vsa_kek(self):
        logger.info("Exporting TWW.examination -> ABWASSER.untersuchung")
        self._export_examination()
        self._check_for_stop()

        logger.info("Exporting TWW.damage_manhole -> ABWASSER.normschachtschaden")
        self._export_damage_manhole()
        self._check_for_stop()

        logger.info("Exporting TWW.damage_channel -> ABWASSER.kanalschaden")
        self._export_damage_channel()
        self._check_for_stop()

        logger.info("Exporting TWW.data_media -> ABWASSER.datentraeger")
        self._export_data_media()
        self._check_for_stop()

        logger.info("Exporting TWW.file -> ABWASSER.datei")
        self._export_file()
        self._check_for_stop()

    def _export_organisation(self):
        query = self.tww_session.query(self.model_classes_tww_od.organisation)
        for row in query:
            organisation = self.model_classes_interlis.organisation(
                # FIELDS TO MAP TO ABWASSER.organisation
                # --- sia405_baseclass ---
                **self.sia_405_base_common(row, "organisation"),
                # --- organisation ---
                auid=row.uid,
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                organisationstyp=self.get_vl(row.organisation_type__REL),
                astatus=self.get_vl(row.status__REL),
            )
            self.abwasser_session.add(organisation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_channel(self):
        query = self.tww_session.query(self.model_classes_tww_od.channel)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            kanal = self.model_classes_interlis.kanal(
                # FIELDS TO MAP TO ABWASSER.kanal
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "kanal"),
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
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_manhole(self):
        query = self.tww_session.query(self.model_classes_tww_od.manhole)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            normschacht = self.model_classes_interlis.normschacht(
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "normschacht"),
                # --- normschacht ---
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                funktion=self.get_vl(row.function__REL),
                material=self.get_vl(row.material__REL),
                oberflaechenzulauf=self.get_vl(row.surface_inflow__REL),
            )
            self.abwasser_session.add(normschacht)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_discharge_point(self):
        query = self.tww_session.query(self.model_classes_tww_od.discharge_point)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            einleitstelle = self.model_classes_interlis.einleitstelle(
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "einleitstelle"),
                # --- einleitstelle ---
                hochwasserkote=row.highwater_level,
                relevanz=self.get_vl(row.relevance__REL),
                terrainkote=row.terrain_level,
                wasserspiegel_hydraulik=row.waterlevel_hydraulic,
            )
            self.abwasser_session.add(einleitstelle)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_special_structure(self):
        query = self.tww_session.query(self.model_classes_tww_od.special_structure)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            logger.warning(
                "TWW field special_structure.upper_elevation has no equivalent in the interlis model. It will be ignored."
            )
            spezialbauwerk = self.model_classes_interlis.spezialbauwerk(
                # FIELDS TO MAP TO ABWASSER.spezialbauwerk
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "spezialbauwerk"),
                # --- spezialbauwerk ---
                # TODO : WARNING : upper_elevation is not mapped
                bypass=self.get_vl(row.bypass__REL),
                funktion=self.get_vl(row.function__REL),
                notueberlauf=self.get_vl(row.emergency_overflow__REL),
                regenbecken_anordnung=self.get_vl(row.stormwater_tank_arrangement__REL),
            )
            self.abwasser_session.add(spezialbauwerk)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infiltration_installation(self):
        query = self.tww_session.query(self.model_classes_tww_od.infiltration_installation)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            logger.warning(
                "TWW field infiltration_installation.upper_elevation has no equivalent in the interlis model. It will be ignored."
            )
            versickerungsanlage = self.model_classes_interlis.versickerungsanlage(
                # FIELDS TO MAP TO ABWASSER.versickerungsanlage
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "versickerungsanlage"),
                # --- versickerungsanlage ---
                # TODO : NOT MAPPED : upper_elevation
                art=self.get_vl(row.kind__REL),
                beschriftung=self.get_vl(row.labeling__REL),
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                gwdistanz=row.distance_to_aquifer,
                maengel=self.get_vl(row.defects__REL),
                notueberlauf=self.get_vl(row.emergency_overflow__REL),
                saugwagen=self.get_vl(row.vehicle_access__REL),
                schluckvermoegen=row.absorption_capacity,
                versickerungswasser=self.get_vl(row.seepage_utilization__REL),
                wasserdichtheit=self.get_vl(row.watertightness__REL),
                wirksameflaeche=row.effective_area,
            )
            self.abwasser_session.add(versickerungsanlage)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_pipe_profile(self):
        query = self.tww_session.query(self.model_classes_tww_od.pipe_profile)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.reach).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.pipe_profile

            # --- pipe_profile ---
            # fk_dataowner, fk_provider, height_width_ratio, identifier, last_modification, obj_id, profile_type, remark

            # --- _bwrel_ ---
            # profile_geometry__BWREL_fk_pipe_profile, reach__BWREL_fk_pipe_profile

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, profile_type__REL

            rohrprofil = self.model_classes_interlis.rohrprofil(
                # FIELDS TO MAP TO ABWASSER.rohrprofil
                # --- vsa_baseclass ---
                **self.vsa_base_common(row, "rohrprofil"),
                # --- rohrprofil ---
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                hoehenbreitenverhaeltnis=row.height_width_ratio,
                profiltyp=self.get_vl(row.profile_type__REL),
            )
            self.abwasser_session.add(rohrprofil)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_reach_point(self):
        query = self.tww_session.query(self.model_classes_tww_od.reach_point)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.reach,
                or_(
                    self.model_classes_tww_od.reach_point.obj_id
                    == self.model_classes_tww_od.reach.fk_reach_point_from,
                    self.model_classes_tww_od.reach_point.obj_id
                    == self.model_classes_tww_od.reach.fk_reach_point_to,
                ),
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.reach_point

            # --- reach_point ---
            # elevation_accuracy, fk_dataowner, fk_provider, fk_wastewater_networkelement, identifier, last_modification, level, obj_id, outlet_shape, position_of_connection, remark, situation_geometry

            # --- _bwrel_ ---
            # examination__BWREL_fk_reach_point, reach__BWREL_fk_reach_point_from, reach__BWREL_fk_reach_point_to

            # --- _rel_ ---
            # elevation_accuracy__REL, fk_dataowner__REL, fk_provider__REL, fk_wastewater_networkelement__REL, outlet_shape__REL

            haltungspunkt = self.model_classes_interlis.haltungspunkt(
                # FIELDS TO MAP TO ABWASSER.haltungspunkt
                # --- vsa_baseclass ---
                **self.vsa_base_common(row, "haltungspunkt"),
                # --- haltungspunkt ---
                abwassernetzelementref=self.get_tid(row.fk_wastewater_networkelement__REL),
                auslaufform=self.get_vl(row.outlet_shape__REL),
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                hoehengenauigkeit=self.get_vl(row.elevation_accuracy__REL),
                kote=row.level,
                lage=ST_Force2D(row.situation3d_geometry),
                lage_anschluss=row.position_of_connection,
            )
            self.abwasser_session.add(haltungspunkt)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_wastewater_node(self):
        query = self.tww_session.query(self.model_classes_tww_od.wastewater_node)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
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
            abwasserknoten = self.model_classes_interlis.abwasserknoten(
                # FIELDS TO MAP TO ABWASSER.abwasserknoten
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row, "abwasserknoten"),
                # --- abwasserknoten ---
                # TODO : WARNING : fk_hydr_geometry is not mapped
                lage=ST_Force2D(row.situation3d_geometry),
                rueckstaukote_ist=row.backflow_level_current,
                sohlenkote=row.bottom_level,
            )
            self.abwasser_session.add(abwasserknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_reach(self):
        query = self.tww_session.query(self.model_classes_tww_od.reach)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.reach

            # --- wastewater_networkelement ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark

            # --- reach ---
            # clear_height, coefficient_of_friction, elevation_determination, fk_pipe_profile, fk_reach_point_from, fk_reach_point_to, horizontal_positioning, inside_coating, length_effective, material, obj_id, progression3d_geometry, reliner_material, reliner_nominal_size, relining_construction, relining_kind, ring_stiffness, slope_building_plan, wall_roughness

            # --- _bwrel_ ---
            # catchment_area__BWREL_fk_wastewater_networkelement_rw_current, catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, catchment_area__BWREL_fk_wastewater_networkelement_ww_current, catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, connection_object__BWREL_fk_wastewater_networkelement, reach_point__BWREL_fk_wastewater_networkelement, reach_text__BWREL_fk_reach, txt_text__BWREL_fk_reach

            # --- _rel_ ---
            # elevation_determination__REL, fk_dataowner__REL, fk_pipe_profile__REL, fk_provider__REL, fk_reach_point_from__REL, fk_reach_point_to__REL, fk_wastewater_structure__REL, horizontal_positioning__REL, inside_coating__REL, material__REL, reliner_material__REL, relining_construction__REL, relining_kind__REL

            logger.warning(
                "TWW field reach.elevation_determination has no equivalent in the interlis model. It will be ignored."
            )
            haltung = self.model_classes_interlis.haltung(
                # FIELDS TO MAP TO ABWASSER.haltung
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row, "haltung"),
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
                verlauf=ST_Force2D(row.progression3d_geometry),
                vonhaltungspunktref=self.get_tid(row.fk_reach_point_from__REL),
                wandrauhigkeit=row.wall_roughness,
            )
            self.abwasser_session.add(haltung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_dryweather_downspout(self):
        query = self.tww_session.query(self.model_classes_tww_od.dryweather_downspout)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_structure,
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
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

            trockenwetterfallrohr = self.model_classes_interlis.trockenwetterfallrohr(
                # FIELDS TO MAP TO ABWASSER.trockenwetterfallrohr
                # --- bauwerksteil ---
                **self.structure_part_common(row, "trockenwetterfallrohr"),
                # --- trockenwetterfallrohr ---
                durchmesser=row.diameter,
            )
            self.abwasser_session.add(trockenwetterfallrohr)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_access_aid(self):
        query = self.tww_session.query(self.model_classes_tww_od.access_aid)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_structure,
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
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

            einstiegshilfe = self.model_classes_interlis.einstiegshilfe(
                # FIELDS TO MAP TO ABWASSER.einstiegshilfe
                # --- bauwerksteil ---
                **self.structure_part_common(row, "einstiegshilfe"),
                # --- einstiegshilfe ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(einstiegshilfe)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_dryweather_flume(self):
        query = self.tww_session.query(self.model_classes_tww_od.dryweather_flume)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_structure,
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
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

            trockenwetterrinne = self.model_classes_interlis.trockenwetterrinne(
                # FIELDS TO MAP TO ABWASSER.trockenwetterrinne
                # --- bauwerksteil ---
                **self.structure_part_common(row, "trockenwetterrinne"),
                # --- trockenwetterrinne ---
                material=self.get_vl(row.material__REL),
            )
            self.abwasser_session.add(trockenwetterrinne)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_cover(self):
        query = self.tww_session.query(self.model_classes_tww_od.cover)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_structure,
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.cover

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- cover ---
            # brand, cover_shape, diameter, fastening, level, material, obj_id, positional_accuracy, situation3d_geometry, sludge_bucket, venting

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id, wastewater_structure__BWREL_fk_main_cover

            # --- _rel_ ---
            # cover_shape__REL, fastening__REL, fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, material__REL, positional_accuracy__REL, renovation_demand__REL, sludge_bucket__REL, venting__REL

            deckel = self.model_classes_interlis.deckel(
                # FIELDS TO MAP TO ABWASSER.deckel
                # --- bauwerksteil ---
                **self.structure_part_common(row, "deckel"),
                # --- deckel ---
                deckelform=self.get_vl(row.cover_shape__REL),
                durchmesser=row.diameter,
                entlueftung=self.get_vl(row.venting__REL),
                fabrikat=row.brand,
                kote=row.level,
                lage=ST_Force2D(row.situation3d_geometry),
                lagegenauigkeit=self.get_vl(row.positional_accuracy__REL),
                material=self.get_vl(row.material__REL),
                schlammeimer=self.get_vl(row.sludge_bucket__REL),
                verschluss=self.get_vl(row.fastening__REL),
            )
            self.abwasser_session.add(deckel)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_benching(self):
        query = self.tww_session.query(self.model_classes_tww_od.benching)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_structure,
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
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

            bankett = self.model_classes_interlis.bankett(
                # FIELDS TO MAP TO ABWASSER.bankett
                # --- bauwerksteil ---
                **self.structure_part_common(row, "bankett"),
                # --- bankett ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(bankett)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_waste_water_treatment_plant(self):
        query = self.tww_session.query(self.model_classes_tww_od.waste_water_treatment_plant)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.waste_water_treatment_plant.obj_id.in_(self.subset_ids)
            )
        for row in query:
            abwasserreinigungsanlage = self.model_classes_interlis.abwasserreinigungsanlage(
                **self.vsa_base_common(row, "abwasserreinigungsanlage"),
                # --- abwasserreinigungsanlage ---
                perimeter=row.area_geometry,
                bsb5=row.bod5,
                csb=row.cod,
                eliminationcsb=row.elimination_cod,
                eliminationn=row.elimination_n,
                eliminationnh4=row.elimination_nh4,
                eliminationp=row.elimination_p,
                bezeichnung=row.identifier,
                art=row.kind,
                nh4=row.nh4,
                betreibertyp=self.get_vl(row.operator_type__REL),
                einwohner_angeschlossen=row.population_connected,
                einwohner_total=row.population_total,
                bemerkung=row.remark,
                lage=row.situation_geometry,
                inbetriebnahme=row.start_year,
                ara_nr=row.wwtp_number,
            )
            self.abwasser_session.add(abwasserreinigungsanlage)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_wwtp_energy_use(self):
        query = self.tww_session.query(self.model_classes_tww_od.wwtp_energy_use)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.wwtp_energy_use.obj_id.in_(self.subset_ids)
            )
        for row in query:
            araenergienutzung = self.model_classes_interlis.araenergienutzung(
                **self.vsa_base_common(row, "araenergienutzung"),
                # --- araenergienutzung ---
                gasmotor=row.gas_motor,
                waermepumpe=row.heat_pump,
                bezeichnung=row.identifier,
                bemerkung=row.remark,
                turbinierung=row.turbining,
                abwasserreinigungsanlageref=self.get_tid(row.fk_waste_water_treatment_plant__REL),
            )
            self.abwasser_session.add(araenergienutzung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_waste_water_treatment(self):
        query = self.tww_session.query(self.model_classes_tww_od.waste_water_treatment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.waste_water_treatment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            abwasserbehandlung = self.model_classes_interlis.abwasserbehandlung(
                **self.vsa_base_common(row, "abwasserbehandlung"),
                # --- abwasserbehandlung ---
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                abwasserreinigungsanlageref=self.get_tid(row.fk_waste_water_treatment_plant__REL),
            )
            self.abwasser_session.add(abwasserbehandlung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_sludge_treatment(self):
        query = self.tww_session.query(self.model_classes_tww_od.sludge_treatment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.sludge_treatment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            schlammbehandlung = self.model_classes_interlis.schlammbehandlung(
                **self.vsa_base_common(row, "schlammbehandlung"),
                # --- schlammbehandlung ---
                kompostierung=row.composting,
                entwaesserung=row.dehydration,
                faulschlammverbrennung=row.digested_sludge_combustion,
                trocknung=row.drying,
                frischschlammverbrennung=row.fresh_sludge_combustion,
                hygienisierung=row.hygenisation,
                bezeichnung=row.identifier,
                ueberschusschlammvoreindickung=row.predensification_of_excess_sludge,
                mischschlammvoreindickung=row.predensification_of_mixed_sludge,
                primaerschlammvoreindickung=row.predensification_of_primary_sludge,
                bemerkung=row.remark,
                stabilisierung=self.get_vl(row.stabilisation__REL),
                entwaessertklaerschlammstapelung=row.stacking_of_dehydrated_sludge,
                fluessigklaerschlammstapelung=row.stacking_of_liquid_sludge,
                abwasserreinigungsanlageref=self.get_tid(row.fk_waste_water_treatment_plant__REL),
            )
            self.abwasser_session.add(schlammbehandlung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_wwtp_structure(self):
        query = self.tww_session.query(self.model_classes_tww_od.wwtp_structure)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            arabauwerk = self.model_classes_interlis.arabauwerk(
                # --- bauwerksteil ---
                **self.wastewater_structure_common(row, "arabauwerk"),
                # --- arabauwerk ---
                art=self.get_vl(row.kind__REL),
                abwasserreinigungsanlageref=self.get_tid(row.fk_waste_water_treatment_plant__REL),
            )
            self.abwasser_session.add(arabauwerk)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_control_center(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            steuerungszentrale = self.model_classes_interlis.steuerungszentrale(
                **self.vsa_base_common(row, "steuerungszentrale"),
                # --- steuerungszentrale ---
                bezeichnung=row.identifier,
                lage=row.situation_geometry,
            )
            self.abwasser_session.add(steuerungszentrale)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_examination(self):
        query = self.tww_session.query(self.model_classes_tww_od.examination)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
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

            untersuchung = self.model_classes_interlis.untersuchung(
                # FIELDS TO MAP TO ABWASSER.untersuchung
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.vsa_base_common(row, "untersuchung"),
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
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_damage_manhole(self):
        query = self.tww_session.query(self.model_classes_tww_od.damage_manhole)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.examination)
                .join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
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

            normschachtschaden = self.model_classes_interlis.normschachtschaden(
                # FIELDS TO MAP TO ABWASSER.normschachtschaden
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.vsa_base_common(row, "normschachtschaden"),
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
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_damage_channel(self):
        query = self.tww_session.query(self.model_classes_tww_od.damage_channel)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.examination)
                .join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
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

            kanalschaden = self.model_classes_interlis.kanalschaden(
                # FIELDS TO MAP TO ABWASSER.kanalschaden
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.vsa_base_common(row, "kanalschaden"),
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
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_data_media(self):
        query = self.tww_session.query(self.model_classes_tww_od.data_media)
        for row in query:
            # AVAILABLE FIELDS IN TWW.data_media

            # --- data_media ---
            # fk_dataowner, fk_provider, identifier, kind, last_modification, location, obj_id, path, remark

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, kind__REL

            datentraeger = self.model_classes_interlis.datentraeger(
                # FIELDS TO MAP TO ABWASSER.datentraeger
                # --- vsa_baseclass ---
                **self.vsa_base_common(row, "datentraeger"),
                # --- datentraeger ---
                art=self.get_vl(row.kind__REL),
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                pfad=row.path,
                standort=row.location,
            )
            self.abwasser_session.add(datentraeger)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_file(self):
        query = self.tww_session.query(self.model_classes_tww_od.file)
        if self.filtered:
            query = (
                query.outerjoin(
                    self.model_classes_tww_od.damage,
                    self.model_classes_tww_od.file.object
                    == self.model_classes_tww_od.damage.obj_id,
                )
                .join(
                    self.model_classes_tww_od.examination,
                    or_(
                        self.model_classes_tww_od.file.object
                        == self.model_classes_tww_od.damage.obj_id,
                        self.model_classes_tww_od.file.object
                        == self.model_classes_tww_od.examination.obj_id,
                    ),
                )
                .join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
        for row in query:
            # AVAILABLE FIELDS IN TWW.file

            # --- file ---
            # class, fk_data_media, fk_dataowner, fk_provider, identifier, kind, last_modification, obj_id, object, path_relative, remark

            # --- _rel_ ---
            # class__REL, fk_dataowner__REL, fk_provider__REL, kind__REL

            datei = self.model_classes_interlis.datei(
                # FIELDS TO MAP TO ABWASSER.datei
                # --- vsa_baseclass ---
                **self.vsa_base_common(row, "datei"),
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
            for row in self.abwasser_session.query(self.model_classes_interlis.haltung):
                tid_for_obj_id["haltung"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.model_classes_interlis.abwasserbauwerk):
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
                    ili_label = self.model_classes_interlis.haltung_text(
                        **self.textpos_common(label, "haltung_text", geojson_crs_def),
                        haltungref=tid_for_obj_id["haltung"][obj_id],
                    )

                elif layer_name == "vw_tww_wastewater_structure":
                    if obj_id not in tid_for_obj_id["abwasserbauwerk"]:
                        logger.warning(
                            f"Label for abwasserbauwerk `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.model_classes_interlis.abwasserbauwerk_text(
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

    def base_common(self, row, type_name):
        """
        Returns common attributes for base
        """
        return {
            "t_ili_tid": row.obj_id,
            "t_type": type_name,
            "t_id": self.get_tid(row),
        }

    def sia_405_base_common(self, row, type_name):
        return {
            **self.base_common(row, type_name),
            "letzte_aenderung": row.last_modification,
        }

    def vsa_base_common(self, row, type_name):
        """
        Returns common attributes for base
        """
        datenherrref = self.get_tid(row.fk_dataowner__REL)
        if not datenherrref:
            raise InterlisExporterToIntermediateSchemaError(
                f"Invalid dataowner reference for object '{row.obj_id}' of type '{type_name}'"
            )

        datenlieferantref = self.get_tid(row.fk_provider__REL)
        if not datenlieferantref:
            raise InterlisExporterToIntermediateSchemaError(
                f"Invalid provider reference for object '{row.obj_id}' of type '{type_name}'"
            )

        return {
            **self.sia_405_base_common(row, type_name),
            "datenherrref": datenherrref,
            "datenlieferantref": datenlieferantref,
        }

    def wastewater_structure_common(self, row, type_name):
        """
        Returns common attributes for wastewater_structure
        """
        logger.warning(
            "Mapping of wastewater_structure->abwasserbauwerk is not fully implemented."
        )

        eigentuemerref = self.get_tid(row.fk_owner__REL)
        if not eigentuemerref:
            raise InterlisExporterToIntermediateSchemaError(
                f"Invalid owner reference for object '{row.obj_id}' of type '{type_name}'"
            )

        return {
            **self.vsa_base_common(row, type_name),
            "akten": row.records,
            "astatus": self.get_vl(row.status__REL),
            "baujahr": row.year_of_construction,
            "baulicherzustand": self.get_vl(row.structure_condition__REL),
            "baulos": row.contract_section,
            "bemerkung": self.truncate(self.emptystr_to_null(row.remark), 80),
            "betreiberref": self.get_tid(row.fk_operator__REL),
            "bezeichnung": self.null_to_emptystr(row.identifier),
            "bruttokosten": row.gross_costs,
            "detailgeometrie": ST_Force2D(row.detail_geometry3d_geometry),
            "eigentuemerref": eigentuemerref,
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

    def wastewater_networkelement_common(self, row, type_name):
        """
        Returns common attributes for network_element
        """
        return {
            **self.vsa_base_common(row, type_name),
            "abwasserbauwerkref": self.get_tid(row.fk_wastewater_structure__REL),
            "bemerkung": self.truncate(self.emptystr_to_null(row.remark), 80),
            "bezeichnung": self.null_to_emptystr(row.identifier),
        }

    def structure_part_common(self, row, type_name):
        """
        Returns common attributes for structure_part
        """
        return {
            **self.vsa_base_common(row, type_name),
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

    def close_sessions(self):
        self.tww_session.close()
        self.abwasser_session.close()

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()
