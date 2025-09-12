# Chicago Crimes Analysis

## Status: Complete

**End-to-end crime data analysis using Python, SQL, and Power BI**

## Technologies
- **Python**: Pandas, NumPy, Matplotlib, Folium
- **SQL**: PostgreSQL with advanced analytics 
- **BI**: Power BI multi-page dashboard
- **Database**: 31,340 crime records (Jan-Feb 2025)

## Project Structure
```
├── raw_data/chicago_crimes.csv          # Source dataset
├── analysis(Python)/                    # Jupyter notebook EDA
├── sql/                                 # Database scripts & queries
├── dashboards/powerbi/                  # Interactive dashboard
└── dashboards/tableau/                  # Static visualizations
```

## Key Findings
- **Property Crime**: 37% of all incidents (theft, burglary)
- **Violent Crime**: 26.6% (battery, assault)
- **Arrest Rate**: 18% overall, 95% for drug crimes
- **Geographic Hotspots**: Downtown Chicago (41.88, -87.63)
- **Temporal Patterns**: Peak activity 12-18:00

## SQL Analytics
- 7 analytical sections covering temporal, geographic, and crime type analysis
- Window functions for rolling averages and rankings
- Materialized views for Power BI optimization
- Advanced queries with CTEs and statistical functions

## Power BI Dashboard
**3 Interactive Pages:**
- **Executive Overview**: KPIs, crime categories, district analysis
- **Geographic Hotspots**: Heat maps, coordinate analysis, location types  
- **Temporal Patterns**: Hourly trends, daily patterns, seasonal analysis

## Database Schema
```sql
-- Main table: crimes (31,340 records)
-- Derived fields: season, time_of_day, crime_category
-- Indexes: date, type, district, coordinates
-- Views: v_crime_by_* for dashboard optimization
```

## Business Impact
- Resource allocation recommendations for police districts
- Identification of high-risk locations and time periods
- Data-driven insights for crime prevention strategies
- Performance metrics for police effectiveness evaluation

## Files
- `chicago_crimes.pbix` - Interactive Power BI dashboard
- `chicago_crimes.pdf` - Dashboard export
- `01_create_schema.sql` - Database setup
- `02_import_data.sql` - Data cleaning & import
- `03_analytical_queries.sql` - Advanced analytics
- `chicago_crimes_analysis.ipynb` - Python EDA

## Setup
1. Import CSV to PostgreSQL using provided scripts
2. Run analytical queries for data exploration
3. Open Power BI file for interactive analysis

**Portfolio Project - Data Analyst Skills Demonstration**