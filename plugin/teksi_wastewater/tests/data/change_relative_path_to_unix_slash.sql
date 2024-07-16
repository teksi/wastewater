UPDATE 
  tww_od.file 
SET 
  --windows to unix path
  path_relative = REPLACE(path_relative, '/', '\') 
  
WHERE 
  NOT (path_relative) ISNULL;