
UPDATE tww_vl.channel_function_hierarchic
SET tww_symbology_order=
 array_position(
	 ARRAY[
		 5068 --pwwf.water_bodies
  	     ,5070 --pwwf.main_drain_regional
		 ,5069 --pwwf.main_drain
		 ,5071 --pwwf.collector_sewer
		 ,1999991 --pwwf.site_drainage
		 ,5062 --pwwf.renovation_conduction
		 ,5064 --pwwf.residential_drainage
		 ,5072 --pwwf.road_drainage
		 ,5066 --pwwf.other
		 ,5074 --pwwf.unknown
		 ,5063 --swwf.renovation_conduction
		 ,5065 --swwf.residential_drainage
		 ,5073 --swwf.road_drainage
		 ,5067 --swwf.other
		 ,5075 --swwf.unknown
		 ]
	 ,code);


UPDATE tww_vl.channel_usage_current
SET tww_symbology_order=
 array_position(
	 ARRAY[
		  4526 --wastewater
  	     ,4522 --combined_wastewater
		 ,4516 --discharged_combined_wastewater
		 ,4524 --industrial_wastewater
		 ,1999989 --street_water
		 ,1999993 -- square_water
		 ,4514 --clean_wastewater
		 ,9023 --surface_water
		 ,4518 --creek_water
		 ,4571 --other
		 ,5322 --unknown
		 ]
	 ,code);