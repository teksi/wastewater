-- 2026.0.1/06_drawing_dimension_orientation.sql
-- Create a table for dimension orientation

/* CREATE TABLE */
CREATE TABLE tww_od.drawing_dimension_orientation (id serial PRIMARY KEY);
COMMENT ON TABLE tww_od.drawing_dimension_orientation IS 'Dimension arcs displays measures done on the field. For example: orientations to buildings corner';

/* columns */
ALTER TABLE tww_od.drawing_dimension_orientation ADD COLUMN observation varchar(120) ;
ALTER TABLE tww_od.drawing_dimension_orientation ADD COLUMN remark      text ;

/* geometry */
ALTER TABLE tww_od.drawing_dimension_orientation ADD COLUMN geometry geometry('LINESTRING',{SRID});
CREATE INDEX dimension_orientation_geoidx ON tww_od.drawing_dimension_orientation USING GIST ( geometry );
