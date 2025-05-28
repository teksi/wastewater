from sqlalchemy import Column, Integer

from .. import config
from .model_interlis_sia405_abwasser import ModelInterlisSia405Abwasser


class ModelInterlisDss(ModelInterlisSia405Abwasser):
    def __init__(self):
        super().__init__()

        class anschlussobjekt(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "anschlussobjekt"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_anschlussobjekt = Column("t_basket", Integer)

        ModelInterlisDss.anschlussobjekt = anschlussobjekt

        class erhaltungsereignis(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "erhaltungsereignis"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_erhaltungsereignis = Column("t_basket", Integer)

        ModelInterlisDss.erhaltungsereignis = erhaltungsereignis

        class oberflaechenabflussparameter(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "oberflaechenabflussparameter"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_oberflaechenabflussparameter = Column("t_basket", Integer)

        ModelInterlisDss.oberflaechenabflussparameter = oberflaechenabflussparameter

        class ueberlauf(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "ueberlauf"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_ueberlauf = Column("t_basket", Integer)

        ModelInterlisDss.ueberlauf = ueberlauf

        class zone(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "azone"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_azone = Column("t_basket", Integer)

        ModelInterlisDss.zone = zone

        class abwasserreinigungsanlage(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "abwasserreinigungsanlage"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwasserreinigungsanlage = Column("t_basket", Integer)

        ModelInterlisDss.abwasserreinigungsanlage = abwasserreinigungsanlage

        class araenergienutzung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "araenergienutzung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_araenergienutzung = Column("t_basket", Integer)

        ModelInterlisDss.araenergienutzung = araenergienutzung

        class abwasserbehandlung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "abwasserbehandlung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abwasserbehandlung = Column("t_basket", Integer)

        ModelInterlisDss.abwasserbehandlung = abwasserbehandlung

        class schlammbehandlung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "schlammbehandlung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_schlammbehandlung = Column("t_basket", Integer)

        ModelInterlisDss.schlammbehandlung = schlammbehandlung

        class arabauwerk(ModelInterlisSia405Abwasser.abwasserbauwerk):
            __tablename__ = "arabauwerk"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_arabauwerk = Column("t_basket", Integer)

        ModelInterlisDss.arabauwerk = arabauwerk

        class steuerungszentrale(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "steuerungszentrale"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_steuerungszentrale = Column("t_basket", Integer)

        ModelInterlisDss.steuerungszentrale = steuerungszentrale

        class abflusslose_toilette(ModelInterlisSia405Abwasser.abwasserbauwerk):
            __tablename__ = "abflusslose_toilette"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_abflusslose_toilette = Column("t_basket", Integer)

        ModelInterlisDss.abflusslose_toilette = abflusslose_toilette

        class absperr_drosselorgan(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "absperr_drosselorgan"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_absperr_drosselorgan = Column("t_basket", Integer)

        ModelInterlisDss.absperr_drosselorgan = absperr_drosselorgan

        class beckenentleerung(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "beckenentleerung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_beckenentleerung = Column("t_basket", Integer)

        ModelInterlisDss.beckenentleerung = beckenentleerung

        class beckenreinigung(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "beckenreinigung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_beckenreinigung = Column("t_basket", Integer)

        ModelInterlisDss.beckenreinigung = beckenreinigung

        class biol_oekol_gesamtbeurteilung(erhaltungsereignis):
            __tablename__ = "biol_oekol_gesamtbeurteilung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_biol_oekol_gesamtbeurteilung = Column("t_basket", Integer)

        ModelInterlisDss.biol_oekol_gesamtbeurteilung = biol_oekol_gesamtbeurteilung

        class brunnen(anschlussobjekt):
            __tablename__ = "brunnen"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_brunnen = Column("t_basket", Integer)

        ModelInterlisDss.brunnen = brunnen

        class ezg_parameter_allg(oberflaechenabflussparameter):
            __tablename__ = "ezg_parameter_allg"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_ezg_parameter_allg = Column("t_basket", Integer)

        ModelInterlisDss.ezg_parameter_allg = ezg_parameter_allg

        class ezg_parameter_mouse1(oberflaechenabflussparameter):
            __tablename__ = "ezg_parameter_mouse1"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_ezg_parameter_mouse1 = Column("t_basket", Integer)

        ModelInterlisDss.ezg_parameter_mouse1 = ezg_parameter_mouse1

        class einzelflaeche(anschlussobjekt):
            __tablename__ = "einzelflaeche"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_einzelflaeche = Column("t_basket", Integer)

        ModelInterlisDss.einzelflaeche = einzelflaeche

        class einzugsgebiet(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "einzugsgebiet"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_einzugsgebiet = Column("t_basket", Integer)

        ModelInterlisDss.einzugsgebiet = einzugsgebiet

        class einzugsgebiet_text(ModelInterlisSia405Abwasser.sia405_textpos):
            __tablename__ = "einzugsgebiet_text"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_einzugsgebiet_text = Column("t_basket", Integer)

        ModelInterlisDss.einzugsgebiet_text = einzugsgebiet_text

        class elektrischeeinrichtung(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "elektrischeeinrichtung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_elektrischeeinrichtung = Column("t_basket", Integer)

        ModelInterlisDss.elektrischeeinrichtung = elektrischeeinrichtung

        class elektromechanischeausruestung(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "elektromechanischeausruestung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_elektromechanischeausruestung = Column("t_basket", Integer)

        ModelInterlisDss.elektromechanischeausruestung = elektromechanischeausruestung

        class entsorgung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "entsorgung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_entsorgung = Column("t_basket", Integer)

        ModelInterlisDss.entsorgung = entsorgung

        class entwaesserungssystem(zone):
            __tablename__ = "entwaesserungssystem"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_entwaesserungssystem = Column("t_basket", Integer)

        ModelInterlisDss.entwaesserungssystem = entwaesserungssystem

        class feststoffrueckhalt(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "feststoffrueckhalt"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_feststoffrueckhalt = Column("t_basket", Integer)

        ModelInterlisDss.feststoffrueckhalt = feststoffrueckhalt

        class foerderaggregat(ueberlauf):
            __tablename__ = "foerderaggregat"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_foerderaggregat = Column("t_basket", Integer)

        ModelInterlisDss.foerderaggregat = foerderaggregat

        class gebaeude(anschlussobjekt):
            __tablename__ = "gebaeude"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_gebaeude = Column("t_basket", Integer)

        ModelInterlisDss.gebaeude = gebaeude

        class gebaeudegruppe(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "gebaeudegruppe"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_gebaeudegruppe = Column("t_basket", Integer)

        ModelInterlisDss.gebaeudegruppe = gebaeudegruppe

        class gebaeudegruppe_baugwr(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "gebaeudegruppe_baugwr"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_gebaeudegruppe_baugwr = Column("t_basket", Integer)

        ModelInterlisDss.gebaeudegruppe_baugwr = gebaeudegruppe_baugwr

        class gesamteinzugsgebiet(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "gesamteinzugsgebiet"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_gesamteinzugsgebiet = Column("t_basket", Integer)

        ModelInterlisDss.gesamteinzugsgebiet = gesamteinzugsgebiet

        class hq_relation(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "hq_relation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_hq_relation = Column("t_basket", Integer)

        ModelInterlisDss.hq_relation = hq_relation

        class hydr_geomrelation(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "hydr_geomrelation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_hydr_geomrelation = Column("t_basket", Integer)

        ModelInterlisDss.hydr_geomrelation = hydr_geomrelation

        class hydr_geometrie(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "hydr_geometrie"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_hydr_geometrie = Column("t_basket", Integer)

        ModelInterlisDss.hydr_geometrie = hydr_geometrie

        class hydr_kennwerte(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "hydr_kennwerte"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_hydr_kennwerte = Column("t_basket", Integer)

        ModelInterlisDss.hydr_kennwerte = hydr_kennwerte

        class klara(ModelInterlisSia405Abwasser.abwasserbauwerk):
            __tablename__ = "klara"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_klara = Column("t_basket", Integer)

        ModelInterlisDss.klara = klara

        class landwirtschaftsbetrieb(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "landwirtschaftsbetrieb"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_landwirtschaftsbetrieb = Column("t_basket", Integer)

        ModelInterlisDss.landwirtschaftsbetrieb = landwirtschaftsbetrieb

        class leapingwehr(ueberlauf):
            __tablename__ = "leapingwehr"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_leapingwehr = Column("t_basket", Integer)

        ModelInterlisDss.leapingwehr = leapingwehr

        class massnahme(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "massnahme"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_massnahme = Column("t_basket", Integer)

        ModelInterlisDss.massnahme = massnahme

        class mechanischevorreinigung(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "mechanischevorreinigung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_mechanischevorreinigung = Column("t_basket", Integer)

        ModelInterlisDss.mechanischevorreinigung = mechanischevorreinigung

        class messgeraet(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "messgeraet"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_messgeraet = Column("t_basket", Integer)

        ModelInterlisDss.messgeraet = messgeraet

        class messreihe(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "messreihe"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_messreihe = Column("t_basket", Integer)

        ModelInterlisDss.messreihe = messreihe

        class messresultat(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "messresultat"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_messresultat = Column("t_basket", Integer)

        ModelInterlisDss.messresultat = messresultat

        class messstelle(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "messstelle"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_messstelle = Column("t_basket", Integer)

        ModelInterlisDss.messstelle = messstelle

        class mutation(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "mutation"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_mutation = Column("t_basket", Integer)

        ModelInterlisDss.mutation = mutation

        class reservoir(anschlussobjekt):
            __tablename__ = "reservoir"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_reservoir = Column("t_basket", Integer)

        ModelInterlisDss.reservoir = reservoir

        class retentionskoerper(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "retentionskoerper"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_retentionskoerper = Column("t_basket", Integer)

        ModelInterlisDss.retentionskoerper = retentionskoerper

        class rohrprofil_geometrie(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "rohrprofil_geometrie"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_rohrprofil_geometrie = Column("t_basket", Integer)

        ModelInterlisDss.rohrprofil_geometrie = rohrprofil_geometrie

        class rueckstausicherung(ModelInterlisSia405Abwasser.bauwerksteil):
            __tablename__ = "rueckstausicherung"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_rueckstausicherung = Column("t_basket", Integer)

        ModelInterlisDss.rueckstausicherung = rueckstausicherung

        class stammkarte(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "stammkarte"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_stammkarte = Column("t_basket", Integer)

        ModelInterlisDss.stammkarte = stammkarte

        class streichwehr(ueberlauf):
            __tablename__ = "streichwehr"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_streichwehr = Column("t_basket", Integer)

        ModelInterlisDss.streichwehr = streichwehr

        class ueberlaufcharakteristik(ModelInterlisSia405Abwasser.vsa_baseclass):
            __tablename__ = "ueberlaufcharakteristik"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_ueberlaufcharakteristik = Column("t_basket", Integer)

        ModelInterlisDss.ueberlaufcharakteristik = ueberlaufcharakteristik

        class unterhalt(erhaltungsereignis):
            __tablename__ = "unterhalt"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_unterhalt = Column("t_basket", Integer)

        ModelInterlisDss.unterhalt = unterhalt

        class versickerungsbereich(zone):
            __tablename__ = "versickerungsbereich"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}
            t_basket_versickerungsbereich = Column("t_basket", Integer)

        ModelInterlisDss.versickerungsbereich = versickerungsbereich

        class erhaltungsereignis_abwasserbauwerkassoc(self.Base):
            __tablename__ = "erhaltungsereignis_abwasserbauwerkassoc"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.erhaltungsereignis_abwasserbauwerkassoc = (
            erhaltungsereignis_abwasserbauwerkassoc
        )

        class gebaeudegruppe_entsorgungassoc(self.Base):
            __tablename__ = "gebaeudegruppe_entsorgungassoc"
            __table_args__ = {"schema": config.ABWASSER_SCHEMA}

        ModelInterlisDss.gebaeudegruppe_entsorgungassoc = gebaeudegruppe_entsorgungassoc
