try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg

from pum.core.deltapy import DeltaPy


class CreateViews(DeltaPy):
    def run(self):
        self.migrate_agxx_data()

    def migrate_agxx_data(self):
        conn = psycopg.connect(f"service={self.pg_service}")
        with conn.cursor() as cursor:
            ext_check= """
            SELECT *
            FROM information_schema.columns
            WHERE table_schema='tww_od'
            AND table_name='wastewater_node'
            AND column_name='ag96_is_gateway'
            """
            cursor.execute(ext_check)
            if cursor.fetchone():
                agxx_defs={
                "wastewater_node":['ag96_is_gateway','ag64_function'],
                "cover":['ag64_fk_wastewater_node'],
                "wastewater_structure":['ag96_fk_measure'],
                "reach":['ag96_clear_height_planned','ag96_clear_width_planned'],
                "catchment_area_totals":['ag96_sewer_infiltration_water_dim','ag96_waste_water_production_dim','ag96_perimeter_geometry'],
                "building_group":['ag96_owner_address','ag96_owner_name','ag96_label_number','ag96_disposal_wastewater','ag96_disposal_industrial_wastewater','ag96_disposal_square_water','ag96_disposal_roof_water','ag96_population'],
                "wastewater_networkelement":['ag96_fk_provider','ag96_remark','ag64_fk_provider','ag64_remark'],
                "overflow":['ag96_fk_provider','ag96_remark','ag64_fk_provider','ag64_remark'],
                "infiltration_zone":['ag96_permeability','ag96_limitation','ag96_thickness','ag96_q_check'],
                }
                query=[]
                for key in agxx_defs:
                    query.append( f"""INSERT INTO tww_od.agxx_{key}(obj_id, {', '.join(agxx_defs[key])})
                        SELECT obj_id, {', '.join(agxx_defs[key])}
                        FROM tww_od.{key};"""
                    )
                    for val in agxx_defs[key]:
                        query.append(f"ALTER TABLE tww_od.{key} DROP COLUMN {val} CASCADE;")
                modification_defs=["wastewater_networkelement","overflow"]
                for key in modification_defs:
                    query.append( f"""INSERT INTO tww_od.agxx_last_modification(obj_id, ag64_last_modification, ag96_last_modification)
                        SELECT obj_id, ag64_last_modification, ag96_last_modification
                        FROM tww_od.{key};"""
                    )
                    for val in ['ag64_last_modification', 'ag96_last_modification']:
                        query.append(f"ALTER TABLE tww_od.{key} DROP COLUMN {val} CASCADE;")
                cursor.execute('\n'.join(query))
        conn.close()
