import collections

from geoalchemy2 import (  # imports needed to avoid type unrecognized error
    Geography,
    Geometry,
)
from sqlalchemy import Column, ForeignKey, Integer, MetaData, String, create_engine
from sqlalchemy.ext.automap import automap_base, name_for_collection_relationship
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Session

# Mock engine that dumps strings instead of executing
# def mock_execute(sql, *multiparams, **params):
#     print(sql.compile(dialect=engine.dialect))
# engine = create_engine('postgresql://postgres:postgres@127.0.0.1:5432/qgep_prod', strategy='mock', executor=mock_execute)
engine = create_engine("postgresql://postgres:postgres@127.0.0.1:5432/qgep_prod")


######################################################################
# Example 0 : ORM 101
######################################################################


def example_0():

    Base = declarative_base()

    class Animal(Base):
        __tablename__ = "animal"
        id = Column(Integer, primary_key=True)
        name = Column(String(255), nullable=False)

    class Cat(Animal):
        __tablename__ = "cat"
        id = Column(ForeignKey(Animal.id), primary_key=True)
        mice_eaten = Column(Integer, nullable=True)

    class Dog(Animal):
        __tablename__ = "dog"
        id = Column(ForeignKey(Animal.id), primary_key=True)
        cars_chased = Column(Integer, nullable=True)

    Base.metadata.create_all(engine)


######################################################################
# Example 1 : ORM from database
######################################################################


def example_1():

    meta = MetaData()
    meta.reflect(bind=engine, schema="qgep_od")

    TableManhole = meta.tables["qgep_od.manhole"]

    select_query = TableManhole.select()
    print(select_query)

    insert_query = TableManhole.insert().values(dimension1=22)
    print(insert_query)


######################################################################
# Actual application : export from QGEP (datamodel) to Interlis (similar but different datamodel)
######################################################################

MAPPING = {
    "wastewater_structure": {
        "accessibility": {
            None: None,
            3444: "ueberdeckt",
            3447: "unbekannt",
            3446: "unzugaenglich",
            3445: "zugaenglich",
        }
    },
    "manhole": {
        "function": {
            None: None,
            4532: "Absturzbauwerk",
            5344: "andere",
            4533: "Be_Entlueftung",
            3267: "Dachwasserschacht",
            3266: "Einlaufschacht",
            3472: "Entwaesserungsrinne",
            228: "Geleiseschacht",
            204: "Kontrollschacht",
            1008: "Oelabscheider",
            4536: "Pumpwerk",
            5346: "Regenueberlauf",
            2742: "Schlammsammler",
            5347: "Schwimmstoffabscheider",
            4537: "Spuelschacht",
            4798: "Trennbauwerk",
            5345: "unbekannt",
        },
    },
}

######################################################################
# Approach A : Plain autoloading (doesn't load inheritance)
# then insert export each table separately, from base to specific
# matching Stefan's script logic
# PROS : simple to grasp, probably exportable as plain SQLs
# CON : verbose, hard to do correct partial exports
######################################################################


