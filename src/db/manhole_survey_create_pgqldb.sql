CREATE TABLE IF NOT EXISTS manhole_survey(
    -- Schema for the manhole_survey. This table aims to replicate the manhole inventory as-is.
    id              SERIAL PRIMARY KEY,    -- manhole id number (agnostic to name)
    mh_dstrct       varchar(20),    -- district name
    mh_align        varchar(250),   -- alignment name
    mh_id           varchar(10),    -- manhole id name (client-facing id)
    mh_sta          float4,         -- convert station # + ###.#### to ####.####
    mh_g3123        geometry(Point,3123),    -- manhole geometry (coordinates of the manhole)
    mh_n3123        float4,         -- northing with PRS92 projection ESPG:3123
    mh_e3123        float4,         -- easting with PRS92 projection ESPG:3123
    mh_rimel        float4,         -- manhole rim elevation
    mh_invel        float4,         -- manhole invert elevation
    mh_len          float4,         -- manhole inner length
    mh_wid          float4,         -- manhole inner width
    mh_thk          float4,         -- manhole wall thickness
    mh_dep          float4,         -- manhole depth (from rim to invert)
    cvr_pcs         float4,         -- manhole cover pieces
    cvr_len         float4,         -- manhole cover length
    cvr_wid         float4,         -- manhole cover width
    cvr_thk         float4,         -- manhole cover thickness
    mh_ws           float4,         -- manhole water surface depth (measured from rim elevation)
    mh_wsdp         float4,         -- manhole water surface depth (measured from invert elevation)
    mh_fil          float4,         -- manhole sand or gravel deposits (i.e. fill) depth (measured from rim elevation)
    mh_fildp        float4,         -- manhole sand or gravel deposits (i.e. fill) elevation (measured from rim elevation)
    mh_crk          bool,           -- is the manhole cracked?
    mh_stgnnt       bool,           -- is the manhole stagnant?
    mh_clggd        bool,           -- is the manhole clogged?
    mh_obsmat       varchar(20),    -- manhole obstruction material, sand and/or garbage
    mh_obstcl       varchar(50),    -- manhole obstacles (e.g. telephone, internet, and potable water lines)
    crb_has         bool,           -- is the manhole connected to a curb inlet? (manhole has curb?)
    crb_wid         int2,           -- curb width in mm
    crb_len         varchar(20),    -- curb height / length (NOTE: ideally should be converted into two integers)
    us_id           varchar(10),    -- upstream pipe manhole id where pipe points to (client-facing id)
    us_shp          varchar(20),    -- upstream pipe shape: CIRC (Circular shape), RECT (Rectangular), or TRAP (Trap)
    us_dia          float4,         -- upstream pipe diameter in mm
    us_dep          float4,         -- upstream pipe depth in mm
    us_wid          float4,         -- upstream pipe width in mm
    us_cells        int2,           -- upstream pipe count (number of cells)
    us_inv          float4,         -- upstream pipe invert depth (measured from rim elevation)
    us_crwn         float4,         -- upstream pipe crown depth (measured from rim elevation)
    us_invel        float4,         -- upstream pipe invert elevation (measured from Mean Sea Level)
    ds_id           varchar(10),    -- downstream pipe manhole id where pipe points to (client-facing id)
    ds_shp          varchar(20),    -- downstream pipe shape: CIRC (Circular shape), RECT (Rectangular), or TRAP (Trap)
    ds_dia          float4,         -- downstream pipe diameter in mm
    ds_dep          float4,         -- downstream pipe depth in mm
    ds_wid          float4,         -- downstream pipe width in mm
    ds_cells        int2,           -- downstream pipe count (number of cells)
    ds_inv          float4,         -- upstream pipe invert depth (measured from rim elevation)
    ds_crwn         float4,         -- upstream pipe crown depth (measured from rim elevation)
    ds_invel        float4,         -- upstream pipe invert elevation (measured from Mean Sea Level)
    sv_date         date,           -- survey date (year, month, day)
    sv_sufice       varchar(20),    -- survey data gathered category: SUFFICIENT, DEFICIENT, LIMITED, UNSUCCESSFUL
    sv_adq          bool,           -- survey data adequecy
    sv_prob         text,           -- survey problems, remarks on the problems during the opening and surveying of the manhole
    sv_oprstat      varchar(20),    -- survey operations status, was the operation SUCCESSFUL, CANCELLED, or NONE
    sv_opnstat      varchar(10),    -- survey manhole opening status, whether the manhole was "OPENED" or "NOT OPENED"
    sv_type         varchar(20),    -- survey type, whether the operation was done on a "Manhole", 
    sv_doc          text            -- survey documentation, link to the photos of the survey in One Drive
);

CREATE OR REPLACE FUNCTION update_geometries() RETURNS trigger AS $manhole_survey_geom$
    -- Update Geometry columns (mh_g3123) when either northing (mh_n3123) or easting (mh_e3123)
    -- is updated. A new point geometry will be placed, and should keep the northing and 
    -- easting columns consistent with the geometry column.
    BEGIN
        -- Check if Northing is given
        IF NEW.mh_n3123 IS NULL THEN
            RAISE EXCEPTION '% must have a northing', NEW.mh_id;
        END IF;
        -- Check if Easting is given
        IF NEW.mh_e3123 IS NULL THEN
            RAISE EXCEPTION '% must have a easting', NEW.mh_id;
        END IF;

        -- Apply new geometry
        NEW.mh_g3123 := st_setsrid(st_point(NEW.mh_e3123, NEW.mh_n3123), 3123);

        RETURN NEW;
        
    END;
$manhole_survey_geom$ LANGUAGE plpgsql;

CREATE TRIGGER manhole_survey_geom BEFORE INSERT OR UPDATE ON manhole_survey
    FOR EACH ROW EXECUTE FUNCTION update_geometries();