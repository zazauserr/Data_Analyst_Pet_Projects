# E-Commerce Sales Analytics Dashboard

## 📊 Project Overview

Comprehensive analytics project analyzing UK-based e-commerce sales data (2009-2011) to derive actionable business insights through advanced SQL analysis and interactive Power BI dashboards.

**Key Focus Areas:**
- Customer segmentation (RFM analysis)
- Product performance optimization
- Geographic market analysis
- Customer retention analysis
- Returns pattern identification

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **PostgreSQL** | Data storage & advanced analytics |
| **Python (Pandas, NumPy, Matplotlib)** | Data preprocessing & exploration |
| **Power BI** | Interactive dashboard creation |
| **Tableau** | Interactive dashboard creation |
| **SQL** | Complex analytical queries (CTEs, Window Functions) |

## 📈 Dashboard Overview

### Page 1: Strategic Analytics
![Strategic Dashboard](powerbi/screenshots/page1_strategic.png)

**Key Metrics:**
- **4,338** unique customers analyzed
- **£8.89M** total revenue
- **13 months** of operational data

**Visualizations:**
- **RFM Customer Segmentation** - Champions (22.85%), New Customers (22.73%)
- **Cohort Retention Analysis** - Customer lifecycle patterns
- **Geographic Revenue Map** - UK dominance with international expansion opportunities
- **ABC Product Classification** - Pareto analysis of product performance

### Page 2: Operational Analytics
![Operational Dashboard](powerbi/screenshots/page2_operational.png)

**Features:**
- **Top Products Analysis** - Best performers by volume and revenue
- **Monthly Sales Trends** - Seasonal patterns identification
- **Customer Performance Matrix** - VIP customer identification
- **Interactive Country Filter** - Dynamic geographic analysis

## 🔍 Key Business Insights

### Customer Segmentation (RFM Analysis)
- **Champions (22.85%)**: High-value customers requiring retention focus
- **New Customers (22.73%)**: Significant onboarding opportunity
- **At Risk (3.19%)**: Immediate intervention needed

### Geographic Distribution
- **UK**: 92% of total revenue (£8.2M)
- **International Markets**: 8% with growth potential
- **Top International**: Netherlands (£284K), EIRE (£263K)

### Product Performance
- **Top Revenue Generator**: PAPER CRAFT, LITTLE BIRDIE
- **ABC Classification**: 80/20 rule confirmed - 20% products drive 80% revenue
- **Return Rate Analysis**: Quality improvement opportunities identified

### Retention Patterns
- **Month 0**: 100% baseline
- **Month 1**: 37% retention (industry benchmark comparison needed)
- **Month 3**: 19% retention (customer lifecycle optimization required)

## 🗃️ Database Schema

```sql
customers (4,338 records)
├── customer_id (PK)
└── country

products (3,684 records)
├── stock_code (PK)
└── description

orders (18,536 records)
├── invoice_no (PK)
├── customer_id (FK)
└── invoice_date

order_items (397,884 records)
├── invoice_no (FK)
├── stock_code (FK)
├── quantity
└── unit_price
```

## 📁 Project Structure

```
├── sql/
│   ├── 01_schema_creation.sql     # Database setup
│   ├── 02_analytical_views.sql    # Core analytics (RFM, Cohort, Geographic)
│   └── 03_advanced_views.sql      # Extended analytics for Power BI
├── notebooks/
│   └── ecommerce_analysis.ipynb   # Python EDA & preprocessing
├── powerbi/
│   ├── ecommerce_dashboard.pbix   # Interactive dashboard
│   └── screenshots/               # Dashboard images
└── docs/
    └── database_schema.pdf        # ERD diagram
```

## 🚀 How to Run

### Prerequisites
- PostgreSQL 12+
- Power BI Desktop
- Python 3.8+ (for notebook analysis)

### Setup Instructions

1. **Database Setup**
```bash
# Create database
createdb ecommerce_analytics

# Run schema creation
psql -d ecommerce_analytics -f sql/01_schema_creation.sql

# Create analytical views
psql -d ecommerce_analytics -f sql/02_analytical_views.sql
psql -d ecommerce_analytics -f sql/03_advanced_views.sql
```

2. **Power BI Dashboard**
```
1. Open powerbi/ecommerce_dashboard.pbix
2. Update data source connection to your PostgreSQL instance
3. Refresh data
```

3. **Python Analysis**
```bash
pip install pandas numpy matplotlib seaborn
jupyter notebook notebooks/ecommerce_analysis.ipynb
```

## 📊 Advanced Analytics Implemented

### SQL Techniques Used
- **Complex CTEs** for multi-step analysis
- **Window Functions** for ranking and percentiles
- **Date Functions** for cohort analysis
- **Case Statements** for customer segmentation
- **Aggregate Functions** with conditional logic

### Python Analysis Features
- **Data Quality Assessment** - Missing values, outliers, duplicates
- **Statistical Analysis** - Correlation analysis, distribution analysis
- **Returns Analysis** - Product return patterns and reasons
- **Customer Behavior** - Purchase patterns and frequency analysis

## 💡 Business Recommendations

1. **Customer Retention**: Implement re-engagement campaigns for "At Risk" segment (3.19%)
2. **Geographic Expansion**: Develop targeted strategies for Netherlands and EIRE markets
3. **Product Optimization**: Focus inventory management on A-tier products (80% revenue)
4. **Quality Improvement**: Address high-return products to reduce operational costs

## 🎯 Project Outcomes

- **Actionable Insights**: 15+ specific business recommendations
- **Performance Metrics**: Complete KPI dashboard for executive reporting
- **Scalable Solution**: Automated refresh capability for ongoing analysis
- **Technical Skills**: Advanced SQL, Power BI, and Python proficiency demonstrated

## 📧 Contact

**Bogdan Kudelia** - zazauserr@gmail.com  
**LinkedIn** - [https://www.linkedin.com/in/bohdan-kudelia/](https://www.linkedin.com/in/bohdan-kudelia/)  
**GitHub** - [github.com/zazauserr](github.com/zazauserr)

---
*This project demonstrates end-to-end data analytics capabilities including data modeling, advanced SQL analytics, and business intelligence dashboard creation.*
