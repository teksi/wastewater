-- 2026.0.1/01_drawing_construction_point.sql
-- Create a table for construction points

/* CREATE TABLE */
CREATE TABLE tww_od.drawing_construction_point (id serial PRIMARY KEY);
COMMENT ON TABLE tww_od.drawing_construction_point IS 'Construction points are artificials points to build objects.';

/* columns */
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN altitude         decimal(10,3);
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN fk_object_reference varchar(16);
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN code                  varchar(15) ;
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN measurement_campaign  varchar(200) ;
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN remark                text ;

/* geometry */
ALTER TABLE tww_od.drawing_construction_point ADD COLUMN geometry geometry('POINTZ',{SRID});
CREATE INDEX constructionpoint_geoidx ON tww_od.drawing_construction_point USING GIST ( geometry );


/* constraints */
ALTER TABLE tww_od.drawing_construction_point ADD CONSTRAINT constructionpoint_fk_object_reference FOREIGN KEY (fk_object_reference) REFERENCES qwat_vl.object_reference(id) MATCH FULL; CREATE INDEX fki_constructionpoint_fk_object_reference ON tww_od.drawing_construction_point(fk_object_reference);
