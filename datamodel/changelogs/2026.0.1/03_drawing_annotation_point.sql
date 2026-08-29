-- 2026.0.1/03_drawing_annotation_point.sql
-- Create a table for annotation points

CREATE TABLE tww_od.drawing_annotation_point (id serial PRIMARY KEY);
COMMENT ON TABLE tww_od.drawing_annotation_point IS 'Table for annotation points.';

/* COLUMNS */
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN text_size        decimal(7,2);
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN text_orientation decimal(7,2);
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN annotation       text;
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN scale_1          boolean default true;
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN scale_2          boolean default true;

/* GEOMETRY */
ALTER TABLE tww_od.drawing_annotation_point ADD COLUMN geometry geometry('POINT',{SRID});
CREATE INDEX annotationpoint_geoidx ON tww_od.drawing_annotation_point USING GIST ( geometry );
