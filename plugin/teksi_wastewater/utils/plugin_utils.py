"""
/***************************************************************************
 Plugin Utils
                              -------------------
        begin                : 28.4.2018
        copyright            : (C) 2018 by OPENGIS.ch
        email                : matthias@opengis.ch
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

import logging
import os


def plugin_root_path():
    """
    Returns the root path of the plugin
    """
    return os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))


class DeduplicatedLogger(logging.Logger):
    """Logger that deduplicates messages

    Multiple subsequent logging with the same message/level will result in [repeated N times]
    message instead of many lines.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._last_message = None
        self._repeated = 0

    def _log(self, level, msg, args, exc_info=None, extra=None, stacklevel=1):
        this_message = (level, msg)
        if self._last_message is None or self._last_message != this_message:
            if self._repeated > 0:
                super()._log(
                    self._last_message[0],
                    f"[repeated {self._repeated} times]",
                    args,
                    exc_info,
                    extra,
                    stacklevel,
                )

            super()._log(level, msg, args, exc_info, extra)
            self._repeated = 0
        else:
            self._repeated += 1
        self._last_message = this_message


logging.setLoggerClass(DeduplicatedLogger)
logger = logging.getLogger(__package__)
