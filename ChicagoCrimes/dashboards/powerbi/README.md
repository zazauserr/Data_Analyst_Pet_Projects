# Power BI Dashboard

## Files
- `chicago_crimes.pbix` - Interactive dashboard (requires Power BI Desktop)
- `chicago_crimes.pdf` - Static export for viewing

## Dashboard Structure

### Page 1: Executive Overview
- Total crimes: 31,340
- Overall arrest rate: 17.98%
- Crime categories breakdown (donut chart)
- District analysis (bar chart)
- Temporal trend (line chart)

### Page 2: Geographic Hotspots  
- Crime heat map (latitude/longitude coordinates)
- Location type analysis (bar chart)
- Geographic KPIs (4 cards)
- Interactive filtering by crime category

### Page 3: Temporal Patterns
- Hourly crime distribution (line chart)
- Daily trends with 7-day rolling average
- Monthly comparison (Jan vs Feb 2025)
- Temporal KPIs (4 cards)

## Data Sources
- PostgreSQL views (v_crime_*)
- Optimized for performance with pre-aggregated data
- Real-time connection to database

## Requirements
- Power BI Desktop
- PostgreSQL ODBC driver
- Access to chicago_crimes database

## Setup
1. Install Power BI Desktop
2. Open chicago_crimes.pbix
3. Refresh data connection if needed
4. Configure PostgreSQL connection: localhost/chicago_crimes