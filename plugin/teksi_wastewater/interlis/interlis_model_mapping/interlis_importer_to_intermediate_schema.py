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
        pre_session.execute(text("SELECT tww_sys.drop_symbology_triggers();"))
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
            post_session.execute(text("SELECT tww_sys.create_symbology_triggers();"))
            post_session.commit()
            post_session.close()

        except Exception as exception:
            logger.warning(f"Could not recreate symbology triggers: '{exception}'")

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
                    self.model_classes_tww_od.reach_point_outlet_shape, row.hoehengenauigkeit
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
                fk_examination=row.untersuchungref__REL.t_ili_tid
                if row.untersuchungref__REL
                else None,
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
                fk_examination=row.untersuchungref__REL.t_ili_tid
                if row.untersuchungref__REL
                else None,
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
            file = self.create_or_update(
                self.model_classes_tww_od.file,
                **self.base_common(row),
                # --- file ---
                fk_data_media=row.datentraegerref__REL.t_ili_tid,
                identifier=row.bezeichnung,
                kind=self.get_vl_code(self.model_classes_tww_vl.file_kind, row.art),
                object=row.objekt,
                path_relative=row.relativpfad,
                remark=row.bemerkung,
            )
            # file.class = self.get_vl_code(self.model_classes_tww_vl.file_class, row.klasse) TODO

            self.session_tww.add(file)
            print(".", end="")

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()
