#!/usr/bin/env python3

import re
from argparse import ArgumentParser, BooleanOptionalAction
from typing import Optional

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def get_db_identifier(pg_service: str, modelname: str):
    conn = psycopg.connect(f"service={pg_service}")
    db_identifier = re.sub(f"{modelname}_|teksi_", "", conn.info.dbname)
    conn.close()
    return db_identifier


def create_role(pg_service: str, role: str, in_role: str = None):
    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    cur.execute(f"SELECT 1 FROM pg_roles WHERE rolname='{role}'")
    role_exists = cur.fetchone()
    if not role_exists:
        role_sql = f"""
            CREATE ROLE {role} NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION {('IN ROLE '+in_role) if in_role else ''};
        """
        cur.execute(role_sql)
    conn.close()


def grant_privileges(model_name: str, roles: list, ext_schema: str = None):
    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    grant_sql = f"""
        GRANT USAGE ON SCHEMA {modelname}_od  TO {roles[0]};
        GRANT USAGE ON SCHEMA {modelname}_sys TO {roles[0]};
        GRANT USAGE ON SCHEMA {modelname}_vl  TO {roles[0]};
        GRANT USAGE ON SCHEMA {modelname}_cfg  TO {roles[0]};
        GRANT USAGE ON SCHEMA {modelname}_app  TO {roles[0]};

        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {modelname}_od  TO {roles[0]};
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {modelname}_sys TO {roles[0]};
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {modelname}_vl  TO {roles[0]};
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {modelname}_cfg  TO {roles[0]};
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {modelname}_app  TO {roles[0]};


        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {modelname}_od  TO {roles[0]};
        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {modelname}_sys TO {roles[0]};
        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {modelname}_vl  TO {roles[0]};
        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {modelname}_cfg  TO {roles[0]};
        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {modelname}_app  TO {roles[0]};


        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_od  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_sys GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_vl  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_cfg GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_app GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};

        /* User */
        GRANT ALL ON SCHEMA {modelname}_od TO {roles[1]};
        GRANT ALL ON ALL TABLES IN SCHEMA {modelname}_od TO {roles[1]};
        GRANT ALL ON ALL SEQUENCES IN SCHEMA {modelname}_od TO {roles[1]};
        GRANT ALL ON SCHEMA {modelname}_app TO {roles[1]};
        GRANT ALL ON ALL TABLES IN SCHEMA {modelname}_app TO {roles[1]};
        GRANT ALL ON ALL TABLES IN SCHEMA {modelname}_cfg TO {roles[1]};

        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_od GRANT ALL ON TABLES TO {roles[1]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_od GRANT ALL ON SEQUENCES TO {roles[1]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_app GRANT ALL ON TABLES TO {roles[1]};

       GRANT CREATE ON DATABASE {conn.info.dbname} TO "{roles[1]}";  -- required for ili2pg imports/exports

        /* Manager */
        GRANT ALL ON SCHEMA {modelname}_vl TO {roles[2]};
        GRANT ALL ON ALL TABLES IN SCHEMA {modelname}_vl TO {roles[2]};
        GRANT ALL ON ALL SEQUENCES IN SCHEMA {modelname}_vl TO {roles[2]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_vl GRANT ALL ON TABLES TO {roles[2]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_vl GRANT ALL ON SEQUENCES TO {roles[2]};

        /* SysAdmin */
        GRANT ALL ON SCHEMA {modelname}_sys TO {roles[3]};
        GRANT ALL ON ALL TABLES IN SCHEMA {modelname}_sys TO {roles[3]};
        GRANT ALL ON ALL SEQUENCES IN SCHEMA {modelname}_sys TO {roles[3]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_sys GRANT ALL ON TABLES TO {roles[3]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_sys GRANT ALL ON SEQUENCES TO {roles[3]};
        """
    cur.execute(grant_sql)
    if ext_schema:
        grant_sql = f"""
        GRANT USAGE ON SCHEMA {ext_schema}  TO {roles[0]};
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {ext_schema}  TO {roles[0]};
        GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA {ext_schema}  TO {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema}  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {roles[0]};
        /* User */
        GRANT ALL ON SCHEMA {ext_schema} TO {roles[1]};
        GRANT ALL ON ALL TABLES IN SCHEMA {ext_schema} TO {roles[1]};
        GRANT ALL ON ALL SEQUENCES IN SCHEMA {ext_schema} TO {roles[1]};
         ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema} GRANT ALL ON TABLES TO {roles[1]};
        """
        cur.execute(grant_sql)
    conn.close()


