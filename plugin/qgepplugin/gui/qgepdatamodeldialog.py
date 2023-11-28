# -*- coding: utf-8 -*-
# -----------------------------------------------------------
#
# Profile
# Copyright (C) 2021  Olivier Dalang
# -----------------------------------------------------------
#
# licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, print to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------
import configparser
import functools
from typing import Optional
import os
import subprocess
import tempfile
from pathlib import Path
from pkg_resources.extern.packaging.version import Version
from pkg_resources import parse_version
import pkg_resources
import psycopg2
from qgis.core import (
    Qgis,
    QgsApplication,
    QgsMessageLog,
    QgsProject,
)
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import (
    QApplication,
    QDialog,
    QMessageBox,
    QProgressDialog,
    QPushButton,
)

from ..utils import get_ui_class

# Path for pg_service.conf
PG_CONFIG_PATH_KNOWN = True
if os.environ.get("PGSERVICEFILE"):
    PG_CONFIG_PATH = os.environ.get("PGSERVICEFILE")
elif os.environ.get("PGSYSCONFDIR"):
    PG_CONFIG_PATH = os.path.join(os.environ.get("PGSYSCONFDIR"), "pg_service.conf")
elif os.path.exists("~/.pg_service.conf"):
    PG_CONFIG_PATH = "~/.pg_service.conf"
else:
    PG_CONFIG_PATH_KNOWN = False
    PG_CONFIG_PATH = os.path.join(
        QgsApplication.qgisSettingsDirPath(), "pg_service.conf"
    )

PLUGIN_FOLDER = Path(__file__).parent.parent
DATAMODEL_PATH = PLUGIN_FOLDER / "datamodel"
REQUIREMENTS_PATH = DATAMODEL_PATH / "requirements.txt"
DELTAS_PATH = DATAMODEL_PATH / "delta"
INIT_SCRIPT_PATH = (
    DATAMODEL_PATH / "init" / "qgep_1.5.6-1_structure_with_value_lists.sql"
)
QGISPROJECT_PATH = PLUGIN_FOLDER / "project" / "qgep.qgs"


def qgep_datamodel_error_catcher(func):
    """Display QGEPDatamodelError in error messages rather than normal exception dialog"""

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except QGEPDatamodelError as e:
            args[0]._show_error(str(e))

    return wrapper


class QGEPDatamodelError(Exception):
    pass


class QgepPgserviceEditorDialog(QDialog, get_ui_class("qgeppgserviceeditordialog.ui")):
    def __init__(self, cur_name, cur_config, taken_names):
        super().__init__()
        self.setupUi(self)
        self.taken_names = taken_names
        self.nameLineEdit.textChanged.connect(self.check_name)
        self.pgconfigUserCheckBox.toggled.connect(self.pgconfigUserLineEdit.setEnabled)
        self.pgconfigPasswordCheckBox.toggled.connect(
            self.pgconfigPasswordLineEdit.setEnabled
        )

        self.nameLineEdit.setText(cur_name)
        self.pgconfigHostLineEdit.setText(cur_config.get("host", ""))
        self.pgconfigPortLineEdit.setText(cur_config.get("port", ""))
        self.pgconfigDbLineEdit.setText(cur_config.get("dbname", ""))
        self.pgconfigUserLineEdit.setText(cur_config.get("user", ""))
        self.pgconfigPasswordLineEdit.setText(cur_config.get("password", ""))

        self.pgconfigUserCheckBox.setChecked(cur_config.get("user") is not None)
        self.pgconfigPasswordCheckBox.setChecked(cur_config.get("password") is not None)
        self.pgconfigUserLineEdit.setEnabled(cur_config.get("user") is not None)
        self.pgconfigPasswordLineEdit.setEnabled(cur_config.get("password") is not None)

        self.check_name(cur_name)

    def check_name(self, new_text):
        if new_text in self.taken_names:
            self.nameCheckLabel.setText("will overwrite")
            self.nameCheckLabel.setStyleSheet(
                "color: rgb(170, 95, 0);\nfont-weight: bold;"
            )
        else:
            self.nameCheckLabel.setText("will be created")
            self.nameCheckLabel.setStyleSheet(
                "color: rgb(0, 170, 0);\nfont-weight: bold;"
            )

    def conf_name(self):
        return self.nameLineEdit.text()

    def conf_dict(self):
        retval = {
            "host": self.pgconfigHostLineEdit.text(),
            "port": self.pgconfigPortLineEdit.text(),
            "dbname": self.pgconfigDbLineEdit.text(),
        }
        if self.pgconfigUserCheckBox.isChecked():
            retval.update(
                {
                    "user": self.pgconfigUserLineEdit.text(),
                }
            )
        if self.pgconfigPasswordCheckBox.isChecked():
            retval.update(
                {
                    "password": self.pgconfigPasswordLineEdit.text(),
                }
            )
        return retval


