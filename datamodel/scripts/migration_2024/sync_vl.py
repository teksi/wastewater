#!/usr/bin/env python3
"""Synchronize the tww_vl value list data from a reference database into a target database.

Rows are upserted (INSERT ... ON CONFLICT DO UPDATE) based on the primary key
of each value list table. Rows that only exist in the target database (e.g.
user-defined value list entries) are kept untouched.

Usage: sync_vl.py <reference-connection-string> <target-connection-string>
"""

import sys

import psycopg
from psycopg import sql

SCHEMA = "tww_vl"


def primary_key_columns(conn: psycopg.Connection, table: str) -> list[str]:
    rows = conn.execute(
        """
        SELECT a.attname
        FROM pg_index i
        JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
        WHERE i.indrelid = %s::regclass AND i.indisprimary
        ORDER BY a.attnum
        """,
        (f"{SCHEMA}.{table}",),
    ).fetchall()
    return [r[0] for r in rows]


def columns(conn: psycopg.Connection, table: str) -> list[str]:
    rows = conn.execute(
        """
        SELECT column_name FROM information_schema.columns
        WHERE table_schema = %s AND table_name = %s
        ORDER BY ordinal_position
        """,
        (SCHEMA, table),
    ).fetchall()
    return [r[0] for r in rows]


def main() -> int:
    ref_conn_str, target_conn_str = sys.argv[1], sys.argv[2]
    with psycopg.connect(ref_conn_str) as ref, psycopg.connect(target_conn_str) as target:
        tables = [
            r[0]
            for r in ref.execute(
                """
                SELECT table_name FROM information_schema.tables
                WHERE table_schema = %s AND table_type = 'BASE TABLE'
                ORDER BY table_name
                """,
                (SCHEMA,),
            ).fetchall()
        ]

        for table in tables:
            target_cols = columns(target, table)
            if not target_cols:
                print(
                    f"WARNING: {SCHEMA}.{table} does not exist in target, skipping",
                    file=sys.stderr,
                )
                continue
            pk = primary_key_columns(ref, table)
            if not pk:
                print(f"WARNING: {SCHEMA}.{table} has no primary key, skipping", file=sys.stderr)
                continue
            cols = [c for c in columns(ref, table) if c in set(target_cols)]

            rows = ref.execute(
                sql.SQL("SELECT {cols} FROM {table}").format(
                    cols=sql.SQL(", ").join(map(sql.Identifier, cols)),
                    table=sql.Identifier(SCHEMA, table),
                )
            ).fetchall()
            if not rows:
                continue

            non_pk_cols = [c for c in cols if c not in pk]
            insert = sql.SQL(
                "INSERT INTO {table} ({cols}) VALUES ({placeholders}) ON CONFLICT ({pk}) DO {action}"
            ).format(
                table=sql.Identifier(SCHEMA, table),
                cols=sql.SQL(", ").join(map(sql.Identifier, cols)),
                placeholders=sql.SQL(", ").join(sql.Placeholder() for _ in cols),
                pk=sql.SQL(", ").join(map(sql.Identifier, pk)),
                action=(
                    sql.SQL("UPDATE SET {assignments}").format(
                        assignments=sql.SQL(", ").join(
                            sql.SQL("{col} = EXCLUDED.{col}").format(col=sql.Identifier(c))
                            for c in non_pk_cols
                        )
                    )
                    if non_pk_cols
                    else sql.SQL("NOTHING")
                ),
            )
            with target.cursor() as cur:
                cur.executemany(insert, rows)
            print(f"{SCHEMA}.{table}: synchronized {len(rows)} rows")

        target.commit()
    return 0


if __name__ == "__main__":
    sys.exit(main())
