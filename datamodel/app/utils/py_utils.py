#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path


def run_py_file(file_path: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    varlist = [sys.executable, str(abs_file_path)]
    for key, value in variables.iteritems():
        varlist.append("--" + key)
        varlist.append(value)
    result = subprocess.run(varlist, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"Error running file: {result.stderr}")


def run_py_files_in_folder(directory: str, pg_service: str, variables: dict = None):
    files = os.listdir(directory)
    files.sort()
    for file in files:
        filename = os.fsdecode(file)
        if filename.lower().endswith(".py"):
            print(f"Running {filename}")
            run_py_file(os.path.join(directory, filename), pg_service, variables)
