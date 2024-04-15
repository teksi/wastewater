#!/usr/bin/env python3


try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pum.core.deltapy import DeltaPy
from view.create_views import create_views

# sys.path.append(os.path.join(os.path.dirname(__file__), ".."))


class CreateViews(DeltaPy):
    def run(self):
        tww_wastewater_structure_extra = self.variables.get("tww_wastewater_structure_extra", None)
        tww_reach_extra = self.variables.get("tww_reach_extra", None)

        if not self.variables.get("SRID"):
            raise RuntimeError(
                "SRID not specified. Add `-v int SRID 2056` (or the corresponding EPSG code) to the upgrade command."
            )
        create_views(
            srid=self.variables.get("SRID"),
            pg_service=self.pg_service,
            tww_wastewater_structure_extra=tww_wastewater_structure_extra,
            tww_reach_extra=tww_reach_extra,
        )

        # refresh network views
        conn = psycopg.connect(f"service={self.pg_service}")
        cursor = conn.cursor()
        cursor.execute("SELECT tww_app.network_refresh_network_simple();")
        conn.commit()
        conn.close()
