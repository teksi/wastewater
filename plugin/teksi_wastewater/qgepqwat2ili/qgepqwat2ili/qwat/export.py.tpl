from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_Transform, ST_Force2D

from .. import utils

from .model_qwat import get_qwat_model
from .model_wasser import get_wasser_model


def qwat_export():

    QWAT = get_qwat_model()
    WASSER = get_wasser_model()

    qwat_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    wasser_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    tid_maker = utils.ili2db.TidMaker(id_attribute='obj_id')

    def create_metaattributes(row, session):
        metaattribute = WASSER.metaattribute(
            # FIELDS TO MAP TO WASSER.metaattribute
            # --- metaattribute ---
            # datenherr=row.REPLACE_ME,
            # datenlieferant=row.REPLACE_ME,
            # letzte_aenderung=row.REPLACE_ME,
            # sia405_baseclass_metaattribute=row.REPLACE_ME,
            # t_id=row.REPLACE_ME
            # t_seq=row.REPLACE_ME,
        )
        session.add(metaattribute)

    print("Exporting QWAT.node -> WASSER.hydraulischer_knoten, WASSER.rohrleitungsteil")
    for row in qwat_session.query(QWAT.node):

        # node --- node._geometry_alt1_used, node._geometry_alt2_used, node._pipe_node_type, node._pipe_orientation, node._pipe_schema_visible, node._printmaps, node.fk_district, node.fk_pressurezone, node.fk_printmap, node.geometry, node.geometry_alt1, node.geometry_alt2, node.id, node.update_geometry_alt1, node.update_geometry_alt2
        # _bwrel_ --- node.pipe__BWREL_fk_node_a, node.pipe__BWREL_fk_node_b
        # _rel_ --- node.fk_district__REL, node.fk_pressurezone__REL

        hydraulischer_knoten = WASSER.hydraulischer_knoten(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- hydraulischer_knoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # knotentyp=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # verbrauch=row.REPLACE_ME,  # INTEGER
        )
        wasser_session.add(hydraulischer_knoten)
        rohrleitungsteil = WASSER.rohrleitungsteil(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- rohrleitungsteil ---
            # abwinklung=row.REPLACE_ME,  # VARCHAR(10)
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # dimension=row.REPLACE_ME,  # INTEGER
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # verbindung=row.REPLACE_ME,  # VARCHAR(255)
            # zulaessiger_betriebsdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(rohrleitungsteil)
        print(".", end="")
    print("done")

    print("Exporting QWAT.pipe -> WASSER.hydraulischer_strang, WASSER.leitung")
    for row in qwat_session.query(QWAT.pipe):

        # pipe --- pipe._diff_elevation, pipe._geometry_alt1_used, pipe._geometry_alt2_used, pipe._length2d, pipe._length3d, pipe._printmaps, pipe._schema_visible, pipe._valve_closed, pipe._valve_count, pipe.fk_bedding, pipe.fk_distributor, pipe.fk_district, pipe.fk_folder, pipe.fk_function, pipe.fk_installmethod, pipe.fk_locationtype, pipe.fk_material, pipe.fk_node_a, pipe.fk_node_b, pipe.fk_parent, pipe.fk_precision, pipe.fk_pressurezone, pipe.fk_printmap, pipe.fk_protection, pipe.fk_status, pipe.fk_watertype, pipe.geometry, pipe.geometry_alt1, pipe.geometry_alt2, pipe.id, pipe.label_1_text, pipe.label_1_visible, pipe.label_2_text, pipe.label_2_visible, pipe.pressure_nominal, pipe.remark, pipe.schema_force_visible, pipe.tunnel_or_bridge, pipe.update_geometry_alt1, pipe.update_geometry_alt2, pipe.year, pipe.year_end, pipe.year_rehabilitation
        # _bwrel_ --- pipe.crossing__BWREL__pipe1_id, pipe.crossing__BWREL__pipe2_id, pipe.leak__BWREL_fk_pipe, pipe.meter__BWREL_fk_pipe, pipe.part__BWREL_fk_pipe, pipe.pipe__BWREL_fk_parent, pipe.pump__BWREL_fk_pipe_in, pipe.pump__BWREL_fk_pipe_out, pipe.subscriber__BWREL_fk_pipe, pipe.valve__BWREL_fk_pipe
        # _rel_ --- pipe.fk_bedding__REL, pipe.fk_distributor__REL, pipe.fk_district__REL, pipe.fk_folder__REL, pipe.fk_function__REL, pipe.fk_installmethod__REL, pipe.fk_material__REL, pipe.fk_node_a__REL, pipe.fk_node_b__REL, pipe.fk_parent__REL, pipe.fk_precision__REL, pipe.fk_pressurezone__REL, pipe.fk_protection__REL, pipe.fk_status__REL, pipe.fk_watertype__REL, pipe.label_1_visible__REL, pipe.label_2_visible__REL, pipe.schema_force_visible__REL

        hydraulischer_strang = WASSER.hydraulischer_strang(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- hydraulischer_strang ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # bisknotenref=row.REPLACE_ME,  # BIGINT
            # durchfluss=row.REPLACE_ME,  # NUMERIC(6, 2)
            # fliessgeschwindigkeit=row.REPLACE_ME,  # NUMERIC(7, 3)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # referenz_durchmesser=row.REPLACE_ME,  # INTEGER
            # referenz_laenge=row.REPLACE_ME,  # INTEGER
            # referenz_rauheit=row.REPLACE_ME,  # INTEGER
            # t_id=row.REPLACE_ME,  # BIGINT
            # verbrauch=row.REPLACE_ME,  # INTEGER
            # vonknotenref=row.REPLACE_ME,  # BIGINT
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(hydraulischer_strang)
        leitung = WASSER.leitung(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitung ---
            # astatus=row.REPLACE_ME,  # VARCHAR(255)
            # aussenbeschichtung=row.REPLACE_ME,  # VARCHAR(255)
            # baujahr=row.REPLACE_ME,  # INTEGER
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # betriebsdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # bettung=row.REPLACE_ME,  # VARCHAR(255)
            # druckzone=row.REPLACE_ME,  # VARCHAR(30)
            # durchmesser=row.REPLACE_ME,  # INTEGER
            # durchmesseraussen=row.REPLACE_ME,  # INTEGER
            # durchmesserinnen=row.REPLACE_ME,  # INTEGER
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # funktion=row.REPLACE_ME,  # VARCHAR(255)
            # geometrie=row.REPLACE_ME,  # geometry(COMPOUNDCURVE,2056)
            # hydraulische_rauheit=row.REPLACE_ME,  # NUMERIC(6, 2)
            # innenbeschichtung=row.REPLACE_ME,  # VARCHAR(255)
            # kathodischer_schutz=row.REPLACE_ME,  # VARCHAR(255)
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # laenge=row.REPLACE_ME,  # INTEGER
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # nennweite=row.REPLACE_ME,  # VARCHAR(10)
            # sanierung_erneuerung=row.REPLACE_ME,  # VARCHAR(255)
            # schubsicherung=row.REPLACE_ME,  # VARCHAR(255)
            # strangref=row.REPLACE_ME,  # BIGINT
            # t_id=row.REPLACE_ME,  # BIGINT
            # ueberdeckung=row.REPLACE_ME,  # NUMERIC(4, 1)
            # unterhalt=row.REPLACE_ME,  # VARCHAR(30)
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # verbindungsart=row.REPLACE_ME,  # VARCHAR(255)
            # verlegeart=row.REPLACE_ME,  # VARCHAR(255)
            # wasserqualitaet=row.REPLACE_ME,  # VARCHAR(255)
            # zulaessiger_bauteil_betriebsdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(leitung)
        print(".", end="")
    print("done")

    print("Exporting QWAT.leak -> WASSER.schadenstelle")
    for row in qwat_session.query(QWAT.leak):

        # leak --- leak._repaired, leak.address, leak.description, leak.detection_date, leak.fk_cause, leak.fk_pipe, leak.geometry, leak.id, leak.label_1_rotation, leak.label_1_text, leak.label_1_visible, leak.label_1_x, leak.label_1_y, leak.label_2_rotation, leak.label_2_text, leak.label_2_visible, leak.label_2_x, leak.label_2_y, leak.pipe_replaced, leak.repair, leak.repair_date, leak.widespread_damage
        # _rel_ --- leak.fk_cause__REL, leak.fk_pipe__REL, leak.label_1_visible__REL, leak.label_2_visible__REL

        schadenstelle = WASSER.schadenstelle(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- schadenstelle ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # ausloeser=row.REPLACE_ME,  # VARCHAR(80)
            # behebungsdatum=row.REPLACE_ME,  # DATE
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # erhebungsdatum=row.REPLACE_ME,  # DATE
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # leitungref=row.REPLACE_ME,  # BIGINT
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # ursache=row.REPLACE_ME,  # VARCHAR(255)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(schadenstelle)
        print(".", end="")
    print("done")

    print("Exporting QWAT.hydrant -> WASSER.hydrant")
    for row in qwat_session.query(QWAT.hydrant):

        # node --- hydrant._geometry_alt1_used, hydrant._geometry_alt2_used, hydrant._pipe_node_type, hydrant._pipe_orientation, hydrant._pipe_schema_visible, hydrant._printmaps, hydrant.fk_district, hydrant.fk_pressurezone, hydrant.fk_printmap, hydrant.geometry, hydrant.geometry_alt1, hydrant.geometry_alt2, hydrant.update_geometry_alt1, hydrant.update_geometry_alt2
        # network_element --- hydrant.altitude, hydrant.fk_distributor, hydrant.fk_folder, hydrant.fk_locationtype, hydrant.fk_object_reference, hydrant.fk_precision, hydrant.fk_precisionalti, hydrant.fk_status, hydrant.identification, hydrant.label_1_rotation, hydrant.label_1_text, hydrant.label_1_visible, hydrant.label_1_x, hydrant.label_1_y, hydrant.label_2_rotation, hydrant.label_2_text, hydrant.label_2_visible, hydrant.label_2_x, hydrant.label_2_y, hydrant.orientation, hydrant.remark, hydrant.year, hydrant.year_end
        # hydrant --- hydrant.fk_material, hydrant.fk_model_inf, hydrant.fk_model_sup, hydrant.fk_output, hydrant.fk_provider, hydrant.flow, hydrant.id, hydrant.marked, hydrant.observation_date, hydrant.observation_source, hydrant.pressure_dynamic, hydrant.pressure_static, hydrant.underground
        # _bwrel_ --- hydrant.meter__BWREL_id, hydrant.pipe__BWREL_fk_node_a, hydrant.pipe__BWREL_fk_node_b, hydrant.samplingpoint__BWREL_id
        # _rel_ --- hydrant.fk_distributor__REL, hydrant.fk_district__REL, hydrant.fk_folder__REL, hydrant.fk_material__REL, hydrant.fk_model_inf__REL, hydrant.fk_model_sup__REL, hydrant.fk_object_reference__REL, hydrant.fk_output__REL, hydrant.fk_precision__REL, hydrant.fk_precisionalti__REL, hydrant.fk_pressurezone__REL, hydrant.fk_provider__REL, hydrant.fk_status__REL, hydrant.label_1_visible__REL, hydrant.label_2_visible__REL

        hydrant = WASSER.hydrant(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- hydrant ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # dimension=row.REPLACE_ME,  # INTEGER
            # entnahme=row.REPLACE_ME,  # NUMERIC(9, 3)
            # fliessdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # hersteller=row.REPLACE_ME,  # VARCHAR(40)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # typ=row.REPLACE_ME,  # VARCHAR(10)
            # versorgungsdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(hydrant)
        print(".", end="")
    print("done")

    print("Exporting QWAT.tank -> WASSER.wasserbehaelter")
    for row in qwat_session.query(QWAT.tank):

        # node --- tank._geometry_alt1_used, tank._geometry_alt2_used, tank._pipe_node_type, tank._pipe_orientation, tank._pipe_schema_visible, tank._printmaps, tank.fk_district, tank.fk_pressurezone, tank.fk_printmap, tank.geometry, tank.geometry_alt1, tank.geometry_alt2, tank.update_geometry_alt1, tank.update_geometry_alt2
        # network_element --- tank.altitude, tank.fk_distributor, tank.fk_folder, tank.fk_locationtype, tank.fk_object_reference, tank.fk_precision, tank.fk_precisionalti, tank.fk_status, tank.identification, tank.label_1_rotation, tank.label_1_text, tank.label_1_visible, tank.label_1_x, tank.label_1_y, tank.label_2_rotation, tank.label_2_text, tank.label_2_visible, tank.label_2_x, tank.label_2_y, tank.orientation, tank.remark, tank.year, tank.year_end
        # installation --- tank.eca, tank.fk_parent, tank.fk_remote, tank.fk_watertype, tank.geometry_polygon, tank.name, tank.open_water_surface, tank.parcel
        # tank --- tank._cistern1_litrepercm, tank._cistern2_litrepercm, tank._litrepercm, tank.altitude_apron, tank.altitude_overflow, tank.cistern1_dimension_1, tank.cistern1_dimension_2, tank.cistern1_fk_type, tank.cistern1_storage, tank.cistern2_dimension_1, tank.cistern2_dimension_2, tank.cistern2_fk_type, tank.cistern2_storage, tank.fire_remote, tank.fire_valve, tank.fk_overflow, tank.fk_tank_firestorage, tank.height_max, tank.id, tank.storage_fire, tank.storage_supply, tank.storage_total
        # _bwrel_ --- tank.cover__BWREL_fk_installation, tank.installation__BWREL_fk_parent, tank.meter__BWREL_id, tank.pipe__BWREL_fk_node_a, tank.pipe__BWREL_fk_node_b, tank.pressurecontrol_type__BWREL_id, tank.samplingpoint__BWREL_id
        # _rel_ --- tank.cistern1_fk_type__REL, tank.cistern2_fk_type__REL, tank.fk_distributor__REL, tank.fk_district__REL, tank.fk_folder__REL, tank.fk_object_reference__REL, tank.fk_overflow__REL, tank.fk_parent__REL, tank.fk_precision__REL, tank.fk_precisionalti__REL, tank.fk_pressurezone__REL, tank.fk_remote__REL, tank.fk_status__REL, tank.fk_tank_firestorage__REL, tank.fk_watertype__REL, tank.label_1_visible__REL, tank.label_2_visible__REL

        wasserbehaelter = WASSER.wasserbehaelter(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- wasserbehaelter ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # beschichtung=row.REPLACE_ME,  # VARCHAR(40)
            # brauchwasserreserve=row.REPLACE_ME,  # NUMERIC(10, 2)
            # fassungsvermoegen=row.REPLACE_ME,  # NUMERIC(10, 2)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # loeschwasserreserve=row.REPLACE_ME,  # NUMERIC(10, 2)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # ueberlaufhoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(wasserbehaelter)
        print(".", end="")
    print("done")

    print("Exporting QWAT.pump -> WASSER.foerderanlage")
    for row in qwat_session.query(QWAT.pump):

        # node --- pump._geometry_alt1_used, pump._geometry_alt2_used, pump._pipe_node_type, pump._pipe_orientation, pump._pipe_schema_visible, pump._printmaps, pump.fk_district, pump.fk_pressurezone, pump.fk_printmap, pump.geometry, pump.geometry_alt1, pump.geometry_alt2, pump.update_geometry_alt1, pump.update_geometry_alt2
        # network_element --- pump.altitude, pump.fk_distributor, pump.fk_folder, pump.fk_locationtype, pump.fk_object_reference, pump.fk_precision, pump.fk_precisionalti, pump.fk_status, pump.identification, pump.label_1_rotation, pump.label_1_text, pump.label_1_visible, pump.label_1_x, pump.label_1_y, pump.label_2_rotation, pump.label_2_text, pump.label_2_visible, pump.label_2_x, pump.label_2_y, pump.orientation, pump.remark, pump.year, pump.year_end
        # installation --- pump.eca, pump.fk_parent, pump.fk_remote, pump.fk_watertype, pump.geometry_polygon, pump.name, pump.open_water_surface, pump.parcel
        # pump --- pump.fk_pipe_in, pump.fk_pipe_out, pump.fk_pump_operating, pump.fk_pump_type, pump.id, pump.manometric_height, pump.no_pumps, pump.rejected_flow
        # _bwrel_ --- pump.cover__BWREL_fk_installation, pump.installation__BWREL_fk_parent, pump.meter__BWREL_id, pump.pipe__BWREL_fk_node_a, pump.pipe__BWREL_fk_node_b, pump.pressurecontrol_type__BWREL_id, pump.samplingpoint__BWREL_id
        # _rel_ --- pump.fk_distributor__REL, pump.fk_district__REL, pump.fk_folder__REL, pump.fk_object_reference__REL, pump.fk_parent__REL, pump.fk_pipe_in__REL, pump.fk_pipe_out__REL, pump.fk_precision__REL, pump.fk_precisionalti__REL, pump.fk_pressurezone__REL, pump.fk_pump_operating__REL, pump.fk_pump_type__REL, pump.fk_remote__REL, pump.fk_status__REL, pump.fk_watertype__REL, pump.label_1_visible__REL, pump.label_2_visible__REL

        foerderanlage = WASSER.foerderanlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- foerderanlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(foerderanlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.treatment -> WASSER.wassergewinnungsanlage")
    for row in qwat_session.query(QWAT.treatment):

        # node --- treatment._geometry_alt1_used, treatment._geometry_alt2_used, treatment._pipe_node_type, treatment._pipe_orientation, treatment._pipe_schema_visible, treatment._printmaps, treatment.fk_district, treatment.fk_pressurezone, treatment.fk_printmap, treatment.geometry, treatment.geometry_alt1, treatment.geometry_alt2, treatment.update_geometry_alt1, treatment.update_geometry_alt2
        # network_element --- treatment.altitude, treatment.fk_distributor, treatment.fk_folder, treatment.fk_locationtype, treatment.fk_object_reference, treatment.fk_precision, treatment.fk_precisionalti, treatment.fk_status, treatment.identification, treatment.label_1_rotation, treatment.label_1_text, treatment.label_1_visible, treatment.label_1_x, treatment.label_1_y, treatment.label_2_rotation, treatment.label_2_text, treatment.label_2_visible, treatment.label_2_x, treatment.label_2_y, treatment.orientation, treatment.remark, treatment.year, treatment.year_end
        # installation --- treatment.eca, treatment.fk_parent, treatment.fk_remote, treatment.fk_watertype, treatment.geometry_polygon, treatment.name, treatment.open_water_surface, treatment.parcel
        # treatment --- treatment.activatedcharcoal, treatment.filtration_membrane, treatment.filtration_sandorgravel, treatment.flocculation, treatment.id, treatment.sanitization_chlorine_gas, treatment.sanitization_chlorine_liquid, treatment.sanitization_ozone, treatment.sanitization_uv, treatment.settling, treatment.treatment_capacity
        # _bwrel_ --- treatment.cover__BWREL_fk_installation, treatment.installation__BWREL_fk_parent, treatment.meter__BWREL_id, treatment.pipe__BWREL_fk_node_a, treatment.pipe__BWREL_fk_node_b, treatment.pressurecontrol_type__BWREL_id, treatment.samplingpoint__BWREL_id
        # _rel_ --- treatment.fk_distributor__REL, treatment.fk_district__REL, treatment.fk_folder__REL, treatment.fk_object_reference__REL, treatment.fk_parent__REL, treatment.fk_precision__REL, treatment.fk_precisionalti__REL, treatment.fk_pressurezone__REL, treatment.fk_remote__REL, treatment.fk_status__REL, treatment.fk_watertype__REL, treatment.label_1_visible__REL, treatment.label_2_visible__REL

        wassergewinnungsanlage = WASSER.wassergewinnungsanlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- wassergewinnungsanlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(wassergewinnungsanlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.subscriber -> WASSER.hausanschluss, WASSER.anlage")
    for row in qwat_session.query(QWAT.subscriber):

        # node --- subscriber._geometry_alt1_used, subscriber._geometry_alt2_used, subscriber._pipe_node_type, subscriber._pipe_orientation, subscriber._pipe_schema_visible, subscriber._printmaps, subscriber.fk_district, subscriber.fk_pressurezone, subscriber.fk_printmap, subscriber.geometry, subscriber.geometry_alt1, subscriber.geometry_alt2, subscriber.update_geometry_alt1, subscriber.update_geometry_alt2
        # network_element --- subscriber.altitude, subscriber.fk_distributor, subscriber.fk_folder, subscriber.fk_locationtype, subscriber.fk_object_reference, subscriber.fk_precision, subscriber.fk_precisionalti, subscriber.fk_status, subscriber.identification, subscriber.label_1_rotation, subscriber.label_1_text, subscriber.label_1_visible, subscriber.label_1_x, subscriber.label_1_y, subscriber.label_2_rotation, subscriber.label_2_text, subscriber.label_2_visible, subscriber.label_2_x, subscriber.label_2_y, subscriber.orientation, subscriber.remark, subscriber.year, subscriber.year_end
        # subscriber --- subscriber.fk_pipe, subscriber.fk_subscriber_type, subscriber.flow_current, subscriber.flow_planned, subscriber.id, subscriber.parcel
        # _bwrel_ --- subscriber.meter__BWREL_id, subscriber.pipe__BWREL_fk_node_a, subscriber.pipe__BWREL_fk_node_b, subscriber.samplingpoint__BWREL_id, subscriber.subscriber_reference__BWREL_fk_subscriber
        # _rel_ --- subscriber.fk_distributor__REL, subscriber.fk_district__REL, subscriber.fk_folder__REL, subscriber.fk_object_reference__REL, subscriber.fk_pipe__REL, subscriber.fk_precision__REL, subscriber.fk_precisionalti__REL, subscriber.fk_pressurezone__REL, subscriber.fk_status__REL, subscriber.fk_subscriber_type__REL, subscriber.label_1_visible__REL, subscriber.label_2_visible__REL

        hausanschluss = WASSER.hausanschluss(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- hausanschluss ---
            # art=row.REPLACE_ME,  # VARCHAR(30)
            # dimension=row.REPLACE_ME,  # INTEGER
            # gebaeudeanschluss=row.REPLACE_ME,  # VARCHAR(255)
            # isolierstueck=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # standort=row.REPLACE_ME,  # VARCHAR(10)
            # t_id=row.REPLACE_ME,  # BIGINT
            # typ=row.REPLACE_ME,  # VARCHAR(10)
            # verbrauch=row.REPLACE_ME,  # INTEGER
            # zuordnung_hydraulischer_knoten=row.REPLACE_ME,  # VARCHAR(40)
            # zuordnung_hydraulischer_strang=row.REPLACE_ME,  # VARCHAR(40)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(hausanschluss)
        anlage = WASSER.anlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- anlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # dimension1=row.REPLACE_ME,  # INTEGER
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(anlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.source -> WASSER.wassergewinnungsanlage")
    for row in qwat_session.query(QWAT.source):

        # node --- source._geometry_alt1_used, source._geometry_alt2_used, source._pipe_node_type, source._pipe_orientation, source._pipe_schema_visible, source._printmaps, source.fk_district, source.fk_pressurezone, source.fk_printmap, source.geometry, source.geometry_alt1, source.geometry_alt2, source.update_geometry_alt1, source.update_geometry_alt2
        # network_element --- source.altitude, source.fk_distributor, source.fk_folder, source.fk_locationtype, source.fk_object_reference, source.fk_precision, source.fk_precisionalti, source.fk_status, source.identification, source.label_1_rotation, source.label_1_text, source.label_1_visible, source.label_1_x, source.label_1_y, source.label_2_rotation, source.label_2_text, source.label_2_visible, source.label_2_x, source.label_2_y, source.orientation, source.remark, source.year, source.year_end
        # installation --- source.eca, source.fk_parent, source.fk_remote, source.fk_watertype, source.geometry_polygon, source.name, source.open_water_surface, source.parcel
        # source --- source.contract_end, source.fk_source_quality, source.fk_source_type, source.flow_average, source.flow_concession, source.flow_lowest, source.gathering_chamber, source.id
        # _bwrel_ --- source.cover__BWREL_fk_installation, source.installation__BWREL_fk_parent, source.meter__BWREL_id, source.pipe__BWREL_fk_node_a, source.pipe__BWREL_fk_node_b, source.pressurecontrol_type__BWREL_id, source.samplingpoint__BWREL_id
        # _rel_ --- source.fk_distributor__REL, source.fk_district__REL, source.fk_folder__REL, source.fk_object_reference__REL, source.fk_parent__REL, source.fk_precision__REL, source.fk_precisionalti__REL, source.fk_pressurezone__REL, source.fk_remote__REL, source.fk_source_quality__REL, source.fk_source_type__REL, source.fk_status__REL, source.fk_watertype__REL, source.label_1_visible__REL, source.label_2_visible__REL

        wassergewinnungsanlage = WASSER.wassergewinnungsanlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- wassergewinnungsanlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(wassergewinnungsanlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.chamber -> WASSER.anlage")
    for row in qwat_session.query(QWAT.chamber):

        # node --- chamber._geometry_alt1_used, chamber._geometry_alt2_used, chamber._pipe_node_type, chamber._pipe_orientation, chamber._pipe_schema_visible, chamber._printmaps, chamber.fk_district, chamber.fk_pressurezone, chamber.fk_printmap, chamber.geometry, chamber.geometry_alt1, chamber.geometry_alt2, chamber.update_geometry_alt1, chamber.update_geometry_alt2
        # network_element --- chamber.altitude, chamber.fk_distributor, chamber.fk_folder, chamber.fk_locationtype, chamber.fk_object_reference, chamber.fk_precision, chamber.fk_precisionalti, chamber.fk_status, chamber.identification, chamber.label_1_rotation, chamber.label_1_text, chamber.label_1_visible, chamber.label_1_x, chamber.label_1_y, chamber.label_2_rotation, chamber.label_2_text, chamber.label_2_visible, chamber.label_2_x, chamber.label_2_y, chamber.orientation, chamber.remark, chamber.year, chamber.year_end
        # installation --- chamber.eca, chamber.fk_parent, chamber.fk_remote, chamber.fk_watertype, chamber.geometry_polygon, chamber.name, chamber.open_water_surface, chamber.parcel
        # chamber --- chamber.depth, chamber.flow_meter, chamber.id, chamber.manometer, chamber.networkseparation, chamber.no_valves, chamber.water_meter
        # _bwrel_ --- chamber.cover__BWREL_fk_installation, chamber.installation__BWREL_fk_parent, chamber.meter__BWREL_id, chamber.pipe__BWREL_fk_node_a, chamber.pipe__BWREL_fk_node_b, chamber.pressurecontrol_type__BWREL_id, chamber.samplingpoint__BWREL_id
        # _rel_ --- chamber.fk_distributor__REL, chamber.fk_district__REL, chamber.fk_folder__REL, chamber.fk_object_reference__REL, chamber.fk_parent__REL, chamber.fk_precision__REL, chamber.fk_precisionalti__REL, chamber.fk_pressurezone__REL, chamber.fk_remote__REL, chamber.fk_status__REL, chamber.fk_watertype__REL, chamber.label_1_visible__REL, chamber.label_2_visible__REL

        anlage = WASSER.anlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- anlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # dimension1=row.REPLACE_ME,  # INTEGER
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(anlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.pressurecontrol -> WASSER.anlage")
    for row in qwat_session.query(QWAT.pressurecontrol):

        # node --- pressurecontrol._geometry_alt1_used, pressurecontrol._geometry_alt2_used, pressurecontrol._pipe_node_type, pressurecontrol._pipe_orientation, pressurecontrol._pipe_schema_visible, pressurecontrol._printmaps, pressurecontrol.fk_district, pressurecontrol.fk_pressurezone, pressurecontrol.fk_printmap, pressurecontrol.geometry, pressurecontrol.geometry_alt1, pressurecontrol.geometry_alt2, pressurecontrol.update_geometry_alt1, pressurecontrol.update_geometry_alt2
        # network_element --- pressurecontrol.altitude, pressurecontrol.fk_distributor, pressurecontrol.fk_folder, pressurecontrol.fk_locationtype, pressurecontrol.fk_object_reference, pressurecontrol.fk_precision, pressurecontrol.fk_precisionalti, pressurecontrol.fk_status, pressurecontrol.identification, pressurecontrol.label_1_rotation, pressurecontrol.label_1_text, pressurecontrol.label_1_visible, pressurecontrol.label_1_x, pressurecontrol.label_1_y, pressurecontrol.label_2_rotation, pressurecontrol.label_2_text, pressurecontrol.label_2_visible, pressurecontrol.label_2_x, pressurecontrol.label_2_y, pressurecontrol.orientation, pressurecontrol.remark, pressurecontrol.year, pressurecontrol.year_end
        # installation --- pressurecontrol.eca, pressurecontrol.fk_parent, pressurecontrol.fk_remote, pressurecontrol.fk_watertype, pressurecontrol.geometry_polygon, pressurecontrol.name, pressurecontrol.open_water_surface, pressurecontrol.parcel
        # pressurecontrol --- pressurecontrol.fk_pressurecontrol_type, pressurecontrol.id
        # _bwrel_ --- pressurecontrol.cover__BWREL_fk_installation, pressurecontrol.installation__BWREL_fk_parent, pressurecontrol.meter__BWREL_id, pressurecontrol.pipe__BWREL_fk_node_a, pressurecontrol.pipe__BWREL_fk_node_b, pressurecontrol.pressurecontrol_type__BWREL_id, pressurecontrol.samplingpoint__BWREL_id
        # _rel_ --- pressurecontrol.fk_distributor__REL, pressurecontrol.fk_district__REL, pressurecontrol.fk_folder__REL, pressurecontrol.fk_object_reference__REL, pressurecontrol.fk_parent__REL, pressurecontrol.fk_precision__REL, pressurecontrol.fk_precisionalti__REL, pressurecontrol.fk_pressurecontrol_type__REL, pressurecontrol.fk_pressurezone__REL, pressurecontrol.fk_remote__REL, pressurecontrol.fk_status__REL, pressurecontrol.fk_watertype__REL, pressurecontrol.label_1_visible__REL, pressurecontrol.label_2_visible__REL

        anlage = WASSER.anlage(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- anlage ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # betreiber=row.REPLACE_ME,  # VARCHAR(80)
            # dimension1=row.REPLACE_ME,  # INTEGER
            # konzessionaer=row.REPLACE_ME,  # VARCHAR(80)
            # leistung=row.REPLACE_ME,  # VARCHAR(30)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # t_id=row.REPLACE_ME,  # BIGINT
            # unterhaltspflichtiger=row.REPLACE_ME,  # VARCHAR(80)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(anlage)
        print(".", end="")
    print("done")

    print("Exporting QWAT.valve -> WASSER.absperrorgan")
    for row in qwat_session.query(QWAT.valve):

        # valve --- valve._geometry_alt1_used, valve._geometry_alt2_used, valve._pipe_node_type, valve._pipe_orientation, valve._pipe_schema_visible, valve._printmaps, valve._schema_visible, valve.altitude, valve.closed, valve.fk_distributor, valve.fk_district, valve.fk_folder, valve.fk_handle_precision, valve.fk_handle_precisionalti, valve.fk_locationtype, valve.fk_maintenance, valve.fk_nominal_diameter, valve.fk_object_reference, valve.fk_pipe, valve.fk_precision, valve.fk_precisionalti, valve.fk_pressurezone, valve.fk_printmap, valve.fk_status, valve.fk_valve_actuation, valve.fk_valve_function, valve.fk_valve_type, valve.geometry, valve.geometry_alt1, valve.geometry_alt2, valve.handle_altitude, valve.handle_geometry, valve.id, valve.identification, valve.label_1_rotation, valve.label_1_text, valve.label_1_visible, valve.label_1_x, valve.label_1_y, valve.label_2_rotation, valve.label_2_text, valve.label_2_visible, valve.label_2_x, valve.label_2_y, valve.networkseparation, valve.orientation, valve.remark, valve.schema_force_visible, valve.update_geometry_alt1, valve.update_geometry_alt2, valve.year, valve.year_end
        # _rel_ --- valve.fk_distributor__REL, valve.fk_district__REL, valve.fk_folder__REL, valve.fk_handle_precision__REL, valve.fk_handle_precisionalti__REL, valve.fk_nominal_diameter__REL, valve.fk_object_reference__REL, valve.fk_pipe__REL, valve.fk_precision__REL, valve.fk_precisionalti__REL, valve.fk_pressurezone__REL, valve.fk_status__REL, valve.fk_valve_actuation__REL, valve.fk_valve_function__REL, valve.fk_valve_type__REL, valve.label_1_visible__REL, valve.label_2_visible__REL, valve.schema_force_visible__REL

        absperrorgan = WASSER.absperrorgan(

            # --- baseclass ---
            # t_ili_tid=row.REPLACE_ME,  # VARCHAR(200)
            # t_type=row.REPLACE_ME,  # VARCHAR(60)

            # --- sia405_baseclass ---
            # obj_id=row.REPLACE_ME,  # VARCHAR(16)

            # --- leitungsknoten ---
            # bemerkung=row.REPLACE_ME,  # VARCHAR(80)
            # druckzone=row.REPLACE_ME,  # NUMERIC(3, 1)
            # eigentuemer=row.REPLACE_ME,  # VARCHAR(80)
            # einbaujahr=row.REPLACE_ME,  # INTEGER
            # geometrie=row.REPLACE_ME,  # geometry(POINT,2056)
            # hoehe=row.REPLACE_ME,  # NUMERIC(7, 3)
            # hoehenbestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # knotenref=row.REPLACE_ME,  # BIGINT
            # lagebestimmung=row.REPLACE_ME,  # VARCHAR(255)
            # symbolori=row.REPLACE_ME,  # NUMERIC(4, 1)

            # --- absperrorgan ---
            # art=row.REPLACE_ME,  # VARCHAR(255)
            # hersteller=row.REPLACE_ME,  # VARCHAR(30)
            # material=row.REPLACE_ME,  # VARCHAR(255)
            # name_nummer=row.REPLACE_ME,  # VARCHAR(40)
            # nennweite=row.REPLACE_ME,  # VARCHAR(10)
            # schaltantrieb=row.REPLACE_ME,  # VARCHAR(255)
            # schaltzustand=row.REPLACE_ME,  # VARCHAR(255)
            # schliessrichtung=row.REPLACE_ME,  # VARCHAR(255)
            # t_id=row.REPLACE_ME,  # BIGINT
            # typ=row.REPLACE_ME,  # VARCHAR(10)
            # zulaessiger_bauteil_betriebsdruck=row.REPLACE_ME,  # NUMERIC(3, 1)
            # zustand=row.REPLACE_ME,  # VARCHAR(40)
        )
        wasser_session.add(absperrorgan)
        print(".", end="")
    print("done")

    wasser_session.commit()

    qwat_session.close()
    wasser_session.close()
