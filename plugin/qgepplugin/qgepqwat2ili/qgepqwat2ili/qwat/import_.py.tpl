from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_Transform, ST_Force2D

from .. import utils

from .model_qwat import get_qwat_model
from .model_wasser import get_wasser_model


def qwat_import():

    QWAT = get_qwat_model()
    WASSER = get_wasser_model()

    wasser_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    qwat_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)

    print("Importing WASSER.hydraulischer_knoten, WASSER.rohrleitungsteil -> QWAT.node")
    for row, rohrleitungsteil in wasser_session.query(WASSER.hydraulischer_knoten, WASSER.rohrleitungsteil).join(WASSER.rohrleitungsteil):

        # baseclass --- hydraulischer_knoten.t_ili_tid, hydraulischer_knoten.t_type
        # sia405_baseclass --- hydraulischer_knoten.obj_id
        # hydraulischer_knoten --- hydraulischer_knoten.bemerkung, hydraulischer_knoten.druck, hydraulischer_knoten.geometrie, hydraulischer_knoten.knotentyp, hydraulischer_knoten.name_nummer, hydraulischer_knoten.t_id, hydraulischer_knoten.verbrauch

        # baseclass --- rohrleitungsteil.t_ili_tid, rohrleitungsteil.t_type
        # sia405_baseclass --- rohrleitungsteil.obj_id
        # leitungsknoten --- rohrleitungsteil.bemerkung, rohrleitungsteil.druckzone, rohrleitungsteil.eigentuemer, rohrleitungsteil.einbaujahr, rohrleitungsteil.geometrie, rohrleitungsteil.hoehe, rohrleitungsteil.hoehenbestimmung, rohrleitungsteil.knotenref, rohrleitungsteil.lagebestimmung, rohrleitungsteil.symbolori
        # rohrleitungsteil --- rohrleitungsteil.abwinklung, rohrleitungsteil.art, rohrleitungsteil.dimension, rohrleitungsteil.material, rohrleitungsteil.name_nummer, rohrleitungsteil.t_id, rohrleitungsteil.verbindung, rohrleitungsteil.zulaessiger_betriebsdruck, rohrleitungsteil.zustand
        # _bwrel_ --- rohrleitungsteil.sia405_symbolpos__BWREL_objekt
        # _rel_ --- rohrleitungsteil.knotenref__REL

        node = QWAT.node(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # id=row.REPLACE_ME,  # INTEGER
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(node)
        print(".", end="")
    print("done")

    print("Importing WASSER.hydraulischer_strang, WASSER.leitung -> QWAT.pipe")
    for row, leitung in wasser_session.query(WASSER.hydraulischer_strang, WASSER.leitung).join(WASSER.leitung):

        # baseclass --- hydraulischer_strang.t_ili_tid, hydraulischer_strang.t_type
        # sia405_baseclass --- hydraulischer_strang.obj_id
        # hydraulischer_strang --- hydraulischer_strang.bemerkung, hydraulischer_strang.bisknotenref, hydraulischer_strang.durchfluss, hydraulischer_strang.fliessgeschwindigkeit, hydraulischer_strang.name_nummer, hydraulischer_strang.referenz_durchmesser, hydraulischer_strang.referenz_laenge, hydraulischer_strang.referenz_rauheit, hydraulischer_strang.t_id, hydraulischer_strang.verbrauch, hydraulischer_strang.vonknotenref, hydraulischer_strang.zustand
        # _bwrel_ --- hydraulischer_strang.leitung__BWREL_strangref, hydraulischer_strang.metaattribute__BWREL_sia405_baseclass_metaattribute, hydraulischer_strang.sia405_textpos__BWREL_hydraulischer_strangref, hydraulischer_strang.spezialbauwerk__BWREL_t_id, hydraulischer_strang.symbolpos__BWREL_t_id, hydraulischer_strang.textpos__BWREL_t_id
        # _rel_ --- hydraulischer_strang.bisknotenref__REL, hydraulischer_strang.vonknotenref__REL

        # baseclass --- leitung.t_ili_tid, leitung.t_type
        # sia405_baseclass --- leitung.obj_id
        # leitung --- leitung.astatus, leitung.aussenbeschichtung, leitung.baujahr, leitung.bemerkung, leitung.betreiber, leitung.betriebsdruck, leitung.bettung, leitung.druckzone, leitung.durchmesser, leitung.durchmesseraussen, leitung.durchmesserinnen, leitung.eigentuemer, leitung.funktion, leitung.geometrie, leitung.hydraulische_rauheit, leitung.innenbeschichtung, leitung.kathodischer_schutz, leitung.konzessionaer, leitung.laenge, leitung.lagebestimmung, leitung.material, leitung.name_nummer, leitung.nennweite, leitung.sanierung_erneuerung, leitung.schubsicherung, leitung.strangref, leitung.t_id, leitung.ueberdeckung, leitung.unterhalt, leitung.unterhaltspflichtiger, leitung.verbindungsart, leitung.verlegeart, leitung.wasserqualitaet, leitung.zulaessiger_bauteil_betriebsdruck, leitung.zustand
        # _bwrel_ --- leitung.metaattribute__BWREL_sia405_baseclass_metaattribute, leitung.schadenstelle__BWREL_leitungref, leitung.sia405_textpos__BWREL_leitungref, leitung.spezialbauwerk__BWREL_t_id, leitung.symbolpos__BWREL_t_id, leitung.textpos__BWREL_t_id
        # _rel_ --- leitung.strangref__REL

        pipe = QWAT.pipe(

            # --- pipe ---
            # _diff_elevation=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _length2d=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _length3d=row.REPLACE_ME,  # NUMERIC(8, 2)
            # _printmaps=row.REPLACE_ME,  # VARCHAR(100)
            # _schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _valve_closed=row.REPLACE_ME,  # BOOLEAN
            # _valve_count=row.REPLACE_ME,  # SMALLINT
            # fk_bedding=row.REPLACE_ME,  # INTEGER
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_function=row.REPLACE_ME,  # INTEGER
            # fk_installmethod=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_material=row.REPLACE_ME,  # INTEGER
            # fk_node_a=row.REPLACE_ME,  # INTEGER
            # fk_node_b=row.REPLACE_ME,  # INTEGER
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # fk_protection=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(LINESTRINGZ,21781)
            # id=row.REPLACE_ME,  # INTEGER
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # pressure_nominal=row.REPLACE_ME,  # SMALLINT
            # remark=row.REPLACE_ME,  # TEXT
            # schema_force_visible=row.REPLACE_ME,  # BOOLEAN
            # tunnel_or_bridge=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
            # year_rehabilitation=row.REPLACE_ME,  # SMALLINT
        )
        qwat_session.add(pipe)
        print(".", end="")
    print("done")

    print("Importing WASSER.schadenstelle -> QWAT.leak")
    for row in wasser_session.query(WASSER.schadenstelle):

        # baseclass --- schadenstelle.t_ili_tid, schadenstelle.t_type
        # sia405_baseclass --- schadenstelle.obj_id
        # schadenstelle --- schadenstelle.art, schadenstelle.ausloeser, schadenstelle.behebungsdatum, schadenstelle.bemerkung, schadenstelle.erhebungsdatum, schadenstelle.geometrie, schadenstelle.leitungref, schadenstelle.name_nummer, schadenstelle.t_id, schadenstelle.ursache, schadenstelle.zustand
        # _bwrel_ --- schadenstelle.metaattribute__BWREL_sia405_baseclass_metaattribute, schadenstelle.spezialbauwerk__BWREL_t_id, schadenstelle.symbolpos__BWREL_t_id, schadenstelle.textpos__BWREL_t_id
        # _rel_ --- schadenstelle.leitungref__REL

        leak = QWAT.leak(

            # --- leak ---
            # _repaired=row.REPLACE_ME,  # BOOLEAN
            # address=row.REPLACE_ME,  # TEXT
            # description=row.REPLACE_ME,  # TEXT
            # detection_date=row.REPLACE_ME,  # DATE
            # fk_cause=row.REPLACE_ME,  # INTEGER
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # geometry=row.REPLACE_ME,  # geometry(POINT,21781)
            # id=row.REPLACE_ME,  # INTEGER
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # pipe_replaced=row.REPLACE_ME,  # BOOLEAN
            # repair=row.REPLACE_ME,  # TEXT
            # repair_date=row.REPLACE_ME,  # DATE
            # widespread_damage=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(leak)
        print(".", end="")
    print("done")

    print("Importing WASSER.hydrant -> QWAT.hydrant")
    for row in wasser_session.query(WASSER.hydrant):

        # baseclass --- hydrant.t_ili_tid, hydrant.t_type
        # sia405_baseclass --- hydrant.obj_id
        # leitungsknoten --- hydrant.bemerkung, hydrant.druckzone, hydrant.eigentuemer, hydrant.einbaujahr, hydrant.geometrie, hydrant.hoehe, hydrant.hoehenbestimmung, hydrant.knotenref, hydrant.lagebestimmung, hydrant.symbolori
        # hydrant --- hydrant.art, hydrant.dimension, hydrant.entnahme, hydrant.fliessdruck, hydrant.hersteller, hydrant.material, hydrant.name_nummer, hydrant.t_id, hydrant.typ, hydrant.versorgungsdruck, hydrant.zustand
        # _bwrel_ --- hydrant.metaattribute__BWREL_sia405_baseclass_metaattribute, hydrant.muffen__BWREL_t_id, hydrant.rohrleitungsteil__BWREL_t_id, hydrant.sia405_symbolpos__BWREL_objekt, hydrant.sia405_textpos__BWREL_leitungsknotenref, hydrant.spezialbauwerk__BWREL_t_id, hydrant.symbolpos__BWREL_t_id, hydrant.textpos__BWREL_t_id, hydrant.uebrige__BWREL_t_id
        # _rel_ --- hydrant.knotenref__REL

        hydrant = QWAT.hydrant(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- hydrant ---
            # fk_material=row.REPLACE_ME,  # INTEGER
            # fk_model_inf=row.REPLACE_ME,  # INTEGER
            # fk_model_sup=row.REPLACE_ME,  # INTEGER
            # fk_output=row.REPLACE_ME,  # INTEGER
            # fk_provider=row.REPLACE_ME,  # INTEGER
            # flow=row.REPLACE_ME,  # NUMERIC(8, 2)
            # id=row.REPLACE_ME,  # INTEGER
            # marked=row.REPLACE_ME,  # BOOLEAN
            # observation_date=row.REPLACE_ME,  # DATE
            # observation_source=row.REPLACE_ME,  # VARCHAR(45)
            # pressure_dynamic=row.REPLACE_ME,  # NUMERIC(5, 2)
            # pressure_static=row.REPLACE_ME,  # NUMERIC(5, 2)
            # underground=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(hydrant)
        print(".", end="")
    print("done")

    print("Importing WASSER.wasserbehaelter -> QWAT.tank")
    for row in wasser_session.query(WASSER.wasserbehaelter):

        # baseclass --- wasserbehaelter.t_ili_tid, wasserbehaelter.t_type
        # sia405_baseclass --- wasserbehaelter.obj_id
        # leitungsknoten --- wasserbehaelter.bemerkung, wasserbehaelter.druckzone, wasserbehaelter.eigentuemer, wasserbehaelter.einbaujahr, wasserbehaelter.geometrie, wasserbehaelter.hoehe, wasserbehaelter.hoehenbestimmung, wasserbehaelter.knotenref, wasserbehaelter.lagebestimmung, wasserbehaelter.symbolori
        # wasserbehaelter --- wasserbehaelter.art, wasserbehaelter.beschichtung, wasserbehaelter.brauchwasserreserve, wasserbehaelter.fassungsvermoegen, wasserbehaelter.leistung, wasserbehaelter.loeschwasserreserve, wasserbehaelter.material, wasserbehaelter.name_nummer, wasserbehaelter.t_id, wasserbehaelter.ueberlaufhoehe, wasserbehaelter.zustand
        # _bwrel_ --- wasserbehaelter.metaattribute__BWREL_sia405_baseclass_metaattribute, wasserbehaelter.muffen__BWREL_t_id, wasserbehaelter.rohrleitungsteil__BWREL_t_id, wasserbehaelter.sia405_symbolpos__BWREL_objekt, wasserbehaelter.sia405_textpos__BWREL_leitungsknotenref, wasserbehaelter.spezialbauwerk__BWREL_t_id, wasserbehaelter.symbolpos__BWREL_t_id, wasserbehaelter.textpos__BWREL_t_id, wasserbehaelter.uebrige__BWREL_t_id
        # _rel_ --- wasserbehaelter.knotenref__REL

        tank = QWAT.tank(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- tank ---
            # _cistern1_litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
            # _cistern2_litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
            # _litrepercm=row.REPLACE_ME,  # NUMERIC(9, 3)
            # altitude_apron=row.REPLACE_ME,  # NUMERIC(7, 3)
            # altitude_overflow=row.REPLACE_ME,  # NUMERIC(7, 3)
            # cistern1_dimension_1=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern1_dimension_2=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern1_fk_type=row.REPLACE_ME,  # INTEGER
            # cistern1_storage=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern2_dimension_1=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern2_dimension_2=row.REPLACE_ME,  # NUMERIC(10, 2)
            # cistern2_fk_type=row.REPLACE_ME,  # INTEGER
            # cistern2_storage=row.REPLACE_ME,  # NUMERIC(10, 2)
            # fire_remote=row.REPLACE_ME,  # BOOLEAN
            # fire_valve=row.REPLACE_ME,  # BOOLEAN
            # fk_overflow=row.REPLACE_ME,  # INTEGER
            # fk_tank_firestorage=row.REPLACE_ME,  # INTEGER
            # height_max=row.REPLACE_ME,  # NUMERIC(7, 3)
            # id=row.REPLACE_ME,  # INTEGER
            # storage_fire=row.REPLACE_ME,  # NUMERIC(10, 1)
            # storage_supply=row.REPLACE_ME,  # NUMERIC(10, 1)
            # storage_total=row.REPLACE_ME,  # NUMERIC(10, 1)
        )
        qwat_session.add(tank)
        print(".", end="")
    print("done")

    print("Importing WASSER.foerderanlage -> QWAT.pump")
    for row in wasser_session.query(WASSER.foerderanlage):

        # baseclass --- foerderanlage.t_ili_tid, foerderanlage.t_type
        # sia405_baseclass --- foerderanlage.obj_id
        # leitungsknoten --- foerderanlage.bemerkung, foerderanlage.druckzone, foerderanlage.eigentuemer, foerderanlage.einbaujahr, foerderanlage.geometrie, foerderanlage.hoehe, foerderanlage.hoehenbestimmung, foerderanlage.knotenref, foerderanlage.lagebestimmung, foerderanlage.symbolori
        # foerderanlage --- foerderanlage.art, foerderanlage.leistung, foerderanlage.name_nummer, foerderanlage.t_id, foerderanlage.zustand
        # _bwrel_ --- foerderanlage.metaattribute__BWREL_sia405_baseclass_metaattribute, foerderanlage.muffen__BWREL_t_id, foerderanlage.rohrleitungsteil__BWREL_t_id, foerderanlage.sia405_symbolpos__BWREL_objekt, foerderanlage.sia405_textpos__BWREL_leitungsknotenref, foerderanlage.spezialbauwerk__BWREL_t_id, foerderanlage.symbolpos__BWREL_t_id, foerderanlage.textpos__BWREL_t_id, foerderanlage.uebrige__BWREL_t_id
        # _rel_ --- foerderanlage.knotenref__REL

        pump = QWAT.pump(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- pump ---
            # fk_pipe_in=row.REPLACE_ME,  # INTEGER
            # fk_pipe_out=row.REPLACE_ME,  # INTEGER
            # fk_pump_operating=row.REPLACE_ME,  # SMALLINT
            # fk_pump_type=row.REPLACE_ME,  # SMALLINT
            # id=row.REPLACE_ME,  # INTEGER
            # manometric_height=row.REPLACE_ME,  # NUMERIC(10, 2)
            # no_pumps=row.REPLACE_ME,  # SMALLINT
            # rejected_flow=row.REPLACE_ME,  # NUMERIC(10, 2)
        )
        qwat_session.add(pump)
        print(".", end="")
    print("done")

    print("Importing WASSER.wassergewinnungsanlage -> QWAT.treatment")
    for row in wasser_session.query(WASSER.wassergewinnungsanlage):

        # baseclass --- wassergewinnungsanlage.t_ili_tid, wassergewinnungsanlage.t_type
        # sia405_baseclass --- wassergewinnungsanlage.obj_id
        # leitungsknoten --- wassergewinnungsanlage.bemerkung, wassergewinnungsanlage.druckzone, wassergewinnungsanlage.eigentuemer, wassergewinnungsanlage.einbaujahr, wassergewinnungsanlage.geometrie, wassergewinnungsanlage.hoehe, wassergewinnungsanlage.hoehenbestimmung, wassergewinnungsanlage.knotenref, wassergewinnungsanlage.lagebestimmung, wassergewinnungsanlage.symbolori
        # wassergewinnungsanlage --- wassergewinnungsanlage.art, wassergewinnungsanlage.betreiber, wassergewinnungsanlage.konzessionaer, wassergewinnungsanlage.leistung, wassergewinnungsanlage.name_nummer, wassergewinnungsanlage.t_id, wassergewinnungsanlage.unterhaltspflichtiger, wassergewinnungsanlage.zustand
        # _bwrel_ --- wassergewinnungsanlage.metaattribute__BWREL_sia405_baseclass_metaattribute, wassergewinnungsanlage.muffen__BWREL_t_id, wassergewinnungsanlage.rohrleitungsteil__BWREL_t_id, wassergewinnungsanlage.sia405_symbolpos__BWREL_objekt, wassergewinnungsanlage.sia405_textpos__BWREL_leitungsknotenref, wassergewinnungsanlage.spezialbauwerk__BWREL_t_id, wassergewinnungsanlage.symbolpos__BWREL_t_id, wassergewinnungsanlage.textpos__BWREL_t_id, wassergewinnungsanlage.uebrige__BWREL_t_id
        # _rel_ --- wassergewinnungsanlage.knotenref__REL

        treatment = QWAT.treatment(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- treatment ---
            # activatedcharcoal=row.REPLACE_ME,  # BOOLEAN
            # filtration_membrane=row.REPLACE_ME,  # BOOLEAN
            # filtration_sandorgravel=row.REPLACE_ME,  # BOOLEAN
            # flocculation=row.REPLACE_ME,  # BOOLEAN
            # id=row.REPLACE_ME,  # INTEGER
            # sanitization_chlorine_gas=row.REPLACE_ME,  # BOOLEAN
            # sanitization_chlorine_liquid=row.REPLACE_ME,  # BOOLEAN
            # sanitization_ozone=row.REPLACE_ME,  # BOOLEAN
            # sanitization_uv=row.REPLACE_ME,  # BOOLEAN
            # settling=row.REPLACE_ME,  # BOOLEAN
            # treatment_capacity=row.REPLACE_ME,  # NUMERIC(10, 2)
        )
        qwat_session.add(treatment)
        print(".", end="")
    print("done")

    print("Importing WASSER.hausanschluss, WASSER.anlage -> QWAT.subscriber")
    for row, anlage in wasser_session.query(WASSER.hausanschluss, WASSER.anlage).join(WASSER.anlage):

        # baseclass --- hausanschluss.t_ili_tid, hausanschluss.t_type
        # sia405_baseclass --- hausanschluss.obj_id
        # leitungsknoten --- hausanschluss.bemerkung, hausanschluss.druckzone, hausanschluss.eigentuemer, hausanschluss.einbaujahr, hausanschluss.geometrie, hausanschluss.hoehe, hausanschluss.hoehenbestimmung, hausanschluss.knotenref, hausanschluss.lagebestimmung, hausanschluss.symbolori
        # hausanschluss --- hausanschluss.art, hausanschluss.dimension, hausanschluss.gebaeudeanschluss, hausanschluss.isolierstueck, hausanschluss.name_nummer, hausanschluss.standort, hausanschluss.t_id, hausanschluss.typ, hausanschluss.verbrauch, hausanschluss.zuordnung_hydraulischer_knoten, hausanschluss.zuordnung_hydraulischer_strang, hausanschluss.zustand
        # _bwrel_ --- hausanschluss.metaattribute__BWREL_sia405_baseclass_metaattribute, hausanschluss.muffen__BWREL_t_id, hausanschluss.rohrleitungsteil__BWREL_t_id, hausanschluss.sia405_symbolpos__BWREL_objekt, hausanschluss.sia405_textpos__BWREL_leitungsknotenref, hausanschluss.spezialbauwerk__BWREL_t_id, hausanschluss.symbolpos__BWREL_t_id, hausanschluss.textpos__BWREL_t_id, hausanschluss.uebrige__BWREL_t_id
        # _rel_ --- hausanschluss.knotenref__REL

        # baseclass --- anlage.t_ili_tid, anlage.t_type
        # sia405_baseclass --- anlage.obj_id
        # leitungsknoten --- anlage.bemerkung, anlage.druckzone, anlage.eigentuemer, anlage.einbaujahr, anlage.geometrie, anlage.hoehe, anlage.hoehenbestimmung, anlage.knotenref, anlage.lagebestimmung, anlage.symbolori
        # anlage --- anlage.art, anlage.betreiber, anlage.dimension1, anlage.konzessionaer, anlage.leistung, anlage.material, anlage.name_nummer, anlage.t_id, anlage.unterhaltspflichtiger, anlage.zustand
        # _bwrel_ --- anlage.metaattribute__BWREL_sia405_baseclass_metaattribute, anlage.muffen__BWREL_t_id, anlage.rohrleitungsteil__BWREL_t_id, anlage.sia405_symbolpos__BWREL_objekt, anlage.sia405_textpos__BWREL_leitungsknotenref, anlage.spezialbauwerk__BWREL_t_id, anlage.symbolpos__BWREL_t_id, anlage.textpos__BWREL_t_id, anlage.uebrige__BWREL_t_id
        # _rel_ --- anlage.knotenref__REL

        subscriber = QWAT.subscriber(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- subscriber ---
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # fk_subscriber_type=row.REPLACE_ME,  # INTEGER
            # flow_current=row.REPLACE_ME,  # NUMERIC(8, 2)
            # flow_planned=row.REPLACE_ME,  # NUMERIC(8, 2)
            # id=row.REPLACE_ME,  # INTEGER
            # parcel=row.REPLACE_ME,  # VARCHAR(12)
        )
        qwat_session.add(subscriber)
        print(".", end="")
    print("done")

    print("Importing WASSER.wassergewinnungsanlage -> QWAT.source")
    for row in wasser_session.query(WASSER.wassergewinnungsanlage):

        # baseclass --- wassergewinnungsanlage.t_ili_tid, wassergewinnungsanlage.t_type
        # sia405_baseclass --- wassergewinnungsanlage.obj_id
        # leitungsknoten --- wassergewinnungsanlage.bemerkung, wassergewinnungsanlage.druckzone, wassergewinnungsanlage.eigentuemer, wassergewinnungsanlage.einbaujahr, wassergewinnungsanlage.geometrie, wassergewinnungsanlage.hoehe, wassergewinnungsanlage.hoehenbestimmung, wassergewinnungsanlage.knotenref, wassergewinnungsanlage.lagebestimmung, wassergewinnungsanlage.symbolori
        # wassergewinnungsanlage --- wassergewinnungsanlage.art, wassergewinnungsanlage.betreiber, wassergewinnungsanlage.konzessionaer, wassergewinnungsanlage.leistung, wassergewinnungsanlage.name_nummer, wassergewinnungsanlage.t_id, wassergewinnungsanlage.unterhaltspflichtiger, wassergewinnungsanlage.zustand
        # _bwrel_ --- wassergewinnungsanlage.metaattribute__BWREL_sia405_baseclass_metaattribute, wassergewinnungsanlage.muffen__BWREL_t_id, wassergewinnungsanlage.rohrleitungsteil__BWREL_t_id, wassergewinnungsanlage.sia405_symbolpos__BWREL_objekt, wassergewinnungsanlage.sia405_textpos__BWREL_leitungsknotenref, wassergewinnungsanlage.spezialbauwerk__BWREL_t_id, wassergewinnungsanlage.symbolpos__BWREL_t_id, wassergewinnungsanlage.textpos__BWREL_t_id, wassergewinnungsanlage.uebrige__BWREL_t_id
        # _rel_ --- wassergewinnungsanlage.knotenref__REL

        source = QWAT.source(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- source ---
            # contract_end=row.REPLACE_ME,  # DATE
            # fk_source_quality=row.REPLACE_ME,  # SMALLINT
            # fk_source_type=row.REPLACE_ME,  # SMALLINT
            # flow_average=row.REPLACE_ME,  # NUMERIC(10, 3)
            # flow_concession=row.REPLACE_ME,  # NUMERIC(10, 2)
            # flow_lowest=row.REPLACE_ME,  # NUMERIC(10, 3)
            # gathering_chamber=row.REPLACE_ME,  # BOOLEAN
            # id=row.REPLACE_ME,  # INTEGER
        )
        qwat_session.add(source)
        print(".", end="")
    print("done")

    print("Importing WASSER.anlage -> QWAT.chamber")
    for row in wasser_session.query(WASSER.anlage):

        # baseclass --- anlage.t_ili_tid, anlage.t_type
        # sia405_baseclass --- anlage.obj_id
        # leitungsknoten --- anlage.bemerkung, anlage.druckzone, anlage.eigentuemer, anlage.einbaujahr, anlage.geometrie, anlage.hoehe, anlage.hoehenbestimmung, anlage.knotenref, anlage.lagebestimmung, anlage.symbolori
        # anlage --- anlage.art, anlage.betreiber, anlage.dimension1, anlage.konzessionaer, anlage.leistung, anlage.material, anlage.name_nummer, anlage.t_id, anlage.unterhaltspflichtiger, anlage.zustand
        # _bwrel_ --- anlage.metaattribute__BWREL_sia405_baseclass_metaattribute, anlage.muffen__BWREL_t_id, anlage.rohrleitungsteil__BWREL_t_id, anlage.sia405_symbolpos__BWREL_objekt, anlage.sia405_textpos__BWREL_leitungsknotenref, anlage.spezialbauwerk__BWREL_t_id, anlage.symbolpos__BWREL_t_id, anlage.textpos__BWREL_t_id, anlage.uebrige__BWREL_t_id
        # _rel_ --- anlage.knotenref__REL

        chamber = QWAT.chamber(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- chamber ---
            # depth=row.REPLACE_ME,  # NUMERIC(10, 3)
            # flow_meter=row.REPLACE_ME,  # BOOLEAN
            # id=row.REPLACE_ME,  # INTEGER
            # manometer=row.REPLACE_ME,  # BOOLEAN
            # networkseparation=row.REPLACE_ME,  # BOOLEAN
            # no_valves=row.REPLACE_ME,  # SMALLINT
            # water_meter=row.REPLACE_ME,  # BOOLEAN
        )
        qwat_session.add(chamber)
        print(".", end="")
    print("done")

    print("Importing WASSER.anlage -> QWAT.pressurecontrol")
    for row in wasser_session.query(WASSER.anlage):

        # baseclass --- anlage.t_ili_tid, anlage.t_type
        # sia405_baseclass --- anlage.obj_id
        # leitungsknoten --- anlage.bemerkung, anlage.druckzone, anlage.eigentuemer, anlage.einbaujahr, anlage.geometrie, anlage.hoehe, anlage.hoehenbestimmung, anlage.knotenref, anlage.lagebestimmung, anlage.symbolori
        # anlage --- anlage.art, anlage.betreiber, anlage.dimension1, anlage.konzessionaer, anlage.leistung, anlage.material, anlage.name_nummer, anlage.t_id, anlage.unterhaltspflichtiger, anlage.zustand
        # _bwrel_ --- anlage.metaattribute__BWREL_sia405_baseclass_metaattribute, anlage.muffen__BWREL_t_id, anlage.rohrleitungsteil__BWREL_t_id, anlage.sia405_symbolpos__BWREL_objekt, anlage.sia405_textpos__BWREL_leitungsknotenref, anlage.spezialbauwerk__BWREL_t_id, anlage.symbolpos__BWREL_t_id, anlage.textpos__BWREL_t_id, anlage.uebrige__BWREL_t_id
        # _rel_ --- anlage.knotenref__REL

        pressurecontrol = QWAT.pressurecontrol(

            # --- node ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN

            # --- network_element ---
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_status=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT

            # --- installation ---
            # eca=row.REPLACE_ME,  # VARCHAR(30)
            # fk_parent=row.REPLACE_ME,  # INTEGER
            # fk_remote=row.REPLACE_ME,  # INTEGER
            # fk_watertype=row.REPLACE_ME,  # INTEGER
            # geometry_polygon=row.REPLACE_ME,  # geometry(MULTIPOLYGON,21781)
            # name=row.REPLACE_ME,  # VARCHAR(60)
            # open_water_surface=row.REPLACE_ME,  # BOOLEAN
            # parcel=row.REPLACE_ME,  # VARCHAR(30)

            # --- pressurecontrol ---
            # fk_pressurecontrol_type=row.REPLACE_ME,  # INTEGER
            # id=row.REPLACE_ME,  # INTEGER
        )
        qwat_session.add(pressurecontrol)
        print(".", end="")
    print("done")

    print("Importing WASSER.absperrorgan -> QWAT.valve")
    for row in wasser_session.query(WASSER.absperrorgan):

        # baseclass --- absperrorgan.t_ili_tid, absperrorgan.t_type
        # sia405_baseclass --- absperrorgan.obj_id
        # leitungsknoten --- absperrorgan.bemerkung, absperrorgan.druckzone, absperrorgan.eigentuemer, absperrorgan.einbaujahr, absperrorgan.geometrie, absperrorgan.hoehe, absperrorgan.hoehenbestimmung, absperrorgan.knotenref, absperrorgan.lagebestimmung, absperrorgan.symbolori
        # absperrorgan --- absperrorgan.art, absperrorgan.hersteller, absperrorgan.material, absperrorgan.name_nummer, absperrorgan.nennweite, absperrorgan.schaltantrieb, absperrorgan.schaltzustand, absperrorgan.schliessrichtung, absperrorgan.t_id, absperrorgan.typ, absperrorgan.zulaessiger_bauteil_betriebsdruck, absperrorgan.zustand
        # _bwrel_ --- absperrorgan.metaattribute__BWREL_sia405_baseclass_metaattribute, absperrorgan.muffen__BWREL_t_id, absperrorgan.rohrleitungsteil__BWREL_t_id, absperrorgan.sia405_symbolpos__BWREL_objekt, absperrorgan.sia405_textpos__BWREL_leitungsknotenref, absperrorgan.spezialbauwerk__BWREL_t_id, absperrorgan.symbolpos__BWREL_t_id, absperrorgan.textpos__BWREL_t_id, absperrorgan.uebrige__BWREL_t_id
        # _rel_ --- absperrorgan.knotenref__REL

        valve = QWAT.valve(

            # --- valve ---
            # _geometry_alt1_used=row.REPLACE_ME,  # BOOLEAN
            # _geometry_alt2_used=row.REPLACE_ME,  # BOOLEAN
            # _pipe_node_type=row.REPLACE_ME,  # qwat_od.pipe_connection
            # _pipe_orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # _pipe_schema_visible=row.REPLACE_ME,  # BOOLEAN
            # _printmaps=row.REPLACE_ME,  # TEXT
            # _schema_visible=row.REPLACE_ME,  # BOOLEAN
            # altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # closed=row.REPLACE_ME,  # BOOLEAN
            # fk_distributor=row.REPLACE_ME,  # INTEGER
            # fk_district=row.REPLACE_ME,  # INTEGER
            # fk_folder=row.REPLACE_ME,  # INTEGER
            # fk_handle_precision=row.REPLACE_ME,  # INTEGER
            # fk_handle_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_locationtype=row.REPLACE_ME,  # INTEGER[]
            # fk_maintenance=row.REPLACE_ME,  # INTEGER[]
            # fk_nominal_diameter=row.REPLACE_ME,  # INTEGER
            # fk_object_reference=row.REPLACE_ME,  # INTEGER
            # fk_pipe=row.REPLACE_ME,  # INTEGER
            # fk_precision=row.REPLACE_ME,  # INTEGER
            # fk_precisionalti=row.REPLACE_ME,  # INTEGER
            # fk_pressurezone=row.REPLACE_ME,  # INTEGER
            # fk_printmap=row.REPLACE_ME,  # INTEGER[]
            # fk_status=row.REPLACE_ME,  # INTEGER
            # fk_valve_actuation=row.REPLACE_ME,  # INTEGER
            # fk_valve_function=row.REPLACE_ME,  # INTEGER
            # fk_valve_type=row.REPLACE_ME,  # INTEGER
            # geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt1=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # geometry_alt2=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # handle_altitude=row.REPLACE_ME,  # NUMERIC(10, 3)
            # handle_geometry=row.REPLACE_ME,  # geometry(POINTZ,21781)
            # id=row.REPLACE_ME,  # INTEGER
            # identification=row.REPLACE_ME,  # VARCHAR(50)
            # label_1_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_1_visible=row.REPLACE_ME,  # SMALLINT
            # label_1_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_1_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_rotation=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_text=row.REPLACE_ME,  # VARCHAR(120)
            # label_2_visible=row.REPLACE_ME,  # SMALLINT
            # label_2_x=row.REPLACE_ME,  # DOUBLE PRECISION
            # label_2_y=row.REPLACE_ME,  # DOUBLE PRECISION
            # networkseparation=row.REPLACE_ME,  # BOOLEAN
            # orientation=row.REPLACE_ME,  # DOUBLE PRECISION
            # remark=row.REPLACE_ME,  # TEXT
            # schema_force_visible=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt1=row.REPLACE_ME,  # BOOLEAN
            # update_geometry_alt2=row.REPLACE_ME,  # BOOLEAN
            # year=row.REPLACE_ME,  # SMALLINT
            # year_end=row.REPLACE_ME,  # SMALLINT
        )
        qwat_session.add(valve)
        print(".", end="")
    print("done")

    qwat_session.commit()

    qwat_session.close()
    wasser_session.close()
