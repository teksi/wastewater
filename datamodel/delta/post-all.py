#!/usr/bin/env python3

import sys, os
import psycopg2
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from pum.core.deltapy import DeltaPy
from view.create_views import create_views


class CreateViews(DeltaPy):

    def run(self):
        qgep_wastewater_structure_extra = self.variables.get('qgep_wastewater_structure_extra', None)
        qgep_reach_extra = self.variables.get('qgep_reach_extra', None)

        if not self.variables.get('SRID'):
            raise RuntimeError('SRID not specified. Add `-v int SRID 2056` (or the corresponding EPSG code) to the upgrade command.')
        create_views(srid=self.variables.get('SRID'),
                     pg_service=self.pg_service,
                     qgep_wastewater_structure_extra=qgep_wastewater_structure_extra,
                     qgep_reach_extra=qgep_reach_extra)

        # refresh network views
        conn = psycopg2.connect("service={0}".format(self.pg_service))
        cursor = conn.cursor()
        cursor.execute('SELECT qgep_network.refresh_network_simple();')
        conn.commit()
        conn.close()
