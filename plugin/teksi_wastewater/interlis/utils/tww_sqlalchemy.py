from __future__ import annotations

import logging
import warnings

import sqlalchemy
from sqlalchemy import ForeignKeyConstraint, inspect
from sqlalchemy.exc import SAWarning
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


def prepare_automap_base(
    base,
    schema,
    inheritance_key: str | None = None,
):
    """
    Reflect and prepare one schema-scoped automap base.

    When ``inheritance_key`` is provided, missing joined-table inheritance
    constraints are added to SQLAlchemy metadata after reflection and before
    mapper configuration.

    The synthetic constraints exist only in local SQLAlchemy metadata. The
    PostgreSQL schema is not modified.

    Classes declared manually before reflection are added to ``Base.classes``
    after automap preparation.
    """

    engine = create_engine()

    base.metadata.reflect(
        bind=engine,
        schema=schema,
        extend_existing=True,
        autoload_replace=True,
    )

    if inheritance_key is not None:
        _add_missing_inheritance_constraints(
            base=base,
            schema=schema,
            inheritance_key=inheritance_key,
        )

    with warnings.catch_warnings():
        warnings.filterwarnings(
            "ignore",
            message=(
                r"Implicitly combining column .*\.t_basket "
                r"with column .*\.t_basket under attribute "
                r"'t_basket'.*"
            ),
            category=SAWarning,
        )

        base.prepare(
            name_for_collection_relationship=(custom_name_for_collection_relationship),
            name_for_scalar_relationship=(custom_name_for_scalar_relationship),
            generate_relationship=(custom_generate_relationship),
        )

    _add_declared_classes(
        base,
    )


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


def _add_missing_inheritance_constraints(
    *,
    base,
    schema: str,
    inheritance_key: str,
) -> None:
    """
    Add missing joined-inheritance constraints to reflected metadata.

    A constraint is considered only when a declared class inherits from
    another declared class that has its own table. Classes inheriting directly
    from the automap base are root classes or independent association classes
    and are ignored.
    """

    visited: set[type,] = set()

    def visit_subclasses(
        parent_class: type,
    ) -> None:
        for child_class in parent_class.__subclasses__():
            if child_class in visited:
                continue

            visited.add(
                child_class,
            )

            if parent_class is not base:
                _add_inheritance_constraint(
                    schema=schema,
                    parent_class=parent_class,
                    child_class=child_class,
                    inheritance_key=inheritance_key,
                )

            visit_subclasses(
                child_class,
            )

    visit_subclasses(
        base,
    )


def _add_inheritance_constraint(
    *,
    schema: str,
    parent_class: type,
    child_class: type,
    inheritance_key: str,
) -> None:
    """
    Add one metadata-only foreign key for joined-table inheritance.
    """

    parent_table = getattr(
        parent_class,
        "__table__",
        None,
    )

    child_table = getattr(
        child_class,
        "__table__",
        None,
    )

    if parent_table is None or child_table is None or parent_table is child_table:
        return

    if parent_table.schema != schema or child_table.schema != schema:
        return

    if inheritance_key not in parent_table.c:
        raise RuntimeError(
            "Cannot configure ORM inheritance from "
            f"{parent_table.fullname!r} to "
            f"{child_table.fullname!r}: parent table does "
            f"not contain inheritance key "
            f"{inheritance_key!r}."
        )

    if inheritance_key not in child_table.c:
        raise RuntimeError(
            "Cannot configure ORM inheritance from "
            f"{parent_table.fullname!r} to "
            f"{child_table.fullname!r}: child table does "
            f"not contain inheritance key "
            f"{inheritance_key!r}."
        )

    child_column = child_table.c[inheritance_key]

    target_fullname = f"{parent_table.schema}." f"{parent_table.name}." f"{inheritance_key}"

    if any(
        foreign_key.target_fullname == target_fullname for foreign_key in child_column.foreign_keys
    ):
        return

    child_table.append_constraint(
        ForeignKeyConstraint(
            [
                inheritance_key,
            ],
            [
                target_fullname,
            ],
            name=("orm_inheritance_" f"{child_table.name}_" f"{parent_table.name}"),
        )
    )


def _add_declared_classes(
    base,
) -> None:
    """
    Add manually declared classes to the automap class collection.
    """

    visited: set[type,] = set()

    def add_subclasses(
        parent_class: type,
    ) -> None:
        for subclass in parent_class.__subclasses__():
            if subclass in visited:
                continue

            visited.add(
                subclass,
            )

            if subclass.__name__ not in base.classes:
                base.classes[subclass.__name__] = subclass

            add_subclasses(
                subclass,
            )

    add_subclasses(
        base,
    )
