#!/usr/bin/env python3
from pirogue.utils import insert_command, select_columns, table_parts, update_command

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def extra_cols(pg_service: str='pg_tww',extra_definition: dict = None):
    with psycopg.connect(f"service={pg_service}") as conn: 
        try:
            # Create a cursor
            cursor = conn.cursor()
            str = ", "+ "\n    ,".join(
                    [
                        select_columns(
                            pg_cur=cursor,
                            table_schema=table_parts(table_def["table"])[0],
                            table_name=table_parts(table_def["table"])[1],
                            skip_columns=table_def.get("skip_columns", []),
                            remap_columns=table_def.get("remap_columns_select", {}),
                            prefix=table_def.get("prefix", None),
                            table_alias=table_def.get("alias", None),
                        )
                        for table_def in extra_definition.get("joins", {}).values()
                    ]
                )
            cursor.close()
        except Exception as e:
            print("An error occurred:", e)

        finally:
            conn.close()
    return str

def extra_joins(pg_service: str='pg_tww',extra_definition: dict = None):
    str = "\n    ".join(
    [
        "LEFT JOIN {tbl} {alias} ON {jon}".format(
            tbl=table_def["table"],
            alias=table_def.get("alias", ""),
            jon=table_def["join_on"],
        )
        for table_def in extra_definition.get("joins", {}).values() 
    ]
    )
    return str

def insert_extra(pg_service: str='pg_tww',extra_definition: dict = None):
    with psycopg.connect(f"service={pg_service}") as conn: 
        try:
            # Create a cursor
            cursor = conn.cursor()
            str = "\n     ".join(
            [
                insert_command(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    remove_pkey=table_def.get("remove_pkey", False),
                    indent=2,
                    skip_columns=table_def.get("skip_columns", []),
                    remap_columns=table_def.get("remap_columns", {}),
                    prefix=table_def.get("prefix", None),
                    table_alias=table_def.get("alias", None),
                    insert_values=table_def.get("insert_values", {}),
                )
                for table_def in (t for t in extra_definition.get("joins", {}).values() if not t.get("read_only", True))
            ]
        )
        except Exception as e:
            print("An error occurred:", e)

        finally:
            conn.close()
    return str

def update_extra(pg_service: str='pg_tww',extra_definition: dict = None):
    with psycopg.connect(f"service={pg_service}") as conn: 
        try:
            # Create a cursor
            cursor = conn.cursor()
            str = "\n     ".join(
            [
                update_command(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    remove_pkey=table_def.get("remove_pkey", False),
                    indent=2,
                    skip_columns=table_def.get("skip_columns", []),
                    remap_columns=table_def.get("remap_columns", {}),
                    prefix=table_def.get("prefix", None),
                    table_alias=table_def.get("alias", None),
                    update_values=table_def.get("update_values", {}),
                    where_clause=table_def.get("where_clause", None),
                )
                for table_def in (t for t in extra_definition.get("joins", {}).values() if not t.get("read_only", True))
            ]
        )
        except Exception as e:
            print("An error occurred:", e)

        finally:
            conn.close()
    return str
