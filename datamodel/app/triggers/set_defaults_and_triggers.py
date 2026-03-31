#!/usr/bin/env python3

import psycopg
from pum import SqlContent


def check_owner(connection: psycopg.Connection, table_schema: str, table_name: str):
    try:
        cursor = SqlContent(
            " SELECT rolname FROM pg_roles WHERE pg_has_role( CURRENT_USER, oid, 'member');"
        ).execute(connection)
        roles = cursor.fetchall()

        cursor = SqlContent(
            f"SELECT tableowner from pg_tables WHERE tablename='{table_name}' and schemaname='{table_schema}';"
        ).execute(connection)
        owner = cursor.fetchone()

        is_owner = True if owner in roles else False
    except Exception as e:
        print("An error occurred:", e)
    return is_owner


def create_last_modification_trigger(tbl: str, parent_tbl: str = None):
    parent = (
        f"_parent('tww_od.{parent_tbl}')" if parent_tbl else "()"
    )  # as parent:_tbl is a tuple, we don't need additional brackets
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


def create_default_value_trigger(tbl: str, inheritance_data: dict = {}):
    inheritance_structure = inheritance_data.get(tbl, {})
    if not inheritance_structure:  # tbl does not inherit to anyone
        return ""
    referencing_tbls = inheritance_structure.get("referencing", [])
    referenced_tbls = inheritance_structure.get("referenced", [])
    inheriting_tbls = inheritance_structure.get("inherits_to", [])
    parent_tbl = inheritance_structure.get("inherits_from", [None])[0]
    subqueries = []

    for inheriting_tbl in inheriting_tbls:
        _referencing = inheritance_data.get(inheriting_tbl, {}).get("referencing", [])
        _referenced = inheritance_data.get(inheriting_tbl, {}).get("referenced", [])
        referencing_tbls.append(_referencing)
        args_referenced_inh = f"'tww_od', {parent_arg}, 'fk_{inheriting_tbl}', " + ", ".join(
            f"'{t}'" for t in _referenced
        )
        subqueries.append(
            f"""
        CREATE OR REPLACE TRIGGER
        update_default_values_{tbl}_referenced
        AFTER UPDATE OR INSERT ON
        tww_od.{tbl}
        FOR EACH ROW EXECUTE PROCEDURE
        tww_app.modification_default_orgs_referenced({args_referenced_inh});
        """
        )

    parent_arg = f"'{parent_tbl}'" if parent_tbl is not None else "NULL"
    args_referencing = f"'tww_od', {parent_arg}, " + ", ".join(f"'{t}'" for t in referencing_tbls)
    args_referenced = f"'tww_od', {parent_arg}, NULL, " + ", ".join(
        f"'{t}'" for t in referenced_tbls
    )

    if referencing_tbls:
        subqueries.append(
            f"""
        CREATE OR REPLACE TRIGGER
        update_default_values_{tbl}_referencing
        AFTER UPDATE OR INSERT ON
        tww_od.{tbl}
        FOR EACH ROW EXECUTE PROCEDURE
        tww_app.modification_default_orgs_referencing({args_referencing});
        """
        )
    if referenced_tbls:
        subqueries.append(
            f"""
        CREATE OR REPLACE TRIGGER
        update_default_values_{tbl}_referenced
        AFTER UPDATE OR INSERT ON
        tww_od.{tbl}
        FOR EACH ROW EXECUTE PROCEDURE
        tww_app.modification_default_orgs_referenced({args_referenced});
        """
        )
    return "".join(subqueries)


def set_defaults_and_triggers(
    connection: psycopg.Connection,
    SingleInheritances: dict = {},
    FkInheritances: dict = {},
):
    """
    Creates the triggers and sets default values for TEKSI Wastewater & GEP
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param SingleInheritances: dictionary of all SingleInheritances in database
    """

    cursor = SqlContent(
        f"select table_name from information_schema.tables WHERE table_schema = '{schema}'"
    ).execute(connection)
    table_names = cursor.fetchall()
    for table_name in table_names:
        cursor = SqlContent(
            f"""select 1 from information_schema.columns
            WHERE table_schema = 'tww_od'
            AND table_name = '{table_name[0]}'
            and column_name = 'obj_id'"""
        ).execute(connection)
        found = cursor.fetchone()
        if found:
            query = create_oid_default(table_name[0])
            SqlContent(query).execute(connection)
        if table_name[0] in SingleInheritances.keys():  # Find Subclasses
            cursor = SqlContent(
                f"""select 1 from information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{SingleInheritances[table_name[0]]}'
                and column_name = 'last_modification'"""
            ).execute(connection)
            found = cursor.fetchone()
            if found:
                if check_owner(connection, "tww_od", table_name[0]):
                    query = create_last_modification_trigger(
                        table_name[0], SingleInheritances[table_name[0]]
                    )
                    SqlContent(query).execute(connection)
                else:
                    raise Exception(f"Must be owner of tww_od.{table_name[0]} to create triggers")
        else:
            cursor = SqlContent(
                f"""select 1 from information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{table_name[0]}'
                and column_name = 'last_modification'"""
            ).execute(connection)
            found = cursor.fetchone()
            if found:
                if check_owner(connection, "tww_od", table_name[0]):
                    query = create_last_modification_trigger(table_name[0])
                    SqlContent(query).execute(connection)
                else:
                    raise Exception(f"Must be owner of tww_od.{table_name[0]} to create triggers")
        if table_name[0] in FkInheritances.keys():  # Find Subclasses
            if check_owner(connection, "tww_od", table_name[0]):
                query = create_default_value_trigger(table_name[0], FkInheritances[table_name[0]])
                SqlContent(query).execute(connection)
            else:
                raise Exception(f"Must be owner of tww_od.{table_name[0]} to create triggers")
