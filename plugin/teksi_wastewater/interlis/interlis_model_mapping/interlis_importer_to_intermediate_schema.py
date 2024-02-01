from geoalchemy2.functions import ST_Force3D
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import flag_dirty
from sqlalchemy.sql import text

from .. import config, utils
from ..utils.various import logger


class InterlisImporterToIntermediateSchema:
    def __init__(
        self,
        model,
        model_classes_interlis,
        model_classes_tww_od,
        model_classes_tww_vl,
        callback_progress_done=None,
    ):
        self.model = model
        self.callback_progress_done = callback_progress_done

        self.model_classes_interlis = model_classes_interlis
        self.model_classes_tww_od = model_classes_tww_od
        self.model_classes_tww_vl = model_classes_tww_vl

        self.session_interlis = None
        self.session_tww = None

    def tww_import(self, skip_closing_tww_session=False):
        try:
            self._tww_import(skip_closing_tww_session)
        except Exception as exception:
            try:
                self.session_tww.rollback()
                self.session_tww.close()
                self.session_interlis.close()
            except Exception as cleanup_exception:
                logger.warning(f"Could not close sessions cleanly: {cleanup_exception}")
            raise exception

    def _tww_import(self, skip_closing_tww_session):
        """
        Imports data from the ili2pg model into the TWW model.

        Args:
            precommit_callback: optional callable that gets invoked with the sqlalchemy's session,
                                allowing for a GUI to  filter objects before committing. It MUST either
                                commit or rollback and close the session.
        """

        pre_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )

        # We also drop symbology triggers as they badly affect performance. This must be done in a separate session as it
        # would deadlock other sessions.
        pre_session.execute(text("SELECT tww_sys.disable_symbology_triggers();"))
        pre_session.commit()
        pre_session.close()

        # We use two different sessions for reading and writing so it's easier to
        # review imports and to keep the door open to getting data from another
        # connection / database type.
        self.session_interlis = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.session_tww = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )

        # Allow to insert rows with cyclic dependencies at once
        self.session_tww.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        self._import_sia405_abwasser()

        if self.model == config.MODEL_NAME_DSS:
            self._import_dss()

        if self.model == config.MODEL_NAME_VSA_KEK:
            self._import_vsa_kek()

        self.close_sessions(skip_closing_tww_session=skip_closing_tww_session)

    def _import_sia405_abwasser(self):
        logger.info("Importing ABWASSER.organisation -> TWW.organisation")
        self._import_organisation()
        self._check_for_stop()

        logger.info("Importing ABWASSER.kanal -> TWW.channel")
        self._import_kanal()
        self._check_for_stop()

        logger.info("Importing ABWASSER.normschacht -> TWW.manhole")
        self._import_normschacht()
        self._check_for_stop()

        logger.info("Importing ABWASSER.einleitstelle -> TWW.discharge_point")
        self._import_einleitstelle()
        self._check_for_stop()

        logger.info("Importing ABWASSER.spezialbauwerk -> TWW.special_structure")
        self._import_spezialbauwerk()
        self._check_for_stop()

        logger.info("Importing ABWASSER.versickerungsanlage -> TWW.infiltration_installation")
        self._import_versickerungsanlage()
        self._check_for_stop()

        logger.info("Importing ABWASSER.rohrprofil -> TWW.pipe_profile")
        self._import_rohrprofil()
        self._check_for_stop()

        logger.info("Importing ABWASSER.abwasserknoten -> TWW.wastewater_node")
        self._import_abwasserknoten()
        self._check_for_stop()

        logger.info("Importing ABWASSER.haltung -> TWW.reach")
        self._import_haltung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.haltungspunkt -> TWW.reach_point")
        self._import_haltungspunkt()
        self._check_for_stop()

        logger.info("Importing ABWASSER.trockenwetterfallrohr -> TWW.dryweather_downspout")
        self._import_trockenwetterfallrohr()
        self._check_for_stop()

        logger.info("Importing ABWASSER.einstiegshilfe -> TWW.access_aid")
        self._import_einstiegshilfe()
        self._check_for_stop()

        logger.info("Importing ABWASSER.trockenwetterrinne -> TWW.dryweather_flume")
        self._import_trockenwetterrinne()
        self._check_for_stop()

        logger.info("Importing ABWASSER.deckel -> TWW.cover")
        self._import_deckel()
        self._check_for_stop()

        logger.info("Importing ABWASSER.bankett -> TWW.benching")
        self._import_bankett()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Spuelstutzen -> TWW.flushing_nozzle")
        self._import_spuelstutzen()
        self._check_for_stop()

    def _import_dss(self):
        logger.info(
            "Importing ABWASSER.abwasserreinigungsanlage -> TWW.waste_water_treatment_plant"
        )
        self._import_abwasserreinigungsanlage()
        self._check_for_stop()

        logger.info("Importing ABWASSER.araenergienutzung -> TWW.wwtp_energy_use")
        self._import_araenergienutzung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.abwasserbehandlung -> TWW.waste_water_treatment")
        self._import_abwasserbehandlung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.schlammbehandlung -> TWW.sludge_treatment")
        self._import_schlammbehandlung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.arabauwerk -> TWW.wwtp_structure")
        self._import_arabauwerk()
        self._check_for_stop()

        logger.info("Importing ABWASSER.steuerungszentrale -> TWW.control_center")
        self._import_steuerungszentrale()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Abflusslose_Toilette -> TWW.drainless_toilet")
        self._import_abflusslose_toilette()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Absperr_Drosselorgan -> TWW.throttle_shut_off_unit")
        self._import_absperr_drosselorgan()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Beckenentleerung -> TWW.tank_emptying")
        self._import_beckenentleerung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Beckenreinigung -> TWW.tank_cleaning")
        self._import_beckenreinigung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Biol_oekol_Gesamtbeurteilung -> TWW.bio_ecol_assessment")
        self._import_biol_oekol_gesamtbeurteilung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Brunnen -> TWW.fountain")
        self._import_brunnen()
        self._check_for_stop()

        logger.info("Importing ABWASSER.EZG_PARAMETER_ALLG -> TWW.param_ca_general")
        self._import_ezg_parameter_allg()
        self._check_for_stop()

        logger.info("Importing ABWASSER.EZG_PARAMETER_MOUSE1 -> TWW.param_ca_mouse1")
        self._import_ezg_parameter_mouse1()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Einzelflaeche -> TWW.individual_surface")
        self._import_einzelflaeche()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Einzugsgebiet -> TWW.catchment_area")
        self._import_einzugsgebiet()
        self._check_for_stop()

        logger.info("Importing ABWASSER.ElektrischeEinrichtung -> TWW.electric_equipment")
        self._import_elektrischeeinrichtung()
        self._check_for_stop()

        logger.info(
            "Importing ABWASSER.ElektromechanischeAusruestung -> TWW.electromechanical_equipment"
        )
        self._import_elektromechanischeausruestung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Entsorgung -> TWW.disposal")
        self._import_entsorgung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Entwaesserungssystem -> TWW.drainage_system")
        self._import_entwaesserungssystem()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Feststoffrueckhalt -> TWW.solids_retention")
        self._import_feststoffrueckhalt()
        self._check_for_stop()

        logger.info("Importing ABWASSER.FoerderAggregat -> TWW.")
        self._import_foerderaggregat()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Gebaeude -> TWW.building")
        self._import_gebaeude()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Gebaeudegruppe -> TWW.building_group")
        self._import_gebaeudegruppe()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Gebaeudegruppe_BAUGWR -> TWW.building_group_baugwr")
        self._import_gebaeudegruppe_baugwr()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Gesamteinzugsgebiet -> TWW.catchment_area_totals")
        self._import_gesamteinzugsgebiet()
        self._check_for_stop()

        logger.info("Importing ABWASSER.HQ_Relation -> TWW.hq_relation")
        self._import_hq_relation()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Hydr_GeomRelation -> TWW.hydr_geom_relation")
        self._import_hydr_geomrelation()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Hydr_Geometrie -> TWW.hydr_geometry")
        self._import_hydr_geometrie()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Hydr_Kennwerte -> TWW.hydraulic_char_data")
        self._import_hydr_kennwerte()
        self._check_for_stop()

        logger.info("Importing ABWASSER.KLARA -> TWW.small_treatment_plant")
        self._import_klara()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Landwirtschaftsbetrieb -> TWW.farm")
        self._import_landwirtschaftsbetrieb()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Leapingwehr -> TWW.leapingweir")
        self._import_leapingwehr()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Massnahme -> TWW.measure")
        self._import_massnahme()
        self._check_for_stop()

        logger.info("Importing ABWASSER.MechanischeVorreinigung -> TWW.mechanical_pretreatment")
        self._import_mechanischevorreinigung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Messgeraet -> TWW.measuring_device")
        self._import_messgeraet()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Messreihe -> TWW.measurement_series")
        self._import_messreihe()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Messresultat -> TWW.measurement_result")
        self._import_messresultat()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Messstelle -> TWW.measuring_point")
        self._import_messstelle()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Mutation -> TWW.mutation")
        self._import_mutation()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Reservoir -> TWW.reservoir")
        self._import_reservoir()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Retentionskoerper -> TWW.retention_body")
        self._import_retentionskoerper()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Rohrprofil_Geometrie -> TWW.profile_geometry")
        self._import_rohrprofil_geometrie()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Rueckstausicherung -> TWW.backflow_prevention")
        self._import_rueckstausicherung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Stammkarte -> TWW.log_card")
        self._import_stammkarte()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Streichwehr -> TWW.prank_weir")
        self._import_streichwehr()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Ueberlaufcharakteristik -> TWW.overflow_char")
        self._import_ueberlaufcharakteristik()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Unterhalt -> TWW.maintenance")
        self._import_unterhalt()
        self._check_for_stop()

        logger.info("Importing ABWASSER.Versickerungsbereich -> TWW.infiltration_zone")
        self._import_versickerungsbereich()
        self._check_for_stop()

    def _import_vsa_kek(self):
        logger.info("Importing ABWASSER.untersuchung -> TWW.examination")
        self._import_untersuchung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.normschachtschaden -> TWW.damage_manhole")
        self._import_normschachtschaden()
        self._check_for_stop()

        logger.info("Importing ABWASSER.kanalschaden -> TWW.damage_channel")
        self._import_kanalschaden()
        self._check_for_stop()

        logger.info("Importing ABWASSER.datentraeger -> TWW.data_media")
        self._import_datentraeger()
        self._check_for_stop()

        logger.info("Importing ABWASSER.datei -> TWW.file")
        self._import_datei()
        self._check_for_stop()

    def close_sessions(self, skip_closing_tww_session=False):
        # Calling the precommit callback if provided, allowing to filter before final import
        if not skip_closing_tww_session:
            self.session_tww.commit()
            self.session_tww.close()
        self.session_interlis.close()

        try:
            post_session = Session(
                utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
            )
            post_session.execute(text("SELECT tww_sys.enable_symbology_triggers();"))
            post_session.commit()
            post_session.close()

        except Exception as exception:
            logger.error(f"Could not re-enable symbology triggers: '{exception}'")

    def get_vl_instance(self, vl_table, value_de):
        """
        Gets a value list instance from the value_de name. Returns None and a warning if not found.
        """
        # TODO : memoize (and get the whole table at once) to improve N+1 performance issue
        # TODO : return "other" (or other applicable value) rather than None, or even throwing an exception, would probably be better
        instance = self.session_tww.query(vl_table).filter(vl_table.value_de == value_de).first()
        if instance is None:
            logger.warning(
                f'Could not find value `{value_de}` in value list "{vl_table.__table__.schema}.{vl_table.__name__}". Setting to None instead.'
            )
            return None
        return instance

    def get_vl_code(self, vl_table, value_de):
        if value_de is None:
            return None

        instance = self.get_vl_instance(vl_table, value_de)
        if instance is None:
            return None
        return instance.code

    def get_pk(self, relation):
        """
        Returns the primary key for a relation
        """
        if relation is None:
            return None
        return relation.t_ili_tid

    def create_or_update(self, cls, **kwargs):
        """
        Updates an existing instance (if obj_id is found) or creates an instance of the provided class
        with given kwargs, and returns it.
        """
        instance = None

        # We try to get the instance from the session/database
        obj_id = kwargs.get("obj_id", None)
        if obj_id:
            instance = self.session_tww.query(cls).get(kwargs.get("obj_id", None))

        if instance:
            # We found it -> update
            instance.__dict__.update(kwargs)
            flag_dirty(instance)  # we flag it as dirty so it stays in the session
        else:
            # We didn't find it -> create
            instance = cls(**kwargs)

        return instance

    def base_common(self, row):
        """
        Returns common attributes for base
        """
        return {
            "obj_id": row.t_ili_tid,
            "fk_dataowner": row.datenherrref,
            "fk_provider": row.datenlieferantref,
            "last_modification": row.letzte_aenderung,
        }

    def wastewater_structure_common(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            "accessibility": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_accessibility, row.zugaenglichkeit
            ),
            "contract_section": row.baulos,
            "detail_geometry3d_geometry": ST_Force3D(row.detailgeometrie),
            "financing": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_financing, row.finanzierung
            ),
            "fk_operator": row.betreiberref,
            "fk_owner": row.eigentuemerref,
            "gross_costs": row.bruttokosten,
            "identifier": row.bezeichnung,
            "inspection_interval": row.inspektionsintervall,
            "location_name": row.standortname,
            "records": row.akten,
            "remark": row.bemerkung,
            "renovation_necessity": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_renovation_necessity,
                row.sanierungsbedarf,
            ),
            "replacement_value": row.wiederbeschaffungswert,
            "rv_base_year": row.wbw_basisjahr,
            "rv_construction_type": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_rv_construction_type, row.wbw_bauart
            ),
            "status": self.get_vl_code(
                self.model_classes_tww_vl.wastewater_structure_status, row.astatus
            ),
            "structure_condition": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_structure_condition,
                row.baulicherzustand,
            ),
            "subsidies": row.subventionen,
            "year_of_construction": row.baujahr,
            "year_of_replacement": row.ersatzjahr,
        }

    def wastewater_networkelement_common(self, row):
        """
        Returns common attributes for network_element
        """
        return {
            "fk_wastewater_structure": self.get_pk(row.abwasserbauwerkref__REL),
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
        }

    def structure_part_common(self, row):
        """
        Returns common attributes for structure_part
        """
        return {
            "fk_wastewater_structure": self.get_pk(row.abwasserbauwerkref__REL),
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
            "renovation_demand": self.get_vl_code(
                self.model_classes_tww_od.structure_part_renovation_demand, row.instandstellung
            ),
        }

    def maintenance_event_common(self, row):
        """
        Returns common attributes for connection_object
        """
        return {
            "base_data": row.datengrundlage,
            "cost": row.kosten,
            "data_details": row.detaildaten,
            "duration": row.dauer,
            "operator": row.ausfuehrender,
            "reason": row.grund,
            "result": row.ergebnis,
            "status": self.get_vl_code(
                self.model_classes_tww_vl.maintenance_event_status, row.astatus
            ),
            "time_point": row.zeitpunkt,
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
            "fk_operating_company": row.ausfuehrende_firmaref,
            "fk_measure": self.get_pk(row.massnahmeref__REL),
        }

    def connection_object_common(self, row):
        """
        Returns common attributes for connection_object
        """
        return {
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
            "sewer_infiltration_water_production": row.fremdwasseranfall,
            "fk_wastewater_networkelement": self.get_pk(row.abwassernetzelementref__REL),
        }

    def surface_runoff_parameters_common(self, row):
        """
        Returns common attributes for surface_runoff_parameters
        """
        return {
            "evaporation_loss": row.verdunstungsverlust,
            "identifier": row.bezeichnung,
            "infiltration_loss": row.versickerungsverlust,
            "remark": row.bemerkung,
            "surface_storage": row.muldenverlust,
            "wetting_loss": row.benetzungsverlust,
            "fk_catchment_area": self.get_pk(row.einzugsgebietref__REL),
        }

    def zone_common(self, row):
        """
        Returns common attributes for zone
        """
        return {
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
        }

    def overflow_common(self, row):
        """
        Returns common attributes for overflow
        """
        return {
            "identifier": row.bezeichnung,
            "remark": row.bemerkung,
            "actuation": self.get_vl_code(
                self.model_classes_tww_vl.overflow_actuation, row.antrieb
            ),
            "adjustability": self.get_vl_code(
                self.model_classes_tww_vl.overflow_adjustability, row.verstellbarkeit
            ),
            "brand": row.fabrikat,
            "control": self.get_vl_code(self.model_classes_tww_vl.overflow_control, row.steuerung),
            "discharge_point": row.einleitstelle,
            "function": self.get_vl_code(
                self.model_classes_tww_vl.overflow_function, row.funktion
            ),
            "gross_costs": row.bruttokosten,
            "qon_dim": row.qan_dim,
            "signal_transmission": self.get_vl_code(
                self.model_classes_tww_vl.overflow_signal_transmission, row.signaluebermittlung
            ),
            "subsidies": row.subventionen,
            "fk_wastewater_node": self.get_pk(row.abwasserknotenref__REL),
            "fk_overflow_to": self.get_pk(row.ueberlaufnachref__REL),
            "fk_overflow_char": self.get_pk(row.ueberlaufcharakteristikref__REL),
            "fk_control_center": self.get_pk(row.steuerungszentraleref__REL),
        }

    def _import_organisation(self):
        for row in self.session_interlis.query(self.model_classes_interlis.organisation):
            organisation = self.create_or_update(
                self.model_classes_tww_od.organisation,
                obj_id=row.t_ili_tid,
                # --- organisation ---
                identifier=row.bezeichnung,
                remark=row.bemerkung,
                uid=row.auid,
                municipality_number=row.gemeindenummer,
                organisation_type=self.get_vl_code(
                    self.model_classes_tww_vl.organisation_organisation_type, row.organisationstyp
                ),
                status=self.get_vl_code(
                    self.model_classes_tww_vl.organisation_status, row.astatus
                ),
            )

            self.session_tww.add(organisation)
            print(".", end="")

    def _import_kanal(self):
        for row in self.session_interlis.query(self.model_classes_interlis.kanal):
            channel = self.create_or_update(
                self.model_classes_tww_od.channel,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- channel ---
                bedding_encasement=self.get_vl_code(
                    self.model_classes_tww_od.channel_bedding_encasement, row.bettung_umhuellung
                ),
                connection_type=self.get_vl_code(
                    self.model_classes_tww_od.channel_connection_type, row.verbindungsart
                ),
                function_hierarchic=self.get_vl_code(
                    self.model_classes_tww_od.channel_function_hierarchic, row.funktionhierarchisch
                ),
                function_hydraulic=self.get_vl_code(
                    self.model_classes_tww_od.channel_function_hydraulic, row.funktionhydraulisch
                ),
                jetting_interval=row.spuelintervall,
                pipe_length=row.rohrlaenge,
                usage_current=self.get_vl_code(
                    self.model_classes_tww_od.channel_usage_current, row.nutzungsart_ist
                ),
                usage_planned=self.get_vl_code(
                    self.model_classes_tww_od.channel_usage_planned, row.nutzungsart_geplant
                ),
            )
            self.session_tww.add(channel)
            print(".", end="")

    def _import_normschacht(self):
        for row in self.session_interlis.query(self.model_classes_interlis.normschacht):
            manhole = self.create_or_update(
                self.model_classes_tww_od.manhole,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- manhole ---
                # _orientation=row.REPLACE_ME,
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                function=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_function, row.funktion
                ),
                material=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_material, row.material
                ),
                surface_inflow=self.get_vl_code(
                    self.model_classes_tww_od.manhole_surface_inflow, row.oberflaechenzulauf
                ),
            )
            self.session_tww.add(manhole)
            print(".", end="")

    def _import_einleitstelle(self):
        for row in self.session_interlis.query(self.model_classes_interlis.einleitstelle):
            discharge_point = self.create_or_update(
                self.model_classes_tww_od.discharge_point,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- discharge_point ---
                # fk_sector_water_body=row.REPLACE_ME, # TODO : NOT MAPPED
                highwater_level=row.hochwasserkote,
                relevance=self.get_vl_code(
                    self.model_classes_tww_od.discharge_point_relevance, row.relevanz
                ),
                terrain_level=row.terrainkote,
                # upper_elevation=row.REPLACE_ME, # TODO : NOT MAPPED
                waterlevel_hydraulic=row.wasserspiegel_hydraulik,
            )
            self.session_tww.add(discharge_point)
            print(".", end="")

    def _import_spezialbauwerk(self):
        for row in self.session_interlis.query(self.model_classes_interlis.spezialbauwerk):
            special_structure = self.create_or_update(
                self.model_classes_tww_od.special_structure,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- special_structure ---
                bypass=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_bypass, row.bypass
                ),
                emergency_overflow=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_emergency_overflow,
                    row.notueberlauf,
                ),
                function=self.get_vl_code(
                    self.model_classes_tww_od.special_structure_function, row.funktion
                ),
                stormwater_tank_arrangement=self.get_vl_code(
                    self.model_classes_tww_od.special_structure_stormwater_tank_arrangement,
                    row.regenbecken_anordnung,
                ),
                # upper_elevation=row.REPLACE_ME,   # TODO : NOT MAPPED
            )
            self.session_tww.add(special_structure)
            print(".", end="")

    def _import_versickerungsanlage(self):
        for row in self.session_interlis.query(self.model_classes_interlis.versickerungsanlage):
            infiltration_installation = self.create_or_update(
                self.model_classes_tww_od.infiltration_installation,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- infiltration_installation ---
                absorption_capacity=row.schluckvermoegen,
                defects=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_defects, row.maengel
                ),
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                distance_to_aquifer=row.gwdistanz,
                effective_area=row.wirksameflaeche,
                emergency_overflow=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_emergency_overflow,
                    row.notueberlauf,
                ),
                # fk_aquifier=row.REPLACE_ME,  # TODO : NOT MAPPED
                kind=self.get_vl_code(
                    self.model_classes_tww_vl.infiltration_installation_kind, row.art
                ),
                labeling=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_labeling, row.beschriftung
                ),
                seepage_utilization=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_seepage_utilization,
                    row.versickerungswasser,
                ),
                # upper_elevation=row.REPLACE_ME,  # TODO : NOT MAPPED
                vehicle_access=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_vehicle_access,
                    row.saugwagen,
                ),
                watertightness=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_watertightness,
                    row.wasserdichtheit,
                ),
            )
            self.session_tww.add(infiltration_installation)
            print(".", end="")

    def _import_abwasserreinigungsanlage(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.abwasserreinigungsanlage
        ):
            waste_water_treatment_plant = self.create_or_update(
                self.model_classes_tww_od.waste_water_treatment_plant,
                **self.base_common(row),
                # --- waste_water_treatment_plant ---
                area_geometry=row.perimeter,
                bod5=row.bsb5,
                cod=row.csb,
                elimination_cod=row.eliminationcsb,
                elimination_n=row.eliminationn,
                elimination_nh4=row.eliminationnh4,
                elimination_p=row.eliminationp,
                identifier=row.bezeichnung,
                kind=row.art,
                nh4=row.nh4,
                operator_type=self.get_vl_code(
                    self.model_classes_tww_vl.waste_water_treatment_plant_operator_type,
                    row.betreibertyp,
                ),
                population_connected=row.einwohner_angeschlossen,
                population_total=row.einwohner_total,
                remark=row.bemerkung,
                situation_geometry=row.lage,
                start_year=row.inbetriebnahme,
                wwtp_number=row.ara_nr,
            )
            self.session_tww.add(waste_water_treatment_plant)
            print(".", end="")

    def _import_araenergienutzung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.araenergienutzung):
            wwtp_energy_use = self.create_or_update(
                self.model_classes_tww_od.wwtp_energy_use,
                **self.base_common(row),
                # --- wwtp_energy_use ---
                gas_motor=row.gasmotor,
                heat_pump=row.waermepumpe,
                identifier=row.bezeichnung,
                remark=row.bemerkung,
                turbining=row.turbinierung,
                fk_waste_water_treatment_plant=self.get_pk(row.abwasserreinigungsanlageref__REL),
            )
            self.session_tww.add(wwtp_energy_use)
            print(".", end="")

    def _import_abwasserbehandlung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserbehandlung):
            waste_water_treatment = self.create_or_update(
                self.model_classes_tww_od.waste_water_treatment,
                **self.base_common(row),
                # --- waste_water_treatment ---
                identifier=row.bezeichnung,
                kind=self.get_vl_code(
                    self.model_classes_tww_vl.waste_water_treatment_kind, row.art
                ),
                remark=row.bemerkung,
                fk_waste_water_treatment_plant=self.get_pk(row.abwasserreinigungsanlageref__REL),
            )
            self.session_tww.add(waste_water_treatment)
            print(".", end="")

    def _import_schlammbehandlung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.schlammbehandlung):
            sludge_treatment = self.create_or_update(
                self.model_classes_tww_od.sludge_treatment,
                **self.base_common(row),
                # --- sludge_treatment ---
                composting=row.kompostierung,
                dehydration=row.entwaesserung,
                digested_sludge_combustion=row.faulschlammverbrennung,
                drying=row.trocknung,
                fresh_sludge_combustion=row.frischschlammverbrennung,
                hygenisation=row.hygienisierung,
                identifier=row.bezeichnung,
                predensification_of_excess_sludge=row.ueberschusschlammvoreindickung,
                predensification_of_mixed_sludge=row.mischschlammvoreindickung,
                predensification_of_primary_sludge=row.primaerschlammvoreindickung,
                remark=row.bemerkung,
                stabilisation=self.get_vl_code(
                    self.model_classes_tww_vl.sludge_treatment_stabilisation, row.stabilisierung
                ),
                stacking_of_dehydrated_sludge=row.entwaessertklaerschlammstapelung,
                stacking_of_liquid_sludge=row.fluessigklaerschlammstapelung,
                fk_waste_water_treatment_plant=self.get_pk(row.abwasserreinigungsanlageref__REL),
            )
            self.session_tww.add(sludge_treatment)
            print(".", end="")

    def _import_arabauwerk(self):
        for row in self.session_interlis.query(self.model_classes_interlis.arabauwerk):
            wwtp_structure = self.create_or_update(
                self.model_classes_tww_od.wwtp_structure,
                **self.base_common(row),
                # --- wastewater_structure ---
                **self.wastewater_structure_common(row),
                # --- wwtp_structure ---
                kind=self.get_vl_code(self.model_classes_tww_vl.wwtp_structure_kind, row.art),
                fk_waste_water_treatment_plant=self.get_pk(row.abwasserreinigungsanlageref__REL),
            )
            self.session_tww.add(wwtp_structure)
            print(".", end="")

    def _import_steuerungszentrale(self):
        for row in self.session_interlis.query(self.model_classes_interlis.steuerungszentrale):
            control_center = self.create_or_update(
                self.model_classes_tww_od.control_center,
                **self.base_common(row),
                # --- control_center ---
                identifier=row.bezeichnung,
                situation_geometry=row.lage,
            )
            self.session_tww.add(control_center)
            print(".", end="")

    def _import_abflusslose_toilette(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abflusslose_toilette):
            drainless_toilet = self.create_or_update(
                self.model_classes_tww_od.drainless_toilet,
                **self.base_common(row),
                **self.wastewater_structure_common(row),
                # --- drainless_toilet ---
                kind=self.get_vl_code(self.model_classes_tww_vl.drainless_toilet_kind, row.art),
            )
            self.session_tww.add(drainless_toilet)
            print(".", end="")

    def _import_absperr_drosselorgan(self):
        for row in self.session_interlis.query(self.model_classes_interlis.absperr_drosselorgan):
            throttle_shut_off_unit = self.create_or_update(
                self.model_classes_tww_od.throttle_shut_off_unit,
                **self.base_common(row),
                # --- throttle_shut_off_unit ---
                actuation=self.get_vl_code(
                    self.model_classes_tww_vl.throttle_shut_off_unit_actuation, row.antrieb
                ),
                adjustability=self.get_vl_code(
                    self.model_classes_tww_vl.throttle_shut_off_unit_adjustability,
                    row.verstellbarkeit,
                ),
                control=self.get_vl_code(
                    self.model_classes_tww_vl.throttle_shut_off_unit_control, row.steuerung
                ),
                cross_section=row.querschnitt,
                effective_cross_section=row.wirksamer_qs,
                gross_costs=row.bruttokosten,
                identifier=row.bezeichnung,
                kind=self.get_vl_code(
                    self.model_classes_tww_vl.throttle_shut_off_unit_kind, row.art
                ),
                manufacturer=row.fabrikat,
                remark=row.bemerkung,
                signal_transmission=self.get_vl_code(
                    self.model_classes_tww_vl.throttle_shut_off_unit_signal_transmission,
                    row.signaluebermittlung,
                ),
                subsidies=row.subventionen,
                throttle_unit_opening_current=row.drosselorgan_oeffnung_ist,
                throttle_unit_opening_current_optimized=row.drosselorgan_oeffnung_ist_optimiert,
                fk_wastewater_node=self.get_pk(row.abwasserknotenref__REL),
                fk_control_center=self.get_pk(row.steuerungszentraleref__REL),
                fk_overflow=self.get_pk(row.ueberlaufref__REL),
            )
            self.session_tww.add(throttle_shut_off_unit)
            print(".", end="")

    def _import_beckenentleerung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.beckenentleerung):
            tank_emptying = self.create_or_update(
                self.model_classes_tww_od.tank_emptying,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- tank_emptying ---
                flow=row.leistung,
                gross_costs=row.bruttokosten,
                type=self.get_vl_code(self.model_classes_tww_vl.tank_emptying_type, row.art),
                year_of_replacement=row.ersatzjahr,
                fk_throttle_shut_off_unit=self.get_pk(row.absperr_drosselorganref__REL),
                fk_overflow=self.get_pk(row.ueberlaufref__REL),
            )
            self.session_tww.add(tank_emptying)
            print(".", end="")

    def _import_beckenreinigung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.beckenreinigung):
            tank_cleaning = self.create_or_update(
                self.model_classes_tww_od.tank_cleaning,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- tank_cleaning ---
                gross_costs=row.bruttokosten,
                type=self.get_vl_code(self.model_classes_tww_vl.tank_cleaning_type, row.art),
                year_of_replacement=row.ersatzjahr,
            )
            self.session_tww.add(tank_cleaning)
            print(".", end="")

    def _import_biol_oekol_gesamtbeurteilung(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.biol_oekol_gesamtbeurteilung
        ):
            bio_ecol_assessment = self.create_or_update(
                self.model_classes_tww_od.bio_ecol_assessment,
                **self.base_common(row),
                **self.maintenance_event_common(row),
                # --- bio_ecol_assessment ---
                comparison_last=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_comparison_last,
                    row.vergleich_letzte_untersuchung,
                ),
                date_last_examen=row.datum_letzte_untersuchung,
                impact_auxiliary_indic=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_impact_auxiliary_indic,
                    row.einfluss_hilfsindikatoren,
                ),
                impact_external_aspect=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_impact_external_aspect,
                    row.einfluss_aeusserer_aspekt,
                ),
                impact_macroinvertebrates=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_impact_macroinvertebrates,
                    row.einfluss_makroinvertebraten,
                ),
                impact_water_plants=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_impact_water_plants,
                    row.einfluss_wasserpflanzen,
                ),
                intervention_demand=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_intervention_demand,
                    row.handlungsbedarf,
                ),
                io_calculation=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_io_calculation,
                    row.immissionsorientierte_berechnung,
                ),
                outlet_pipe_clear_height=row.auslaufrohr_lichte_hoehe,
                q347=row.q347,
                relevance_matrix=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_relevance_matrix,
                    row.relevanzmatrix,
                ),
                relevant_slope=row.relevantes_gefaelle,
                surface_water_bodies=row.oberflaechengewaesser,
                type_water_body=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_type_water_body, row.gewaesserart
                ),
                water_specific_discharge_freight_nh4_n_current=row.gewaesserspezifische_entlastungsfracht_nh4_n_ist,
                water_specific_discharge_freight_nh4_n_current_opt=row.gewaesserspezifische_entlastungsfracht_nh4_n_ist_optimiert,
                water_specific_discharge_freight_nh4_n_planned=row.gewaesserspezifische_entlastungsfracht_nh4_n_geplant,
            )
            self.session_tww.add(bio_ecol_assessment)
            print(".", end="")

    def _import_brunnen(self):
        for row in self.session_interlis.query(self.model_classes_interlis.brunnen):
            fountain = self.create_or_update(
                self.model_classes_tww_od.fountain,
                **self.base_common(row),
                **self.connection_object_common(row),
                # --- fountain ---
                location_name=row.standortname,
                situation_geometry=row.lage,
            )
            self.session_tww.add(fountain)
            print(".", end="")

    def _import_ezg_parameter_allg(self):
        for row in self.session_interlis.query(self.model_classes_interlis.ezg_parameter_allg):
            param_ca_general = self.create_or_update(
                self.model_classes_tww_od.param_ca_general,
                **self.base_common(row),
                **self.surface_runoff_parameters_common(row),
                # --- param_ca_general ---
                dry_wheather_flow=row.trockenwetteranfall,
                flow_path_length=row.fliessweglaenge,
                flow_path_slope=row.fliessweggefaelle,
                population_equivalent=row.einwohnergleichwert,
                surface_ca=row.flaeche,
            )
            self.session_tww.add(param_ca_general)
            print(".", end="")

    def _import_ezg_parameter_mouse1(self):
        for row in self.session_interlis.query(self.model_classes_interlis.ezg_parameter_mouse1):
            param_ca_mouse1 = self.create_or_update(
                self.model_classes_tww_od.param_ca_mouse1,
                **self.base_common(row),
                **self.surface_runoff_parameters_common(row),
                # --- param_ca_mouse1 ---
                dry_wheather_flow=row.trockenwetteranfall,
                flow_path_length=row.fliessweglaenge,
                flow_path_slope=row.fliessweggefaelle,
                population_equivalent=row.einwohnergleichwert,
                surface_ca_mouse=row.flaeche,
                usage=row.nutzungsart,
            )
            self.session_tww.add(param_ca_mouse1)
            print(".", end="")

    def _import_einzelflaeche(self):
        for row in self.session_interlis.query(self.model_classes_interlis.einzelflaeche):
            individual_surface = self.create_or_update(
                self.model_classes_tww_od.individual_surface,
                **self.base_common(row),
                **self.connection_object_common(row),
                # --- individual_surface ---
                function=self.get_vl_code(
                    self.model_classes_tww_vl.individual_surface_function, row.funktion
                ),
                inclination=row.neigung,
                pavement=self.get_vl_code(
                    self.model_classes_tww_vl.individual_surface_pavement, row.befestigung
                ),
                perimeter_geometry=row.perimeter,
            )
            self.session_tww.add(individual_surface)
            print(".", end="")

    def _import_einzugsgebiet(self):
        for row in self.session_interlis.query(self.model_classes_interlis.einzugsgebiet):
            catchment_area = self.create_or_update(
                self.model_classes_tww_od.catchment_area,
                **self.base_common(row),
                # --- catchment_area ---
                direct_discharge_current=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_direct_discharge_current,
                    row.direkteinleitung_in_gewaesser_ist,
                ),
                direct_discharge_planned=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_direct_discharge_planned,
                    row.direkteinleitung_in_gewaesser_geplant,
                ),
                discharge_coefficient_rw_current=row.abflussbeiwert_rw_ist,
                discharge_coefficient_rw_planned=row.abflussbeiwert_rw_geplant,
                discharge_coefficient_ww_current=row.abflussbeiwert_sw_ist,
                discharge_coefficient_ww_planned=row.abflussbeiwert_sw_geplant,
                drainage_system_current=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_drainage_system_current,
                    row.entwaesserungssystem_ist,
                ),
                drainage_system_planned=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_drainage_system_planned,
                    row.entwaesserungssystem_geplant,
                ),
                identifier=row.bezeichnung,
                infiltration_current=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_infiltration_current,
                    row.versickerung_ist,
                ),
                infiltration_planned=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_infiltration_planned,
                    row.versickerung_geplant,
                ),
                perimeter_geometry=row.perimeter,
                population_density_current=row.einwohnerdichte_ist,
                population_density_planned=row.einwohnerdichte_geplant,
                remark=row.bemerkung,
                retention_current=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_retention_current, row.retention_ist
                ),
                retention_planned=self.get_vl_code(
                    self.model_classes_tww_vl.catchment_area_retention_planned,
                    row.retention_geplant,
                ),
                runoff_limit_current=row.abflussbegrenzung_ist,
                runoff_limit_planned=row.abflussbegrenzung_geplant,
                seal_factor_rw_current=row.befestigungsgrad_rw_ist,
                seal_factor_rw_planned=row.befestigungsgrad_rw_geplant,
                seal_factor_ww_current=row.befestigungsgrad_sw_ist,
                seal_factor_ww_planned=row.befestigungsgrad_sw_geplant,
                sewer_infiltration_water_production_current=row.fremdwasseranfall_ist,
                sewer_infiltration_water_production_planned=row.fremdwasseranfall_geplant,
                surface_area=row.flaeche,
                waste_water_production_current=row.schmutzabwasseranfall_ist,
                waste_water_production_planned=row.schmutzabwasseranfall_geplant,
                fk_wastewater_networkelement_rw_current=self.get_pk(
                    row.abwassernetzelement_rw_istref__REL
                ),
                fk_wastewater_networkelement_rw_planned=self.get_pk(
                    row.abwassernetzelement_rw_geplantref__REL
                ),
                fk_wastewater_networkelement_ww_planned=self.get_pk(
                    row.abwassernetzelement_sw_geplantref__REL
                ),
                fk_wastewater_networkelement_ww_current=self.get_pk(
                    row.abwassernetzelement_sw_istref__REL
                ),
                fk_special_building_rw_planned=self.get_pk(row.sbw_rw_geplantref__REL),
                fk_special_building_rw_current=self.get_pk(row.sbw_rw_istref__REL),
                fk_special_building_ww_planned=self.get_pk(row.sbw_sw_geplantref__REL),
                fk_special_building_ww_current=self.get_pk(row.sbw_sw_istref__REL),
            )
            self.session_tww.add(catchment_area)
            print(".", end="")

    def _import_elektrischeeinrichtung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.elektrischeeinrichtung):
            electric_equipment = self.create_or_update(
                self.model_classes_tww_od.electric_equipment,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- electric_equipment ---
                gross_costs=row.bruttokosten,
                kind=self.get_vl_code(self.model_classes_tww_vl.electric_equipment_kind, row.art),
                year_of_replacement=row.ersatzjahr,
            )
            self.session_tww.add(electric_equipment)
            print(".", end="")

    def _import_elektromechanischeausruestung(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.elektromechanischeausruestung
        ):
            electromechanical_equipment = self.create_or_update(
                self.model_classes_tww_od.electromechanical_equipment,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- electromechanical_equipment ---
                gross_costs=row.bruttokosten,
                kind=self.get_vl_code(
                    self.model_classes_tww_vl.electromechanical_equipment_kind, row.art
                ),
                year_of_replacement=row.ersatzjahr,
            )
            self.session_tww.add(electromechanical_equipment)
            print(".", end="")

    def _import_entsorgung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.entsorgung):
            disposal = self.create_or_update(
                self.model_classes_tww_od.disposal,
                **self.base_common(row),
                # --- disposal ---
                disposal_interval_current=row.entsorgungsintervall_ist,
                disposal_interval_nominal=row.entsorgungsintervall_soll,
                disposal_place_current=self.get_vl_code(
                    self.model_classes_tww_vl.disposal_disposal_place_current,
                    row.entsorgungsort_ist,
                ),
                disposal_place_planned=self.get_vl_code(
                    self.model_classes_tww_vl.disposal_disposal_place_planned,
                    row.entsorgungsort_geplant,
                ),
                volume_pit_without_drain=row.volumenabflusslosegrube,
                fk_infiltration_installation=self.get_pk(row.versickerungsanlageref__REL),
                fk_discharge_point=self.get_pk(row.einleitstelleref__REL),
                fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
            )
            self.session_tww.add(disposal)
            print(".", end="")

    def _import_entwaesserungssystem(self):
        for row in self.session_interlis.query(self.model_classes_interlis.entwaesserungssystem):
            drainage_system = self.create_or_update(
                self.model_classes_tww_od.drainage_system,
                **self.base_common(row),
                **self.zone_common(row),
                # --- drainage_system ---
                kind=self.get_vl_code(self.model_classes_tww_vl.drainage_system_kind, row.art),
                perimeter_geometry=row.perimeter,
            )
            self.session_tww.add(drainage_system)
            print(".", end="")

    def _import_feststoffrueckhalt(self):
        for row in self.session_interlis.query(self.model_classes_interlis.feststoffrueckhalt):
            solids_retention = self.create_or_update(
                self.model_classes_tww_od.solids_retention,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- solids_retention ---
                dimensioning_value=row.dimensionierungswert,
                gross_costs=row.bruttokosten,
                overflow_level=row.anspringkote,
                type=self.get_vl_code(self.model_classes_tww_vl.solids_retention_type, row.art),
                year_of_replacement=row.ersatzjahr,
            )
            self.session_tww.add(solids_retention)
            print(".", end="")

    def _import_foerderaggregat(self):
        for row in self.session_interlis.query(self.model_classes_interlis.foerderaggregat):
            pump = self.create_or_update(
                self.model_classes_tww_od.pump,
                **self.base_common(row),
                **self.overflow_common(row),
                # --- pump ---
                construction_type=self.get_vl_code(
                    self.model_classes_tww_vl.pump_construction_type, row.bauart
                ),
                operating_point=row.arbeitspunkt,
                placement_of_actuation=self.get_vl_code(
                    self.model_classes_tww_vl.pump_placement_of_actuation, row.aufstellungantrieb
                ),
                placement_of_pump=self.get_vl_code(
                    self.model_classes_tww_vl.pump_placement_of_pump,
                    row.aufstellungfoerderaggregat,
                ),
                pump_flow_max_single=row.foerderstrommax_einzel,
                pump_flow_min_single=row.foerderstrommin_einzel,
                start_level=row.kotestart,
                stop_level=row.kotestop,
            )
            self.session_tww.add(pump)
            print(".", end="")

    def _import_gebaeude(self):
        for row in self.session_interlis.query(self.model_classes_interlis.gebaeude):
            building = self.create_or_update(
                self.model_classes_tww_od.building,
                **self.base_common(row),
                **self.connection_object_common(row),
                # --- building ---
                house_number=row.hausnummer,
                location_name=row.standortname,
                perimeter_geometry=row.perimeter,
                reference_point_geometry=row.referenzpunkt,
            )
            self.session_tww.add(building)
            print(".", end="")

    def _import_gebaeudegruppe(self):
        for row in self.session_interlis.query(self.model_classes_interlis.gebaeudegruppe):
            building_group = self.create_or_update(
                self.model_classes_tww_od.building_group,
                **self.base_common(row),
                # --- building_group ---
                movie_theater_seats=row.kinositzplaetze,
                church_seats=row.kirchesitzplaetze,
                camping_area=row.campingflaeche,
                camping_lodgings=row.campinguebernachtungen,
                connecting_obligation=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_connecting_obligation,
                    row.anschlusspflicht,
                ),
                connection_wwtp=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_connection_wwtp, row.anschlussara
                ),
                craft_employees=row.gewerbebeschaeftigte,
                dorm_beds=row.schlafsaalbetten,
                dorm_overnight_stays=row.schlafsaaluebernachtungen,
                drainage_map=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_drainage_map, row.entwaesserungsplan
                ),
                drinking_water_network=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_drinking_water_network,
                    row.trinkwassernetzanschluss,
                ),
                drinking_water_others=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_drinking_water_others,
                    row.trinkwasserandere,
                ),
                electric_connection=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_electric_connection,
                    row.stromanschluss,
                ),
                event_visitors=row.veranstaltungbesucher,
                function=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_function, row.funktion
                ),
                gym_area=row.turnhalleflaeche,
                holiday_accomodation=row.ferienuebernachtungen,
                hospital_beds=row.spitalbetten,
                hotel_beds=row.hotelbetten,
                hotel_overnight_stays=row.hoteluebernachtungen,
                identifier=row.bezeichnung,
                other_usage_population_equivalent=row.anderenutzungegw,
                other_usage_type=row.anderenutzungart,
                population_equivalent=row.einwohnerwerte,
                remark=row.bemerkung,
                renovation_date=row.sanierungsdatum,
                renovation_necessity=self.get_vl_code(
                    self.model_classes_tww_vl.building_group_renovation_necessity,
                    row.sanierungsbedarf,
                ),
                restaurant_seats=row.raststaettesitzplaetze,
                restaurant_seats_hall_garden=row.restaurantsitzplaetze_saalgarten,
                restaurant_seats_permanent=row.restaurantsitzplaetze_permanent,
                restructuring_concept=row.sanierungskonzept,
                school_students=row.schuleschueler,
                situation_geometry=row.lage,
                # fk_disposal=self.get_pk(row.entsorgungref__REL), # TODO check why not available
                fk_measure=self.get_pk(row.massnahmeref__REL),
            )
            self.session_tww.add(building_group)
            print(".", end="")

    def _import_gebaeudegruppe_baugwr(self):
        for row in self.session_interlis.query(self.model_classes_interlis.gebaeudegruppe_baugwr):
            building_group_baugwr = self.create_or_update(
                self.model_classes_tww_od.building_group_baugwr,
                **self.base_common(row),
                # --- building_group_baugwr ---
                egid=row.egid,
                fk_building_group=self.get_pk(row.gebaeudegrupperef__REL),
            )
            self.session_tww.add(building_group_baugwr)
            print(".", end="")

    def _import_gesamteinzugsgebiet(self):
        for row in self.session_interlis.query(self.model_classes_interlis.gesamteinzugsgebiet):
            catchment_area_totals = self.create_or_update(
                self.model_classes_tww_od.catchment_area_totals,
                **self.base_common(row),
                # --- catchment_area_totals ---
                discharge_freight_nh4_n=row.entlastungsfracht_nh4_n,
                discharge_proportion_nh4_n=row.entlastungsanteil_nh4_n,
                identifier=row.bezeichnung,
                population=row.einwohner,
                population_dim=row.einwohner_dim,
                sewer_infiltration_water=row.fremdwasseranfall,
                surface_area=row.flaeche,
                surface_dim=row.flaeche_dim,
                surface_imp=row.flaeche_bef,
                surface_imp_dim=row.flaeche_bef_dim,
                surface_red=row.flaeche_red,
                surface_red_dim=row.flaeche_red_dim,
                waste_water_production=row.schmutzabwasseranfall,
                fk_discharge_point=self.get_pk(row.einleitstelleref__REL),
                fk_hydraulic_char_data=self.get_pk(row.hydr_kennwerteref__REL),
            )
            self.session_tww.add(catchment_area_totals)
            print(".", end="")

    def _import_hq_relation(self):
        for row in self.session_interlis.query(self.model_classes_interlis.hq_relation):
            hq_relation = self.create_or_update(
                self.model_classes_tww_od.hq_relation,
                **self.base_common(row),
                # --- hq_relation ---
                altitude=row.hoehe,
                flow=row.abfluss,
                flow_from=row.zufluss,
                fk_overflow_char=self.get_pk(row.ueberlaufcharakteristikref__REL),
            )
            self.session_tww.add(hq_relation)
            print(".", end="")

    def _import_hydr_geomrelation(self):
        for row in self.session_interlis.query(self.model_classes_interlis.hydr_geomrelation):
            hydr_geom_relation = self.create_or_update(
                self.model_classes_tww_od.hydr_geom_relation,
                **self.base_common(row),
                # --- hydr_geom_relation ---
                water_depth=row.wassertiefe,
                water_surface=row.wasseroberflaeche,
                wet_cross_section_area=row.benetztequerschnittsflaeche,
                fk_hydr_geometry=self.get_pk(row.hydr_geometrieref__REL),
            )
            self.session_tww.add(hydr_geom_relation)
            print(".", end="")

    def _import_hydr_geometrie(self):
        for row in self.session_interlis.query(self.model_classes_interlis.hydr_geometrie):
            hydr_geometry = self.create_or_update(
                self.model_classes_tww_od.hydr_geometry,
                **self.base_common(row),
                # --- hydr_geometry ---
                remark=row.bemerkung,
                storage_volume=row.stauraum,
                usable_capacity_storage=row.nutzinhalt_fangteil,
                usable_capacity_treatment=row.nutzinhalt_klaerteil,
                utilisable_capacity=row.nutzinhalt,
                volume_pump_sump=row.volumen_pumpensumpf,
            )
            self.session_tww.add(hydr_geometry)
            print(".", end="")

    def _import_hydr_kennwerte(self):
        for row in self.session_interlis.query(self.model_classes_interlis.hydr_kennwerte):
            hydraulic_char_data = self.create_or_update(
                self.model_classes_tww_od.hydraulic_char_data,
                **self.base_common(row),
                # --- hydraulic_char_data ---
                qon=row.qan,
                remark=row.bemerkung,
                status=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_status, row.astatus
                ),
                aggregate_number=row.aggregatezahl,
                delivery_height_geodaetic=row.foerderhoehe_geodaetisch,
                identifier=row.bezeichnung,
                is_overflowing=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_is_overflowing, row.springt_an
                ),
                main_weir_kind=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_main_weir_kind, row.hauptwehrart
                ),
                overcharge=row.mehrbelastung,
                overflow_duration=row.ueberlaufdauer,
                overflow_freight=row.ueberlauffracht,
                overflow_frequency=row.ueberlaufhaeufigkeit,
                overflow_volume=row.ueberlaufmenge,
                pump_characteristics=self.get_vl_code(
                    self.model_classes_tww_vl.hydraulic_char_data_pump_characteristics,
                    row.pumpenregime,
                ),
                pump_flow_max=row.foerderstrommax,
                pump_flow_min=row.foerderstrommin,
                q_discharge=row.qab,
                fk_wastewater_node=self.get_pk(row.abwasserknotenref__REL),
                fk_overflow_char=self.get_pk(row.ueberlaufcharakteristikref__REL),
                fk_primary_direction=self.get_pk(row.primaerrichtungref__REL),
            )
            self.session_tww.add(hydraulic_char_data)
            print(".", end="")

    def _import_klara(self):
        for row in self.session_interlis.query(self.model_classes_interlis.klara):
            small_treatment_plant = self.create_or_update(
                self.model_classes_tww_od.small_treatment_plant,
                **self.base_common(row),
                **self.wastewater_structure_common(row),
                # --- small_treatment_plant ---
                approval_number=row.bewilligungsnummer,
                function=self.get_vl_code(
                    self.model_classes_tww_vl.small_treatment_plant_function, row.funktion
                ),
                installation_number=row.anlagenummer,
                remote_monitoring=self.get_vl_code(
                    self.model_classes_tww_vl.small_treatment_plant_remote_monitoring,
                    row.fernueberwachung,
                ),
            )
            self.session_tww.add(small_treatment_plant)
            print(".", end="")

    def _import_landwirtschaftsbetrieb(self):
        for row in self.session_interlis.query(self.model_classes_interlis.landwirtschaftsbetrieb):
            farm = self.create_or_update(
                self.model_classes_tww_od.farm,
                **self.base_common(row),
                # --- farm ---
                agriculture_arable_surface=row.nutzflaechelandwirtschaft,
                cesspit_comment=row.guellegrubebemerkung,
                cesspit_volume=self.get_vl_code(
                    self.model_classes_tww_vl.farm_cesspit_volume, row.guellegrubevolumen
                ),
                cesspit_volume_current=row.guellegrubevolumen_ist,
                cesspit_volume_nominal=row.guellegrubevolumen_soll,
                cesspit_volume_ww_treated=row.guellegrubevolumen_sw_behandelt,
                cesspit_year_of_approval=row.guellegrubebewilligungsjahr,
                conformity=self.get_vl_code(
                    self.model_classes_tww_vl.farm_conformity, row.konformitaet
                ),
                continuance=self.get_vl_code(
                    self.model_classes_tww_vl.farm_continuance, row.fortbestand
                ),
                continuance_comment=row.fortbestandbemerkung,
                dung_heap_area_current=row.mistplatzflaeche_ist,
                dung_heap_area_nominal=row.mistplatzflaeche_soll,
                remark=row.bemerkung,
                shepherds_hut_comment=row.hirtenhuettebemerkung,
                shepherds_hut_population_equivalent=row.hirtenhuetteegw,
                shepherds_hut_wastewater=self.get_vl_code(
                    self.model_classes_tww_vl.farm_shepherds_hut_wastewater,
                    row.hirtenhuetteabwasser,
                ),
                stable_cattle=self.get_vl_code(
                    self.model_classes_tww_vl.farm_stable_cattle, row.stallvieh
                ),
                stable_cattle_equivalent_other_cattle=row.stallgrossvieheinheit_fremdvieh,
                stable_cattle_equivalent_own_cattle=row.stallgrossvieheinheit_eigenesvieh,
                fk_building_group=self.get_pk(row.gebaeudegrupperef__REL),
            )
            self.session_tww.add(farm)
            print(".", end="")

    def _import_leapingwehr(self):
        for row in self.session_interlis.query(self.model_classes_interlis.leapingwehr):
            leapingweir = self.create_or_update(
                self.model_classes_tww_od.leapingweir,
                **self.base_common(row),
                **self.overflow_common(row),
                # --- leapingweir ---
                length=row.laenge,
                opening_shape=self.get_vl_code(
                    self.model_classes_tww_vl.leapingweir_opening_shape, row.oeffnungsform
                ),
                width=row.breite,
            )
            self.session_tww.add(leapingweir)
            print(".", end="")

    def _import_massnahme(self):
        for row in self.session_interlis.query(self.model_classes_interlis.massnahme):
            measure = self.create_or_update(
                self.model_classes_tww_od.measure,
                **self.base_common(row),
                # --- measure ---
                date_entry=row.datum_eingang,
                description=row.beschreibung,
                category=self.get_vl_code(
                    self.model_classes_tww_vl.measure_category, row.kategorie
                ),
                identifier=row.bezeichnung,
                intervention_demand=row.handlungsbedarf,
                line_geometry=row.linie,
                link=row.verweis,
                perimeter_geometry=row.perimeter,
                priority=self.get_vl_code(
                    self.model_classes_tww_vl.measure_priority, row.prioritaet
                ),
                remark=row.bemerkung,
                status=self.get_vl_code(self.model_classes_tww_vl.measure_status, row.astatus),
                symbolpos_geometry=row.symbolpos,
                total_cost=row.gesamtkosten,
                year_implementation_effective=row.jahr_umsetzung_effektiv,
                year_implementation_planned=row.jahr_umsetzung_geplant,
                fk_responsible_entity=row.traegerschaftref,
                fk_responsible_start=row.verantwortlich_ausloesungref,
            )
            self.session_tww.add(measure)
            print(".", end="")

    def _import_mechanischevorreinigung(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.mechanischevorreinigung
        ):
            mechanical_pretreatment = self.create_or_update(
                self.model_classes_tww_od.mechanical_pretreatment,
                **self.base_common(row),
                # --- mechanical_pretreatment ---
                identifier=row.bezeichnung,
                kind=self.get_vl_code(
                    self.model_classes_tww_vl.mechanical_pretreatment_kind, row.art
                ),
                remark=row.bemerkung,
                fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
            )
            self.session_tww.add(mechanical_pretreatment)
            print(".", end="")

    def _import_messgeraet(self):
        for row in self.session_interlis.query(self.model_classes_interlis.messgeraet):
            measuring_device = self.create_or_update(
                self.model_classes_tww_od.measuring_device,
                **self.base_common(row),
                # --- measuring_device ---
                serial_number=row.seriennummer,
                brand=row.fabrikat,
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.measuring_device_kind, row.art),
                remark=row.bemerkung,
                fk_measuring_point=self.get_pk(row.messstelleref__REL),
            )
            self.session_tww.add(measuring_device)
            print(".", end="")

    def _import_messreihe(self):
        for row in self.session_interlis.query(self.model_classes_interlis.messreihe):
            measurement_series = self.create_or_update(
                self.model_classes_tww_od.measurement_series,
                **self.base_common(row),
                # --- measurement_series ---
                dimension=row.dimension,
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.measurement_series_kind, row.art),
                remark=row.bemerkung,
                fk_measuring_point=self.get_pk(row.messstelleref__REL),
                fk_wastewater_networkelement=self.get_pk(row.abwassernetzelementref__REL),
            )
            self.session_tww.add(measurement_series)
            print(".", end="")

    def _import_messresultat(self):
        for row in self.session_interlis.query(self.model_classes_interlis.messresultat):
            measurement_result = self.create_or_update(
                self.model_classes_tww_od.measurement_result,
                **self.base_common(row),
                # --- measurement_result ---
                identifier=row.bezeichnung,
                measurement_type=self.get_vl_code(
                    self.model_classes_tww_vl.measurement_result_measurement_type, row.messart
                ),
                measuring_duration=row.messdauer,
                remark=row.bemerkung,
                time=row.zeit,
                value=row.wert,
                fk_measuring_device=self.get_pk(row.messgeraetref__REL),
                fk_measurement_series=self.get_pk(row.messreiheref__REL),
            )
            self.session_tww.add(measurement_result)
            print(".", end="")

    def _import_messstelle(self):
        for row in self.session_interlis.query(self.model_classes_interlis.messstelle):
            measuring_point = self.create_or_update(
                self.model_classes_tww_od.measuring_point,
                **self.base_common(row),
                # --- measuring_point ---
                purpose=row.zweck,
                remark=row.bemerkung,
                damming_device=row.staukoerper,
                identifier=row.bezeichnung,
                kind=row.art,
                situation_geometry=row.lage,
                fk_operator=row.betreiberref,
                fk_waste_water_treatment_plant=self.get_pk(row.abwasserreinigungsanlageref__REL),
                fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
            )
            self.session_tww.add(measuring_point)
            print(".", end="")

    def _import_mutation(self):
        for row in self.session_interlis.query(self.model_classes_interlis.mutation):
            mutation = self.create_or_update(
                self.model_classes_tww_od.mutation,
                **self.base_common(row),
                # --- mutation ---
                attribute=row.attribut,
                classname=row.klasse,
                date_mutation=row.mutationsdatum,
                date_time=row.aufnahmedatum,
                kind=self.get_vl_code(self.model_classes_tww_vl.mutation_kind, row.art),
                last_value=row.letzter_wert,
                object=row.objekt,
                recorded_by=row.aufnehmer,
                remark=row.bemerkung,
                system_user=row.systembenutzer,
            )
            self.session_tww.add(mutation)
            print(".", end="")

    def _import_reservoir(self):
        for row in self.session_interlis.query(self.model_classes_interlis.reservoir):
            reservoir = self.create_or_update(
                self.model_classes_tww_od.reservoir,
                **self.base_common(row),
                **self.connection_object_common(row),
                # --- reservoir ---
                location_name=row.standortname,
                situation_geometry=row.lage,
            )
            self.session_tww.add(reservoir)
            print(".", end="")

    def _import_retentionskoerper(self):
        for row in self.session_interlis.query(self.model_classes_interlis.retentionskoerper):
            retention_body = self.create_or_update(
                self.model_classes_tww_od.retention_body,
                **self.base_common(row),
                # --- retention_body ---
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.retention_body_kind, row.art),
                remark=row.bemerkung,
                volume=row.retention_volumen,
                fk_infiltration_installation=self.get_pk(row.versickerungsanlageref__REL),
            )
            self.session_tww.add(retention_body)
            print(".", end="")

    def _import_rohrprofil_geometrie(self):
        for row in self.session_interlis.query(self.model_classes_interlis.rohrprofil_geometrie):
            profile_geometry = self.create_or_update(
                self.model_classes_tww_od.profile_geometry,
                **self.base_common(row),
                # --- profile_geometry ---
                sequence=row.reihenfolge,
                x=row.x,
                y=row.y,
                fk_pipe_profile=self.get_pk(row.rohrprofilref__REL),
            )
            self.session_tww.add(profile_geometry)
            print(".", end="")

    def _import_rueckstausicherung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.rueckstausicherung):
            backflow_prevention = self.create_or_update(
                self.model_classes_tww_od.backflow_prevention,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- backflow_prevention ---
                gross_costs=row.bruttokosten,
                kind=self.get_vl_code(self.model_classes_tww_vl.backflow_prevention_kind, row.art),
                year_of_replacement=row.ersatzjahr,
                fk_throttle_shut_off_unit=self.get_pk(row.absperr_drosselorganref),
                fk_pump=self.get_pk(row.foerderaggregatref),
            )
            self.session_tww.add(backflow_prevention)
            print(".", end="")

    def _import_stammkarte(self):
        for row in self.session_interlis.query(self.model_classes_interlis.stammkarte):
            log_card = self.create_or_update(
                self.model_classes_tww_od.log_card,
                **self.base_common(row),
                # --- log_card ---
                control_remote_control=self.get_vl_code(
                    self.model_classes_tww_vl.log_card_control_remote_control,
                    row.steuerung_fernwirkung,
                ),
                information_source=self.get_vl_code(
                    self.model_classes_tww_vl.log_card_information_source, row.informationsquelle
                ),
                person_in_charge=row.sachbearbeiter,
                remark=row.bemerkung,
                fk_pwwf_wastewater_node=self.get_pk(row.paa_knotenref__REL),
                fk_agency=row.bueroref,
                fk_location_municipality=row.standortgemeinderef,
            )
            self.session_tww.add(log_card)
            print(".", end="")

    def _import_streichwehr(self):
        for row in self.session_interlis.query(self.model_classes_interlis.streichwehr):
            prank_weir = self.create_or_update(
                self.model_classes_tww_od.prank_weir,
                **self.base_common(row),
                **self.overflow_common(row),
                # --- prank_weir ---
                hydraulic_overflow_length=row.hydrueberfalllaenge,
                level_max=row.kotemax,
                level_min=row.kotemin,
                weir_edge=self.get_vl_code(
                    self.model_classes_tww_vl.prank_weir_weir_edge, row.ueberfallkante
                ),
                weir_kind=self.get_vl_code(
                    self.model_classes_tww_vl.prank_weir_weir_kind, row.wehr_art
                ),
            )
            self.session_tww.add(prank_weir)
            print(".", end="")

    def _import_ueberlaufcharakteristik(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.ueberlaufcharakteristik
        ):
            overflow_char = self.create_or_update(
                self.model_classes_tww_od.overflow_char,
                **self.base_common(row),
                # --- overflow_char ---
                identifier=row.bezeichnung,
                kind_overflow_char=self.get_vl_code(
                    self.model_classes_tww_vl.overflow_char_kind_overflow_char, row.kennlinie_typ
                ),
                remark=row.bemerkung,
            )
            self.session_tww.add(overflow_char)
            print(".", end="")

    def _import_unterhalt(self):
        for row in self.session_interlis.query(self.model_classes_interlis.unterhalt):
            maintenance = self.create_or_update(
                self.model_classes_tww_od.maintenance,
                **self.base_common(row),
                **self.maintenance_event_common(row),
                # --- maintenance ---
                kind=self.get_vl_code(self.model_classes_tww_vl.maintenance_kind, row.art),
            )
            self.session_tww.add(maintenance)
            print(".", end="")

    def _import_versickerungsbereich(self):
        for row in self.session_interlis.query(self.model_classes_interlis.versickerungsbereich):
            infiltration_zone = self.create_or_update(
                self.model_classes_tww_od.infiltration_zone,
                **self.base_common(row),
                **self.zone_common(row),
                # --- infiltration_zone ---
                infiltration_capacity=self.get_vl_code(
                    self.model_classes_tww_vl.infiltration_zone_infiltration_capacity,
                    row.versickerungsmoeglichkeit,
                ),
                perimeter_geometry=row.perimeter,
            )
            self.session_tww.add(infiltration_zone)
            print(".", end="")

    def _import_rohrprofil(self):
        for row in self.session_interlis.query(self.model_classes_interlis.rohrprofil):
            pipe_profile = self.create_or_update(
                self.model_classes_tww_od.pipe_profile,
                **self.base_common(row),
                # --- pipe_profile ---
                height_width_ratio=row.hoehenbreitenverhaeltnis,
                identifier=row.bezeichnung,
                profile_type=self.get_vl_code(
                    self.model_classes_tww_od.pipe_profile_profile_type, row.profiltyp
                ),
                remark=row.bemerkung,
            )
            self.session_tww.add(pipe_profile)
            print(".", end="")

    def _import_haltungspunkt(self):
        for row in self.session_interlis.query(self.model_classes_interlis.haltungspunkt):
            reach_point = self.create_or_update(
                self.model_classes_tww_od.reach_point,
                **self.base_common(row),
                # --- reach_point ---
                elevation_accuracy=self.get_vl_code(
                    self.model_classes_tww_od.reach_point_elevation_accuracy, row.hoehengenauigkeit
                ),
                fk_wastewater_networkelement=self.get_pk(row.abwassernetzelementref__REL),
                identifier=row.bezeichnung,
                level=row.kote,
                outlet_shape=self.get_vl_code(
                    self.model_classes_tww_od.reach_point_outlet_shape, row.auslaufform
                ),
                position_of_connection=row.lage_anschluss,
                remark=row.bemerkung,
                situation3d_geometry=ST_Force3D(row.lage),
            )
            self.session_tww.add(reach_point)
            print(".", end="")

    def _import_abwasserknoten(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserknoten):
            wastewater_node = self.create_or_update(
                self.model_classes_tww_od.wastewater_node,
                **self.base_common(row),
                # --- wastewater_networkelement ---
                **self.wastewater_networkelement_common(row),
                # --- wastewater_node ---
                # fk_hydr_geometry=row.REPLACE_ME,  # TODO : NOT MAPPED
                backflow_level_current=row.rueckstaukote_ist,
                bottom_level=row.sohlenkote,
                situation3d_geometry=ST_Force3D(row.lage),
            )
            self.session_tww.add(wastewater_node)
            print(".", end="")

    def _import_haltung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.haltung):
            reach = self.create_or_update(
                self.model_classes_tww_od.reach,
                **self.base_common(row),
                # --- wastewater_networkelement ---
                **self.wastewater_networkelement_common(row),
                # --- reach ---
                clear_height=row.lichte_hoehe,
                coefficient_of_friction=row.reibungsbeiwert,
                # elevation_determination=self.get_vl_code(TWW.reach_elevation_determination, row.REPLACE_ME),  # TODO : NOT MAPPED
                fk_pipe_profile=self.get_pk(row.rohrprofilref__REL),
                fk_reach_point_from=self.get_pk(row.vonhaltungspunktref__REL),
                fk_reach_point_to=self.get_pk(row.nachhaltungspunktref__REL),
                horizontal_positioning=self.get_vl_code(
                    self.model_classes_tww_od.reach_horizontal_positioning, row.lagebestimmung
                ),
                inside_coating=self.get_vl_code(
                    self.model_classes_tww_od.reach_inside_coating, row.innenschutz
                ),
                length_effective=row.laengeeffektiv,
                material=self.get_vl_code(self.model_classes_tww_vl.reach_material, row.material),
                progression3d_geometry=ST_Force3D(row.verlauf),
                reliner_material=self.get_vl_code(
                    self.model_classes_tww_od.reach_reliner_material, row.reliner_material
                ),
                reliner_nominal_size=row.reliner_nennweite,
                relining_construction=self.get_vl_code(
                    self.model_classes_tww_od.reach_relining_construction, row.reliner_bautechnik
                ),
                relining_kind=self.get_vl_code(
                    self.model_classes_tww_od.reach_relining_kind, row.reliner_art
                ),
                ring_stiffness=row.ringsteifigkeit,
                slope_building_plan=row.plangefaelle,  # TODO : check, does this need conversion ?
                wall_roughness=row.wandrauhigkeit,
            )
            self.session_tww.add(reach)
            print(".", end="")

    def _import_trockenwetterfallrohr(self):
        for row in self.session_interlis.query(self.model_classes_interlis.trockenwetterfallrohr):
            dryweather_downspout = self.create_or_update(
                self.model_classes_tww_od.dryweather_downspout,
                **self.base_common(row),
                # --- structure_part ---
                **self.structure_part_common(row),
                # --- dryweather_downspout ---
                diameter=row.durchmesser,
            )
            self.session_tww.add(dryweather_downspout)
            print(".", end="")

    def _import_einstiegshilfe(self):
        for row in self.session_interlis.query(self.model_classes_interlis.einstiegshilfe):
            access_aid = self.create_or_update(
                self.model_classes_tww_od.access_aid,
                **self.base_common(row),
                # --- structure_part ---
                **self.structure_part_common(row),
                # --- access_aid ---
                kind=self.get_vl_code(self.model_classes_tww_vl.access_aid_kind, row.art),
            )
            self.session_tww.add(access_aid)
            print(".", end="")

    def _import_trockenwetterrinne(self):
        for row in self.session_interlis.query(self.model_classes_interlis.trockenwetterrinne):
            dryweather_flume = self.create_or_update(
                self.model_classes_tww_od.dryweather_flume,
                **self.base_common(row),
                # --- structure_part ---
                **self.structure_part_common(row),
                # --- dryweather_flume ---
                material=self.get_vl_code(
                    self.model_classes_tww_od.dryweather_flume_material, row.material
                ),
            )
            self.session_tww.add(dryweather_flume)
            print(".", end="")

    def _import_deckel(self):
        for row in self.session_interlis.query(self.model_classes_interlis.deckel):
            cover = self.create_or_update(
                self.model_classes_tww_od.cover,
                **self.base_common(row),
                # --- structure_part ---
                **self.structure_part_common(row),
                # --- cover ---
                brand=row.fabrikat,
                cover_shape=self.get_vl_code(
                    self.model_classes_tww_vl.cover_cover_shape, row.deckelform
                ),
                diameter=row.durchmesser,
                fastening=self.get_vl_code(
                    self.model_classes_tww_vl.cover_fastening, row.verschluss
                ),
                level=row.kote,
                material=self.get_vl_code(self.model_classes_tww_vl.cover_material, row.material),
                positional_accuracy=self.get_vl_code(
                    self.model_classes_tww_od.cover_positional_accuracy, row.lagegenauigkeit
                ),
                situation3d_geometry=ST_Force3D(row.lage),
                sludge_bucket=self.get_vl_code(
                    self.model_classes_tww_od.cover_sludge_bucket, row.schlammeimer
                ),
                venting=self.get_vl_code(self.model_classes_tww_vl.cover_venting, row.entlueftung),
            )
            self.session_tww.add(cover)
            print(".", end="")

    def _import_bankett(self):
        for row in self.session_interlis.query(self.model_classes_interlis.bankett):
            benching = self.create_or_update(
                self.model_classes_tww_od.benching,
                **self.base_common(row),
                # --- structure_part ---
                **self.structure_part_common(row),
                # --- benching ---
                kind=self.get_vl_code(self.model_classes_tww_vl.benching_kind, row.art),
            )
            self.session_tww.add(benching)
            print(".", end="")

    def _import_spuelstutzen(self):
        for row in self.session_interlis.query(self.model_classes_interlis.spuelstutzen):
            flushing_nozzle = self.create_or_update(
                self.model_classes_tww_od.flushing_nozzle,
                **self.base_common(row),
                **self.structure_part_common(row),
                # --- flushing_nozzle ---
                situation_geometry=row.lage,
            )
            self.session_tww.add(flushing_nozzle)
            print(".", end="")

    def _import_untersuchung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.untersuchung):
            logger.warning(
                "TWW examination.active_zone has no equivalent in the interlis model. This field will be null."
            )
            examination = self.create_or_update(
                self.model_classes_tww_od.examination,
                **self.base_common(row),
                # --- maintenance_event ---
                # active_zone=row.REPLACE_ME,  # TODO : found no matching field for this in interlis, confirm this is ok
                base_data=row.datengrundlage,
                cost=row.kosten,
                data_details=row.detaildaten,
                duration=row.dauer,
                fk_operating_company=row.ausfuehrende_firmaref
                if row.ausfuehrende_firmaref
                else None,
                identifier=row.bezeichnung,
                operator=row.ausfuehrender,
                reason=row.grund,
                remark=row.bemerkung,
                result=row.ergebnis,
                status=self.get_vl_code(
                    self.model_classes_tww_vl.maintenance_event_status, row.astatus
                ),
                time_point=row.zeitpunkt,
                # --- examination ---
                equipment=row.geraet,
                fk_reach_point=row.haltungspunktref if row.haltungspunktref else None,
                from_point_identifier=row.vonpunktbezeichnung,
                inspected_length=row.inspizierte_laenge,
                recording_type=self.get_vl_code(
                    self.model_classes_tww_od.examination_recording_type, row.erfassungsart
                ),
                to_point_identifier=row.bispunktbezeichnung,
                vehicle=row.fahrzeug,
                videonumber=row.videonummer,
                weather=self.get_vl_code(
                    self.model_classes_tww_vl.examination_weather, row.witterung
                ),
            )
            self.session_tww.add(examination)

            # In TWW, relation between maintenance_event and wastewater_structure is done with
            # an association table instead of a foreign key on maintenance_event.
            # NOTE : this may change in future versions of VSA_KEK
            if row.abwasserbauwerkref:
                # TODO : for now, this will not work unless the related wastewaterstructures are part of the import,
                # as ili2pg imports dangling references as NULL.
                # The day ili2pg works, we probably need to double-check whether the referenced wastewater structure exists prior
                # to creating this association.
                # Soft matching based on from/to_point_identifier will be done in the GUI data checking process.
                exam_to_wastewater_structure = self.create_or_update(
                    self.model_classes_tww_od.re_maintenance_event_wastewater_structure,
                    fk_wastewater_structure=row.abwasserbauwerkref,
                    fk_maintenance_event=row.t_ili_tid,
                )
                self.session_tww.add(exam_to_wastewater_structure)

            print(".", end="")

    def _import_normschachtschaden(self):
        for row in self.session_interlis.query(self.model_classes_interlis.normschachtschaden):
            damage_manhole = self.create_or_update(
                self.model_classes_tww_od.damage_manhole,
                **self.base_common(row),
                # --- damage ---
                comments=row.anmerkung,
                connection=self.get_vl_code(
                    self.model_classes_tww_vl.damage_connection, row.verbindung
                ),
                manhole_damage_begin=row.schadenlageanfang,
                manhole_damage_end=row.schadenlageende,
                line_damage=row.streckenschaden,
                manhole_channel_distance=row.distanz,
                fk_examination=self.get_pk(row.untersuchungref__REL),
                manhole_quantification1=row.quantifizierung1,
                manhole_quantification2=row.quantifizierung2,
                single_damage_class=self.get_vl_code(
                    self.model_classes_tww_od.damage_single_damage_class, row.einzelschadenklasse
                ),
                video_counter=row.videozaehlerstand,
                view_parameters=row.ansichtsparameter,
                # --- damage_manhole ---
                manhole_damage_code=self.get_vl_code(
                    self.model_classes_tww_od.damage_manhole_manhole_damage_code,
                    row.schachtschadencode,
                ),
                manhole_shaft_area=self.get_vl_code(
                    self.model_classes_tww_od.damage_manhole_manhole_shaft_area, row.schachtbereich
                ),
            )
            self.session_tww.add(damage_manhole)
            print(".", end="")

    def _import_kanalschaden(self):
        for row in self.session_interlis.query(self.model_classes_interlis.kanalschaden):
            # Note : in TWW, some attributes are on the base damage class,
            # while they are on the normschachtschaden/kanalschaden subclasses
            # in the ili2pg mode.
            # Concerned attributes : distanz, quantifizierung1, quantifizierung2, schadenlageanfang, schadenlageende
            damage_channel = self.create_or_update(
                self.model_classes_tww_od.damage_channel,
                **self.base_common(row),
                # --- damage ---
                comments=row.anmerkung,
                connection=self.get_vl_code(
                    self.model_classes_tww_vl.damage_connection, row.verbindung
                ),
                channel_damage_begin=row.schadenlageanfang,
                channel_damage_end=row.schadenlageende,
                line_damage=row.streckenschaden,
                channel_distance=row.distanz,
                fk_examination=self.get_pk(row.untersuchungref__REL),
                channel_quantification1=row.quantifizierung1,
                channel_quantification2=row.quantifizierung2,
                single_damage_class=self.get_vl_code(
                    self.model_classes_tww_od.damage_single_damage_class, row.einzelschadenklasse
                ),
                video_counter=row.videozaehlerstand,
                view_parameters=row.ansichtsparameter,
                # --- damage_channel ---
                channel_damage_code=self.get_vl_code(
                    self.model_classes_tww_od.damage_channel_channel_damage_code,
                    row.kanalschadencode,
                ),
            )
            self.session_tww.add(damage_channel)
            print(".", end="")

    def _import_datentraeger(self):
        for row in self.session_interlis.query(self.model_classes_interlis.datentraeger):
            data_media = self.create_or_update(
                self.model_classes_tww_od.data_media,
                **self.base_common(row),
                # --- data_media ---
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.data_media_kind, row.art),
                location=row.standort,
                path=row.pfad,
                remark=row.bemerkung,
            )
            self.session_tww.add(data_media)
            print(".", end="")

    def _import_datei(self):
        for row in self.session_interlis.query(self.model_classes_interlis.datei):
            file_table_row = self.create_or_update(
                self.model_classes_tww_od.file,
                **self.base_common(row),
                # --- file ---
                fk_data_media=self.get_pk(row.datentraegerref__REL),
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.file_kind, row.art),
                object=row.objekt,
                path_relative=row.relativpfad,
                remark=row.bemerkung,
                class_column=self.get_vl_code(self.model_classes_tww_vl.file_class, row.klasse),
            )

            self.session_tww.add(file_table_row)
            print(".", end="")

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()
