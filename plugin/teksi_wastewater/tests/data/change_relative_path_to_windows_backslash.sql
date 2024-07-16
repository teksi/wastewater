UPDATE 
  tww_od.file 
SET 
  --unix to windwos path
  path_relative = REPLACE(path_relative, '/', '\') 
  
WHERE 
  NOT (path_relative) ISNULL;