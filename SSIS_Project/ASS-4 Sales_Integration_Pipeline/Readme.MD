# 🛒 Retail Sales Integration & Data Quality Pipeline

---

## 🎯 Project Overview

This project implements a comprehensive **ETL (Extract, Transform, Load)** pipeline that processes daily retail sales data from multiple regional systems, performs intelligent data quality validation using fuzzy matching algorithms, and produces clean, aggregated data ready for business intelligence and reporting.

---

## 🌟 Key Highlights

- ✅ **Automated Data Quality** - Fuzzy customer name matching with 80% similarity threshold
- ✅ **Star Schema Design** - Professional data warehouse dimensional modeling
- ✅ **Error Handling** - Complete rejection tracking 
- ✅ **Scalable Architecture** - Modular SSIS packages for maintainability

---

## 💼 Business Problem

### Current State:

- 📂 Multiple regional stores submit daily sales CSV files (East & West regions)
- ❌ Customer names have inconsistencies ("John Smith" vs "Jon Smyth")
- ❌ Product codes need validation
- ❌ No centralized, clean data
- ❌ No audit trail

### Solution Delivered:

- ✅ Clean, validated sales data
- ✅ Standardized customer names
- ✅ Enriched dimensional context
- ✅ Automated daily aggregations
- ✅ Complete rejection tracking

---

## 🏗️ Solution Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   SOURCE: CSV FILES                         │
│      Regional Sales (East.csv, West.csv) by Date           │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│           DIMENSION BUILDING LAYER                          │
│   ┌──────────────┐              ┌──────────────┐          │
│   │ Fuzzy        │              │ Product      │          │
│   │ Grouping     │              │ Extraction   │          │
│   └──────┬───────┘              └──────┬───────┘          │
│          │                              │                  │
│          ▼                              ▼                  │
│   ┌──────────────┐              ┌──────────────┐          │
│   │ Dim_Customer │              │ Dim_Product  │          │
│   └──────────────┘              └──────────────┘          │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              VALIDATION & ENRICHMENT                        │
│  • Fuzzy Customer Matching (≥80%)                          │
│  • Product Code Validation                                  │
│  • Data Quality Rules                                       │
└───────────────────┬─────────────────────────────────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
         ▼                     ▼
┌─────────────┐        ┌──────────────┐
│ Fact_Sales  │        │ Sales        │
│ _Clean      │        │ _Rejected    │
└──────┬──────┘        └──────────────┘
       │
       ▼
┌──────────────┐
│ Sales_Daily  │
│ _Summary     │
└──────────────┘
```

---

## ✨ Key Features

### 1. 🤖 Intelligent Data Quality

**Fuzzy Customer Matching**

- Handles typos: "John Smit" → "John Smith" (92% match)
- Format variations: "Smith, John" → "John Smith"
- 80% similarity threshold
- Preserves original + canonical names

### 2. ✔️ Data Validation

- Product code validation
- Customer ID assignment
- Foreign key enforcement
- Region extraction from Order IDs

### 3. 📊 Error Tracking

- Detailed rejection reasons
- Match confidence scores
- Source file tracking

### 4. 🗄️ Dimensional Model

- Star schema design
- Surrogate keys
- Optimized indexes
- SCD-ready structure

### 5. 📈 Automated Aggregations

- Daily summaries by Date/Region/Product
- Pre-calculated metrics
- Fast query performance

---

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **ETL Tool** | SQL Server Integration Services (SSIS) 2016+ |
| **Database** | Microsoft SQL Server 2016+ |
| **IDE** | Visual Studio / SQL Server Data Tools |
| **Language** | T-SQL, SSIS Expression Language |

### Key SSIS Components:

- Fuzzy Grouping Transformation
- Lookup Transformation
- Conditional Split
- Aggregate Transformation
- Derived Column
- OLE DB Source/Destination

---

## 📊 Database Schema

### Tables Created:

**Dimensions:**
- `Dim_Customer_master_table` - Customer master data
- `Dim_Product_master_table` - Product catalog

**Facts:**
- `Fact_Sales_Clean` - Validated sales (17 columns)
- `Sales_Rejected` - Rejected records (16 columns)
- `Sales_Daily_Summary` - Aggregations (12 columns)

**Supporting:**
- `fuzzy_grouping` - Customer matching results

### Entity Relationship:

```
Dim_Customer ──┐
               ├──> Fact_Sales_Clean ──> Sales_Daily_Summary
