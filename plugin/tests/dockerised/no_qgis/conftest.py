import sys

import pytest


@pytest.fixture(autouse=True)
def forbid_qgis_import(request, monkeypatch):
    if request.node.get_closest_marker("no_qgis"):
        monkeypatch.setitem(sys.modules, "qgis", None)
