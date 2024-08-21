#!/usr/bin/env python3

import re
from argparse import (
    ArgumentDefaultsHelpFormatter,
    ArgumentParser,
    BooleanOptionalAction,
)
from typing import Optional

from pgserviceparser import service_config

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def get_db_identifier(pg_service: str, modulename: str):
    """
    Returns the db identifier for database specific roles
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    """
    dbname = service_config(pg_service).get("dbname")
    db_identifier = re.sub(f"{modulename}_|teksi_", "", dbname)
    return db_identifier


def create_roles(pg_service: str, modulename: str, db_spec_roles: Optional[bool] = False):
    """
    Creates the roles for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    :param db_spec_roles: will create database specific roles instead of cluster specific roles
    """
    roles, child_roles = get_roles(pg_service, modulename, db_spec_roles)

    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    for key in roles:
        cur.execute(f"SELECT 1 FROM pg_roles WHERE rolname='{roles[key]}'")
        role_exists = cur.fetchone()
        if not role_exists:
            role_sql = f"""
                CREATE ROLE {roles[key]} NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
            """
            print(f"created role {roles[key]}")
            cur.execute(role_sql)
            cur.execute(f"SELECT 1 FROM pg_roles WHERE rolname='{child_roles[key]}'")
            child_role_exists = cur.fetchone()
            if child_role_exists:
                child_role_sql = f"""
                    GRANT {child_roles[key]} TO {roles[key]};
                """
                cur.execute(child_role_sql)
                print(f"granted {child_roles[key]} to role {roles[key]}")
    conn.commit()
    conn.close()


def get_roles(pg_service: str, modulename: str, db_spec_roles: Optional[bool] = False):
    """
    returns a dict of role names and their children for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    :param db_spec_roles: will create database specific roles instead of cluster specific roles
    """
    if db_spec_roles:
        db_identifier = "_" + get_db_identifier(pg_service, modulename)
    else:
        db_identifier = ""

    roles = {
        "viewer": f"{modulename}_viewer{db_identifier}",
        "user": f"{modulename}_user{db_identifier}",
        "manager": f"{modulename}_manager{db_identifier}",
        "sysadmin": f"{modulename}_sysadmin{db_identifier}",
    }
    child_roles = {
        "viewer": None,
        "user": f"{modulename}_viewer{db_identifier}",
        "manager": f"{modulename}_user{db_identifier}",
        "sysadmin": f"{modulename}_manager{db_identifier}",
    }
    return roles, child_roles


def grant_privileges(
    pg_service: str, modulename: str, db_spec_roles: Optional[bool] = False, ext_schema: str = None
):
    """
    Grants the rights from the roles for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    :param db_spec_roles: will create database specific roles instead of cluster specific roles
    :param ext_schema: Schema name of the extension model schema (optional)
    """
    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    roles, _ = get_roles(pg_service, modulename, db_spec_roles)
    schema_defs = {
        f"{modulename}_od": roles["user"],
        f"{modulename}_app": roles["user"],
        f"{modulename}_sys": roles["sysadmin"],
        f"{modulename}_vl": roles["manager"],
        f"{modulename}_cfg": roles["manager"],
    }
    if ext_schema:
        schema_defs[ext_schema] = roles["user"]
    for key in roles:
        cur.execute(f"SELECT 1 FROM pg_roles WHERE rolname='{roles[key]}'")
        role_exists = cur.fetchone()
        if not role_exists:
            raise Exception(f"{roles[key]} not found on database")
    grant_sql = f"""
        GRANT CREATE ON DATABASE {conn.info.dbname} TO "{roles['user']}";  -- required for ili2pg imports/exports
    """
    for key in schema_defs:
        grant_sql = """

        """.join(
            grant_sql,
            f"""
            GRANT USAGE ON SCHEMA {key}  TO {roles['viewer']};
            GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {key}  TO {roles['viewer']};
            GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {key}  TO {roles['viewer']};
            ALTER DEFAULT PRIVILEGES IN SCHEMA {key} GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles['viewer']};

            GRANT ALL ON SCHEMA {key} TO {schema_defs[key]};
            GRANT ALL ON ALL TABLES IN SCHEMA {key} TO {schema_defs[key]};
            GRANT ALL ON ALL SEQUENCES IN SCHEMA {key} TO {schema_defs[key]};
            ALTER DEFAULT PRIVILEGES IN SCHEMA {key} GRANT ALL ON TABLES TO {schema_defs[key]};
            """,
        )
    cur.execute(grant_sql)
    conn.commit()
    conn.close()


