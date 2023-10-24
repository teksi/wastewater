#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
***************************************************************************
    create_release.py
    ---------------------
    Date                 : April 2018
    Copyright            : (C) 2018 by Denis Rouzaud
    Email                : denis@opengis.ch
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""

__author__ = 'Denis Rouzaud'
__date__ = 'April 2018'
__copyright__ = '(C) 2018,Denis Rouzaud'
# This will get replaced with a git SHA1 when you do a git archive
__revision__ = '$Format:%H$'

import http.client
import os
import json
import subprocess


def _cmd(args):
    """
    Runs a command in subprocess, showing output if it fails
    """

    try:
        subprocess.check_output(args, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        print(e.output)
        raise e


def files_description(version):
    return """

## Descriptions of the files
File | Description
------------ | -------------
tww_{version}_structure.sql | Contains the structure of tables and system schema content
tww_{version}_structure_with_value_lists.sql | Contains the structure of tables, system schema data and value lists data
tww_{version}_demo_data.backup | Data-only backup of the `tww_od` schema (i.e. ordinary data) from demonstration set of data
tww_{version}_structure_and_demo_data.backup | Complete backup with structure and data of the demonstration set of data

* If you plan to **use tww for production**, it is more likely you will be using the plain SQL `tww_{version}_structure_with_value_lists.sql`.
* If you want to **give a try at tww**, you will likely restore the `tww_{version}_structure_and_demo_data.backup` backup file.
""".format(version=version)


def create_dumps():
    """
    Creates all dumps
    :return: the files names in a list
    """
    file_s = create_plain_structure_only()
    file_v = create_plain_value_list(file_s)
    file_d = create_backup_data()
    file_b = create_backup_complete()
    return [file_s, file_v, file_d, file_b]


def create_plain_structure_only():
    """
    Create a plain SQL dump of data structure of all schemas and the content of pum_sys.inf
    :return: the file name of the dump
    """
    print('::group::plain SQL structure only')

    # structure
    dump_s = 'tww_{version}_structure.sql'.format(
        version=os.environ['CI_TAG'])

    print('Creating dump {}'.format(dump_s))
    dump_file_s = 'artifacts/{dump}'.format(dump=dump_s)
    _cmd(['pg_dump',
          '--format', 'plain',
          '--schema-only',
          '--file', dump_file_s,
          '--exclude-schema', 'public',
          '--no-owner',
          'tww_prod']
         )

    # dump all from tww_sys except logged_actions
    dump_i = 'tww_{version}_pum_info.sql'.format(
        version=os.environ['CI_TAG'])
    print('Creating dump {}'.format(dump_i))
    dump_file_i = 'artifacts/{dump}'.format(dump=dump_i)
    _cmd(['pg_dump',
          '--format', 'plain',
          '--data-only',
          '--file', dump_file_i,
          '--schema', 'tww_sys',
          '--exclude-table', 'tww_sys.logged_actions',
          'tww_prod']
         )
    print('Concatenating the 2 dumps')
    with open(dump_file_i) as f:
        dump_data = f.read()
    with open(dump_file_s, "a") as f:
        f.write(dump_data)

    print('::endgroup::')

    return dump_file_s


def create_plain_value_list(structure_dump_file):
    """
    Create a plain SQL dump of data structure (result of create_structure_only)
    with value list content
    :return: the file name of the dump
    """
    print('::group::value lists dump')

    dump = 'tww_{version}_structure_with_value_lists.sql'.format(
        version=os.environ['CI_TAG'])

    print('Creating dump {}'.format(dump))
    dump_file = 'artifacts/{dump}'.format(dump=dump)

    _cmd(['pg_dump',
          '--format', 'plain',
          '--blobs',
          '--data-only',
          '--file', dump_file,
          '--schema', 'tww_vl',
          'tww_prod']
         )

    print('Concatenating the 2 dumps')
    with open(dump_file) as f:
        dump_data = f.read()
    with open(structure_dump_file) as f:
        structure_dump_data = f.read()
    with open(dump_file, 'w') as f:
        f.write(structure_dump_data)
        f.write('\n\n\n-- Value lists dump --\n\n')
        f.write(dump_data)

    print('::endgroup::')

    return dump_file


def create_backup_data():
    """
    Create a data-only dump (without VL and pum_info)
    :return: the file name
    """
    # Create data-only dumps (with sample data)
    dump = 'tww_{version}_demo_data.backup'.format(
        version=os.environ['CI_TAG'])
    print('::group::{}'.format(dump))
    print('Creating dump {}'.format(dump))
    dump_file = 'artifacts/{dump}'.format(dump=dump)
    _cmd(['pg_dump',
          '--format', 'custom',
          '--blobs',
          '--data-only',
          '--compress', '5',
          '--file', dump_file,
          '--table', 'tww_od.*',
          '--table', 'tww_sys.logged_actions',
          'tww_prod']
         )
    print('::endgroup::')
    return dump_file


def create_backup_complete():
    """
    Create data + structure dump
    :return: the file name
    """
    # Create data + structure dumps (with sample data)
    dump = 'tww_{version}_structure_and_demo_data.backup'.format(
        version=os.environ['CI_TAG'])
    print('::group::{}'.format(dump))
    print('Creating dump {}'.format(dump))
    dump_file = 'artifacts/{dump}'.format(dump=dump)
    _cmd(['pg_dump',
          '--format', 'custom',
          '--blobs',
          '--compress', '5',
          '--file', dump_file,
          '-N', 'public',
          'tww_prod']
         )
    print('::endgroup::')

    return dump_file


def main():
    """
    Creates dumps to be attached to releases.
    """
    if 'CI_TAG' not in os.environ or not os.environ['CI_TAG']:
        print('No git tag: not deploying anything')
        return
    else:
        print('Creating release from tag {}'.format(os.environ['CI_TAG']))

    os.mkdir('artifacts')
    files = create_dumps()
    print('Dumps created: {}'.format(', '.join(files)))


if __name__ == "__main__":
    main()