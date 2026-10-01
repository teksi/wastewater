from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisDss(ModelInterlisSia405Abwasser):
    def __init__(self, schema):
        super().__init__(schema)

        class anschlussobjekt(self.vsa_baseclass):
            __tablename__ = "anschlussobjekt"
            __table_args__ = {"schema": self.schema}

        self.anschlussobjekt = anschlussobjekt

        class erhaltungsereignis(self.vsa_baseclass):
            __tablename__ = "erhaltungsereignis"
            __table_args__ = {"schema": self.schema}

        self.erhaltungsereignis = erhaltungsereignis

        class oberflaechenabflussparameter(self.vsa_baseclass):
            __tablename__ = "oberflaechenabflussparameter"
            __table_args__ = {"schema": self.schema}

        self.oberflaechenabflussparameter = oberflaechenabflussparameter

        class ueberlauf(self.vsa_baseclass):
            __tablename__ = "ueberlauf"
            __table_args__ = {"schema": self.schema}

        self.ueberlauf = ueberlauf

        class zone(self.vsa_baseclass):
            __tablename__ = "azone"
            __table_args__ = {"schema": self.schema}

        self.zone = zone

        class abwasserreinigungsanlage(self.vsa_baseclass):
            __tablename__ = "abwasserreinigungsanlage"
            __table_args__ = {"schema": self.schema}

        self.abwasserreinigungsanlage = abwasserreinigungsanlage

        class araenergienutzung(self.vsa_baseclass):
            __tablename__ = "araenergienutzung"
            __table_args__ = {"schema": self.schema}

        self.araenergienutzung = araenergienutzung

        class abwasserbehandlung(self.vsa_baseclass):
            __tablename__ = "abwasserbehandlung"
            __table_args__ = {"schema": self.schema}

        self.abwasserbehandlung = abwasserbehandlung

        class schlammbehandlung(self.vsa_baseclass):
            __tablename__ = "schlammbehandlung"
            __table_args__ = {"schema": self.schema}

        self.schlammbehandlung = schlammbehandlung

        class arabauwerk(self.abwasserbauwerk):
            __tablename__ = "arabauwerk"
            __table_args__ = {"schema": self.schema}

        self.arabauwerk = arabauwerk

        class steuerungszentrale(self.vsa_baseclass):
            __tablename__ = "steuerungszentrale"
            __table_args__ = {"schema": self.schema}

        self.steuerungszentrale = steuerungszentrale

        class abflusslose_toilette(self.abwasserbauwerk):
            __tablename__ = "abflusslose_toilette"
            __table_args__ = {"schema": self.schema}

        self.abflusslose_toilette = abflusslose_toilette

        class absperr_drosselorgan(self.vsa_baseclass):
            __tablename__ = "absperr_drosselorgan"
            __table_args__ = {"schema": self.schema}

        self.absperr_drosselorgan = absperr_drosselorgan

        class beckenentleerung(self.bauwerksteil):
            __tablename__ = "beckenentleerung"
            __table_args__ = {"schema": self.schema}

        self.beckenentleerung = beckenentleerung

        class beckenreinigung(self.bauwerksteil):
            __tablename__ = "beckenreinigung"
            __table_args__ = {"schema": self.schema}

        self.beckenreinigung = beckenreinigung

        class biol_oekol_gesamtbeurteilung(erhaltungsereignis):
            __tablename__ = "biol_oekol_gesamtbeurteilung"
            __table_args__ = {"schema": self.schema}

        self.biol_oekol_gesamtbeurteilung = biol_oekol_gesamtbeurteilung

        class brunnen(anschlussobjekt):
            __tablename__ = "brunnen"
            __table_args__ = {"schema": self.schema}

        self.brunnen = brunnen

        class ezg_parameter_allg(oberflaechenabflussparameter):
            __tablename__ = "ezg_parameter_allg"
            __table_args__ = {"schema": self.schema}

        self.ezg_parameter_allg = ezg_parameter_allg

        class ezg_parameter_mouse1(oberflaechenabflussparameter):
            __tablename__ = "ezg_parameter_mouse1"
            __table_args__ = {"schema": self.schema}

        self.ezg_parameter_mouse1 = ezg_parameter_mouse1

        class einzelflaeche(anschlussobjekt):
            __tablename__ = "einzelflaeche"
            __table_args__ = {"schema": self.schema}

        self.einzelflaeche = einzelflaeche

        class einzugsgebiet(self.vsa_baseclass):
            __tablename__ = "einzugsgebiet"
            __table_args__ = {"schema": self.schema}

        self.einzugsgebiet = einzugsgebiet

        class einzugsgebiet_text(self.sia405_textpos):
            __tablename__ = "einzugsgebiet_text"
            __table_args__ = {"schema": self.schema}

        self.einzugsgebiet_text = einzugsgebiet_text

        class elektrischeeinrichtung(self.bauwerksteil):
            __tablename__ = "elektrischeeinrichtung"
            __table_args__ = {"schema": self.schema}

        self.elektrischeeinrichtung = elektrischeeinrichtung

        class elektromechanischeausruestung(self.bauwerksteil):
            __tablename__ = "elektromechanischeausruestung"
            __table_args__ = {"schema": self.schema}

        self.elektromechanischeausruestung = elektromechanischeausruestung

        class entsorgung(self.vsa_baseclass):
            __tablename__ = "entsorgung"
            __table_args__ = {"schema": self.schema}

        self.entsorgung = entsorgung

        class entwaesserungssystem(zone):
            __tablename__ = "entwaesserungssystem"
            __table_args__ = {"schema": self.schema}

        self.entwaesserungssystem = entwaesserungssystem

        class feststoffrueckhalt(self.bauwerksteil):
            __tablename__ = "feststoffrueckhalt"
            __table_args__ = {"schema": self.schema}

        self.feststoffrueckhalt = feststoffrueckhalt

        class foerderaggregat(ueberlauf):
            __tablename__ = "foerderaggregat"
            __table_args__ = {"schema": self.schema}

        self.foerderaggregat = foerderaggregat

        class gebaeude(anschlussobjekt):
            __tablename__ = "gebaeude"
            __table_args__ = {"schema": self.schema}

        self.gebaeude = gebaeude

        class gebaeudegruppe(self.vsa_baseclass):
            __tablename__ = "gebaeudegruppe"
            __table_args__ = {"schema": self.schema}

        self.gebaeudegruppe = gebaeudegruppe

        class gebaeudegruppe_baugwr(self.vsa_baseclass):
            __tablename__ = "gebaeudegruppe_baugwr"
            __table_args__ = {"schema": self.schema}

        self.gebaeudegruppe_baugwr = gebaeudegruppe_baugwr

        class gesamteinzugsgebiet(self.vsa_baseclass):
            __tablename__ = "gesamteinzugsgebiet"
            __table_args__ = {"schema": self.schema}

        self.gesamteinzugsgebiet = gesamteinzugsgebiet

        class hq_relation(self.vsa_baseclass):
            __tablename__ = "hq_relation"
            __table_args__ = {"schema": self.schema}

        self.hq_relation = hq_relation

        class hydr_geomrelation(self.vsa_baseclass):
            __tablename__ = "hydr_geomrelation"
            __table_args__ = {"schema": self.schema}

        self.hydr_geomrelation = hydr_geomrelation

        class hydr_geometrie(self.vsa_baseclass):
            __tablename__ = "hydr_geometrie"
            __table_args__ = {"schema": self.schema}

        self.hydr_geometrie = hydr_geometrie

        class hydr_kennwerte(self.vsa_baseclass):
            __tablename__ = "hydr_kennwerte"
            __table_args__ = {"schema": self.schema}

        self.hydr_kennwerte = hydr_kennwerte

        class klara(self.abwasserbauwerk):
            __tablename__ = "klara"
            __table_args__ = {"schema": self.schema}

        self.klara = klara

        class landwirtschaftsbetrieb(self.vsa_baseclass):
            __tablename__ = "landwirtschaftsbetrieb"
            __table_args__ = {"schema": self.schema}

        self.landwirtschaftsbetrieb = landwirtschaftsbetrieb

        class leapingwehr(ueberlauf):
            __tablename__ = "leapingwehr"
            __table_args__ = {"schema": self.schema}

        self.leapingwehr = leapingwehr

        class massnahme(self.vsa_baseclass):
            __tablename__ = "massnahme"
            __table_args__ = {"schema": self.schema}

        self.massnahme = massnahme

        class mechanischevorreinigung(self.vsa_baseclass):
            __tablename__ = "mechanischevorreinigung"
            __table_args__ = {"schema": self.schema}

        self.mechanischevorreinigung = mechanischevorreinigung

        class messgeraet(self.vsa_baseclass):
            __tablename__ = "messgeraet"
            __table_args__ = {"schema": self.schema}

        self.messgeraet = messgeraet

        class messreihe(self.vsa_baseclass):
            __tablename__ = "messreihe"
            __table_args__ = {"schema": self.schema}

        self.messreihe = messreihe

        class messresultat(self.vsa_baseclass):
            __tablename__ = "messresultat"
            __table_args__ = {"schema": self.schema}

        self.messresultat = messresultat

        class messstelle(self.vsa_baseclass):
            __tablename__ = "messstelle"
            __table_args__ = {"schema": self.schema}

        self.messstelle = messstelle

        class mutation(self.vsa_baseclass):
            __tablename__ = "mutation"
            __table_args__ = {"schema": self.schema}

        self.mutation = mutation

        class reservoir(anschlussobjekt):
            __tablename__ = "reservoir"
            __table_args__ = {"schema": self.schema}

        self.reservoir = reservoir

        class retentionskoerper(self.vsa_baseclass):
            __tablename__ = "retentionskoerper"
            __table_args__ = {"schema": self.schema}

        self.retentionskoerper = retentionskoerper

        class rohrprofil_geometrie(self.vsa_baseclass):
            __tablename__ = "rohrprofil_geometrie"
            __table_args__ = {"schema": self.schema}

        self.rohrprofil_geometrie = rohrprofil_geometrie

        class rueckstausicherung(self.bauwerksteil):
            __tablename__ = "rueckstausicherung"
            __table_args__ = {"schema": self.schema}

        self.rueckstausicherung = rueckstausicherung

        class stammkarte(self.vsa_baseclass):
            __tablename__ = "stammkarte"
            __table_args__ = {"schema": self.schema}

        self.stammkarte = stammkarte

        class streichwehr(ueberlauf):
            __tablename__ = "streichwehr"
            __table_args__ = {"schema": self.schema}

        self.streichwehr = streichwehr

        class ueberlaufcharakteristik(self.vsa_baseclass):
            __tablename__ = "ueberlaufcharakteristik"
            __table_args__ = {"schema": self.schema}

        self.ueberlaufcharakteristik = ueberlaufcharakteristik

        class unterhalt(erhaltungsereignis):
            __tablename__ = "unterhalt"
            __table_args__ = {"schema": self.schema}

        self.unterhalt = unterhalt

        class versickerungsbereich(zone):
            __tablename__ = "versickerungsbereich"
            __table_args__ = {"schema": self.schema}

        self.versickerungsbereich = versickerungsbereich

        class erhaltungsereignis_abwasserbauwerkassoc(self.Base):
            __tablename__ = "erhaltungsereignis_abwasserbauwerkassoc"
            __table_args__ = {"schema": self.schema}

        self.erhaltungsereignis_abwasserbauwerkassoc = erhaltungsereignis_abwasserbauwerkassoc

        class gebaeudegruppe_entsorgungassoc(self.Base):
            __tablename__ = "gebaeudegruppe_entsorgungassoc"
            __table_args__ = {"schema": self.schema}

        self.gebaeudegruppe_entsorgungassoc = gebaeudegruppe_entsorgungassoc
