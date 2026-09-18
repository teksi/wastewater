CREATE TABLE IF NOT EXISTS tww_od.re_measuring_point_reference_station
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    fk_measuring_point character varying(16) COLLATE pg_catalog."default",
    fk_reference_station character varying(16) COLLATE pg_catalog."default",
    CONSTRAINT pkey_tww_od_measuring_point_reference_station_id PRIMARY KEY (id),
    CONSTRAINT rel_measuring_point_reference_station_measuring_point FOREIGN KEY (fk_measuring_point)
        REFERENCES tww_od.measuring_point (obj_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT rel_measuring_point_reference_station_reference_station FOREIGN KEY (fk_reference_station)
        REFERENCES tww_od.measuring_point (obj_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

INSERT INTO tww_od.re_measuring_point_reference_station
 (
    fk_measuring_point,
     fk_reference_station
 )
SELECT obj_id, fk_reference_station
FROM tww_od.measuring_point
WHERE fk_reference_station IS NOT NULL;

ALTER TABLE tww_od.measuring_point DROP COLUMN fk_reference_station;