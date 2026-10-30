# -----------------------------------------------------------
#
# Elevation Profile Widget — Compatibility re-export
# Copyright (C) 2026  TEKSI Contributors and Peter Zhao
# -----------------------------------------------------------
#
# licensed under the terms of GNU GPL 2
#
# This file exists only for backward compatibility.
# All implementation has been moved to gui/profile/.
# Do not add new logic here.
#
# ---------------------------------------------------------------------

from .profile.canvas import TwwElevationProfileCanvas  # noqa: F401
from .profile.widget import TwwElevationProfileWidget  # noqa: F401
