SELECT * FROM inundation_survey
	WHERE typhoon LIKE {{ storm_name_here }} 
	AND district LIKE {{ district_name_here }};
