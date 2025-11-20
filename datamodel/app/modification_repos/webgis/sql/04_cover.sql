CREATE MATERIALIZED VIEW IF NOT EXISTS tww_app.mvw_web_cover
AS
 SELECT co.obj_id,
    sp.identifier,
    co.brand,
    co_cs.{value_lang} AS cover_shape,
    co.diameter,
    co_fa.{value_lang} AS fastening,
    co.level,
    co_ma.{value_lang} AS material,
    co_pa.{value_lang} AS positional_accuracy,
    co.situation3d_geometry,
    co_sb.{value_lang} AS sludge_bucket,
    co_vn.{value_lang} AS venting,
    sp_rd.{value_lang} AS renovation_demand
   FROM tww_od.cover co
     LEFT JOIN tww_od.structure_part sp ON sp.obj_id = co.obj_id
     LEFT JOIN tww_vl.structure_part_renovation_demand sp_rd ON sp_rd.code = sp.renovation_demand
     LEFT JOIN tww_vl.cover_cover_shape co_cs ON co_cs.code = co.cover_shape
     LEFT JOIN tww_vl.cover_fastening co_fa ON co_fa.code = co.fastening
     LEFT JOIN tww_vl.cover_venting co_vn ON co_vn.code = co.venting
     LEFT JOIN tww_vl.cover_material co_ma ON co_ma.code = co.material
     LEFT JOIN tww_vl.cover_positional_accuracy co_pa ON co_ma.code = co.positional_accuracy
     LEFT JOIN tww_vl.cover_sludge_bucket co_sb ON co_sb.code = co.sludge_bucket;