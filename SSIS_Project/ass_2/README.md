
# SSIS_Multi_Excel_To_SQL_Server

This project demonstrates an end-to-end **SSIS ETL pipeline** that loads multiple Excel files into a SQL Server destination table using a dynamic and scalable architecture.

The package automatically detects Excel files from a folder, iterates through each file using a **Foreach Loop Container**, and appends all records into a single SQL Server table.

---

## 🎯 Project Objective

Design and implement an SSIS package that:

* Reads **multiple Excel (.xlsx) files** from a source directory
* Dynamically assigns file paths at runtime
* Iterates through each file using **Foreach File Enumerator**
* Extracts data from a common sheet name
* Loads data into a **single SQL Server table**
* Supports reusable and scalable ETL execution

---


---

## 📂 Source Files

Three Excel files placed inside one folder:

```
File1.xlsx
File2.xlsx
File3.xlsx
```

### Notes

* All files must have **same sheet name** (Example: `Sheet1`)
* Schema must be identical across all files


---

## 🧩 Package Architecture

The solution uses **Control Flow + Data Flow** design.

---

## 🔁 Control Flow Design

### 1️⃣ Foreach Loop Container

Purpose:
Iterates through all Excel files in the source directory.

Configuration:

* Enumerator → Foreach File Enumerator
* Folder → Source Excel folder path
* Files → *.xlsx
* Retrieve → Fully Qualified
* Variable → `User::FileName`

This variable stores the current Excel file path dynamically.

---

### 2️⃣ Data Flow Task

Executes the ETL process for each Excel file detected by the loop.

Flow:

```
Excel Source → OLE DB Destination
```

---

## 🔹 Data Flow Components

### Excel Source

Purpose:

* Reads data from Excel sheet

Configuration:

* Sheet name must be same for all files (DATA$)
* Connection Manager uses dynamic path from variable

---

### OLE DB Destination

Purpose:

* Loads records into SQL Server table

Configuration:

* Data access mode → Table or View – Fast Load
* Insert mode → Append
* Column mappings configured

---

## 🧠 Dynamic Configuration

### Excel Connection Manager (Important)

The Excel file path is assigned dynamically using an expression:

```
@[User::FileName]
```

This allows SSIS to automatically switch files during each loop iteration.

---

## 🗄 Destination Table Example

```sql
CREATE TABLE dbo.Employees
(
    id INT,
    emp_name NVARCHAR(255),
    department NVARCHAR(255),
    city NVARCHAR(255)
);
```

Note:

* NVARCHAR is recommended because Excel outputs Unicode data.

---

## 🚀 Execution Flow

For each Excel file:

1. Foreach loop selects file
2. Excel Source reads sheet data
3. Data loaded into SQL Server
4. Repeat for next file

Example:

```
Data1 → Load rows
Data2 → Load rows
Data3 → Load rows
```

All rows are appended into one table.

---

## ✅ Validation Queries

```sql
SELECT * FROM Employees;

SELECT COUNT(*) FROM Employees;
```




Yash Vaghasiya
SSIS ETL Practice Project
