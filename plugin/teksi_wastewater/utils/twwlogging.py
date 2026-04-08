# -----------------------------------------------------------
#
# Profile
# Copyright (C) 2013  Matthias Kuhn
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
# with this progsram; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------

"""
This module is used for logging in TWW.
"""

import logging

from qgis.core import Qgis, QgsApplication, QgsMessageLog


class TwwQgsLogHandler(logging.Handler):
    """
    A class acting as a translator between pythons log system and the QGIS log
    system.
    """

    qgsMessageLog = QgsApplication.messageLog()

    def emit(self, record):
        """
        Will be called by pythons logging and is the actual bridge
        @param record: The record to be logged
        """

        # Translate Python logging levels to QGIS message levels.
        level = {
            logging.DEBUG: Qgis.Info,
            logging.INFO: Qgis.Info,
            logging.WARNING: Qgis.Warning,
            logging.ERROR: Qgis.Critical,
            logging.CRITICAL: Qgis.Critical,
        }.get(record.levelno, Qgis.Info)

        QgsMessageLog.logMessage(
            record.name + ": " + self.format(record),
            "tww",
            level,
        )
