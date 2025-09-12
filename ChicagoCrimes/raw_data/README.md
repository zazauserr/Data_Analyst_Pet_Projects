# Raw Data

## File
`chicago_crimes.csv` - Source dataset for analysis

## Dataset Details
- **Records**: 31,340 crime incidents
- **Time Period**: January-February 2025  
- **Location**: Chicago, IL
- **File Size**: ~7.6 MB
- **Format**: Comma-separated values (CSV)

## Columns
- **ID**: Unique crime identifier
- **Case Number**: Police case reference
- **Date**: Incident timestamp  
- **Block**: Approximate street address
- **IUCR**: Illinois Uniform Crime Reporting code
- **Primary Type**: Main crime category
- **Description**: Detailed crime description
- **Location Description**: Type of location
- **Arrest**: Boolean - was arrest made
- **Domestic**: Boolean - domestic incident flag
- **Beat/District/Ward**: Administrative divisions
- **Community Area**: Neighborhood identifier
- **FBI Code**: Federal crime classification
- **Coordinates**: X/Y and Lat/Long positions
- **Year**: Incident year
- **Updated On**: Record last modified

## Data Quality
- Cleaned and validated coordinates
- Standardized date formats
- Complete geographic coverage
- Minimal missing values

## Usage
Import into PostgreSQL using provided SQL scripts or analyze directly with Python/pandas.

## Source
Chicago Police Department crime data portal