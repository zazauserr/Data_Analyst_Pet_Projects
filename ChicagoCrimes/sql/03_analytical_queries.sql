
-- TEMPORAL ANALYSIS

SELECT CASE 
WHEN month_occurred = 1 THEN 'January'
WHEN month_occurred = 2 THEN 'February'
END AS month_name, 
COUNT(*) as total_crimes, 
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM crimes), 2) as percentage,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100 / COUNT(*), 2) as arrest_rate
FROM crimes
GROUP BY month_occurred;

-- GEOGRAPHIC ANALYSIS (HOTSPOTS)

SELECT district,
COUNT(*) AS crimes,
COUNT(*) FILTER (WHERE arrest = True) as arrests,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM crimes WHERE location_description IS NOT NULL), 2) as percentage
FROM crimes
WHERE location_description IS NOT NULL
GROUP BY district
ORDER BY COUNT(*) DESC;

SELECT ROUND(longitude, 2) as longitude,
ROUND(latitude, 2) as latitude,
COUNT(*) as crimes
FROM crimes
GROUP BY ROUND(longitude, 2), ROUND(latitude, 2)
ORDER BY COUNT(*) DESC;

SELECT location_description, 
crime_category,
COUNT(*) as crimes
FROM crimes
WHERE location_description IS NOT NULL AND crime_category IS NOT NULL
GROUP BY location_description, crime_category
ORDER BY COUNT(*) DESC;

-- CRIME TYPE ANALYSIS

SELECT primary_type, COUNT(*) as crimes
FROM crimes
GROUP BY primary_type
ORDER BY COUNT(*) DESC;

SELECT 
crime_category,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100/ COUNT(*), 2) as arrest_rate
FROM crimes
GROUP BY crime_category
ORDER BY COUNT(*) DESC;

SELECT 
primary_type,
crime_category,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100/ COUNT(*), 2) as arrest_rate
FROM crimes
WHERE primary_type IS NOT NULL
GROUP BY crime_category, primary_type
ORDER BY COUNT(*) DESC;

SELECT description, COUNT(*) as crimes
FROM crimes 
WHERE primary_type = 'THEFT'
GROUP BY description
ORDER BY COUNT(*) DESC
LIMIT 10;


-- ARREST RATE ANALYSIS


SELECT primary_type,
COUNT(*) AS crimes,
COUNT(*) FILTER (WHERE arrest = True) as arrests,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM crimes), 2) as percentage
FROM crimes
GROUP BY primary_type
ORDER BY COUNT(*) DESC;

SELECT district,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = True) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = True) * 100.0 / COUNT(*), 2) as arrest_rate
FROM crimes
WHERE district IS NOT NULL
GROUP BY district
ORDER BY arrest_rate DESC;

SELECT hour_occurred,
    COUNT(*) AS total_crimes,
    COUNT(*) FILTER (WHERE arrest = True) as arrests,
    ROUND(COUNT(*) FILTER (WHERE arrest = True) * 100.0 / COUNT(*), 2) as arrest_rate
FROM crimes
WHERE hour_occurred IS NOT NULL
GROUP BY hour_occurred
ORDER BY hour_occurred;
 
SELECT 
CASE
	WHEN domestic = true THEN 'Domestic Violence'
	WHEN domestic = false THEN 'Non-Domestic'
	ELSE 'Unknown'
END as crime_type,
crime_category,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) as arrest_rate
FROM crimes
WHERE domestic IS NOT NULL
GROUP BY domestic, crime_category
ORDER BY arrest_rate DESC;

-- SECTION 5: ADVANCED ANALYTICS (WINDOW FUNCTIONS & CTE)