def revoke_privileges(model_name: str, roles: list, ext_schema: str = None):
    conn = psycopg.connect(f"service={pg_service}")
    cur = conn.cursor()
    revoke_sql = f"""
        REVOKE ALL ON SCHEMA {modelname}_od  FROM {roles[0]};
        REVOKE ALL ON SCHEMA {modelname}_app FROM {roles[0]};
        REVOKE ALL ON SCHEMA {modelname}_sys FROM {roles[0]};
        REVOKE ALL ON SCHEMA {modelname}_vl  FROM {roles[0]};

        REVOKE ALL ON ALL TABLES IN SCHEMA {modelname}_od  FROM {roles[0]};
        REVOKE ALL ON ALL TABLES IN SCHEMA {modelname}_app FROM {roles[0]};
        REVOKE ALL ON ALL TABLES IN SCHEMA {modelname}_sys FROM {roles[0]};
        REVOKE ALL ON ALL TABLES IN SCHEMA {modelname}_vl  FROM {roles[0]};

        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_od  REVOKE ALL ON TABLES  FROM {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_app REVOKE ALL ON TABLES  FROM {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_sys REVOKE ALL ON TABLES  FROM {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {modelname}_vl  REVOKE ALL ON TABLES  FROM {roles[0]};
        """
    cur.execute(revoke_sql)
    if ext_schema:
        revoke_sql = f"""
        REVOKE ALL ON SCHEMA {ext_schema} FROM {roles[0]};
        REVOKE ALL ON ALL TABLES IN SCHEMA {ext_schema} FROM {roles[0]};
        ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema} REVOKE ALL ON TABLES  FROM {roles[0]};
        """
        cur.execute(revoke_sql)
    conn.close()


def create_roles(
    modelname: str,
    pg_service: str = None,
    grant: bool = True,
    ext_schema: str = None,
    db_spec_roles: Optional[bool] = False,
):
    """
    Creates the roles for usage in TEKSI Modules
    :param pg_service: the PostgreSQL service
    :param modelname: Abbreviation of the TEKSI model
    :param grant: Boolean defining whether to grant privileges or revoke them
    :param ext_schema: Schema name of the extension model
    :param db_spec_roles: will create database specific roles instead of cluster specific roles
    """
    if modelname and not pg_service:
        pg_service = f"pg_{modelname}"

    roles = [
        f"{modelname}_viewer",
        f"{modelname}_user",
        f"{modelname}_manager",
        f"{modelname}_sysadmin",
    ]

    if db_spec_roles:
        db_identifier = "_" + get_db_identifier(pg_service, modelname)
        roles = [s + db_identifier for s in roles]

    in_roles = [None]
    in_roles.extend(roles[:-1])

    for role, in_role in zip(roles, in_roles):
        create_role(pg_service, role, in_role)

    if grant:
        grant_privileges(model_name, roles, ext_schema)
    else:
        revoke_privileges(model_name, roles, ext_schema)


if __name__ == "__main__":
    parser = ArgumentParser()

    parser.add_argument("-m", "--modelname", help="Abbreviation of the TEKSI model")

    parser.add_argument("-p", "--pg_service", help="postgres service")

    parser.add_argument(
        "-d",
        "--database_specific_roles",
        help="Create database specific roles",
        default=False,
        action=BooleanOptionalAction,
    )
    excl_group = parser.add_mutually_exclusive_group(required=True)
    excl_group.add_argument(
        "-g",
        "--grant_privileges",
        help="grant privileges for roles",
        default=True,
        dest="grant",
        action="store_true",
    )

    excl_group.add_argument(
        "-r",
        "--revoke_privileges",
        help="revoke privileges for roles",
        dest="grant",
        action="store_false",
    )
    parser.set_defaults(grant=True)

    parser.add_argument(
        "-x", "--extension_schema", help="Name of the extension schema", required=False
    )

    args = parser.parse_args()

    create_roles(
        args.modelname,
        args.pg_service,
        grant=args.grant,
        ext_schema=args.extension_schema,
        db_spec_roles=args.database_specific_roles,
    )
