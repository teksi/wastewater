INSERT INTO tww_vl.infiltration_installation_kind_export_rel_agxx (code,value_de) VALUES
(3283,'Versickerungsstrang'),
(3284,'Versickerungsschacht_Strang')
ON CONFLICT (code) DO UPDATE SET
  value_de = EXCLUDED.value_de;

  