SELECT date_occurred::date as date,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(AVG(COUNT(*)) OVER(ORDER BY date_occurred::date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as avg_crimes_7d
FROM crimes
GROUP BY date_occurred::date
ORDER BY date;



SELECT RANK() OVER(ORDER BY COUNT(*) FILTER(WHERE arrest = true) * 1.0/ COUNT(*) DESC) as rank_rate,
district,
COUNT(*) AS crimes,
COUNT(*) FILTER(WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER(WHERE arrest = true) * 100/ COUNT(*), 2) as arrest_rate
FROM crimes 
GROUP BY district
ORDER BY rank_rate;

-- SECTION 6: POWER BI DASHBOARD QUERIES

CREATE MATERIALIZED VIEW mv_dashboard_summary AS
SELECT 
    COUNT(*) AS total_crimes,
    COUNT(*) FILTER (WHERE arrest = true) AS total_arrests,
    ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS overall_arrest_rate,
    (SELECT district 
     FROM crimes 
     GROUP BY district 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS top_district,
    (SELECT primary_type 
     FROM crimes 
     GROUP BY primary_type 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS top_crime_type
FROM crimes;



CREATE MATERIALIZED VIEW mv_dashboard_crimes_by_month AS
SELECT 
DATE_TRUNC('month', date_occurred)::date AS month,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
GROUP BY DATE_TRUNC('month', date_occurred)
ORDER BY month;


CREATE MATERIALIZED VIEW mv_dashboard_crimes_by_day AS
SELECT 
date_occurred::date AS date,
COUNT(*) AS crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(AVG(COUNT(*)) OVER(ORDER BY date_occurred::date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS avg_crimes_7d
FROM crimes
GROUP BY date_occurred::date
ORDER BY date;


CREATE MATERIALIZED VIEW mv_dashboard_crimes_by_district AS
SELECT 
district,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS total_arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE district IS NOT NULL
GROUP BY district
ORDER BY total_crimes DESC;


CREATE MATERIALIZED VIEW mv_dashboard_crimes_by_coords AS
SELECT 
ROUND(longitude, 2) AS longitude,
ROUND(latitude, 2) AS latitude,
COUNT(*) AS crimes
FROM crimes
WHERE longitude IS NOT NULL AND latitude IS NOT NULL
GROUP BY ROUND(longitude, 2), ROUND(latitude, 2)
ORDER BY crimes DESC;


CREATE MATERIALIZED VIEW mv_dashboard_crimes_by_category AS
SELECT 
crime_category,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE crime_category IS NOT NULL
GROUP BY crime_category
ORDER BY total_crimes DESC;

-- SECTION 7: BUSINESS INSIGHTS QUERIES

-- Resource allocation insights

SELECT hour_occurred,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = True) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = True) * 100.0 / COUNT(*), 2) as arrest_rate
FROM crimes
WHERE hour_occurred IS NOT NULL
GROUP BY hour_occurred
ORDER BY hour_occurred;

SELECT date_occurred::date as date,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(AVG(COUNT(*)) OVER(ORDER BY date_occurred::date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as avg_crimes_7d
FROM crimes
GROUP BY date_occurred::date
ORDER BY date;

-- Crime prevention opportunities

SELECT 
CASE
WHEN domestic = true THEN 'Domestic Violence'
WHEN domestic = false THEN 'Non-Domestic'
ELSE 'Unknown'
END as crime_type,
crime_category,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) as arrest_rate
FROM crimes
WHERE domestic IS NOT NULL
GROUP BY domestic, crime_category
ORDER BY arrest_rate DESC;

SELECT location_description, 
crime_category,
COUNT(*) as crimes
FROM crimes
WHERE location_description IS NOT NULL AND crime_category IS NOT NULL
GROUP BY location_description, crime_category
ORDER BY COUNT(*) DESC;

-- Public safety metrics

SELECT RANK() OVER(ORDER BY COUNT(*) FILTER(WHERE arrest = true) * 1.0 / COUNT(*) DESC) as rank_rate,
district,
COUNT(*) AS crimes,
COUNT(*) FILTER(WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER(WHERE arrest = true) * 100/ COUNT(*), 2) as arrest_rate
FROM crimes 
GROUP BY district
ORDER BY rank_rate;

SELECT 
crime_category,
COUNT(*) as crimes,
COUNT(*) FILTER (WHERE arrest = true) as arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100/ COUNT(*), 2) as arrest_rate
FROM crimes
GROUP BY crime_category
ORDER BY arrest_rate DESC;

-- VIEWS FOR POWER BI

CREATE MATERIALIZED VIEW mv_crime_summary AS
SELECT 
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS total_arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS overall_arrest_rate
FROM crimes;

CREATE MATERIALIZED VIEW mv_crime_by_month AS
SELECT 
DATE_TRUNC('month', date_occurred)::date AS month,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
GROUP BY DATE_TRUNC('month', date_occurred)
ORDER BY month;

CREATE MATERIALIZED VIEW mv_crime_by_day AS
SELECT 
date_occurred::date AS date,
COUNT(*) AS crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(AVG(COUNT(*)) OVER(ORDER BY date_occurred::date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS avg_crimes_7d
FROM crimes
GROUP BY date_occurred::date
ORDER BY date;

CREATE MATERIALIZED VIEW mv_crime_by_hour AS
SELECT 
hour_occurred,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE hour_occurred IS NOT NULL
GROUP BY hour_occurred
ORDER BY hour_occurred;

CREATE MATERIALIZED VIEW mv_crime_by_district AS
SELECT 
district,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE district IS NOT NULL
GROUP BY district
ORDER BY total_crimes DESC;

CREATE MATERIALIZED VIEW mv_crime_by_coords AS
SELECT 
ROUND(longitude, 2) AS longitude,
ROUND(latitude, 2) AS latitude,
COUNT(*) AS crimes
FROM crimes
WHERE longitude IS NOT NULL AND latitude IS NOT NULL
GROUP BY ROUND(longitude, 2), ROUND(latitude, 2)
ORDER BY crimes DESC;

CREATE MATERIALIZED VIEW mv_crime_by_category AS
SELECT 
crime_category,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE crime_category IS NOT NULL
GROUP BY crime_category
ORDER BY total_crimes DESC;

CREATE MATERIALIZED VIEW mv_crime_by_type AS
SELECT 
primary_type,
COUNT(*) AS total_crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE primary_type IS NOT NULL
GROUP BY primary_type
ORDER BY total_crimes DESC;

CREATE MATERIALIZED VIEW mv_crime_by_location AS
SELECT 
location_description,
crime_category,
COUNT(*) AS crimes
FROM crimes
WHERE location_description IS NOT NULL AND crime_category IS NOT NULL
GROUP BY location_description, crime_category
ORDER BY crimes DESC;

CREATE MATERIALIZED VIEW mv_domestic_vs_nondomestic AS
SELECT 
CASE
WHEN domestic = true THEN 'Domestic Violence'
WHEN domestic = false THEN 'Non-Domestic'
ELSE 'Unknown'
END AS crime_type,
crime_category,
COUNT(*) AS crimes,
COUNT(*) FILTER (WHERE arrest = true) AS arrests,
ROUND(COUNT(*) FILTER (WHERE arrest = true) * 100.0 / COUNT(*), 2) AS arrest_rate
FROM crimes
WHERE domestic IS NOT NULL
GROUP BY domestic, crime_category
ORDER BY arrest_rate DESC;
