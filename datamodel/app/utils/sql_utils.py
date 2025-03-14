#!/usr/bin/env python3
import os
import re
from pathlib import Path

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def run_sql_file(file_path: str, pg_service: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    with open(abs_file_path) as f:
        sql = f.read()
    run_sql(sql, pg_service, variables)


def run_sql(sql: str, pg_service: str, variables: dict = None):
    if variables:
        if re.search(r"\{[^}]*\}", sql):  # avoid formatting if no variables are present
            try:
                sql = psycopg.sql.SQL(sql).format(**variables)
            except IndexError:
                print(sql)
                raise
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    conn.close()


def run_sql_files_in_folder(directory: str, pg_service: str, variables: dict = None):
    files = os.listdir(directory)
    files.sort()
    for file in files:
        filename = os.fsdecode(file)
        if filename.lower().endswith(".sql"):
            print(f"Running {filename}")
            run_sql_file(os.path.join(directory, filename), pg_service, variables)
