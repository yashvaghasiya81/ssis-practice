# SSIS_CSV_Sales_Transformation_To_SQL

This project demonstrates a complete **ETL pipeline using SSIS** that loads multiple CSV sales files, applies data transformations, calculates  metrics, and appends the cleaned data into a SQL Server table.

The solution uses **Foreach Loop + Flat File Source + Data Conversion + Derived Column + OLE DB Destination** to create a scalable and automated data processing workflow.

---

## 🎯 Project Objective

Design and implement an SSIS package that:

* Reads multiple CSV sales files from a folder
* Iterates dynamically using Foreach Loop
* Converts string data into numeric types
* Calculates Total Sales Amount
* Appends all processed data into SQL Server
* Supports scalable loading for any number of files


## 📂 Folder Structure

```
ASS3\
│
└── data\
      sales_jan1.csv
      sales_jan2.csv
      sales_jan3.csv
```

---



### Notes

* quantity and price come as STRING in CSV
* Must convert to numeric before calculations
* All files share identical schema

---

## 🧩 Package Architecture

The SSIS package contains:

```
Control Flow
   ↓
Foreach Loop Container
   ↓
Data Flow Task
```

---

# 🔁 Control Flow Design

## 1️⃣ Foreach Loop Container

Purpose:
Iterates through all CSV files dynamically.

Configuration:

* Enumerator → Foreach File Enumerator
* Folder → ASS3\data
* Files → *.csv
* Retrieve → Fully Qualified
* Variable → User::FileName

Each iteration processes one CSV file.

---

## 2️⃣ Data Flow Task

Handles extraction, transformation, and loading.

Flow:

```
Flat File Source
      ↓
Data Conversion
      ↓
Derived Column
      ↓
OLE DB Destination
```

---

# 🔹 Data Flow Components

## 🟢 Flat File Source

Purpose:

* Reads CSV file dynamically

Configuration:

* Connection string uses expression:

```
@[User::FileName]
```

* Delimiter → Comma
* Header row enabled

---

## 🟡 Data Conversion Transformation

Purpose:

* Convert string columns to numeric types

Because CSV reads everything as string:

### Conversions

| Column   | From   | To               |
| -------- | ------ | ---------------- |
| quantity | DT_STR | DT_I4 (INT)      |
| price    | DT_STR | DT_NUMERIC/DT_R8 |

Output columns:

```
quantity_int
price_num
```

---

## 🔵 Derived Column Transformation

Purpose:

* Calculate total sales amount


### Expression

```
quantity_int * price_num
```

New column created:

```
TotalAmount
```

---

## 🔴 OLE DB Destination

Purpose:

* Load final transformed data into SQL Server

Configuration:

* Data access → Table or View – Fast Load
* Insert mode → Append

---

# 🗄 Destination Table Example

```sql
CREATE TABLE Sales_Data
(
    product_id INT,
    product_name NVARCHAR(255),
    quantity INT,
    price DECIMAL(10,2),
    TotalAmount DECIMAL(12,2)
);
```

---

# 🔄 Execution Flow

For each CSV file:

1. Foreach loop selects file
2. Flat File Source reads data
3. Data Conversion fixes datatypes
4. Derived Column calculates TotalAmount
5. Data appended into SQL table

Example:

```
sales_jan1 → Load
sales_jan2 → Load
sales_jan3 → Load
```

Final table contains combined data of all 3 files.

---

# ✅ Validation Queries

```sql
SELECT * FROM Sales_Data;

SELECT COUNT(*) FROM Sales_Data;

SELECT SUM(TotalAmount) FROM Sales_Data;
```



Yash Vaghasiya
SSIS Sales Data Transformation Project

