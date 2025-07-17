#!/usr/bin/env python3

"""
***************************************************************************
    create_release.py
    ---------------------
    Date                 : July 2025
    Copyright            : (C) 2025 by TEKSI
    Email                : info@teksi.ch
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""

import argparse
import sys

from packaging import version


def compare_versions(changed_files: list = [], latest_stable_release: str = None):
    """
    Compares versions of all  all dumps
    :return: the files names in a list
    """
    for file in changed_files:
        if file.startswith("datamodel/changelogs/"):
            parts = file.split("/")
            if len(parts) >= 3:
                version_folder = parts[2]

                # Parse version strings
                v1 = version.parse(latest_stable_release)
                v2 = version.parse(version_folder)

                # Compare versions
                if v2 < v1:
                    print(
                        f"Changes detected in a disallowed datamodel/changelogs/{version_folder} folder."
                    )
                    sys.exit(1)

    print("no Changes detected in a disallowed changelogs version folder.")
    sys.exit(0)


def get_parser():
    """
    Creates a new argument parser.
    """
    _parser = argparse.ArgumentParser("check-changes-in-changelog.py")
    _parser.add_argument(
        "--latest_stable_release", "-r", help="Sets the latest latest_stable_release"
    )
    _parser.add_argument(
        "--changed_files", "-f", nargs="+", required=True, help="Sets the list of changed files"
    )
    return _parser


if __name__ == "__main__":
    parser = get_parser()
    args = parser.parse_args()

    files = compare_versions(latest_stable_release=args.latest_stable_release, changed_files=args.changed_files)