Dim_Product ───┘
```

### Execution Order:

1. **CustomerDimension** - Builds Dim_Customer via fuzzy grouping
2. **ProductDimension** - Builds Dim_Product from sales data
3. **MainETL** - Validates & loads Fact_Sales_Clean + Sales_Rejected
4. **Summary** - Creates Sales_Daily_Summary aggregations

---

## 🔄 Data Flow

### Customer Dimension Pipeline:

```
CSV → Fuzzy Grouping (80%) → fuzzy_grouping table → 
Extract canonical names → Lookup OrderId → 
Derive Region → Dim_Customer
```

### Main ETL Pipeline:

```
CSV → Lookup fuzzy_grouping (_score) → 
Lookup Dim_Customer (CustomerId) → 
Lookup Dim_Product (ProductId) → 
Conditional Split (Valid/Invalid) →
├─> Valid: Fact_Sales_Clean
└─> Invalid: Sales_Rejected
```

### Summary Pipeline:

```
Fact_Sales_Clean → Aggregate (Group by Date/Region/Product) → 
Sales_Daily_Summary
```

---

## 📈 Results

### Sample Input (CSV):

```csv
OrderId,OrderDate,CustomerName,ProductCode,Quantity,Amount
E1001,2026-02-10,John Smith,P1001,2,200
E1002,2026-02-10,Jon Smyth,P1001,1,100
```

### Sample Output (Fact_Sales_Clean):

| OrderId | CustomerId | ProductId | OriginalName | CanonicalName | MatchScore |
|---------|-----------|-----------|--------------|---------------|-----------|
| E1001 | 1 | 0 | John Smith | John Smith | 1.00 |
| E1002 | 1 | 0 | Jon Smyth | John Smith | 0.92 |

### Sample Aggregation (Sales_Daily_Summary):

| SalesDate | Region | ProductId | TotalQty | TotalAmt | RecordCount |
|-----------|--------|-----------|----------|----------|-------------|
| 2026-02-10 | E | 0 | 3 | 300 | 2 |

---

## 🎓 Learning Outcomes

This project demonstrates:

- ✅ **SSIS Development** - Complex data flows, transformations
- ✅ **Fuzzy Matching** - Intelligent data quality algorithms
- ✅ **Dimensional Modeling** - Star schema, surrogate keys
- ✅ **Data Validation** - Multi-level quality checks
- ✅ **T-SQL** - Advanced queries, procedures
- ✅ **Error Handling** - Comprehensive rejection tracking
- ✅ **ETL Best Practices** - Modular design, logging, auditing

---

## 🔮 Future Enhancements

- [ ] Slowly Changing Dimensions (SCD Type 2)
- [ ] Incremental loading
- [ ] Power BI dashboards
- [ ] Email notifications
- [ ] Cloud migration (Azure Data Factory)
- [ ] Real-time streaming
- [ ] Machine learning integration

---

## 📁 Project Structure

```
ASS-4_Sales-pipeline/
├── SSIS_Packages/
│   ├── Load_data.dtsx
│   ├── CustomerDimension.dtsx
│   ├── ProductDimension.dtsx
│   ├── Transform.dtsx
│   └── Summary.dtsx
├── Data/
│   ├── 2026-02-10/
│   │   ├── East.csv
│   │   └── West.csv
│   ├── 2026-02-11/
│   │   ├── East.csv
│   │   └── West.csv
│   ├── 2026-02-12/
│   │   ├── East.csv
│   │   └── West.csv
└── README.md
```

---

## 👤 Author

**Yash Vaghasiya**

---