def export_a():

    # Autoload QGEP datamodel
    QGEPBase = automap_base()
    QGEPBase.prepare(engine, reflect=True, schema="qgep_od")

    # Autoload Interlis datamodel
    SIABase = automap_base()
    SIABase.prepare(engine, reflect=True, schema="vsa_dss_2015_2_d")

    # Shortcuts
    QGEP = QGEPBase.classes
    SIA = SIABase.classes

    # Autoincrementing ID
    oid2tid = collections.defaultdict(lambda: len(oid2tid))

    # Actual insert routing
    session = Session(engine)

    print("Exporting wastewater_networkelement -> baseclass")
    for row in session.query(QGEP.wastewater_networkelement):
        session.add(
            SIA.baseclass(
                t_id=oid2tid[row.obj_id],
                t_type="abwassernetzelement",  # this will be replaced by correct subclass below
                t_ili_tid=row.obj_id,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting wastewater_networkelement -> sia405_baseclass")
    for row in session.query(QGEP.wastewater_networkelement):
        session.add(
            SIA.sia405_baseclass(
                t_id=oid2tid[row.obj_id],
                obj_id=row.obj_id,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting wastewater_networkelement -> abwassernetzelement")
    for row in session.query(QGEP.wastewater_networkelement):
        session.add(
            SIA.abwassernetzelement(
                t_id=oid2tid[row.obj_id],
                bezeichnung=row.identifier,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting wastewater_structure -> baseclass")
    for row in session.query(QGEP.wastewater_structure):
        session.add(
            SIA.baseclass(
                t_id=oid2tid[row.obj_id],
                t_type="abwasserbauwerk",  # this will be replaced by correct subclass below
                t_ili_tid=row.obj_id,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting wastewater_structure -> sia405_baseclass")
    for row in session.query(QGEP.wastewater_structure):
        session.add(
            SIA.sia405_baseclass(
                t_id=oid2tid[row.obj_id],
                obj_id=row.obj_id,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting wastewater_structure -> abwasserbauwerk")
    for row in session.query(QGEP.wastewater_structure):
        session.add(
            SIA.abwasserbauwerk(
                t_id=oid2tid[row.obj_id],
                zugaenglichkeit=MAPPING["wastewater_structure"]["accessibility"][row.accessibility],
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting manhole -> normschacht")
    for row in session.query(QGEP.manhole):
        session.add(
            SIA.normschacht(
                t_id=oid2tid[row.obj_id],
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                funktion=MAPPING["manhole"]["function"][row.function],
            )
        )
        print(".", end="")
    print("done !")

    print("Updating  manhole -> normschacht")
    normschacht_subquery = session.query(SIA.normschacht.t_id)
    session.query(SIA.baseclass).filter(SIA.baseclass.t_id.in_(normschacht_subquery)).update(
        {SIA.baseclass.t_type: "normschacht"}, synchronize_session=False
    )
    print("done !")

    session.commit()


######################################################################
# Approach B : Plain autoloading (doesn't load inheritance)
# then insert from a joined query, base and specific at once
# PRO : compared to A, easier to do partial export
# CONS : not as easy to read, not possible to export as plain SQL
######################################################################


def export_b():

    # Autoload QGEP datamodel
    QGEPBase = automap_base()
    QGEPBase.prepare(engine, reflect=True, schema="qgep_od")

    # Autoload Interlis datamodel
    SIABase = automap_base()
    SIABase.prepare(engine, reflect=True, schema="vsa_dss_2015_2_d")

    # Shortcuts
    QGEP = QGEPBase.classes
    SIA = SIABase.classes

    # Autoincrementing ID
    oid2tid = collections.defaultdict(lambda: len(oid2tid))

    # Actual insert routing
    session = Session(engine)

    print("Exporting manhole -> normschacht")
    joined_query = (
        session.query(QGEP.manhole, QGEP.wastewater_structure, QGEP.wastewater_networkelement)
        .filter(QGEP.manhole.obj_id == QGEP.wastewater_structure.obj_id)
        .filter(QGEP.wastewater_structure.obj_id == QGEP.wastewater_networkelement.fk_wastewater_structure)
    )
    for row in joined_query:

        # wastewater_networkelement -> baseclass
        session.add(
            SIA.baseclass(
                t_id=oid2tid[row.wastewater_networkelement.obj_id],
                t_type="abwassernetzelement",
                t_ili_tid=row.wastewater_networkelement.obj_id,
            )
        )

        # wastewater_networkelement -> sia405_baseclass
        session.add(
            SIA.sia405_baseclass(
                t_id=oid2tid[row.wastewater_networkelement.obj_id],
                obj_id=row.wastewater_networkelement.obj_id,
            )
        )

        # wastewater_networkelement -> abwassernetzelement
        session.add(
            SIA.abwassernetzelement(
                t_id=oid2tid[row.wastewater_networkelement.obj_id],
                bezeichnung=row.wastewater_networkelement.identifier,
            )
        )

        # manhole -> baseclass
        session.add(
            SIA.baseclass(
                t_id=oid2tid[row.manhole.obj_id],
                t_type="normschacht",
                t_ili_tid=row.manhole.obj_id,
            )
        )

        # manhole -> sia405_baseclass
        session.add(
            SIA.sia405_baseclass(
                t_id=oid2tid[row.manhole.obj_id],
                obj_id=row.manhole.obj_id,
            )
        )

        # wastewater_structure -> abwasserbauwerk
        session.add(
            SIA.abwasserbauwerk(
                t_id=oid2tid[row.wastewater_structure.obj_id],
                zugaenglichkeit=MAPPING["wastewater_structure"]["accessibility"][
                    row.wastewater_structure.accessibility
                ],
            )
        )

        # manhole -> normschacht
        session.add(
            SIA.normschacht(
                t_id=oid2tid[row.manhole.obj_id],
                dimension1=row.manhole.dimension1,
                dimension2=row.manhole.dimension2,
                funktion=MAPPING["manhole"]["function"][row.manhole.function],
            )
        )
        print(".", end="")

    print("done !")

    session.commit()


######################################################################
# Approach C : Hybrid autoloading (maps inheritance)
# then insert using inheritance !
# PROS : conceptually clean, easy to read in python
# CON : probably not easily possible to export as plain SQL script, means we nede to depend on sqlalchemy
######################################################################


def export_c():
    def custom_name_for_collection_relationship(base, local_cls, referred_cls, constraint):
        # This customizes the name for backwards relation, avoiding clashes for inherited classes.
        # See https://stackoverflow.com/a/48288656/13690651
        if constraint.name:
            return "REF_" + constraint.name.lower()
        # if this didn't work, revert to the default behavior
        return "REF_" + name_for_collection_relationship(base, local_cls, referred_cls, constraint)

    # Define QGEP datamodel
    QGEPBase = automap_base()

    class QGEPWastewaterNetworkelement(QGEPBase):
        __tablename__ = "wastewater_networkelement"
        __table_args__ = {"schema": "qgep_od"}

    class QGEPWastewaterStructure(QGEPBase):
        __tablename__ = "wastewater_structure"
        __table_args__ = {"schema": "qgep_od"}

    class QGEPManhole(QGEPWastewaterStructure):
        __tablename__ = "manhole"
        __table_args__ = {"schema": "qgep_od"}

    QGEPBase.prepare(
        engine,
        reflect=True,
        schema="qgep_od",
        name_for_collection_relationship=custom_name_for_collection_relationship,
    )

    # Define Interlis datamodel
    SIABase = automap_base()

    class SIABaseClass(SIABase):
        __tablename__ = "baseclass"
        __table_args__ = {"schema": "vsa_dss_2015_2_d"}

    class SIASia405BaseClass(SIABaseClass):
        __tablename__ = "sia405_baseclass"
        __table_args__ = {"schema": "vsa_dss_2015_2_d"}

    class SIAAbwassernetzelement(SIASia405BaseClass):
        __tablename__ = "abwassernetzelement"
        __table_args__ = {"schema": "vsa_dss_2015_2_d"}

    class SIAAbwasserbauwerk(SIASia405BaseClass):
        __tablename__ = "abwasserbauwerk"
        __table_args__ = {"schema": "vsa_dss_2015_2_d"}

    class SIANormschacht(SIAAbwasserbauwerk):
        __tablename__ = "normschacht"
        __table_args__ = {"schema": "vsa_dss_2015_2_d"}

    SIABase.prepare(
        engine,
        reflect=True,
        schema="vsa_dss_2015_2_d",
        name_for_collection_relationship=custom_name_for_collection_relationship,
    )

    # Autoincrementing ID
    oid2tid = collections.defaultdict(lambda: len(oid2tid))

    # Actual insert routing
    session = Session(engine)

    print("Exporting wastewaternetworkelement -> abwassernetzelement")
    for row in session.query(QGEPWastewaterNetworkelement):
        session.add(
            SIAAbwassernetzelement(
                t_id=oid2tid[row.obj_id],
                t_type="abwassernetzelement",
                t_ili_tid=row.obj_id,
                obj_id=row.obj_id,
                bezeichnung=row.identifier,
            )
        )
        print(".", end="")
    print("done !")

    print("Exporting manhole -> normschacht")
    for row in session.query(QGEPManhole):
        session.add(
            SIANormschacht(
                t_id=oid2tid[row.obj_id],
                t_type="normschacht",
                t_ili_tid=row.obj_id,
                obj_id=row.obj_id,
                zugaenglichkeit=MAPPING["wastewater_structure"]["accessibility"][row.accessibility],
                dimension1=row.dimension1,
                dimension2=row.dimension2,
                funktion=MAPPING["manhole"]["function"][row.function],
            )
        )
        print(".", end="")
    print("done !")

    session.commit()


export_c()
