import datetime
import unicodedata

from geoalchemy2.functions import (
    ST_Z,
    ST_CurveToLine,
    ST_Force2D,
    ST_ForceCurve,
    ST_GeometryN,
    ST_LineSubstring,
    ST_NumGeometries,
    ST_RemoveRepeatedPoints,
    ST_Transform,
)
from sqlalchemy.orm import Session

from .. import utils
from ..utils.various import logger
from .model_qwat import get_qwat_model
from .model_wasser import get_wasser_model


def qwat_export(include_hydraulics=False):

    if include_hydraulics:
        logger.warning(
            "Exports with hydraulics are currently broken (invalid). Remove --include_hydraulics to export valid files."
        )

    QWAT = get_qwat_model()
    WASSER = get_wasser_model()

    # We use these to identify fields that are not matched
    DOES_NOT_EXIST_IN_QWAT = None
    MAPPING_OPEN_QUESTION = None

    # Logging disabled (very slow)
    # qwat_session = Session(utils.sqlalchemy.create_engine(logger_name='qwat'), autocommit=False, autoflush=False)
    # wasser_session = Session(utils.sqlalchemy.create_engine(logger_name='wasser'), autocommit=False, autoflush=False)
    qwat_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    wasser_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    tid_maker = utils.ili2db.TidMaker(id_attribute="id")

    def tid2oid(tid):
        return f"ch{tid:014}"  # convert to OID

    def get_tid(relation, for_class=None):
        """
        Makes a tid for a relation
        """
        if relation is None:
            return None
        return tid_maker.tid_for_row(relation, for_class=for_class)

    def get_vl(relation, attr_name="sia405code"):
        """
        Gets a literal value from a value list relation
        """
        if relation is None:
            return None
        if not hasattr(relation, attr_name):
            logger.warning(f"{relation} has no attribute {attr_name}")
            return None
        return getattr(relation, attr_name)

    def truncate(val, max_length):
        """
        Raises a warning if values gets truncated
        """
        if val is None:
            return None
        if len(val) > max_length:
            logger.warning(f"Value '{val}' exceeds expected length ({max_length})")
        return val[0:max_length]

    def clamp(val, min_val=None, max_val=None, accept_none=False):
        """
        Raises a warning if values gets clamped
        """
        if val is None and accept_none:
            return None
        if (val is None) or (min_val is not None and val < min_val):
            logger.warning(f"Value '{val}' was clamped to {min_val}")
            val = min_val
        elif max_val is not None and val > max_val:
            logger.warning(f"Value '{val}' was clamped to {max_val}")
            val = max_val
        return val

    def sanitize_str(val):
        """
        Converts blank strings to NULLs (see https://github.com/claeis/ili2db/issues/388) and removes control characters
        """
        if not val:
            return None
        # from https://stackoverflow.com/a/19016117/13690651
        return "".join(ch for ch in val if unicodedata.category(ch)[0] != "C")

    def sanitize_geom(val):
        return ST_RemoveRepeatedPoints(ST_Force2D(ST_Transform(val, 2056)), 0.002)

    def create_metaattributes(instance):
        logger.warning(
            f"QWAT doesn't define meta attributes. Dummy metaattributes will be created with an arbitrary date."
        )

        # NOTE : QWAT doesn't define meta attributes, so we create a dummy metattribute
        metaattribute = WASSER.metaattribute(
            # FIELDS TO MAP TO WASSER.metaattribute
            # --- metaattribute ---
            datenherr="unknown",
            datenlieferant="unknown",
            letzte_aenderung=datetime.datetime.today(),
            sia405_baseclass_metaattribute=instance.t_id,
            # OD : is this OK ? Don't we need a different t_id from what inserted above in organisation ? if so, consider adding a "for_class" arg to tid_for_row
            t_id=instance.t_id,
            t_seq=0,
        )
        wasser_session.add(metaattribute)

    def create_spezialbauwerk(row, spezialbauwerk_art):
        """
        Some objects (such as Anlage, Wasserbehaelter, Wassergewinnungsanlage, Foerderanlage, ...)
        that have a polygonal representation are also to be represented with a spezialbauwerk
        """

        spezialbauwerk = WASSER.spezialbauwerk(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "spezialbauwerk", tid_for_class=WASSER.spezialbauwerk),
            # --- spezialbauwerk ---
            name_nummer=str(row.id),
            art=spezialbauwerk_art,
            material=DOES_NOT_EXIST_IN_QWAT,
            einbaujahr=clamp(row.year, min_val=1800, max_val=2100, accept_none=True),
            eigentuemer=DOES_NOT_EXIST_IN_QWAT,
            bemerkung=DOES_NOT_EXIST_IN_QWAT,
        )
        wasser_session.add(spezialbauwerk)
        create_metaattributes(spezialbauwerk)

        # TODO : using scalar here may cause many database roundtrips, we can probably do that client side
        geom_count = wasser_session.scalar(ST_NumGeometries(row.geometry_polygon))
        for geom_idx in range(geom_count):
            spezialbauwerk_flaeche = WASSER.spezialbauwerk_flaeche(
                # --- spezialbauwerk_flaeche ---
                geometrie=ST_ForceCurve(ST_GeometryN(sanitize_geom(row.geometry_polygon), geom_idx + 1)),
                spezialbauwerkref__REL=spezialbauwerk,
            )
            wasser_session.add(spezialbauwerk_flaeche)
            # create_metaattributes(spezialbauwerk_flaeche)

    def base_common(row, type_name, tid_for_class=None):
        """
        Returns common attributes for base
        """
        tid = get_tid(row, tid_for_class)
        oid = tid2oid(tid)
        return {
            "t_ili_tid": oid,
            "t_type": type_name,
            "obj_id": oid,
            "t_id": tid,
        }

    def leitungsknoten_common(row):
        """
        Returns common attributes for leitungsknoten
        """
        return {
            # --- leitungsknoten ---
            "bemerkung": DOES_NOT_EXIST_IN_QWAT,
            "druckzone": DOES_NOT_EXIST_IN_QWAT,
            "eigentuemer": DOES_NOT_EXIST_IN_QWAT,
            "einbaujahr": clamp(row.year, min_val=1800, max_val=2100, accept_none=True),
            "geometrie": sanitize_geom(row.geometry),
            "hoehe": ST_Z(row.geometry),
            "hoehenbestimmung": get_vl(row.fk_precisionalti__REL),
            "knotenref": None if not include_hydraulics else tid_maker.tid_for_row(row, QWAT.node),
            "lagebestimmung": get_vl(row.fk_precision__REL),
            "symbolori": 0,
        }

    if not include_hydraulics:
        logger.info("Skipping QWAT.node -> WASSER.hydraulischer_knoten")
    else:
        logger.info("Exporting QWAT.node -> WASSER.hydraulischer_knoten")
        # Mapping all QWAT nodes to hydraulischer_knoten.
        for row in qwat_session.query(QWAT.node):

            # node --- node.id, node.fk_district, node.fk_pressurezone, node.fk_printmap, node._printmaps, node._geometry_alt1_used, node._geometry_alt2_used, node._pipe_node_type, node._pipe_orientation, node._pipe_schema_visible, node.geometry, node.geometry_alt1, node.geometry_alt2, node.update_geometry_alt1, node.update_geometry_alt2
            # _bwrel_ --- node.pipe__BWREL_fk_node_b, node.pipe__BWREL_fk_node_a
            # _rel_ --- node.fk_district__REL, node.fk_pressurezone__REL

            hydraulischer_knoten = WASSER.hydraulischer_knoten(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **base_common(row, "hydraulischer_knoten", tid_for_class=QWAT.node),
                # --- hydraulischer_knoten ---
                bemerkung=DOES_NOT_EXIST_IN_QWAT,
                druck=MAPPING_OPEN_QUESTION,
                geometrie=sanitize_geom(row.geometry),
                knotentyp="Normalknoten",
                name_nummer=str(row.id),
                verbrauch=DOES_NOT_EXIST_IN_QWAT,
            )
            wasser_session.add(hydraulischer_knoten)
            create_metaattributes(hydraulischer_knoten)
            print(".", end="")
        logger.info("done")
        wasser_session.flush()

    # In most cases, leitungsknoten will be created further down by subclasses.
    # But we still need to create leitungsknoten for plain nodes (not subclass instances)
    logger.info("Exporting QWAT.node -> WASSER.rohrleitungsteil")
    for row in (
        qwat_session.query(QWAT.node).join(QWAT.network_element, isouter=True).filter(QWAT.network_element.id == None)
    ):
        # In most cases, leitungsknoten will be created further down by subclasses.
        # But we still need to create leitungsknoten for plain nodes (not subclass instances)

        rohrleitungsteil = WASSER.rohrleitungsteil(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "rohrleitungsteil"),
            # --- leitungsknoten ---
            bemerkung=DOES_NOT_EXIST_IN_QWAT,
            druckzone=DOES_NOT_EXIST_IN_QWAT,
            eigentuemer=DOES_NOT_EXIST_IN_QWAT,
            einbaujahr=None,
            geometrie=sanitize_geom(row.geometry),
            hoehe=ST_Z(row.geometry),
            hoehenbestimmung="unbekannt",
            knotenref=None if not include_hydraulics else tid_maker.tid_for_row(row, QWAT.node),
            lagebestimmung="unbekannt",
            symbolori=0,
            # --- rohrleitungsteil ---
            # Note : there's no match for these attributes, as we are matching generic/abstract
            # QWAT.node to specific WASSER.rohrleitungsteil, because WASSER.leitungsknoten is
            # abstract.
            abwinklung=DOES_NOT_EXIST_IN_QWAT,
            art=DOES_NOT_EXIST_IN_QWAT,
            dimension=DOES_NOT_EXIST_IN_QWAT,
            material=DOES_NOT_EXIST_IN_QWAT,
            name_nummer=DOES_NOT_EXIST_IN_QWAT,
            verbindung=DOES_NOT_EXIST_IN_QWAT,
            zulaessiger_betriebsdruck=DOES_NOT_EXIST_IN_QWAT,
            zustand=DOES_NOT_EXIST_IN_QWAT,
        )
        wasser_session.add(rohrleitungsteil)
        create_metaattributes(rohrleitungsteil)
        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.pipe -> WASSER.hydraulischer_strang, WASSER.leitung")
    for row in qwat_session.query(QWAT.pipe):

        # pipe --- pipe.id, pipe.fk_parent, pipe.fk_function, pipe.fk_installmethod, pipe.fk_material, pipe.fk_distributor, pipe.fk_precision, pipe.fk_bedding, pipe.fk_protection, pipe.fk_status, pipe.fk_watertype, pipe.fk_locationtype, pipe.fk_folder, pipe.year, pipe.year_rehabilitation, pipe.year_end, pipe.tunnel_or_bridge, pipe.pressure_nominal, pipe.remark, pipe._valve_count, pipe._valve_closed, pipe.label_1_visible, pipe.label_1_text, pipe.label_2_visible, pipe.label_2_text, pipe.fk_node_a, pipe.fk_node_b, pipe.fk_district, pipe.fk_pressurezone, pipe.fk_printmap, pipe._length2d, pipe._length3d, pipe._diff_elevation, pipe._printmaps, pipe._geometry_alt1_used, pipe._geometry_alt2_used, pipe.update_geometry_alt1, pipe.update_geometry_alt2, pipe.geometry, pipe.geometry_alt1, pipe.geometry_alt2, pipe.schema_force_visible, pipe._schema_visible
        # _bwrel_ --- pipe.meter__BWREL_fk_pipe, pipe.leak__BWREL_fk_pipe, pipe.valve__BWREL_fk_pipe, pipe.crossing__BWREL__pipe2_id, pipe.crossing__BWREL__pipe1_id, pipe.pipe__BWREL_fk_parent, pipe.part__BWREL_fk_pipe, pipe.subscriber__BWREL_fk_pipe, pipe.pump__BWREL_fk_pipe_in, pipe.pump__BWREL_fk_pipe_out
        # _rel_ --- pipe.fk_precision__REL, pipe.schema_force_visible__REL, pipe.fk_installmethod__REL, pipe.fk_material__REL, pipe.label_1_visible__REL, pipe.fk_function__REL, pipe.fk_watertype__REL, pipe.fk_parent__REL, pipe.label_2_visible__REL, pipe.fk_status__REL, pipe.fk_node_b__REL, pipe.fk_pressurezone__REL, pipe.fk_folder__REL, pipe.fk_protection__REL, pipe.fk_district__REL, pipe.fk_bedding__REL, pipe.fk_node_a__REL, pipe.fk_distributor__REL

        if include_hydraulics:
            hydraulischer_strang = WASSER.hydraulischer_strang(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **base_common(row, "hydraulischer_strang", tid_for_class=WASSER.hydraulischer_strang),
                # --- hydraulischer_strang ---
                bemerkung=truncate(sanitize_str(row.remark), 80),
                bisknotenref=get_tid(row.fk_node_b__REL, QWAT.node),
                durchfluss=DOES_NOT_EXIST_IN_QWAT,
                fliessgeschwindigkeit=DOES_NOT_EXIST_IN_QWAT,
                name_nummer=str(row.id),
                referenz_durchmesser=clamp(get_vl(row.fk_material__REL, "diameter_nominal"), min_val=0),
                referenz_laenge=row._length2d,
                referenz_rauheit=DOES_NOT_EXIST_IN_QWAT,
                verbrauch=DOES_NOT_EXIST_IN_QWAT,
                vonknotenref=get_tid(row.fk_node_a__REL, QWAT.node),
                zustand=get_vl(row.fk_status__REL),
            )
            wasser_session.add(hydraulischer_strang)
            create_metaattributes(hydraulischer_strang)

        leitung = WASSER.leitung(
            # FIELDS TO MAP TO WASSER.leitung
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "leitung", tid_for_class=WASSER.leitung),
            # --- leitung ---
            astatus=get_vl(row.fk_status__REL),
            aussenbeschichtung=get_vl(row.fk_protection__REL),
            baujahr=clamp(row.year, min_val=1800, max_val=2100),
            bemerkung=truncate(sanitize_str(row.remark), 80),
            betreiber=get_vl(row.fk_distributor__REL, "name"),
            betriebsdruck=row.pressure_nominal,
            bettung=get_vl(row.fk_bedding__REL),
            druckzone=get_vl(row.fk_pressurezone__REL, "name") or "unknown",
            durchmesser=get_vl(row.fk_material__REL, "diameter_nominal"),
            durchmesseraussen=get_vl(row.fk_material__REL, "diameter_external"),
            durchmesserinnen=get_vl(row.fk_material__REL, "diameter_internal"),
            eigentuemer=DOES_NOT_EXIST_IN_QWAT,
            funktion=get_vl(row.fk_function__REL),
            geometrie=ST_ForceCurve(sanitize_geom(row.geometry)),
            hydraulische_rauheit=DOES_NOT_EXIST_IN_QWAT,
            innenbeschichtung=DOES_NOT_EXIST_IN_QWAT,
            kathodischer_schutz=DOES_NOT_EXIST_IN_QWAT,
            konzessionaer=DOES_NOT_EXIST_IN_QWAT,
            laenge=row._length2d,
            lagebestimmung=get_vl(row.fk_precision__REL),
            material=get_vl(row.fk_material__REL),
            name_nummer=str(row.id),
            nennweite=str(get_vl(row.fk_material__REL, "diameter_nominal")),
            sanierung_erneuerung=DOES_NOT_EXIST_IN_QWAT,
            schubsicherung=DOES_NOT_EXIST_IN_QWAT,
            strangref=None if not include_hydraulics else hydraulischer_strang.t_id,
            ueberdeckung=DOES_NOT_EXIST_IN_QWAT,
            unterhalt=DOES_NOT_EXIST_IN_QWAT,
            unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
            verbindungsart=DOES_NOT_EXIST_IN_QWAT,
            verlegeart=get_vl(row.fk_installmethod__REL),
            wasserqualitaet=get_vl(row.fk_watertype__REL),
            zulaessiger_bauteil_betriebsdruck=get_vl(row.fk_material__REL, "pressure_nominal"),
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(leitung)
        create_metaattributes(leitung)
        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.leak -> WASSER.schadenstelle")
    for row in qwat_session.query(QWAT.leak):

        # leak --- leak.id, leak.fk_cause, leak.fk_pipe, leak.widespread_damage, leak.detection_date, leak.repair_date, leak._repaired, leak.address, leak.pipe_replaced, leak.description, leak.repair, leak.geometry, leak.label_1_visible, leak.label_1_x, leak.label_1_y, leak.label_1_rotation, leak.label_1_text, leak.label_2_visible, leak.label_2_x, leak.label_2_y, leak.label_2_rotation, leak.label_2_text
        # _rel_ --- leak.label_2_visible__REL, leak.label_1_visible__REL, leak.fk_cause__REL, leak.fk_pipe__REL

        if row.fk_pipe__REL is None:
            logger.warning(
                f"Cannot export QWAT.leak {row.id} as it has no related pipe, which are mandatory in SIA405."
            )
            continue

        schadenstelle = WASSER.schadenstelle(
            # FIELDS TO MAP TO WASSER.schadenstelle
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "schadenstelle"),
            # --- schadenstelle ---
            art=get_vl(row.fk_cause__REL),
            ausloeser=DOES_NOT_EXIST_IN_QWAT,
            behebungsdatum=row.repair_date,
            bemerkung=truncate(sanitize_str(row.description), 80),
            erhebungsdatum=row.detection_date,
            geometrie=sanitize_geom(row.geometry),
            leitungref=get_tid(row.fk_pipe__REL, for_class=WASSER.leitung),
            name_nummer=str(row.id),
            ursache=DOES_NOT_EXIST_IN_QWAT,  # somehow overlapping with art, but not exactly
            zustand=DOES_NOT_EXIST_IN_QWAT,
        )
        wasser_session.add(schadenstelle)
        create_metaattributes(schadenstelle)
        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.hydrant -> WASSER.hydrant")
    for row in qwat_session.query(QWAT.hydrant):

        # node --- hydrant.fk_district, hydrant.fk_pressurezone, hydrant.fk_printmap, hydrant._printmaps, hydrant._geometry_alt1_used, hydrant._geometry_alt2_used, hydrant._pipe_node_type, hydrant._pipe_orientation, hydrant._pipe_schema_visible, hydrant.geometry, hydrant.geometry_alt1, hydrant.geometry_alt2, hydrant.update_geometry_alt1, hydrant.update_geometry_alt2
        # network_element --- hydrant.identification, hydrant.fk_distributor, hydrant.fk_status, hydrant.fk_folder, hydrant.fk_locationtype, hydrant.fk_precision, hydrant.fk_precisionalti, hydrant.fk_object_reference, hydrant.altitude, hydrant.year, hydrant.year_end, hydrant.orientation, hydrant.remark, hydrant.label_1_visible, hydrant.label_1_x, hydrant.label_1_y, hydrant.label_1_rotation, hydrant.label_1_text, hydrant.label_2_visible, hydrant.label_2_x, hydrant.label_2_y, hydrant.label_2_rotation, hydrant.label_2_text
        # hydrant --- hydrant.id, hydrant.fk_provider, hydrant.fk_model_sup, hydrant.fk_model_inf, hydrant.fk_material, hydrant.fk_output, hydrant.underground, hydrant.marked, hydrant.pressure_static, hydrant.pressure_dynamic, hydrant.flow, hydrant.observation_date, hydrant.observation_source
        # _bwrel_ --- hydrant.samplingpoint__BWREL_id, hydrant.meter__BWREL_id, hydrant.pipe__BWREL_fk_node_b, hydrant.pipe__BWREL_fk_node_a
        # _rel_ --- hydrant.fk_model_inf__REL, hydrant.fk_model_sup__REL, hydrant.fk_provider__REL, hydrant.fk_output__REL, hydrant.fk_material__REL, hydrant.fk_object_reference__REL, hydrant.label_1_visible__REL, hydrant.label_2_visible__REL, hydrant.fk_precisionalti__REL, hydrant.fk_folder__REL, hydrant.fk_precision__REL, hydrant.fk_distributor__REL, hydrant.fk_status__REL, hydrant.fk_district__REL, hydrant.fk_pressurezone__REL

        hydrant = WASSER.hydrant(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "hydrant"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- hydrant ---
            art=get_vl(row.fk_model_inf__REL) if row.underground else get_vl(row.fk_model_sup__REL),
            dimension=DOES_NOT_EXIST_IN_QWAT,
            entnahme=row.flow,
            fliessdruck=row.pressure_dynamic,
            hersteller=get_vl(row.fk_provider__REL),
            material=get_vl(row.fk_material__REL),
            name_nummer=row.identification,
            typ=truncate(f"{row.fk_model_sup} / {row.fk_model_inf}", 10),
            versorgungsdruck=row.pressure_static,
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(hydrant)
        create_metaattributes(hydrant)
        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.tank -> WASSER.wasserbehaelter")
    for row in qwat_session.query(QWAT.tank):

        # node --- tank.fk_district, tank.fk_pressurezone, tank.fk_printmap, tank._printmaps, tank._geometry_alt1_used, tank._geometry_alt2_used, tank._pipe_node_type, tank._pipe_orientation, tank._pipe_schema_visible, tank.geometry, tank.geometry_alt1, tank.geometry_alt2, tank.update_geometry_alt1, tank.update_geometry_alt2
        # network_element --- tank.identification, tank.fk_distributor, tank.fk_status, tank.fk_folder, tank.fk_locationtype, tank.fk_precision, tank.fk_precisionalti, tank.fk_object_reference, tank.altitude, tank.year, tank.year_end, tank.orientation, tank.remark, tank.label_1_visible, tank.label_1_x, tank.label_1_y, tank.label_1_rotation, tank.label_1_text, tank.label_2_visible, tank.label_2_x, tank.label_2_y, tank.label_2_rotation, tank.label_2_text
        # installation --- tank.name, tank.fk_parent, tank.fk_remote, tank.fk_watertype, tank.parcel, tank.eca, tank.open_water_surface, tank.geometry_polygon
        # tank --- tank.id, tank.fk_overflow, tank.fk_tank_firestorage, tank.storage_total, tank.storage_supply, tank.storage_fire, tank.altitude_overflow, tank.altitude_apron, tank.height_max, tank.fire_valve, tank.fire_remote, tank._litrepercm, tank.cistern1_fk_type, tank.cistern1_dimension_1, tank.cistern1_dimension_2, tank.cistern1_storage, tank._cistern1_litrepercm, tank.cistern2_fk_type, tank.cistern2_dimension_1, tank.cistern2_dimension_2, tank.cistern2_storage, tank._cistern2_litrepercm
        # _bwrel_ --- tank.samplingpoint__BWREL_id, tank.cover__BWREL_fk_installation, tank.pressurecontrol_type__BWREL_id, tank.meter__BWREL_id, tank.pipe__BWREL_fk_node_b, tank.pipe__BWREL_fk_node_a, tank.installation__BWREL_fk_parent
        # _rel_ --- tank.cistern1_fk_type__REL, tank.cistern2_fk_type__REL, tank.fk_tank_firestorage__REL, tank.fk_overflow__REL, tank.fk_remote__REL, tank.fk_watertype__REL, tank.fk_parent__REL, tank.fk_object_reference__REL, tank.label_1_visible__REL, tank.label_2_visible__REL, tank.fk_precisionalti__REL, tank.fk_folder__REL, tank.fk_precision__REL, tank.fk_distributor__REL, tank.fk_status__REL, tank.fk_district__REL, tank.fk_pressurezone__REL

        wasserbehaelter = WASSER.wasserbehaelter(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "wasserbehaelter"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- wasserbehaelter ---
            art=DOES_NOT_EXIST_IN_QWAT,
            beschichtung=DOES_NOT_EXIST_IN_QWAT,
            brauchwasserreserve=clamp(row.storage_supply, min_val=0) / 1000,
            fassungsvermoegen=clamp(row.storage_total, min_val=0) / 1000,
            leistung=DOES_NOT_EXIST_IN_QWAT,
            loeschwasserreserve=clamp(row.storage_fire, min_val=0) / 1000,
            material=DOES_NOT_EXIST_IN_QWAT,
            name_nummer=str(row.id),
            ueberlaufhoehe=clamp(row.altitude_overflow, min_val=0),
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(wasserbehaelter)
        create_metaattributes(wasserbehaelter)

        if row.geometry_polygon:
            create_spezialbauwerk(row, "Wasserbehaelter")

        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.pump -> WASSER.foerderanlage")
    for row in qwat_session.query(QWAT.pump):

        # node --- pump.fk_district, pump.fk_pressurezone, pump.fk_printmap, pump._printmaps, pump._geometry_alt1_used, pump._geometry_alt2_used, pump._pipe_node_type, pump._pipe_orientation, pump._pipe_schema_visible, pump.geometry, pump.geometry_alt1, pump.geometry_alt2, pump.update_geometry_alt1, pump.update_geometry_alt2
        # network_element --- pump.identification, pump.fk_distributor, pump.fk_status, pump.fk_folder, pump.fk_locationtype, pump.fk_precision, pump.fk_precisionalti, pump.fk_object_reference, pump.altitude, pump.year, pump.year_end, pump.orientation, pump.remark, pump.label_1_visible, pump.label_1_x, pump.label_1_y, pump.label_1_rotation, pump.label_1_text, pump.label_2_visible, pump.label_2_x, pump.label_2_y, pump.label_2_rotation, pump.label_2_text
        # installation --- pump.name, pump.fk_parent, pump.fk_remote, pump.fk_watertype, pump.parcel, pump.eca, pump.open_water_surface, pump.geometry_polygon
        # pump --- pump.id, pump.fk_pump_type, pump.fk_pipe_in, pump.fk_pipe_out, pump.fk_pump_operating, pump.no_pumps, pump.rejected_flow, pump.manometric_height
        # _bwrel_ --- pump.samplingpoint__BWREL_id, pump.cover__BWREL_fk_installation, pump.pressurecontrol_type__BWREL_id, pump.meter__BWREL_id, pump.pipe__BWREL_fk_node_b, pump.pipe__BWREL_fk_node_a, pump.installation__BWREL_fk_parent
        # _rel_ --- pump.fk_pump_type__REL, pump.fk_pump_operating__REL, pump.fk_pipe_in__REL, pump.fk_pipe_out__REL, pump.fk_remote__REL, pump.fk_watertype__REL, pump.fk_parent__REL, pump.fk_object_reference__REL, pump.label_1_visible__REL, pump.label_2_visible__REL, pump.fk_precisionalti__REL, pump.fk_folder__REL, pump.fk_precision__REL, pump.fk_distributor__REL, pump.fk_status__REL, pump.fk_district__REL, pump.fk_pressurezone__REL

        foerderanlage = WASSER.foerderanlage(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "foerderanlage"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- foerderanlage ---
            art=get_vl(row.fk_pump_type__REL),
            leistung=f"{row.rejected_flow} m3/s",
            name_nummer=str(row.id),
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(foerderanlage)
        create_metaattributes(foerderanlage)

        if row.geometry_polygon:
            create_spezialbauwerk(row, "Foerderanlage")

        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.treatment -> WASSER.wassergewinnungsanlage")
    for row in qwat_session.query(QWAT.treatment):

        # node --- treatment.fk_district, treatment.fk_pressurezone, treatment.fk_printmap, treatment._printmaps, treatment._geometry_alt1_used, treatment._geometry_alt2_used, treatment._pipe_node_type, treatment._pipe_orientation, treatment._pipe_schema_visible, treatment.geometry, treatment.geometry_alt1, treatment.geometry_alt2, treatment.update_geometry_alt1, treatment.update_geometry_alt2
        # network_element --- treatment.identification, treatment.fk_distributor, treatment.fk_status, treatment.fk_folder, treatment.fk_locationtype, treatment.fk_precision, treatment.fk_precisionalti, treatment.fk_object_reference, treatment.altitude, treatment.year, treatment.year_end, treatment.orientation, treatment.remark, treatment.label_1_visible, treatment.label_1_x, treatment.label_1_y, treatment.label_1_rotation, treatment.label_1_text, treatment.label_2_visible, treatment.label_2_x, treatment.label_2_y, treatment.label_2_rotation, treatment.label_2_text
        # installation --- treatment.name, treatment.fk_parent, treatment.fk_remote, treatment.fk_watertype, treatment.parcel, treatment.eca, treatment.open_water_surface, treatment.geometry_polygon
        # treatment --- treatment.id, treatment.sanitization_uv, treatment.sanitization_chlorine_liquid, treatment.sanitization_chlorine_gas, treatment.sanitization_ozone, treatment.filtration_membrane, treatment.filtration_sandorgravel, treatment.flocculation, treatment.activatedcharcoal, treatment.settling, treatment.treatment_capacity
        # _bwrel_ --- treatment.pressurecontrol_type__BWREL_id, treatment.meter__BWREL_id, treatment.pipe__BWREL_fk_node_b, treatment.pipe__BWREL_fk_node_a, treatment.samplingpoint__BWREL_id, treatment.cover__BWREL_fk_installation, treatment.installation__BWREL_fk_parent
        # _rel_ --- treatment.fk_remote__REL, treatment.fk_parent__REL, treatment.fk_watertype__REL, treatment.fk_distributor__REL, treatment.fk_status__REL, treatment.fk_object_reference__REL, treatment.fk_precision__REL, treatment.fk_folder__REL, treatment.label_1_visible__REL, treatment.label_2_visible__REL, treatment.fk_precisionalti__REL, treatment.fk_district__REL, treatment.fk_pressurezone__REL

        wassergewinnungsanlage = WASSER.wassergewinnungsanlage(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "wassergewinnungsanlage"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- wassergewinnungsanlage ---
            name_nummer=str(row.id),
            art="Aufbereitungsanlage.unbekannt",
            leistung=f"{row.treatment_capacity}",
            betreiber=row.fk_distributor__REL.name,
            konzessionaer=DOES_NOT_EXIST_IN_QWAT,
            unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(wassergewinnungsanlage)
        create_metaattributes(wassergewinnungsanlage)

        if row.geometry_polygon:
            create_spezialbauwerk(row, "Wassergewinnungsanlage.uebrige")

        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.subscriber -> WASSER.hausanschluss")
    for row in qwat_session.query(QWAT.subscriber):

        # node --- subscriber.fk_district, subscriber.fk_pressurezone, subscriber.fk_printmap, subscriber._printmaps, subscriber._geometry_alt1_used, subscriber._geometry_alt2_used, subscriber._pipe_node_type, subscriber._pipe_orientation, subscriber._pipe_schema_visible, subscriber.geometry, subscriber.geometry_alt1, subscriber.geometry_alt2, subscriber.update_geometry_alt1, subscriber.update_geometry_alt2
        # network_element --- subscriber.identification, subscriber.fk_distributor, subscriber.fk_status, subscriber.fk_folder, subscriber.fk_locationtype, subscriber.fk_precision, subscriber.fk_precisionalti, subscriber.fk_object_reference, subscriber.altitude, subscriber.year, subscriber.year_end, subscriber.orientation, subscriber.remark, subscriber.label_1_visible, subscriber.label_1_x, subscriber.label_1_y, subscriber.label_1_rotation, subscriber.label_1_text, subscriber.label_2_visible, subscriber.label_2_x, subscriber.label_2_y, subscriber.label_2_rotation, subscriber.label_2_text
        # subscriber --- subscriber.id, subscriber.fk_subscriber_type, subscriber.fk_pipe, subscriber.parcel, subscriber.flow_current, subscriber.flow_planned
        # _bwrel_ --- subscriber.samplingpoint__BWREL_id, subscriber.subscriber_reference__BWREL_fk_subscriber, subscriber.meter__BWREL_id, subscriber.pipe__BWREL_fk_node_b, subscriber.pipe__BWREL_fk_node_a
        # _rel_ --- subscriber.fk_pipe__REL, subscriber.fk_subscriber_type__REL, subscriber.fk_object_reference__REL, subscriber.label_1_visible__REL, subscriber.label_2_visible__REL, subscriber.fk_precisionalti__REL, subscriber.fk_folder__REL, subscriber.fk_precision__REL, subscriber.fk_distributor__REL, subscriber.fk_status__REL, subscriber.fk_district__REL, subscriber.fk_pressurezone__REL

        if get_vl(row.fk_subscriber_type__REL) == "Fountain":

            anlage = WASSER.anlage(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **base_common(row, "anlage"),
                # --- leitungsknoten ---
                **leitungsknoten_common(row),
                # --- anlage ---
                name_nummer=str(row.id),
                art="Brunnen",
                material=DOES_NOT_EXIST_IN_QWAT,
                leistung=f"{row.flow_current}",
                betreiber=get_vl(row.fk_distributor__REL, "name"),
                konzessionaer=DOES_NOT_EXIST_IN_QWAT,
                unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
                zustand=get_vl(row.fk_status__REL),
                dimension1=DOES_NOT_EXIST_IN_QWAT,
            )
            wasser_session.add(anlage)
            create_metaattributes(anlage)

            if row.geometry_polygon:
                create_spezialbauwerk(row, "Anlage")

        else:  # incl. row.fk_subscriber_type__REL.value_en == "Subscriber"

            hausanschluss = WASSER.hausanschluss(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **base_common(row, "hausanschluss"),
                # --- leitungsknoten ---
                **leitungsknoten_common(row),
                # --- hausanschluss ---
                art=get_vl(row.fk_subscriber_type__REL),
                dimension=DOES_NOT_EXIST_IN_QWAT,
                gebaeudeanschluss=DOES_NOT_EXIST_IN_QWAT,
                isolierstueck=DOES_NOT_EXIST_IN_QWAT,
                name_nummer=str(row.id),
                standort=DOES_NOT_EXIST_IN_QWAT,
                typ=DOES_NOT_EXIST_IN_QWAT,
                verbrauch=row.flow_current,
                zuordnung_hydraulischer_knoten="undefined",
                zuordnung_hydraulischer_strang="undefined",
                zustand=get_vl(row.fk_status__REL),
            )
            wasser_session.add(hausanschluss)
            create_metaattributes(hausanschluss)

        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.source -> WASSER.wassergewinnungsanlage")
    for row in qwat_session.query(QWAT.source):

        # node --- source.fk_district, source.fk_pressurezone, source.fk_printmap, source._printmaps, source._geometry_alt1_used, source._geometry_alt2_used, source._pipe_node_type, source._pipe_orientation, source._pipe_schema_visible, source.geometry, source.geometry_alt1, source.geometry_alt2, source.update_geometry_alt1, source.update_geometry_alt2
        # network_element --- source.identification, source.fk_distributor, source.fk_status, source.fk_folder, source.fk_locationtype, source.fk_precision, source.fk_precisionalti, source.fk_object_reference, source.altitude, source.year, source.year_end, source.orientation, source.remark, source.label_1_visible, source.label_1_x, source.label_1_y, source.label_1_rotation, source.label_1_text, source.label_2_visible, source.label_2_x, source.label_2_y, source.label_2_rotation, source.label_2_text
        # installation --- source.name, source.fk_parent, source.fk_remote, source.fk_watertype, source.parcel, source.eca, source.open_water_surface, source.geometry_polygon
        # source --- source.id, source.fk_source_type, source.fk_source_quality, source.flow_lowest, source.flow_average, source.flow_concession, source.contract_end, source.gathering_chamber
        # _bwrel_ --- source.samplingpoint__BWREL_id, source.cover__BWREL_fk_installation, source.pressurecontrol_type__BWREL_id, source.meter__BWREL_id, source.pipe__BWREL_fk_node_b, source.pipe__BWREL_fk_node_a, source.installation__BWREL_fk_parent
        # _rel_ --- source.fk_source_quality__REL, source.fk_source_type__REL, source.fk_remote__REL, source.fk_watertype__REL, source.fk_parent__REL, source.fk_object_reference__REL, source.label_1_visible__REL, source.label_2_visible__REL, source.fk_precisionalti__REL, source.fk_folder__REL, source.fk_precision__REL, source.fk_distributor__REL, source.fk_status__REL, source.fk_district__REL, source.fk_pressurezone__REL

        wassergewinnungsanlage = WASSER.wassergewinnungsanlage(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "wassergewinnungsanlage"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- wassergewinnungsanlage ---
            art=get_vl(row.fk_source_type__REL),
            betreiber=get_vl(row.fk_distributor__REL, "name"),
            konzessionaer=DOES_NOT_EXIST_IN_QWAT,
            leistung=str(row.flow_average),
            name_nummer=str(row.id),
            unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(wassergewinnungsanlage)
        create_metaattributes(wassergewinnungsanlage)
        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    logger.info("Exporting QWAT.chamber -> WASSER.anlage")
    for row in qwat_session.query(QWAT.chamber):

        # node --- chamber.fk_district, chamber.fk_pressurezone, chamber.fk_printmap, chamber._printmaps, chamber._geometry_alt1_used, chamber._geometry_alt2_used, chamber._pipe_node_type, chamber._pipe_orientation, chamber._pipe_schema_visible, chamber.geometry, chamber.geometry_alt1, chamber.geometry_alt2, chamber.update_geometry_alt1, chamber.update_geometry_alt2
        # network_element --- chamber.identification, chamber.fk_distributor, chamber.fk_status, chamber.fk_folder, chamber.fk_locationtype, chamber.fk_precision, chamber.fk_precisionalti, chamber.fk_object_reference, chamber.altitude, chamber.year, chamber.year_end, chamber.orientation, chamber.remark, chamber.label_1_visible, chamber.label_1_x, chamber.label_1_y, chamber.label_1_rotation, chamber.label_1_text, chamber.label_2_visible, chamber.label_2_x, chamber.label_2_y, chamber.label_2_rotation, chamber.label_2_text
        # installation --- chamber.name, chamber.fk_parent, chamber.fk_remote, chamber.fk_watertype, chamber.parcel, chamber.eca, chamber.open_water_surface, chamber.geometry_polygon
        # chamber --- chamber.id, chamber.networkseparation, chamber.flow_meter, chamber.water_meter, chamber.manometer, chamber.depth, chamber.no_valves
        # _bwrel_ --- chamber.samplingpoint__BWREL_id, chamber.pipe__BWREL_fk_node_b, chamber.pipe__BWREL_fk_node_a, chamber.cover__BWREL_fk_installation, chamber.pressurecontrol_type__BWREL_id, chamber.meter__BWREL_id, chamber.installation__BWREL_fk_parent
        # _rel_ --- chamber.fk_watertype__REL, chamber.fk_remote__REL, chamber.fk_parent__REL, chamber.fk_distributor__REL, chamber.fk_status__REL, chamber.label_1_visible__REL, chamber.fk_precision__REL, chamber.fk_object_reference__REL, chamber.label_2_visible__REL, chamber.fk_folder__REL, chamber.fk_precisionalti__REL, chamber.fk_district__REL, chamber.fk_pressurezone__REL

        anlage = WASSER.anlage(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "anlage"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- anlage ---
            name_nummer=str(row.id),
            art="Schacht.Zonentrennung" if row.networkseparation else "Schacht.unbekannt",
            material=DOES_NOT_EXIST_IN_QWAT,
            leistung=DOES_NOT_EXIST_IN_QWAT,
            betreiber=get_vl(row.fk_distributor__REL, "name"),
            konzessionaer=DOES_NOT_EXIST_IN_QWAT,
            unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
            zustand=get_vl(row.fk_status__REL),
            dimension1=DOES_NOT_EXIST_IN_QWAT,
        )
        wasser_session.add(anlage)
        create_metaattributes(anlage)

        if row.geometry_polygon:
            create_spezialbauwerk(row, "Anlage")

        print(".", end="")
    logger.info("done")

    logger.info("Exporting QWAT.pressurecontrol -> WASSER.anlage")
    for row in qwat_session.query(QWAT.pressurecontrol):

        # node --- pressurecontrol.fk_district, pressurecontrol.fk_pressurezone, pressurecontrol.fk_printmap, pressurecontrol._printmaps, pressurecontrol._geometry_alt1_used, pressurecontrol._geometry_alt2_used, pressurecontrol._pipe_node_type, pressurecontrol._pipe_orientation, pressurecontrol._pipe_schema_visible, pressurecontrol.geometry, pressurecontrol.geometry_alt1, pressurecontrol.geometry_alt2, pressurecontrol.update_geometry_alt1, pressurecontrol.update_geometry_alt2
        # network_element --- pressurecontrol.identification, pressurecontrol.fk_distributor, pressurecontrol.fk_status, pressurecontrol.fk_folder, pressurecontrol.fk_locationtype, pressurecontrol.fk_precision, pressurecontrol.fk_precisionalti, pressurecontrol.fk_object_reference, pressurecontrol.altitude, pressurecontrol.year, pressurecontrol.year_end, pressurecontrol.orientation, pressurecontrol.remark, pressurecontrol.label_1_visible, pressurecontrol.label_1_x, pressurecontrol.label_1_y, pressurecontrol.label_1_rotation, pressurecontrol.label_1_text, pressurecontrol.label_2_visible, pressurecontrol.label_2_x, pressurecontrol.label_2_y, pressurecontrol.label_2_rotation, pressurecontrol.label_2_text
        # installation --- pressurecontrol.name, pressurecontrol.fk_parent, pressurecontrol.fk_remote, pressurecontrol.fk_watertype, pressurecontrol.parcel, pressurecontrol.eca, pressurecontrol.open_water_surface, pressurecontrol.geometry_polygon
        # pressurecontrol --- pressurecontrol.id, pressurecontrol.fk_pressurecontrol_type
        # _bwrel_ --- pressurecontrol.samplingpoint__BWREL_id, pressurecontrol.pipe__BWREL_fk_node_b, pressurecontrol.pipe__BWREL_fk_node_a, pressurecontrol.cover__BWREL_fk_installation, pressurecontrol.pressurecontrol_type__BWREL_id, pressurecontrol.meter__BWREL_id, pressurecontrol.installation__BWREL_fk_parent
        # _rel_ --- pressurecontrol.fk_pressurecontrol_type__REL, pressurecontrol.fk_watertype__REL, pressurecontrol.fk_remote__REL, pressurecontrol.fk_parent__REL, pressurecontrol.fk_distributor__REL, pressurecontrol.fk_status__REL, pressurecontrol.label_1_visible__REL, pressurecontrol.fk_precision__REL, pressurecontrol.fk_object_reference__REL, pressurecontrol.label_2_visible__REL, pressurecontrol.fk_folder__REL, pressurecontrol.fk_precisionalti__REL, pressurecontrol.fk_district__REL, pressurecontrol.fk_pressurezone__REL

        anlage = WASSER.anlage(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "anlage"),
            # --- leitungsknoten ---
            **leitungsknoten_common(row),
            # --- anlage ---
            name_nummer=str(row.id),
            art=get_vl(row.fk_pressurecontrol_type__REL),
            material=DOES_NOT_EXIST_IN_QWAT,
            leistung=DOES_NOT_EXIST_IN_QWAT,
            betreiber=get_vl(row.fk_distributor__REL, "name"),
            konzessionaer=DOES_NOT_EXIST_IN_QWAT,
            unterhaltspflichtiger=DOES_NOT_EXIST_IN_QWAT,
            zustand=get_vl(row.fk_status__REL),
            dimension1=DOES_NOT_EXIST_IN_QWAT,
        )
        wasser_session.add(anlage)
        create_metaattributes(anlage)
        print(".", end="")
    logger.info("done")

    logger.info("Exporting QWAT.valve -> WASSER.absperrorgan")
    for row in qwat_session.query(QWAT.valve):
        """
        Valves are reprsented on the pipes in QWAT, and as nodes in SIA405.
        We create the required hydraulischer_knoten on the fly. Not done yet:
        splitting the pipes at nodes. To do that, we probably should do this
        as a post-import processing step.
        """

        # valve --- valve.id, valve.fk_valve_type, valve.fk_valve_function, valve.fk_valve_actuation, valve.fk_pipe, valve.fk_handle_precision, valve.fk_handle_precisionalti, valve.fk_maintenance, valve.closed, valve.networkseparation, valve.handle_altitude, valve.handle_geometry, valve.fk_district, valve.fk_pressurezone, valve.fk_distributor, valve.fk_precision, valve.fk_precisionalti, valve.fk_status, valve.fk_object_reference, valve.fk_folder, valve.year, valve.year_end, valve.altitude, valve.orientation, valve.fk_locationtype, valve.identification, valve.remark, valve.fk_printmap, valve._geometry_alt1_used, valve._geometry_alt2_used, valve._pipe_node_type, valve._pipe_orientation, valve._pipe_schema_visible, valve._printmaps, valve.geometry, valve.geometry_alt1, valve.geometry_alt2, valve.update_geometry_alt1, valve.update_geometry_alt2, valve.label_1_visible, valve.label_1_x, valve.label_1_y, valve.label_1_rotation, valve.label_1_text, valve.label_2_visible, valve.label_2_x, valve.label_2_y, valve.label_2_rotation, valve.label_2_text, valve.schema_force_visible, valve._schema_visible, valve.fk_nominal_diameter
        # _rel_ --- valve.label_2_visible__REL, valve.fk_precisionalti__REL, valve.fk_valve_function__REL, valve.fk_valve_actuation__REL, valve.fk_valve_type__REL, valve.fk_district__REL, valve.fk_nominal_diameter__REL, valve.fk_object_reference__REL, valve.fk_pipe__REL, valve.fk_precision__REL, valve.label_1_visible__REL, valve.fk_folder__REL, valve.fk_handle_precision__REL, valve.fk_pressurezone__REL, valve.fk_handle_precisionalti__REL, valve.fk_distributor__REL, valve.fk_status__REL, valve.schema_force_visible__REL

        if include_hydraulics:
            # We add an intermediate node to split the pipe
            hydraulischer_knoten = WASSER.hydraulischer_knoten(
                # --- baseclass ---
                # --- sia405_baseclass ---
                **base_common(row, "hydraulischer_knoten", tid_for_class=QWAT.valve),
                # --- hydraulischer_knoten ---
                bemerkung=truncate(sanitize_str(row.remark), 80),
                druck=DOES_NOT_EXIST_IN_QWAT,
                geometrie=sanitize_geom(row.geometry),
                knotentyp="Normalknoten",
                name_nummer=str(row.id),
                verbrauch=DOES_NOT_EXIST_IN_QWAT,
            )
            wasser_session.add(hydraulischer_knoten)
            create_metaattributes(hydraulischer_knoten)

        absperrorgan = WASSER.absperrorgan(
            # --- baseclass ---
            # --- sia405_baseclass ---
            **base_common(row, "absperrorgan"),
            # --- leitungsknoten ---
            bemerkung=truncate(sanitize_str(row.remark), 80),
            druckzone=DOES_NOT_EXIST_IN_QWAT,
            eigentuemer=DOES_NOT_EXIST_IN_QWAT,
            einbaujahr=clamp(row.year, min_val=1800, max_val=2100, accept_none=True),
            geometrie=sanitize_geom(row.geometry),
            hoehe=ST_Z(row.geometry),
            hoehenbestimmung=get_vl(row.fk_precisionalti__REL),
            knotenref__REL=None if not include_hydraulics else hydraulischer_knoten,
            lagebestimmung=get_vl(row.fk_precision__REL),
            symbolori=0,
            # --- absperrorgan ---
            art=get_vl(row.fk_valve_type__REL),
            hersteller=DOES_NOT_EXIST_IN_QWAT,
            material=DOES_NOT_EXIST_IN_QWAT,
            name_nummer=str(row.id),
            nennweite=truncate(get_vl(row.fk_nominal_diameter__REL), 10),
            schaltantrieb={
                6403: "motorisch.ohne_Fernsteuerung",
                6406: "motorisch.mit_Fernsteuerung",
            }.get(get_vl(row.fk_valve_actuation__REL, "id"), "keiner"),
            schaltzustand="unbekannt" if row.closed is None else ("geschlossen" if row.closed else "offen"),
            schliessrichtung="links" if get_vl(row.fk_valve_actuation__REL, "id") == 6402 else "rechts",
            typ=DOES_NOT_EXIST_IN_QWAT,
            zulaessiger_bauteil_betriebsdruck=DOES_NOT_EXIST_IN_QWAT,
            zustand=get_vl(row.fk_status__REL),
        )
        wasser_session.add(absperrorgan)
        create_metaattributes(absperrorgan)

        if row.fk_pipe__REL is None:
            # If there's no related pipe, we keep the valve as a standalone
            print(".", end="")
            continue
        # Otherwise, we split the pipe at the valve.

        # Get the related pipe
        leitung_a = wasser_session.query(WASSER.leitung).get(get_tid(row.fk_pipe__REL, for_class=WASSER.leitung))

        # We clone the pipe
        leitung_b = utils.sqlalchemy.copy_instance(leitung_a)
        leitung_b.t_id = get_tid(row, for_class=WASSER.leitung)
        leitung_b.obj_id = tid2oid(leitung_b.t_id)
        leitung_b.t_ili_tid = leitung_b.obj_id

        # We split the geometry
        logger.warning(
            f"Pipe will be split at valve to accomodate SIA405's representation. However, split will occur at the middle of the pipe, not taking into account the actual valve's position"
        )
        # TODO the geometry of the new node does not necessarily lie in the middle (nor on the segment)
        leitung_a.geometrie = ST_ForceCurve(
            sanitize_geom(ST_LineSubstring(ST_CurveToLine(leitung_a.geometrie), 0, 0.5))
        )
        leitung_b.geometrie = ST_ForceCurve(
            sanitize_geom(ST_LineSubstring(ST_CurveToLine(leitung_b.geometrie), 0.5, 1))
        )

        # And add the new pipe to the session
        wasser_session.add(leitung_b)
        create_metaattributes(leitung_b)

        if include_hydraulics:
            strang_a = wasser_session.query(WASSER.hydraulischer_strang).get(
                get_tid(row.fk_pipe__REL, for_class=WASSER.hydraulischer_strang)
            )

        # We do the same for hydraulics
        if include_hydraulics:
            strang_b = utils.sqlalchemy.copy_instance(strang_a)
            strang_b.t_id = get_tid(row, for_class=WASSER.hydraulischer_strang)
            strang_b.obj_id = tid2oid(strang_b.t_id)
            strang_b.t_ili_tid = strang_b.obj_id
            leitung_b.strangref__REL = strang_b

            # We connect to the midpoint
            strang_a.bisknotenref__REL = hydraulischer_knoten
            strang_b.vonknotenref__REL = hydraulischer_knoten

            # And add the new pipe to the session
            wasser_session.add(strang_b)
            create_metaattributes(strang_b)

        print(".", end="")
    logger.info("done")
    wasser_session.flush()

    wasser_session.commit()
    wasser_session.close()
    qwat_session.close()
