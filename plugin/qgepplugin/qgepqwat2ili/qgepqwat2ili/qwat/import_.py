from sqlalchemy.orm import Session

from .. import utils
from ..utils.various import logger
from .model_qwat import get_qwat_model
from .model_wasser import get_wasser_model


def qwat_import():

    QWAT = get_qwat_model()
    WASSER = get_wasser_model()

    wasser_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    qwat_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)

    logger.info("Importing WASSER.hydraulischer_knoten -> QWAT.node")
    for row in wasser_session.query(WASSER.hydraulischer_knoten):

        # baseclass --- hydraulischer_knoten.t_type, hydraulischer_knoten.t_ili_tid
        # sia405_baseclass --- hydraulischer_knoten.obj_id
        # hydraulischer_knoten --- hydraulischer_knoten.t_id, hydraulischer_knoten.name_nummer, hydraulischer_knoten.geometrie, hydraulischer_knoten.knotentyp, hydraulischer_knoten.verbrauch, hydraulischer_knoten.druck, hydraulischer_knoten.bemerkung
        # _bwrel_ --- hydraulischer_knoten.sia405_textpos__BWREL_hydraulischer_knotenref, hydraulischer_knoten.textpos__BWREL_t_id, hydraulischer_knoten.symbolpos__BWREL_t_id, hydraulischer_knoten.spezialbauwerk__BWREL_t_id, hydraulischer_knoten.metaattribute__BWREL_sia405_baseclass_metaattribute, hydraulischer_knoten.leitungsknoten__BWREL_knotenref, hydraulischer_knoten.hydraulischer_strang__BWREL_bisknotenref, hydraulischer_knoten.hydraulischer_strang__BWREL_vonknotenref

        node = QWAT.node(
            # --- node ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(node)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.hydraulischer_strang, WASSER.leitung -> QWAT.pipe")
    for row, leitung in wasser_session.query(WASSER.hydraulischer_strang, WASSER.leitung).join(WASSER.leitung):

        # baseclass --- hydraulischer_strang.t_type, hydraulischer_strang.t_ili_tid
        # sia405_baseclass --- hydraulischer_strang.obj_id
        # hydraulischer_strang --- hydraulischer_strang.t_id, hydraulischer_strang.name_nummer, hydraulischer_strang.referenz_laenge, hydraulischer_strang.referenz_rauheit, hydraulischer_strang.referenz_durchmesser, hydraulischer_strang.verbrauch, hydraulischer_strang.durchfluss, hydraulischer_strang.fliessgeschwindigkeit, hydraulischer_strang.zustand, hydraulischer_strang.bemerkung, hydraulischer_strang.bisknotenref, hydraulischer_strang.vonknotenref
        # _bwrel_ --- hydraulischer_strang.sia405_textpos__BWREL_hydraulischer_strangref, hydraulischer_strang.textpos__BWREL_t_id, hydraulischer_strang.symbolpos__BWREL_t_id, hydraulischer_strang.spezialbauwerk__BWREL_t_id, hydraulischer_strang.metaattribute__BWREL_sia405_baseclass_metaattribute, hydraulischer_strang.leitung__BWREL_strangref
        # _rel_ --- hydraulischer_strang.bisknotenref__REL, hydraulischer_strang.vonknotenref__REL

        # baseclass --- leitung.t_type, leitung.t_ili_tid
        # sia405_baseclass --- leitung.obj_id
        # leitung --- leitung.t_id, leitung.name_nummer, leitung.geometrie, leitung.funktion, leitung.material, leitung.durchmesserinnen, leitung.durchmesseraussen, leitung.durchmesser, leitung.nennweite, leitung.wasserqualitaet, leitung.lagebestimmung, leitung.astatus, leitung.baujahr, leitung.verbindungsart, leitung.aussenbeschichtung, leitung.innenbeschichtung, leitung.verlegeart, leitung.schubsicherung, leitung.ueberdeckung, leitung.sanierung_erneuerung, leitung.bettung, leitung.kathodischer_schutz, leitung.druckzone, leitung.zulaessiger_bauteil_betriebsdruck, leitung.betriebsdruck, leitung.hydraulische_rauheit, leitung.laenge, leitung.unterhalt, leitung.zustand, leitung.eigentuemer, leitung.betreiber, leitung.konzessionaer, leitung.unterhaltspflichtiger, leitung.bemerkung, leitung.strangref
        # _bwrel_ --- leitung.sia405_textpos__BWREL_leitungref, leitung.textpos__BWREL_t_id, leitung.symbolpos__BWREL_t_id, leitung.spezialbauwerk__BWREL_t_id, leitung.metaattribute__BWREL_sia405_baseclass_metaattribute, leitung.schadenstelle__BWREL_leitungref
        # _rel_ --- leitung.strangref__REL

        pipe = QWAT.pipe(
            # --- pipe ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_function=row.REPLACE_ME,  # INTEGER
            # fk_installmethod=row.REPLACE_ME,  # INTEGER
            # fk_material=row.REPLACE_ME,  # INTEGER
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_bedding=row.REPLACE_ME,  # INTEGER
            # fk_protection=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # year=row.REPLACE_ME,  # SMALLINT
            # year_rehabilitation=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # tunnel_or_bridge=row.REPLACE_ME,  # BOOLEAN
            # pressure_nominal=row.REPLACE_ME,  # SMALLINT
            # remark=row.REPLACE_ME,  # TEXT
            # _valve_count=row.REPLACE_ME,  # SMALLINT
            # _valve_closed=row.REPLACE_ME,  # BOOLEAN
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # fk_node_a=row.REPLACE_ME,  # INTEGER
            # fk_node_b=row.REPLACE_ME,  # INTEGER
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _length2d=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _length3d=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _diff_elevation=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _printmaps=row.REPLACE_ME,  # VARCHAR(100)
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # schema_force_visible=row.REPLACE_ME,  # BOOLEAN
            # _schema_visible=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(pipe)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.schadenstelle -> QWAT.leak")
    for row in wasser_session.query(WASSER.schadenstelle):

        # baseclass --- schadenstelle.t_type, schadenstelle.t_ili_tid
        # sia405_baseclass --- schadenstelle.obj_id
        # schadenstelle --- schadenstelle.t_id, schadenstelle.name_nummer, schadenstelle.geometrie, schadenstelle.art, schadenstelle.ursache, schadenstelle.ausloeser, schadenstelle.erhebungsdatum, schadenstelle.behebungsdatum, schadenstelle.zustand, schadenstelle.bemerkung, schadenstelle.leitungref
        # _bwrel_ --- schadenstelle.textpos__BWREL_t_id, schadenstelle.symbolpos__BWREL_t_id, schadenstelle.spezialbauwerk__BWREL_t_id, schadenstelle.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- schadenstelle.leitungref__REL

        leak = QWAT.leak(
            # --- leak ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_cause=row.REPLACE_ME,  # INTEGER
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # widespread_damage=row.REPLACE_ME,  # BOOLEAN
            # detection_date=row.REPLACE_ME,  # DATE
            # repair_date=row.REPLACE_ME,  # DATE
            # _repaired=row.REPLACE_ME,  # BOOLEAN
            # address=row.REPLACE_ME,  # TEXT
            # pipe_replaced=row.REPLACE_ME,  # BOOLEAN
            # description=row.REPLACE_ME,  # TEXT
            # repair=row.REPLACE_ME,  # TEXT
            # geometry=row.REPLACE_ME,  # geometry(POINT,21781)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
        )
        qwat_session.add(leak)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.hydrant -> QWAT.hydrant")
    for row in wasser_session.query(WASSER.hydrant):

        # baseclass --- hydrant.t_type, hydrant.t_ili_tid
        # sia405_baseclass --- hydrant.obj_id
        # leitungsknoten --- hydrant.geometrie, hydrant.symbolori, hydrant.lagebestimmung, hydrant.hoehe, hydrant.hoehenbestimmung, hydrant.einbaujahr, hydrant.druckzone, hydrant.eigentuemer, hydrant.bemerkung, hydrant.knotenref
        # hydrant --- hydrant.t_id, hydrant.name_nummer, hydrant.art, hydrant.material, hydrant.dimension, hydrant.hersteller, hydrant.versorgungsdruck, hydrant.fliessdruck, hydrant.entnahme, hydrant.typ, hydrant.zustand
        # _bwrel_ --- hydrant.sia405_textpos__BWREL_leitungsknotenref, hydrant.sia405_symbolpos__BWREL_objekt, hydrant.rohrleitungsteil__BWREL_t_id, hydrant.muffen__BWREL_t_id, hydrant.textpos__BWREL_t_id, hydrant.uebrige__BWREL_t_id, hydrant.symbolpos__BWREL_t_id, hydrant.spezialbauwerk__BWREL_t_id, hydrant.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- hydrant.knotenref__REL

        hydrant = QWAT.hydrant(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- hydrant ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_provider=row.REPLACE_ME,  # INTEGER
            # fk_model_sup=row.REPLACE_ME,  # INTEGER
            # fk_model_inf=row.REPLACE_ME,  # INTEGER
            # fk_material=row.REPLACE_ME,  # INTEGER
            # fk_output=row.REPLACE_ME,  # INTEGER
            # underground=row.REPLACE_ME,  # BOOLEAN
            # marked=row.REPLACE_ME,  # BOOLEAN
            # pressure_static=row.REPLACE_ME,  # NUMERIC(5, 2)
            # pressure_dynamic=row.REPLACE_ME,  # NUMERIC(5, 2)
            # flow=row.REPLACE_ME,  # NUMERIC(8, 2)
            # observation_date=row.REPLACE_ME,  # DATE
            # observation_source=row.REPLACE_ME,  # VARCHAR(45)
        )
        qwat_session.add(hydrant)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.wasserbehaelter -> QWAT.tank")
    for row in wasser_session.query(WASSER.wasserbehaelter):

        # baseclass --- wasserbehaelter.t_type, wasserbehaelter.t_ili_tid
        # sia405_baseclass --- wasserbehaelter.obj_id
        # leitungsknoten --- wasserbehaelter.geometrie, wasserbehaelter.symbolori, wasserbehaelter.lagebestimmung, wasserbehaelter.hoehe, wasserbehaelter.hoehenbestimmung, wasserbehaelter.einbaujahr, wasserbehaelter.druckzone, wasserbehaelter.eigentuemer, wasserbehaelter.bemerkung, wasserbehaelter.knotenref
        # wasserbehaelter --- wasserbehaelter.t_id, wasserbehaelter.name_nummer, wasserbehaelter.art, wasserbehaelter.material, wasserbehaelter.beschichtung, wasserbehaelter.ueberlaufhoehe, wasserbehaelter.fassungsvermoegen, wasserbehaelter.brauchwasserreserve, wasserbehaelter.loeschwasserreserve, wasserbehaelter.leistung, wasserbehaelter.zustand
        # _bwrel_ --- wasserbehaelter.sia405_textpos__BWREL_leitungsknotenref, wasserbehaelter.sia405_symbolpos__BWREL_objekt, wasserbehaelter.rohrleitungsteil__BWREL_t_id, wasserbehaelter.muffen__BWREL_t_id, wasserbehaelter.textpos__BWREL_t_id, wasserbehaelter.uebrige__BWREL_t_id, wasserbehaelter.symbolpos__BWREL_t_id, wasserbehaelter.spezialbauwerk__BWREL_t_id, wasserbehaelter.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- wasserbehaelter.knotenref__REL

        tank = QWAT.tank(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- installation ---
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(30)
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # --- tank ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_overflow=row.REPLACE_ME,  # INTEGER
            # fk_tank_firestorage=row.REPLACE_ME,  # INTEGER
            # storage_total=row.REPLACE_ME,  # NUMERIC(10, 1)
            # storage_supply=row.REPLACE_ME,  # NUMERIC(10, 1)
            # storage_fire=row.REPLACE_ME,  # NUMERIC(10, 1)
            # altitude_overflow=row.REPLACE_ME,  # NUMERIC(7, 3)
            # altitude_apron=row.REPLACE_ME,  # NUMERIC(7, 3)
            # height_max=row.REPLACE_ME,  # NUMERIC(7, 3)
            # fire_valve=row.REPLACE_ME,  # BOOLEAN
            # fire_remote=row.REPLACE_ME,  # BOOLEAN
            # _litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
            # cistern1_fk_type=row.REPLACE_ME,  # INTEGER
            # cistern1_dimension_1=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern1_dimension_2=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern1_storage=row.REPLACE_ME,  # NUMERIC(10, 2)
            # _cistern1_litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
            # cistern2_fk_type=row.REPLACE_ME,  # INTEGER
            # cistern2_dimension_1=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern2_dimension_2=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern2_storage=row.REPLACE_ME,  # NUMERIC(10, 2)
            # _cistern2_litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
        )
        qwat_session.add(tank)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.foerderanlage -> QWAT.pump")
    for row in wasser_session.query(WASSER.foerderanlage):

        # baseclass --- foerderanlage.t_type, foerderanlage.t_ili_tid
        # sia405_baseclass --- foerderanlage.obj_id
        # leitungsknoten --- foerderanlage.geometrie, foerderanlage.symbolori, foerderanlage.lagebestimmung, foerderanlage.hoehe, foerderanlage.hoehenbestimmung, foerderanlage.einbaujahr, foerderanlage.druckzone, foerderanlage.eigentuemer, foerderanlage.bemerkung, foerderanlage.knotenref
        # foerderanlage --- foerderanlage.t_id, foerderanlage.name_nummer, foerderanlage.art, foerderanlage.leistung, foerderanlage.zustand
        # _bwrel_ --- foerderanlage.sia405_textpos__BWREL_leitungsknotenref, foerderanlage.sia405_symbolpos__BWREL_objekt, foerderanlage.rohrleitungsteil__BWREL_t_id, foerderanlage.muffen__BWREL_t_id, foerderanlage.textpos__BWREL_t_id, foerderanlage.uebrige__BWREL_t_id, foerderanlage.symbolpos__BWREL_t_id, foerderanlage.spezialbauwerk__BWREL_t_id, foerderanlage.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- foerderanlage.knotenref__REL

        pump = QWAT.pump(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- installation ---
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(30)
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # --- pump ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_pump_type=row.REPLACE_ME,  # SMALLINT
            # fk_pipe_in=row.REPLACE_ME,  # INTEGER
            # fk_pipe_out=row.REPLACE_ME,  # INTEGER
            # fk_pump_operating=row.REPLACE_ME,  # SMALLINT
            # no_pumps=row.REPLACE_ME,  # SMALLINT
            # rejected_flow=row.REPLACE_ME,  # NUMERIC(10, 2)
            # manometric_height=row.REPLACE_ME,  # NUMERIC(10, 2)
        )
        qwat_session.add(pump)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.anlage -> QWAT.treatment")
    for row in wasser_session.query(WASSER.anlage):

        # baseclass --- anlage.t_type, anlage.t_ili_tid
        # sia405_baseclass --- anlage.obj_id
        # leitungsknoten --- anlage.geometrie, anlage.symbolori, anlage.lagebestimmung, anlage.hoehe, anlage.hoehenbestimmung, anlage.einbaujahr, anlage.druckzone, anlage.eigentuemer, anlage.bemerkung, anlage.knotenref
        # anlage --- anlage.t_id, anlage.name_nummer, anlage.art, anlage.material, anlage.leistung, anlage.betreiber, anlage.konzessionaer, anlage.unterhaltspflichtiger, anlage.zustand, anlage.dimension1
        # _bwrel_ --- anlage.sia405_textpos__BWREL_leitungsknotenref, anlage.sia405_symbolpos__BWREL_objekt, anlage.rohrleitungsteil__BWREL_t_id, anlage.muffen__BWREL_t_id, anlage.textpos__BWREL_t_id, anlage.uebrige__BWREL_t_id, anlage.symbolpos__BWREL_t_id, anlage.spezialbauwerk__BWREL_t_id, anlage.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- anlage.knotenref__REL

        treatment = QWAT.treatment(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- installation ---
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(30)
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # --- treatment ---
            # id=row.REPLACE_ME,  # INTEGER
            # sanitization_uv=row.REPLACE_ME,  # BOOLEAN
            # sanitization_chlorine_liquid=row.REPLACE_ME,  # BOOLEAN
            # sanitization_chlorine_gas=row.REPLACE_ME,  # BOOLEAN
            # sanitization_ozone=row.REPLACE_ME,  # BOOLEAN
            # filtration_membrane=row.REPLACE_ME,  # BOOLEAN
            # filtration_sandorgravel=row.REPLACE_ME,  # BOOLEAN
            # flocculation=row.REPLACE_ME,  # BOOLEAN
            # activatedcharcoal=row.REPLACE_ME,  # BOOLEAN
            # settling=row.REPLACE_ME,  # BOOLEAN
            # treatment_capacity=row.REPLACE_ME,  # NUMERIC(10, 2)
        )
        qwat_session.add(treatment)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.hausanschluss -> QWAT.subscriber")
    for row in wasser_session.query(WASSER.hausanschluss):

        # baseclass --- hausanschluss.t_type, hausanschluss.t_ili_tid
        # sia405_baseclass --- hausanschluss.obj_id
        # leitungsknoten --- hausanschluss.geometrie, hausanschluss.symbolori, hausanschluss.lagebestimmung, hausanschluss.hoehe, hausanschluss.hoehenbestimmung, hausanschluss.einbaujahr, hausanschluss.druckzone, hausanschluss.eigentuemer, hausanschluss.bemerkung, hausanschluss.knotenref
        # hausanschluss --- hausanschluss.t_id, hausanschluss.name_nummer, hausanschluss.standort, hausanschluss.art, hausanschluss.gebaeudeanschluss, hausanschluss.isolierstueck, hausanschluss.typ, hausanschluss.dimension, hausanschluss.zuordnung_hydraulischer_strang, hausanschluss.zuordnung_hydraulischer_knoten, hausanschluss.verbrauch, hausanschluss.zustand
        # _bwrel_ --- hausanschluss.sia405_textpos__BWREL_leitungsknotenref, hausanschluss.sia405_symbolpos__BWREL_objekt, hausanschluss.rohrleitungsteil__BWREL_t_id, hausanschluss.muffen__BWREL_t_id, hausanschluss.textpos__BWREL_t_id, hausanschluss.uebrige__BWREL_t_id, hausanschluss.symbolpos__BWREL_t_id, hausanschluss.spezialbauwerk__BWREL_t_id, hausanschluss.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- hausanschluss.knotenref__REL

        subscriber = QWAT.subscriber(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- subscriber ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_subscriber_type=row.REPLACE_ME,  # INTEGER
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(12)
            # flow_current=row.REPLACE_ME,  # NUMERIC(8, 2)
            # flow_planned=row.REPLACE_ME,  # NUMERIC(8, 2)
        )
        qwat_session.add(subscriber)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.wassergewinnungsanlage -> QWAT.source")
    for row in wasser_session.query(WASSER.wassergewinnungsanlage):

        # baseclass --- wassergewinnungsanlage.t_type, wassergewinnungsanlage.t_ili_tid
        # sia405_baseclass --- wassergewinnungsanlage.obj_id
        # leitungsknoten --- wassergewinnungsanlage.geometrie, wassergewinnungsanlage.symbolori, wassergewinnungsanlage.lagebestimmung, wassergewinnungsanlage.hoehe, wassergewinnungsanlage.hoehenbestimmung, wassergewinnungsanlage.einbaujahr, wassergewinnungsanlage.druckzone, wassergewinnungsanlage.eigentuemer, wassergewinnungsanlage.bemerkung, wassergewinnungsanlage.knotenref
        # wassergewinnungsanlage --- wassergewinnungsanlage.t_id, wassergewinnungsanlage.name_nummer, wassergewinnungsanlage.art, wassergewinnungsanlage.leistung, wassergewinnungsanlage.betreiber, wassergewinnungsanlage.konzessionaer, wassergewinnungsanlage.unterhaltspflichtiger, wassergewinnungsanlage.zustand
        # _bwrel_ --- wassergewinnungsanlage.sia405_textpos__BWREL_leitungsknotenref, wassergewinnungsanlage.sia405_symbolpos__BWREL_objekt, wassergewinnungsanlage.rohrleitungsteil__BWREL_t_id, wassergewinnungsanlage.muffen__BWREL_t_id, wassergewinnungsanlage.textpos__BWREL_t_id, wassergewinnungsanlage.uebrige__BWREL_t_id, wassergewinnungsanlage.symbolpos__BWREL_t_id, wassergewinnungsanlage.spezialbauwerk__BWREL_t_id, wassergewinnungsanlage.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- wassergewinnungsanlage.knotenref__REL

        source = QWAT.source(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- installation ---
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(30)
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # --- source ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_source_type=row.REPLACE_ME,  # SMALLINT
            # fk_source_quality=row.REPLACE_ME,  # SMALLINT
            # flow_lowest=row.REPLACE_ME,  # NUMERIC(10, 3)
            # flow_average=row.REPLACE_ME,  # NUMERIC(10, 3)
            # flow_concession=row.REPLACE_ME,  # NUMERIC(10, 2)
            # contract_end=row.REPLACE_ME,  # DATE
            # gathering_chamber=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(source)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.absperrorgan -> QWAT.chamber")
    for row in wasser_session.query(WASSER.absperrorgan):

        # baseclass --- absperrorgan.t_type, absperrorgan.t_ili_tid
        # sia405_baseclass --- absperrorgan.obj_id
        # leitungsknoten --- absperrorgan.geometrie, absperrorgan.symbolori, absperrorgan.lagebestimmung, absperrorgan.hoehe, absperrorgan.hoehenbestimmung, absperrorgan.einbaujahr, absperrorgan.druckzone, absperrorgan.eigentuemer, absperrorgan.bemerkung, absperrorgan.knotenref
        # absperrorgan --- absperrorgan.t_id, absperrorgan.name_nummer, absperrorgan.art, absperrorgan.schaltzustand, absperrorgan.schaltantrieb, absperrorgan.material, absperrorgan.zulaessiger_bauteil_betriebsdruck, absperrorgan.nennweite, absperrorgan.hersteller, absperrorgan.typ, absperrorgan.schliessrichtung, absperrorgan.zustand
        # _bwrel_ --- absperrorgan.sia405_textpos__BWREL_leitungsknotenref, absperrorgan.sia405_symbolpos__BWREL_objekt, absperrorgan.rohrleitungsteil__BWREL_t_id, absperrorgan.muffen__BWREL_t_id, absperrorgan.textpos__BWREL_t_id, absperrorgan.uebrige__BWREL_t_id, absperrorgan.symbolpos__BWREL_t_id, absperrorgan.spezialbauwerk__BWREL_t_id, absperrorgan.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- absperrorgan.knotenref__REL

        chamber = QWAT.chamber(
            # --- node ---
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # --- network_element ---
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # --- installation ---
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(30)
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # --- chamber ---
            # id=row.REPLACE_ME,  # INTEGER
            # networkseparation=row.REPLACE_ME,  # BOOLEAN
            # flow_meter=row.REPLACE_ME,  # BOOLEAN
            # water_meter=row.REPLACE_ME,  # BOOLEAN
            # manometer=row.REPLACE_ME,  # BOOLEAN
            # depth=row.REPLACE_ME,  # NUMERIC(10, 3)
            # no_valves=row.REPLACE_ME,  # SMALLINT
        )
        qwat_session.add(chamber)
        print(".", end="")
    logger.info("done")

    logger.info("Importing WASSER.absperrorgan -> QWAT.valve")
    for row in wasser_session.query(WASSER.absperrorgan):

        # baseclass --- absperrorgan.t_type, absperrorgan.t_ili_tid
        # sia405_baseclass --- absperrorgan.obj_id
        # leitungsknoten --- absperrorgan.geometrie, absperrorgan.symbolori, absperrorgan.lagebestimmung, absperrorgan.hoehe, absperrorgan.hoehenbestimmung, absperrorgan.einbaujahr, absperrorgan.druckzone, absperrorgan.eigentuemer, absperrorgan.bemerkung, absperrorgan.knotenref
        # absperrorgan --- absperrorgan.t_id, absperrorgan.name_nummer, absperrorgan.art, absperrorgan.schaltzustand, absperrorgan.schaltantrieb, absperrorgan.material, absperrorgan.zulaessiger_bauteil_betriebsdruck, absperrorgan.nennweite, absperrorgan.hersteller, absperrorgan.typ, absperrorgan.schliessrichtung, absperrorgan.zustand
        # _bwrel_ --- absperrorgan.sia405_textpos__BWREL_leitungsknotenref, absperrorgan.sia405_symbolpos__BWREL_objekt, absperrorgan.rohrleitungsteil__BWREL_t_id, absperrorgan.muffen__BWREL_t_id, absperrorgan.textpos__BWREL_t_id, absperrorgan.uebrige__BWREL_t_id, absperrorgan.symbolpos__BWREL_t_id, absperrorgan.spezialbauwerk__BWREL_t_id, absperrorgan.metaattribute__BWREL_sia405_baseclass_metaattribute
        # _rel_ --- absperrorgan.knotenref__REL

        valve = QWAT.valve(
            # --- valve ---
            # id=row.REPLACE_ME,  # INTEGER
            # fk_valve_type=row.REPLACE_ME,  # INTEGER
            # fk_valve_function=row.REPLACE_ME,  # INTEGER
            # fk_valve_actuation=row.REPLACE_ME,  # INTEGER
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # fk_handle_precision=row.REPLACE_ME,  # INTEGER
            # fk_handle_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_maintenance=row.REPLACE_ME,  # INTEGER[]
            # closed=row.REPLACE_ME,  # BOOLEAN
            # networkseparation=row.REPLACE_ME,  # BOOLEAN
            # handle_altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # handle_geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # remark=row.REPLACE_ME,  # TEXT
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # schema_force_visible=row.REPLACE_ME,  # BOOLEAN
            # _schema_visible=row.REPLACE_ME,  # BOOLEAN
            # fk_nominal_diameter=row.REPLACE_ME,  # INTEGER
        )
        qwat_session.add(valve)
        print(".", end="")
    logger.info("done")

    qwat_session.commit()

    qwat_session.close()
    wasser_session.close()
