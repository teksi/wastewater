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

        self.current_basket = None
        self.basket_topic_sia405_administration = None
        self.basket_topic_sia405_abwasser = None
        self.basket_topic_dss = None
        self.basket_topic_kek = None

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
            self._create_basket()
            self.current_basket = self.basket_topic_sia405_administration

        self._export_sia405_abwasser()

        if self.model == config.MODEL_NAME_DSS:
            self.current_basket = self.basket_topic_dss
            self._export_dss()

        if self.model == config.MODEL_NAME_VSA_KEK:
            self.current_basket = self.basket_topic_kek
            self._export_vsa_kek()

        # Labels
        # Note: these are extracted from the optional labels file (not exported from the TWW database)
        if self.labels_file:
            logger.info(f"Exporting label positions from {self.labels_file}")
            self._export_label_positions()

    def _create_basket(self):
        dataset = self.model_classes_interlis.t_ili2db_dataset(
            t_id=1,
            datasetname="teksi-wastewater-export",
        )
        self.abwasser_session.add(dataset)

        self.basket_topic_sia405_administration = self.model_classes_interlis.t_ili2db_basket(
            t_id=2,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_SIA405_ADMINISTRATION,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_sia405_administration)

        self.basket_topic_sia405_abwasser = self.model_classes_interlis.t_ili2db_basket(
            t_id=3,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_SIA405_ABWASSER,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_sia405_abwasser)

        self.basket_topic_dss = self.model_classes_interlis.t_ili2db_basket(
            t_id=4,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_DSS,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_dss)

        self.basket_topic_kek = self.model_classes_interlis.t_ili2db_basket(
            t_id=5,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_KEK,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_kek)
        self.abwasser_session.flush()

    def _export_sia405_abwasser(self):
        logger.info("Exporting TWW.organisation -> ABWASSER.organisation")
        self._export_organisation()
        self._check_for_stop()

        self.current_basket = self.basket_topic_sia405_abwasser

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

        logger.info("Exporting TWW.drainless_toilet -> ABWASSER.Abflusslose_Toilette")
        self._export_drainless_toilet()
        self._check_for_stop()

        logger.info("Exporting TWW.throttle_shut_off_unit -> ABWASSER.Absperr_Drosselorgan")
        self._export_throttle_shut_off_unit()
        self._check_for_stop()

        logger.info("Exporting TWW.tank_emptying -> ABWASSER.Beckenentleerung")
        self._export_tank_emptying()
        self._check_for_stop()

        logger.info("Exporting TWW.tank_cleaning -> ABWASSER.Beckenreinigung")
        self._export_tank_cleaning()
        self._check_for_stop()

        logger.info("Exporting TWW.bio_ecol_assessment -> ABWASSER.Biol_oekol_Gesamtbeurteilung")
        self._export_bio_ecol_assessment()
        self._check_for_stop()

        logger.info("Exporting TWW.fountain -> ABWASSER.Brunnen")
        self._export_fountain()
        self._check_for_stop()

        logger.info("Exporting TWW.param_ca_general -> ABWASSER.EZG_PARAMETER_ALLG")
        self._export_param_ca_general()
        self._check_for_stop()

        logger.info("Exporting TWW.param_ca_mouse1 -> ABWASSER.EZG_PARAMETER_MOUSE1")
        self._export_param_ca_mouse1()
        self._check_for_stop()

        logger.info("Exporting TWW.individual_surface -> ABWASSER.Einzelflaeche")
        self._export_individual_surface()
        self._check_for_stop()

        logger.info("Exporting TWW.catchment_area -> ABWASSER.Einzugsgebiet")
        self._export_catchment_area()
        self._check_for_stop()

        logger.info("Exporting TWW.electric_equipment -> ABWASSER.ElektrischeEinrichtung")
        self._export_electric_equipment()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.electromechanical_equipment -> ABWASSER.ElektromechanischeAusruestung"
        )
        self._export_electromechanical_equipment()
        self._check_for_stop()

        logger.info("Exporting TWW.disposal -> ABWASSER.Entsorgung")
        self._export_disposal()
        self._check_for_stop()

        logger.info("Exporting TWW.drainage_system -> ABWASSER.Entwaesserungssystem")
        self._export_drainage_system()
        self._check_for_stop()

        logger.info("Exporting TWW.solids_retention -> ABWASSER.Feststoffrueckhalt")
        self._export_solids_retention()
        self._check_for_stop()

        logger.info("Exporting TWW.pump -> ABWASSER.FoerderAggregat")
        self._export_pump()
        self._check_for_stop()

        logger.info("Exporting TWW.building -> ABWASSER.Gebaeude")
        self._export_building()
        self._check_for_stop()

        logger.info("Exporting TWW.building_group -> ABWASSER.Gebaeudegruppe")
        self._export_building_group()
        self._check_for_stop()

        logger.info("Exporting TWW.building_group_baugwr -> ABWASSER.Gebaeudegruppe_BAUGWR")
        self._export_building_group_baugwr()
        self._check_for_stop()

        logger.info("Exporting TWW.catchment_area_totals -> ABWASSER.Gesamteinzugsgebiet")
        self._export_catchment_area_totals()
        self._check_for_stop()

        logger.info("Exporting TWW.hq_relation -> ABWASSER.HQ_Relation")
        self._export_hq_relation()
        self._check_for_stop()

        logger.info("Exporting TWW.hydr_geom_relation -> ABWASSER.Hydr_GeomRelation")
        self._export_hydr_geom_relation()
        self._check_for_stop()

        logger.info("Exporting TWW.hydr_geometry -> ABWASSER.Hydr_Geometrie")
        self._export_hydr_geometry()
        self._check_for_stop()

        logger.info("Exporting TWW.hydraulic_char_data -> ABWASSER.Hydr_Kennwerte")
        self._export_hydraulic_char_data()
        self._check_for_stop()

        logger.info("Exporting TWW.small_treatment_plant -> ABWASSER.KLARA")
        self._export_small_treatment_plant()
        self._check_for_stop()

        logger.info("Exporting TWW.farm -> ABWASSER.Landwirtschaftsbetrieb")
        self._export_farm()
        self._check_for_stop()

        logger.info("Exporting TWW.leapingweir -> ABWASSER.Leapingwehr")
        self._export_leapingweir()
        self._check_for_stop()

        logger.info("Exporting TWW.measure -> ABWASSER.Massnahme")
        self._export_measure()
        self._check_for_stop()

        logger.info("Exporting TWW.mechanical_pretreatment -> ABWASSER.MechanischeVorreinigung")
        self._export_mechanical_pretreatment()
        self._check_for_stop()

        logger.info("Exporting TWW.measuring_device -> ABWASSER.Messgeraet")
        self._export_measuring_device()
        self._check_for_stop()

        logger.info("Exporting TWW.measurement_series -> ABWASSER.Messreihe")
        self._export_measurement_series()
        self._check_for_stop()

        logger.info("Exporting TWW.measurement_result -> ABWASSER.Messresultat")
        self._export_measurement_result()
        self._check_for_stop()

        logger.info("Exporting TWW.measuring_point -> ABWASSER.Messstelle")
        self._export_measuring_point()
        self._check_for_stop()

        logger.info("Exporting TWW.mutation -> ABWASSER.Mutation")
        self._export_mutation()
        self._check_for_stop()

        logger.info("Exporting TWW.reservoir -> ABWASSER.Reservoir")
        self._export_reservoir()
        self._check_for_stop()

        logger.info("Exporting TWW.retention_body -> ABWASSER.Retentionskoerper")
        self._export_retention_body()
        self._check_for_stop()

        logger.info("Exporting TWW.profile_geometry -> ABWASSER.Rohrprofil_Geometrie")
        self._export_profile_geometry()
        self._check_for_stop()

        logger.info("Exporting TWW.backflow_prevention -> ABWASSER.Rueckstausicherung")
        self._export_backflow_prevention()
        self._check_for_stop()

        logger.info("Exporting TWW.log_card -> ABWASSER.Stammkarte")
        self._export_log_card()
        self._check_for_stop()

        logger.info("Exporting TWW.prank_weir -> ABWASSER.Streichwehr")
        self._export_prank_weir()
        self._check_for_stop()

        logger.info("Exporting TWW.overflow_char -> ABWASSER.Ueberlaufcharakteristik")
        self._export_overflow_char()
        self._check_for_stop()

        logger.info("Exporting TWW.maintenance -> ABWASSER.Unterhalt")
        self._export_maintenance()
        self._check_for_stop()

        logger.info("Exporting TWW.infiltration_zone -> ABWASSER.Versickerungsbereich")
        self._export_infiltration_zone()
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

    def _export_drainless_toilet(self):
        query = self.tww_session.query(self.model_classes_tww_od.drainless_toilet)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.drainless_toilet.obj_id.in_(self.subset_ids)
            )
        for row in query:
            abflusslose_toilette = self.model_classes_interlis.abflusslose_toilette(
                **self.wastewater_structure_common(row, "abflusslose_toilette"),
                # --- drainless_toilet ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(abflusslose_toilette)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_throttle_shut_off_unit(self):
        query = self.tww_session.query(self.model_classes_tww_od.throttle_shut_off_unit)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.throttle_shut_off_unit.obj_id.in_(self.subset_ids)
            )
        for row in query:
            absperr_drosselorgan = self.model_classes_interlis.absperr_drosselorgan(
                **self.vsa_base_common(row, "absperr_drosselorgan"),
                # --- throttle_shut_off_unit ---
                antrieb=self.get_vl(row.actuation__REL),
                verstellbarkeit=self.get_vl(row.adjustability__REL),
                steuerung=self.get_vl(row.control__REL),
                querschnitt=row.cross_section,
                wirksamer_qs=row.effective_cross_section,
                bruttokosten=row.gross_costs,
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                fabrikat=row.manufacturer,
                bemerkung=row.remark,
                signaluebermittlung=self.get_vl(row.signal_transmission__REL),
                subventionen=row.subsidies,
                drosselorgan_oeffnung_ist=row.throttle_unit_opening_current,
                drosselorgan_oeffnung_ist_optimiert=row.throttle_unit_opening_current_optimized,
                abwasserknotenref=self.get_pk(row.fk_wastewater_node__REL),
                steuerungszentraleref=self.get_pk(row.fk_control_center__REL),
                ueberlaufref=self.get_pk(row.fk_overflow__REL),
            )
            self.abwasser_session.add(absperr_drosselorgan)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_tank_emptying(self):
        query = self.tww_session.query(self.model_classes_tww_od.tank_emptying)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.tank_emptying.obj_id.in_(self.subset_ids)
            )
        for row in query:
            beckenentleerung = self.model_classes_interlis.beckenentleerung(
                **self.vsa_base_common(row, "beckenentleerung"),
                **self.structure_part_common(row),
                # --- tank_emptying ---
                leistung=row.flow,
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.type__REL),
                ersatzjahr=row.year_of_replacement,
                absperr_drosselorganref=self.get_pk(row.fk_throttle_shut_off_unit__REL),
                ueberlaufref=self.get_pk(row.fk_overflow__REL),
            )
            self.abwasser_session.add(beckenentleerung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_tank_cleaning(self):
        query = self.tww_session.query(self.model_classes_tww_od.tank_cleaning)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.tank_cleaning.obj_id.in_(self.subset_ids)
            )
        for row in query:
            beckenreinigung = self.model_classes_interlis.beckenreinigung(
                **self.vsa_base_common(row, "beckenreinigung"),
                **self.structure_part_common(row),
                # --- tank_cleaning ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.type__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(beckenreinigung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_bio_ecol_assessment(self):
        query = self.tww_session.query(self.model_classes_tww_od.bio_ecol_assessment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.bio_ecol_assessment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            biol_oekol_gesamtbeurteilung = self.model_classes_interlis.biol_oekol_gesamtbeurteilung(
                **self.vsa_base_common(row, "biol_oekol_gesamtbeurteilung"),
                **self.maintenance_event_common(row),
                # --- bio_ecol_assessment ---
                vergleich_letzte_untersuchung=self.get_vl(row.comparison_last__REL),
                datum_letzte_untersuchung=row.date_last_examen,
                einfluss_hilfsindikatoren=self.get_vl(row.impact_auxiliary_indic__REL),
                einfluss_aeusserer_aspekt=self.get_vl(row.impact_external_aspect__REL),
                einfluss_makroinvertebraten=self.get_vl(row.impact_macroinvertebrates__REL),
                einfluss_wasserpflanzen=self.get_vl(row.impact_water_plants__REL),
                handlungsbedarf=self.get_vl(row.intervention_demand__REL),
                immissionsorientierte_berechnung=self.get_vl(row.io_calculation__REL),
                auslaufrohr_lichte_hoehe=row.outlet_pipe_clear_height,
                q347=row.q347,
                relevanzmatrix=self.get_vl(row.relevance_matrix__REL),
                relevantes_gefaelle=row.relevant_slope,
                oberflaechengewaesser=row.surface_water_bodies,
                gewaesserart=self.get_vl(row.type_water_body__REL),
                gewaesserspezifische_entlastungsfracht_nh4_n_ist=row.water_specific_discharge_freight_nh4_n_current,
                gewaesserspezifische_entlastungsfracht_nh4_n_ist_optimiert=row.water_specific_discharge_freight_nh4_n_current_opt,
                gewaesserspezifische_entlastungsfracht_nh4_n_geplant=row.water_specific_discharge_freight_nh4_n_planned,
            )
            self.abwasser_session.add(biol_oekol_gesamtbeurteilung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_fountain(self):
        query = self.tww_session.query(self.model_classes_tww_od.fountain)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.fountain.obj_id.in_(self.subset_ids))
        for row in query:
            brunnen = self.model_classes_interlis.brunnen(
                **self.vsa_base_common(row, "brunnen"),
                **self.connection_object_common(row),
                # --- fountain ---
                standortname=row.location_name,
                lage=row.situation_geometry,
            )
            self.abwasser_session.add(brunnen)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_param_ca_general(self):
        query = self.tww_session.query(self.model_classes_tww_od.param_ca_general)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.param_ca_general.obj_id.in_(self.subset_ids)
            )
        for row in query:
            ezg_parameter_allg = self.model_classes_interlis.ezg_parameter_allg(
                **self.vsa_base_common(row, "ezg_parameter_allg"),
                **self.surface_runoff_parameters_common(row),
                # --- param_ca_general ---
                trockenwetteranfall=row.dry_wheather_flow,
                fliessweglaenge=row.flow_path_length,
                fliessweggefaelle=row.flow_path_slope,
                einwohnergleichwert=row.population_equivalent,
                flaeche=row.surface_ca,
            )
            self.abwasser_session.add(ezg_parameter_allg)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_param_ca_mouse1(self):
        query = self.tww_session.query(self.model_classes_tww_od.param_ca_mouse1)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.param_ca_mouse1.obj_id.in_(self.subset_ids)
            )
        for row in query:
            ezg_parameter_mouse1 = self.model_classes_interlis.ezg_parameter_mouse1(
                **self.vsa_base_common(row, "ezg_parameter_mouse1"),
                **self.surface_runoff_parameters_common(row),
                # --- param_ca_mouse1 ---
                trockenwetteranfall=row.dry_wheather_flow,
                fliessweglaenge=row.flow_path_length,
                fliessweggefaelle=row.flow_path_slope,
                einwohnergleichwert=row.population_equivalent,
                flaeche=row.surface_ca_mouse,
                nutzungsart=row.usage,
            )
            self.abwasser_session.add(ezg_parameter_mouse1)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_individual_surface(self):
        query = self.tww_session.query(self.model_classes_tww_od.individual_surface)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.individual_surface.obj_id.in_(self.subset_ids)
            )
        for row in query:
            einzelflaeche = self.model_classes_interlis.einzelflaeche(
                **self.vsa_base_common(row, "einzelflaeche"),
                **self.connection_object_common(row),
                # --- individual_surface ---
                funktion=self.get_vl(row.function__REL),
                neigung=row.inclination,
                befestigung=self.get_vl(row.pavement__REL),
                perimeter=row.perimeter_geometry,
            )
            self.abwasser_session.add(einzelflaeche)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_catchment_area(self):
        query = self.tww_session.query(self.model_classes_tww_od.catchment_area)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.catchment_area.obj_id.in_(self.subset_ids)
            )
        for row in query:
            einzugsgebiet = self.model_classes_interlis.einzugsgebiet(
                **self.vsa_base_common(row, "einzugsgebiet"),
                # --- catchment_area ---
                direkteinleitung_in_gewaesser_ist=self.get_vl(row.direct_discharge_current__REL),
                direkteinleitung_in_gewaesser_geplant=self.get_vl(
                    row.direct_discharge_planned__REL
                ),
                abflussbeiwert_rw_ist=row.discharge_coefficient_rw_current,
                abflussbeiwert_rw_geplant=row.discharge_coefficient_rw_planned,
                abflussbeiwert_sw_ist=row.discharge_coefficient_ww_current,
                abflussbeiwert_sw_geplant=row.discharge_coefficient_ww_planned,
                entwaesserungssystem_ist=self.get_vl(row.drainage_system_current__REL),
                entwaesserungssystem_geplant=self.get_vl(row.drainage_system_planned__REL),
                bezeichnung=row.identifier,
                versickerung_ist=self.get_vl(row.infiltration_current__REL),
                versickerung_geplant=self.get_vl(row.infiltration_planned__REL),
                perimeter=row.perimeter_geometry,
                einwohnerdichte_ist=row.population_density_current,
                einwohnerdichte_geplant=row.population_density_planned,
                bemerkung=row.remark,
                retention_ist=self.get_vl(row.retention_current__REL),
                retention_geplant=self.get_vl(row.retention_planned__REL),
                abflussbegrenzung_ist=row.runoff_limit_current,
                abflussbegrenzung_geplant=row.runoff_limit_planned,
                befestigungsgrad_rw_ist=row.seal_factor_rw_current,
                befestigungsgrad_rw_geplant=row.seal_factor_rw_planned,
                befestigungsgrad_sw_ist=row.seal_factor_ww_current,
                befestigungsgrad_sw_geplant=row.seal_factor_ww_planned,
                fremdwasseranfall_ist=row.sewer_infiltration_water_production_current,
                fremdwasseranfall_geplant=row.sewer_infiltration_water_production_planned,
                flaeche=row.surface_area,
                schmutzabwasseranfall_ist=row.waste_water_production_current,
                schmutzabwasseranfall_geplant=row.waste_water_production_planned,
                abwassernetzelement_rw_istref=self.get_pk(
                    row.fk_wastewater_networkelement_rw_current__REL
                ),
                abwassernetzelement_rw_geplantref=self.get_pk(
                    row.fk_wastewater_networkelement_rw_planned__REL
                ),
                abwassernetzelement_sw_geplantref=self.get_pk(
                    row.fk_wastewater_networkelement_ww_planned__REL
                ),
                abwassernetzelement_sw_istref=self.get_pk(
                    row.fk_wastewater_networkelement_ww_current__REL
                ),
                sbw_rw_geplantref=self.get_pk(row.fk_special_building_rw_planned__REL),
                sbw_rw_istref=self.get_pk(row.fk_special_building_rw_current__REL),
                sbw_sw_geplantref=self.get_pk(row.fk_special_building_ww_planned__REL),
                sbw_sw_istref=self.get_pk(row.fk_special_building_ww_current__REL),
            )
            self.abwasser_session.add(einzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_electric_equipment(self):
        query = self.tww_session.query(self.model_classes_tww_od.electric_equipment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.electric_equipment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            elektrischeeinrichtung = self.model_classes_interlis.elektrischeeinrichtung(
                **self.vsa_base_common(row, "elektrischeeinrichtung"),
                **self.structure_part_common(row),
                # --- electric_equipment ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(elektrischeeinrichtung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_electromechanical_equipment(self):
        query = self.tww_session.query(self.model_classes_tww_od.electromechanical_equipment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.electromechanical_equipment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            elektromechanischeausruestung = self.model_classes_interlis.elektromechanischeausruestung(
                **self.vsa_base_common(row, "elektromechanischeausruestung"),
                **self.structure_part_common(row),
                # --- electromechanical_equipment ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(elektromechanischeausruestung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_disposal(self):
        query = self.tww_session.query(self.model_classes_tww_od.disposal)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.disposal.obj_id.in_(self.subset_ids))
        for row in query:
            entsorgung = self.model_classes_interlis.entsorgung(
                **self.vsa_base_common(row, "entsorgung"),
                # --- disposal ---
                entsorgungsintervall_ist=row.disposal_interval_current,
                entsorgungsintervall_soll=row.disposal_interval_nominal,
                entsorgungsort_ist=self.get_vl(row.disposal_place_current__REL),
                entsorgungsort_geplant=self.get_vl(row.disposal_place_planned__REL),
                volumenabflusslosegrube=row.volume_pit_without_drain,
                versickerungsanlageref=self.get_pk(row.fk_infiltration_installation__REL),
                einleitstelleref=self.get_pk(row.fk_discharge_point__REL),
                abwasserbauwerkref=self.get_pk(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(entsorgung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_drainage_system(self):
        query = self.tww_session.query(self.model_classes_tww_od.drainage_system)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.drainage_system.obj_id.in_(self.subset_ids)
            )
        for row in query:
            entwaesserungssystem = self.model_classes_interlis.entwaesserungssystem(
                **self.vsa_base_common(row, "entwaesserungssystem"),
                **self.zone_common(row),
                # --- drainage_system ---
                art=self.get_vl(row.kind__REL),
                perimeter=row.perimeter_geometry,
            )
            self.abwasser_session.add(entwaesserungssystem)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_solids_retention(self):
        query = self.tww_session.query(self.model_classes_tww_od.solids_retention)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.solids_retention.obj_id.in_(self.subset_ids)
            )
        for row in query:
            feststoffrueckhalt = self.model_classes_interlis.feststoffrueckhalt(
                **self.vsa_base_common(row, "feststoffrueckhalt"),
                **self.structure_part_common(row),
                # --- solids_retention ---
                dimensionierungswert=row.dimensioning_value,
                bruttokosten=row.gross_costs,
                anspringkote=row.overflow_level,
                art=self.get_vl(row.type__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(feststoffrueckhalt)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_pump(self):
        query = self.tww_session.query(self.model_classes_tww_od.pump)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.pump.obj_id.in_(self.subset_ids))
        for row in query:
            foerderaggregat = self.model_classes_interlis.foerderaggregat(
                **self.vsa_base_common(row, "foerderaggregat"),
                **self.overflow_common(row),
                # --- pump ---
                bauart=self.get_vl(row.construction_type__REL),
                arbeitspunkt=row.operating_point,
                aufstellungantrieb=self.get_vl(row.placement_of_actuation__REL),
                aufstellungfoerderaggregat=self.get_vl(row.placement_of_pump__REL),
                foerderstrommax_einzel=row.pump_flow_max_single,
                foerderstrommin_einzel=row.pump_flow_min_single,
                kotestart=row.start_level,
                kotestop=row.stop_level,
            )
            self.abwasser_session.add(foerderaggregat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_building(self):
        query = self.tww_session.query(self.model_classes_tww_od.building)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.building.obj_id.in_(self.subset_ids))
        for row in query:
            gebaeude = self.model_classes_interlis.gebaeude(
                **self.vsa_base_common(row, "gebaeude"),
                **self.connection_object_common(row),
                # --- building ---
                hausnummer=row.house_number,
                standortname=row.location_name,
                perimeter=row.perimeter_geometry,
                referenzpunkt=row.reference_point_geometry,
            )
            self.abwasser_session.add(gebaeude)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_building_group(self):
        query = self.tww_session.query(self.model_classes_tww_od.building_group)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.building_group.obj_id.in_(self.subset_ids)
            )
        for row in query:
            gebaeudegruppe = self.model_classes_interlis.gebaeudegruppe(
                **self.vsa_base_common(row, "gebaeudegruppe"),
                # --- building_group ---
                kinositzplaetze=row.movie_theater_seats,
                kirchesitzplaetze=row.church_seats,
                campingflaeche=row.camping_area,
                campinguebernachtungen=row.camping_lodgings,
                anschlusspflicht=self.get_vl(row.connecting_obligation__REL),
                anschlussara=self.get_vl(row.connection_wwtp__REL),
                gewerbebeschaeftigte=row.craft_employees,
                schlafsaalbetten=row.dorm_beds,
                schlafsaaluebernachtungen=row.dorm_overnight_stays,
                entwaesserungsplan=self.get_vl(row.drainage_map__REL),
                trinkwassernetzanschluss=self.get_vl(row.drinking_water_network__REL),
                trinkwasserandere=self.get_vl(row.drinking_water_others__REL),
                stromanschluss=self.get_vl(row.electric_connection__REL),
                veranstaltungbesucher=row.event_visitors,
                funktion=self.get_vl(row.function__REL),
                turnhalleflaeche=row.gym_area,
                ferienuebernachtungen=row.holiday_accomodation,
                spitalbetten=row.hospital_beds,
                hotelbetten=row.hotel_beds,
                hoteluebernachtungen=row.hotel_overnight_stays,
                bezeichnung=row.identifier,
                anderenutzungegw=row.other_usage_population_equivalent,
                anderenutzungart=row.other_usage_type,
                einwohnerwerte=row.population_equivalent,
                bemerkung=row.remark,
                sanierungsdatum=row.renovation_date,
                sanierungsbedarf=self.get_vl(row.renovation_necessity__REL),
                raststaettesitzplaetze=row.restaurant_seats,
                restaurantsitzplaetze_saalgarten=row.restaurant_seats_hall_garden,
                restaurantsitzplaetze_permanent=row.restaurant_seats_permanent,
                sanierungskonzept=row.restructuring_concept,
                schuleschueler=row.school_students,
                lage=row.situation_geometry,
                # entsorgungref=self.get_pk(row.fk_disposal__REL), # TODO check why not available
                massnahmeref=self.get_pk(row.fk_measure__REL),
            )
            self.abwasser_session.add(gebaeudegruppe)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_building_group_baugwr(self):
        query = self.tww_session.query(self.model_classes_tww_od.building_group_baugwr)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.building_group_baugwr.obj_id.in_(self.subset_ids)
            )
        for row in query:
            gebaeudegruppe_baugwr = self.model_classes_interlis.gebaeudegruppe_baugwr(
                **self.vsa_base_common(row, "gebaeudegruppe_baugwr"),
                # --- building_group_baugwr ---
                egid=row.egid,
                gebaeudegrupperef=self.get_pk(row.fk_building_group__REL),
            )
            self.abwasser_session.add(gebaeudegruppe_baugwr)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_catchment_area_totals(self):
        query = self.tww_session.query(self.model_classes_tww_od.catchment_area_totals)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.catchment_area_totals.obj_id.in_(self.subset_ids)
            )
        for row in query:
            gesamteinzugsgebiet = self.model_classes_interlis.gesamteinzugsgebiet(
                **self.vsa_base_common(row, "gesamteinzugsgebiet"),
                # --- catchment_area_totals ---
                entlastungsfracht_nh4_n=row.discharge_freight_nh4_n,
                entlastungsanteil_nh4_n=row.discharge_proportion_nh4_n,
                bezeichnung=row.identifier,
                einwohner=row.population,
                einwohner_dim=row.population_dim,
                fremdwasseranfall=row.sewer_infiltration_water,
                flaeche=row.surface_area,
                flaeche_dim=row.surface_dim,
                flaeche_bef=row.surface_imp,
                flaeche_bef_dim=row.surface_imp_dim,
                flaeche_red=row.surface_red,
                flaeche_red_dim=row.surface_red_dim,
                schmutzabwasseranfall=row.waste_water_production,
                einleitstelleref=self.get_pk(row.fk_discharge_point__REL),
                hydr_kennwerteref=self.get_pk(row.fk_hydraulic_char_data__REL),
            )
            self.abwasser_session.add(gesamteinzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hq_relation(self):
        query = self.tww_session.query(self.model_classes_tww_od.hq_relation)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.hq_relation.obj_id.in_(self.subset_ids))
        for row in query:
            hq_relation = self.model_classes_interlis.hq_relation(
                **self.vsa_base_common(row, "hq_relation"),
                # --- hq_relation ---
                hoehe=row.altitude,
                abfluss=row.flow,
                zufluss=row.flow_from,
                ueberlaufcharakteristikref=self.get_pk(row.fk_overflow_char__REL),
            )
            self.abwasser_session.add(hq_relation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hydr_geom_relation(self):
        query = self.tww_session.query(self.model_classes_tww_od.hydr_geom_relation)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.hydr_geom_relation.obj_id.in_(self.subset_ids)
            )
        for row in query:
            hydr_geomrelation = self.model_classes_interlis.hydr_geomrelation(
                **self.vsa_base_common(row, "hydr_geomrelation"),
                # --- hydr_geom_relation ---
                wassertiefe=row.water_depth,
                wasseroberflaeche=row.water_surface,
                benetztequerschnittsflaeche=row.wet_cross_section_area,
                hydr_geometrieref=self.get_pk(row.fk_hydr_geometry__REL),
            )
            self.abwasser_session.add(hydr_geomrelation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hydr_geometry(self):
        query = self.tww_session.query(self.model_classes_tww_od.hydr_geometry)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.hydr_geometry.obj_id.in_(self.subset_ids)
            )
        for row in query:
            hydr_geometrie = self.model_classes_interlis.hydr_geometrie(
                **self.vsa_base_common(row, "hydr_geometrie"),
                # --- hydr_geometry ---
                bemerkung=row.remark,
                stauraum=row.storage_volume,
                nutzinhalt_fangteil=row.usable_capacity_storage,
                nutzinhalt_klaerteil=row.usable_capacity_treatment,
                nutzinhalt=row.utilisable_capacity,
                volumen_pumpensumpf=row.volume_pump_sump,
            )
            self.abwasser_session.add(hydr_geometrie)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hydraulic_char_data(self):
        query = self.tww_session.query(self.model_classes_tww_od.hydraulic_char_data)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.hydraulic_char_data.obj_id.in_(self.subset_ids)
            )
        for row in query:
            hydr_kennwerte = self.model_classes_interlis.hydr_kennwerte(
                **self.vsa_base_common(row, "hydr_kennwerte"),
                # --- hydraulic_char_data ---
                qan=row.qon,
                bemerkung=row.remark,
                status=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_status, row.astatus
                ),
                aggregatezahl=row.aggregate_number,
                foerderhoehe_geodaetisch=row.delivery_height_geodaetic,
                bezeichnung=row.identifier,
                is_overflowing=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_is_overflowing, row.springt_an
                ),
                hauptwehrart=self.get_vl(row.main_weir_kind__REL),
                mehrbelastung=row.overcharge,
                ueberlaufdauer=row.overflow_duration,
                ueberlauffracht=row.overflow_freight,
                ueberlaufhaeufigkeit=row.overflow_frequency,
                ueberlaufmenge=row.overflow_volume,
                pumpenregime=self.get_vl(row.pump_characteristics__REL),
                foerderstrommax=row.pump_flow_max,
                foerderstrommin=row.pump_flow_min,
                qab=row.q_discharge,
                abwasserknotenref=self.get_pk(row.fk_wastewater_node__REL),
                ueberlaufcharakteristikref=self.get_pk(row.fk_overflow_char__REL),
                primaerrichtungref=self.get_pk(row.fk_primary_direction__REL),
            )
            self.abwasser_session.add(hydr_kennwerte)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_small_treatment_plant(self):
        query = self.tww_session.query(self.model_classes_tww_od.small_treatment_plant)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.small_treatment_plant.obj_id.in_(self.subset_ids)
            )
        for row in query:
            klara = self.model_classes_interlis.klara(
                **self.vsa_base_common(row, "klara"),
                **self.wastewater_structure_common(row),
                # --- small_treatment_plant ---
                bewilligungsnummer=row.approval_number,
                funktion=self.get_vl(row.function__REL),
                anlagenummer=row.installation_number,
                fernueberwachung=self.get_vl(row.remote_monitoring__REL),
            )
            self.abwasser_session.add(klara)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_farm(self):
        query = self.tww_session.query(self.model_classes_tww_od.farm)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.farm.obj_id.in_(self.subset_ids))
        for row in query:
            landwirtschaftsbetrieb = self.model_classes_interlis.landwirtschaftsbetrieb(
                **self.vsa_base_common(row, "landwirtschaftsbetrieb"),
                # --- farm ---
                nutzflaechelandwirtschaft=row.agriculture_arable_surface,
                guellegrubebemerkung=row.cesspit_comment,
                guellegrubevolumen=self.get_vl(row.cesspit_volume__REL),
                guellegrubevolumen_ist=row.cesspit_volume_current,
                guellegrubevolumen_soll=row.cesspit_volume_nominal,
                guellegrubevolumen_sw_behandelt=row.cesspit_volume_ww_treated,
                guellegrubebewilligungsjahr=row.cesspit_year_of_approval,
                konformitaet=self.get_vl(row.conformity__REL),
                fortbestand=self.get_vl(row.continuance__REL),
                fortbestandbemerkung=row.continuance_comment,
                mistplatzflaeche_ist=row.dung_heap_area_current,
                mistplatzflaeche_soll=row.dung_heap_area_nominal,
                bemerkung=row.remark,
                hirtenhuettebemerkung=row.shepherds_hut_comment,
                hirtenhuetteegw=row.shepherds_hut_population_equivalent,
                hirtenhuetteabwasser=self.get_vl(row.shepherds_hut_wastewater__REL),
                stallvieh=self.get_vl(row.stable_cattle__REL),
                stallgrossvieheinheit_fremdvieh=row.stable_cattle_equivalent_other_cattle,
                stallgrossvieheinheit_eigenesvieh=row.stable_cattle_equivalent_own_cattle,
                gebaeudegrupperef=self.get_pk(row.fk_building_group__REL),
            )
            self.abwasser_session.add(landwirtschaftsbetrieb)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_leapingweir(self):
        query = self.tww_session.query(self.model_classes_tww_od.leapingweir)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.leapingweir.obj_id.in_(self.subset_ids))
        for row in query:
            leapingwehr = self.model_classes_interlis.leapingwehr(
                **self.vsa_base_common(row, "leapingwehr"),
                **self.overflow_common(row),
                # --- leapingweir ---
                laenge=row.length,
                oeffnungsform=self.get_vl(row.opening_shape__REL),
                breite=row.width,
            )
            self.abwasser_session.add(leapingwehr)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measure(self):
        query = self.tww_session.query(self.model_classes_tww_od.measure)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.measure.obj_id.in_(self.subset_ids))
        for row in query:
            massnahme = self.model_classes_interlis.massnahme(
                **self.vsa_base_common(row, "massnahme"),
                # --- measure ---
                datum_eingang=row.date_entry,
                beschreibung=row.description,
                kategorie=self.get_vl(row.category__REL),
                bezeichnung=row.identifier,
                handlungsbedarf=row.intervention_demand,
                linie=row.line_geometry,
                verweis=row.link,
                perimeter=row.perimeter_geometry,
                prioritaet=self.get_vl(row.priority__REL),
                bemerkung=row.remark,
                astatus=self.get_vl(row.status__REL),
                symbolpos=row.symbolpos_geometry,
                gesamtkosten=row.total_cost,
                jahr_umsetzung_effektiv=row.year_implementation_effective,
                jahr_umsetzung_geplant=row.year_implementation_planned,
                traegerschaftref=row.fk_responsible_entity,
                verantwortlich_ausloesungref=row.fk_responsible_start,
            )
            self.abwasser_session.add(massnahme)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_mechanical_pretreatment(self):
        query = self.tww_session.query(self.model_classes_tww_od.mechanical_pretreatment)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.mechanical_pretreatment.obj_id.in_(self.subset_ids)
            )
        for row in query:
            mechanischevorreinigung = self.model_classes_interlis.mechanischevorreinigung(
                **self.vsa_base_common(row, "mechanischevorreinigung"),
                # --- mechanical_pretreatment ---
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                abwasserbauwerkref=self.get_pk(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(mechanischevorreinigung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measuring_device(self):
        query = self.tww_session.query(self.model_classes_tww_od.measuring_device)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.measuring_device.obj_id.in_(self.subset_ids)
            )
        for row in query:
            messgeraet = self.model_classes_interlis.messgeraet(
                **self.vsa_base_common(row, "messgeraet"),
                # --- measuring_device ---
                seriennummer=row.serial_number,
                fabrikat=row.brand,
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                messstelleref=self.get_pk(row.fk_measuring_point__REL),
            )
            self.abwasser_session.add(messgeraet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measurement_series(self):
        query = self.tww_session.query(self.model_classes_tww_od.measurement_series)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.measurement_series.obj_id.in_(self.subset_ids)
            )
        for row in query:
            messreihe = self.model_classes_interlis.messreihe(
                **self.vsa_base_common(row, "messreihe"),
                # --- measurement_series ---
                dimension=row.dimension,
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                messstelleref=self.get_pk(row.fk_measuring_point__REL),
                abwassernetzelementref=self.get_pk(row.fk_wastewater_networkelement__REL),
            )
            self.abwasser_session.add(messreihe)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measurement_result(self):
        query = self.tww_session.query(self.model_classes_tww_od.measurement_result)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.measurement_result.obj_id.in_(self.subset_ids)
            )
        for row in query:
            messresultat = self.model_classes_interlis.messresultat(
                **self.vsa_base_common(row, "messresultat"),
                # --- measurement_result ---
                bezeichnung=row.identifier,
                messart=self.get_vl(row.measurement_type__REL),
                messdauer=row.measuring_duration,
                bemerkung=row.remark,
                zeit=row.time,
                wert=row.value,
                messgeraetref=self.get_pk(row.fk_measuring_device__REL),
                messreiheref=self.get_pk(row.fk_measurement_series__REL),
            )
            self.abwasser_session.add(messresultat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measuring_point(self):
        query = self.tww_session.query(self.model_classes_tww_od.measuring_point)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.measuring_point.obj_id.in_(self.subset_ids)
            )
        for row in query:
            messstelle = self.model_classes_interlis.messstelle(
                **self.vsa_base_common(row, "messstelle"),
                # --- measuring_point ---
                zweck=row.purpose,
                bemerkung=row.remark,
                staukoerper=row.damming_device,
                bezeichnung=row.identifier,
                art=row.kind,
                lage=row.situation_geometry,
                betreiberref=row.fk_operator,
                abwasserreinigungsanlageref=self.get_pk(row.fk_waste_water_treatment_plant__REL),
                abwasserbauwerkref=self.get_pk(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(messstelle)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_mutation(self):
        query = self.tww_session.query(self.model_classes_tww_od.mutation)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.mutation.obj_id.in_(self.subset_ids))
        for row in query:
            mutation = self.model_classes_interlis.mutation(
                **self.vsa_base_common(row, "mutation"),
                # --- mutation ---
                attribut=row.attribute,
                klasse=row.classname,
                mutationsdatum=row.date_mutation,
                aufnahmedatum=row.date_time,
                art=self.get_vl(row.kind__REL),
                letzter_wert=row.last_value,
                objekt=row.object,
                aufnehmer=row.recorded_by,
                bemerkung=row.remark,
                systembenutzer=row.system_user,
            )
            self.abwasser_session.add(mutation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_reservoir(self):
        query = self.tww_session.query(self.model_classes_tww_od.reservoir)
        if self.filtered:
            query = query.filter(self.model_classes_tww_od.reservoir.obj_id.in_(self.subset_ids))
        for row in query:
            reservoir = self.model_classes_interlis.reservoir(
                **self.vsa_base_common(row, "reservoir"),
                **self.connection_object_common(row),
                # --- reservoir ---
                standortname=row.location_name,
                lage=row.situation_geometry,
            )
            self.abwasser_session.add(reservoir)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_retention_body(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            retentionskoerper = self.model_classes_interlis.retentionskoerper(
                **self.vsa_base_common(row, "retentionskoerper"),
                # --- retention_body ---
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                retention_volumen=row.volume,
                versickerungsanlageref=self.get_pk(row.fk_infiltration_installation__REL),
            )
            self.abwasser_session.add(retentionskoerper)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_profile_geometry(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            rohrprofil_geometrie = self.model_classes_interlis.rohrprofil_geometrie(
                **self.vsa_base_common(row, "rohrprofil_geometrie"),
                # --- profile_geometry ---
                reihenfolge=row.sequence,
                x=row.x,
                y=row.y,
                rohrprofilref=self.get_pk(row.fk_pipe_profile__REL),
            )
            self.abwasser_session.add(rohrprofil_geometrie)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_backflow_prevention(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            rueckstausicherung = self.model_classes_interlis.rueckstausicherung(
                **self.vsa_base_common(row, "rueckstausicherung"),
                **self.structure_part_common(row),
                # --- backflow_prevention ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
                fk_throttle_shut_off_unit=self.get_pk(row.absperr_drosselorganref),
                fk_pump=self.get_pk(row.foerderaggregatref),
            )
            self.abwasser_session.add(rueckstausicherung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_log_card(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            stammkarte = self.model_classes_interlis.stammkarte(
                **self.vsa_base_common(row, "stammkarte"),
                # --- log_card ---
                steuerung_fernwirkung=self.get_vl(row.control_remote_control__REL),
                informationsquelle=self.get_vl(row.information_source__REL),
                sachbearbeiter=row.person_in_charge,
                bemerkung=row.remark,
                paa_knotenref=self.get_pk(row.fk_pwwf_wastewater_node__REL),
                bueroref=row.fk_agency,
                standortgemeinderef=row.fk_location_municipality,
            )
            self.abwasser_session.add(stammkarte)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_prank_weir(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            streichwehr = self.model_classes_interlis.streichwehr(
                **self.vsa_base_common(row, "streichwehr"),
                **self.overflow_common(row),
                # --- prank_weir ---
                hydrueberfalllaenge=row.hydraulic_overflow_length,
                kotemax=row.level_max,
                kotemin=row.level_min,
                ueberfallkante=self.get_vl(row.weir_edge__REL),
                wehr_art=self.get_vl(row.weir_kind__REL),
            )
            self.abwasser_session.add(streichwehr)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_overflow_char(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            ueberlaufcharakteristik = self.model_classes_interlis.ueberlaufcharakteristik(
                **self.vsa_base_common(row, "ueberlaufcharakteristik"),
                # --- overflow_char ---
                bezeichnung=row.identifier,
                kennlinie_typ=self.get_vl(row.kind_overflow_char__REL),
                bemerkung=row.remark,
            )
            self.abwasser_session.add(ueberlaufcharakteristik)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_maintenance(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            unterhalt = self.model_classes_interlis.unterhalt(
                **self.vsa_base_common(row, "unterhalt"),
                **self.maintenance_event_common(row),
                # --- maintenance ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(unterhalt)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infiltration_zone(self):
        query = self.tww_session.query(self.model_classes_tww_od.control_center)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.control_center.obj_id.in_(self.subset_ids)
            )
        for row in query:
            versickerungsbereich = self.model_classes_interlis.versickerungsbereich(
                **self.vsa_base_common(row, "versickerungsbereich"),
                **self.zone_common(row),
                # --- infiltration_zone ---
                art=self.get_vl(row.kind__REL),
                versickerungsmoeglichkeit=self.get_vl(row.infiltration_capacity__REL),
                perimeter=row.perimeter_geometry,
            )
            self.abwasser_session.add(versickerungsbereich)
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
            untersuchung = self.model_classes_interlis.untersuchung(
                # --- baseclass ---
                **self.vsa_base_common(row, "untersuchung"),
                # --- erhaltungsereignis ---
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
            normschachtschaden = self.model_classes_interlis.normschachtschaden(
                # FIELDS TO MAP TO ABWASSER.normschachtschaden
                # --- baseclass ---
                # --- sia405_baseclass ---
                **self.vsa_base_common(row, "normschachtschaden"),
                # --- schaden ---
                anmerkung=row.comments,
                ansichtsparameter=row.view_parameters,
                untersuchungref=self.get_tid(row.fk_examination__REL),
                verbindung=self.get_vl(row.connection__REL),
                videozaehlerstand=row.video_counter,
                # --- normschachtschaden ---
                distanz=row.manhole_channel_distance,
                quantifizierung1=row.manhole_quantification1,
                quantifizierung2=row.manhole_quantification2,
                schachtbereich=self.get_vl(row.manhole_shaft_area__REL),
                schachtschadencode=self.get_vl(row.manhole_damage_code__REL),
                schadenlageanfang=row.manhole_damage_begin,
                schadenlageende=row.manhole_damage_end,
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
                distanz=row.channel_distance,
                kanalschadencode=self.get_vl(row.channel_damage_code__REL),
                quantifizierung1=row.channel_quantification1,
                quantifizierung2=row.channel_quantification2,
                schadenlageanfang=row.channel_damage_begin,
                schadenlageende=row.channel_damage_end,
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
            datei = self.model_classes_interlis.datei(
                # FIELDS TO MAP TO ABWASSER.datei
                # --- vsa_baseclass ---
                **self.vsa_base_common(row, "datei"),
                # --- datei ---
                art=self.get_vl(row.kind__REL) or "andere",
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                datentraegerref=self.get_tid(row.fk_data_media__REL),
                klasse=self.get_vl_by_code(self.model_classes_tww_vl.file_class, row.class_column),
                objekt=self.null_to_emptystr(row.object),
                relativpfad=row.path_relative,
            )
            self.abwasser_session.add(datei)
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

    def get_vl_by_code(self, vl_table, vl_code):
        instance = self.tww_session.query(vl_table).filter(vl_table.code == vl_code).first()
        if instance is None:
            logger.warning(
                f'Could not find code `{vl_code}` in value list "{vl_table.__table__.schema}.{vl_table.__name__}". Setting to None instead.'
            )
            return None

        return instance.value_de

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

    def _modulo_angle(self, val):
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
        base = {
            "t_ili_tid": row.obj_id,
            "t_type": type_name,
            "t_id": self.get_tid(row),
        }
        if self.current_basket:
            base["t_basket"] = self.current_basket.t_id

        return base

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
        if datenherrref is None:
            raise InterlisExporterToIntermediateSchemaError(
                f"Invalid dataowner reference for object '{row.obj_id}' of type '{type_name}'"
            )

        datenlieferantref = self.get_tid(row.fk_provider__REL)
        if datenlieferantref is None:
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
        if eigentuemerref is None:
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

    def _textpos_common(self, row, t_type, geojson_crs_def):
        """
        Returns common attributes for textpos
        """
        t_id = self.tid_maker.next_tid()

        return {
            "t_id": t_id,
            "t_type": t_type,
            "t_ili_tid": f"ch080txtPR0000{t_id}",
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
            "textori": self._modulo_angle(row["properties"]["LabelRotation"]),
            "texthali": "Left",  # can be Left/Center/Right
            "textvali": "Bottom",  # can be Top,Cap,Half,Base,Bottom
            # --- SIA405_TextPos ---
            "plantyp": row["properties"]["scale"],
            "textinhalt": row["properties"]["LabelText"],
            "bemerkung": None,
        }

    def _export_label_positions(self):
        logger.info(f"Exporting label positions from {self.labels_file}")

        # Get t_id by obj_name to create the reference on the labels below
        tid_for_obj_id = {
            "vw_tww_reach": {},
            "vw_tww_wastewater_structure": {},
            "catchment_area": {},
        }
        for row in self.abwasser_session.query(self.model_classes_interlis.haltung):
            tid_for_obj_id["vw_tww_reach"][row.t_ili_tid] = row.t_id
        for row in self.abwasser_session.query(self.model_classes_interlis.abwasserbauwerk):
            tid_for_obj_id["vw_tww_wastewater_structure"][row.t_ili_tid] = row.t_id
        for row in self.abwasser_session.query(self.model_classes_interlis.einzugsgebiet):
            tid_for_obj_id["catchment_area"][row.t_ili_tid] = row.t_id

        with open(self.labels_file) as labels_file_handle:
            labels = json.load(labels_file_handle)

        geojson_crs_def = labels["crs"]

        for label in labels["features"]:
            layer_name = label["properties"]["Layer"]
            obj_id = label["properties"]["tww_obj_id"]

            print(f"label[properties]: {label['properties']}")

            if self.subset_ids and obj_id not in self.subset_ids:
                logger.warning(
                    f"Label for {layer_name} `{obj_id}` exists, but that object is not part of the export"
                )
                continue

            if not label["properties"]["LabelText"]:
                logger.warning(
                    f"Label of object '{obj_id}' from layer '{layer_name}' is empty and will not be exported"
                )
                continue

            t_id = tid_for_obj_id.get(layer_name, {}).get(obj_id, None)
            if not t_id:
                logger.warning(
                    f"Label for '{layer_name}' '{obj_id}' exists, but that object is not part of the export"
                )
                continue

            if layer_name == "vw_tww_reach":
                ili_label = self.model_classes_interlis.haltung_text(
                    **self._textpos_common(label, "haltung_text", geojson_crs_def),
                    haltungref=t_id,
                )

            elif layer_name == "vw_tww_wastewater_structure":
                ili_label = self.model_classes_interlis.abwasserbauwerk_text(
                    **self._textpos_common(label, "abwasserbauwerk_text", geojson_crs_def),
                    abwasserbauwerkref=t_id,
                )

            elif layer_name == "catchment_area":
                ili_label = self.model_classes_interlis.einzugsgebiet_text(
                    **self._textpos_common(label, "einzugsgebiet_text", geojson_crs_def),
                    einzugsgebietref=t_id,
                )

            else:
                logger.warning(
                    f"Unknown layer `{layer_name}` for label with id '{obj_id}'. Label will be ignored",
                )
                continue

            self.abwasser_session.add(ili_label)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def close_sessions(self):
        self.tww_session.close()
        self.abwasser_session.close()

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()
