import logging

import sqlalchemy
from sqlalchemy import inspect
from sqlalchemy.ext.automap import generate_relationship
from sqlalchemy.orm import ColumnProperty

from ...utils.database_utils import DatabaseUtils


def create_engine(logger_name=None):
    logging_args = {}
    if logger_name:
        handler = logging.FileHandler(f"tww_export.{logger_name}.log", mode="w")
        handler.setLevel(logging.DEBUG)
        logging.getLogger(f"sqlalchemy.engine.base.Engine.{logger_name}").addHandler(handler)
        logging_args = {"logging_name": logger_name, "echo": True}

    pgconf = DatabaseUtils.get_pgconf()

    return sqlalchemy.create_engine(
        f"postgresql://{pgconf['user']}:{pgconf['password']}@{pgconf['host']}:{pgconf['port']}/{pgconf['dbname']}",
        **logging_args,
    )


def custom_name_for_collection_relationship(base, local_cls, referred_cls, constraint):
    # This customizes the name for backwards relation (uses the class name and it's fk column name), avoiding clashes for inherited classes.
    # See https://stackoverflow.com/a/48288656/13690651
    return f"{referred_cls.__name__}__BWREL_{constraint.columns.keys()[0]}"


def custom_name_for_scalar_relationship(base, local_cls, referred_cls, constraint):
    # This customizes the name for backwards relation (uses the fk column name), avoiding clashes for inherited classes.
    # See https://stackoverflow.com/a/48288656/13690651
    return f"{constraint.columns.keys()[0]}__REL"


def custom_generate_relationship(
    base, direction, return_fn, attrname, local_cls, referred_cls, **kw
):
    """
    Skips creating backwards relations to avoid adding instances twice with session.merge
    """
    # disabling type checks on all relations, allowing to flush subclasses instead of abstract classes in relations
    # without requiring to configure polymorphism
    kw["enable_typechecks"] = False

    # accept circular-dependencies (e.g. organisation.dataowner can be itself)
    # see https://docs.sqlalchemy.org/en/20/orm/relationship_persistence.html#rows-that-point-to-themselves-mutually-dependent-rows)
    if attrname in ["fk_dataowner__REL", "fk_provider__REL"]:
        kw["post_update"] = True

    return generate_relationship(
        base, direction, return_fn, attrname, local_cls, referred_cls, **kw
    )


def prepare_automap_base(base, schema):
    """
    Prepares the automap base by reflecting all the fields with some specific configuration for relationship and population Base.classes with manually defined classes (which for some reason isn't done by default)
    """

    # DOESN'T WORK, BUT CACHING WOULD BE GOOD
    # pickle_file = f'{__file__}.pickled'
    # reflect = True
    # if os.path.exists(pickle_file):
    #     with open(pickle_file, 'rb') as f:
    #         reflect = False
    #         base.metadata = pickle.load(f)

    base.prepare(
        create_engine(),
        reflect=True,
        schema=schema,
        name_for_collection_relationship=custom_name_for_collection_relationship,
        name_for_scalar_relationship=custom_name_for_scalar_relationship,
        generate_relationship=custom_generate_relationship,
    )

    # For some reason, automap_base doesn't add manually defined classes to Base.classes,
    # so we do it manually here
    def add_subclasses(Parent):
        for subclass in Parent.__subclasses__():
            if subclass.__name__ not in base.classes:
                base.classes[subclass.__name__] = subclass
            add_subclasses(subclass)

    add_subclasses(base)

    # DOESN'T WORK, BUT CACHING WOULD BE GOOD
    # with open(pickle_file, 'wb') as f:
    #     pickle.dump(base.metadata, f)


def copy_instance(instance):
    """
    Creates a copy of an SQLAchely ORM instance. Dont forget to change (or nullify) the primary key.
    """
    klass = instance.__class__
    mapper = inspect(klass)
    new_instance = klass()
    for attr in mapper.attrs:
        if isinstance(attr, ColumnProperty):
            setattr(new_instance, attr.key, getattr(instance, attr.key))
    return new_instance
