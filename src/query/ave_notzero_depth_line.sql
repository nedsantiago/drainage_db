SELECT AVG(depth) FROM inundation_survey 
	WHERE 
		(
			UPPER(subject_address) REGEXP 'ALHAMBRA' 
			AND UPPER(subject_address) REGEXP 'KALAW' 
			AND typhoon LIKE 'Ondoy'
		) 
		OR 
		(
			UPPER(subject_address) REGEXP 'UNITED' 
			AND UPPER(subject_address) REGEXP 'ALHAMBRA' 
			AND typhoon LIKE 'Ondoy'
		) 
		AND 
		(
			depth > 0;
		)
