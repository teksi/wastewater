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

        class gepmassnahme(self.Base):
            __tablename__ = "gepmassnahme"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}

        ModelTwwAG6496.gepmassnahme = gepmassnahme

        class bautenausserhalbbaugebiet(self.Base):
            __tablename__ = "bautenausserhalbbaugebiet"
            obj_id=Column(String, primary_key=True)
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

        class sbw_einzugsgebiet(self.Base):
            __tablename__ = "sbw_einzugsgebiet"
            obj_id=Column(String, primary_key=True)
            __table_args__ = {"schema": config.TWW_AG_SCHEMA}
            
        ModelTwwAG6496.sbw_einzugsgebiet = sbw_einzugsgebiet

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
