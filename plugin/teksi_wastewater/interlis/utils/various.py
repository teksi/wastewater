import datetime
import os
import re
import subprocess
import tempfile
from typing import List

from ...utils.database_utils import DatabaseUtils
from ...utils.plugin_utils import logger


class CmdException(BaseException):
    pass


def execute_subprocess(command, check=True, output_content=False):
    command_masked_pwd = re.sub(r"(--dbpwd)\s\"[\w\.*#?!@$%^&-]+\"", r'\1 "[PASSWORD]"', command)
    logger.info(f"EXECUTING: {command_masked_pwd}")
    try:
        proc = subprocess.run(
            command,
            check=True,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
    except subprocess.CalledProcessError as e:
        if check:
            logger.exception(e.output.decode("windows-1252" if os.name == "nt" else "utf-8"))
            raise CmdException("Command errored ! See logs for more info.")
        return e.output if output_content else e.returncode
    return proc.stdout.decode().strip() if output_content else proc.returncode


def get_pgconf_as_ili_args() -> List[str]:
    """Returns the pgconf as a list of ili2db arguments"""
    pgconf = DatabaseUtils.get_pgconf()
    args = []
    if pgconf["host"]:
        args.extend(["--dbhost", '"' + pgconf["host"] + '"'])
    if pgconf["port"]:
        args.extend(["--dbport", '"' + pgconf["port"] + '"'])
    if pgconf["user"]:
        args.extend(["--dbusr", '"' + pgconf["user"] + '"'])
    if pgconf["password"]:
        args.extend(["--dbpwd", '"' + pgconf["password"] + '"'])
    if pgconf["dbname"]:
        args.extend(["--dbdatabase", '"' + pgconf["dbname"] + '"'])
    return args


def make_log_path(next_to_path, step_name):
    """Returns a path for logging purposes. If next_to_path is None, it will be saved in the temp directory"""
    now = f"{datetime.datetime.now():%y%m%d%H%M%S}"
    if next_to_path:
        return f"{next_to_path}.{now}.{step_name}.log"
    else:
        temp_path = os.path.join(tempfile.gettempdir(), "tww2ili")
        os.makedirs(temp_path, exist_ok=True)
        return os.path.join(temp_path, f"{now}.{step_name}.log")


class LoggingHandlerContext:
    """Temporarily sets a log handler, then removes it"""

    def __init__(self, handler):
        self.handler = handler

    def __enter__(self):
        logger.addHandler(self.handler)

    def __exit__(self, et, ev, tb):
        logger.removeHandler(self.handler)
        self.handler.close()
        # implicit return of None => don't swallow exceptions
