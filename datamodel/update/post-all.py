#!/usr/bin/env python3


try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pum.core.deltapy import DeltaPy
from ..app.create_app import create_app

# sys.path.append(os.path.join(os.path.dirname(__file__), ".."))


class CreateViews(DeltaPy):
    def run(self):
        extension_names = self.variables.get("extension_names", [])

        if not self.variables.get("SRID"):
            raise RuntimeError(
                "SRID not specified. Add `-v int SRID 2056` (or the corresponding EPSG code) to the upgrade command."
            )
        create_app(
            srid=self.variables.get("SRID"),
            pg_service=self.pg_service,
            extension_names=extension_names,
        )

        # refresh network views
        conn = psycopg.connect(f"service={self.pg_service}")
        cursor = conn.cursor()
        cursor.execute("SELECT tww_app.network_refresh_network_simple();")
        conn.commit()
        conn.close()
