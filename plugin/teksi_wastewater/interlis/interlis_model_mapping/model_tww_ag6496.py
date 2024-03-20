from .. import config
from .model_base import ModelBase
from sqlalchemy import Column, String, DateTime, Integer, Float
from geoalchemy2 import Geometry


class ModelTwwAG6496(ModelBase):
    def __init__(self):
        super().__init__(config.TWW_AG_SCHEMA)

        class organisation(self.Base):
            __tablename__ = "organisation"
            obj_id=Column(String, primary_key=True)
            uid = Column(String)
            bezeichnung = Column(String)
            kurzbezeichnung = Column(String)
            datenbewirtschafter_kt = Column(String)
            organisationtyp = Column(String)
            letzte_aenderung = Column(DateTime)
            bemerkung = Column(String)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.organisation = organisation

        class gepmassnahme(self.Base):
            __tablename__ = "gepmassnahme"
            obj_id=Column(String, primary_key=True)
            ausdehnung = Column(Geometry)
            beschreibung = Column(String)
            bezeichnung = Column(String)
            datum_eingang = Column(DateTime)
            gesamtkosten = Column(Float)
            handlungsbedarf = Column(String)
            jahr_umsetzung_effektiv = Column(Integer)
            jahr_umsetzung_planned = Column(Integer)
            kategorie = Column(String)
            perimeter = Column(Geometry)
            prioritaetag = Column(String)
            status = Column(String)
            symbolpos = Column(Geometry)
            verweis = Column(String)
            traegerschaft = Column(String)
            verantwortlich_ausloesung = Column(String)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepmassnahme = gepmassnahme

        class gepknoten(self.Base):
            __tablename__ = "gepknoten"
            obj_id=Column(String, primary_key=True)
            ara_nr = Column(Integer)
            baujahr = Column(Integer)
            baulicherzustand = Column(String)
            bauwerkstatus = Column(String)
            bemerkung_wi = Column(String)
            bezeichnung = Column(String)
            deckelkote = Column(Float)
            detailgeometrie = Column(Geometry)
            finanzierung = Column(String)
            funktionag = Column(String)
            funktionhierarchisch = Column(String)
            istschnittstelle = Column(String)
            jahr_zustandserhebung = Column(Integer)
            lage = Column(Geometry)
            lagegenauigkeit = Column(String)
            letzte_aenderung_wi = Column(DateTime)
            maxrueckstauhoehe = Column(Float)
            sanierungsbedarf = Column(String)
            sohlenkote = Column(Float)
            zugaenglichkeit = Column(String)
            betreiber = Column(String)
            datenbewirtschafter_wi = Column(String)
            eigentuemer = Column(String)
            gepmassnahmeref = Column(String)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepknoten = gepknoten

        class gephaltung(self.Base):
            __tablename__ = "gephaltung"
            obj_id=Column(String, primary_key=True)
            baujahr = Column(Integer)
            baulicherzustand = Column(String)
            bauwerkstatus = Column(String)
            bemerkung_wi = Column(String)
            bezeichnung = Column(String)
            finanzierung = Column(String)
            funktionhierarchisch = Column(String)
            funktionhydraulisch = Column(String)
            hoehengenauigkeit_nach = Column(String)
            hoehengenauigkeit_von = Column(String)
            hydraulischebelastung = Column(Integer)
            jahr_zustandserhebung = Column(Integer)
            kote_beginn = Column(Float)
            kote_ende = Column(Float)
            letzte_aenderung_wi = Column(DateTime)
            lichte_breite_ist = Column(Integer)
            lichte_breite_geplant = Column(Integer)
            lichte_hoehe_ist = Column(Integer)
            lichte_hoehe_geplant = Column(Integer)
            laengeeffektiv = Column(Float)
            material = Column(String)
            profiltyp = Column(String)
            nutzungsartag_ist = Column(String)
            nutzungsartag_geplant = Column(String)
            reliner_art = Column(String)
            reliner_bautechnik = Column(String)
            reliner_material = Column(String)
            reliner_nennweite = Column(Integer)
            sanierungsbedarf = Column(String)
            verlauf = Column(Geometry)
            wbw_basisjahr = Column(Integer)
            wiederbeschaffungswert = Column(Float)
            betreiber = Column(String)
            datenbewirtschafter_wi = Column(String)
            eigentuemer = Column(String)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            gepmassnahmeref = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            startknoten = Column(String)
            endknoten = Column(String)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gephaltung = gephaltung

        class einzugsgebiet(self.Base):
            __tablename__ = "einzugsgebiet"
            obj_id=Column(String, primary_key=True)
            abflussbegrenzung_geplant = Column(Float)
            abflussbegrenzung_ist = Column(Float)
            abflussbeiwert_rw_geplant = Column(Float)
            abflussbeiwert_rw_ist = Column(Float)
            abflussbeiwert_sw_geplant = Column(Float)
            abflussbeiwert_sw_ist = Column(Float)
            befestigungsgrad_rw_geplant = Column(Float)
            befestigungsgrad_rw_ist = Column(Float)
            befestigungsgrad_sw_geplant = Column(Float)
            befestigungsgrad_sw_ist = Column(Float)
            bezeichnung = Column(String)
            direkteinleitung_in_gewaesser_geplant = Column(String)
            direkteinleitung_in_gewaesser_ist = Column(String)
            einwohnerdichte_geplant = Column(Integer)
            einwohnerdichte_ist = Column(Integer)
            entwaesserungssystemag_geplant = Column(String)
            entwaesserungssystemag_ist = Column(String)
            flaeche = Column(Float)
            fremdwasseranfall_geplant = Column(Float)
            fremdwasseranfall_ist = Column(Float)
            perimeter = Column(Geometry)
            perimetertyp = Column(String)
            retention_geplant = Column(String)
            retention_ist = Column(String)
            schmutzabwasseranfall_geplant = Column(Float)
            schmutzabwasseranfall_ist = Column(Float)
            versickerung_geplant = Column(String)
            versickerung_ist = Column(String)
            gepknoten_rw_geplantref = Column(String)
            gepknoten_rw_istref = Column(String)
            gepknoten_sw_geplantref = Column(String)
            gepknoten_sw_istref = Column(String)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.einzugsgebiet = einzugsgebiet

        class bautenausserhalbbaugebiet(self.Base):
            __tablename__ = "bautenausserhalbbaugebiet"
            obj_id=Column(String, primary_key=True)
            anzstaendigeeinwohner = Column(Integer)
            arealnutzung = Column(String)
            beseitigung_haeusliches_abwasser = Column(String)
            beseitigung_gewerbliches_abwasser = Column(String)
            beseitigung_platzentwaesserung = Column(String)
            beseitigung_dachentwaesserung = Column(String)
            bezeichnung = Column(String)
            eigentuemeradresse = Column(String)
            eigentuemername = Column(String)
            einwohnergleichwert = Column(Integer)
            lage = Column(Geometry)
            nummer = Column(Integer)
            sanierungsbedarf = Column(String)
            sanierungsdatum = Column(DateTime)
            sanierungskonzept = Column(String)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.bautenausserhalbbaugebiet = bautenausserhalbbaugebiet

        class ueberlauf_foerderaggregat(self.Base):
            __tablename__ = "ueberlauf_foerderaggregat"
            obj_id=Column(String, primary_key=True)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            art = Column(String)
            bezeichnung = Column(String)
            knotenref = Column(String)
            knoten_nachref = Column(String)

            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.ueberlauf_foerderaggregat = ueberlauf_foerderaggregat

        class versickerungsbereichag(self.Base):
            __tablename__ = "versickerungsbereichag"
            obj_id=Column(String, primary_key=True)
            datenbewirtschafter_gep = Column(String)
            bemerkung_gep = Column(String)
            letzte_aenderung_gep = Column(DateTime)
            bezeichnung = Column(String)
            durchlaessigkeit = Column(String)
            einschraenkung = Column(String)
            maechtigkeit = Column(String)
            perimeter = Column(Geometry)
            ag96_q_check = Column(String)
            versickerungsmoeglichkeitag = Column(String)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}
        
        ModelTwwAG6496.versickerungsbereichag = versickerungsbereichag
