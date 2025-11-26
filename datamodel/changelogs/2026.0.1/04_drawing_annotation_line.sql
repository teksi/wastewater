-- 2026.0.1/04_drawing_annotation_line.sql
-- Create a table for annotation lines

CREATE TABLE tww_od.drawing_annotation_line (id serial PRIMARY KEY);
COMMENT ON TABLE tww_od.drawing_annotation_line IS 'Table for annotation lines.';

/* COLUMNS */
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN labelvisible     boolean not null default true;
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN text_size        decimal(7,2);
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN text_orientation decimal(7,2);
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN annotation       text;
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN scale_1          boolean default true;
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN scale_2          boolean default true;

/* GEOMETRY */
ALTER TABLE tww_od.drawing_annotation_line ADD COLUMN geometry geometry('LINESTRING',{SRID});
CREATE INDEX annotationline_geoidx ON tww_od.drawing_annotation_line USING GIST ( geometry );
