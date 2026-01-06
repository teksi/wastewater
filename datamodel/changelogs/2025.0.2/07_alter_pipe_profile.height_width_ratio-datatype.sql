-- old definition till VSA-DSS Release 2020.1
-- ALTER TABLE tww_od.pipe_profile ADD COLUMN height_width_ratio  decimal(5,2) ;
-- PatchChange November 2025 corrects to this:
 ALTER TABLE tww_od.pipe_profile ALTER COLUMN height_width_ratio TYPE decimal(8,5);
