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

import os


def plugin_root_path():
    """
    Returns the root path of the plugin
    """
    return os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
