#!/usr/bin/env python3


try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg




def create_last_modification_trigger(tbl: str, parent_tbl: str = None):
    parent = f"_parent('tww_od.{parent_tbl}')" if parent_tbl else ""
    query = f"""
    CREATE TRIGGER
    update_last_modified_{tbl}
    BEFORE UPDATE OR INSERT ON
     tww_od.{tbl}
    FOR EACH ROW EXECUTE PROCEDURE
     tww_app.update_last_modified{parent}();
     """
    return query


def create_oid_default(tbl: str):
    query = f"""
    ALTER TABLE
     tww_od.{tbl}
    ALTER COLUMN obj_id DEFAULT tww_app.generate_oid('tww_od','{tbl}');
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
    cursor.execute("select table_name from information_schema.tables WHERE table_schema = 'tww_od'")
    entries = cursor.fetchall()

    for entry in entries:
        cursor.execute(f"select 1 from information_schema.columns WHERE table_schema = 'tww_od' AND table_name = '{entry}' and column_name = 'obj_id'")
        attrs = cursor.fetchone()
        if attrs:
            query = create_oid_default(entry)
            cursor.execute(query)
        is_subclass = False
        for key in SingleInheritances:
            if entry == key: #Find Subclasses
                query = create_last_modification_trigger(key,SingleInheritances[key])
                cursor.execute(query)
                is_subclass = True
                break
        if not is_subclass:
            query = create_last_modification_trigger(entry,None)
                cursor.execute(query)
    conn.commit()
    conn.close()
