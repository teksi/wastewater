#!/usr/bin/env python3

import psycopg
from pum import SqlContent


def check_owner(connection: psycopg.Connection, table_schema: str, table_name: str):
    is_owner = False

    try:
        cursor = SqlContent(
            "SELECT rolname FROM pg_roles WHERE pg_has_role(CURRENT_USER, oid, 'member');"
        ).execute(connection)
        roles = cursor.fetchall()

        cursor = SqlContent(
            f"SELECT tableowner FROM pg_tables "
            f"WHERE tablename = '{table_name}' AND schemaname = '{table_schema}';"
        ).execute(connection)
        owner = cursor.fetchone()

        is_owner = True if owner in roles else False

    except Exception as e:
        print("An error occurred:", e)

    return is_owner


def create_last_modification_trigger(tbl: str, parent_tbl: str = None):
    parent = (
        f"_parent('tww_od.{parent_tbl}')" if parent_tbl else "()"
    )  # as parent_tbl is a tuple, we don't need additional brackets

    query = f"""
    CREATE OR REPLACE TRIGGER
    update_last_modified_{tbl}
    BEFORE UPDATE OR INSERT ON
     tww_od.{tbl}
    FOR EACH ROW EXECUTE PROCEDURE
     tww_app.modification_last_modified{parent};
     """

    return query


def create_oid_default(tbl: str):
    query = f"""
    ALTER TABLE
     tww_od.{tbl}
    ALTER COLUMN obj_id
    SET DEFAULT tww_app.generate_oid('tww_od','{tbl}');
     """

    return query


def create_default_value_trigger(tbl: str, fk_data: dict):
    def create_referencing_triggers(tbl, parent_tbl, target_to_fk_provider):
        triggers = []

        parent_arg = f"'{parent_tbl}'" if parent_tbl else "'_SELF_'"

        for target, fk_provider_tbl in sorted(target_to_fk_provider.items()):
            fk_col = f"fk_{fk_provider_tbl}"

            triggers.append(f"""
            CREATE OR REPLACE TRIGGER
            update_defaults_{tbl}_to_{target}
            AFTER UPDATE OR INSERT ON
            tww_od.{tbl}
            FOR EACH ROW EXECUTE PROCEDURE
            tww_app.modification_default_orgs_referencing(
                'tww_od',
                {parent_arg},
                '{fk_col}',
                '{target}'
            );
            """)

        return triggers

    def resolve_fk_targets(tbl: str, fk_data: dict) -> dict:
        """
        Returns:
        {
            "referencing": {
                target_table: fk_provider_table
            },
            "referenced": set(...)
        }

        For referencing targets, the FK provider is the table where the
        reference is declared in the YAML.

        Example:
            wastewater_node:
              referencing:
                - hydraulic_char_data

        Generates:
            hydraulic_char_data -> fk_wastewater_node

        If a target is inherited through inherits_to, the child table that
        declares the target becomes the FK provider.
        """
        resolved = {
            "referencing": {},
            "referenced": set(),
        }

        visited = set()

        def walk(current):
            if current in visited:
                return

            visited.add(current)

            node = fk_data.get(current, {})

            for target in node.get("referencing", []):
                resolved["referencing"][target] = current

            resolved["referenced"].update(node.get("referenced", []))

            for child in node.get("inherits_to", []):
                walk(child)

        walk(tbl)

        return resolved

    node = fk_data.get(tbl)
    if not node:
        return ""

    parent_tbl = node.get("inherits_from", [None])[0]

    resolved = resolve_fk_targets(tbl, fk_data)

    sql = []

    if resolved["referencing"]:
        sql += create_referencing_triggers(
            tbl,
            parent_tbl,
            resolved["referencing"],
        )

    if resolved["referenced"]:
        parent_arg = f"'{parent_tbl}'" if parent_tbl else "'_SELF_'"

        for target in sorted(resolved["referenced"]):
            sql.append(f"""
            CREATE OR REPLACE TRIGGER
            update_defaults_{tbl}_from_{target}
            AFTER UPDATE OR INSERT ON
            tww_od.{tbl}
            FOR EACH ROW EXECUTE PROCEDURE
            tww_app.modification_default_orgs_referenced(
                'tww_od',
                {parent_arg},
                '_SELF_',
                '{target}'
            );
            """)

    return "".join(sql)


def set_defaults_and_triggers(
    connection: psycopg.Connection,
    SingleInheritances: dict = None,
    FkInheritances: dict = None,
):
    """
    Creates the triggers and sets default values for TEKSI Wastewater & GEP.

    :param connection: psycopg database connection
    :param SingleInheritances: dictionary of all SingleInheritances in database
    :param FkInheritances: dictionary of all FK inheritances in database
    """
    if SingleInheritances is None:
        SingleInheritances = {}

    if FkInheritances is None:
        FkInheritances = {}

    schema = "tww_od"

    cursor = SqlContent(
        f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{schema}'"
    ).execute(connection)
    table_names = cursor.fetchall()

    for table_name in table_names:
        tbl = table_name[0]

        cursor = SqlContent(f"""
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'tww_od'
            AND table_name = '{tbl}'
            AND column_name = 'obj_id'
        """).execute(connection)
        found = cursor.fetchone()

        if found:
            query = create_oid_default(tbl)
            SqlContent(query).execute(connection)

        if tbl in SingleInheritances.keys():  # Find subclasses
            parent_tbl = SingleInheritances[tbl]

            cursor = SqlContent(f"""
                SELECT 1 FROM information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{parent_tbl}'
                AND column_name = 'last_modification'
            """).execute(connection)
            found = cursor.fetchone()

            if found:
                if check_owner(connection, "tww_od", tbl):
                    query = create_last_modification_trigger(tbl, parent_tbl)
                    SqlContent(query).execute(connection)
                else:
                    raise Exception(f"Must be owner of tww_od.{tbl} to create triggers")

        else:
            cursor = SqlContent(f"""
                SELECT 1 FROM information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{tbl}'
                AND column_name = 'last_modification'
            """).execute(connection)
            found = cursor.fetchone()

            if found:
                if check_owner(connection, "tww_od", tbl):
                    query = create_last_modification_trigger(tbl)
                    SqlContent(query).execute(connection)
                else:
                    raise Exception(f"Must be owner of tww_od.{tbl} to create triggers")

        if tbl in FkInheritances.keys():  # Find FK inheritance definitions
            if check_owner(connection, "tww_od", tbl):
                query = create_default_value_trigger(tbl, FkInheritances)
                if query:
                    SqlContent(query).execute(connection)
            else:
                raise Exception(f"Must be owner of tww_od.{tbl} to create triggers")