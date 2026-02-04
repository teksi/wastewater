DROP MATERIALIZED VIEW IF EXISTS tww_app.vw_labeling_inlets_outlets CASCADE;
CREATE MATERIALIZED VIEW tww_app.vw_labeling_inlets_outlets
AS
 WITH inlet AS (
    SELECT ne.obj_id AS obj_id_ne,
    ne.identifier AS network_element_identifier,
        CASE
            WHEN st_length(re.progression3d_geometry) > 1::double precision THEN st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 1::double precision - 1::double precision / st_length(re.progression3d_geometry))
            WHEN st_length(re.progression3d_geometry) < 1::double precision THEN st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 0.7::double precision)
            ELSE st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 0.000001::double precision)
        END AS geom,
    rp.level,
    rp.obj_id AS obj_id_rp,
    usg_curr.value_de AS usage_current,
    stat.value_de AS astatus,
    re.obj_id AS fk_reach,
    wn.obj_id AS fk_wastewater_node,
    'inlet'::text AS type
    FROM tww_od.wastewater_networkelement ne
        LEFT JOIN tww_od.reach_point rp ON rp.fk_wastewater_networkelement::text = ne.obj_id::text
        LEFT JOIN tww_od.reach re ON re.fk_reach_point_to::text = rp.obj_id::text
        LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
        LEFT JOIN tww_vl.wastewater_structure_status stat ON ws.status = stat.code
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id::text = ws.fk_main_wastewater_node::text
        LEFT JOIN tww_vl.channel_usage_current usg_curr ON wn._usage_current = usg_curr.code
    WHERE re.progression3d_geometry IS NOT NULL AND wn.obj_id IS NOT NULL
    ORDER BY rp.level DESC
), 
outlet AS (
    SELECT ne.obj_id AS obj_id_ne,
    ne.identifier AS network_element_identifier,
        CASE
            WHEN st_length(re.progression3d_geometry) > 1::double precision THEN st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 1::double precision / st_length(re.progression3d_geometry))
            WHEN st_length(re.progression3d_geometry) < 1::double precision THEN st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 0.7::double precision)
            ELSE st_lineinterpolatepoint(st_geomfromtext(st_astext(st_curvetoline(re.progression3d_geometry)), 2056), 0.000001::double precision)
        END AS geom,
    rp.level,
    rp.obj_id AS obj_id_rp,
    usg_curr.value_de AS usage_current,
    stat.value_de AS astatus,
    re.obj_id AS fk_reach,
    wn.obj_id AS fk_wastewater_node,
    'outlet'::text AS type
    FROM tww_od.wastewater_networkelement ne
        LEFT JOIN tww_od.reach_point rp ON rp.fk_wastewater_networkelement::text = ne.obj_id::text
        LEFT JOIN tww_od.reach re ON re.fk_reach_point_from::text = rp.obj_id::text
        LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
        LEFT JOIN tww_vl.wastewater_structure_status stat ON ws.status = stat.code
        LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id::text = ws.fk_main_wastewater_node::text
        LEFT JOIN tww_vl.channel_usage_current usg_curr ON wn._usage_current = usg_curr.code
    WHERE re.progression3d_geometry IS NOT NULL AND wn.obj_id IS NOT NULL
    ORDER BY rp.level DESC
)
 SELECT uuid_generate_v4() AS _uuid,
    i.obj_id_ne,
    i.network_element_identifier,
    st_force2d(i.geom) AS geom,
    COALESCE(i.level::text, '?'::text) AS level,
    i.obj_id_rp,
    i.usage_current,
    i.astatus,
    i.fk_reach,
    i.fk_wastewater_node,
    i.type,
    'E'::text || row_number() OVER (PARTITION BY i.obj_id_ne ORDER BY i.level DESC)::text AS _label
   FROM inlet i
UNION ALL
 SELECT uuid_generate_v4() AS _uuid,
    o.obj_id_ne,
    o.network_element_identifier,
    st_force2d(o.geom) AS geom,
    COALESCE(o.level::text, '?'::text) AS level,
    o.obj_id_rp,
    o.usage_current,
    o.astatus,
    o.fk_reach,
    o.fk_wastewater_node,
    o.type,
    'A'::text || row_number() OVER (PARTITION BY o.obj_id_ne ORDER BY o.level DESC)::text AS _label
   FROM outlet o;


CREATE INDEX labeling_inlets_outlets_geom_idx
  ON tww_app.vw_labeling_inlets_outlets
  USING GIST (geom);