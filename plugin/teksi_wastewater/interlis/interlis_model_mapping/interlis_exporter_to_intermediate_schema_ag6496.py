import json

from geoalchemy2.functions import ST_Force2D, ST_GeomFromGeoJSON
from sqlalchemy import or_
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from .. import utils
from ..utils.various import logger


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

        # Logging disabled (very slow)
        self.tww_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.abwasser_session = Session(
            utils.tww_sqlalchemy.create_engine(), autocommit=False, autoflush=False
        )
        self.tid_maker = utils.ili2db.TidMaker(id_attribute="obj_id")

    def tww_export(self):
        try:
            self._tww_export()
            self.abwasser_session.commit()
            self.close_sessions()
        except Exception as exception:
            self.close_sessions()
            raise exception

    def _tww_export(self):
        # Allow to insert rows with cyclic dependencies at once
        self.abwasser_session.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        if self.basket_enabled:
            raise Exception("Export with baskets is not implemented")

        logger.info("Exporting TWW.organisation -> ABWASSER.organisation")
        self._export_organisation()
        self._check_for_stop()

        logger.info("Exporting TWW.gepmassnahme -> ABWASSER.gepmassnahme")
        self._export_gepmassnahme()
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

        # Labels
        # Note: these are extracted from the optional labels file (not exported from the TWW database)
        if self.labels_file:
            logger.info(f"Exporting label positions from {self.labels_file}")
            self._export_label_positions()


    # Filter sind nicht implementiert
    def _export_organisation(self):
        query = self.tww_session.query(self.model_classes_tww_od.organisation)
        for row in query:
            organisation = self.model_classes_interlis.organisation(
                # FIELDS TO MAP TO ABWASSER.organisation
                t_id=get_tid(row),
                t_ili_tid=row.obj_id,
                obj_id=row.obj_id,
                auid=row.uid,
                bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 80),
                kurzbezeichnung=truncate(emptystr_to_null(row.kurzbezeichnung), 12),
                datenbewirtschafter_kt=row.datenbewirtschafter_kt,
                organisationstyp=get_vl(row.organisationstyp),
                letzte_aenderung=row.letzte_aenderung,
                bemerkung=truncate(emptystr_to_null(row.bemerkung), 80),
            )
            self.abwasser_session.add(organisation)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_gepmassnahme(self):
        query = self.tww_session.query(self.model_classes_tww_od.gepmassnahme)
        # TO DO: Filter via Knotenref/Haltungsref
        # if self.filtered:
        #     query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
        #         self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
        #     )
        for row in query:
            gepmassnahme = self.model_classes_interlis.gepmassnahme(
                **self.gep_metainformation_common(row,'gepmassnahme'),
                ausdehnung=row.ausdehnung,
                baulicherzustand=get_vl(row.baulicherzustand),
                beschreibung=truncate(emptystr_to_null(row.bemerkung_wi), 100),
                bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
                datum_eingang=row.datum_eingang,
                finanzierung=row.finanzierung),
                gesamtkosten=row.gesamtkosten,
                handlungsbedarf=row.handlungsbedarf,
                jahr_umsetzung_effektiv=row.jahr_umsetzung_effektiv,
                jahr_umsetzung_geplant=row.jahr_umsetzung_geplant,
                kategorie=get_vl(row.kategorie),
                perimeter=row.perimeter,
                prioritaetag=get_vl(row.prioritaetag),
                status=get_vl(row.status),
                symbolpos=row.symbolpos,
                verweis=row.verweis,
                traegerschaft=getattr(row.traegerschaft, "obj_id", "unbekannt"),
                verantwortlicher_ausloesung=getattr(row.verantwortlicher_ausloesung, "obj_id", "unbekannt"),
            )
            self.abwasser_session.add(gepmassnahme)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_gepknoten(self):
        query = self.tww_session.query(self.model_classes_tww_od.gepknoten)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        
        """
        GEPKnoten werden nach Fläche sortiert hinzugefügt, damit bei der Triggerlogik
        hinter {ext_schema}.gepknoten die Verknüpfung zu anderen Abwasserbauwerken 
        basierend auf einem Spatial Join implementiert werden kann.
        Dies ist relevant, da Zweitknoten der FunktionAG "andere", die innerhalb der Detailgeometrie
        eines anderen Abwasserbauwerks liegen, als Deckel importiert werden.
        """
        query.order_by(nullslast(self.model_classes_tww_od.gepknoten.detailgeometrie.ST_Area().asc()))
        for row in query:
            gepknoten = self.model_classes_interlis.abwasserbauwerk( #abwasserbauwerk wegen Kompatibiltät bei Label-Export
                **self.gep_metainformation_common(row,'gepknoten'),
                **self.knoten_common(row,'gepknoten'),
                istschnittstelle=get_vl(row.istischnittstelle),
                maxrueckstauhoehe=row.maxrueckstauhoehe,
                gepmassnahmeref=getattr(row.gepmassnahmeref, "obj_id", "unbekannt"),
            )
            self.abwasser_session.add(gepknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infrastrukturknoten(self):
        query = self.tww_session.query(self.model_classes_tww_od.infrastrukturknoten)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        
        """
        InfrastrukturKnoten werden nach Fläche sortiert hinzugefügt, damit bei der Triggerlogik
        hinter {ext_schema}.gepknoten die Verknüpfung zu anderen Abwasserbauwerken 
        basierend auf einem Spatial Join implementiert werden kann.
        Dies ist relevant, da Zweitknoten der FunktionAG "andere", die innerhalb der Detailgeometrie
        eines anderen Abwasserbauwerks liegen, als Deckel importiert werden.
        """
        query.order_by(nullslast(self.model_classes_tww_od.infrastrukturknoten.detailgeometrie.ST_Area().asc()))
        for row in query:
            infrastrukturknoten = self.model_classes_interlis.infrastrukturknoten(
                **self.base_common(row,'infrastrukturknoten'),
                **self.knoten_common(row,'infrastrukturknoten'),
            )
            self.abwasser_session.add(infrastrukturknoten)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_gephaltung(self):
        query = self.tww_session.query(self.model_classes_tww_od.gephaltung)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            gephaltung = self.model_classes_interlis.haltung(
                **self.gep_metainformation_common(row,'gephaltung'),
                **self.haltung_common(row,'gephaltung'),
                hydraulischebelastung=row.hydraulischebelastung,
                lichte_breite_geplant=row.lichte_breite_geplant,
                lichte_hoehe_geplant=row.lichte_hoehe_geplant,
                nutzungsartag_geplant=get_vl(row.nutzungsartag_geplant),
                gepmassnahmeref=getattr(row.gepmassnahmeref, "obj_id", "unbekannt"),
            )
            self.abwasser_session.add(gephaltung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_infrastrukturhaltung(self):
        query = self.tww_session.query(self.model_classes_tww_od.infrastrukturhaltung)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            infrastrukturhaltung = self.model_classes_interlis.haltung(
                # --- abwasserbauwerk ---
                **self.base_common(row,'infrastrukturhaltung'),
                **self.haltung_common(row,'infrastrukturhaltung'),
            )
            self.abwasser_session.add(infrastrukturhaltung)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_ueberlauf_foerderaggregat_ag96(self):
        query = self.tww_session.query(self.model_classes_tww_od.ueberlauf_foerderaggregat)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            ueberlauf_foerderaggregat = self.model_classes_interlis.ueberlauf_foerderaggregat(
                **self.gep_metainformation_common(row,'ueberlauf_foerderaggregat'),
                **self.ueberlauf_foerderaggregat_common(row),
            )
            self.abwasser_session.add(ueberlauf_foerderaggregat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_ueberlauf_foerderaggregat_ag64(self):
        query = self.tww_session.query(self.model_classes_tww_od.ueberlauf_foerderaggregat)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            ueberlauf_foerderaggregat = self.model_classes_interlis.ueberlauf_foerderaggregat(
                # --- abwasserbauwerk ---
                **self.base_common(row,'ueberlauf_foerderaggregat'),
                **self.ueberlauf_foerderaggregat_common(row),
            )
            self.abwasser_session.add(ueberlauf_foerderaggregat)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_sbw_einzugsgebiet(self):
        query = self.tww_session.query(self.model_classes_tww_od.sbw_einzugsgebiet)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            sbw_einzugsgebiet = self.model_classes_interlis.sbw_einzugsgebiet(
                # --- abwasserbauwerk ---
                **self.base_common(row,'sbw_einzugsgebiet'),
                            bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
                            flaeche_geplant=row.flaeche_geplant,
                            flaeche_ist=row.flaeche_ist,
                            flaeche_befestigt_geplant=row.flaeche_befestigt_geplant,
                            flaeche_befestigt_ist=row.flaeche_befestigt_ist,
                            flaeche_reduziert_geplant=row.flaeche_reduziert_geplant,
                            flaeche_reduziert_ist=row.flaeche_reduziert_ist,
                            fremdwasseranfall_geplant=row.fremdwasseranfall_geplant,
                            fremdwasseranfall_ist=row.fremdwasseranfall_ist,
                            perimeter_ist=row.perimeter_ist,
                            schmutzabwasseranfall_geplant=row.schmutzabwasseranfall_geplant,
                            schmutzabwasseranfall_ist=row.schmutzabwasseranfall_ist,
                            versickerung_geplant=get_vl(row.versickerung_geplant),
                            versickerung_ist=get_vl(row.versickerung_ist),
                            einleitstelleref=getattr(row.einleitstelleref, "obj_id"),
                            sonderbauwerk_ref=getattr(row.sonderbauwerk_ref, "obj_id"),
            )
            self.abwasser_session.add(sbw_einzugsgebiet)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()

    def _export_versickerungsbereichag(self):
        query = self.tww_session.query(self.model_classes_tww_od.versickerungsbereichag)
        if self.filtered:
            query = query.join(self.model_classes_tww_od.wastewater_networkelement).filter(
                self.model_classes_tww_od.wastewater_networkelement.obj_id.in_(self.subset_ids)
            )
        for row in query:
            versickerungsbereichag = self.model_classes_interlis.versickerungsbereichag(
                # --- abwasserbauwerk ---
                **self.base_common(row,'versickerungsbereichag'),
                bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
                durchlaessigkeit=row.durchlaessigkeit,
                einschraenkung=row.einschraenkung,
                maechtigkeit=row.maechtigkeit,
                perimeter=row.perimeter,
                q_check=row.q_check,
                versickerungsmoeglichkeitag=get_vl(row.versickerungsmoeglichkeitag),
                durchlaessigkeit=row.durchlaessigkeit,
            )
            self.abwasser_session.add(versickerungsbereichag)
            print(".", end="")
        logger.info("done")
        self.abwasser_session.flush()
     



    # um neue Labels erweitert. TBD: Check Layer Names.
    def _export_label_positions(self):

        # Labels
        # Note: these are extracted from the optional labels file (not exported from the TWW database)
        if self.labels_file:
            logger.info(f"Exporting label positions from {self.labels_file}")

            # Get t_id by obj_name to create the reference on the labels below
            tid_for_obj_id = {
                "haltung": {},
                "abwasserbauwerk": {},
                "einzugsgebiet": {},
                "gepmassnahme": {},
                "bautenausserhalbbaugebiet": {},
            }
            for row in self.abwasser_session.query(self.model_classes_interlis.haltung):
                tid_for_obj_id["haltung"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.model_classes_interlis.abwasserbauwerk):
                tid_for_obj_id["abwasserbauwerk"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.model_classes_interlis.einzugsgebiet):
                tid_for_obj_id["einzugsgebiet"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.model_classes_interlis.gepmassnahme):
                tid_for_obj_id["gepmassnahme"][row.obj_id] = row.t_id
            for row in self.abwasser_session.query(self.model_classes_interlis.bautenausserhalbbaugebiet):
                tid_for_obj_id["bautenausserhalbbaugebiet"][row.obj_id] = row.t_id

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

                elif layer_name == "catchment_area":
                    if obj_id not in tid_for_obj_id["einzugsgebiet"]:
                        logger.warning(
                            f"Label for einzugsgebiet `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.model_classes_interlis.einzugsgebiet_text(
                        **self.textpos_common(label, "einzugsgebiet_text", geojson_crs_def),
                        einzugsgebietref=tid_for_obj_id["einzugsgebiet"][obj_id],
                    )

                elif layer_name == "gepmassnahme":
                    if obj_id not in tid_for_obj_id["gepmassnahme"]:
                        logger.warning(
                            f"Label for gepmassnahme `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.model_classes_interlis.gepmassnahme_text(
                        **self.textpos_common(label, "gepmassnahme_text", geojson_crs_def),
                        gepmassnahmeref=tid_for_obj_id["gepmassnahme"][obj_id],
                    )


                elif layer_name == "bautenausserhalbbaugebiet":
                    if obj_id not in tid_for_obj_id["bautenausserhalbbaugebiet"]:
                        logger.warning(
                            f"Label for bautenausserhalbbaugebiet `{obj_id}` exists, but that object is not part of the export"
                        )
                        continue
                    ili_label = self.model_classes_interlis.bautenausserhalbbaugebiet_text(
                        **self.textpos_common(label, "bautenausserhalbbaugebiet_text", geojson_crs_def),
                        bautenausserhalbbaugebietref=tid_for_obj_id["bautenausserhalbbaugebiet"][obj_id],
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

    # Basisfunktionen Teksi

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

    def close_sessions(self):
        self.tww_session.close()
        self.abwasser_session.close()

    def _check_for_stop(self):
        if self.callback_progress_done:
            self.callback_progress_done()

    # Funktionen auf Basis VSA

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
        Returns common attributes for metainformation
        """
        return {
            **self.sia_405_base_common(row, type_name),
            "datenherrref": self.get_tid(row.fk_dataowner__REL),
            "datenlieferantref": self.get_tid(row.fk_provider__REL),
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

    # Funktionen auf Basis AG-xx

    def gep_metainformation_common(self, row, type_name):
        return {
            **self.base_common(row, type_name),
            "bemerkung_gep": row.bemerkung_gep,
            "datenbewirtschafter_gep": row.datenbewirtschafter_gep,
            "letzte_aenderung_gep": row.letzte_aenderung_gep,
        }

    def knoten_common(self, row, type_name):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            ara_nr=row.ara_nr,
            baujahr=row.baujahr,
            baulicherzustand=get_vl(row.baulicherzustand),
            bauwerkstatus=get_vl(row.bauwerkstatus),
            bemerkung_wi=truncate(emptystr_to_null(row.bemerkung_wi), 80),
            bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
            deckelkote=row.deckelkote,
            detailgeometrie=row.detailgeometrie,
            finanzierung=get_vl(row.finanzierung),
            funktionag=get_vl(row.funktionag),
            funktionhierarchisch=get_vl(row.funktionhierarchisch),
            jahr_zustandserhebung=row.jahr_zustandserhebung,
            lage=row.lage,
            letzte_aenderung_wi=row.letzte_aenderung_wi,
            sanierungsbedarf=get_vl(row.sanierungsbedarf),
            sohlenkote=row.sohlenkote,
            zugaenglichkeit=get_vl(row.zugaenglichkeit),
            betreiber=getattr(row.betreiber, "obj_id", "unbekannt"),
            datenbewirtschafter_wi=getattr(row.datenbewirtschafter_wi, "obj_id", "unbekannt"),
            eigentuemer=getattr(row.eigentuemer, "obj_id", "unbekannt"),
        }

    def haltung_common(self, row, type_name):
        """
        Returns common attributes for wastewater_structure
        """
        return {
            baujahr=row.baujahr,
            baulicherzustand=get_vl(row.baulicherzustand),
            bauwerkstatus=get_vl(row.bauwerkstatus),
            bemerkung_wi=truncate(emptystr_to_null(row.bemerkung_wi), 80),
            bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
            finanzierung=get_vl(row.finanzierung),
            funktionhierarchisch=get_vl(row.funktionhierarchisch),
            funktionhydraulisch=get_vl(row.funktionhydraulisch),
            hoehengenauigkeit_nach=get_vl(row.hoehengenauigkeit_nach),
            hoehengenauigkeit_von=get_vl(row.hoehengenauigkeit_von),
            jahr_zustandserhebung=row.jahr_zustandserhebung,
            kote_beginn=row.kote_beginn,
            kote_ende=row.kote_ende,
            letzte_aenderung_wi=row.letzte_aenderung_wi,
            lichte_breite_ist=row.lichte_breite_ist,
            lichte_hoehe_ist=row.lichte_hoehe_ist,
            laengeeffektiv=row.laengeeffektiv,
            material=get_vl(row.material),
            profiltyp=get_vl(row.profiltyp),
            nutzungsartag_ist=get_vl(row.nutzungartag_ist),
            reliner_art=get_vl(row.reliner_art),
            reliner_bautechnik=get_vl(row.reliner_bautechnik),
            reliner_material=get_vl(row.reliner_material),
            reliner_nennweite=row.reliner_nennweite,
            sanierungsbedarf=get_vl(row.sanierungsbedarf),
            verlauf=row.verlauf,
            wbw_basisjahr=row.wbw_basisjahr,
            wiederbeschaffungswert=row.wiederbeschaffungswert,
            betreiber=getattr(row.betreiber, "obj_id", "unbekannt"),
            datenbewirtschafter_wi=getattr(row.datenbewirtschafter_wi, "obj_id", "unbekannt"),
            eigentuemer=getattr(row.eigentuemer, "obj_id", "unbekannt"),
            endknoten=getattr(row.endknoten, "obj_id"),
            startknoten=getattr(row.startknoten, "obj_id"),
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

    def ueberlauf_foerderaggregat_common(self, row):
        """
        Returns common attributes for ueberlauf_foerderaggregat
        """
        return {
            art=get_vl(row.art),
            bezeichnung=truncate(emptystr_to_null(row.bezeichnung), 20),
            knotenref=getattr(row.knotenref, "obj_id"),
            knoten_nachref=getattr(row.knoten_nachref, "obj_id"),
        }
