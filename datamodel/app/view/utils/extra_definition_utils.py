#!/usr/bin/env python3
import psycopg
from pirogue.utils import insert_command, select_columns, table_parts, update_command


def extra_cols(
    connection: psycopg.Connection, extra_definition: dict = {}, skip_prefix: bool = False
):
    if extra_definition:
        str = ", " + "\n    ,".join(
            [
                select_columns(
                    connection=connection,
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
        return str
    return ""


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
    return ""


def insert_extra(connection: psycopg.Connection, extra_definition: dict = {}):
    if not extra_definition:
        return ""

    sql_parts = []
    for table_def in extra_definition.get("joins", {}).values():
        if table_def.get("read_only", True):
            continue

        condition = table_def.get("case_condition", None)
        insert_sql = insert_command(
            connection=connection,
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
        if condition:
            wrapped_sql = f"""
            CASE WHEN {condition} THEN
                {insert_sql}
            ELSE NULL;
            END;
            """
            sql_parts.append(wrapped_sql)
        else:
            sql_parts.append(insert_sql)
        return "\n     ".join(sql_parts)
    return ""


def update_extra(connection: psycopg.Connection, extra_definition: dict = {}):
    if not extra_definition:
        return ""

    sql_parts = []
    for table_def in extra_definition.get("joins", {}).values():
        if table_def.get("read_only", True):
            continue

        condition = table_def.get("case_condition", None)
        update_sql = update_command(
                    connection=connection,
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
        if condition:
            wrapped_sql = f"""
            CASE WHEN {condition} THEN
                {update_sql}
            ELSE NULL;
            END;
            """
            sql_parts.append(wrapped_sql)
        else:
            sql_parts.append(update_sql)
        return "\n     ".join(sql_parts)
    return ""
