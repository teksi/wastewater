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
    if variables is None:
        variables = {}
    sql_vars=parse_variables(variables)
    if re.search(r"\{[^}]*\}", sql):  # avoid formatting if no variables are present
        try:
            sql_query = psycopg.sql.SQL(sql).format(**sql_vars)
        except IndexError:
            print(sql)
            raise
    else:
       sql_query = psycopg.sql.SQL(sql) 
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    # print(sql_query.as_string(conn))
    cursor.execute(sql_query)
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


def parse_variables(variables: dict) -> dict:
    """Parse variables based on their defined types in the YAML."""
    formatted_vars = {}
    
    for key, meta in variables.items():
        if isinstance(meta, dict) and "value" in meta and "type" in meta:
            value, var_type = meta["value"], meta["type"].lower()
            
            if var_type == "raw":  # Directly insert SQL without escaping
                formatted_vars[key] = psycopg.sql.SQL(value)
            elif var_type == "identifier":  # Table/Column names
                formatted_vars[key] = psycopg.sql.Identifier(value)
            elif var_type == "literal":  # String/Number literals
                formatted_vars[key] = psycopg.sql.Literal(value)
            else:
                raise ValueError(f"Unknown type '{var_type}' for variable '{key}'")
        else:
            formatted_vars[key] = psycopg.sql.Literal(str(meta))  
    return formatted_vars