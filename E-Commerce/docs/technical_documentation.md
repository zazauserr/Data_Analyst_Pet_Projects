# Technical Documentation

## System Architecture

### Data Flow Pipeline
```
Raw CSV Data → PostgreSQL → Analytical Views → Power BI Dashboard
```

### Technology Stack
- **Database**: PostgreSQL 12+
- **Analytics**: SQL (CTEs, Window Functions, Joins)
- **Visualization**: Power BI Desktop
- **Data Processing**: Python (Pandas, NumPy)

## Database Design

### Entity Relationship Diagram
```
customers (1) ----< orders (1) ----< order_items (M) >---- products (1)
```

### Table Schemas

#### customers
```sql
customer_id INTEGER PRIMARY KEY  -- Unique customer identifier
country VARCHAR(50)              -- Customer country
```

#### products  
```sql
stock_code VARCHAR(20) PRIMARY KEY  -- Product SKU
description TEXT                    -- Product name/description
```

#### orders
```sql
invoice_no VARCHAR(20) PRIMARY KEY  -- Order number
customer_id INTEGER                 -- FK to customers
invoice_date TIMESTAMP              -- Order timestamp
```

#### order_items
```sql
invoice_no VARCHAR(20)              -- FK to orders
stock_code VARCHAR(20)              -- FK to products  
quantity INTEGER                    -- Items ordered (negative = returns)
unit_price DECIMAL(10,2)            -- Price per unit
```

## Analytical Views Architecture

### Core Analytics (Page 1)
- **rfm_analysis**: Customer segmentation using Recency, Frequency, Monetary analysis
- **cohort_analysis**: Customer retention patterns by acquisition month
- **geographic_analysis**: Revenue and customer distribution by country
- **abc_analysis**: Product classification using Pareto principle

### Advanced Analytics (Page 2)
- **top_products_quantity**: Best-selling products by volume
- **top_products_revenue**: Highest revenue-generating products
- **customer_performance**: Customer metrics and lifetime value
- **monthly_sales_trends**: Time-series sales analysis
- **returns_analysis**: Product return patterns

## SQL Implementation Details

### RFM Analysis Algorithm
```sql
-- Step 1: Calculate base metrics
recency = CURRENT_DATE - MAX(invoice_date)
frequency = COUNT(DISTINCT invoice_no)
monetary = SUM(quantity * unit_price)

-- Step 2: Score assignment (1-5 scale)
R_Score: recency quartiles (lower = higher score)
F_Score: frequency quartiles (higher = higher score)  
M_Score: monetary quartiles (higher = higher score)

-- Step 3: Segment classification
IF R>=4 AND F>=4 AND M>=4 THEN 'Champions'
IF R>=4 AND F>=3 AND M>=3 THEN 'Loyal Customers'
-- ... additional rules
```

### Cohort Analysis Logic
```sql
-- Step 1: Identify first purchase month for each customer
first_purchase_month = MIN(TO_CHAR(invoice_date, 'YYYY-MM'))

-- Step 2: Calculate months since first purchase
months_since_first = AGE(current_month, first_purchase_month)

-- Step 3: Count unique customers per cohort/period
retention_rate = COUNT(DISTINCT customer_id) / cohort_size
```

## Power BI Implementation

### Data Model
- **Import Mode**: All data loaded into Power BI for performance
- **Relationships**: Auto-detected based on foreign keys
- **Calculated Columns**: Minimal use, logic in SQL views
- **Measures**: KPI calculations and aggregations

### Page 1: Strategic Dashboard
```
├── KPI Cards (customer count, revenue)
├── RFM Donut Chart (customer segments)  
├── Geographic Map (revenue by country)
├── Cohort Matrix (retention heatmap)
└── ABC Bar Chart (product tiers)
```

### Page 2: Operational Dashboard  
```
├── Product Performance Charts
├── Monthly Trend Lines
├── Customer Performance Table
├── Treemap (revenue by product)
└── Country Filter Slicer
```

### Filtering & Interactivity
- **Cross-filtering**: Enabled between all visuals
- **Drill-through**: Country → Customer details
- **Slicers**: Country, Date range, Customer segment
- **Bookmarks**: Saved views for different analysis modes

## Performance Optimization

### SQL Optimization
- **Indexes**: Created on customer_id, invoice_no, stock_code
- **Views**: Pre-calculated aggregations to reduce query time
- **Partitioning**: Date-based partitioning for large tables
- **Query Plans**: Analyzed and optimized for complex CTEs

### Power BI Optimization
- **Data Types**: Optimized for memory efficiency
- **Column Cardinality**: Reduced where possible
- **Aggregations**: Pre-calculated in SQL layer
- **Refresh Schedule**: Incremental refresh configured

## Data Quality Controls

### Validation Rules
```sql
-- Remove negative prices (data errors)
WHERE unit_price >= 0

-- Exclude invalid descriptions
WHERE description NOT LIKE '%damaged%'
AND description NOT LIKE '%manual%'
AND description != 'Unknown'

-- Handle missing customer IDs
COALESCE(customer_id, 'Guest')
```

### Data Cleaning Process
1. **Null Handling**: Missing CustomerID → 'Guest'
2. **Invalid Data**: Negative prices removed
3. **Duplicates**: DISTINCT clause in data loading
4. **Outliers**: Quantity > 80,995 flagged for review

## Security & Access

### Database Security
- **Roles**: Read-only access for Power BI service account
- **Connection**: SSL encryption enabled
- **Auditing**: Query logging for monitoring

### Power BI Security
- **Row-level Security**: By country (if needed)
- **Dataset Permissions**: Controlled access to sensitive data
- **Gateway**: On-premises data gateway for live connections

## Deployment Instructions

### Local Development Setup
```bash
# 1. Install PostgreSQL
# 2. Create database
createdb ecommerce_analytics

# 3. Run SQL scripts in order
psql -d ecommerce_analytics -f sql/01_schema_creation.sql
psql -d ecommerce_analytics -f sql/02_core_analytical_views.sql  
psql -d ecommerce_analytics -f sql/03_advanced_views.sql

# 4. Open Power BI file
# 5. Update data source connection
# 6. Refresh data
```

### Production Deployment
1. **Database**: Deploy to PostgreSQL server
2. **Scheduling**: Set up automated data refresh
3. **Power BI Service**: Publish dashboard to workspace
4. **Gateway**: Configure for live data connection
5. **Monitoring**: Set up alerts for data refresh failures

## Troubleshooting

### Common Issues
- **Connection Timeout**: Increase query timeout in Power BI
- **Memory Errors**: Optimize data model, reduce cardinality
- **Slow Performance**: Check SQL execution plans, add indexes
- **Data Refresh Failures**: Verify database connectivity and permissions

### Monitoring & Maintenance
- **Query Performance**: Monitor slow-running queries
- **Data Freshness**: Automated checks for data updates
- **Usage Analytics**: Track dashboard performance and usage
- **Backup Strategy**: Regular database backups and Power BI exports