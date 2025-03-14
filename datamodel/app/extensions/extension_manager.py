import os
from argparse import ArgumentParser
from pathlib import Path

from yaml import safe_load

from ..utils.py_utils import run_py_files_in_folder
from ..utils.sql_utils import run_sql_files_in_folder

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def read_config(config_file: str, extension_name: str):
    abs_file_path = Path(__file__).parent.resolve() / config_file
    with open(abs_file_path) as file:
        config = safe_load(file)
    for entry in config.get("extensions", []):
        if entry.get("id") == extension_name:
            return entry
    raise ValueError(f"No entry found with id: {extension_name}")


def load_extension(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    module_name: str = "tww",
    extension_name: str = None,
):
    """
    initializes the TWW database for usage of an extension

    Args:
        pgservice: pg service string
        extension_name: Name of the extension to load

    """

    # load definitions from config
    config = read_config("config.yaml", extension_name)
    variables = config.get("variables", {})
    if srid:
        variables.update({"SRID": psycopg.sql.SQL(f"{srid}")})

    # We also disable symbology triggers as they can badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(f"SELECT {module_name}_app.alter_symbology_triggers('disable');")
    conn.commit()
    conn.close()

    directory = config.get("directory", None)
    yaml_files = {}
    if directory:
        abs_dir = Path(__file__).parent.resolve() / directory
        run_py_files_in_folder(abs_dir, variables)
        run_sql_files_in_folder(abs_dir, pg_service, variables)
        files = os.listdir(abs_dir)
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".yaml"):
                key = filename.removesuffix(".yaml")
                yaml_files[key] = abs_dir / filename

    # re-create symbology triggers
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(f"SELECT {module_name}_app.alter_symbology_triggers('enable');")
    conn.commit()
    conn.close()
    return yaml_files


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument("-m", "--module_name", help="name of TEKSI module", default="tww")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "-x", "--extension_name", help="name of the database extension", type=str, default="demo"
    )
    args = parser.parse_args()

    _ = load_extension(
        args.srid,
        args.pg_service,
        args.module_name,
        args.extension_name,
    )
