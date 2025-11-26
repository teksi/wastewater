-- 2026.0.1/02_drawing_construction_line.sql
-- Create a table for construction lines

/* CREATE TABLE */
CREATE TABLE tww_od.drawing_construction_line (id serial PRIMARY KEY);
COMMENT ON TABLE tww_od.drawing_construction_line IS 'Construction lines are artificials lines to build objects.';

/* columns */
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN altitude         decimal(10,3)  ;
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN fk_object_reference varchar(16)     ;
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN code                  varchar(15) ;
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN measurement_campaign  varchar(200) ;
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN remark                text ;

/* geometry */
ALTER TABLE tww_od.drawing_construction_line ADD COLUMN geometry geometry('LINESTRINGZ',{SRID});
CREATE INDEX constructionpoint_geoidx ON tww_od.drawing_construction_line USING GIST ( geometry );


/* constraints */
ALTER TABLE tww_od.drawing_construction_line ADD CONSTRAINT construction_line_fk_object_reference FOREIGN KEY (fk_object_reference) REFERENCES tww_vl.object_reference(id) MATCH FULL; 

/* index */
CREATE INDEX fki_construction_line_fk_object_reference ON tww_od.drawing_construction_line(fk_object_reference);
