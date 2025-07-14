#!/usr/bin/env python3
import psycopg
from pirogue.utils import insert_command, select_columns, table_parts, update_command


def extra_cols(
    connection: psycopg.Connection, extra_definition: dict = {}, skip_prefix: bool = False
):
    if extra_definition:
        # Create a cursor
        cursor = connection.cursor()
        str = ", " + "\n    ,".join(
            [
                select_columns(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    skip_columns=table_def.get("skip_columns", []),
                    remap_columns=table_def.get("remap_columns_select", {}),
                    prefix=table_def.get("prefix", None) if not skip_prefix else None,
                    table_alias=table_def.get("alias", None),
                )
                for table_def in extra_definition.get("joins", {}).values()
            ]
        )
        cursor.close()
        return str
    return None


def extra_joins(connection: psycopg.Connection, extra_definition: dict = {}):
    if extra_definition:
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
    return None


def insert_extra(connection: psycopg.Connection, extra_definition: dict = {}):
    if extra_definition:
        # Create a cursor
        cursor = connection.cursor()
        str = "\n     ".join(
            [
                insert_command(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    remove_pkey=table_def.get("remove_pkey", False),
                    indent=2,
                    skip_columns=[
                        col
                        for col in table_def.get("skip_columns", [])
                        if col not in table_def.get("remap_columns", {})
                    ],
                    remap_columns=table_def.get("remap_columns", {}),
                    prefix=table_def.get("prefix", None),
                    table_alias=table_def.get("alias", None),
                    insert_values=table_def.get("insert_values", {}),
                )
                for table_def in (
                    t
                    for t in extra_definition.get("joins", {}).values()
                    if not t.get("read_only", True)
                )
            ]
        )
        return str
    return None


def update_extra(connection: psycopg.Connection, extra_definition: dict = {}):
    if extra_definition:
        # Create a cursor
        cursor = connection.cursor()
        str = "\n     ".join(
            [
                update_command(
                    pg_cur=cursor,
                    table_schema=table_parts(table_def["table"])[0],
                    table_name=table_parts(table_def["table"])[1],
                    remove_pkey=table_def.get("remove_pkey", False),
                    indent=2,
                    skip_columns=[
                        col
                        for col in table_def.get("skip_columns", [])
                        if col not in table_def.get("remap_columns", {})
                    ],
                    remap_columns=table_def.get("remap_columns", {}),
                    prefix=table_def.get("prefix", None),
                    table_alias=table_def.get("alias", None),
                    update_values=table_def.get("update_values", {}),
                    where_clause=table_def.get("where_clause", None),
                )
                for table_def in (
                    t
                    for t in extra_definition.get("joins", {}).values()
                    if not t.get("read_only", True)
                )
            ]
        )
        return str
    return None
