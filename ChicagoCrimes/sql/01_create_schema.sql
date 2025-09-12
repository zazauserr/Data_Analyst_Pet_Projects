-- Drop table if exists to avoid conflicts
DROP TABLE IF EXISTS crimes CASCADE;

-- Create main crimes table
CREATE TABLE crimes (
    id SERIAL PRIMARY KEY,
    crime_id INTEGER,                  -- Original ID from CSV
    case_number VARCHAR(20),           -- Removed UNIQUE constraint
    date_occurred TIMESTAMP,
    block VARCHAR(150),                -- Increased size
    iucr VARCHAR(10),
    primary_type VARCHAR(100),         -- Increased size
    description VARCHAR(200),          -- Increased size
    location_description VARCHAR(100), -- FIXED: increased from 50 to 100
    arrest BOOLEAN,
    domestic BOOLEAN,
    beat INTEGER,
    district INTEGER,
    ward INTEGER,
    community_area INTEGER,
    fbi_code VARCHAR(10),
    x_coordinate DECIMAL(12,2),
    y_coordinate DECIMAL(12,2),
    year_occurred INTEGER,
    updated_on TIMESTAMP,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    location_coords VARCHAR(100)       -- Increased size
);

-- Add derived columns for analysis
ALTER TABLE crimes ADD COLUMN month_occurred INTEGER;
ALTER TABLE crimes ADD COLUMN day_of_week INTEGER;  -- 1=Sunday, 7=Saturday
ALTER TABLE crimes ADD COLUMN hour_occurred INTEGER;
ALTER TABLE crimes ADD COLUMN season VARCHAR(10);
ALTER TABLE crimes ADD COLUMN time_of_day VARCHAR(15);
ALTER TABLE crimes ADD COLUMN crime_category VARCHAR(30);

-- Drop existing indexes if they exist
DROP INDEX IF EXISTS idx_crimes_date;
DROP INDEX IF EXISTS idx_crimes_type;
DROP INDEX IF EXISTS idx_crimes_district;
DROP INDEX IF EXISTS idx_crimes_ward;
DROP INDEX IF EXISTS idx_crimes_arrest;
DROP INDEX IF EXISTS idx_crimes_coordinates;
DROP INDEX IF EXISTS idx_crimes_year;
DROP INDEX IF EXISTS idx_crimes_arrested;

-- Create indexes for better performance
CREATE INDEX idx_crimes_date ON crimes (date_occurred);
CREATE INDEX idx_crimes_type ON crimes (primary_type);
CREATE INDEX idx_crimes_district ON crimes (district);
CREATE INDEX idx_crimes_ward ON crimes (ward);
CREATE INDEX idx_crimes_arrest ON crimes (arrest);
CREATE INDEX idx_crimes_coordinates ON crimes (latitude, longitude);
CREATE INDEX idx_crimes_year ON crimes (year_occurred);

-- Create partial index for arrested crimes (faster filtering)
CREATE INDEX idx_crimes_arrested ON crimes (case_number) WHERE arrest = true;

-- Add comments for documentation
COMMENT ON TABLE crimes IS 'Chicago crime incidents data with geographic and temporal information';
COMMENT ON COLUMN crimes.case_number IS 'Unique identifier for each crime case';
COMMENT ON COLUMN crimes.primary_type IS 'Primary classification of the crime';
COMMENT ON COLUMN crimes.arrest IS 'Whether an arrest was made (true/false)';
COMMENT ON COLUMN crimes.domestic IS 'Whether the incident was domestic-related';
COMMENT ON COLUMN crimes.beat IS 'Police beat where incident occurred';
COMMENT ON COLUMN crimes.district IS 'Police district where incident occurred';
COMMENT ON COLUMN crimes.ward IS 'City ward where incident occurred';

\d crimes;