from .model_qwat import get_qwat_model
from .model_wasser import get_wasser_model


def get_qwat_mapping():
    QWAT = get_qwat_model()
    WASSER = get_wasser_model()

    # Quick hack to list QWAT.node twice in the dict, TODO : use list of 2uple instead
    class QWATnodeclone(QWAT.node):
        pass

    return {
        # Node
        QWAT.node: [WASSER.hydraulischer_knoten],
        QWATnodeclone: [WASSER.rohrleitungsteil],
        # Pipe
        QWAT.pipe: [WASSER.hydraulischer_strang, WASSER.leitung],
        QWAT.leak: [WASSER.schadenstelle],
        # Network elements
        QWAT.hydrant: [WASSER.hydrant],
        QWAT.tank: [WASSER.wasserbehaelter],
        QWAT.pump: [WASSER.foerderanlage],
        QWAT.treatment: [WASSER.wassergewinnungsanlage],
        QWAT.subscriber: [WASSER.hausanschluss, WASSER.anlage],
        QWAT.source: [WASSER.wassergewinnungsanlage],
        QWAT.chamber: [WASSER.anlage],
        QWAT.pressurecontrol: [WASSER.anlage],
        QWAT.valve: [WASSER.absperrorgan],
        # QWAT.???: [WASSER.rohrleitungsteil], # not sure to what this maps
        # QWAT.???: [WASSER.uebrige], # not sure to what this maps
        # QWAT.???: [WASSER.muffen], # does not exist in QWAT
    }

    # AVAILABLE TABLES
    # WASSER.absperrorgan, WASSER.anlage, WASSER.baseclass, WASSER.foerderanlage, WASSER.hausanschluss, WASSER.hydrant, WASSER.hydraulischer_knoten, WASSER.hydraulischer_strang, WASSER.leitung, WASSER.leitung_strang_assoc, WASSER.leitungsknoten, WASSER.leitungsknoten_knoten_assoc, WASSER.leitungspunkt, WASSER.metaattribute, WASSER.muffen, WASSER.rohrleitungsteil, WASSER.schadenstelle, WASSER.sia405_15_lv95sia405_wasser_lk_anlage, WASSER.sia405_15_lv95sia405_wasser_lk_leitung, WASSER.sia405_15_lv95sia405_wasser_lk_leitung_text, WASSER.sia405_15_lv95sia405_wasser_lk_leitung_textassoc, WASSER.sia405_15_lv95sia405_wasser_lk_leitungsknoten, WASSER.sia405_15_lv95sia405_wasser_lk_leitungsknoten_text, WASSER.sia405_15_lv95sia405_wasser_lk_leitungsknoten_textassoc, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_flaeche, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_flaecheassoc, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_linie, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_linieassoc, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_text, WASSER.sia405_15_lv95sia405_wasser_lk_spezialbauwerk_textassoc, WASSER.sia405_baseclass, WASSER.sia405_symbolpos, WASSER.sia405_textpos, WASSER.spezialbauwerk, WASSER.spezialbauwerk_flaeche, WASSER.spezialbauwerk_linie, WASSER.symbolpos, WASSER.t_ili2db_attrname, WASSER.t_ili2db_basket, WASSER.t_ili2db_classname, WASSER.t_ili2db_dataset, WASSER.t_ili2db_inheritance, WASSER.t_ili2db_model, WASSER.t_ili2db_settings, WASSER.textpos, WASSER.uebrige, WASSER.wasserbehaelter, WASSER.wassergewinnungsanlage

    # NOT YET MAPPED
    # QWAT.consumptionzone: [WASSER.REPLACE_ME],
    # QWAT.district: [WASSER.REPLACE_ME],
    # QWAT.meter: [WASSER.REPLACE_ME],
    # QWAT.part: [WASSER.REPLACE_ME],
    # QWAT.pressurezone: [WASSER.REPLACE_ME],
    # QWAT.protectionzone: [WASSER.REPLACE_ME],
    # QWAT.remote: [WASSER.REPLACE_ME],
    # QWAT.samplingpoint: [WASSER.REPLACE_ME],
    # QWAT.surveypoint: [WASSER.REPLACE_ME],
