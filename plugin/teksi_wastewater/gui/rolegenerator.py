# -----------------------------------------------------------
#
# TEKSI Wastewater
# Copyright (C) 2024 TEKSI
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

import logging

from qgis.PyQt.QtCore import pyqtSlot
from qgis.PyQt.QtWidgets import QDockWidget

from ..tools.manage_roles import create_roles, grant_privileges, revoke_privileges
from ..utils import get_ui_class
from ..utils.database_utils import DatabaseUtils

DOCK_WIDGET = get_ui_class("rolegenerator.ui")


class RoleGeneratorGui(QDockWidget, DOCK_WIDGET):
    logger = logging.getLogger(__name__)

    def __init__(self, parent, iface):
        QDockWidget.__init__(self, parent)
        self.setupUi(self)
        self.initPgServiceComboBox()
        self.accepted.connect(self.onAccept)

    def initPgServiceComboBox(self):
        config, _ = DatabaseUtils.list_pgservice()
        for pgservice in config.sections():
            self.pgserviceComboBox.addItem(pgservice)

    @pyqtSlot()
    def onAccept(self):
        logging.getLogger("tww")
        # General settings
        role_args = {"pg_service": self.pgserviceComboBox.currentText(), "modulename": "tww"}
        if self.addDbSpecRolesCheckBox.isChecked():
            role_args["db_spec_roles"] = True

        if self.CreateRolesCheckBox.isChecked():
            create_roles(**role_args)
        if self.GrantRolesOnDBCheckBox.isChecked():
            grant_privileges(**role_args)
        if self.GrantRolesOnDBCheckBox.isChecked():
            revoke_privileges(**role_args)
