-- FINAL: Chicago Crimes Data Processing Script
-- Run this AFTER you successfully import CSV into crimes_temp table

-- Check imported data first
SELECT COUNT(*) as total_rows FROM crimes_temp;
SELECT 'Sample of imported data:' as info;
SELECT * FROM crimes_temp LIMIT 3;

-- Clean and transform data, then insert into main crimes table
INSERT INTO crimes (
    crime_id,
    case_number,
    date_occurred,
    block,
    iucr,
    primary_type,
    description,
    location_description,
    arrest,
    domestic,
    beat,
    district,
    ward,
    community_area,
    fbi_code,
    x_coordinate,
    y_coordinate,
    year_occurred,
    updated_on,
    latitude,
    longitude,
    location_coords
)
SELECT 
    CASE 
        WHEN id_str ~ '^\d+$' THEN id_str::INTEGER
        ELSE NULL
    END as crime_id,
    NULLIF(TRIM(case_number), '') as case_number,
    -- Handle different date formats (MM/DD/YYYY HH:MM:SS AM/PM)
    CASE 
        WHEN date_str ~ '^\d{1,2}/\d{1,2}/\d{4}' THEN
            TO_TIMESTAMP(date_str, 'MM/DD/YYYY HH12:MI:SS AM')
        ELSE NULL
    END as date_occurred,
    NULLIF(TRIM(block), '') as block,
    NULLIF(TRIM(iucr), '') as iucr,
    NULLIF(TRIM(primary_type), '') as primary_type,
    NULLIF(TRIM(description), '') as description,
    NULLIF(TRIM(location_description), '') as location_description,
    CASE 
        WHEN UPPER(TRIM(arrest_str)) = 'TRUE' THEN true
        WHEN UPPER(TRIM(arrest_str)) = 'FALSE' THEN false
        ELSE NULL
    END as arrest,
    CASE 
        WHEN UPPER(TRIM(domestic_str)) = 'TRUE' THEN true
        WHEN UPPER(TRIM(domestic_str)) = 'FALSE' THEN false
        ELSE NULL
    END as domestic,
    CASE 
        WHEN beat ~ '^\d+$' THEN beat::INTEGER
        ELSE NULL
    END as beat,
    CASE 
        WHEN district ~ '^\d+$' THEN district::INTEGER
        ELSE NULL
    END as district,
    CASE 
        WHEN ward ~ '^\d+$' THEN ward::INTEGER
        ELSE NULL
    END as ward,
    CASE 
        WHEN community_area ~ '^\d+$' THEN community_area::INTEGER
        ELSE NULL
    END as community_area,
    NULLIF(TRIM(fbi_code), '') as fbi_code,
    CASE 
        WHEN x_coordinate ~ '^-?\d+\.?\d*$' THEN x_coordinate::DECIMAL(12,2)
        ELSE NULL
    END as x_coordinate,
    CASE 
        WHEN y_coordinate ~ '^-?\d+\.?\d*$' THEN y_coordinate::DECIMAL(12,2)
        ELSE NULL
    END as y_coordinate,
    CASE 
        WHEN year_str ~ '^\d{4}$' THEN year_str::INTEGER
        ELSE NULL
    END as year_occurred,
    CASE 
        WHEN updated_on_str ~ '^\d{1,2}/\d{1,2}/\d{4}' THEN
            TO_TIMESTAMP(updated_on_str, 'MM/DD/YYYY HH12:MI:SS AM')
        ELSE NULL
    END as updated_on,
    CASE 
        WHEN latitude ~ '^-?\d+\.?\d*$' THEN latitude::DECIMAL(10,7)
        ELSE NULL
    END as latitude,
    CASE 
        WHEN longitude ~ '^-?\d+\.?\d*$' THEN longitude::DECIMAL(10,7)
        ELSE NULL
    END as longitude,
    NULLIF(TRIM(location), '') as location_coords
FROM crimes_temp
WHERE TRIM(case_number) != '' AND TRIM(case_number) IS NOT NULL
   AND id_str IS NOT NULL AND TRIM(id_str) != '';  -- Filter by ID instead

-- Update derived columns
UPDATE crimes SET 
    month_occurred = EXTRACT(MONTH FROM date_occurred),
    day_of_week = EXTRACT(DOW FROM date_occurred) + 1,  -- PostgreSQL DOW: 0=Sunday, convert to 1=Sunday
    hour_occurred = EXTRACT(HOUR FROM date_occurred),
    season = CASE 
        WHEN EXTRACT(MONTH FROM date_occurred) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM date_occurred) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date_occurred) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date_occurred) IN (9, 10, 11) THEN 'Fall'
        ELSE NULL
    END,
    time_of_day = CASE 
        WHEN EXTRACT(HOUR FROM date_occurred) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM date_occurred) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM date_occurred) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END,
    crime_category = CASE 
        WHEN primary_type IN ('THEFT', 'BURGLARY', 'ROBBERY', 'MOTOR VEHICLE THEFT') THEN 'Property Crime'
        WHEN primary_type IN ('BATTERY', 'ASSAULT', 'HOMICIDE', 'CRIMINAL SEXUAL ASSAULT') THEN 'Violent Crime'
        WHEN primary_type IN ('NARCOTICS', 'OTHER NARCOTIC VIOLATION') THEN 'Drug Crime'
        WHEN primary_type IN ('CRIMINAL DAMAGE', 'ARSON', 'VANDALISM') THEN 'Damage/Destruction'
        ELSE 'Other'
    END
WHERE date_occurred IS NOT NULL;

-- Data quality checks
SELECT 'FINAL RESULTS:' as status;
SELECT 'Total records imported:' as check_name, COUNT(*)::text as value FROM crimes
UNION ALL
SELECT 'Records with coordinates:', COUNT(*)::text FROM crimes WHERE latitude IS NOT NULL AND longitude IS NOT NULL
UNION ALL
SELECT 'Records with arrests:', COUNT(*)::text FROM crimes WHERE arrest = true
UNION ALL
SELECT 'Date range:', CONCAT(MIN(date_occurred::date)::text, ' to ', MAX(date_occurred::date)::text) FROM crimes
UNION ALL
SELECT 'Unique crime types:', COUNT(DISTINCT primary_type)::text FROM crimes;

-- Show sample of processed data
SELECT 'Sample of final processed data:' as info;
SELECT 
    crime_id,
    case_number,
    date_occurred,
    primary_type,
    description,
    arrest,
    district,
    latitude,
    longitude,
    season,
    time_of_day,
    crime_category
FROM crimes 
ORDER BY date_occurred DESC 
LIMIT 10;

-- Clean up temporary table
DROP TABLE crimes_temp;

-- Update table statistics for better query performance
ANALYZE crimes;

-- Success!
SELECT 'DATABASE SETUP COMPLETE! Ready for analytics!' as final_status;