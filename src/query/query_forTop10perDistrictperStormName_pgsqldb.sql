SELECT *
FROM inundation_survey AS is1
WHERE survey_id
	IN(
	SELECT survey_id
	FROM inundation_survey AS is2
	WHERE district = is1.district
		AND storm_name = is1.storm_name
		AND survey_id NOT IN (1708)
	ORDER BY depth DESC
	LIMIT 10
	)