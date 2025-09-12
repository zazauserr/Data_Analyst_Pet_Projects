# Chicago Crimes SQL Analysis

## 📁 Clean Project Structure

```
sql/
├── 01_create_schema.sql     # ✅ Database schema and tables
├── 02_import_data.sql       # ✅ CSV import (corrected structure)  
├── 03_process_data.sql      # ✅ Data cleaning and processing
├── 03_analytical_queries.sql # 🔄 Analytics (TO BE COMPLETED)
└── README.md               # ✅ This documentation
```

## 🚀 Execution Order

### Step 1: Create Database Schema
```sql
\i 01_create_schema.sql
```
Creates `crimes` table with proper structure and `crimes_temp` for import.

### Step 2: Import CSV Data  
```sql
\i 02_import_data.sql
```
This creates `crimes_temp` table. Then manually import CSV via pgAdmin:
- Right-click `crimes_temp` → Import/Export Data
- Import your `chicago_crimes.csv` file
- Settings: Header=Yes, Delimiter=Comma

### Step 3: Process and Clean Data
```sql
\i 03_process_data.sql  
```
Transfers data from `crimes_temp` to `crimes` with cleaning and derived columns.

### Step 4: Run Analytics (Your Turn!)
```sql
\i 03_analytical_queries.sql
```
Complete the analytical queries for your Power BI dashboard.

## 📊 Expected Results

After successful execution:
- **crimes** table with ~400K cleaned records
- Derived columns: `season`, `time_of_day`, `crime_category`
- Proper indexes for fast querying
- Ready for Power BI connection

## 🎯 Next Steps

1. ✅ Complete database setup (Steps 1-3)
2. 🔄 Write analytical queries in `03_analytical_queries.sql`
3. 📊 Connect Power BI to PostgreSQL database
4. 📈 Build interactive dashboard

## 🔧 Database Connection for Power BI

```
Server: localhost (or your PostgreSQL server)
Database: chicago_crimes  
Table: crimes
Authentication: Your PostgreSQL credentials
```

**Ready to rock your SQL analytics!** 🚀