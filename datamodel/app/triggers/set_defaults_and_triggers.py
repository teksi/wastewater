#!/usr/bin/env python3


try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def create_last_modification_trigger(tbl: str, parent_tbl: str = None):
    parent = (
        f"_parent('tww_od.{parent_tbl}')" if parent_tbl else "()"
    )  # as parent:_tbl is a tuple, we don't need additional brackets
    query = f"""
    CREATE TRIGGER
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


def set_defaults_and_triggers(
    pg_service: str = "pg_tww",
    SingleInheritances: dict = {},
):
    """
    Creates the triggers and sets default values for TEKSI Wastewater & GEP
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    :param SingleInheritances: dictionary of all SingleInheritances in database
    """

    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(
        "select table_name from information_schema.tables WHERE table_schema = 'tww_od'"
    )
    entries = cursor.fetchall()

    for entry in entries:
        cursor.execute(
            f"""select 1 from information_schema.columns
            WHERE table_schema = 'tww_od'
            AND table_name = '{entry[0]}'
            and column_name = 'obj_id'"""
        )
        found = cursor.fetchone()
        if found:
            query = create_oid_default(entry[0])
            cursor.execute(query)
        if entry[0] in SingleInheritances.keys():  # Find Subclasses
            cursor.execute(
                f"""select 1 from information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{SingleInheritances[entry[0]]}'
                and column_name = 'last_modification'"""
            )
            found = cursor.fetchone()
            if found:
                query = create_last_modification_trigger(entry[0], SingleInheritances[entry[0]])
                cursor.execute(query)

   
        else:
            cursor.execute(
                f"""select 1 from information_schema.columns
                WHERE table_schema = 'tww_od'
                AND table_name = '{entry[0]}'
                and column_name = 'last_modification'"""
            )
            found = cursor.fetchone()
            if found:
                query = create_last_modification_trigger(entry[0])
                cursor.execute(query)
    conn.commit()
    conn.close()