def revoke_privileges(
    pg_service: str, modulename: str, db_spec_roles: Optional[bool] = False, ext_schema: str = None
):
    """
    Revokes the rights from the roles for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    :param roles: Dict defining the names of the roles
    :param ext_schema: Schema name of the extension model schema (optional)
    """
    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    schemanames = [
        f"{modulename}_od",
        f"{modulename}_app",
        f"{modulename}_sys",
        f"{modulename}_vl",
        f"{modulename}_cfg",
    ]
    if ext_schema:
        schemanames.append(ext_schema)
    roles, _ = get_roles(pg_service, modulename, db_spec_roles)
    cur.execute(f"SELECT 1 FROM pg_roles WHERE rolname='{roles['viewer']}'")
    role_exists = cur.fetchone()

    if role_exists:
        for schemaname in schemanames:
            revoke_sql = f"""
            REVOKE ALL ON SCHEMA {schemaname} FROM {roles['viewer']};
            REVOKE ALL ON ALL TABLES IN SCHEMA {schemaname} FROM {roles['viewer']};
            ALTER DEFAULT PRIVILEGES IN SCHEMA {schemaname} REVOKE ALL ON TABLES  FROM {roles['viewer']};
            """
            cur.execute(revoke_sql)
    else:
        raise Exception(f"{roles['viewer']} not found on database")

    conn.commit()
    conn.close()


def manage_roles(
    modulename: str,
    pg_service: str = None,
    grant: bool = True,
    ext_schema: str = None,
    db_spec_roles: Optional[bool] = False,
):
    """
    Manages the roles for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modulename: Abbreviation of the TEKSI module
    :param grant: Boolean defining whether to grant privileges or revoke them
    :param ext_schema: Schema name of the extension model
    :param db_spec_roles: will create database specific roles instead of cluster specific roles
    """
    if modulename and not pg_service:
        pg_service = f"pg_{modulename}"

    create_roles(pg_service, modulename, db_spec_roles)

    if grant:
        grant_privileges(pg_service, modulename, db_spec_roles, ext_schema)
    else:
        revoke_privileges(pg_service, modulename, db_spec_roles, ext_schema)


if __name__ == "__main__":
    parser = ArgumentParser()

    subparsers = parser.add_subparsers(title="subcommands", dest="parser")

    createrole_parser = subparsers.add_parser(
        "create_roles",
        help="Create roles for usage in TEKSI",
        description="Create roles for usage in TEKSI",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )

    createrole_parser.add_argument("-m", "--modulename", help="Abbreviation of the TEKSI module")

    createrole_parser.add_argument("-p", "--pg_service", help="postgres service")

    createrole_parser.add_argument(
        "-d",
        "--database_specific_roles",
        help="Create database specific roles",
        default=False,
        action=BooleanOptionalAction,
    )

    grant_parser = subparsers.add_parser(
        "grant",
        help="Grant rights to roles",
        description="Grant rights to roles",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )

    grant_parser.add_argument("-m", "--modulename", help="Abbreviation of the TEKSI module")

    grant_parser.add_argument("-p", "--pg_service", help="postgres service")

    grant_parser.add_argument(
        "-d",
        "--database_specific_roles",
        help="Create database specific roles",
        default=False,
        action=BooleanOptionalAction,
    )

    grant_parser.add_argument(
        "-x", "--extension_schema", help="Name of the extension schema", required=False
    )
    revoke_parser = subparsers.add_parser(
        "revoke",
        help="Revoke rights from roles",
        description="Revoke rights from roles",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )
    revoke_parser.add_argument("-m", "--modulename", help="Abbreviation of the TEKSI module")

    revoke_parser.add_argument("-p", "--pg_service", help="postgres service")

    revoke_parser.add_argument(
        "-d",
        "--database_specific_roles",
        help="Create database specific roles",
        default=False,
        action=BooleanOptionalAction,
    )

    revoke_parser.add_argument(
        "-x", "--extension_schema", help="Name of the extension schema", required=False
    )

    args = parser.parse_args()

    if args.parser == "create_roles":
        create_roles(
            pg_service=args.pg_service,
            modulename=args.modulename,
            db_spec_roles=args.database_specific_roles,
        )
    elif args.parser == "grant":
        grant_privileges(
            pg_service=args.pg_service,
            modulename=args.modulename,
            ext_schema=args.extension_schema,
            db_spec_roles=args.database_specific_roles,
        )
    elif args.parser == "revoke":
        revoke_privileges(
            pg_service=args.pg_service,
            modulename=args.modulename,
            ext_schema=args.extension_schema,
            db_spec_roles=args.database_specific_roles,
        )
    else:
        print("Unknown operation")
        exit(1)
