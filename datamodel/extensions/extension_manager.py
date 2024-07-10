# Definitions for tww datamodel with delta >= 1.7.0
# supposed usage: add TEKSI2AG64_96 into the plugin folder of TEKSI wastewater.

import os
import subprocess
import sys
from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path

from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from yaml import safe_load


def read_config(config_file: str, entry_id: str):
    with open(config_file, 'r') as file:
        config = safe_load(file)
    for entry in config.get('extensions', []):
        if entry.get('id') == entry_id:
            return entry
    raise ValueError(f"No entry found with id: {entry_id}")


def run_py_file(file_path: str):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    result = subprocess.run([sys.executable, str(abs_file_path)], capture_output=True, text=True)

    if result.returncode != 0:
        raise RuntimeError(f"Error running file: {result.stderr}")

def run_sql_file(file_path: str, pg_service: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    with open(abs_file_path) as f:
        sql = f.read()
    run_sql(sql, pg_service, variables)

def run_sql(sql: str, pg_service: str, variables: dict = None):
    if variables:
        sql = psycopg.sql.SQL(sql).format(**variables)
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    conn.close()

def load_extension(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    extension_name: str = None
    drop_schema: Optional[bool] = False,
    ):
    """
    initializes the TWW database for usage of an extension

    Args:
        pgservice: pg service string
        extension_name: Name of the extension to load

    """


    # load definitions from config
    config = read_config("config.yaml", entry_id)
    definitions = [d for d in config.extension_def if d['id'] == extension_name] [0]
    variables = config.get('variables',{})
    # pass SRID and extension schema name per default
    variables.update({'ext_schema': config.get('schema','tww_'||entry_id),'srid': psycopg.sql.SQL(f"{srid}")})

    if drop_schema:
        run_sql(f"DROP SCHEMA IF EXISTS {config.get('schema','tww_'||entry_id)} CASCADE;", pg_service)

    # We also disable symbology triggers as they can badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    init_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    init_session.execute("SELECT tww_sys.disable_symbology_triggers();")
    init_session.commit()
    init_session.flush()

    directory = config.get('directory',None)
    if directory:
        files = os.listdir(os.path.join(directory,os.pardir))
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".sql"):
                run_sql_file(os.path.join(directory, filename),pg_service,variables)
            if filename.endswith(".py"):
                run_py_file(os.path.join(directory, filename))


    # re-create symbology triggers
    post_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    post_session.execute("SELECT tww_sys.enable_symbology_triggers();")
    post_session.commit()
    post_session.close()


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "-x --extension_name",
        help="YAML definition file path for additions to vw_tww_wastewater_structure view",
    )
    parser.add_argument(
        "--tww_reach_extra",
        help="YAML definition file path for additions to vw_tww_reach view",
    )
    parser.add_argument(
        "-d",
        "--drop-schema",
        help="Drops cascaded any existing extension schema",
        default=False,
        action=BooleanOptionalAction,
    )
    args = parser.parse_args()

    load_extension(
        args.srid,
        args.pg_service,
        args.extension_name,
        drop_schema=args.drop_schema,
    )
