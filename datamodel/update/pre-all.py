#!/usr/bin/env python3


# sys.path.append(os.path.join(os.path.dirname(__file__), ".."))

from pkg_resources import DistributionNotFound, get_distribution, parse_version
from pum.core.deltapy import DeltaPy
from view.create_views import drop_views

# Older verisons of pum and pirogue can create issues such as reapplying deltas whose checksum have changed,
# or create columuns in views in a non-deterministic order. To avoid causing trouble in user's database,
# we check these versions here before doing anything
MIN_PUM = "0.10.0"
MIN_PIROGUE = "1.4.1"


class CheckLibraryVersions(DeltaPy):
    def run(self):
        # check pum
        try:
            if get_distribution("pum").parsed_version < parse_version(MIN_PUM):
                raise RuntimeError
        except (RuntimeError, DistributionNotFound):
            raise RuntimeError(
                f"You need pum {MIN_PUM} or newer to proceed. Run `pip install pum --upgrade` before continuing"
            )

        # check pirogue
        try:
            if get_distribution("pirogue").parsed_version < parse_version(MIN_PIROGUE):
                raise RuntimeError
        except (RuntimeError, DistributionNotFound):
            raise RuntimeError(
                f"You need pirogue {MIN_PIROGUE} or newer to proceed. Run `pip install pirogue --upgrade` before continuing"
            )


class DropViews(DeltaPy):
    def run(self):
        drop_views(pg_service=self.pg_service)
