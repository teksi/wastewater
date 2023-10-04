-- 18.9.2023 Adapt so that PUM upgrade works - change similar names in damage subclasse to unique ones

-- damage_channel

ALTER TABLE tww_od.damage_channel 
RENAME COLUMN distance TO channel_distance;

ALTER TABLE tww_od.damage_channel 
RENAME COLUMN damage_begin TO channel_damage_begin;

ALTER TABLE tww_od.damage_channel 
RENAME COLUMN damage_end TO channel_damage_end;

ALTER TABLE tww_od.damage_channel 
RENAME COLUMN quantification1  TO channel_quantification1;

ALTER TABLE tww_od.damage_channel 
RENAME COLUMN quantification2  TO channel_quantification2;

-- damage_manhole

ALTER TABLE tww_od.damage_manhole 
RENAME COLUMN distance TO manhole_channel_distance;

ALTER TABLE tww_od.damage_manhole 
RENAME COLUMN damage_begin TO manhole_damage_begin;

ALTER TABLE tww_od.damage_manhole 
RENAME COLUMN damage_end TO manhole_damage_end;

ALTER TABLE tww_od.damage_manhole 
RENAME COLUMN quantification1  TO manhole_quantification1;

ALTER TABLE tww_od.damage_manhole 
RENAME COLUMN quantification2  TO manhole_quantification2;
