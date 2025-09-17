from datetime import date, datetime

from geoalchemy2.functions import ST_Force3D, ST_Multi
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import flag_dirty
from sqlalchemy.sql import text

from ...utils.plugin_utils import logger
from .. import config, utils


class InterlisImporterToIntermediateSchema:
    def __init__(
        self,
        model,
        model_classes_interlis,
        model_classes_tww_od,
        model_classes_tww_vl,
        model_classes_tww_app=None,
        callback_progress_done=None,
        filter_nulls=False,
    ):
        self.model = model
        self.callback_progress_done = callback_progress_done

        self.model_classes_interlis = model_classes_interlis
        self.model_classes_tww_od = model_classes_tww_od
        self.model_classes_tww_vl = model_classes_tww_vl
        self.model_classes_tww_app = model_classes_tww_app

        self.session_interlis = None
        self.session_tww = None

        self.filter_nulls = filter_nulls

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

        if self.model not in (config.MODEL_NAME_AG64, config.MODEL_NAME_AG96):
            self._import_sia405_abwasser_base()
            if self.model != config.MODEL_NAME_SIA405_BASE_ABWASSER:
                self._import_sia405_abwasser()

        if self.model == config.MODEL_NAME_DSS:
            self._import_dss()

        if self.model == config.MODEL_NAME_VSA_KEK:
            self._import_vsa_kek()

        if self.model == config.MODEL_NAME_AG96:
            self._import_ag96()

        if self.model == config.MODEL_NAME_AG64:
            self._import_ag64()

        self.close_sessions(skip_closing_tww_session=skip_closing_tww_session)

    def _import_sia405_abwasser_base(self):
        logger.info("\nImporting ABWASSER.organisation -> TWW.organisation")
        self._import_organisation()
        self._check_for_stop()

    def _import_sia405_abwasser(self):

        logger.info("\nImporting ABWASSER.kanal -> TWW.channel")
        self._import_kanal()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.normschacht -> TWW.manhole")
        self._import_normschacht()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.einleitstelle -> TWW.discharge_point")
        self._import_einleitstelle()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.spezialbauwerk -> TWW.special_structure")
        self._import_spezialbauwerk()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.versickerungsanlage -> TWW.infiltration_installation")
        self._import_versickerungsanlage()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.rohrprofil -> TWW.pipe_profile")
        self._import_rohrprofil()
        self._check_for_stop()

        # As fk_hydr_geometry only exists in VSA-DSS, but not in SIA405_Abwasser, distinguish which matching configuration is used
        if self.model == config.MODEL_NAME_DSS:
            logger.info(
                "\nImporting ABWASSER.abwasserknoten with VSA-DSS 2020 -> TWW.wastewater_node"
            )
            self._import_abwasserknoten_dss()
        else:
            logger.info("\nImporting ABWASSER.abwasserknoten -> TWW.wastewater_node")
            self._import_abwasserknoten()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.haltung -> TWW.reach")
        self._import_haltung()
        self._check_for_stop()

        logger.info(
            "\nImporting ABWASSER.haltung_alternativverlauf -> TWW.reach_progression_alternative"
        )
        self._import_haltung_alternativverlauf()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.haltungspunkt -> TWW.reach_point")
        self._import_haltungspunkt()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.trockenwetterfallrohr -> TWW.dryweather_downspout")
        self._import_trockenwetterfallrohr()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.einstiegshilfe -> TWW.access_aid")
        self._import_einstiegshilfe()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.trockenwetterrinne -> TWW.dryweather_flume")
        self._import_trockenwetterrinne()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.deckel -> TWW.cover")
        self._import_deckel()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.bankett -> TWW.benching")
        self._import_bankett()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.spuelstutzen -> TWW.flushing_nozzle")
        self._import_spuelstutzen()
        self._check_for_stop()

        logger.info(
            "\nImporting ABWASSER.abwasserbauwerk_symbol -> TWW.wastewater_structure_symbol"
        )
        self._import_abwasserbauwerk_symbol()
        self._check_for_stop()

    def _import_dss(self):
        logger.info(
            "\nImporting ABWASSER.abwasserreinigungsanlage -> TWW.waste_water_treatment_plant"
        )
        self._import_abwasserreinigungsanlage()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.araenergienutzung -> TWW.wwtp_energy_use")
        self._import_araenergienutzung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.abwasserbehandlung -> TWW.waste_water_treatment")
        self._import_abwasserbehandlung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.schlammbehandlung -> TWW.sludge_treatment")
        self._import_schlammbehandlung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.arabauwerk -> TWW.wwtp_structure")
        self._import_arabauwerk()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.steuerungszentrale -> TWW.control_center")
        self._import_steuerungszentrale()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.abflusslose_toilette -> TWW.drainless_toilet")
        self._import_abflusslose_toilette()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.absperr_drosselorgan -> TWW.throttle_shut_off_unit")
        self._import_absperr_drosselorgan()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.beckenentleerung -> TWW.tank_emptying")
        self._import_beckenentleerung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.beckenreinigung -> TWW.tank_cleaning")
        self._import_beckenreinigung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.biol_oekol_gesamtbeurteilung -> TWW.bio_ecol_assessment")
        self._import_biol_oekol_gesamtbeurteilung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.brunnen -> TWW.fountain")
        self._import_brunnen()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.ezg_parameter_allg -> TWW.param_ca_general")
        self._import_ezg_parameter_allg()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.ezg_parameter_mouse1 -> TWW.param_ca_mouse1")
        self._import_ezg_parameter_mouse1()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.einzelflaeche -> TWW.individual_surface")
        self._import_einzelflaeche()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.einzugsgebiet -> TWW.catchment_area")
        self._import_einzugsgebiet()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.elektrischeeinrichtung -> TWW.electric_equipment")
        self._import_elektrischeeinrichtung()
        self._check_for_stop()

        logger.info(
            "\nImporting ABWASSER.elektromechanischeausruestung -> TWW.electromechanical_equipment"
        )
        self._import_elektromechanischeausruestung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.entsorgung -> TWW.disposal")
        self._import_entsorgung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.entwaesserungssystem -> TWW.drainage_system")
        self._import_entwaesserungssystem()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.feststoffrueckhalt -> TWW.solids_retention")
        self._import_feststoffrueckhalt()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.foerderaggregat -> TWW.pump")
        self._import_foerderaggregat()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.gebaeude -> TWW.building")
        self._import_gebaeude()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.gebaeudegruppe -> TWW.building_group")
        self._import_gebaeudegruppe()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.gebaeudegruppe_baugwr -> TWW.building_group_baugwr")
        self._import_gebaeudegruppe_baugwr()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.gesamteinzugsgebiet -> TWW.catchment_area_totals")
        self._import_gesamteinzugsgebiet()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.hq_relation -> TWW.hq_relation")
        self._import_hq_relation()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.hydr_geomrelation -> TWW.hydr_geom_relation")
        self._import_hydr_geomrelation()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.hydr_geometrie -> TWW.hydr_geometry")
        self._import_hydr_geometrie()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.hydr_kennwerte -> TWW.hydraulic_char_data")
        self._import_hydr_kennwerte()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.klara -> TWW.small_treatment_plant")
        self._import_klara()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.landwirtschaftsbetrieb -> TWW.farm")
        self._import_landwirtschaftsbetrieb()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.leapingwehr -> TWW.leapingweir")
        self._import_leapingwehr()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.massnahme -> TWW.measure")
        self._import_massnahme()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.mechanischevorreinigung -> TWW.mechanical_pretreatment")
        self._import_mechanischevorreinigung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.messgeraet -> TWW.measuring_device")
        self._import_messgeraet()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.messreihe -> TWW.measurement_series")
        self._import_messreihe()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.messresultat -> TWW.measurement_result")
        self._import_messresultat()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.messstelle -> TWW.measuring_point")
        self._import_messstelle()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.mutation -> TWW.mutation")
        self._import_mutation()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.reservoir -> TWW.reservoir")
        self._import_reservoir()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.retentionskoerper -> TWW.retention_body")
        self._import_retentionskoerper()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.rohrprofil_geometrie -> TWW.profile_geometry")
        self._import_rohrprofil_geometrie()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.rueckstausicherung -> TWW.backflow_prevention")
        self._import_rueckstausicherung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.stammkarte -> TWW.log_card")
        self._import_stammkarte()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.streichwehr -> TWW.prank_weir")
        self._import_streichwehr()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.ueberlaufcharakteristik -> TWW.overflow_char")
        self._import_ueberlaufcharakteristik()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.unterhalt -> TWW.maintenance")
        self._import_unterhalt()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.versickerungsbereich -> TWW.infiltration_zone")
        self._import_versickerungsbereich()
        self._check_for_stop()

        logger.info(
            "\nImporting ABWASSER.erhaltungsereignis_abwasserbauwerkassoc -> TWW.re_maintenance_event_wastewater_structure"
        )
        self._import_erhaltungsereignis_abwasserbauwerkassoc()
        self._check_for_stop()

        logger.info(
            "\nImporting ABWASSER.gebaeudegruppe_entsorgungassoc -> TWW.re_building_group_disposal"
        )
        self._import_gebaeudegruppe_entsorgungassoc()
        self._check_for_stop()

    def _import_vsa_kek(self):
        logger.info("\nImporting ABWASSER.untersuchung -> TWW.examination")
        self._import_untersuchung()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.normschachtschaden -> TWW.damage_manhole")
        self._import_normschachtschaden()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.kanalschaden -> TWW.damage_channel")
        self._import_kanalschaden()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.datentraeger -> TWW.data_media")
        self._import_datentraeger()
        self._check_for_stop()

        logger.info("\nImporting ABWASSER.datei -> TWW.file")
        self._import_datei()
        self._check_for_stop()

    def close_sessions(self, skip_closing_tww_session=False):
        # Calling the precommit callback if provided, allowing to filter before final import
        if not skip_closing_tww_session:
            self.session_tww.commit()
            self.session_tww.close()
        self.session_interlis.close()

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
        return (
            relation.t_ili_tid if relation.t_ili_tid else relation.obj_id
        )  # if else needed for AG-64/AG-96

    def geometry3D_convert(
        self, geometryattribute, levelattribute, obj_id, classname_attributename
    ):
        """
        Checks if levelattribute or geometryattribut is Null or empty and calls ST_Force3D accordingly as else 3D geometry will be set to NULL if levelattribute is missing - see https://github.com/teksi/wastewater/issues/475#issuecomment-2441032526 and https://trac.osgeo.org/postgis/ticket/5804#comment:1
        """
        if levelattribute is None or levelattribute == "":
            if geometryattribute is None or geometryattribute == "":
                # No geometry AND no levelattribute provided
                logger.warning(
                    f"No {classname_attributename} and geometry (Lage) provided for object {obj_id} -  situation3d_geometry cannot be defined! Object cannot be displayed in TEKSI TWW!"
                )
                return None

            else:
                # geometry attribute but no levelattribute provided
                geom = self.session_tww.scalar(ST_Force3D(geometryattribute))
                logger.info(
                    f"No {classname_attributename} provided for object {obj_id}- situation3d_geometry with no z-value created: {geom}."
                )
                return geom
        else:
            if geometryattribute is None or geometryattribute == "":
                # Levelattribute provided but no geometry attribute
                logger.warning(
                    f"{classname_attributename} provided but no geometry (Lage) provided for object {obj_id} -  situation3d_geometry cannot be defined! Object cannot be displayed in TEKSI TWW!"
                )
                return None
            else:
                # Levelattribute and geometry attribute provided - 3D coordinate can be created as expected
                geom = self.session_tww.scalar(ST_Force3D(geometryattribute, levelattribute))
                logger.debug(
                    f" debug: situation3d_geometry created with geometry (x,y) and level (z): {geom}."
                )
                return geom

    def create_or_update(self, cls, **kwargs):
        """
        Updates an existing instance (if obj_id is found) or creates an instance of the provided class
        with given kwargs, and returns it.
        """
        instance = None

        if self.filter_nulls:
            kwargs = {key: val for key, val in kwargs.items() if val is not None}

        # We try to get the instance from the session/database
        obj_id = kwargs.get("obj_id", None)
        if obj_id:
            instance = self.session_tww.get(cls, obj_id)

        if instance:
            flag_dirty(
                instance
            )  # we flag it as dirty so it stays in the session. This is a workaround trick
            # needed because the session is not meant to be used as a cache: https://docs.sqlalchemy.org/en/20/orm/session_basics.html#is-the-session-a-cache

            # Update dates times (different resolution Interlis / TWW)
            date_time_keys = [
                "last_modification",
                "time_point",
                "date_last_examen",
                "renovation_date",
                "date_entry",
                "time",
                "date_mutation",
            ]

            # Double fields that needs special comparison (imported as text from interlis)
            double_value_keys = ["value", "x", "y"]

            for key, value in kwargs.items():
                if key in date_time_keys and isinstance(value, date):
                    value = datetime.combine(value, datetime.min.time())

                instanceAttribute = getattr(instance, key, None)

                if key in double_value_keys:
                    try:
                        value = float(value)
                        instanceAttribute = float(instanceAttribute)
                    except Exception:
                        logger.warning(
                            f"Values of column '{key}' are not convertible to float: interlis='{value}', old='{instanceAttribute}'"
                        )

                if instanceAttribute != value:
                    # Setattr in the background updates the session state and make it possible to use "is_modified" afterwards
                    setattr(instance, key, value)
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
            # new attribute condition_score Release 2020
            "condition_score": row.zustandsnote,
            "contract_section": row.baulos,
            "detail_geometry3d_geometry": (
                row.detailgeometrie
                if row.detailgeometrie is None
                else self.session_tww.scalar(ST_Force3D(row.detailgeometrie))
            ),
            # -- attribute 3D ---
            # "elevation_determination": self.get_vl_code(
            #    self.model_classes_tww_od.wastewater_structure_elevation_determination, row.hoehenbestimmung
            # ),
            "financing": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_financing, row.finanzierung
            ),
            # looks like wrong notation
            # "fk_main_cover": row.hauptdeckelref,
            "fk_main_cover": self.get_pk(row.hauptdeckelref__REL),
            # TO DO check also if ok or other notation needed
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
            # new attribute status_survey_year Release 2020
            "status_survey_year": row.zustandserhebung_jahr,
            "structure_condition": self.get_vl_code(
                self.model_classes_tww_od.wastewater_structure_structure_condition,
                row.baulicherzustand,
            ),
            "subsidies": row.subventionen,
            # new attribute urgency_figure Release 2020.1
            "urgency_figure": row.dringlichkeitszahl,
            "year_of_construction": row.baujahr,
            "year_of_replacement": row.ersatzjahr,
        }

    def wastewater_networkelement_common(self, row):
        """
        Returns common attributes for wastewater_networkelement
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
                # manually add for organisation (instead of adding **self.base_common(row) as this would also add fk_dataowner and fk_provider, that are not in INTERLIS for class organisation (change to VSA-DSS 2015, as organisation is now a separate external class maintained by the VSA (or its successor organisation for this)
                last_modification=row.letzte_aenderung,
                # --- organisation ---
                identifier=row.bezeichnung,
                identifier_short=row.kurzbezeichnung,
                municipality_number=row.gemeindenummer,
                organisation_type=self.get_vl_code(
                    self.model_classes_tww_vl.organisation_organisation_type, row.organisationstyp
                ),
                remark=row.bemerkung,
                status=self.get_vl_code(
                    self.model_classes_tww_vl.organisation_status, row.astatus
                ),
                uid=row.auid,
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
                # new attribute function_amelioration Release 2020
                function_amelioration=self.get_vl_code(
                    self.model_classes_tww_od.channel_function_amelioration,
                    row.funktionmelioration,
                ),
                function_hierarchic=self.get_vl_code(
                    self.model_classes_tww_od.channel_function_hierarchic, row.funktionhierarchisch
                ),
                function_hydraulic=self.get_vl_code(
                    self.model_classes_tww_od.channel_function_hydraulic, row.funktionhydraulisch
                ),
                jetting_interval=row.spuelintervall,
                pipe_length=row.rohrlaenge,
                # new attribute seepage Release 2020
                seepage=self.get_vl_code(self.model_classes_tww_od.channel_seepage, row.sickerung),
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
                # new attribute amphibian_exit Release 2020
                amphibian_exit=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_amphibian_exit, row.amphibienausstieg
                ),
                # -- attribute 3D ---
                # depth=row.maechtigkeit,
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                function=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_function, row.funktion
                ),
                material=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_material, row.material
                ),
                # new attribute possibility_intervention Release 2020
                possibility_intervention=self.get_vl_code(
                    self.model_classes_tww_vl.manhole_possibility_intervention,
                    row.interventionsmoeglichkeit,
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
                # only VSA-DSS 2015
                # fk_sector_water_body=row.REPLACE_ME, # TODO : NOT MAPPED
                # -- attribute 3D ---
                # depth=row.maechtigkeit,
                highwater_level=row.hochwasserkote,
                relevance=self.get_vl_code(
                    self.model_classes_tww_od.discharge_point_relevance, row.relevanz
                ),
                terrain_level=row.terrainkote,
                # -- attribute 3D ---
                # upper_elevation=row.deckenkote,
                # new attribute water_course_segment_canton Release 2020
                water_course_segment_canton=row.gewaesserabschnitt_kanton,
                # new attribute water_course_number Release 2020
                water_course_number=row.gewaesserlaufnummer,
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
                # new attribute amphibian_exit Release 2020
                amphibian_exit=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_amphibian_exit,
                    row.amphibienausstieg,
                ),
                bypass=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_bypass, row.bypass
                ),
                # -- attribute 3D ---
                # depth=row.maechtigkeit,
                emergency_overflow=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_emergency_overflow,
                    row.notueberlauf,
                ),
                function=self.get_vl_code(
                    self.model_classes_tww_od.special_structure_function, row.funktion
                ),
                # new attribute possibility_intervention Release 2020
                possibility_intervention=self.get_vl_code(
                    self.model_classes_tww_vl.special_structure_possibility_intervention,
                    row.interventionsmoeglichkeit,
                ),
                stormwater_tank_arrangement=self.get_vl_code(
                    self.model_classes_tww_od.special_structure_stormwater_tank_arrangement,
                    row.regenbecken_anordnung,
                ),
                # -- attribute 3D ---
                # upper_elevation=row.deckenkote,
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
                # -- attribute 3D ---
                # depth=row.maechtigkeit,
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                distance_to_aquifer=row.gwdistanz,
                effective_area=row.wirksameflaeche,
                emergency_overflow=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_emergency_overflow,
                    row.notueberlauf,
                ),
                # new attribute filling_material Release 2020,
                filling_material=self.get_vl_code(
                    self.model_classes_tww_od.infiltration_installation_filling_material,
                    row.fuellmaterial,
                ),
                # fk_dss15_aquifer=row.REPLACE_ME,  # only in TEKSI, not supported in VSA-DSS 2020
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
                # -- attribute 3D ---
                # upper_elevation=row.deckenkote,
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
                kind=self.get_vl_code(self.model_classes_tww_vl.tank_emptying_kind, row.art),
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
                kind=self.get_vl_code(self.model_classes_tww_vl.tank_cleaning_kind, row.art),
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
                kind_water_body=self.get_vl_code(
                    self.model_classes_tww_vl.bio_ecol_assessment_kind_water_body, row.gewaesserart
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
                kind=self.get_vl_code(self.model_classes_tww_vl.solids_retention_kind, row.art),
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
                # n:m relation - see def _import_gebaeudegruppe_entsorgungassoc
                # fk_disposal=self.get_pk(row.entsorgungref__REL),
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
                identifier=row.bezeichnung,
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
                time_point=row.zeit,  # renamed 20250812 as time is a reserved SQL:2023 keyword
                measurement_value=row.wert,  # renamed 20250812 as value is a reserved SQL:2023 keyword
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
                # change to value list reference
                # purpose=row.zweck,
                purpose=self.get_vl_code(
                    self.model_classes_tww_vl.measuring_point_purpose, row.zweck
                ),
                remark=row.bemerkung,
                # change to value list reference
                # damming_device=row.staukoerper,
                damming_device=self.get_vl_code(
                    self.model_classes_tww_vl.measuring_point_damming_device, row.staukoerper
                ),
                identifier=row.bezeichnung,
                # kind is not a value list here
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
                user_system=row.systembenutzer,
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
                fk_throttle_shut_off_unit=self.get_pk(row.absperr_drosselorganref__REL),
                fk_pump=self.get_pk(row.foerderaggregatref__REL),
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
                # new attribute pipe_closure release 2020
                pipe_closure=self.get_vl_code(
                    self.model_classes_tww_od.reach_point_pipe_closure, row.rohrverschluss_kappe
                ),
                remark=row.bemerkung,
                situation3d_geometry=self.geometry3D_convert(
                    row.lage, row.kote, row.t_ili_tid, "reach_point.cote (Haltungpunkt.Kote)"
                ),
            )
            self.session_tww.add(reach_point)
            print(".", end="")

    def _import_haltung_alternativverlauf(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.haltung_alternativverlauf
        ):
            reach_progression_alternative = self.create_or_update(
                self.model_classes_tww_od.reach_progression_alternative,
                obj_id=row.t_ili_tid,
                plantype=self.get_vl_code(
                    self.model_classes_tww_od.reach_progression_alternative_plantype, row.plantyp
                ),
                progression_geometry=row.verlauf,
                fk_reach=self.get_pk(row.haltungref__REL),
            )
            self.session_tww.add(reach_progression_alternative)
            print(".", end="")

    def _import_abwasserknoten(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserknoten):
            wastewater_node = self.create_or_update(
                self.model_classes_tww_od.wastewater_node,
                **self.base_common(row),
                # --- wastewater_networkelement ---
                **self.wastewater_networkelement_common(row),
                # --- wastewater_node ---
                backflow_level_current=row.rueckstaukote_ist,
                bottom_level=row.sohlenkote,
                # new attribute elevation_accuracy release 2020
                elevation_accuracy=self.get_vl_code(
                    self.model_classes_tww_od.wastewater_node_elevation_accuracy,
                    row.hoehengenauigkeit,
                ),
                # new attribute fk_hydr_geometry release 2020 if vsa-dss -> see _import_abwasserknoten_dss
                # fk_hydr_geometry=self.get_pk(row.hydr_geometrieref__REL),
                # new attribute function_node_amelioration release 2020
                function_node_amelioration=self.get_vl_code(
                    self.model_classes_tww_od.wastewater_node_function_node_amelioration,
                    row.funktion_knoten_melioration,
                ),
                situation3d_geometry=self.geometry3D_convert(
                    row.lage,
                    row.sohlenkote,
                    row.t_ili_tid,
                    "wastewater_node.bottom_level (Abwasserknoten.Sohlenkote)",
                ),
                # new attribute wwtp_number release 2020
                wwtp_number=row.ara_nr,
            )
            self.session_tww.add(wastewater_node)
            print(".", end="")

    def _import_abwasserknoten_dss(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserknoten):
            wastewater_node = self.create_or_update(
                self.model_classes_tww_od.wastewater_node,
                **self.base_common(row),
                # --- wastewater_networkelement ---
                **self.wastewater_networkelement_common(row),
                # --- wastewater_node ---
                backflow_level_current=row.rueckstaukote_ist,
                bottom_level=row.sohlenkote,
                # new attribute elevation_accuracy release 2020
                elevation_accuracy=self.get_vl_code(
                    self.model_classes_tww_od.wastewater_node_elevation_accuracy,
                    row.hoehengenauigkeit,
                ),
                # new attribute fk_hydr_geometry release 2020
                # try debug 20.6.2025 without self., as in _import_reach (also subclass) - not working
                fk_hydr_geometry=self.get_pk(row.hydr_geometrieref__REL),
                # new attribute function_node_amelioration release 2020
                function_node_amelioration=self.get_vl_code(
                    self.model_classes_tww_od.wastewater_node_function_node_amelioration,
                    row.funktion_knoten_melioration,
                ),
                situation3d_geometry=self.geometry3D_convert(
                    row.lage,
                    row.sohlenkote,
                    row.t_ili_tid,
                    "wastewater_node.bottom_level (Abwasserknoten.Sohlenkote)",
                ),
                # new attribute wwtp_number release 2020
                wwtp_number=row.ara_nr,
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
                # -- attribute 3D ---
                # elevation_determination=self.get_vl_code(
                #    self.model_classes_tww_od.wastewater_structure_elevation_determination, row.hoehenbestimmung
                # ),
                fk_pipe_profile=self.get_pk(row.rohrprofilref__REL),
                fk_reach_point_from=self.get_pk(row.vonhaltungspunktref__REL),
                fk_reach_point_to=self.get_pk(row.nachhaltungspunktref__REL),
                # new attribute flow_time_dry_weather release 2020
                flow_time_dry_weather=row.fliesszeit_trockenwetter,
                horizontal_positioning=self.get_vl_code(
                    self.model_classes_tww_od.reach_horizontal_positioning, row.lagebestimmung
                ),
                # new attribute hydraulic_load_current release 2020
                hydraulic_load_current=row.hydr_belastung_ist,
                inside_coating=self.get_vl_code(
                    self.model_classes_tww_od.reach_inside_coating, row.innenschutz
                ),
                # new attribute leak_protection release 2020
                leak_protection=self.get_vl_code(
                    self.model_classes_tww_vl.reach_leak_protection, row.leckschutz
                ),
                length_effective=row.laengeeffektiv,
                material=self.get_vl_code(self.model_classes_tww_vl.reach_material, row.material),
                progression3d_geometry=self.session_tww.scalar(ST_Force3D(row.verlauf)),
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
                # -- attribute 3D ---
                # depth=row.maechtigkeit,
                diameter=row.durchmesser,
                fastening=self.get_vl_code(
                    self.model_classes_tww_vl.cover_fastening, row.verschluss
                ),
                level=row.kote,
                material=self.get_vl_code(self.model_classes_tww_vl.cover_material, row.material),
                positional_accuracy=self.get_vl_code(
                    self.model_classes_tww_od.cover_positional_accuracy, row.lagegenauigkeit
                ),
                situation3d_geometry=self.geometry3D_convert(
                    row.lage, row.kote, row.t_ili_tid, "cover.level (Deckel.Deckelkote)"
                ),
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

    def _import_abwasserbauwerk_symbol(self):
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserbauwerk_symbol):
            wastewater_structure_symbol = self.create_or_update(
                self.model_classes_tww_od.wastewater_structure_symbol,
                # --- wastewater_structure_symbol ---
                obj_id=row.t_ili_tid,
                plantype=self.get_vl_code(
                    self.model_classes_tww_vl.wastewater_structure_symbol_plantype, row.plantyp
                ),
                symbol_scaling_height=row.symbolskalierunghoch,
                symbol_scaling_width=row.symbolskalierunglaengs,
                symbolori=row.symbolori,
                symbolpos_geometry=row.symbolpos,
                fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
            )
            self.session_tww.add(wastewater_structure_symbol)
            print(".", end="")

    def _import_untersuchung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.untersuchung):
            examination = self.create_or_update(
                self.model_classes_tww_od.examination,
                **self.base_common(row),
                # --- maintenance_event ---
                base_data=row.datengrundlage,
                cost=row.kosten,
                data_details=row.detaildaten,
                duration=row.dauer,
                # in VSA-KEK 2020 in class maintenance_event instead of examination
                # fk_operating_company=(
                #    row.ausfuehrende_firmaref if row.ausfuehrende_firmaref else None
                # ),
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

                exam_to_wastewater_structure = (
                    self.session_tww.query(
                        self.model_classes_tww_od.re_maintenance_event_wastewater_structure
                    )
                    .filter_by(
                        fk_wastewater_structure=row.abwasserbauwerkref,
                        fk_maintenance_event=row.t_ili_tid,
                    )
                    .first()
                )
                if exam_to_wastewater_structure is not None:
                    # Already existing -> do nothing
                    continue

                exam_to_wastewater_structure = (
                    self.model_classes_tww_od.re_maintenance_event_wastewater_structure(
                        fk_wastewater_structure=row.abwasserbauwerkref,
                        fk_maintenance_event=row.t_ili_tid,
                    )
                )
                self.session_tww.add(exam_to_wastewater_structure)

            print(".", end="")

    def _import_normschachtschaden(self):
        for row in self.session_interlis.query(self.model_classes_interlis.normschachtschaden):
            damage_manhole = self.create_or_update(
                self.model_classes_tww_od.damage_manhole,
                **self.base_common(row),
                # --- damage ---
                # to check Adaption VSA-KEK 2020 moved to superclass schaden
                comments=row.anmerkung,
                # to check Adaption VSA-KEK 2020 moved to superclass schaden
                connection=self.get_vl_code(
                    self.model_classes_tww_vl.damage_connection, row.verbindung
                ),
                manhole_damage_begin=row.schadenlageanfang,
                manhole_damage_end=row.schadenlageende,
                line_damage=row.streckenschaden,
                manhole_distance=row.distanz,
                fk_examination=self.get_pk(row.untersuchungref__REL),
                manhole_quantification1=row.quantifizierung1,
                manhole_quantification2=row.quantifizierung2,
                # to check Adaption VSA-KEK 2020 moved to superclass schaden
                single_damage_class=self.get_vl_code(
                    self.model_classes_tww_od.damage_single_damage_class, row.einzelschadenklasse
                ),
                # to check Adaption VSA-KEK 2020 moved to superclass schaden
                video_counter=row.videozaehlerstand,
                # to check Adaption VSA-KEK 2020 moved to superclass schaden
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
                classname=self.get_vl_code(self.model_classes_tww_vl.file_classname, row.klasse),
            )

            self.session_tww.add(file_table_row)
            print(".", end="")

    def _import_erhaltungsereignis_abwasserbauwerkassoc(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.erhaltungsereignis_abwasserbauwerkassoc
        ):
            re_maintenance_event_wastewater_structure = (
                self.session_tww.query(
                    self.model_classes_tww_od.re_maintenance_event_wastewater_structure
                )
                .filter_by(
                    fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
                    fk_maintenance_event=self.get_pk(
                        row.erhaltungsereignis_abwasserbauwerkassocref__REL
                    ),
                )
                .first()
            )
            if re_maintenance_event_wastewater_structure is not None:
                # Already existing -> do nothing
                continue

            re_maintenance_event_wastewater_structure = (
                self.model_classes_tww_od.re_maintenance_event_wastewater_structure(
                    fk_maintenance_event=self.get_pk(
                        row.erhaltungsereignis_abwasserbauwerkassocref__REL
                    ),
                    fk_wastewater_structure=self.get_pk(row.abwasserbauwerkref__REL),
                )
            )

            self.session_tww.add(re_maintenance_event_wastewater_structure)
            print(".", end="")

    def _import_gebaeudegruppe_entsorgungassoc(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.gebaeudegruppe_entsorgungassoc
        ):
            re_building_group_disposal = (
                self.session_tww.query(self.model_classes_tww_od.re_building_group_disposal)
                .filter_by(
                    fk_building_group=self.get_pk(row.gebaeudegruppe_entsorgungassocref__REL),
                    fk_disposal=self.get_pk(row.entsorgungref__REL),
                )
                .first()
            )
            if re_building_group_disposal is not None:
                # Already existing -> do nothing
                continue

            re_building_group_disposal = self.model_classes_tww_od.re_building_group_disposal(
                fk_building_group=self.get_pk(row.gebaeudegruppe_entsorgungassocref__REL),
                fk_disposal=self.get_pk(row.entsorgungref__REL),
            )

            self.session_tww.add(re_building_group_disposal)
            print(".", end="")

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()

    # AG-64/96
    def _import_ag64(self):
        logger.info("Importing ABWASSER.infrastrukturknoten -> TWW.gepknoten")
        self._import_infrastrukturknoten()
        self._check_for_stop()

        logger.info("Importing ABWASSER.infrastrukturhaltung -> TWW.gephaltung")
        self._import_infrastrukturhaltung()
        self._check_for_stop()

        logger.info(
            "Importing ABWASSER.ueberlauf_foerderaggregat -> TWW.ueberlauf_foerderaggregat"
        )
        self._import_ueberlauf_foerderaggregat_ag64()
        self._check_for_stop()

    def _import_ag96(self):
        logger.info("Importing ABWASSER.gepmassnahme -> TWW.gepmassnahme")
        self._import_gepmassnahme()
        self._check_for_stop()

        logger.info("Importing ABWASSER.gepknoten -> TWW.gepknoten")
        self._import_gepknoten()
        self._check_for_stop()

        logger.info("Importing ABWASSER.gephaltung -> TWW.gephaltung")
        self._import_gephaltung()
        self._check_for_stop()

        logger.info("Importing ABWASSER.einzugsgebiet -> TWW.einzugsgebiet")
        self._import_einzugsgebiet_ag96()
        self._check_for_stop()

        logger.info(
            "Importing ABWASSER.bautenausserhalbbaugebiet -> TWW.bautenausserhalbbaugebiet"
        )
        self._import_bautenausserhalbbaugebiet()
        self._check_for_stop()

        logger.info(
            "Importing ABWASSER.ueberlauf_foerderaggregat -> TWW.ueberlauf_foerderaggregat"
        )
        self._import_ueberlauf_foerderaggregat_ag96()
        self._check_for_stop()

        logger.info("Importing ABWASSER.sbw_einzugsgebiet -> TWW.sbw_einzugsgebiet")
        self._import_sbw_einzugsgebiet()
        self._check_for_stop()

        logger.info("Importing ABWASSER.versickerungsbereichag -> TWW.versickerungsbereichag")
        self._import_versickerungsbereichag()
        self._check_for_stop()

    def check_ignore_ws(self, row):
        if row.funktionag != "andere":
            return False
        else:
            abwasserbw = (
                self.model_classes_interlis.abwasserbauwerk.t_ili_tid
                if self.model_classes_interlis.abwasserbauwerk.t_ili_tid
                else self.model_classes_interlis.abwasserbauwerk.obj_id
            )
            detailgeoms = (
                self.session_interlis.query(self.model_classes_interlis.abwasserbauwerk)
                .filter(
                    self.model_classes_interlis.abwasserbauwerk.detailgeometrie.ST_Buffer(
                        0.001
                    ).ST_Covers(row.lage),
                    abwasserbw != row.t_ili_tid,
                )
                .first()
            )
        if detailgeoms:
            return True
        else:
            return False

    def base_common_ag_xx(self, row):
        return {
            "obj_id": (
                row.t_ili_tid if row.t_ili_tid else row.obj_id
            ),  # AG-64 loads no t_ili_tid, AG-96 loads no obj_id
            "bezeichnung": row.bezeichnung,
        }

    def base_common_ag64(self, row):
        """
        Returns common attributes for base
        """
        return {
            "letzte_aenderung_wi": row.letzte_aenderung_wi,
            "datenbewirtschafter_wi": self.get_pk(row.datenbewirtschafter_wi__REL),
            "bemerkung_wi": row.bemerkung_wi,
        }

    def gep_metainformation_common_ag_xx(self, row):
        """
        Returns common attributes for base
        """
        return {
            "letzte_aenderung_gep": row.letzte_aenderung_gep,
            "datenbewirtschafter_gep": self.get_pk(row.datenbewirtschafter_gep__REL),
            "bemerkung_gep": row.bemerkung_gep,
        }

    def knoten_common_ag_xx(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            **self.base_common_ag_xx(row),
            **self.base_common_ag64(row),
            "ara_nr": row.ara_nr,
            "baujahr": row.baujahr,
            "baulicherzustand": row.baulicherzustand,
            "bauwerkstatus": row.bauwerkstatus,
            "deckelkote": row.deckelkote,
            "detailgeometrie": row.detailgeometrie,
            "finanzierung": row.finanzierung,
            "funktionag": row.funktionag,
            "funktionhierarchisch": row.funktionhierarchisch,
            "jahr_zustandserhebung": row.jahr_zustandserhebung,
            "lage": row.lage,
            "lagegenauigkeit": row.lagegenauigkeit,
            "sanierungsbedarf": row.sanierungsbedarf,
            "sohlenkote": row.sohlenkote,
            "zugaenglichkeit": row.zugaenglichkeit,
            "betreiber": self.get_pk(row.betreiber__REL),
            "eigentuemer": self.get_pk(row.eigentuemer__REL),
            "ignore_ws": self.check_ignore_ws(row),
        }

    def haltung_common_ag_xx(self, row):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            **self.base_common_ag_xx(row),
            **self.base_common_ag64(row),
            "baujahr": row.baujahr,
            "baulicherzustand": row.baulicherzustand,
            "bauwerkstatus": row.bauwerkstatus,
            "finanzierung": row.finanzierung,
            "funktionhierarchisch": row.funktionhierarchisch,
            "funktionhydraulisch": row.funktionhydraulisch,
            "hoehengenauigkeit_von": row.hoehengenauigkeit_von,
            "hoehengenauigkeit_nach": row.hoehengenauigkeit_nach,
            "jahr_zustandserhebung": row.jahr_zustandserhebung,
            "lichte_hoehe_ist": row.lichte_hoehe_ist,
            "kote_beginn": row.kote_beginn,
            "kote_ende": row.kote_ende,
            "laengeeffektiv": row.laengeeffektiv,
            "material": row.material,
            "nutzungsartag_ist": row.nutzungsartag_ist,
            "profiltyp": row.profiltyp,
            "reliner_art": row.reliner_art,
            "reliner_bautechnik": row.reliner_bautechnik,
            "sanierungsbedarf": row.sanierungsbedarf,
            "verlauf": row.verlauf,
            "wbw_basisjahr": row.wbw_basisjahr,
            "wiederbeschaffungswert": row.wiederbeschaffungswert,
            "betreiber": self.get_pk(row.betreiber__REL),
            "eigentuemer": self.get_pk(row.eigentuemer__REL),
            "startknoten": self.get_pk(row.startknoten__REL),
            "endknoten": self.get_pk(row.endknoten__REL),
        }

    def ueberlauf_foerderaggregat_common_ag_xx(self, row):
        """
        Returns common attributes for ueberlauf_foerderaggregat
        """
        return {
            **self.base_common_ag_xx(row),
            "art": row.art,
            "knotenref": self.get_pk(row.knotenref__REL),
            "knoten_nachref": self.get_pk(row.knoten_nachref__REL),
        }

    def _import_gepmassnahme(self):
        for row in self.session_interlis.query(self.model_classes_interlis.gepmassnahme):
            gepmassnahme = self.create_or_update(
                self.model_classes_tww_app.gepmassnahme,
                **self.base_common_ag_xx(row),
                **self.gep_metainformation_common_ag_xx(row),
                ausdehnung=row.ausdehnung,
                beschreibung=row.beschreibung,
                datum_eingang=row.datum_eingang,
                gesamtkosten=row.gesamtkosten,
                handlungsbedarf=row.handlungsbedarf,
                jahr_umsetzung_effektiv=row.jahr_umsetzung_effektiv,
                jahr_umsetzung_geplant=row.jahr_umsetzung_geplant,
                kategorie=row.kategorie,
                perimeter=row.perimeter,
                prioritaetag=row.prioritaetag,
                status=row.astatus,
                symbolpos=row.symbolpos,
                verweis=row.verweis,
                traegerschaft=self.get_pk(row.traegerschaft__REL),
                verantwortlich_ausloesung=self.get_pk(row.verantwortlich_ausloesung__REL),
            )
            self.session_tww.add(gepmassnahme)
            print(".", end="")

    def _import_gepknoten(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.abwasserbauwerk
        ):  # abwasserbauwerk wegen Kompatibiltät bei Label-Export
            gepknoten = self.create_or_update(
                self.model_classes_tww_app.gepknoten,
                **self.gep_metainformation_common_ag_xx(row),
                **self.knoten_common_ag_xx(row),
                istschnittstelle=row.istschnittstelle,
                maxrueckstauhoehe=row.maxrueckstauhoehe,
                gepmassnahmeref=self.get_pk(row.gepmassnahmeref__REL),
            )
            self.session_tww.add(gepknoten)
            print(".", end="")

    def _import_infrastrukturknoten(self):
        # abwasserbauwerk wegen Kompatibiltät bei Label-Export
        for row in self.session_interlis.query(self.model_classes_interlis.abwasserbauwerk):
            gepknoten = self.create_or_update(
                self.model_classes_tww_app.gepknoten,
                **self.knoten_common_ag_xx(row),
            )
            self.session_tww.add(gepknoten)
            print(".", end="")

    def _import_gephaltung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.haltung):
            gephaltung = self.create_or_update(
                self.model_classes_tww_app.gephaltung,
                **self.gep_metainformation_common_ag_xx(row),
                **self.haltung_common_ag_xx(row),
                gepmassnahmeref=self.get_pk(row.gepmassnahmeref__REL),
                hydraulischebelastung=row.hydraulischebelastung,
                lichte_breite_ist=row.lichte_breite_ist,
                lichte_breite_geplant=row.lichte_breite_geplant,
                lichte_hoehe_geplant=row.lichte_hoehe_geplant,
                nutzungsartag_geplant=row.nutzungsartag_geplant,
            )
            self.session_tww.add(gephaltung)
            print(".", end="")

    def _import_infrastrukturhaltung(self):
        for row in self.session_interlis.query(self.model_classes_interlis.haltung):
            gephaltung = self.create_or_update(
                self.model_classes_tww_app.gephaltung,
                **self.haltung_common_ag_xx(row),
                lichte_breite_ist=row.lichte_breite,
            )
            self.session_tww.add(gephaltung)
            print(".", end="")

    def _import_einzugsgebiet_ag96(self):
        for row in self.session_interlis.query(self.model_classes_interlis.einzugsgebiet):
            einzugsgebiet = self.create_or_update(
                self.model_classes_tww_app.einzugsgebiet,
                **self.base_common_ag_xx(row),
                **self.gep_metainformation_common_ag_xx(row),
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
                gepknoten_rw_geplantref=self.get_pk(row.gepknoten_rw_geplantref__REL),
                gepknoten_rw_istref=self.get_pk(row.gepknoten_rw_istref__REL),
                gepknoten_sw_geplantref=self.get_pk(row.gepknoten_sw_geplantref__REL),
                gepknoten_sw_istref=self.get_pk(row.gepknoten_sw_istref__REL),
            )
            self.session_tww.add(einzugsgebiet)
            print(".", end="")

    def _import_bautenausserhalbbaugebiet(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.bautenausserhalbbaugebiet
        ):
            bautenausserhalbbaugebiet = self.create_or_update(
                self.model_classes_tww_app.bautenausserhalbbaugebiet,
                **self.base_common_ag_xx(row),
                **self.gep_metainformation_common_ag_xx(row),
                anzstaendigeeinwohner=row.anzstaendigeeinwohner,
                arealnutzung=row.arealnutzung,
                beseitigung_haeusliches_abwasser=row.beseitigung_haeusliches_abwasser,
                beseitigung_gewerbliches_abwasser=row.beseitigung_gewerbliches_abwasser,
                beseitigung_platzentwaesserung=row.beseitigung_platzentwaesserung,
                beseitigung_dachentwaesserung=row.beseitigung_dachentwaesserung,
                eigentuemeradresse=row.eigentuemeradresse,
                eigentuemername=row.eigentuemername,
                einwohnergleichwert=row.einwohnergleichwert,
                lage=row.lage,
                nummer=row.nummer,
                sanierungsbedarf=row.sanierungsbedarf,
                sanierungsdatum=row.sanierungsdatum,
                sanierungskonzept=row.sanierungskonzept,
            )
            self.session_tww.add(bautenausserhalbbaugebiet)
            print(".", end="")

    def _import_ueberlauf_foerderaggregat_ag96(self):
        for row in self.session_interlis.query(
            self.model_classes_interlis.ueberlauf_foerderaggregat
        ):
            ueberlauf_foerderaggregat = self.create_or_update(
                self.model_classes_tww_app.ueberlauf_foerderaggregat,
                **self.gep_metainformation_common_ag_xx(row),
                **self.ueberlauf_foerderaggregat_common_ag_xx(row),
            )
            self.session_tww.add(ueberlauf_foerderaggregat)
            print(".", end="")

    def _import_ueberlauf_foerderaggregat_ag64(self):

        for row in self.session_interlis.query(
            self.model_classes_interlis.ueberlauf_foerderaggregat
        ):
            ueberlauf_foerderaggregat = self.create_or_update(
                self.model_classes_tww_app.ueberlauf_foerderaggregat,
                **self.ueberlauf_foerderaggregat_common_ag_xx(row),
            )
            self.session_tww.add(ueberlauf_foerderaggregat)
            print(".", end="")
        logger.info("done")

    def _import_sbw_einzugsgebiet(self):
        for row in self.session_interlis.query(self.model_classes_interlis.sbw_einzugsgebiet):
            sbw_einzugsgebiet = self.create_or_update(
                self.model_classes_tww_app.sbw_einzugsgebiet,
                **self.base_common_ag_xx(row),
                **self.gep_metainformation_common_ag_xx(row),
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
                perimeter_ist=ST_Multi(row.perimeter_ist),
                schmutzabwasseranfall_geplant=row.schmutzabwasseranfall_geplant,
                schmutzabwasseranfall_ist=row.schmutzabwasseranfall_ist,
                einleitstelleref=self.get_pk(row.einleitstelleref__REL),
                sonderbauwerk_ref=self.get_pk(row.sonderbauwerk_ref__REL),
            )
            self.session_tww.add(sbw_einzugsgebiet)
            print(".", end="")

    def _import_versickerungsbereichag(self):
        for row in self.session_interlis.query(self.model_classes_interlis.versickerungsbereichag):
            versickerungsbereichag = self.create_or_update(
                self.model_classes_tww_app.versickerungsbereichag,
                **self.base_common_ag_xx(row),
                **self.gep_metainformation_common_ag_xx(row),
                durchlaessigkeit=row.durchlaessigkeit,
                einschraenkung=row.einschraenkung,
                maechtigkeit=row.maechtigkeit,
                perimeter=row.perimeter,
                q_check=row.q_check,
                versickerungsmoeglichkeitag=row.versickerungsmoeglichkeitag,
            )
            self.session_tww.add(versickerungsbereichag)
            print(".", end="")
