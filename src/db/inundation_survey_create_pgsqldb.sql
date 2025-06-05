CREATE TABLE IF NOT EXISTS inundation_survey(
    survey_id SERIAL PRIMARY KEY,       -- inundation survey id number
    storm_name TEXT,                    -- name of storm (e.g. Ondoy, Egay, and Persistent Rain)
    survey_address TEXT,                -- subject address of the survey (usually a street corner)
    depth REAL,                         -- depth of flooding
    district TEXT,                      -- district of the subject address
    survey_g4326 geometry(Point,4326),  -- manhole geometry (coordinates of the subject address)
    long REAL,                          -- longitude of subject address in degrees
    lat REAL,                           -- latitude of subject address in degrees
    interviewer_name TEXT,              -- name of interviewer
    survey_encode_datetime TIMESTAMP,        -- date of encoding into the Google Forms
    email_ad TEXT,                      -- email address of encoder (Google Forms)
    survey_date DATE,                   -- date when interview was conducted
    respondent_age INTEGER,
    respondent_name TEXT,
    respondent_tenure INTEGER,          -- for how many years has the respondent been working/living near the subject address
    respondent_education TEXT,
    respondent_residency_type TEXT,     -- working or resident?
    respondent_occupation TEXT,         -- if working, what is there occupation?
    respondent_civil_status TEXT,
    respondent_ethnicity TEXT,
    respondent_religion TEXT,
    storm_duration REAL,                -- duration of flooding in hours
    storm_originate TEXT,               -- where did the floodwater originate from?
    storm_warning TEXT,                 -- was there warning from news, officials, etc.?
    storm_did_evacuate NUMERIC,         -- did the respondent evacuate?
    storm_evacuate_loc TEXT,            -- where did the respondent evacuate to?
    storm_evacuate_floodtime TEXT,      -- did the respondent evacuate before, during, or after the flooding event?
    storm_transpo TEXT,                 -- what forms of transportation could still pass through the subject address during the flood event?
    storm_disease TEXT,                 -- did the respondent experience illness after the flooding? what disease?
    storm_loss TEXT,                    -- what did the respondent lose during the flooding? Can be family, housing, living, etc.
    storm_work_school TEXT,             -- does the respondent work and/or go to school?
    storm_days_no_ws INTEGER,           -- how many days did work/school stop?
    storm_walkability TEXT,             -- was it still walkable during the storm event?
    remarks TEXT                        -- extra remarks about the interview
);

CREATE OR REPLACE FUNCTION update_geometries() RETURNS trigger AS $inundation_survey_geom$
    -- Update Geometry columns (survey_g4326) when either latitude (lat) or longitude (long)
    -- is updated. A new point geometry will be placed, and should keep the latitude and 
    -- longitude columns consistent with the geometry column.
    BEGIN
        -- Check if Latitude is given
        IF NEW.lat IS NULL THEN
            RAISE EXCEPTION '% must have a latitude', NEW.survey_id;
        END IF;
        -- Check if Easting is given
        IF NEW.long IS NULL THEN
            RAISE EXCEPTION '% must have a longitude', NEW.survey_id;
        END IF;

        -- Apply new geometry
        NEW.survey_g4326 := st_setsrid(st_point(NEW.long, NEW.lat), 4326);

        RETURN NEW;
        
    END;
$inundation_survey_geom$ LANGUAGE plpgsql;

CREATE TRIGGER inundation_survey_geom BEFORE INSERT OR UPDATE ON inundation_survey
    FOR EACH ROW EXECUTE FUNCTION update_geometries();