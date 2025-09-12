-- Chicago Crimes Data Import Script (FIXED FIELD SIZES)
-- Author: Bogdan Kudelya  
-- Date: September 2025

SET CLIENT_ENCODING TO 'UTF8';

-- Drop and recreate temp table with LARGER field sizes
DROP TABLE IF EXISTS crimes_temp;
CREATE TABLE crimes_temp (
    id_str VARCHAR(20),                -- ID
    case_number VARCHAR(20),           -- Case Number
    date_str VARCHAR(30),              -- Date
    block VARCHAR(150),                -- Block (increased)
    iucr VARCHAR(10),                  -- IUCR
    primary_type VARCHAR(100),         -- Primary Type (increased)
    description VARCHAR(200),          -- Description (increased)
    location_description VARCHAR(100), -- Location Description (FIXED: 50->100)
    arrest_str VARCHAR(10),            -- Arrest
    domestic_str VARCHAR(10),          -- Domestic
    beat VARCHAR(10),                  -- Beat
    district VARCHAR(10),              -- District
    ward VARCHAR(10),                  -- Ward
    community_area VARCHAR(10),        -- Community Area
    fbi_code VARCHAR(10),              -- FBI Code
    x_coordinate VARCHAR(20),          -- X Coordinate
    y_coordinate VARCHAR(20),          -- Y Coordinate
    year_str VARCHAR(10),              -- Year
    updated_on_str VARCHAR(30),        -- Updated On
    latitude VARCHAR(20),              -- Latitude
    longitude VARCHAR(20),             -- Longitude
    location VARCHAR(100)              -- Location (increased)
);

-- Now try the import again with bigger field sizes!
COPY crimes_temp FROM 'D:/Data_Analyst_Pet_Projects/ChicagoCrimes/raw_data/chicago_crimes.csv' 
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ',', 
    NULL '', 
    ENCODING 'UTF8'
);

-- Check the import
SELECT COUNT(*) as total_rows FROM crimes_temp;
SELECT 'Import successful!' as status;