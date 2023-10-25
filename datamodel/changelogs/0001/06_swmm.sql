-- Modifications applied for link with SWMM
-------------------------------------------

-- Add attributes
ALTER TABLE tww_od.reach ADD COLUMN swmm_default_coefficient_of_friction  smallint ;
COMMENT ON COLUMN tww_od.reach.swmm_default_coefficient_of_friction IS '1 / N_Manning, value between 0 and 999. Value exported in SWMM if coefficient_of_friction and wall_roughness are not set. ';
ALTER TABLE tww_od.reach ADD COLUMN dss2020_hydraulic_load_current smallint ;
COMMENT ON COLUMN tww_od.reach.dss2020_hydraulic_load_current IS 'Dimensioning of the discharge divided by the normal discharge capacity of the reach [%]. / Dimensionierungsabfluss geteilt durch Normalabflusskapazität der Leitung [%]. / Débit de dimensionnement divisé par la capacité d''écoulement normale de la conduite [%].';

-- Add table for defaults coefficients of friction
CREATE TABLE tww_swmm.reach_coefficient_of_friction (fk_material integer, coefficient_of_friction smallint);
ALTER TABLE tww_swmm.reach_coefficient_of_friction ADD CONSTRAINT pkey_tww_vl_reach_coefficient_of_friction_id PRIMARY KEY (fk_material);
INSERT INTO tww_swmm.reach_coefficient_of_friction(fk_material) SELECT vsacode FROM tww_vl.reach_material;
UPDATE tww_swmm.reach_coefficient_of_friction SET coefficient_of_friction = (CASE WHEN fk_material IN (5381,5081,3016) THEN 100
                                                                                    WHEN fk_material IN (2754,3638,3639,3640,3641,3256,147,148,3648,5079,5080,153,2762) THEN 83
                                                                                    WHEN fk_material IN (2755) THEN 67
                                                                                    WHEN fk_material IN (5076,5077,5078,5382) THEN 111
                                                                                    WHEN fk_material IN (3654) THEN 91
                                                                                    WHEN fk_material IN (154,2761) THEN 71
                                                                                    ELSE 100 END);