class QgepDatamodelInitToolDialog(QDialog, get_ui_class("qgepdatamodeldialog.ui")):
    def __init__(self, parent=None):
        QDialog.__init__(self, parent)
        self.setupUi(self)

        self.progress_dialog = None

        # Show the pgconfig path
        path_label = PG_CONFIG_PATH
        if not PG_CONFIG_PATH_KNOWN:
            self.pgservicePathLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-style: italic;"
            )
            path_label += f"<br/>Note: you must create a PGSYSCONFDIR variable for this configuration to work.</span>More info <a href='https://gis.stackexchange.com/a/393494'>here</a>."
            self.pgservicePathLabel.setTextFormat(Qt.RichText)
            self.pgservicePathLabel.setTextInteractionFlags(Qt.TextBrowserInteraction)
            self.pgservicePathLabel.setWordWrap(True)
        self.pgservicePathLabel.setText(path_label)

        # Connect some signals

        self.installDepsButton.pressed.connect(self.install_requirements)

        self.pgserviceComboBox.activated.connect(self.select_pgconfig)
        self.pgserviceAddButton.pressed.connect(self.add_pgconfig)

        self.versionUpgradeButton.pressed.connect(self.upgrade_version)
        self.initializeButton.pressed.connect(self.initialize_version)

        self.loadProjectButton.pressed.connect(self.load_project)

        # Initialize the checks
        self.checks = {
            "datamodel": False,
            "requirements": False,
            "pgconfig": False,
            "current_version": False,
            "project": False,
        }
        self.check_datamodel()
        self.check_requirements()
        self.check_version()
        self.check_project()

    # Properties

    @property
    def conf(self):
        return self.pgserviceComboBox.currentData()

    # Feedback helpers

    def _show_progress(self, message):
        if self.progress_dialog is None:
            self.progress_dialog = QProgressDialog(
                self.tr("Starting..."), self.tr("Cancel"), 0, 0
            )
            cancel_button = QPushButton(self.tr("Cancel"))
            cancel_button.setEnabled(False)
            self.progress_dialog.setCancelButton(cancel_button)
        self.progress_dialog.setLabelText(message)
        self.progress_dialog.show()
        QApplication.processEvents()

    def _done_progress(self):
        self.progress_dialog.close()
        self.progress_dialog.deleteLater()
        self.progress_dialog = None
        QApplication.processEvents()

    def _show_error(self, message):
        self._done_progress()
        err = QMessageBox()
        err.setText(message)
        err.setIcon(QMessageBox.Warning)
        err.exec_()

    # Actions helpers

    def _run_sql(
        self,
        sql_command,
        master_db=False,
        autocommit=False,
        returns=False,
        error_message="Psycopg error, see logs for more information",
    ):
        results = None
        connection_string = f"service={self.conf}"
        if master_db:
            connection_string += f" dbname=postgres"
        QgsMessageLog.logMessage(
            f"Running query against {connection_string}: {sql_command}", "QGEP"
        )
        try:
            conn = psycopg2.connect(connection_string)
            if autocommit:
                conn.autocommit = True
            cur = conn.cursor()
            cur.execute(sql_command)
            if returns:
                results = cur.fetchall()
            conn.commit()
            cur.close()
            conn.close()
        except psycopg2.Error as e:
            message = f"{error_message}\nCommand :\n{sql_command}\n{e}"
            raise QGEPDatamodelError(message)
        return results

    def _run_cmd(
        self,
        shell_command,
        cwd=None,
        error_message="Subprocess error, see logs for more information",
        timeout=10,
    ):
        """
        Helper to run commands through subprocess
        """
        QgsMessageLog.logMessage(f"Running command : {shell_command}", "QGEP")
        result = subprocess.run(
            shell_command,
            cwd=cwd,
            shell=True,
            capture_output=True,
            timeout=timeout,
        )
        if result.stdout:
            stdout = result.stdout.decode("utf-8", errors="replace")
            QgsMessageLog.logMessage(stdout, "QGEP")
        else:
            stdout = None
        if result.stderr:
            stderr = result.stderr.decode("utf-8", errors="replace")
            QgsMessageLog.logMessage(stderr, "QGEP", level=Qgis.Critical)
        else:
            stderr = None
        if result.returncode:
            message = f"{error_message}\nCommand :\n{shell_command}"
            message += f"\n\nOutput :\n{stdout}"
            message += f"\n\nError :\n{stderr}"
            raise QGEPDatamodelError(message)
        return stdout

    def _read_pgservice(self):
        config = configparser.ConfigParser()
        if os.path.exists(PG_CONFIG_PATH):
            config.read(PG_CONFIG_PATH)
        return config

    def _write_pgservice_conf(self, service_name, config_dict):
        config = self._read_pgservice()
        config[service_name] = config_dict

        class EqualsSpaceRemover:
            # see https://stackoverflow.com/a/25084055/13690651
            output_file = None

            def __init__(self, output_file):
                self.output_file = output_file

            def write(self, content):
                content = content.replace(" = ", "=", 1)
                self.output_file.write(content.encode("utf-8"))

        config.write(EqualsSpaceRemover(open(PG_CONFIG_PATH, "wb")))

    def _get_current_version(self) -> Optional[Version]:
        max_version = None

        results = self._run_sql(
            "SELECT version FROM qgep_sys.pum_info;",
            returns=True,
            error_message="Could not retrieve versions from pum_info table",
        )
        for (version_str,) in results:
            version = parse_version(version_str)
            if max_version is None or version > max_version:
                max_version = version

        return max_version

    def _get_target_version(self) -> Version:
        """Returns the target version, ie the highest version present in the delta folder"""

        max_version = None
        for filename in os.listdir(DELTAS_PATH):
            if filename.startswith("delta_"):
                version = parse_version(filename[6:].split("_")[0])
                if max_version is None or version > max_version:
                    max_version = version

        assert max_version is not None

        return max_version

    # Display

    def showEvent(self, event):
        self.update_pgconfig_combobox()
        self.check_requirements()
        self.check_pgconfig()
        self.check_version()
        self.check_project()
        super().showEvent(event)

    def enable_buttons_if_ready(self):
        QgsMessageLog.logMessage(f"Checks: {self.checks}", "QGEP")
        self.installDepsButton.setEnabled(not self.checks["requirements"])
        self.versionUpgradeButton.setEnabled(all(self.checks.values()))
        self.loadProjectButton.setEnabled(self.checks["project"])

    # Datamodel

    def check_datamodel(self):
        # in theory, this check is useless, because the datamodel files are now embedded in the plugin,
        # but since a symlink is involved, we keep the check as it could not work under certain circumstances
        # (e.g. dev on Windows)

        target_version = self._get_target_version()

        check = bool(target_version)

        if check:
            self.targetVersionLabel.setText(f"{target_version}")
            self.targetVersionLabel.setStyleSheet(
                "color: rgb(0, 170, 0);\nfont-weight: bold;"
            )
        else:
            self.targetVersionLabel.setText("not found")
            self.targetVersionLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        self.checks["datamodel"] = check
        self.enable_buttons_if_ready()

        return check

    # Requirements

    def check_requirements(self):

        missing = []
        requirements = pkg_resources.parse_requirements(open(REQUIREMENTS_PATH))
        for requirement in requirements:
            try:
                pkg_resources.require(str(requirement))
            except pkg_resources.DistributionNotFound:
                missing.append((requirement, "missing"))
            except pkg_resources < Conflict:
                missing.append((requirement, "conflict"))

        check = len(missing) == 0

        if check:
            self.pythonCheckLabel.setText("ok")
            self.pythonCheckLabel.setStyleSheet(
                "color: rgb(0, 170, 0);\nfont-weight: bold;"
            )
        else:
            self.pythonCheckLabel.setText(
                "\n".join(f"{dep}: {err}" for dep, err in missing)
            )
            self.pythonCheckLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        self.checks["requirements"] = check
        self.enable_buttons_if_ready()

        return check

    @qgep_datamodel_error_catcher
    def install_requirements(self):

        # TODO : Ideally, this should be done in a venv, as to avoid permission issues and/or modification
        # of libraries versions that could affect other parts of the system.
        # We could initialize a venv in the user's directory, and activate it.
        # It's almost doable when only running commands from the command line (in which case we could
        # just prepent something like `path/to/venv/Scripts/activate && ` to commands, /!\ syntax differs on Windows),
        # but to be really useful, it would be best to then enable the virtualenv from within python directly.
        # It seems venv doesn't provide a way to do so, while virtualenv does
        # (see https://stackoverflow.com/a/33637378/13690651)
        # but virtualenv isn't in the stdlib... So we'd have to install it globally ! Argh...
        # Anyway, pip deps support should be done in QGIS one day so all plugins can benefit.
        # In the mean time we just install globally and hope for the best.

        self._show_progress("Installing python dependencies with pip")

        # Install dependencies
        QgsMessageLog.logMessage(
            f"Installing python dependencies from {REQUIREMENTS_PATH}", "QGEP"
        )
        dependencies = " ".join(
            [
                f'"{l.strip()}"'
                for l in open(REQUIREMENTS_PATH, "r").read().splitlines()
                if l.strip()
            ]
        )
        command_line = "the OSGeo4W shell" if os.name == "nt" else "the terminal"
        self._run_cmd(
            f"python3 -m pip install --user {dependencies}",
            error_message=f"Could not install python dependencies. You can try to run the command manually from {command_line}.",
            timeout=None,
        )

        self._done_progress()

        # Update UI
        self.check_requirements()

    # Pgservice

    def check_pgconfig(self):

        check = bool(self.pgserviceComboBox.currentData())
        if check:
            self.pgconfigCheckLabel.setText("ok")
            self.pgconfigCheckLabel.setStyleSheet(
                "color: rgb(0, 170, 0);\nfont-weight: bold;"
            )
        else:
            self.pgconfigCheckLabel.setText("not set")
            self.pgconfigCheckLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        self.checks["pgconfig"] = check
        self.enable_buttons_if_ready()

        return check

    def add_pgconfig(self):
        taken_names = self._read_pgservice().sections()
        if self.conf in self._read_pgservice():
            cur_config = self._read_pgservice()[self.conf]
        else:
            cur_config = {}

        add_dialog = QgepPgserviceEditorDialog(self.conf, cur_config, taken_names)
        if add_dialog.exec_() == QDialog.Accepted:
            name = add_dialog.conf_name()
            conf = add_dialog.conf_dict()
            self._write_pgservice_conf(name, conf)
            self.update_pgconfig_combobox()
            self.pgserviceComboBox.setCurrentIndex(
                self.pgserviceComboBox.findData(name)
            )
            self.select_pgconfig()

    def update_pgconfig_combobox(self):
        self.pgserviceComboBox.clear()
        for config_name in self._read_pgservice().sections():
            self.pgserviceComboBox.addItem(config_name, config_name)
        self.pgserviceComboBox.setCurrentIndex(0)

    def select_pgconfig(self, _=None):
        config = self._read_pgservice()
        if self.conf in config.sections():
            host = config.get(self.conf, "host", fallback="-")
            port = config.get(self.conf, "port", fallback="-")
            dbname = config.get(self.conf, "dbname", fallback="-")
            user = config.get(self.conf, "user", fallback="-")
            password = (
                len(config.get(self.conf, "password", fallback="")) * "*"
            ) or "-"
            self.pgserviceCurrentLabel.setText(
                f"host: {host}:{port}\ndbname: {dbname}\nuser: {user}\npassword: {password}"
            )
        else:
            self.pgserviceCurrentLabel.setText("-")
        self.check_pgconfig()
        self.check_version()
        self.check_project()

    # Version

    @qgep_datamodel_error_catcher
    def check_version(self, _=None):
        check = False

        # target version

        target_version = self._get_target_version()

        # current version

        self.initializeButton.setVisible(False)
        self.versionUpgradeButton.setVisible(True)

        pgservice = self.pgserviceComboBox.currentData()
        if not pgservice:
            self.versionCheckLabel.setText("service not selected")
            self.versionCheckLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        elif not target_version:
            self.versionCheckLabel.setText("no delta in datamodel")
            self.versionCheckLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        else:

            error = None
            current_version = None
            connection_works = True

            try:
                current_version = self._get_current_version()
            except QGEPDatamodelError:
                # Can happend if PUM is not initialized, unfortunately we can't really
                # determine if this is a connection error or if PUM is not initailized
                # see https://github.com/opengisch/pum/issues/96
                # We'll try to connect to see if it's a connection error
                error = "qgep not initialized"
                try:
                    self._run_sql(
                        "SELECT 1;",
                        error_message="Errors when initializing the database.",
                    )
                except QGEPDatamodelError:
                    error = "database does not exist"
                    try:
                        self._run_sql(
                            "SELECT 1;",
                            master_db=True,
                            error_message="Errors when initializing the database.",
                        )
                    except QGEPDatamodelError:
                        error = "could not connect to database"
                        connection_works = False

            if not connection_works:
                check = False
                self.versionCheckLabel.setText(error)
                self.versionCheckLabel.setStyleSheet(
                    "color: rgb(170, 0, 0);\nfont-weight: bold;"
                )
            elif error is not None:
                check = False
                self.versionCheckLabel.setText(error)
                self.versionCheckLabel.setStyleSheet(
                    "color: rgb(170, 95, 0);\nfont-weight: bold;"
                )
            elif current_version <= target_version:
                check = True
                self.versionCheckLabel.setText(f"{current_version}")
                self.versionCheckLabel.setStyleSheet(
                    "color: rgb(0, 170, 0);\nfont-weight: bold;"
                )
            elif current_version > target_version:
                check = False
                self.versionCheckLabel.setText(f"{current_version} (cannot downgrade)")
                self.versionCheckLabel.setStyleSheet(
                    "color: rgb(170, 0, 0);\nfont-weight: bold;"
                )
            else:
                check = False
                self.versionCheckLabel.setText(f"{current_version} (invalid version)")
                self.versionCheckLabel.setStyleSheet(
                    "color: rgb(170, 0, 0);\nfont-weight: bold;"
                )

            self.initializeButton.setVisible(
                current_version is None and connection_works
            )
            self.versionUpgradeButton.setVisible(current_version is not None)

        self.checks["current_version"] = check
        self.enable_buttons_if_ready()

        return check

    @qgep_datamodel_error_catcher
    def initialize_version(self):

        confirm = QMessageBox()
        confirm.setText(f"You are about to initialize the datamodel on {self.conf}. ")
        confirm.setInformativeText(
            "Please confirm that you have a backup of your data as this operation can result in data loss."
        )
        confirm.setStandardButtons(QMessageBox.Apply | QMessageBox.Cancel)
        confirm.setIcon(QMessageBox.Warning)

        if confirm.exec_() == QMessageBox.Apply:

            self._show_progress("Initializing the datamodel")

            srid = self.sridLineEdit.text()

            # If we can't get current version, it's probably that the DB is not initialized
            # (or maybe we can't connect, but we can't know easily with PUM)

            self._show_progress("Initializing the datamodel")

            # TODO : this should be done by PUM directly (see https://github.com/opengisch/pum/issues/94)

            # Dirty hack to customize SRID in a dump
            init_script_path = INIT_SCRIPT_PATH
            if srid != "2056":
                with open(INIT_SCRIPT_PATH, "r", encoding="utf8") as file:
                    contents = file.read()
                contents = contents.replace("2056", srid)
                init_script_path = tempfile.NamedTemporaryFile(
                    suffix=".sql", delete=False
                )
                with open(init_script_path, "w", encoding="utf8") as file:
                    file.write(contents)

            try:
                try:
                    conn = psycopg2.connect(f"service={self.conf}")
                except psycopg2.Error:
                    # It may be that the database doesn't exist yet
                    # in that case, we try to connect to the postgres database and to create it from there
                    self._show_progress("Creating the database")
                    dbname = self._read_pgservice()[self.conf]["dbname"]
                    self._run_sql(
                        f"CREATE DATABASE {dbname};",
                        autocommit=True,
                        master_db=True,
                        error_message="Could not create a new database.",
                    )

                self._show_progress("Running the initialization scripts")
                self._run_sql(
                    "CREATE EXTENSION IF NOT EXISTS postgis;",
                    error_message="Errors when initializing the database.",
                )
                # we cannot use this, as it doesn't support COPY statements
                # this means we'll run through psql without transaction :-/
                # cur.execute(open(sql_path, "r").read())
                self._run_cmd(
                    f'psql -f {init_script_path} "service={self.conf}"',
                    error_message="Errors when initializing the database.",
                    timeout=300,
                )
                # workaround until https://github.com/QGEP/QGEP/issues/612 is fixed
                self._run_sql(
                    "SELECT qgep_network.refresh_network_simple();",
                    error_message="Errors when initializing the database.",
                )

            except psycopg2.Error as e:
                raise QGEPDatamodelError(str(e))

            self.check_version()
            self.check_project()

            self._done_progress()

            success = QMessageBox()
            success.setText(
                "Datamodel successfully initialized, will now proceed to upgrade."
            )
            success.setIcon(QMessageBox.Information)
            success.exec_()

            self.upgrade_version(skip_confirmation=True)

    @qgep_datamodel_error_catcher
    def upgrade_version(self, skip_confirmation=False):

        target_version = self._get_target_version()

        confirm = QMessageBox()
        confirm.setText(
            f"You are about to update the datamodel on {self.conf} to version {target_version}."
        )
        confirm.setInformativeText(
            "Please confirm that you have a backup of your data as this operation can result in data loss."
        )
        confirm.setStandardButtons(QMessageBox.Apply | QMessageBox.Cancel)
        confirm.setIcon(QMessageBox.Warning)

        if skip_confirmation or confirm.exec_() == QMessageBox.Apply:

            self._show_progress("Upgrading the datamodel")

            srid = self.sridLineEdit.text()

            self._show_progress("Running pum upgrade")
            self._run_cmd(
                f"python3 -m pum upgrade -p {self.conf} -t qgep_sys.pum_info -d {DELTAS_PATH} -u {target_version} -v int SRID {srid}",
                cwd=os.path.dirname(DELTAS_PATH),
                error_message="Errors when upgrading the database.",
                timeout=300,
            )

            self.check_version()
            self.check_project()

            self._done_progress()

            success = QMessageBox()
            success.setText("Datamodel successfully upgraded")
            success.setIcon(QMessageBox.Information)
            success.exec_()

    # Project

    @qgep_datamodel_error_catcher
    def check_project(self):

        try:
            current_version = self._get_current_version()
        except QGEPDatamodelError:
            # Can happend if PUM is not initialized, unfortunately we can't really
            # determine if this is a connection error or if PUM is not initailized
            # see https://github.com/opengisch/pum/issues/96
            current_version = None

        check = current_version is not None

        if check:
            self.projectCheckLabel.setText("ok")
            self.projectCheckLabel.setStyleSheet(
                "color: rgb(0, 170, 0);\nfont-weight: bold;"
            )
        else:
            self.projectCheckLabel.setText("version not found")
            self.projectCheckLabel.setStyleSheet(
                "color: rgb(170, 0, 0);\nfont-weight: bold;"
            )

        self.checks["project"] = check
        self.enable_buttons_if_ready()

        return check

    @qgep_datamodel_error_catcher
    def load_project(self):
        with open(QGISPROJECT_PATH, "r") as original_project:
            contents = original_project.read()

        # replace the service name
        contents = contents.replace("service='pg_qgep'", f"service='{self.conf}'")

        output_file = tempfile.NamedTemporaryFile(suffix=".qgs", delete=False)
        output_file.write(contents.encode("utf8"))

        QgsProject.instance().read(output_file.name)
