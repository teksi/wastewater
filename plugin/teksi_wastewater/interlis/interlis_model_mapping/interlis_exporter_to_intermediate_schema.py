import json
import re

from geoalchemy2.functions import ST_Force2D, ST_GeomFromGeoJSON
from sqlalchemy import nullslast, or_
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from ...utils.plugin_utils import logger
from .. import config, utils


class InterlisExporterToIntermediateSchemaError(Exception):
    pass


class InterlisExporterToIntermediateSchema:
    def __init__(
        self,
        model,
        model_classes_interlis,
        model_classes_tww_od,
        model_classes_tww_vl,
        model_classes_tww_sys,
        model_classes_tww_app=None,
        labels_orientation_offset=90,
        selection=None,
        labels_file=None,
        basket_enabled=False,
        callback_progress_done=None,
        use_vsacode=True,
    ):
        """
        Export data from the TWW model into the ili2pg model.

        Args:
            selection:      if provided, limits the export to networkelements that are provided in the selection
        """
        self.model = model
        self.is_ag_xx_model = model in [config.MODEL_NAME_AG64, config.MODEL_NAME_AG96]
        self.callback_progress_done = callback_progress_done

        # Filtering
        self.filtered = False
        if selection:
            self.filtered = True

        self.subset_ids = selection if selection is not None else []

        self.labels_file = labels_file
        self.use_vsacode = use_vsacode
        self.oid_prefix = None

        self.basket_enabled = basket_enabled

        self.model_classes_interlis = model_classes_interlis
        self.model_classes_tww_od = model_classes_tww_od
        self.model_classes_tww_vl = model_classes_tww_vl
        self.model_classes_tww_sys = model_classes_tww_sys
        self.model_classes_tww_app = model_classes_tww_app
        self.labels_orientation_offset = labels_orientation_offset

        self.tww_session = None
        self.abwasser_session = None
        self.tid_maker = utils.ili2db.TidMaker(id_attribute="obj_id")

        self.current_basket = None
        self.basket_topic_sia405_administration = None
        self.basket_topic_sia405_abwasser = None
        self.basket_topic_dss = None
        self.basket_topic_kek = None
        self.basket_topic_ag64 = None
        self.basket_topic_ag96 = None

    def tww_export(self):
        # Logging disabled (very slow)
        self.tww_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.abwasser_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )

        # write self.subset_ids to logger.info
        if self.filtered:
            logger.info(f"Exporting selection {self.subset_ids}")

        try:
            self._export()
            self.abwasser_session.commit()
            self.close_sessions()
        except Exception as e:
            if hasattr(e, "pgcode") and e.pgcode == "23503":  # psycopg2/3
                enhanced_exc = self.parse_fk_violation(e)
            self.close_sessions()
            if enhanced_exc:
                raise enhanced_exc
            raise e

    def _export(self):
        # Allow to insert rows with cyclic dependencies at once
        self.abwasser_session.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        if self.basket_enabled:
            self._create_basket()

        self._set_tid_iterator()

        if not self.is_ag_xx_model:
            self.current_basket = self.basket_topic_sia405_administration
            self._export_sia405_abwasser_base()

            if self.model != config.MODEL_NAME_SIA405_BASE_ABWASSER:
                self._export_sia405_abwasser()

                if self.model == config.MODEL_NAME_DSS:
                    self.current_basket = self.basket_topic_dss
                    self._export_dss()

                if self.model == config.MODEL_NAME_VSA_KEK:
                    self.current_basket = self.basket_topic_kek
                    self._export_vsa_kek()

        elif self.model == config.MODEL_NAME_AG64:
            self.current_basket = self.basket_topic_ag64
            self._export_ag64()

        elif self.model == config.MODEL_NAME_AG96:
            self.current_basket = self.basket_topic_ag96
            self._export_ag96()

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

        self.basket_topic_ag64 = self.model_classes_interlis.t_ili2db_basket(
            t_id=6,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_AG64,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_ag64)

        self.basket_topic_ag96 = self.model_classes_interlis.t_ili2db_basket(
            t_id=7,
            dataset=dataset.t_id,
            topic=config.TOPIC_NAME_AG96,
            t_ili_tid=None,
            attachmentkey=dataset.datasetname,
            domains="",
        )
        self.abwasser_session.add(self.basket_topic_ag96)

        self.abwasser_session.flush()

    def _export_sia405_abwasser_base(self):
        logger.info("Exporting TWW.organisation -> ABWASSER.organisation")
        self._export_organisation()
        self._check_for_stop()

    def _export_sia405_abwasser(self):
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

        if self.model == config.MODEL_NAME_DSS:
            logger.info(
                "Exporting TWW.wastewater_node for VSA-DSS 2020 -> ABWASSER.abwasserknoten"
            )
            self._export_wastewater_node_dss()
        else:
            logger.info("Exporting TWW.wastewater_node -> ABWASSER.abwasserknoten")
            self._export_wastewater_node()
        self._check_for_stop()

        logger.info("Exporting TWW.reach -> ABWASSER.haltung")
        self._export_reach()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.reach_progression_alternative -> ABWASSER.haltung_alternativverlauf"
        )
        self._export_reach_progression_alternative()
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

        logger.info("Exporting TWW.wastewater_structure_symbol -> ABWASSER.abwasserbauwerk_symbol")
        self._export_wastewater_structure_symbol()
        self._check_for_stop()

        logger.info("Exporting TWW.flushing_nozzle -> ABWASSER.spuelstutzen")
        self._export_flushing_nozzle()
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

        logger.info(
            "Exporting TWW.re_maintenance_event_wastewater_structure -> ABWASSER.erhaltungsereignis_abwasserbauwerkassoc"
        )
        self._export_re_maintenance_event_wastewater_structure()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.re_building_group_disposal -> ABWASSER.gebaeudegruppe_entsorgungassoc"
        )
        self._export_re_building_group_disposal()
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

    def _set_tid_iterator(self):
        # set tidMaker
        max_tid = self.abwasser_session.execute(
            text("SELECT last_value from pg2ili_abwasser.t_ili2db_seq;")
        ).fetchone()
        for _ in range(max_tid.last_value + 1):
            self.tid_maker.next_tid()

    def _export_organisation(self):
        query = self.tww_session.query(self.model_classes_tww_od.organisation)
        # only export my local extension organisations if called by SIA405 Base
        if self.model == config.MODEL_NAME_SIA405_BASE_ABWASSER:
            query = query.filter(
                self.model_classes_tww_od.organisation.tww_local_extension.is_(True)
            ).all()
        for row in query:
            organisation = self.model_classes_interlis.organisation(
                # FIELDS TO MAP TO ABWASSER.organisation
                # --- sia405_baseclass ---
                **self.sia_405_base_common(row, "organisation"),
                # --- organisation ---
                auid=row.uid,
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 255),
                bezeichnung=self.null_to_emptystr(row.identifier),
                kurzbezeichnung=row.identifier_short,
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            kanal = self.model_classes_interlis.kanal(
                # FIELDS TO MAP TO ABWASSER.kanal
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "kanal"),
                # --- kanal ---
                bettung_umhuellung=self.get_vl(row.bedding_encasement__REL),
                funktionhierarchisch=self.get_vl(row.function_hierarchic__REL),
                funktionhydraulisch=self.get_vl(row.function_hydraulic__REL),
                # new attribute funktion_melioration release 2020
                funktionmelioration=self.get_vl(row.function_amelioration__REL),
                nutzungsart_geplant=self.get_vl(row.usage_planned__REL),
                nutzungsart_ist=self.get_vl(row.usage_current__REL),
                rohrlaenge=row.pipe_length,
                # new attribute sickerung release 2020
                sickerung=self.get_vl(row.seepage__REL),
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            normschacht = self.model_classes_interlis.normschacht(
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "normschacht"),
                # --- normschacht ---
                # new attribute amphibienausstieg Release 2020
                amphibienausstieg=self.get_vl(row.amphibian_exit__REL),
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                funktion=self.get_vl(row.function__REL),
                # new attribute interventionsmoeglichkeit Release 2020
                interventionsmoeglichkeit=self.get_vl(row.possibility_intervention__REL),
                # -- attribute 3D ---
                # maechtigkeit=row.depth,
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            einleitstelle = self.model_classes_interlis.einleitstelle(
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "einleitstelle"),
                # --- einleitstelle ---
                # -- attribute 3D ---
                # deckenkote=row.upper_elevation,
                # new attribute gewaesserabschnitt_kanton Release 2020
                gewaesserabschnitt_kanton=row.water_course_segment_canton,
                # new attribute gewaesserlaufnummer Release 2020
                gewaesserlaufnummer=row.water_course_number,
                hochwasserkote=row.highwater_level,
                # -- attribute 3D ---
                # maechtigkeit=row.depth,
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            spezialbauwerk = self.model_classes_interlis.spezialbauwerk(
                # FIELDS TO MAP TO ABWASSER.spezialbauwerk
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "spezialbauwerk"),
                # --- spezialbauwerk ---
                # new attribute amphibienausstieg Release 2020
                amphibienausstieg=self.get_vl(row.amphibian_exit__REL),
                bypass=self.get_vl(row.bypass__REL),
                # -- attribute 3D ---
                # deckenkote=row.upper_elevation,
                funktion=self.get_vl(row.function__REL),
                # new attribute interventionsmoeglichkeit Release 2020
                interventionsmoeglichkeit=self.get_vl(row.possibility_intervention__REL),
                # -- attribute 3D ---
                # maechtigkeit=row.depth,
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            versickerungsanlage = self.model_classes_interlis.versickerungsanlage(
                # FIELDS TO MAP TO ABWASSER.versickerungsanlage
                # --- abwasserbauwerk ---
                **self.wastewater_structure_common(row, "versickerungsanlage"),
                # --- versickerungsanlage ---
                # TODO : NOT MAPPED : upper_elevation
                art=self.get_vl(row.kind__REL),
                beschriftung=self.get_vl(row.labeling__REL),
                # -- attribute 3D ---
                # deckenkote=row.upper_elevation,
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                gwdistanz=row.distance_to_aquifer,
                # -- attribute 3D ---
                # maechtigkeit=row.depth,
                # neues attribut fuellmaterial release 2020
                fuellmaterial=self.get_vl(row.filling_material__REL),
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
            logger.info(f"Selection query: {query.statement}")

        logger.info(
            "height_width_ration rounded to 3 decimals! Change if adapted in INTERLIS VSA-DSS / SIA405 Abwasser > 2020.1"
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
                # added round as long as INTERLIS 2020.1 is used Verhaeltnis_H_B = 0.01 .. 100.00;
                hoehenbreitenverhaeltnis=self.round(row.height_width_ratio, 2),
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
            logger.info(f"Selection query: {query.statement}")
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
                # changed call from get_tid to check_fk_in_subsetid so it does not write foreignkeys on elements that do not exist
                abwassernetzelementref=self.check_fk_in_subsetid(
                    row.fk_wastewater_networkelement__REL
                ),
                auslaufform=self.get_vl(row.outlet_shape__REL),
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 80),
                bezeichnung=self.null_to_emptystr(row.identifier),
                hoehengenauigkeit=self.get_vl(row.elevation_accuracy__REL),
                kote=row.level,
                lage=ST_Force2D(row.situation3d_geometry),
                lage_anschluss=row.position_of_connection,
                # new attribute rohrverschluss_kappe release 2020
                rohrverschluss_kappe=self.get_vl(row.pipe_closure__REL),
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.wastewater_node

            # --- wastewater_networkelement ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark

            # --- wastewater_node ---

            # --- _bwrel_ ---
            # catchment_area__BWREL_fk_wastewater_networkelement_rw_current, catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, catchment_area__BWREL_fk_wastewater_networkelement_ww_current, catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, connection_object__BWREL_fk_wastewater_networkelement, hydraulic_char_data__BWREL_fk_wastewater_node, overflow__BWREL_fk_overflow_to, overflow__BWREL_fk_wastewater_node, reach_point__BWREL_fk_wastewater_networkelement, throttle_shut_off_unit__BWREL_fk_wastewater_node, wastewater_structure__BWREL_fk_main_wastewater_node

            # --- _rel_ ---
            # fk_dataowner__REL, fk_hydr_geometry__REL, fk_provider__REL, fk_wastewater_structure__REL

            abwasserknoten = self.model_classes_interlis.abwasserknoten(
                # FIELDS TO MAP TO ABWASSER.abwasserknoten
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row, "abwasserknoten"),
                # --- abwasserknoten ---
                # new attribute ara_nr release 2020
                ara_nr=row.wwtp_number,
                # new attribute funktion_knoten_melioration release 2020
                funktion_knoten_melioration=self.get_vl(row.function_node_amelioration__REL),
                # new attribute hoehengenauigkeit release 2020
                hoehengenauigkeit=self.get_vl(row.elevation_accuracy__REL),
                # new attribute hydr_geometrieref release 2020 vsa-dss, but not sia405 abwasser
                # hydr_geometrieref=self.get_tid(row.fk_hydr_geometry__REL),
                lage=ST_Force2D(row.situation3d_geometry),
                rueckstaukote_ist=row.backflow_level_current,
                sohlenkote=row.bottom_level,
            )
            self.abwasser_session.add(abwasserknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    # extra version for dss export - with hydr_geometrieref
    def _export_wastewater_node_dss(self):
        query = self.tww_session.query(self.model_classes_tww_od.wastewater_node)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.wastewater_node

            # --- wastewater_networkelement ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark

            # --- wastewater_node ---

            # --- _bwrel_ ---
            # catchment_area__BWREL_fk_wastewater_networkelement_rw_current, catchment_area__BWREL_fk_wastewater_networkelement_rw_planned, catchment_area__BWREL_fk_wastewater_networkelement_ww_current, catchment_area__BWREL_fk_wastewater_networkelement_ww_planned, connection_object__BWREL_fk_wastewater_networkelement, hydraulic_char_data__BWREL_fk_wastewater_node, overflow__BWREL_fk_overflow_to, overflow__BWREL_fk_wastewater_node, reach_point__BWREL_fk_wastewater_networkelement, throttle_shut_off_unit__BWREL_fk_wastewater_node, wastewater_structure__BWREL_fk_main_wastewater_node

            # --- _rel_ ---
            # fk_dataowner__REL, fk_hydr_geometry__REL, fk_provider__REL, fk_wastewater_structure__REL

            abwasserknoten = self.model_classes_interlis.abwasserknoten(
                # FIELDS TO MAP TO ABWASSER.abwasserknoten
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row, "abwasserknoten"),
                # --- abwasserknoten ---
                # new attribute ara_nr release 2020
                ara_nr=row.wwtp_number,
                # new attribute funktion_knoten_melioration release 2020
                funktion_knoten_melioration=self.get_vl(row.function_node_amelioration__REL),
                # new attribute hoehengenauigkeit release 2020
                hoehengenauigkeit=self.get_vl(row.elevation_accuracy__REL),
                # new attribute hydr_geometrieref release 2020
                hydr_geometrieref=self.get_tid(row.fk_hydr_geometry__REL),
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
            logger.info(f"Selection query: {query.statement}")
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

            haltung = self.model_classes_interlis.haltung(
                # FIELDS TO MAP TO ABWASSER.haltung
                # --- abwassernetzelement ---
                **self.wastewater_networkelement_common(row, "haltung"),
                # --- haltung ---
                # new attribute fliesszeit_trockenwetter release 2020
                fliesszeit_trockenwetter=row.flow_time_dry_weather,
                # -- attribute 3D ---
                #  hoehenbestimmung=self.get_vl(row.elevation_determination__REL),
                # new attribute hydr_belastung_ist release 2020
                hydr_belastung_ist=row.hydraulic_load_current,
                innenschutz=self.get_vl(row.inside_coating__REL),
                laengeeffektiv=row.length_effective,
                lagebestimmung=self.get_vl(row.horizontal_positioning__REL),
                # new attribute leckschutz release 2020
                leckschutz=self.get_vl(row.leak_protection__REL),
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

    def _export_reach_progression_alternative(self):
        query = self.tww_session.query(self.model_classes_tww_od.reach_progression_alternative)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.reach_progression_alternative.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            haltung_alternativverlauf = self.model_classes_interlis.haltung_alternativverlauf(
                **self.base_common(row, "haltung_alternativverlauf"),
                # --- haltung_alternativverlauf ---
                plantyp=self.get_vl(row.plantype__REL),
                verlauf=row.progression_geometry,
                haltungref=self.get_tid(row.fk_reach__REL),
            )
            self.abwasser_session.add(haltung_alternativverlauf)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_dryweather_downspout(self):
        query = self.tww_session.query(self.model_classes_tww_od.dryweather_downspout)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.dryweather_downspout

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- dryweather_downspout ---
            # diameter, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.access_aid

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- access_aid ---
            # kind, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.dryweather_flume

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- dryweather_flume ---
            # material, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.cover

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- cover ---
            # brand, cover_shape, diameter, fastening, level, material, obj_id, positional_accuracy, situation3d_geometry, sludge_bucket, venting

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id, wastewater_structure__BWREL_fk_main_cover

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
                # -- attribute 3D ---
                # maechtigkeit=row.depth,
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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.benching

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- benching ---
            # kind, obj_id

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

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

    def _export_wastewater_structure_symbol(self):
        query = self.tww_session.query(self.model_classes_tww_od.wastewater_structure_symbol)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            abwasserbauwerk_symbol = self.model_classes_interlis.abwasserbauwerk_symbol(
                # FIELDS TO MAP TO ABWASSER.abwasserbauwerk_symbol
                # --- abwasserbauwerk_symbol ---
                **self.base_common(row, "abwasserbauwerk_symbol"),
                plantyp=self.get_vl(row.plantype__REL),
                symbolskalierunghoch=row.symbol_scaling_height,
                symbolskalierunglaengs=row.symbol_scaling_width,
                symbolori=row.symbolori,
                symbolpos=row.symbolpos_geometry,
                abwasserbauwerkref=self.get_tid(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(abwasserbauwerk_symbol)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_flushing_nozzle(self):
        query = self.tww_session.query(self.model_classes_tww_od.flushing_nozzle)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            spuelstutzen = self.model_classes_interlis.spuelstutzen(
                # FIELDS TO MAP TO ABWASSER.spuelstutzen
                # --- bauwerksteil ---
                **self.structure_part_common(row, "spuelstutzen"),
                # --- spuelstutzen ---
                lage=row.situation_geometry,
            )
            self.abwasser_session.add(spuelstutzen)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_waste_water_treatment_plant(self):
        query = self.tww_session.query(self.model_classes_tww_od.waste_water_treatment_plant)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.waste_water_treatment_plant.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
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
                bemerkung=self.truncate(self.emptystr_to_null(row.remark), 255),
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
            logger.info(f"Selection query: {query.statement}")
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
            logger.info(f"Selection query: {query.statement}")
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
            logger.info(f"Selection query: {query.statement}")
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
            logger.info(f"Selection query: {query.statement}")
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
            query = (
                query.join(self.model_classes_tww_od.throttle_shut_off_unit)
                .join(self.model_classes_tww_od.wastewater_node)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
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
        # subclass of wastewater_structure - therefore same as eg. manhole
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
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
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
                or_(
                    self.model_classes_tww_od.wastewater_node.obj_id
                    == self.model_classes_tww_od.throttle_shut_off_unit.fk_wastewater_node,
                ),
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
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
                abwasserknotenref=self.get_tid(row.fk_wastewater_node__REL),
                steuerungszentraleref=self.get_tid(row.fk_control_center__REL),
                ueberlaufref=self.get_tid(row.fk_overflow__REL),
            )
            self.abwasser_session.add(absperr_drosselorgan)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_tank_emptying(self):
        query = self.tww_session.query(self.model_classes_tww_od.tank_emptying)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            beckenentleerung = self.model_classes_interlis.beckenentleerung(
                **self.structure_part_common(row, "beckenentleerung"),
                # --- tank_emptying ---
                leistung=row.flow,
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
                absperr_drosselorganref=self.get_tid(row.fk_throttle_shut_off_unit__REL),
                ueberlaufref=self.get_tid(row.fk_overflow__REL),
            )
            self.abwasser_session.add(beckenentleerung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_tank_cleaning(self):
        query = self.tww_session.query(self.model_classes_tww_od.tank_cleaning)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            beckenreinigung = self.model_classes_interlis.beckenreinigung(
                **self.structure_part_common(row, "beckenreinigung"),
                # --- tank_cleaning ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(beckenreinigung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_bio_ecol_assessment(self):
        query = self.tww_session.query(self.model_classes_tww_od.bio_ecol_assessment)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            biol_oekol_gesamtbeurteilung = self.model_classes_interlis.biol_oekol_gesamtbeurteilung(
                **self.maintenance_event_common(row, "biol_oekol_gesamtbeurteilung"),
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
                gewaesserart=self.get_vl(row.kind_water_body__REL),
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
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            brunnen = self.model_classes_interlis.brunnen(
                **self.connection_object_common(row, "brunnen"),
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            ezg_parameter_allg = self.model_classes_interlis.ezg_parameter_allg(
                **self.surface_runoff_parameters_common(row, "ezg_parameter_allg"),
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
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            ezg_parameter_mouse1 = self.model_classes_interlis.ezg_parameter_mouse1(
                **self.surface_runoff_parameters_common(row, "ezg_parameter_mouse1"),
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
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            einzelflaeche = self.model_classes_interlis.einzelflaeche(
                **self.connection_object_common(row, "einzelflaeche"),
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
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
                or_(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id
                    == self.model_classes_tww_od.catchment_area.fk_wastewater_networkelement_rw_planned,
                    self.model_classes_tww_od.wastewater_networkelement.obj_id
                    == self.model_classes_tww_od.catchment_area.fk_wastewater_networkelement_rw_current,
                    self.model_classes_tww_od.wastewater_networkelement.obj_id
                    == self.model_classes_tww_od.catchment_area.fk_wastewater_networkelement_ww_planned,
                    self.model_classes_tww_od.wastewater_networkelement.obj_id
                    == self.model_classes_tww_od.catchment_area.fk_wastewater_networkelement_ww_current,
                ),
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
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
                # changed call from get_tid to check_fk_in_subsetid so it does not write foreignkeys on elements that do not exist
                abwassernetzelement_rw_geplantref=self.check_fk_in_subsetid(
                    row.fk_wastewater_networkelement_rw_planned__REL
                ),
                abwassernetzelement_rw_istref=self.check_fk_in_subsetid(
                    row.fk_wastewater_networkelement_rw_current__REL
                ),
                abwassernetzelement_sw_geplantref=self.check_fk_in_subsetid(
                    row.fk_wastewater_networkelement_ww_planned__REL
                ),
                abwassernetzelement_sw_istref=self.check_fk_in_subsetid(
                    row.fk_wastewater_networkelement_ww_current__REL
                ),
                sbw_rw_geplantref=self.get_tid(row.fk_special_building_rw_planned__REL),
                sbw_rw_istref=self.get_tid(row.fk_special_building_rw_current__REL),
                sbw_sw_geplantref=self.get_tid(row.fk_special_building_ww_planned__REL),
                sbw_sw_istref=self.get_tid(row.fk_special_building_ww_current__REL),
            )
            self.abwasser_session.add(einzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_electric_equipment(self):
        query = self.tww_session.query(self.model_classes_tww_od.electric_equipment)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            elektrischeeinrichtung = self.model_classes_interlis.elektrischeeinrichtung(
                **self.structure_part_common(row, "elektrischeeinrichtung"),
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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            elektromechanischeausruestung = self.model_classes_interlis.elektromechanischeausruestung(
                **self.structure_part_common(row, "elektromechanischeausruestung"),
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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            entsorgung = self.model_classes_interlis.entsorgung(
                **self.vsa_base_common(row, "entsorgung"),
                # --- disposal ---
                entsorgungsintervall_ist=row.disposal_interval_current,
                entsorgungsintervall_soll=row.disposal_interval_nominal,
                entsorgungsort_ist=self.get_vl(row.disposal_place_current__REL),
                entsorgungsort_geplant=self.get_vl(row.disposal_place_planned__REL),
                volumenabflusslosegrube=row.volume_pit_without_drain,
                versickerungsanlageref=self.get_tid(row.fk_infiltration_installation__REL),
                einleitstelleref=self.get_tid(row.fk_discharge_point__REL),
                abwasserbauwerkref=self.get_tid(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(entsorgung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_drainage_system(self):
        query = self.tww_session.query(self.model_classes_tww_od.drainage_system)
        # no connection to sewer network - selected obj_id for drainage_system have to be added specifically
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.drainage_system.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            entwaesserungssystem = self.model_classes_interlis.entwaesserungssystem(
                **self.zone_common(row, "entwaesserungssystem"),
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
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            feststoffrueckhalt = self.model_classes_interlis.feststoffrueckhalt(
                **self.structure_part_common(row, "feststoffrueckhalt"),
                # --- solids_retention ---
                dimensionierungswert=row.dimensioning_value,
                bruttokosten=row.gross_costs,
                anspringkote=row.overflow_level,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
            )
            self.abwasser_session.add(feststoffrueckhalt)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_pump(self):
        query = self.tww_session.query(self.model_classes_tww_od.pump)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
                self.model_classes_tww_od.wastewater_node.obj_id
                == self.model_classes_tww_od.prank_weir.fk_wastewater_node,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            foerderaggregat = self.model_classes_interlis.foerderaggregat(
                **self.overflow_common(row, "foerderaggregat"),
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
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            gebaeude = self.model_classes_interlis.gebaeude(
                **self.connection_object_common(row, "gebaeude"),
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
            query = (
                query.join(self.model_classes_tww_od.re_building_group_disposal)
                .join(self.model_classes_tww_od.disposal)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
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
                # entsorgungref=self.get_tid(row.fk_disposal__REL), # TODO check why not available
                massnahmeref=self.get_tid(row.fk_measure__REL),
            )
            self.abwasser_session.add(gebaeudegruppe)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_building_group_baugwr(self):
        query = self.tww_session.query(self.model_classes_tww_od.building_group_baugwr)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.building_group)
                .join(self.model_classes_tww_od.re_building_group_disposal)
                .join(self.model_classes_tww_od.disposal)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            gebaeudegruppe_baugwr = self.model_classes_interlis.gebaeudegruppe_baugwr(
                **self.vsa_base_common(row, "gebaeudegruppe_baugwr"),
                # --- building_group_baugwr ---
                egid=row.egid,
                gebaeudegrupperef=self.get_tid(row.fk_building_group__REL),
            )
            self.abwasser_session.add(gebaeudegruppe_baugwr)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_catchment_area_totals(self):
        query = self.tww_session.query(self.model_classes_tww_od.catchment_area_totals)
        # only export catchment_area_totals if explicitly added
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.catchment_area_totals.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
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
                # discharge_point might no be in selection - therefore use check_fk_in_subsetid instead of get_tid
                einleitstelleref=self.check_fk_in_subsetid(row.fk_discharge_point__REL),
                hydr_kennwerteref=self.get_tid(row.fk_hydraulic_char_data__REL),
            )
            self.abwasser_session.add(gesamteinzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hq_relation(self):
        query = self.tww_session.query(self.model_classes_tww_od.hq_relation)
        if self.filtered:
            # just check if overflow_char exists, but no filter
            query = query.join(
                self.model_classes_tww_od.overflow_char,
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            hq_relation = self.model_classes_interlis.hq_relation(
                **self.vsa_base_common(row, "hq_relation"),
                # --- hq_relation ---
                hoehe=row.altitude,
                abfluss=row.flow,
                zufluss=row.flow_from,
                ueberlaufcharakteristikref=self.get_tid(row.fk_overflow_char__REL),
            )
            self.abwasser_session.add(hq_relation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hydr_geom_relation(self):
        query = self.tww_session.query(self.model_classes_tww_od.hydr_geom_relation)
        if self.filtered:
            # to do check if join is ok or left/right join is needed
            query = (
                query.join(self.model_classes_tww_od.hydr_geometry)
                .join(self.model_classes_tww_od.wastewater_node)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            hydr_geomrelation = self.model_classes_interlis.hydr_geomrelation(
                **self.vsa_base_common(row, "hydr_geomrelation"),
                # --- hydr_geom_relation ---
                wassertiefe=row.water_depth,
                wasseroberflaeche=row.water_surface,
                benetztequerschnittsflaeche=row.wet_cross_section_area,
                hydr_geometrieref=self.get_tid(row.fk_hydr_geometry__REL),
            )
            self.abwasser_session.add(hydr_geomrelation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_hydr_geometry(self):
        query = self.tww_session.query(self.model_classes_tww_od.hydr_geometry)
        if self.filtered:
            # to do check if join is ok or left/right join is needed
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            hydr_geometrie = self.model_classes_interlis.hydr_geometrie(
                **self.vsa_base_common(row, "hydr_geometrie"),
                # --- hydr_geometry ---
                bezeichnung=row.identifier,
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
            # side fk_overflow_char not considered in filter query
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
                or_(
                    self.model_classes_tww_od.wastewater_node.obj_id
                    == self.model_classes_tww_od.hydraulic_char_data.fk_wastewater_node,
                    self.model_classes_tww_od.wastewater_node.obj_id
                    == self.model_classes_tww_od.hydraulic_char_data.fk_primary_direction,
                ),
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            hydr_kennwerte = self.model_classes_interlis.hydr_kennwerte(
                **self.vsa_base_common(row, "hydr_kennwerte"),
                # --- hydraulic_char_data ---
                qan=row.qon,
                bemerkung=row.remark,
                astatus=self.get_vl(row.status__REL),
                aggregatezahl=row.aggregate_number,
                foerderhoehe_geodaetisch=row.delivery_height_geodaetic,
                bezeichnung=row.identifier,
                springt_an=self.get_vl(row.is_overflowing__REL),
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
                abwasserknotenref=self.get_tid(row.fk_wastewater_node__REL),
                ueberlaufcharakteristikref=self.get_tid(row.fk_overflow_char__REL),
                primaerrichtungref=self.get_tid(row.fk_primary_direction__REL),
            )
            self.abwasser_session.add(hydr_kennwerte)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_small_treatment_plant(self):
        query = self.tww_session.query(self.model_classes_tww_od.small_treatment_plant)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            klara = self.model_classes_interlis.klara(
                **self.wastewater_structure_common(row, "klara"),
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
            query = (
                query.join(self.model_classes_tww_od.building_group)
                .join(self.model_classes_tww_od.re_building_group_disposal)
                .join(self.model_classes_tww_od.disposal)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
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
                gebaeudegrupperef=self.get_tid(row.fk_building_group__REL),
            )
            self.abwasser_session.add(landwirtschaftsbetrieb)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_leapingweir(self):
        query = self.tww_session.query(self.model_classes_tww_od.leapingweir)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
                self.model_classes_tww_od.wastewater_node.obj_id
                == self.model_classes_tww_od.leapingweir.fk_wastewater_node,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            leapingwehr = self.model_classes_interlis.leapingwehr(
                **self.overflow_common(row, "leapingwehr"),
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
        # always export all measure, therefore no if self.filtered. Adding filter here needs further investigation
        # if self.filtered:
        #    query = query.filter(self.model_classes_tww_od.measure.obj_id.in_(self.subset_ids))
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
                traegerschaftref=self.get_tid(row.fk_responsible_entity__REL),
                verantwortlich_ausloesungref=self.get_tid(row.fk_responsible_start__REL),
            )
            self.abwasser_session.add(massnahme)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_mechanical_pretreatment(self):
        query = self.tww_session.query(self.model_classes_tww_od.mechanical_pretreatment)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            mechanischevorreinigung = self.model_classes_interlis.mechanischevorreinigung(
                **self.vsa_base_common(row, "mechanischevorreinigung"),
                # --- mechanical_pretreatment ---
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                abwasserbauwerkref=self.get_tid(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(mechanischevorreinigung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measuring_device(self):
        query = self.tww_session.query(self.model_classes_tww_od.measuring_device)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.measuring_point)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            messgeraet = self.model_classes_interlis.messgeraet(
                **self.vsa_base_common(row, "messgeraet"),
                # --- measuring_device ---
                seriennummer=row.serial_number,
                fabrikat=row.brand,
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                messstelleref=self.get_tid(row.fk_measuring_point__REL),
            )
            self.abwasser_session.add(messgeraet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measurement_series(self):
        query = self.tww_session.query(self.model_classes_tww_od.measurement_series)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.measuring_point)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            messreihe = self.model_classes_interlis.messreihe(
                **self.vsa_base_common(row, "messreihe"),
                # --- measurement_series ---
                dimension=row.dimension,
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                messstelleref=self.get_tid(row.fk_measuring_point__REL),
                abwassernetzelementref=self.get_tid(row.fk_wastewater_networkelement__REL),
            )
            self.abwasser_session.add(messreihe)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measurement_result(self):
        query = self.tww_session.query(self.model_classes_tww_od.measurement_result)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.measurement_series)
                .join(self.model_classes_tww_od.measuring_point)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            messresultat = self.model_classes_interlis.messresultat(
                **self.vsa_base_common(row, "messresultat"),
                # --- measurement_result ---
                bezeichnung=row.identifier,
                messart=self.get_vl(row.measurement_type__REL),
                messdauer=row.measuring_duration,
                bemerkung=row.remark,
                zeit=row.time_point,  # renamed 20250812 as time is a reserved SQL:2023 keyword
                wert=row.measurement_value,  # renamed 20250812 as value is a reserved SQL:2023 keyword
                messgeraetref=self.get_tid(row.fk_measuring_device__REL),
                messreiheref=self.get_tid(row.fk_measurement_series__REL),
            )
            self.abwasser_session.add(messresultat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_measuring_point(self):
        query = self.tww_session.query(self.model_classes_tww_od.measuring_point)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            # only filter via wastewater_networkelement, union queries need further investigation
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            messstelle = self.model_classes_interlis.messstelle(
                **self.vsa_base_common(row, "messstelle"),
                # --- measuring_point ---
                # zweck is a valuelist
                # zweck=row.purpose,
                zweck=self.get_vl(row.purpose__REL),
                bemerkung=row.remark,
                # staukoerper is a valuelist
                # staukoerper=row.damming_device,
                staukoerper=self.get_vl(row.damming_device__REL),
                bezeichnung=row.identifier,
                # here art is not a value list
                art=row.kind,
                lage=row.situation_geometry,
                betreiberref=self.get_tid(row.fk_operator__REL),
                abwasserreinigungsanlageref=self.get_tid(row.fk_waste_water_treatment_plant__REL),
                abwasserbauwerkref=self.get_tid(row.fk_wastewater_structure__REL),
            )
            self.abwasser_session.add(messstelle)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_mutation(self):
        query = self.tww_session.query(self.model_classes_tww_od.mutation)
        # only export explicitly specified mutation objects if filtered
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
                systembenutzer=row.user_system,
            )
            self.abwasser_session.add(mutation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_reservoir(self):
        query = self.tww_session.query(self.model_classes_tww_od.reservoir)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_networkelement,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            reservoir = self.model_classes_interlis.reservoir(
                **self.connection_object_common(row, "reservoir"),
                # --- reservoir ---
                standortname=row.location_name,
                lage=row.situation_geometry,
            )
            self.abwasser_session.add(reservoir)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_retention_body(self):
        query = self.tww_session.query(self.model_classes_tww_od.retention_body)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.infiltration_installation)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
        for row in query:
            retentionskoerper = self.model_classes_interlis.retentionskoerper(
                **self.vsa_base_common(row, "retentionskoerper"),
                # --- retention_body ---
                bezeichnung=row.identifier,
                art=self.get_vl(row.kind__REL),
                bemerkung=row.remark,
                retention_volumen=row.volume,
                versickerungsanlageref=self.get_tid(row.fk_infiltration_installation__REL),
            )
            self.abwasser_session.add(retentionskoerper)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_profile_geometry(self):
        query = self.tww_session.query(self.model_classes_tww_od.profile_geometry)
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.profile_geometry.obj_id.in_(self.subset_ids)
            )
        for row in query:
            rohrprofil_geometrie = self.model_classes_interlis.rohrprofil_geometrie(
                **self.vsa_base_common(row, "rohrprofil_geometrie"),
                # --- profile_geometry ---
                reihenfolge=row.sequence,
                x=row.x,
                y=row.y,
                rohrprofilref=self.get_tid(row.fk_pipe_profile__REL),
            )
            self.abwasser_session.add(rohrprofil_geometrie)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_backflow_prevention(self):
        query = self.tww_session.query(self.model_classes_tww_od.backflow_prevention)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            # AVAILABLE FIELDS IN TWW.backflow_prevention

            # --- structure_part ---
            # fk_dataowner, fk_provider, fk_wastewater_structure, identifier, last_modification, remark, renovation_demand

            # --- backflow_prevention ---
            # gross_costs, kind, obj_id, year_of_replacement

            # --- _bwrel_ ---
            # access_aid_kind__BWREL_obj_id, backflow_prevention__BWREL_obj_id, benching_kind__BWREL_obj_id, dryweather_flume_material__BWREL_obj_id, electric_equipment__BWREL_obj_id, electromechanical_equipment__BWREL_obj_id, solids_retention__BWREL_obj_id, flushing_nozzle__BWREL_obj_id, tank_cleaning__BWREL_obj_id, tank_emptying__BWREL_obj_id

            # --- _rel_ ---
            # fk_dataowner__REL, fk_provider__REL, fk_wastewater_structure__REL, renovation_demand__REL, fk_throttle_shut_off_unit__REL, fk_pump__REL

            rueckstausicherung = self.model_classes_interlis.rueckstausicherung(
                # FIELDS TO MAP TO ABWASSER.rueckstausicherung
                # --- bauwerksteil ---
                **self.structure_part_common(row, "rueckstausicherung"),
                # --- backflow_prevention ---
                bruttokosten=row.gross_costs,
                art=self.get_vl(row.kind__REL),
                ersatzjahr=row.year_of_replacement,
                absperr_drosselorganref=self.get_tid(row.fk_throttle_shut_off_unit__REL),
                foerderaggregatref=self.get_tid(row.fk_pump__REL),
            )
            self.abwasser_session.add(rueckstausicherung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_log_card(self):
        query = self.tww_session.query(self.model_classes_tww_od.log_card)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            stammkarte = self.model_classes_interlis.stammkarte(
                **self.vsa_base_common(row, "stammkarte"),
                # --- log_card ---
                steuerung_fernwirkung=self.get_vl(row.control_remote_control__REL),
                informationsquelle=self.get_vl(row.information_source__REL),
                sachbearbeiter=row.person_in_charge,
                bemerkung=row.remark,
                paa_knotenref=self.get_tid(row.fk_pwwf_wastewater_node__REL),
                bueroref=self.get_tid(row.fk_agency__REL),
                standortgemeinderef=self.get_tid(row.fk_location_municipality__REL),
            )
            self.abwasser_session.add(stammkarte)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_prank_weir(self):
        query = self.tww_session.query(self.model_classes_tww_od.prank_weir)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_od.wastewater_node,
                self.model_classes_tww_od.wastewater_node.obj_id
                == self.model_classes_tww_od.prank_weir.fk_wastewater_node,
            ).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            streichwehr = self.model_classes_interlis.streichwehr(
                **self.overflow_common(row, "streichwehr"),
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
        query = self.tww_session.query(self.model_classes_tww_od.overflow_char)
        # always export all overflow_char datasets
        if self.filtered:
            logger.info(f"Selection query: {query.statement}")
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
        query = self.tww_session.query(self.model_classes_tww_od.maintenance)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.re_maintenance_event_wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            unterhalt = self.model_classes_interlis.unterhalt(
                **self.maintenance_event_common(row, "unterhalt"),
                # --- maintenance ---
                art=self.get_vl(row.kind__REL),
            )
            self.abwasser_session.add(unterhalt)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infiltration_zone(self):
        query = self.tww_session.query(self.model_classes_tww_od.infiltration_zone)
        # no connection to sewer network - selected obj_id for infiltration_zone have to be added specifically
        if self.filtered:
            query = query.filter(
                self.model_classes_tww_od.infiltration_zone.obj_id.in_(self.subset_ids)
            )
        for row in query:
            versickerungsbereich = self.model_classes_interlis.versickerungsbereich(
                **self.zone_common(row, "versickerungsbereich"),
                # --- infiltration_zone ---
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
            logger.info(f"Selection query: {query.statement}")
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
            logger.info(f"Selection query: {query.statement}")
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
                distanz=row.manhole_distance,
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
            logger.info(f"Selection query: {query.statement}")
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
                streckenschaden=row.line_damage,
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
        if self.filtered:
            logger.info(f"Selection query: {query.statement}")
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
            logger.info(f"Selection query: {query.statement}")
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
                klasse=self.get_vl_by_code(
                    self.model_classes_tww_vl.file_classname, row.classname
                ),
                objekt=self.null_to_emptystr(row.object),
                relativpfad=row.path_relative,
            )
            self.abwasser_session.add(datei)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_re_maintenance_event_wastewater_structure(self):
        query = self.tww_session.query(
            self.model_classes_tww_od.re_maintenance_event_wastewater_structure
        )
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:

            # Before exporting the relation object, check that it use one sublclass of maintenance_event
            # supported by DSS
            maintenance_event_obj_id = row.fk_maintenance_event
            dss_supported = False

            subclass_object = (
                self.tww_session.query(self.model_classes_tww_od.maintenance)
                .filter(self.model_classes_tww_od.maintenance.obj_id == maintenance_event_obj_id)
                .first()
            )
            if subclass_object is not None:
                dss_supported = True

            subclass_object = (
                self.tww_session.query(self.model_classes_tww_od.bio_ecol_assessment)
                .filter(
                    self.model_classes_tww_od.bio_ecol_assessment.obj_id
                    == maintenance_event_obj_id
                )
                .first()
            )
            if not dss_supported and subclass_object is not None:
                dss_supported = True

            if not dss_supported:
                continue

            erhaltungsereignis_abwasserbauwerkassoc = self.model_classes_interlis.erhaltungsereignis_abwasserbauwerkassoc(
                # FIELDS TO MAP TO ABWASSER.erhaltungsereignis_abwasserbauwerkassoc
                # this class does not inherit vsa_base_common
                # --- erhaltungsereignis_abwasserbauwerkassoc ---
                abwasserbauwerkref=self.get_tid(row.fk_wastewater_structure__REL),
                erhaltungsereignis_abwasserbauwerkassocref=self.get_tid(
                    row.fk_maintenance_event__REL
                ),
            )
            self.abwasser_session.add(erhaltungsereignis_abwasserbauwerkassoc)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_re_building_group_disposal(self):
        query = self.tww_session.query(self.model_classes_tww_od.re_building_group_disposal)
        if self.filtered:
            query = (
                query.join(self.model_classes_tww_od.disposal)
                .join(self.model_classes_tww_od.wastewater_structure)
                .join(self.model_classes_tww_od.wastewater_networkelement)
                .filter(
                    self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
                )
            )
            logger.info(f"Selection query: {query.statement}")
        for row in query:
            gebaeudegruppe_entsorgungassoc = self.model_classes_interlis.gebaeudegruppe_entsorgungassoc(
                # FIELDS TO MAP TO ABWASSER.gebaeudegruppe_entsorgungassoc
                # --- baseclass ---
                # --- sia405_baseclass ---
                # this class does not inherit vsa_base_common
                # **self.vsa_base_common(row, "gebaeudegruppe_entsorgungassoc"),
                # --- gebaeudegruppe_entsorgungassoc ---
                entsorgungref=self.get_tid(row.fk_disposal__REL),
                gebaeudegruppe_entsorgungassocref=self.get_tid(row.fk_building_group__REL),
            )
            self.abwasser_session.add(gebaeudegruppe_entsorgungassoc)
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
        elif relation.code == relation.vsacode:
            return relation.value_de
        elif self.use_vsacode:
            # use vsacode instead of code

            vsacode_value_de = self.get_vl_by_code(
                self.model_classes_tww_vl.value_list_base, relation.vsacode
            )
            if vsacode_value_de is None:
                logger.warning(
                    f"Code {relation.code}: Usage of vsacode returned none. Falling back to {relation.value_de}. This will probably cause validation errors",
                )
                return relation.value_de
            return vsacode_value_de
        else:  # value list extension for other type
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

    def round(self, val, digits):
        """
        Rounds val to the provided digits (extra function that can deal also with None)
        """
        if val is None:
            return None
        else:
            if digits is None:
                return round(val)
            else:
                return round(val, digits)

    def _modulo_angle(self, val):
        """
        Returns an angle between 0 and 359.9 (for Orientierung in Base_d-20181005.ili)
        """
        if val is None:
            return None

        # add labels_orientation_offset
        val = val + self.labels_orientation_offset

        val = val % 360.0
        if val > 359.9:
            val = 0
        return val

    #    def check_fk_in_subsetid (self, subset, relation):
    def check_fk_in_subsetid(self, relation):
        """
        checks, whether foreignkey is in the subset_ids - if yes it return the tid of the foreignkey, if no it will return None
        """
        # first check for None, as is get_tid
        if relation is None:
            return None

        # only if self.filtered
        if self.filtered:
            # logger.info(f"check_fk_in_subsetid -  Subset ID's '{self.subset}'")
            logger.info(f"check_fk_in_subsetid -  Subset ID's '{self.subset_ids}'")
            # get the value of the fk_ attribute as str out of the relation to be able to check whether it is in the subset
            fremdschluesselstr = getattr(relation, "obj_id")
            logger.info(f"check_fk_in_subsetid -  fremdschluesselstr '{fremdschluesselstr}'")

            # if fremdschluesselstr in self.subset:
            if fremdschluesselstr in self.subset_ids:
                logger.info(f"check_fk_in_subsetid - '{fremdschluesselstr}' is in subset ")
                logger.info(
                    f"check_fk_in_subsetid - tid = '{self.tid_maker.tid_for_row(relation)}' "
                )
                # return tid_maker.tid_for_row(relation)
                return self.tid_maker.tid_for_row(relation)
            else:
                logger.info(
                    f"check_fk_in_subsetid - '{fremdschluesselstr}' is not in subset - replaced with None instead!"
                )
                return None
        else:
            # Makes a tid for a relation, like in get_tid
            logger.info(
                f"check_fk_in_subsetid not filtered - give back tid = '{self.tid_maker.tid_for_row(relation)}'"
            )
            return self.tid_maker.tid_for_row(relation)

    def get_oid_prefix(self, oid_table):
        instance = self.tww_session.query(oid_table).filter(oid_table.active.is_(True)).first()
        if instance is None:
            logger.warning(
                f'Could not find an active entry in table"{oid_table.__table__.schema}.{oid_table.__name__}". \
                Returning an empty string, which will lead to INTERLIS Errors. \
                Set the value that you want to use as prefix to \'active\' in table"{oid_table.__table__.schema}.{oid_table.__name__}" \
                to avoid this issue.'
            )
            return ""

        return instance.prefix

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
            # new attribute dringlichkeitszahl Release 2020
            "dringlichkeitszahl": row.urgency_figure,
            "eigentuemerref": eigentuemerref,
            "ersatzjahr": row.year_of_replacement,
            "finanzierung": self.get_vl(row.financing__REL),
            # new attribute hauptdeckelref Release 2020
            "hauptdeckelref": self.get_tid(row.fk_main_cover__REL),
            # -- attribute 3D ---
            # "hoehenbestimmung": self.get_vl(row.elevation_determination__REL),
            "inspektionsintervall": row.inspection_interval,
            "sanierungsbedarf": self.get_vl(row.renovation_necessity__REL),
            "standortname": row.location_name,
            "subventionen": row.subsidies,
            "wbw_basisjahr": row.rv_base_year,
            "wbw_bauart": self.get_vl(row.rv_construction_type__REL),
            "wiederbeschaffungswert": row.replacement_value,
            "zugaenglichkeit": self.get_vl(row.accessibility__REL),
            # new attribute zustandserhebung_jahr Release 2020
            "zustandserhebung_jahr": row.status_survey_year,
            # new attribute condition_score Release 2020
            "zustandsnote": row.condition_score,
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

    def maintenance_event_common(self, row, type_name):
        """
        Returns common attributes for maintenance_event
        """
        maintenance_event = {
            **self.vsa_base_common(row, type_name),
            "ausfuehrender": row.operator,
            "bemerkung": row.remark,
            "bezeichnung": row.identifier,
            "datengrundlage": row.base_data,
            "dauer": row.duration,
            "detaildaten": row.data_details,
            "ergebnis": row.result,
            "grund": row.reason,
            "kosten": row.cost,
            "astatus": self.get_vl(row.status__REL),
            "zeitpunkt": row.time_point,
            "ausfuehrende_firmaref": self.get_tid(row.fk_operating_company__REL),
            "massnahmeref": self.get_tid(row.fk_measure__REL),
        }

        if self.model == config.MODEL_NAME_VSA_KEK:
            query = self.tww_session.query(
                self.model_classes_tww_od.re_maintenance_event_wastewater_structure
            ).where(
                self.model_classes_tww_od.re_maintenance_event_wastewater_structure.fk_maintenance_event
                == row.obj_id
            )
            for assoc_row in query:
                abwasserbauwerkref = maintenance_event.get("abwasserbauwerkref", None)
                if abwasserbauwerkref is not None:
                    logger.warning(
                        f"Maintenance event '{row.obj_id}' is associated with multiple wastewater structures, but only the first will be exported: '{abwasserbauwerkref}'. This is a limitation of the KEK model."
                    )
                    break

                maintenance_event["abwasserbauwerkref"] = self.get_tid(
                    assoc_row.fk_wastewater_structure__REL
                )

        return maintenance_event

    def connection_object_common(self, row, type_name):
        """
        Returns common attributes for connection_object
        """
        return {
            **self.vsa_base_common(row, type_name),
            "bezeichnung": row.identifier,
            "bemerkung": row.remark,
            "fremdwasseranfall": row.sewer_infiltration_water_production,
            # added check_fk_in_subsetid instead of get_tid to make sure on if filtered we do not write missing fk_wastewater_networkelement
            "abwassernetzelementref": self.check_fk_in_subsetid(
                row.fk_wastewater_networkelement__REL
            ),
        }

    def surface_runoff_parameters_common(self, row, type_name):
        """
        Returns common attributes for surface_runoff_parameters
        """
        return {
            **self.vsa_base_common(row, type_name),
            "verdunstungsverlust": row.evaporation_loss,
            "bezeichnung": row.identifier,
            "versickerungsverlust": row.infiltration_loss,
            "bemerkung": row.remark,
            "muldenverlust": row.surface_storage,
            "benetzungsverlust": row.wetting_loss,
            "einzugsgebietref": self.get_tid(row.fk_catchment_area__REL),
        }

    def zone_common(self, row, type_name):
        """
        Returns common attributes for zone
        """
        return {
            **self.vsa_base_common(row, type_name),
            "bemerkung": row.remark,
            "bezeichnung": row.identifier,
        }

    def overflow_common(self, row, type_name):
        """
        Returns common attributes for overflow
        """
        return {
            **self.vsa_base_common(row, type_name),
            "bezeichnung": row.identifier,
            "bemerkung": row.remark,
            "antrieb": self.get_vl(row.actuation__REL),
            "verstellbarkeit": self.get_vl(row.adjustability__REL),
            "fabrikat": row.brand,
            "steuerung": self.get_vl(row.control__REL),
            "einleitstelle": row.discharge_point,
            "funktion": self.get_vl(row.function__REL),
            "bruttokosten": row.gross_costs,
            "qan_dim": row.qon_dim,
            "signaluebermittlung": self.get_vl(row.signal_transmission__REL),
            "subventionen": row.subsidies,
            "abwasserknotenref": self.get_tid(row.fk_wastewater_node__REL),
            "ueberlaufnachref": self.get_tid(row.fk_overflow_to__REL),
            "ueberlaufcharakteristikref": self.get_tid(row.fk_overflow_char__REL),
            "steuerungszentraleref": self.get_tid(row.fk_control_center__REL),
        }

    # def _textpos_common(self, row, t_type, geojson_crs_def, shortcut_en, oid_prefix):
    def _textpos_common(self, row, t_type, geojson_crs_def, shortcut_en, oid_prefix, plantyp):
        """
        Returns common attributes for textpos
        """
        t_id = self.tid_maker.next_tid()
        if t_id > 999999:
            logger.warning(
                f"Exporting more than 999999 labels will generate invalid OIDs. Currently exporting {t_id} label of type '{t_type}'."
            )

        return {
            "t_id": t_id,
            "t_type": t_type,
            "t_ili_tid": f"{oid_prefix}{shortcut_en}{t_id:06d}",
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
            # "plantyp": row["properties"]["scale"],
            "plantyp": plantyp,
            "textinhalt": row["properties"]["LabelText"],
            "bemerkung": None,
        }

    def _export_label_positions(self):
        logger.info(f"Exporting label positions from {self.labels_file}")

        # get oid prefix
        self.oid_prefix = self.get_oid_prefix(self.model_classes_tww_sys.oid_prefixes)
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

        if self.model in [config.MODEL_NAME_DSS, config.MODEL_NAME_AG96]:
            for row in self.abwasser_session.query(self.model_classes_interlis.einzugsgebiet):
                tid_for_obj_id["catchment_area"][row.t_ili_tid] = row.t_id

        if self.model == config.MODEL_NAME_AG96:
            tid_for_obj_id.update(
                {
                    "building_group": {},
                    "measure_line": {},
                    "measure_point": {},
                    "measure_polygon": {},
                }
            )
            for row in self.abwasser_session.query(
                self.model_classes_interlis.bautenausserhalbbaugebiet
            ):
                tid_for_obj_id["building_group"][row.t_ili_tid] = row.t_id

            for row in self.abwasser_session.query(self.model_classes_interlis.gepmassnahme):
                tid_for_obj_id["measure_line"][row.t_ili_tid] = row.t_id
                tid_for_obj_id["measure_point"][row.t_ili_tid] = row.t_id
                tid_for_obj_id["measure_polygon"][row.t_ili_tid] = row.t_id

        with open(self.labels_file) as labels_file_handle:
            labels = json.load(labels_file_handle)

        geojson_crs_def = labels["crs"]

        for label in labels["features"]:
            layer_name = label["properties"]["Layer"]
            obj_id = label["properties"]["tww_obj_id"]

            print(f"label[properties]: {label['properties']}")

            if self.subset_ids and obj_id not in self.subset_ids:
                logger.warning(
                    f"Label for {layer_name} `{obj_id}` exists, but that object is not part of the subset export"
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

            # Adapt plantype if subtype of Werkplan as VSA-DSS does not yet supports subvalues.
            plantyp = (label["properties"]["scale"],)
            # ('Werkplan.500',)
            plantyp_short = str(plantyp)
            plantyp_short = plantyp_short[2:10]
            logger.debug(f"Debug Plantyp_short: '{plantyp_short}'")
            if plantyp_short == "Werkplan":
                plantyp = "Werkplan"
                logger.debug(f"Debug Plantyp adapted '{plantyp}'")
            else:
                logger.debug(f"Debug Plantyp not adapted '{plantyp}'")

            if not self.is_ag_xx_model:
                if layer_name == "vw_tww_reach":
                    ili_label = self.model_classes_interlis.haltung_text(
                        **self._textpos_common(
                            # label, "haltung_text", geojson_crs_def, "RX", self.oid_prefix
                            label,
                            "haltung_text",
                            geojson_crs_def,
                            "RX",
                            self.oid_prefix,
                            plantyp,
                        ),
                        haltungref=t_id,
                    )

                elif layer_name == "vw_tww_wastewater_structure":
                    ili_label = self.model_classes_interlis.abwasserbauwerk_text(
                        **self._textpos_common(
                            # label, "abwasserbauwerk_text", geojson_crs_def, "WX", self.oid_prefix
                            label,
                            "abwasserbauwerk_text",
                            geojson_crs_def,
                            "WX",
                            self.oid_prefix,
                            plantyp,
                        ),
                        abwasserbauwerkref=t_id,
                    )

                elif layer_name == "catchment_area":
                    ili_label = self.model_classes_interlis.einzugsgebiet_text(
                        **self._textpos_common(
                            # label, "einzugsgebiet_text", geojson_crs_def, "CX", self.oid_prefix
                            label,
                            "einzugsgebiet_text",
                            geojson_crs_def,
                            "CX",
                            self.oid_prefix,
                            plantyp,
                        ),
                        einzugsgebietref=t_id,
                    )
                else:
                    logger.warning(
                        f"Unknown layer `{layer_name}` for label with id '{obj_id}'. Label will be ignored",
                    )
                    continue
            else:
                if self.model == config.MODEL_NAME_AG64:
                    if layer_name == "vw_tww_reach":
                        ili_label = self.model_classes_interlis.haltung_text(
                            **self._textpos_common(
                                label,
                                "infrastrukturhaltung_text",
                                geojson_crs_def,
                                "RX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            infrastrukturhaltungref=t_id,
                        )

                    elif layer_name == "vw_tww_wastewater_structure":
                        ili_label = self.model_classes_interlis.abwasserbauwerk_text(
                            **self._textpos_common(
                                label,
                                "infrastrukturknoten_text",
                                geojson_crs_def,
                                "WX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            infrastrukturknotenref=t_id,
                        )
                    else:
                        logger.warning(
                            f"Unknown layer `{layer_name}` for label with id '{obj_id}'. Label will be ignored",
                        )
                        continue
                else:  # AG-96
                    if layer_name == "vw_tww_reach":
                        ili_label = self.model_classes_interlis.haltung_text(
                            **self._textpos_common(
                                label,
                                "gephaltung_text",
                                geojson_crs_def,
                                "RX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            gephaltungref=t_id,
                        )

                    elif layer_name == "vw_tww_wastewater_structure":
                        ili_label = self.model_classes_interlis.abwasserbauwerk_text(
                            **self._textpos_common(
                                label,
                                "gepknoten_text",
                                geojson_crs_def,
                                "WX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            gepknotenref=t_id,
                        )

                    elif layer_name == "catchment_area":
                        ili_label = self.model_classes_interlis.einzugsgebiet_text(
                            **self._textpos_common(
                                label,
                                "einzugsgebiet_text",
                                geojson_crs_def,
                                "CX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            einzugsgebietref=t_id,
                        )

                    elif layer_name == "building_group":
                        ili_label = self.model_classes_interlis.bautenausserhalbbaugebiet_text(
                            **self._textpos_common(
                                label,
                                "bautenausserhalbbaugebiet_text",
                                geojson_crs_def,
                                "BX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            bautenausserhalbbaugebietref=t_id,
                        )

                    elif layer_name == "measure_line":
                        ili_label = self.model_classes_interlis.gepmassnahme_text(
                            **self._textpos_common(
                                label,
                                "gepmassnahme_text",
                                geojson_crs_def,
                                "MX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            gepmassnahmeref=t_id,
                        )

                    elif layer_name == "measure_point":
                        ili_label = self.model_classes_interlis.gepmassnahme_text(
                            **self._textpos_common(
                                label,
                                "gepmassnahme_text",
                                geojson_crs_def,
                                "MX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            gepmassnahmeref=t_id,
                        )

                    elif layer_name == "measure_polygon":
                        ili_label = self.model_classes_interlis.gepmassnahme_text(
                            **self._textpos_common(
                                label,
                                "gepmassnahme_text",
                                geojson_crs_def,
                                "MX",
                                self.oid_prefix,
                                plantyp,
                            ),
                            gepmassnahmeref=t_id,
                        )

                    else:
                        logger.warning(
                            f"Unknown layer {layer_name} for label with id '{obj_id}'. Label will be ignored",
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

    # AG-64/96
    def _export_ag64(self):

        logger.info("Adding organisations to ABWASSER.organisation export")
        self._export_organisation_agxx()
        self._check_for_stop()

        logger.info("Exporting TWW.gepknoten -> ABWASSER.infrastrukturknoten")
        self._export_infrastrukturknoten()
        self._check_for_stop()

        logger.info("Exporting TWW.gephaltung -> ABWASSER.infrastrukturhaltung")
        self._export_infrastrukturhaltung()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.ueberlauf_foerderaggregat -> ABWASSER.ueberlauf_foerderaggregat"
        )
        self._export_ueberlauf_foerderaggregat_ag64()
        self._check_for_stop()

    def _export_ag96(self):

        logger.info("Adding organisations to ABWASSER.organisation export")
        self._export_organisation_agxx()
        self._check_for_stop()

        logger.info("Exporting TWW.gepmassnahme -> ABWASSER.gepmassnahme")
        self._export_gepmassnahme()
        self._check_for_stop()

        logger.info("Exporting TWW.gepknoten -> ABWASSER.gepknoten")
        self._export_gepknoten()
        self._check_for_stop()

        logger.info("Exporting TWW.gephaltung -> ABWASSER.gephaltung")
        self._export_gephaltung()
        self._check_for_stop()

        logger.info("Exporting TWW.einzugsgebiet -> ABWASSER.einzugsgebiet")
        self._export_einzugsgebiet()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.bautenausserhalbbaugebiet -> ABWASSER.bautenausserhalbbaugebiet"
        )
        self._export_bautenausserhalbbaugebiet()
        self._check_for_stop()

        logger.info(
            "Exporting TWW.ueberlauf_foerderaggregat -> ABWASSER.ueberlauf_foerderaggregat"
        )
        self._export_ueberlauf_foerderaggregat_ag96()
        self._check_for_stop()

        logger.info("Exporting TWW.sbw_einzugsgebiet -> ABWASSER.sbw_einzugsgebiet")
        self._export_sbw_einzugsgebiet()
        self._check_for_stop()

        logger.info("Exporting TWW.versickerungsbereichag -> ABWASSER.versickerungsbereichag")
        self._export_versickerungsbereichag()
        self._check_for_stop()

    def _export_organisation_agxx(self):
        # no export from database, but populate Obj2Tid
        query = self.tww_session.query(self.model_classes_interlis.organisation)
        for row in query:
            self.map_tid_ag_xx(row.obj_id, row.t_id)

    def _export_gepmassnahme(self):
        query = self.tww_session.query(self.model_classes_tww_app.gepmassnahme)
        for row in query:
            gepmassnahme = self.model_classes_interlis.gepmassnahme(
                **self.gep_metainformation_common_ag_xx(row, "gepmassnahme"),
                ausdehnung=row.ausdehnung,
                beschreibung=self.truncate(self.emptystr_to_null(row.beschreibung), 100),
                bezeichnung=self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
                datum_eingang=row.datum_eingang,
                gesamtkosten=row.gesamtkosten,
                handlungsbedarf=row.handlungsbedarf,
                jahr_umsetzung_effektiv=row.jahr_umsetzung_effektiv,
                jahr_umsetzung_geplant=row.jahr_umsetzung_geplant,
                kategorie=row.kategorie,
                perimeter=row.perimeter,
                prioritaetag=row.prioritaetag,
                astatus=row.status,
                symbolpos=row.symbolpos,
                verweis=row.verweis,
                traegerschaft=self.get_tid_by_obj_id(row.traegerschaft),
                verantwortlich_ausloesung=self.get_tid_by_obj_id(row.verantwortlich_ausloesung),
            )
            self.map_tid_ag_xx(row.obj_id, gepmassnahme.t_id)
            self.abwasser_session.add(gepmassnahme)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_gepknoten(self):
        query = self.knoten_query_ag_xx()
        for row in query:
            gepknoten = self.model_classes_interlis.abwasserbauwerk(  # abwasserbauwerk wegen Kompatibiltät bei Label-Export
                **self.gep_metainformation_common_ag_xx(row, "gepknoten"),
                **self.knoten_common_ag_xx(row),
                istschnittstelle=row.istschnittstelle,
                maxrueckstauhoehe=row.maxrueckstauhoehe,
                gepmassnahmeref=self.get_tid_by_obj_id(row.gepmassnahmeref),
            )
            self.map_tid_ag_xx(row.obj_id, gepknoten.t_id)
            self.abwasser_session.add(gepknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infrastrukturknoten(self):
        query = self.knoten_query_ag_xx()
        for row in query:
            gepknoten = self.model_classes_interlis.abwasserbauwerk(  # abwasserbauwerk wegen Kompatibiltät bei Label-Export
                **self.knoten_common_ag_xx(row),
                obj_id=row.obj_id,
                t_ili_tid=row.obj_id,
                t_id=self.get_tid(row),
            )
            self.map_tid_ag_xx(row.obj_id, gepknoten.t_id)
            self.abwasser_session.add(gepknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_gephaltung(self):
        query = self.haltung_query_ag_xx()
        for row in query:
            gephaltung = self.model_classes_interlis.haltung(
                **self.gep_metainformation_common_ag_xx(row, "gephaltung"),
                **self.haltung_common_ag_xx(row),
                gepmassnahmeref=self.get_tid_by_obj_id(row.gepmassnahmeref),
                hydraulischebelastung=row.hydraulischebelastung,
                lichte_breite_ist=row.lichte_breite_ist,
                lichte_breite_geplant=row.lichte_breite_geplant,
                lichte_hoehe_geplant=row.lichte_hoehe_geplant,
                nutzungsartag_geplant=row.nutzungsartag_geplant,
            )
            self.abwasser_session.add(gephaltung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infrastrukturhaltung(self):
        query = self.haltung_query_ag_xx()
        for row in query:
            gephaltung = self.model_classes_interlis.haltung(
                **self.haltung_common_ag_xx(row),
                obj_id=row.obj_id,
                t_ili_tid=row.obj_id,
                t_id=self.get_tid(row),
                lichte_breite=row.lichte_breite_ist,
            )
            self.abwasser_session.add(gephaltung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_einzugsgebiet(self):
        query = self.tww_session.query(self.model_classes_tww_app.einzugsgebiet)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_app.gepknoten,
                or_(
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.einzugsgebiet.gepknoten_rw_geplantref,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.einzugsgebiet.gepknoten_rw_istref,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.einzugsgebiet.gepknoten_sw_geplantref,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.einzugsgebiet.gepknoten_sw_istref,
                ),
            ).filter(self.model_classes_tww_app.gepknoten.obj_id.in_(self.subset_ids))

        for row in query:
            einzugsgebiet = self.model_classes_interlis.einzugsgebiet(
                **self.gep_metainformation_common_ag_xx(row, "einzugsgebiet"),
                abflussbegrenzung_geplant=row.abflussbegrenzung_geplant,
                abflussbegrenzung_ist=row.abflussbegrenzung_ist,
                abflussbeiwert_rw_geplant=row.abflussbeiwert_rw_geplant,
                abflussbeiwert_rw_ist=row.abflussbeiwert_rw_ist,
                abflussbeiwert_sw_geplant=row.abflussbeiwert_sw_geplant,
                abflussbeiwert_sw_ist=row.abflussbeiwert_sw_ist,
                befestigungsgrad_rw_geplant=row.befestigungsgrad_rw_geplant,
                befestigungsgrad_rw_ist=row.befestigungsgrad_rw_ist,
                befestigungsgrad_sw_geplant=row.befestigungsgrad_sw_geplant,
                befestigungsgrad_sw_ist=row.befestigungsgrad_sw_ist,
                bezeichnung=self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
                direkteinleitung_in_gewaesser_geplant=row.direkteinleitung_in_gewaesser_geplant,
                direkteinleitung_in_gewaesser_ist=row.direkteinleitung_in_gewaesser_ist,
                einwohnerdichte_geplant=row.einwohnerdichte_geplant,
                einwohnerdichte_ist=row.einwohnerdichte_ist,
                entwaesserungssystemag_geplant=row.entwaesserungssystemag_geplant,
                entwaesserungssystemag_ist=row.entwaesserungssystemag_ist,
                flaeche=row.flaeche,
                fremdwasseranfall_geplant=row.fremdwasseranfall_geplant,
                fremdwasseranfall_ist=row.fremdwasseranfall_ist,
                perimeter=row.perimeter,
                perimetertyp=row.perimetertyp,
                retention_geplant=row.retention_geplant,
                retention_ist=row.retention_ist,
                schmutzabwasseranfall_geplant=row.schmutzabwasseranfall_geplant,
                schmutzabwasseranfall_ist=row.schmutzabwasseranfall_ist,
                versickerung_geplant=row.versickerung_geplant,
                versickerung_ist=row.versickerung_ist,
                gepknoten_rw_geplantref=self.get_tid_by_obj_id(row.gepknoten_rw_geplantref),
                gepknoten_rw_istref=self.get_tid_by_obj_id(row.gepknoten_rw_istref),
                gepknoten_sw_geplantref=self.get_tid_by_obj_id(row.gepknoten_sw_geplantref),
                gepknoten_sw_istref=self.get_tid_by_obj_id(row.gepknoten_sw_istref),
            )
            self.abwasser_session.add(einzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_bautenausserhalbbaugebiet(self):
        query = self.tww_session.query(self.model_classes_tww_app.bautenausserhalbbaugebiet)
        for row in query:
            bautenausserhalbbaugebiet = self.model_classes_interlis.bautenausserhalbbaugebiet(
                **self.gep_metainformation_common_ag_xx(row, "bautenausserhalbbaugebiet"),
                anzstaendigeeinwohner=row.anzstaendigeeinwohner,
                arealnutzung=row.arealnutzung,
                beseitigung_haeusliches_abwasser=row.beseitigung_haeusliches_abwasser,
                beseitigung_gewerbliches_abwasser=row.beseitigung_gewerbliches_abwasser,
                beseitigung_platzentwaesserung=row.beseitigung_platzentwaesserung,
                beseitigung_dachentwaesserung=row.beseitigung_dachentwaesserung,
                bezeichnung=self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
                eigentuemeradresse=row.eigentuemeradresse,
                eigentuemername=row.eigentuemername,
                einwohnergleichwert=row.einwohnergleichwert,
                lage=row.lage,
                nummer=row.nummer,
                sanierungsbedarf=row.sanierungsbedarf,
                sanierungsdatum=row.sanierungsdatum,
                sanierungskonzept=row.sanierungskonzept,
            )
            self.abwasser_session.add(bautenausserhalbbaugebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_ueberlauf_foerderaggregat_ag96(self):
        query = self.ueberlauf_foerderaggregat_query_ag_xx()
        for row in query:
            ueberlauf_foerderaggregat = self.model_classes_interlis.ueberlauf_foerderaggregat(
                **self.gep_metainformation_common_ag_xx(row, "ueberlauf_foerderaggregat"),
                **self.ueberlauf_foerderaggregat_common_ag_xx(row),
            )
            self.abwasser_session.add(ueberlauf_foerderaggregat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_ueberlauf_foerderaggregat_ag64(self):
        query = self.ueberlauf_foerderaggregat_query_ag_xx()
        for row in query:
            ueberlauf_foerderaggregat = self.model_classes_interlis.ueberlauf_foerderaggregat(
                **self.ueberlauf_foerderaggregat_common_ag_xx(row),
                obj_id=row.obj_id,
                t_ili_tid=row.obj_id,
                t_id=self.get_tid(row),
                letzte_aenderung_wi=row.letzte_aenderung_wi,
                bemerkung_wi=self.truncate(self.emptystr_to_null(row.bemerkung_wi), 80),
            )
            self.abwasser_session.add(ueberlauf_foerderaggregat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_sbw_einzugsgebiet(self):
        query = self.tww_session.query(self.model_classes_tww_app.sbw_einzugsgebiet)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_app.gepknoten,
                or_(
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.sbw_einzugsgebiet.einleitstelleref,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.sbw_einzugsgebiet.sonderbauwerk_ref,
                ),
            ).filter(self.model_classes_tww_app.gepknoten.obj_id.in_(self.subset_ids))

        perimeter_query = text(
            """
            WITH geoms AS (
             SELECT *, ST_ForceCurve((ST_Dump(perimeter_ist)).geom) AS geom
             FROM tww_app.vw_agxx_sbw_einzugsgebiet
             WHERE ST_NumGeometries(perimeter_ist)>1
            UNION
             SELECT *, ST_ForceCurve(ST_GeometryN(perimeter_ist,1)) AS geom
             FROM tww_app.vw_agxx_sbw_einzugsgebiet
             WHERE ST_NumGeometries(perimeter_ist)=1
            )
            SELECT DISTINCT ON (obj_id) obj_id, ST_Area(geom) AS area, geom, ST_GeometryType(geom) as type
            FROM geoms
            ORDER BY obj_id, area DESC;
        """
        )
        perimeters = self.tww_session.execute(perimeter_query).fetchall()

        for row in query:
            largest_perimeter = None
            for perimeter in perimeters:
                if perimeter[0] == row.obj_id:
                    largest_perimeter = perimeter[2]
                    break

            sbw_einzugsgebiet = self.model_classes_interlis.sbw_einzugsgebiet(
                **self.gep_metainformation_common_ag_xx(row, "sbw_einzugsgebiet"),
                bezeichnung=self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
                einwohner_geplant=row.einwohner_geplant,
                einwohner_ist=row.einwohner_ist,
                flaeche_geplant=row.flaeche_geplant,
                flaeche_ist=row.flaeche_ist,
                flaeche_befestigt_geplant=row.flaeche_befestigt_geplant,
                flaeche_befestigt_ist=row.flaeche_befestigt_ist,
                flaeche_reduziert_geplant=row.flaeche_reduziert_geplant,
                flaeche_reduziert_ist=row.flaeche_reduziert_ist,
                fremdwasseranfall_geplant=row.fremdwasseranfall_geplant,
                fremdwasseranfall_ist=row.fremdwasseranfall_ist,
                perimeter_ist=largest_perimeter,
                schmutzabwasseranfall_geplant=row.schmutzabwasseranfall_geplant,
                schmutzabwasseranfall_ist=row.schmutzabwasseranfall_ist,
                einleitstelleref=self.get_tid_by_obj_id(row.einleitstelleref),
                sonderbauwerk_ref=self.get_tid_by_obj_id(row.sonderbauwerk_ref),
            )
            self.abwasser_session.add(sbw_einzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_versickerungsbereichag(self):
        query = self.tww_session.query(self.model_classes_tww_app.versickerungsbereichag)
        for row in query:
            versickerungsbereichag = self.model_classes_interlis.versickerungsbereichag(
                # --- abwasserbauwerk ---
                **self.gep_metainformation_common_ag_xx(row, "versickerungsbereichag"),
                bezeichnung=self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
                durchlaessigkeit=row.durchlaessigkeit,
                einschraenkung=row.einschraenkung,
                maechtigkeit=row.maechtigkeit,
                perimeter=row.perimeter,
                q_check=row.q_check,
                versickerungsmoeglichkeitag=row.versickerungsmoeglichkeitag,
            )
            self.abwasser_session.add(versickerungsbereichag)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def map_tid_ag_xx(self, obj_id, t_id):
        """
        Creates a t_id for a given obj_id
        """
        if hasattr(self, "obj2tId") is False:
            self.obj2tId = {}

        if obj_id not in self.obj2tId.keys():
            self.obj2tId[obj_id] = t_id

    def get_tid_by_obj_id(self, obj_id):
        """
        Returns a t_id for a given obj_id
        """
        if obj_id in self.obj2tId.keys():
            return self.obj2tId[obj_id]
        else:
            return None

    def gep_metainformation_common_ag_xx(self, row, type_name):
        return {
            **self.base_common(row, type_name),
            "bemerkung_gep": row.bemerkung_gep,
            "datenbewirtschafter_gep": self.get_tid_by_obj_id(row.datenbewirtschafter_gep),
            "letzte_aenderung_gep": row.letzte_aenderung_gep,
        }

    def knoten_query_ag_xx(self):
        """
        Returns a query for knoten
        """
        query = self.tww_session.query(self.model_classes_tww_app.gepknoten)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_app.gephaltung,
                or_(
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.gephaltung.startknoten,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.gephaltung.endknoten,
                ),
            ).filter(
                or_(
                    self.model_classes_tww_app.gephaltung.obj_id.in_(self.subset_ids),
                    self.model_classes_tww_app.gepknoten.obj_id.in_(self.subset_ids),
                )
            )

        """
        GEPKnoten werden nach Fläche sortiert hinzugefügt, damit bei der Triggerlogik
        hinter {ext_schema}.gepknoten die Verknüpfung zu anderen Abwasserbauwerken
        basierend auf einem Spatial Join implementiert werden kann.
        Dies ist relevant, da Zweitknoten der FunktionAG "andere", die innerhalb der Detailgeometrie
        eines anderen Abwasserbauwerks liegen, als Deckel importiert werden.
        """
        query.order_by(
            nullslast(self.model_classes_tww_app.gepknoten.detailgeometrie.ST_Area().asc())
        )
        return query

    def knoten_common_ag_xx(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            "ara_nr": row.ara_nr,
            "baujahr": row.baujahr,
            "baulicherzustand": row.baulicherzustand,
            "bauwerkstatus": row.bauwerkstatus,
            "bemerkung_wi": self.truncate(self.emptystr_to_null(row.bemerkung_wi), 80),
            "bezeichnung": self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
            "deckelkote": row.deckelkote,
            "detailgeometrie": row.detailgeometrie,
            "finanzierung": row.finanzierung,
            "funktionag": row.funktionag,
            "funktionhierarchisch": row.funktionhierarchisch,
            "jahr_zustandserhebung": row.jahr_zustandserhebung,
            "lage": row.lage,
            "lagegenauigkeit": row.lagegenauigkeit,
            "letzte_aenderung_wi": row.letzte_aenderung_wi,
            "sanierungsbedarf": row.sanierungsbedarf,
            "sohlenkote": row.sohlenkote,
            "zugaenglichkeit": row.zugaenglichkeit,
            "betreiber": self.get_tid_by_obj_id(row.betreiber),
            "datenbewirtschafter_wi": self.get_tid_by_obj_id(row.datenbewirtschafter_wi),
            "eigentuemer": self.get_tid_by_obj_id(row.eigentuemer),
        }

    def haltung_query_ag_xx(self):
        """
        Returns a query for ueberlauf_foerderaggregat
        """
        query = self.tww_session.query(self.model_classes_tww_app.gephaltung)
        if self.filtered:
            query = query.filter(self.model_classes_tww_app.gephaltung.obj_id.in_(self.subset_ids))

        return query

    def haltung_common_ag_xx(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            "baujahr": row.baujahr,
            "baulicherzustand": row.baulicherzustand,
            "bauwerkstatus": row.bauwerkstatus,
            "bemerkung_wi": self.truncate(self.emptystr_to_null(row.bemerkung_wi), 80),
            "betreiber": self.get_tid_by_obj_id(row.betreiber),
            "bezeichnung": self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
            "datenbewirtschafter_wi": self.get_tid_by_obj_id(row.datenbewirtschafter_wi),
            "eigentuemer": self.get_tid_by_obj_id(row.eigentuemer),
            "endknoten": self.get_tid_by_obj_id(row.endknoten),
            "finanzierung": row.finanzierung,
            "funktionhierarchisch": row.funktionhierarchisch,
            "funktionhydraulisch": row.funktionhydraulisch,
            "hoehengenauigkeit_nach": row.hoehengenauigkeit_nach,
            "hoehengenauigkeit_von": row.hoehengenauigkeit_von,
            "jahr_zustandserhebung": row.jahr_zustandserhebung,
            "kote_beginn": row.kote_beginn,
            "kote_ende": row.kote_ende,
            "laengeeffektiv": row.laengeeffektiv,
            "letzte_aenderung_wi": row.letzte_aenderung_wi,
            "lichte_hoehe_ist": row.lichte_hoehe_ist,
            "material": row.material,
            "nutzungsartag_ist": row.nutzungsartag_ist,
            "profiltyp": row.profiltyp,
            "reliner_art": row.reliner_art,
            "reliner_bautechnik": row.reliner_bautechnik,
            "reliner_material": row.reliner_material,
            "reliner_nennweite": row.reliner_nennweite,
            "sanierungsbedarf": row.sanierungsbedarf,
            "startknoten": self.get_tid_by_obj_id(row.startknoten),
            "verlauf": row.verlauf,
            "wbw_basisjahr": row.wbw_basisjahr,
            "wiederbeschaffungswert": row.wiederbeschaffungswert,
        }

    def ueberlauf_foerderaggregat_query_ag_xx(self):
        """
        Returns a query for ueberlauf_foerderaggregat
        """
        query = self.tww_session.query(self.model_classes_tww_app.ueberlauf_foerderaggregat)
        if self.filtered:
            query = query.join(
                self.model_classes_tww_app.gepknoten,
                or_(
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.ueberlauf_foerderaggregat.knotenref,
                    self.model_classes_tww_app.gepknoten.obj_id
                    == self.model_classes_tww_app.ueberlauf_foerderaggregat.knoten_nachref,
                ),
            ).filter(self.model_classes_tww_app.gepknoten.obj_id.in_(self.subset_ids))

        return query

    def ueberlauf_foerderaggregat_common_ag_xx(self, row):
        """
        Returns common attributes for ueberlauf_foerderaggregat
        """
        return {
            "art": row.art,
            "bezeichnung": self.truncate(self.emptystr_to_null(row.bezeichnung), 20),
            "knotenref": self.get_tid_by_obj_id(row.knotenref),
            "knoten_nachref": self.get_tid_by_obj_id(row.knoten_nachref),
        }

    def parse_fk_violation(self, exc: Exception) -> Exception:
        """
        Creates a new exception with the original message plus parsed details.
        """

        result = {
            "table": None,
            "column": None,
            "key": None,
            "referenced_table": None,
            "constraint": None,
        }

        error_msg = str(exc)

        table_constraint_match = re.search(
            r'insert or update on table "([^"]+)" violates foreign key constraint "([^"]+)"',
            error_msg,
        )
        if table_constraint_match:
            result["table"] = table_constraint_match.group(1)
            result["constraint"] = table_constraint_match.group(2)

        detail_match = re.search(
            r'DETAIL:\s*Key \(([^)]+)\)=\(([^)]+)\) is not present in table "([^"]+)"', error_msg
        )
        if detail_match:
            result["column"] = detail_match.group(1)
            result["key"] = detail_match.group(2)
            result["referenced_table"] = detail_match.group(3)

        if self.model in [config.MODEL_NAME_AG64, config.MODEL_NAME_AG96]:
            query = text("SELECT obj_id from pg2ili_abwasser.:table WHERE t_id= :t_id;")
            table = result["table"]
        else:
            query = text("SELECT t_ili_tid from pg2ili_abwasser.:table WHERE t_id= :t_id;")
            table = "baseclass"
        oid = self.abwasser_session.execute(
            query, {"t_id": result["key"], "table": table}
        ).fetchone()
        enriched_msg = f"{str(exc)}\n" f"Object-ID: {oid}"
        # Create a new exception of the same type, with the enriched message
        new_exc = type(exc)(enriched_msg)
        return new_exc
