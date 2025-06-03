SELECT format('%1, my number is %2',{myVariable}, {myNumber});

SELECT re.obj_id,
    re_mat.{value_lang} AS material,
    re_mat.{abbr_lang} AS material_abbr
   FROM tww_od.reach re
     LEFT JOIN ( SELECT reach_material.code,
            reach_material.{value_lang},
            reach_material.{abbr_lang}
           FROM tww_vl.reach_material) re_mat ON re_mat.code = re.material;
